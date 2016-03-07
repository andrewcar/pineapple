//
//  DataSource.swift
//  Pineapple
//
//  Created by Andrew Carvajal on 2/27/16.
//  Copyright © 2016 Andrew Carvajal. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class DataSource {
    
    static let sharedInstance = DataSource()
    private init() {}
    
    func updatedProfilePic() -> UIImage {
        var profilePic = UIImage()
        let params = ["redirect": true, "type": "large"]
        let pictureRequest = FBSDKGraphRequest(graphPath: "/me/picture?fields=", parameters: params, HTTPMethod: "GET")
        pictureRequest.startWithCompletionHandler { (connection, result, error) -> Void in
            if error != nil {
                print(error.debugDescription)
            } else {
                profilePic = result as! UIImage
            }
        }
        return profilePic
    }
}