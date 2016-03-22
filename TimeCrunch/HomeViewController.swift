//
//  ViewController.swift
//  TimeCrunch
//
//  Created by Justin Lennox on 3/22/16.
//  Copyright © 2016 Justin Lennox. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let addActivityButton = UIButton()
    let startActivityButton = UIButton()
    let timerLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addActivityButton.frame = CGRectMake(view.frame.width * 0.25, self.view.frame.height * 0.10, view.frame.width * 0.50, self.view.frame.height * 0.08)
        addActivityButton.backgroundColor = UIColor.redColor()
        addActivityButton.setTitle("Add an Activity", forState: UIControlState.Normal)
        addActivityButton.addTarget(self, action: "AddActivityPressed", forControlEvents: UIControlEvents.TouchUpInside)
        addActivityButton.layer.cornerRadius = 8.0
        view.addSubview(addActivityButton)
        
        timerLabel.frame = CGRectMake(view.frame.width * 0.25, CGRectGetMaxY(addActivityButton.frame), view.frame.width * 0.50, view.frame.height * 0.10)
        timerLabel.text = "0:00"
        timerLabel.adjustsFontSizeToFitWidth = true
        timerLabel.font = UIFont(name: "Helvetica", size: 30.0)
        timerLabel.textAlignment = NSTextAlignment.Center
        view.addSubview(timerLabel)
        
        startActivityButton.frame = CGRectMake(view.frame.width * 0.25, CGRectGetMaxY(timerLabel.frame) + 10, view.frame.width * 0.50, view.frame.width * 0.50)
        startActivityButton.backgroundColor = UIColor.redColor()
        startActivityButton.setTitle("Start", forState: UIControlState.Normal)
        startActivityButton.layer.cornerRadius = startActivityButton.frame.width / 2
        startActivityButton.addTarget(self, action: "StartActivityPressed", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(startActivityButton)
        
        
    }
    
    func AddActivityPressed(){
        performSegueWithIdentifier("AddActivitySegue", sender: self)
    }
    
    func StartActivityPressed(){
        print("Start Activity!")
    }

}

