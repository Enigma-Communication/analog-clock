//
//  ClockViewController.swift
//  clock
//
//  Created by dsy on 7/31/15.
//  Copyright (c) 2015 dsy. All rights reserved.
//
import UIKit

class ClockViewController: UIViewController {
    @IBOutlet var myClock: ClockFaceView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        for view in self.view.subviews {
            if view.tag == 10 {
                view.removeFromSuperview()
            }
        }
        self.addHandsAndCenterPiece()
    }
    
    func addHandsAndCenterPiece() {
        let newView = UIView(frame: CGRect(x: CGRectGetMidX(myClock.frame), y: CGRectGetMidY(myClock.frame), width: CGRectGetWidth(myClock.frame), height: CGRectGetWidth(myClock.frame)))
        
        newView.tag = 10
        self.view.addSubview(newView)
        
        // hour hand
        let hourHandWidth:CGFloat = (myClock.bounds.height/2 * 0.030)
        // minute hand
        let minuteHandWidth:CGFloat = (myClock.bounds.height/2 * 0.0225)
        // second hand
        let secondHandWidth:CGFloat = (myClock.bounds.height/2 * 0.0168)

        let time = timeCoords(myClock.bounds.minX, y: myClock.bounds.minY, time: ctime(),radius: myClock.bounds.height/2)
        
        let hourHandPath = UIBezierPath()
        let minuteHandPath = UIBezierPath()
        let secondHandPath = UIBezierPath()
        
        hourHandPath.moveToPoint(CGPoint(x: newView.bounds.minX, y:newView.bounds.minY ))
        minuteHandPath.moveToPoint(CGPoint(x: newView.bounds.minX, y:newView.bounds.minY ))
        secondHandPath.moveToPoint(CGPoint(x: newView.bounds.minX, y:newView.bounds.minY ))
        
        hourHandPath.addLineToPoint(CGPoint(x: time.h.x, y: time.h.y))
        hourHandPath.lineWidth = hourHandWidth
        let hourLayer = CAShapeLayer()
        hourLayer.path = hourHandPath.CGPath
        hourLayer.lineWidth = hourHandWidth
        hourLayer.lineCap = kCALineCapButt
        hourLayer.strokeColor = UIColor.redColor().CGColor
        hourLayer.rasterizationScale = UIScreen.mainScreen().scale;
        hourLayer.shouldRasterize = true
        newView.layer.addSublayer(hourLayer)
        rotateLayer(hourLayer,dur:43200)
        
        minuteHandPath.addLineToPoint(CGPoint(x: time.m.x, y: time.m.y))
        minuteHandPath.lineWidth = minuteHandWidth
        let minuteLayer = CAShapeLayer()
        minuteLayer.path = minuteHandPath.CGPath
        minuteLayer.lineWidth = minuteHandWidth
        minuteLayer.lineCap = kCALineCapButt
        minuteLayer.strokeColor = UIColor.grayColor().CGColor
        minuteLayer.rasterizationScale = UIScreen.mainScreen().scale;
        minuteLayer.shouldRasterize = true
        newView.layer.addSublayer(minuteLayer)
        rotateLayer(minuteLayer,dur: 3600)
        
        secondHandPath.addLineToPoint(CGPoint(x: time.s.x, y: time.s.y))
        secondHandPath.lineWidth = secondHandWidth
        let secondLayer = CAShapeLayer()
        secondLayer.path = secondHandPath.CGPath
        secondLayer.lineWidth = secondHandWidth
        secondLayer.lineCap = kCALineCapButt
        secondLayer.strokeColor = UIColor.blackColor().CGColor
        secondLayer.rasterizationScale = UIScreen.mainScreen().scale;
        secondLayer.shouldRasterize = true
        newView.layer.addSublayer(secondLayer)
        rotateLayer(secondLayer,dur: 60)
        
        let endAngle = CGFloat(2*M_PI)
        let circle = UIBezierPath(arcCenter: CGPoint(x: newView.bounds.origin.x, y:newView.bounds.origin.y), radius: myClock.bounds.height/2 * 0.03, startAngle: 0, endAngle: endAngle, clockwise: true)
        let centerPiece = CAShapeLayer()
        
        centerPiece.path = circle.CGPath
        centerPiece.fillColor = UIColor.blackColor().CGColor
        newView.layer.addSublayer(centerPiece)
    }
    
    func rotateLayer(currentLayer:CALayer,dur:CFTimeInterval){
        var angle = degree2radian(360)
        
        var theAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
        theAnimation.duration = dur
        theAnimation.delegate = self
        theAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)

        theAnimation.fromValue = 0
        theAnimation.repeatCount = Float.infinity
        theAnimation.toValue = angle
        // Add animation to layer
        currentLayer.addAnimation(theAnimation, forKey:"rotate")
    }
    
    func  timeCoords(x:CGFloat,y:CGFloat,time:(h:Int,m:Int,s:Int),radius:CGFloat,adjustment:CGFloat=90)->(h:CGPoint, m:CGPoint,s:CGPoint) {
        let cx = x
        let cy = y
        var r  = radius * 0.52
        var points = [CGPoint]()
        var angle = degree2radian(6)
        func newPoint (t:Int) {
            let xpo = cx - r * cos(angle * CGFloat(t)+degree2radian(adjustment))
            let ypo = cy - r * sin(angle * CGFloat(t)+degree2radian(adjustment))
            points.append(CGPoint(x: xpo, y: ypo))
        }
        // hours
        var hours = time.h
        if hours > 12 {
            hours = hours-12
        }
        let hoursInSeconds = time.h*3600 + time.m*60 + time.s
        newPoint(hoursInSeconds*5/3600)
        
        // minutes
        r = radius * 0.58
        let minutesInSeconds = time.m*60 + time.s
        newPoint(minutesInSeconds/60)
        
        // seconds
        r = radius * 0.63
        newPoint(time.s)
        
        return (h:points[0],m:points[1],s:points[2])
    }
    func degree2radian(a:CGFloat)->CGFloat {
        let b = CGFloat(M_PI) * a/180
        return b
    }
    func ctime ()->(h:Int,m:Int,s:Int) {
        var t = time_t()
        time(&t)
        let x = localtime(&t)
        
        return (h:Int(x.memory.tm_hour),m:Int(x.memory.tm_min),s:Int(x.memory.tm_sec))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

}
