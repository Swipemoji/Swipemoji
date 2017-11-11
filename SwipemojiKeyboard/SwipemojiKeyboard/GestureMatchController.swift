//
//  GestureMatchController.swift
//  SwipemojiKeyboard
//
//  Created by Shakeeb Majid on 2/17/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit
import CoreData

class GestureMatchController: UIViewController {

    var initialText : String?
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var canvas: UIView!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var emojiView: UIView!
    @IBOutlet weak var emojiLabel: UILabel!
    
    var selectedEmoji: String?
    
    var lastPoint = CGPoint.zero
    
    var drawingCanvas:PointDrawingCanvas?
    
    var _library = PointCloudLibrary.getDemoLibrary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emojiLabel.text = selectedEmoji
        emojiView.layer.cornerRadius = 50
        emojiView.dropShadow(color: UIColor.black, offSet: 4)
        
        closeButton.layer.cornerRadius = 22
        closeButton.dropShadow(color: UIColor(red:1.00, green:0.29, blue:0.42, alpha:1.0), offSet: 4)
        
        submitButton.layer.cornerRadius = 30
        submitButton.dropShadow(color: UIColor(red:1.00, green:0.29, blue:0.42, alpha:1.0), offSet: 4)
        
        canvas.layer.cornerRadius = 8
        canvas.dropShadow(color: UIColor.black, offSet: 4)
    
        
        drawingCanvas = PointDrawingCanvas(frame: canvas.bounds)
        drawingCanvas!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        canvas.addSubview(drawingCanvas!)
        
        let clearButton = UIButton(frame: CGRect(x: canvas.bounds.width - 65, y: canvas.frame.origin.y + 5, width: 100, height: 30))
    
        clearButton.setTitle("clear", for: .normal)
        clearButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        clearButton.tag = 1
        clearButton.setTitleColor(UIColor.darkGray, for: .normal)
        clearButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 18)
        clearButton.titleLabel?.textAlignment = .right

        self.view.addSubview(clearButton)
        
        // Do any additional setup after loading the view.
    }
    
    func buttonPressed(sender: UIButton!){
        if(sender.tag == 1){
            drawingCanvas?.clearCanvas()
        }
    }

    @IBAction func clearPressed(_ sender: Any) {
        drawingCanvas?.clearCanvas()
    }
    
    @IBAction func closePressed(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
        
    @IBAction func submitGesture(_ sender: Any) {
        if let canvas = drawingCanvas {
            if !canvas.isEmpty() {
                PointCloudLibrary.submitGesture(input: selectedEmoji!, inputPoints: canvas.points)
            } else {
                //self.emojiText.text = "No match result."
            }
        }
        self.dismiss(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
