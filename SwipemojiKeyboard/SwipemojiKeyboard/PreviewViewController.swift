//
//  PreviewViewController.swift
//  SwipemojiKeyboard
//
//  Created by Takashi Wickes on 2/21/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var _library = PointCloudLibrary.getDemoLibrary()
    var isEmojiCollection = true
    var popUpIndex : Int?
    var pinkColor = UIColor(red:1.00, green:0.29, blue:0.42, alpha:1.0)
    
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popBlackBack: UIView!
    @IBOutlet weak var popGestureView: UIView!
    @IBOutlet weak var popEmojiLabel: UILabel!
    @IBOutlet weak var popCountLabel: UILabel!
    
    @IBOutlet weak var popEditButton: UIView!
    @IBOutlet weak var popDeleteButton: UIView!
    @IBOutlet weak var viewOptionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.popBlackBack.alpha = 0
        self.popUpView.center.y = 1000

        self.popUpView.layer.cornerRadius = 8
        self.popUpView.dropShadow(color: UIColor.black, offSet: 4)
        self.popEditButton.layer.cornerRadius = 20
        self.popEditButton.dropShadow(color: UIColor(red:0.41, green:0.69, blue:1.00, alpha:1.0), offSet: 2)
        self.popDeleteButton.layer.cornerRadius = 20
        self.popDeleteButton.dropShadow(color: UIColor(red:1.00, green:0.29, blue:0.42, alpha:1.0), offSet: 2)
        self.popDeleteButton.backgroundColor = UIColor(red:1.00, green:0.29, blue:0.42, alpha:1.0)
        
        self.addButton.layer.cornerRadius = 30
        self.addButton.dropShadow(color: UIColor(red:0.41, green:0.69, blue:1.00, alpha:1.0), offSet: 4)
        self.bottomView.layer.cornerRadius = 8
        self.bottomView.dropShadow(color: UIColor.black, offSet: -4)
        self.topView.layer.backgroundColor = UIColor(red:1.00, green:0.29, blue:0.42, alpha:1.0).cgColor
        self.topView.dropShadow(color: UIColor(red:1.00, green:0.29, blue:0.42, alpha:1.0), offSet: 4)
        
        self.collectionView.alwaysBounceVertical = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.popBlackBack.alpha = 0
        self.popBlackBack.bounds = UIScreen.main.bounds
        self.popUpView.center.y = 1000
        _library = PointCloudLibrary.getDemoLibrary()
        self.collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewOptionChanged(_ sender: Any) {
        self.collectionView.reloadData()
    }
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _library.pointClouds.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as! emojiCollectionViewCell
        cell.emojiLabel.text = _library.pointClouds[indexPath.item].name

        cell.emojiDrawingCanvas = PointDisplayCanvas(frame: cell.gestureView.bounds)
        cell.emojiDrawingCanvas?.setBackgroundColor(color: UIColor.white)
        cell.emojiDrawingCanvas?.drawPointCloud(drawingPoints: _library.pointClouds[indexPath.item]._points)
        cell.gestureView.addSubview(cell.emojiDrawingCanvas!)
    


 
        
        if(viewOptionSegmentedControl.selectedSegmentIndex == 0){
            cell.gestureView.isHidden = true
            cell.emojiLabel.isHidden = false
        } else {
            cell.gestureView.isHidden = false
            cell.emojiLabel.isHidden = true
        }
        
        cell.layer.cornerRadius = 8
        cell.dropShadow(color: UIColor.black, offSet: 2)
        cell.layer.masksToBounds = true

        return cell
    }
    
    // MARK: - Pop Up
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
        presentPop()
        
        let drawingCanvas = PointDisplayCanvas(frame: popGestureView.bounds)
        drawingCanvas.setBackgroundColor(color: UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0))
        drawingCanvas.drawPointCloud(drawingPoints: _library.pointClouds[indexPath.item]._points)
        drawingCanvas.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popGestureView.addSubview(drawingCanvas)
        popEmojiLabel.text = _library.pointClouds[indexPath.item].name
        popCountLabel.text = String(_library.pointClouds[indexPath.item].count)
        
        popUpIndex = indexPath.item
    }
    
    @IBAction func popBackPressed(_ sender: Any) {
        dismissPop()
    }
    
    func presentPop(){
        UIView.animate(withDuration: 0.5) {
            self.popBlackBack.alpha = 0.5
            self.popUpView.center.y = 340
        }
    }
    
    func dismissPop(){
        UIView.animate(withDuration: 0.5) {
            self.popBlackBack.alpha = 0
            self.popUpView.center.y = 1000
        }
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        deleteEmoji(indexRow: self.popUpIndex!)
        dismissPop()
        self.collectionView.reloadData()
    }
    
    func deleteEmoji(indexRow : Int){
        let defaults = UserDefaults.init(suiteName: "group.swipemoji.appgroup")
        if let dicArray = defaults!.array(forKey: "gestures") as? [NSMutableDictionary] {
            var dicArrayStore = dicArray
            var i = 0
            dicArrayStore.forEach { dic in
                print(dic)
                if dic[popEmojiLabel.text! as String] != nil {
                    // the key exists in the dictionary
                    dicArrayStore.remove(at: i)
                }
                i += 1
            }
            //dicArrayStore.remove(at: indexRow)
            defaults!.set(dicArrayStore, forKey: "gestures")
        }
        _library = PointCloudLibrary.getDemoLibrary()
    }
    
    @IBAction func editEmoji(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "GestureMatch") as! GestureMatchController
        //            vc.initialText = self.popEmojiLabel.text
        vc.selectedEmoji = self.popEmojiLabel.text
        present(vc, animated: true, completion: nil)

    }

    
//     MARK: - Navigation

//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         Get the new view controller using segue.destinationViewController.
//         Pass the selected object to the new view controller.
        
        if(segue.identifier == "editSegue"){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "GestureMatch") as! GestureMatchController
            //            vc.initialText = self.popEmojiLabel.text
            vc.selectedEmoji = self.popEmojiLabel.text

        }
    }
}

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadow(color: UIColor, offSet: Int){
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = CGSize(width: 0, height: offSet)
        self.layer.shadowRadius = 4
        
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: self.layer.cornerRadius, height: self.layer.cornerRadius)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func dropShadow(color: UIColor, offSet: Int, cornerRadius: Int){
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = CGSize(width: 0, height: offSet)
        self.layer.shadowRadius = 4
        
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 50, height: 50)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
