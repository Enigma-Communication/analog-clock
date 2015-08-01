//
//  ClockFaceView.swift
//  clock
//
//  Created by dsy on 7/31/15.
//  Copyright (c) 2015 dsy. All rights reserved.
//

import Foundation
import UIKit

let π:CGFloat = CGFloat(M_PI)
@IBDesignable class ClockFaceView : UIView {
    
    @IBInspectable var fillColor: UIColor = UIColor.greenColor()
    
    func drawFrame(rect: CGRect) {
        let center = CGPoint(x:rect.width/2, y: rect.height/2)
        
        let radius: CGFloat = (max(rect.width, rect.height) / 2)
        
        let arcWidth: CGFloat = 0
        
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = 2*π
        
        var path = UIBezierPath(arcCenter: center, radius: radius-(rect.height * 0.083),startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        var strokeColor: UIColor = UIColor.blackColor()
        
        path.lineWidth = arcWidth
        
        strokeColor.setStroke()
        path.lineWidth = (rect.height * 0.083)
        path.stroke()
        var fillColor: UIColor = UIColor.whiteColor()
        fillColor.setFill()
        path.fill()
        
    }
    
    func drawTicks(rect: CGRect) {
        
        var context = UIGraphicsGetCurrentContext()
        
        // save original state
        CGContextSaveGState(context)
        var strokeColor1: UIColor = UIColor.blackColor()
        strokeColor1.setFill()
        
        // minute ticks
        var minuteWidth:CGFloat = (rect.height * 0.0125)
        var minuteSize:CGFloat = (rect.height * 0.025)
        
        // the marker is positioned in top left
        var minutePath = UIBezierPath(rect: CGRect(x: -minuteWidth/2, y: 0,
            width: minuteWidth, height: minuteSize))
        
        // hour ticks
        var hourWidth:CGFloat = (rect.height * 0.020)
        var hourSize:CGFloat = (rect.height * 0.0333)
        
        var hourPath = UIBezierPath(rect: CGRect(x: -hourWidth/2, y: 0, width: hourWidth,height: hourSize))
        
        
        // move context to the center position
        CGContextTranslateCTM(context, rect.width/2, rect.height/2)
        
        var arcLengthPerGlass = π/30
        
        // minute ticks
        for i in 1...60 {
            // save the centred context
            CGContextSaveGState(context)
            
            // calculate the rotation angle
            var angle = arcLengthPerGlass * CGFloat(i) - π/2
            
            //rotate and translate
            CGContextRotateCTM(context, angle)
            
            // translate and fill with hour tick
            if (i%5 == 0) {
                CGContextTranslateCTM(context,
                    0, ((rect.height/2) - (rect.height * 0.1235)) - hourSize)
                hourPath.fill()
                
            } // translate and fill with minute tick
            else {
                CGContextTranslateCTM(context,
                    0, ((rect.height/2) - (rect.height * 0.116)) - hourSize)
                minutePath.fill()
            }
            
            // restore the centred context for the next rotate
            CGContextRestoreGState(context)
        }
        
    }
    
    
    func drawHourLabels(rect: CGRect) {
       
//        var testLabel = UILabel(frame: CGRectMake(rect.width/2, rect.height/2, 75, 75))
//        
//        testLabel.textAlignment = NSTextAlignment.Center
//        
//        var radius:Float = 170.0
//        
//        testLabel.center = CGPointMake(rect.width / 2, ((rect.height/2.0) - radius))
//        testLabel.font = UIFont(name: testLabel.font.fontName, size: 38)
//        testLabel.text = "12"
//        
//        self.addSubview(testLabel)
        
//        let labelSize:CFFloat =
//        
//        var context = UIGraphicsGetCurrentContext()
//        
//        // save original state
//        CGContextSaveGState(context)
//        
//        CGContextTranslateCTM(context, rect.width/2, rect.height/2)
//        var arcLengthPerGlass = π/30
//        
//        for i in 1...60 {
//            
//            var angle = arcLengthPerGlass * CGFloat(i) - π/2
//            
//            if (i%5 == 0) {
//                CGContextTranslateCTM(context,
//                    0, ((rect.height/2) - (rect.height * 0.1235)) - hourSize)
//                hourPath.fill()
//                
//            }
//        }
        
    }
    
    override func drawRect(rect: CGRect) {
        
        
        
        drawFrame(rect)
        drawTicks(rect)
        drawHourLabels(rect)
        
    }
}