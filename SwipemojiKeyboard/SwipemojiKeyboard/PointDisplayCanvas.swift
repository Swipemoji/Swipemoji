//
//  PointDisplayCanvas.swift
//  SwipemojiKeyboard
//
//  Created by Takashi Wickes on 3/22/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit

class PointDisplayCanvas: UIView {
    
    var tempImageView:UIImageView?
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        tempImageView = UIImageView(frame:frame)
        
        // or bit operator in
        // swift 1.2 : .FlexibleWidth | .FlexibleHeight -- Object Name is inferred
        // swift 2 : [.FlexibleWidth, .FlexibleHeight]
        tempImageView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tempImageView!.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:1)
        self.addSubview(tempImageView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func drawPointCloud(drawingPoints: [Point]){
        var previousPoint = CGPoint.zero
        var previousID = -1
        for drawPoint in drawingPoints {
            if(previousPoint != nil && previousID == drawPoint.id){
                drawLine(previousPoint, to: CGPoint(x: drawPoint.x * 50 + 10, y: drawPoint.y * 50 + 10))
            }
            previousID = drawPoint.id
            previousPoint = CGPoint(x: (drawPoint.x * 50 + 10), y: drawPoint.y * 50 + 10)
        }
    }


    func drawLine(_ from:CGPoint, to:CGPoint) {
        // Creates a bitmap-based graphics context and makes it the current context.
        print(from)
        print(to)
        UIGraphicsBeginImageContext(self.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView!.image?.draw(in: CGRect(x:0, y:0, width:self.frame.size.width, height:self.frame.size.height))
        
        context?.move(to: CGPoint(x: from.x, y: from.y))
        context?.addLine(to: CGPoint(x: to.x, y: to.y))
        context?.setLineCap(.round)
        context?.setLineWidth(CGFloat(3.0))
        context?.setStrokeColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        context?.setBlendMode(.normal)
        
        context?.strokePath()
        
        tempImageView!.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}
