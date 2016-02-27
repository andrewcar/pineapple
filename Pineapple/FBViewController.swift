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

class FBViewController: UIViewController, FBSDKLoginButtonDelegate {
    override func viewDidLoad() {
        
        if FBSDKAccessToken.currentAccessToken() == nil {
            print("Not logged in")
        } else {
            print("Logged in")
        }
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = view.center
        loginButton.delegate = self
        
        view.addSubview(loginButton)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error == nil {
            print("Login complete")
            self.performSegueWithIdentifier("showNew", sender: self)
        } else {
            print("Error: \(error.localizedDescription)")

        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out")
    }
}
