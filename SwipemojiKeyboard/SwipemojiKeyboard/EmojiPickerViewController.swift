//
//  EmojiPickerViewController.swift
//  SwipemojiKeyboard
//
//  Created by Takashi Wickes on 10/18/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit
import CoreData

class EmojiPickerViewController: UIViewController, EmojiPickerDelegate {
    
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any addivarnal setup after loading the view.
        closeButton.layer.cornerRadius = 21
        closeButton.dropShadow(color: UIColor(red:1.00, green:0.29, blue:0.42, alpha:1.0), offSet: 4)
        let emojiView = EmojiPickerView()
        emojiView.delegate = self
        self.view.addSubview(emojiView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func emojiViewDidSelectEmoji(emojiView: EmojiPickerView, emoji: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "GestureMatch") as! GestureMatchController
        vc.selectedEmoji = emoji
        vc.initialText = emoji
        navigationController?.pushViewController(vc, animated: true)
        
    }

    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
