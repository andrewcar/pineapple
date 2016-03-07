//
//  FBViewController.swift
//  Pineapple
//
//  Created by Andrew Carvajal on 2/25/16.
//  Copyright © 2016 Andrew Carvajal. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class FBViewController: UIViewController {
    
    @IBOutlet weak var loginButton: MaterialButton!
    
    override func viewDidLoad() {
        
        if FBSDKAccessToken.currentAccessToken() == nil {
            print("Not logged in")
        } else {
            print("Logged in")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil {
            performSegueWithIdentifier("showNew", sender: nil)
        }
    }
    
    @IBAction func fbButtonTapped(sender: UIButton) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["public_profile", "email", "user_friends", "user_birthday", "user_relationship_details"], fromViewController: self) { (facebookResult, facebookError) -> Void in
            if facebookError != nil {
                print("facebook had an error: \(facebookError.debugDescription)")
            } else {
                print("facebook result: \(facebookResult.debugDescription)")
                NSUserDefaults.standardUserDefaults().setValue(FBSDKAccessToken.currentAccessToken().tokenString, forKey: "uid")
                self.performSegueWithIdentifier("showNew", sender: nil)
            }
        }
    }
}
