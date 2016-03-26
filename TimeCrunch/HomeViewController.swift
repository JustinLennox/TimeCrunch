//
//  ViewController.swift
//  TimeCrunch
//
//  Created by Justin Lennox on 3/22/16.
//  Copyright © 2016 Justin Lennox. All rights reserved.
//

import UIKit
import QuartzCore

class HomeViewController: UIViewController {
    
    let addActivityButton = UIButton()
    let timerButton = UIButton()
    let shadowView = UIView()
    let timerLabel = UILabel()
    var timer = NSTimer()
    var timing = false
    var timerSeconds = 0
    var ring = RingLayer()
    var ringBackground = RingLayer()

    //All of the things we only need to do once
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerButton.frame = CGRectMake(view.frame.width * 0.25, view.frame.height * 0.15, view.frame.width * 0.50, self.view.frame.width * 0.50)
        timerButton.layer.cornerRadius = timerButton.frame.width / 2
        timerButton.addTarget(self, action: "TimerDown", forControlEvents: .TouchDown)
        timerButton.addTarget(self, action: "TimerPressed", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(timerButton)
        
        shadowView.frame = CGRectMake(timerButton.frame.origin.x + 10, timerButton.frame.origin.y + 10, timerButton.frame.width-20, timerButton.frame.width - 20)
        shadowView.layer.cornerRadius = shadowView.frame.width/2
        shadowView.alpha = 0.0
        view.addSubview(shadowView)
        
        timerLabel.frame = CGRectMake(view.frame.width * 0.25, CGRectGetMidY(timerButton.frame) - view.frame.height * 0.05, view.frame.width * 0.50, view.frame.height * 0.10)
        timerLabel.text = "00:00"
        timerLabel.adjustsFontSizeToFitWidth = true
        timerLabel.font = UIFont.systemFontOfSize(30.0)
        timerLabel.textColor = UIColor.TimeCrunchBlue()
        timerLabel.textAlignment = NSTextAlignment.Center
        view.addSubview(timerLabel)
        
        ringBackground = RingLayer(x: Double(view.frame.width) * 0.25, y: Double(view.frame.height) * 0.15, width: Double(view.frame.width) * 0.50, height: Double(view.frame.width) * 0.50)
        ringBackground.strokeColor = UIColor.TimeCrunchBeige().CGColor
        view.layer.addSublayer(ringBackground)
        
        ring = RingLayer(x: Double(view.frame.width) * 0.25, y: Double(view.frame.height) * 0.15, width: Double(view.frame.width) * 0.50, height: Double(view.frame.width) * 0.50)
        view.layer.addSublayer(ring)
        ringBackground.lineWidth = ring.lineWidth
        
        addActivityButton.frame = CGRectMake(view.frame.width * 0.05, CGRectGetMaxY(timerButton.frame) + view.frame.height * 0.05, view.frame.width * 0.90, self.view.frame.height * 0.08)
        addActivityButton.backgroundColor = UIColor.TimeCrunchBlue()
        addActivityButton.setTitle("Add an Activity", forState: UIControlState.Normal)
        addActivityButton.addTarget(self, action: "AddActivityPressed", forControlEvents: UIControlEvents.TouchUpInside)
        addActivityButton.layer.cornerRadius = 8.0
        view.addSubview(addActivityButton)
    
    }
    
    func AddActivityPressed(){
        performSegueWithIdentifier("AddActivitySegue", sender: self)
    }
    
    func TimerPressed(){
        shadowView.alpha = 0.0
        if(!timing){
            timing = true
            StartActivity()
        }else{
            timing = false
            StopActivity()
        }
    }
    
    func StartActivity(){
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "IncrementTime", userInfo: nil, repeats: true)
        if(timerSeconds == 0){
            ring.animateStroke(0)
        }
        ringBackground.strokeColor = UIColor.TimeCrunchBlue().CGColor
        timerLabel.textColor = UIColor.TimeCrunchBlue()
//        timerButton.setTitle("Stop", forState: UIControlState.Normal)
        let strokeAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeColor")
        strokeAnimation.fromValue = ringBackground.strokeColor
        strokeAnimation.toValue = UIColor.TimeCrunchBlue().CGColor
        strokeAnimation.duration = 0.25
        performSelector("ChangeRingColor", withObject: nil, afterDelay: 0.22)
        ringBackground.addAnimation(strokeAnimation, forKey: "strokeColor")
        ring.hidden = false
    }
    
    func StopActivity(){
        timer.invalidate()
        timerLabel.textColor = UIColor.TimeCrunchOrange()
        ring.hidden = true
        ring.removeAllAnimations()
        ring.strokeStart = 0.0
        ring.strokeEnd = CGFloat((Double(timerSeconds) + 1) / 60.0)
        let strokeAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeColor")
        strokeAnimation.fromValue = UIColor.TimeCrunchBeige().CGColor
        strokeAnimation.toValue = UIColor.TimeCrunchOrange().CGColor
        strokeAnimation.duration = 0.25
        ringBackground.addAnimation(strokeAnimation, forKey: nil)
        performSelector("ChangeRingColor", withObject: nil, afterDelay: 0.22)
    }
    
    func IncrementTime(){
        print("Increment time \(timerSeconds)")
        timerSeconds++
        ring.animateStroke(timerSeconds)
        //Make the minutes into a displayable version
        let timerMinutes = timerSeconds / 60
        var minutesString = "\(timerMinutes)"
        if(timerMinutes < 10){
            minutesString = "0\(minutesString)"
        }
        
        //Make the seconds into a displayable version
        let secondsMinusMinutes = timerSeconds % 60
        var secondsString = "\(secondsMinusMinutes)"
        if(secondsMinusMinutes < 10){
            secondsString = "0\(secondsMinusMinutes)"
        }
        timerLabel.text = "\(minutesString):\(secondsString)"
    }
    
    func TimerDown(){
        if(timing){
            ringBackground.strokeColor = UIColor.TimeCrunchOrange().CGColor
        }else{
            ringBackground.strokeColor = UIColor.TimeCrunchBlue().CGColor
        }
        shadowView.alpha = 1.0
        shadowView.backgroundColor = UIColor.whiteColor()
        shadowView.layer.shadowColor = UIColor.blackColor().CGColor
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowRadius = 5.0
        shadowView.layer.shadowOffset = CGSize(width: -5, height: -5)
    }

    
    func ChangeRingColor(){
        if(timing){
            ringBackground.strokeColor = UIColor.TimeCrunchBeige().CGColor
        }else{
            ringBackground.strokeColor = UIColor.TimeCrunchOrange().CGColor
        }
    }
}

