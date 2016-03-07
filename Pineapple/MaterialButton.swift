//
//  MaterialButton.swift
//  Pineapple
//
//  Created by Andrew Carvajal on 3/3/16.
//  Copyright © 2016 Andrew Carvajal. All rights reserved.
//

import UIKit

class MaterialButton: UIButton {
    
    override func awakeFromNib() {
        layer.cornerRadius = 4.0
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }
    
}