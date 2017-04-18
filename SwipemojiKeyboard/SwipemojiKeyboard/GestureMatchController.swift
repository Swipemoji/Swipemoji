//
//  GestureMatchController.swift
//  SwipemojiKeyboard
//
//  Created by Shakeeb Majid on 2/17/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit

class GestureMatchController: UIViewController {

    var initialText : String?
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var emojiText: UITextField!
    
    @IBOutlet weak var canvas: UIView!
    
    
    var lastPoint = CGPoint.zero
    
    var drawingCanvas:PointDrawingCanvas?
    
    var _library = PointCloudLibrary.getDemoLibrary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 10
        emojiText.text = initialText
        drawingCanvas = PointDrawingCanvas(frame: canvas.bounds)
        drawingCanvas!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        canvas.addSubview(drawingCanvas!)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func clearPressed(_ sender: Any) {
        drawingCanvas?.clearCanvas()
    }
    
    @IBAction func submitGesture(_ sender: Any) {
        if let canvas = drawingCanvas {
            if !canvas.isEmpty() {
                PointCloudLibrary.submitGesture(input: emojiText.text!, inputPoints: canvas.points)
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
