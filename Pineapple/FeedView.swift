//
//  FeedViewController.swift
//  Pineapple
//
//  Created by Andrew Carvajal on 3/16/16.
//  Copyright © 2016 Andrew Carvajal. All rights reserved.
//

import UIKit

class FeedView: UIView {
    
    var toolbarView = UIView()
    var meetingPointLabel = UILabel()
    var logoImageView = UIImageView()
    var currentPlaceLabel = UILabel()
    var tableView = UITableView()
    var partyListView = UIView()
    var partyListViewMaxY = CGFloat()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        
        toolbarView.frame = CGRectMake(0, 7, bounds.width, 80)
        
        logoImageView.frame = CGRectMake(toolbarView.frame.midX - toolbarView.frame.height / 2, toolbarView.frame.minY, toolbarView.frame.height, toolbarView.frame.height)
        logoImageView.image = UIImage(named: "yuge logo")
        
        meetingPointLabel.frame = CGRectMake(10, 10, logoImageView.frame.minX - 20, toolbarView.frame.height - 20)
        meetingPointLabel.adjustsFontSizeToFitWidth = true
        meetingPointLabel.textAlignment = .Center
        meetingPointLabel.font = UIFont.boldSystemFontOfSize(100)
        meetingPointLabel.numberOfLines = 0
        
        currentPlaceLabel.frame = CGRectMake(logoImageView.frame.maxX + 10, 10, logoImageView.frame.minX - 20, toolbarView.frame.height - 20)
        currentPlaceLabel.adjustsFontSizeToFitWidth = true
        currentPlaceLabel.textAlignment = .Center
        currentPlaceLabel.font = UIFont.boldSystemFontOfSize(100)
        currentPlaceLabel.numberOfLines = 0
        
        partyListView.frame = CGRectMake(0, toolbarView.frame.maxY, bounds.width, 100)
        partyListViewMaxY = partyListView.frame.maxY
        
        addSubview(toolbarView)
        toolbarView.addSubview(meetingPointLabel)
        toolbarView.addSubview(logoImageView)
        toolbarView.addSubview(currentPlaceLabel)
        addSubview(partyListView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
