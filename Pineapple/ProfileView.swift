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
    var profilePicImageView: FBSDKProfilePictureView = FBSDKProfilePictureView()
    var scoreLabel: UILabel = UILabel()
    var nameLabel: UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
                
        profilePicImageView.frame = CGRectMake(2, 2, bounds.width - 4, bounds.height - 4)
        profilePicImageView.profileID = "/me"
//        profilePicImageView.image = DataSource.sharedInstance.updatedProfilePic()
        addSubview(profilePicImageView)
        
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.textColor = UIColor.blackColor()
        nameLabel.numberOfLines = 0
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.font = UIFont.boldSystemFontOfSize(42)
        nameLabel.text = ""
        addSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
