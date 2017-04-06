//
//  GestureMatchController.swift
//  SwipemojiKeyboard
//
//  Created by Shakeeb Majid on 2/17/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit
import Firebase

class GestureMatchController: UIViewController {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var emojiText: UITextField!
    
    @IBOutlet weak var canvas: UIView!
    
    
    var lastPoint = CGPoint.zero
    
    var drawingCanvas:PointDrawingCanvas?
    
    var _library = PointCloudLibrary.getDemoLibrary()
    
    var ref: FIRDatabaseReference!
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 10

        drawingCanvas = PointDrawingCanvas(frame: canvas.bounds)
        drawingCanvas!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        canvas.addSubview(drawingCanvas!)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }

    @IBAction func clearPressed(_ sender: Any) {
        drawingCanvas?.clearCanvas()
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
        
    @IBAction func submitGesture(_ sender: Any) {
        if let canvas = drawingCanvas {
            if !canvas.isEmpty() {
                ref = FIRDatabase.database().reference()
                let gestureRef = ref.child("gestures")
                
                let gesture = PointCloud(emojiText.text!, canvas.points)
                let gestureJson = gesture.toJSON()
                
                let gestureDict = convertToDictionary(text: gestureJson)
                ref.observe(.value, with: { snapshot in
                    var gestures = (snapshot.value! as! NSDictionary).object(forKey: "gestures")! as! NSDictionary
                    gestures.setValue(gestureDict?[self.emojiText.text!], forKey: self.emojiText.text!)
                    
                    gestureRef.setValue(gestures)
                    //print("gestures: \(gestures)")
             
                })

                
                
                //let pointCloud = PointCloud("input gesture", canvas.points)
                
                //let matchResult = _library.recognizeFromLibrary(pointCloud)
                //                let text = "\(matchResult.name), score: \(matchResult.score)"
                
                //print(canvas.points) //array of Point objects
                
                let defaults = UserDefaults.init(suiteName: "group.swipemoji.appgroup")
                if let dicArray = defaults!.array(forKey: "gestures") as? [NSMutableDictionary] {
                    var dicArrayStore = dicArray
                    dicArrayStore.append([emojiText.text!:pointsToArray(points: canvas.points)])
                    //_library.pointClouds.append(PointCloud(emojiText.text!, canvas.points))
                    defaults!.set(dicArrayStore, forKey: "gestures")
                    
                } else {
                    var dicArray: [NSMutableDictionary] = []
                    
                    dicArray.append([emojiText.text!:pointsToArray(points: canvas.points)])
                    //_library.pointClouds.append(PointCloud(emojiText.text!, canvas.points))
                    
                    defaults!.set(dicArray, forKey: "gestures")
                }
                
                
                
                
                
                
                //let text = "\(matchResult.name) "
                //var proxy = textDocumentProxy as UITextDocumentProxy
                
                /*if let input = text as String? {
                    proxy.insertText(input)
                    drawingCanvas?.clearCanvas()
                }*/
            } else {
                //self.emojiText.text = "No match result."
            }
        }
        self.dismiss(animated: true)
        
        
    }
    func pointsToArray(points:[Point]) -> [NSArray] {
        var pointArray = [] as [NSArray]
        
        for point in points {
            var array = [point.x, point.y, point.id] as NSArray
            pointArray.append(array)
            
            
            
            
            
            
        }
        //print(pointArray)
        return pointArray
        
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
    
    /* ref = FIRDatabase.database().reference()
     var gestureRef = ref.child("gestures")
     
     let groceryItem = "{\"name\":\"James\"}"
     let groceryItem1 = "{\"names\":[{\"James\": \"Baldwin\", \"Daniel\": \"Rad\" }, { \"Alec\": \"Baldwin\"}]}"
     var groceryDict = convertToDictionary(text: groceryItem1)
     
     
     var pcloud = PointCloud("💩", [
     Point(x:507,y:8,id:1),Point(x:507,y:87,id:1),
     Point(x:513,y:7,id:2),Point(x:528,y:7,id:2),Point(x:537,y:8,id:2),Point(x:544,y:10,id:2),Point(x:550,y:12,id:2),Point(x:555,y:15,id:2),Point(x:558,y:18,id:2),Point(x:560,y:22,id:2),Point(x:561,y:27,id:2),Point(x:562,y:33,id:2),Point(x:561,y:37,id:2),Point(x:559,y:42,id:2),Point(x:556,y:45,id:2),Point(x:550,y:48,id:2),Point(x:544,y:51,id:2),Point(x:538,y:53,id:2),Point(x:532,y:54,id:2),Point(x:525,y:55,id:2),Point(x:519,y:55,id:2),Point(x:513,y:55,id:2),Point(x:510,y:55,id:2)
     ])
     
     var json = pcloud.toJSON()
     //gestureRef.setValue(groceryDict)
     gestureRef.setValue(convertToDictionary(text: json))
     //print("ref: \(gestureRef.key)")
     //print("name: \(json)")
     //print("name2: \(groceryItem1)")
     ref.observe(.value, with: { snapshot in
     //print(snapshot.value!)
     //print((snapshot.value! as! NSDictionary).object(forKey: "gestures")!)
     var pointArray = [] as [Point]
     let gestures = (snapshot.value! as! NSDictionary).object(forKey: "gestures")! as! NSDictionary
     for (key, value) in gestures {
     let points = value as! NSArray
     for point in points {
     let x = (point as! NSDictionary).object(forKey: "x")
     let y = (point as! NSDictionary).object(forKey: "y")
     let id = (point as! NSDictionary).object(forKey: "id")
     let pointObject = Point(x: x as! Double, y: y as! Double, id: id as! Int)
     //print(pointObject)
     pointArray.append(pointObject)
     
     }
     let pCloud1 = PointCloud(key as! String, pointArray)
     print("name: \(pCloud1.name) points: \(pCloud1._points)")
     self._library.pointClouds.append(pCloud1)
     
     }
     })
     */


}
