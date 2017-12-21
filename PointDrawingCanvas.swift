//
//  PointDrawingCanvas.swift
//  PointClouds
//
//  Created by David Lee on 2016. 2. 9..
//  Copyright © 2016년 dhlee. All rights reserved.
//

import UIKit

class PointDrawingCanvas : UIView {
    var points = [Point]()
    var id = 0
    var lastPoint = CGPoint.zero
    var tempImageView:UIImageView?
    var emptyOverlayView: EmptyDrawOverlayView?
    
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        tempImageView = UIImageView(frame:frame)
        tempImageView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tempImageView!.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1)
        self.addSubview(tempImageView!)
        createEmptyStateOverlay()
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createEmptyStateOverlay(){
        emptyOverlayView = EmptyDrawOverlayView(frame: self.frame)
        self.addSubview(emptyOverlayView!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            emptyOverlayView?.hide()
            lastPoint = touch.location(in: self)
            let point = Point(x: Double(lastPoint.x), y: Double(lastPoint.y), id: self.id)
            points.append(point)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let point = touch.location(in: self)
            let pointForCloud = Point(x: Double(point.x), y: Double(point.y), id: self.id)
            points.append(pointForCloud)
            
            drawLine(lastPoint, to:point)
            lastPoint = point
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(points == nil){
            emptyOverlayView?.show()
        }
        self.id += 1
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
    func isEmpty() -> Bool {
        return self.tempImageView?.image == nil
    }
    
    // Quartz 2D
    func drawLine(_ from:CGPoint, to:CGPoint) {
        UIGraphicsBeginImageContext(self.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView!.image?.draw(in: CGRect(x:0, y:0, width:self.frame.size.width, height:self.frame.size.height))
        context?.move(to: CGPoint(x: from.x, y: from.y))
        context?.addLine(to: CGPoint(x: to.x, y: to.y))
        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        context?.setLineWidth(CGFloat(8.0))
        context?.setStrokeColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        context?.setBlendMode(.normal)
        
        context?.strokePath()
        
        tempImageView!.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func clearCanvas() {
        emptyOverlayView?.show()
        self.points = [Point]()
        self.lastPoint = CGPoint.zero
        self.id = 0
        self.tempImageView!.image = nil
    }
}
