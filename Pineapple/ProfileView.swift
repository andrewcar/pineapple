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

    override init(frame: CGRect) {
        super.init(frame: frame)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateProfilePic", name: "GotCurrentProfilePic", object: nil)
        DataSource.sharedInstance.getCurrentProfilePic()
        
        // Profile pic image view
        profilePicImageView.frame = CGRectMake(2, 2, bounds.width - 4, bounds.height - 4)
        
        // Rating view
        ratingImageView = UIImageView(image: UIImage(named: "rating stars"))
        
        // Name label
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.textColor = UIColor.blackColor()
        nameLabel.numberOfLines = 0
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.font = UIFont.boldSystemFontOfSize(42)
        nameLabel.text = ""
        
        addSubview(profilePicImageView)
        addSubview(nameLabel)
        addSubview(ratingImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateProfilePic() {
        print("got notification and setting the image to the property containing the data received")
        print("DataSource.sharedInstance.profilePic: \(DataSource.sharedInstance.profilePic)")
        profilePicImageView.image = DataSource.sharedInstance.profilePic
        print("image: \(profilePicImageView.image)")
        print("DataSource.sharedInstance.profilePic: \(DataSource.sharedInstance.profilePic)")

    }
}
