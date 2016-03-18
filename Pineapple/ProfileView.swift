//
//  ProfileView.swift
//  Pineapple
//
//  Created by Andrew Carvajal on 2/21/16.
//  Copyright © 2016 Andrew Carvajal. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

enum ProfileState {
    case ProfileClosed
    case ProfileOpen
}

class ProfileView: UIView {
    
    var profileState = ProfileState?()
    var profilePicImageView: UIImageView = UIImageView()
    var ratingImageView: UIImageView = UIImageView()
    var nameLabel: UILabel = UILabel()
    var hostCountLabel: UILabel = UILabel()
    var attendCountLabel: UILabel = UILabel()
    var showLocationLabel: UILabel = UILabel()
    var showLocationSwitch: UISwitch = UISwitch()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        
        // Profile pic image view
        profilePicImageView.frame = CGRectMake(2, 2, frame.width - 4, frame.height - 4)
        
        // Rating view
        ratingImageView = UIImageView(image: UIImage(named: "rating stars"))
        ratingImageView.frame = CGRectMake(CGRectGetMinX(ratingImageView.frame), CGRectGetMinY(ratingImageView.frame), CGRectGetWidth(ratingImageView.frame), 0)
        
        // Name label
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.textColor = UIColor.blackColor()
        nameLabel.numberOfLines = 0
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.font = UIFont.boldSystemFontOfSize(42)
        
        // Host count label
        hostCountLabel.textAlignment = NSTextAlignment.Center
        hostCountLabel.textColor = UIColor.darkGrayColor()
        hostCountLabel.numberOfLines = 1
        hostCountLabel.adjustsFontSizeToFitWidth = true
        hostCountLabel.font = UIFont.systemFontOfSize(21)
        hostCountLabel.text = "You have hosted no parties."
        
        // Attend count label
        attendCountLabel.textAlignment = NSTextAlignment.Center
        attendCountLabel.textColor = UIColor.darkGrayColor()
        attendCountLabel.numberOfLines = 1
        attendCountLabel.adjustsFontSizeToFitWidth = true
        attendCountLabel.font = UIFont.systemFontOfSize(21)
        attendCountLabel.text = "You have attended no parties."
        
        // Show location label
        showLocationLabel.textAlignment = NSTextAlignment.Right
        showLocationLabel.textColor = UIColor.lightGrayColor()
        showLocationLabel.numberOfLines = 1
        showLocationLabel.font = UIFont.italicSystemFontOfSize(20)
        showLocationLabel.text = "Show location to party"
                
        addSubview(profilePicImageView)
        addSubview(ratingImageView)
        addSubview(nameLabel)
        addSubview(hostCountLabel)
        addSubview(attendCountLabel)
        addSubview(showLocationLabel)
        addSubview(showLocationSwitch)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
