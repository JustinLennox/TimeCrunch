//
//  ActivityTableCell.swift
//  TimeCrunch
//
//  Created by Justin Lennox on 4/4/16.
//  Copyright © 2016 Justin Lennox. All rights reserved.
//

import UIKit

class ActivityTableCell : UITableViewCell {
    
    let containerView = UIView()
    let activityTitleLabel = UILabel()
    
    /**
    *   This is where we add all of the UI for the chill table view cell
    */
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.TimeCrunchTableGray()
        selectionStyle = .None
        
        containerView.backgroundColor = UIColor.whiteColor()
        containerView.layer.cornerRadius = 8.0
        containerView.layer.masksToBounds = true
        addSubview(containerView)
        
        activityTitleLabel.textColor = UIColor.TimeCrunchBlue()
        activityTitleLabel.font = UIFont.systemFontOfSize(16.0, weight: 0.4)
        containerView.addSubview(activityTitleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("FATAL ERROR")
    }
    
    /**
     *   This is where we position the UI for the chill table view cell
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.frame = CGRectMake(frame.width * 0.025, frame.height * 0.05, frame.width * 0.95, frame.height * 0.9)
        activityTitleLabel.frame = CGRectMake(5, 5, containerView.frame.width - 10, containerView.frame.height - 10)
    }
}
