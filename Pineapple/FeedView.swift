//
//  FeedViewController.swift
//  Pineapple
//
//  Created by Andrew Carvajal on 3/16/16.
//  Copyright © 2016 Andrew Carvajal. All rights reserved.
//

import UIKit

class FeedView: UIView {
    
    var logoImageView = UIImageView()
    var hoodNameLabel = UILabel()
    @IBOutlet weak var tableView: UITableView!
    var toolbarView = UIView()
    var partyListView = UIView()
    var partyListViewMaxY = CGFloat()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        
        toolbarView.frame = CGRectMake(0, 10, bounds.width, 80)
        
        logoImageView.frame = CGRectMake(toolbarView.frame.midX - toolbarView.frame.height / 2, toolbarView.frame.minY, toolbarView.frame.height, toolbarView.frame.height)
        logoImageView.image = UIImage(named: "yuge logo")
        print("frame: \(frame)")
        print("toolbar: \(toolbarView.frame)")
        print("logo: \(logoImageView.frame)")
        
        hoodNameLabel.frame = CGRectMake(0, 0, logoImageView.frame.minX, toolbarView.frame.height)
        hoodNameLabel.adjustsFontSizeToFitWidth = true
        hoodNameLabel.textAlignment = .Center
        hoodNameLabel.font = UIFont.boldSystemFontOfSize(69)
        
        partyListView.frame = CGRectMake(0, toolbarView.frame.maxY, bounds.width, 100)
        partyListViewMaxY = partyListView.frame.maxY
        
        addSubview(toolbarView)
        toolbarView.addSubview(logoImageView)
        toolbarView.addSubview(hoodNameLabel)
        addSubview(partyListView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
