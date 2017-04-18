
//
//  KeyboardViewController.swift
//  Swipemoji
//
//  Created by Takashi Wickes on 2/8/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet var keyboardView: UIView!
    @IBOutlet weak var drawingArea: UIView!

    @IBOutlet weak var suggestionView: UIView!
    var lastPoint = CGPoint.zero
    var drawingCanvas:PointDrawingCanvas?
    var _library = PointCloudLibrary.getDemoLibrary()
    var suggestions : [String]?
    var newCharacter : Bool = true
    var lastInput : String = ""

    let cellId = "suggestionCell"
    
    //MARK: - Initialization

    override func updateViewConstraints() {
        super.updateViewConstraints()

        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardViewController.strokeEnded), name: NSNotification.Name(rawValue: "reload"), object: nil)
        loadInterface();
        keyboardView.backgroundColor = UIColor(red:0.82, green:0.84, blue:0.86, alpha:1.0)
        self.populateSuggestions(pointCloud: nil)
    }
    
    func populateSuggestions(pointCloud : PointCloud?){
        if(pointCloud == nil){
            self.suggestions = Array(_library.pointClouds.prefix(10)).map({$0.name})
            return
        }
        self.suggestions = _library.recognizeoptionsFromLibrary(pointCloud!)
    }
    
    func reset(){
        self.newCharacter = true
        drawingCanvas?.clearCanvas()
        self.populateSuggestions(pointCloud: nil)
        collectionView.reloadData()
    }
    
    func loadInterface() {
        let keyboardNib = UINib(nibName: "Swipemoji", bundle: nil)
        keyboardView = keyboardNib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.addSubview(keyboardView)
        view.backgroundColor = keyboardView.backgroundColor
        createNextKeyboardButton()
        createSuggestionView()
        createDrawingCanvas()
    }
    
    func createNextKeyboardButton(){
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        self.view.addSubview(self.nextKeyboardButton)
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func createDrawingCanvas(){
        drawingCanvas = PointDrawingCanvas(frame: drawingArea!.bounds)
        drawingCanvas!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        drawingCanvas?.backgroundColor = UIColor.white
        drawingArea!.addSubview(drawingCanvas!)
        drawingArea.backgroundColor = UIColor.white
    }
    
    func createSuggestionGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.suggestionView.bounds
        gradientLayer.colors = [UIColor(red:0.95, green:0.95, blue:0.95, alpha:1).cgColor, UIColor(red:0.95, green:0.95, blue:0.95, alpha:0).cgColor]
        gradientLayer.locations = [0.2, 1]
        suggestionView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func submitCount(submittedString: String){
        
    }
    
    //MARK: - SuggestionView

    func createSuggestionView(){
        createSuggestionGradient()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SuggestionCollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _library.pointClouds.count > 10 ? 10 : _library.pointClouds.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! SuggestionCollectionViewCell
        cell.label.text = suggestions?[indexPath.item]
        var border = CALayer()
        border.backgroundColor = UIColor.lightGray.cgColor;
        border.opacity = 0.5
        border.frame = CGRect(x: 0, y: 0, width: 0.7, height: cell.frame.height - 10)
        cell.layer.addSublayer(border)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let input = suggestions?[indexPath.item]
        PointCloudLibrary.updateGestureDefault(input: input!)
        self.updateProxyText(text: input!)
        self.reset()
    }
    
    //MARK: - While Drawing

    func strokeEnded() {
        if let canvas = drawingCanvas {
            if !canvas.isEmpty() {
                DispatchQueue.global(qos: .userInitiated).async { // 1
                    let pointCloud = PointCloud("input gesture", canvas.points)
                    let matchResult = self._library.recognizeFromLibrary(pointCloud)
                    self.populateSuggestions(pointCloud: pointCloud)

                    DispatchQueue.main.async { // 2
                        self.collectionView.reloadData()
                    }
                    self.updateProxyText(text: matchResult.name)
                }
            }
        }
    }
    
    func updateProxyText(text: String){
        let proxy = self.textDocumentProxy as UITextDocumentProxy
        
        if let input = text as String? {
            if(self.newCharacter){
                proxy.insertText(input)
                self.newCharacter = false
                self.lastInput = input
            } else {
                proxy.deleteBackward()
                proxy.insertText(input)
                self.lastInput = input
            }
        }
    }

    //MARK:- Button Functions

    @IBAction func clearButtonPressed(_ sender: Any) {
        self.reset()
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        if let canvas = drawingCanvas {
            if !canvas.isEmpty() {
                PointCloudLibrary.updateGestureDefault(input: (suggestions?[0])!)
                drawingCanvas?.clearCanvas()
                newCharacter = true
            } else {
//                self.label!.text = "No match result."
            }
        }
    }

    @IBAction func backspacePressed(_ sender: Any) {
        let proxy = textDocumentProxy as UITextDocumentProxy
        proxy.deleteBackward()
        self.reset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }


    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.

        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

}
