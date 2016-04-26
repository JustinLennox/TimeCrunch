//
//  AddActivityViewController.swift
//  TimeCrunch
//
//  Created by Justin Lennox on 4/4/16.
//  Copyright © 2016 Justin Lennox. All rights reserved.
//

import UIKit

class AddActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    let addActivityTableView = UITableView()
    let addActivityTextField = UITextField()
    var activitiesArray = ["Walk the dog", "Take out the trash"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()

        addActivityTextField.placeholder = "Enter a new activity"
        addActivityTextField.font = UIFont.systemFontOfSize(16.0, weight: 0.4)
        addActivityTextField.textColor = UIColor.TimeCrunchBlue()
        addActivityTextField.tintColor = UIColor.TimeCrunchBlue()
        addActivityTextField.delegate = self
        addActivityTextField.returnKeyType = .Done
        view.addSubview(addActivityTextField)
        
        addActivityTableView.frame = CGRectMake(0, 0, view.frame.width, view.frame.height)
        addActivityTableView.dataSource = self
        addActivityTableView.delegate = self
        addActivityTableView.separatorStyle = .None
        addActivityTableView.tableFooterView = UIView()
        addActivityTableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, 0, 5))
        addActivityTableView.registerClass(ActivityTableCell.self, forCellReuseIdentifier: "ActivityCell")
        addActivityTableView.backgroundColor = UIColor.TimeCrunchTableGray()
        addActivityTableView.allowsMultipleSelection = true
        view.addSubview(addActivityTableView)
        addActivityTableView.setNeedsLayout()
        addActivityTableView.layoutIfNeeded()
        addActivityTableView.reloadData()
    }
    
    //MARK: - Table View Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activitiesArray.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let activityCell = tableView.dequeueReusableCellWithIdentifier("ActivityCell") as! ActivityTableCell
            addActivityTextField.frame = CGRectMake(activityCell.containerView.frame.origin.x + 5, activityCell.containerView.frame.origin.y, activityCell.containerView.frame.width - 5, activityCell.containerView.frame.height)
            activityCell.addSubview(addActivityTextField)
            return activityCell
        }else{
            let activityCell = tableView.dequeueReusableCellWithIdentifier("ActivityCell") as! ActivityTableCell
            activityCell.activityTitleLabel.text = activitiesArray[indexPath.row - 1]
            return activityCell
        }
    }
    
    //MARK: Text Field Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let activityTitle = textField.text {
            addActivityTextField.text = ""
        }
        addActivityTextField.resignFirstResponder()
        return false
    }
}
