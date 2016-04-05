//
//  ViewController.swift
//  TimeCrunch
//
//  Created by Justin Lennox on 3/22/16.
//  Copyright © 2016 Justin Lennox. All rights reserved.
//

import UIKit
import QuartzCore

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let addActivityButton = UIButton()
    /** The invisible button over the timer that starts and stops activities */
    let timerButton = UIButton()
    /** Label that displays the time the activity is taking */
    let timerLabel = UILabel()
    /** The NSTimer that keeps track of the time the activity is taking */
    var timer = NSTimer()
    /** A boolean flag indicating whether we're timing an activity or not */
    var timing = false
    /** The number of seconds the activity has taken so far */
    var timerSeconds = 0
    
    /** A visual ring to display the seconds moving */
    var ring = RingLayer()
    var ringBackground = RingLayer()
    
    let activitiesTableView = UITableView()
    var activitiesArray = ["Brush Teeth", "Shower", "Walk the Pup"]
    var expandedIndex = NSIndexPath()

    //All of the things we only need to do once
    override func viewDidLoad() {
        super.viewDidLoad()
        AddTimerUI()
        AddTableViewUI()
    }
    
    //MARK: - UI
    
    /**
    Adds the timer button, label, ring, and add activity button UI to the app.
    */
    func AddTimerUI(){
        timerButton.frame = CGRectMake(view.frame.width * 0.25, view.frame.height * 0.15, view.frame.width * 0.50, self.view.frame.width * 0.50)
        timerButton.layer.cornerRadius = timerButton.frame.width / 2
        timerButton.addTarget(self, action: "TimerDown", forControlEvents: .TouchDown)
        timerButton.addTarget(self, action: "TimerPressed", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(timerButton)
        
        timerLabel.frame = CGRectMake(view.frame.width * 0.25, CGRectGetMidY(timerButton.frame) - view.frame.height * 0.05, view.frame.width * 0.50, view.frame.height * 0.10)
        timerLabel.text = "Start"
        timerLabel.adjustsFontSizeToFitWidth = true
        timerLabel.font = UIFont.systemFontOfSize(30.0)
        timerLabel.textColor = UIColor.TimeCrunchBlue()
        timerLabel.textAlignment = NSTextAlignment.Center
        view.addSubview(timerLabel)
        
        ringBackground = RingLayer(x: Double(view.frame.width) * 0.50, y: CGRectGetMidY(timerButton.frame), width: Double(view.frame.width) * 0.50, height: Double(view.frame.width) * 0.50)
        ringBackground.strokeColor = UIColor.TimeCrunchBeige().CGColor
        view.layer.addSublayer(ringBackground)
        
        ring = RingLayer(x: Double(view.frame.width) * 0.50, y: CGRectGetMidY(timerButton.frame), width: Double(view.frame.width) * 0.50, height: Double(view.frame.width) * 0.50)
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
    
    //MARK: - Timing Activities
    
    /**
    Called when we press the main timer button in the center of the screen. Starts timing the activity
    if we're not already, or stops timing it if we are.
    */
    func TimerPressed(){
        timerButton.backgroundColor = view.backgroundColor
        if(!timing){    //Start timing the activity
            timing = true
            StartActivity()
        }else{  //Stop timing the activity
            timing = false
            StopActivity()
        }
    }
    
    /**
    Starts timing the activity
    */
    func StartActivity(){
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "IncrementTime", userInfo: nil, repeats: true)
        timerLabel.textColor = UIColor.TimeCrunchBlue()
        ChangeRingToTiming()
    }
    
    /**
    Stops timing the activity
    */
    func StopActivity(){
        timer.invalidate()
        timerLabel.textColor = UIColor.TimeCrunchOrange()
        ChangeRingToStopped()
    }
    
    /**
    Called every second while we're timing an activity. Updates UI and time
    */
    func IncrementTime(){
        timerSeconds++
        ring.animateStroke(timerSeconds)
        //Make the minutes into a displayable version (i.e. 09 instead of 9)
        let timerMinutes = timerSeconds / 60
        var minutesString = "\(timerMinutes)"
        if(timerMinutes < 10){
            minutesString = "0\(minutesString)"
        }
        
        //Make the seconds into a displayable version (i.e. 09 instead of 9)
        let secondsMinusMinutes = timerSeconds % 60
        var secondsString = "\(secondsMinusMinutes)"
        if(secondsMinusMinutes < 10){
            secondsString = "0\(secondsMinusMinutes)"
        }
        timerLabel.text = "\(minutesString):\(secondsString)"   //Combines the minutes and seconds to look like "09:45"
    }
    
    /**
    Called when we press down on the timer just to show touch down
    */
    func TimerDown(){
       timerButton.backgroundColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0 , alpha: 1.0)
    }
    
    //MARK: - TableView
    
    /**
     Adds the tableview UI to the app
     */
    func AddTableViewUI(){
        activitiesTableView.frame = CGRectMake(CGRectGetMinX(addActivityButton.frame), CGRectGetMaxY(addActivityButton.frame) + 10, addActivityButton.frame.width, view.frame.height - CGRectGetMaxY(addActivityButton.frame) - 20)
        activitiesTableView.backgroundColor = UIColor.TimeCrunchTableGray()
        activitiesTableView.registerClass(ActivityTableCell.self, forCellReuseIdentifier: "ActivityCell")
        activitiesTableView.tableFooterView = UIView()
        activitiesTableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, 0, 5))
        activitiesTableView.layer.cornerRadius = addActivityButton.layer.cornerRadius
        activitiesTableView.delegate = self
        activitiesTableView.separatorStyle = .None
        activitiesTableView.dataSource = self
        view.addSubview(activitiesTableView)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activitiesArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let activityCell = tableView.dequeueReusableCellWithIdentifier("ActivityCell") as! ActivityTableCell
        activityCell.activityTitleLabel.text = activitiesArray[indexPath.row]
        return activityCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        for index in 0...activitiesArray.count {
            if let activityCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? ActivityTableCell{
                activityCell.containerView.backgroundColor = UIColor.whiteColor()
                activityCell.activityTitleLabel.textColor = UIColor.TimeCrunchBlue()
            }
        }
        
        if let activityCell = tableView.cellForRowAtIndexPath(indexPath) as? ActivityTableCell{
            activityCell.containerView.backgroundColor = UIColor.TimeCrunchBlue()
            activityCell.activityTitleLabel.textColor = UIColor.whiteColor()
        }
    }
    
    //MARK: - Ring Methods (ADVANCED!)
    
    /**
    Changes the ring's UI to show that we are timing an activity
    */
    func ChangeRingToTiming(){
        if(timerSeconds == 0){
            ring.animateStroke(0)
        }
        ringBackground.strokeColor = UIColor.TimeCrunchBlue().CGColor
        let strokeAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeColor")
        strokeAnimation.fromValue = ringBackground.strokeColor
        strokeAnimation.toValue = UIColor.TimeCrunchBlue().CGColor
        strokeAnimation.duration = 0.25
        performSelector("ChangeRingColor", withObject: nil, afterDelay: 0.22)
        ringBackground.addAnimation(strokeAnimation, forKey: "strokeColor")
        ring.hidden = false
    }
    
    /**
    Changes the ring's UI to show that we've stopped timing
    */
    func ChangeRingToStopped(){
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

    
    func ChangeRingColor(){
        if(timing){
            ringBackground.strokeColor = UIColor.TimeCrunchBeige().CGColor
        }else{
            ringBackground.strokeColor = UIColor.TimeCrunchOrange().CGColor
        }
    }
}

