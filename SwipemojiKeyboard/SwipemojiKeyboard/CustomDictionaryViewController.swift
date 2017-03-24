//
//  CustomDictionaryViewController.swift
//  SwipemojiKeyboard
//
//  Created by Takashi Wickes on 3/21/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit

class CustomDictionaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var _library = PointCloudLibrary.getDemoLibrary()


    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePressed(_ sender: Any) {
//        _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)

    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _library.pointClouds.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dictionaryEntryCell", for: indexPath) as! DictionaryEntryTableViewCell
        cell.emojiLabel.text = _library.pointClouds[indexPath.row].name
        
        cell.drawingCanvas = PointDisplayCanvas(frame: cell.gestureDefinitionView.bounds)
        cell.drawingCanvas?.drawPointCloud(drawingPoints: _library.pointClouds[indexPath.row]._points)
        cell.drawingCanvas!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cell.gestureDefinitionView.addSubview(cell.drawingCanvas!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            print("ASDAS")
            let defaults = UserDefaults.init(suiteName: "group.swipemoji.appgroup")
            if let dicArray = defaults!.array(forKey: "gestures") as? [NSMutableDictionary] {
                var dicArrayStore = dicArray
                dicArrayStore.remove(at: indexPath.row)
                defaults!.set(dicArrayStore, forKey: "gestures")
            }
            _library = PointCloudLibrary.getDemoLibrary()
            tableView.reloadData()
//            yourArray.remove(at: indexPath.row)
//            tblDltRow.reloadData()
        }
    }
    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .delete {
//            self.dawgs.removeAtIndex(indexPath.row)
//            self.tableView.reloadData()
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
