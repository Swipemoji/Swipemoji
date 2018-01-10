//
//  EmptyDrawOverlayView.swift
//  SwipemojiKeyboard
//
//  Created by Takashi Wickes on 10/25/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit
import Lottie

class EmptyDrawOverlayView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var animationView : LOTAnimationView?
    var overlayLabel : UILabel?
    var overlayList : [String] = ["swipe away!"]

    override init(frame: CGRect) {
        super.init(frame: frame)
        animationView = LOTAnimationView(name: "LogoBWAnimation.json")
        animationView?.frame = CGRect(x: 0, y: 0, width: 200, height: 112.75)
        animationView?.center = self.center
        self.overlayLabel = UILabel(frame: .zero)
        overlayLabel?.frame.size = CGSize(width: 300, height: 44)
        overlayLabel?.text = "swipe away!"
        overlayLabel?.textAlignment = .center
        overlayLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 32)
        overlayLabel?.textColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
        overlayLabel?.center = self.center
        overlayLabel?.frame.origin.y += 44

        animationView?.frame.origin.y -= (overlayLabel?.frame.height)! / 2
        self.addSubview(animationView!)
        self.addSubview(overlayLabel!)
        animateOverlay()
    }
    
    func animateOverlay(){
        self.alpha = 0
        self.overlayLabel?.alpha = 0
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.5
            self.overlayLabel?.alpha = 1
        }) { (finished) in
           self.animationView?.play()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggleOpacity(opacity: Int){
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.alpha = CGFloat(opacity)
        }, completion: nil)
    }
    
    func hide(){
        self.toggleOpacity(opacity: 0)
    }
    
    func show(){
        self.toggleOpacity(opacity: 1)
    }
    
    func changeOverlayText(){
        
    }
}
