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
    var userName = String()

    private init() {}
    
    func getCurrentProfilePic() {
        let urlRequest = NSURLRequest(URL: NSURL(string: "https://graph.facebook.com/me/picture?redirect=true&type=large&return_ssl_resources=1&access_token="+FBSDKAccessToken.currentAccessToken().tokenString)!)
        NSURLSession.sharedSession().dataTaskWithRequest(urlRequest) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error != nil {
                print("Error: \(error.debugDescription)")
            } else {
                if data != nil {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.profilePic = UIImage(data: data!)!
                        NSNotificationCenter.defaultCenter().postNotificationName("GotCurrentProfilePic", object: nil)
                    })
                } else {
                    print("data was nil")
                }
            }
        }.resume()
    }
    
    func getCurrentUserName() {
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: FBSDKAccessToken.currentAccessToken().tokenString, version: nil, HTTPMethod: "GET").startWithCompletionHandler { (connection, result, error) -> Void in
            if error != nil {
                print(error.debugDescription)
            } else {
                if result == nil {
                    self.userName = ""
                } else {
                    self.userName = (result as! Dictionary)["name"]!
                    NSNotificationCenter.defaultCenter().postNotificationName("GotCurrentUserName", object: nil)
                }
            }
        }
    }
}