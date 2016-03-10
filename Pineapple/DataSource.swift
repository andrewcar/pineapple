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
    var profilePic = UIImage()

    private init() {}
    
    func getCurrentProfilePic() {
        let urlRequest = NSURLRequest(URL: NSURL(string: "https://graph.facebook.com/me/picture?redirect=true&type=large&return_ssl_resources=1&access_token="+FBSDKAccessToken.currentAccessToken().tokenString)!)
        NSURLSession.sharedSession().dataTaskWithRequest(urlRequest) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error != nil {
                print("Error: \(error.debugDescription)")
            } else {
                if data != nil {
                    NSNotificationCenter.defaultCenter().postNotificationName("GotCurrentProfilePic", object: nil)
                    print("got profile pic data and posted notification")
                    print("DataSource.sharedInstance.profilePic just before setting it: \(DataSource.sharedInstance.profilePic)")
                    self.profilePic = UIImage(data: data!)!
                    print("DataSource.sharedInstance.profilePic just after setting it: \(DataSource.sharedInstance.profilePic)")
                } else {
                    print("data was nil")
                }
            }
        }.resume()
    }
}