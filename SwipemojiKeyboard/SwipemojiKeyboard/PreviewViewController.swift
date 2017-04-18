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
    
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popBlackBack: UIView!
    @IBOutlet weak var popGestureView: UIView!
    @IBOutlet weak var popEmojiLabel: UILabel!
    @IBOutlet weak var popEmojiView: UIView!
    @IBOutlet weak var popCountLabel: UILabel!
    
    @IBOutlet weak var viewOptionSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.popBlackBack.alpha = 0
        self.popUpView.center.y = 1000
        self.popEmojiView.layer.cornerRadius = 62.5
        self.popEmojiView.layer.borderColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0).cgColor
        self.popEmojiView.layer.borderWidth = 2
        self.popUpView.layer.cornerRadius = 18
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !PreviewViewController.isSwipemojiKBInstalled() {
            self.performSegue(withIdentifier: "setupSegue", sender: nil)
        }
    }
    
    static func isSwipemojiKBInstalled() -> Bool{
        let defaults = UserDefaults.standard
        let keyboards = defaults.object(forKey: "AppleKeyboards") as! NSArray
        let index = keyboards.index(of: "com.swipemoji.swipemoji.Swipemoji")
        if(index != NSNotFound) {
            print("Found keyboard")
            return true
        }
        return false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.popBlackBack.alpha = 0
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
        
        if(viewOptionSegmentedControl.selectedSegmentIndex == 0){
            cell.emojiLabel.text = _library.pointClouds[indexPath.row].name
            cell.gestureView.isHidden = true
            cell.emojiLabel.isHidden = false
        } else {
            cell.emojiDrawingCanvas = PointDisplayCanvas(frame: cell.gestureView.bounds)
            cell.emojiDrawingCanvas?.drawPointCloud(drawingPoints: _library.pointClouds[indexPath.row]._points)
            cell.emojiDrawingCanvas!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            cell.gestureView.addSubview(cell.emojiDrawingCanvas!)
            cell.gestureView.isHidden = false
            cell.emojiLabel.isHidden = true
        }
        
        cell.layer.cornerRadius = 6
        return cell
    }
    
    // MARK: - Pop Up
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
        presentPop()
        
        let drawingCanvas = PointDisplayCanvas(frame: popGestureView.bounds)
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
            dicArrayStore.remove(at: indexRow)
            defaults!.set(dicArrayStore, forKey: "gestures")
        }
        _library = PointCloudLibrary.getDemoLibrary()
    }
    

    
//     MARK: - Navigation

//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         Get the new view controller using segue.destinationViewController.
//         Pass the selected object to the new view controller.
        
        if(segue.identifier == "editSegue"){
            let vc = segue.destination as! GestureMatchController
            vc.initialText = self.popEmojiLabel.text
        }
    }
    

}
