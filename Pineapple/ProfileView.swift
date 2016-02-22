//
//  ProfileView.swift
//  Pineapple
//
//  Created by Andrew Carvajal on 2/21/16.
//  Copyright © 2016 Andrew Carvajal. All rights reserved.
//

import UIKit

enum ProfileState {
    case ProfileClosed
    case ProfileOpen
}

class ProfileView: UIView {
    
    var profileState = ProfileState?()
    var profilePicImageView: UIImageView = UIImageView()
    var scoreLabel: UILabel = UILabel()
    var nameLabel: UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        profilePicImageView.frame = CGRectMake(2, 2, bounds.width - 4, bounds.height - 4)
        profilePicImageView.image = UIImage(named: "bruh")
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.width / 2
        profilePicImageView.layer.masksToBounds = true
        addSubview(profilePicImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
