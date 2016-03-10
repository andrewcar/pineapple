//
//  MapViewController.swift
//  Pineapple
//
//  Created by Andrew Carvajal on 2/7/16.
//  Copyright © 2016 Andrew Carvajal. All rights reserved.
//

import UIKit
import Mapbox
import FBSDKCoreKit

class MapViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate {
    
    var edgePadding: CGFloat = 20
    var innerPadding: CGFloat = 10
    var mapboxView: MGLMapView!
    var locationManager: CLLocationManager = CLLocationManager()
    var mapCenter: CLLocationCoordinate2D?
    var profileView = ProfileView()
    var profileButton = UIButton()
    
    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addMap()
        addProfile()
        setCamera()
        addLocationManager()
    }
    
    // MARK: Helper Functions
    
    func addMap() {
        mapboxView = MGLMapView(frame: view.bounds)
        mapboxView.delegate = self
        mapboxView.styleURL = NSURL(string: "mapbox://styles/andrewcar/cigjifhox00059em63qbqemcm")
        mapboxView.showsUserLocation = true
        mapboxView.tintColor = UIColor.clearColor()
        mapboxView.allowsRotating = true
        mapboxView.pitchEnabled = true
        mapboxView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.addSubview(mapboxView)
    }
    
    func setCamera() {
        // If location manager returns user location, set mapCenter to it, else, set mapCenter to NYC.
        if locationManager.location?.coordinate != nil {
            mapCenter = locationManager.location?.coordinate
        } else {
            mapCenter = CLLocationCoordinate2DMake(40.735987, -73.993631)
        }
        
        // Zoom into mapCenter.
        let camera = MGLMapCamera(lookingAtCenterCoordinate: mapCenter!, fromDistance: 14500, pitch: 0, heading: 0)
        mapboxView.setCenterCoordinate(mapCenter!, zoomLevel: 10, direction: 0, animated: false)
        mapboxView.setCamera(camera, withDuration: 5, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    }
    
    func addLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    func addProfile() {
        profileView.profileState = ProfileState.ProfileClosed
        profileClosedValues()
        
        // Configure the profile view.
        profileView.backgroundColor = UIColor.whiteColor()
        profileView.layer.cornerRadius = profileView.frame.width / 2
        profileView.layer.masksToBounds = true
        
        // Set the profile pic image view corner radius.
        profileView.profilePicImageView.layer.cornerRadius = profileView.profilePicImageView.frame.width / 2
        profileView.profilePicImageView.layer.masksToBounds = true
        
        // Configure the profile button.
        profileButton.addTarget(self, action: "toggleProfile", forControlEvents: UIControlEvents.TouchUpInside)
        profileButton.backgroundColor = UIColor.clearColor()
        profileButton.titleLabel!.font = UIFont.boldSystemFontOfSize(18)
        
        view.addSubview(profileView)
        view.addSubview(profileButton)
    }
    
    func toggleProfile() {
        if profileView.profileState == ProfileState.ProfileClosed {
            openProfile()
        } else {
            closeProfile()
        }
    }
    
    func openProfile() {
        self.profileView.profileState = ProfileState.ProfileOpen

        // Animate the profile opening and its content appearing after.
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.profileOpenValues()
            
            UIView.animateWithDuration(0.15, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                
                self.profileButton.setTitle("close", forState: UIControlState.Normal)

                }, completion: { (Bool) -> Void in
                    self.profileContentHiddenValues()
            })
            
            }) { (Bool) -> Void in
                self.showProfileContent()
        }
    }
    
    func closeProfile() {
        self.profileView.profileState = ProfileState.ProfileClosed
        self.hideProfileContent()

        // Hide all the profile content and then animate the profile closed.
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.profileClosedValues()
            
            }) { (Bool) -> Void in
                return
        }
    }
    
    func showProfileContent() {
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.profileLabelsShownValues()
            
            UIView.animateWithDuration(0.1, delay: 0.3, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                
                self.ratingImageViewShownValues()
                
                }, completion: { (Bool) -> Void in
                    return
            })
            
            }) { (Bool) -> Void in
                return
        }
    }
    
    func hideProfileContent() {
        self.profileContentHiddenValues()
    }
    
    
    
    // MARK: Profile Values
    
    func profileClosedValues() {
        // Profile view
        self.profileView.frame = CGRectMake(self.edgePadding, self.edgePadding + 5, self.view.frame.width * 0.15, self.view.frame.width * 0.15)
        
        // Profile button
        self.profileButton.frame = CGRectMake(self.profileView.frame.origin.x, self.profileView.frame.origin.y, self.profileView.frame.width, self.profileView.frame.height)
        self.profileButton.setTitle("", forState: UIControlState.Normal)
        self.profileButton.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
        
        // Profile pic
        self.profileView.profilePicImageView.frame = CGRectMake(2, 2, self.profileView.frame.width - 4, self.profileView.frame.height - 4)
    }
    
    func profileContentHiddenValues() {
        // Name label
        self.profileView.nameLabel.frame = CGRectMake(self.profileView.profilePicImageView.frame.width + self.edgePadding * 2, self.profileView.profilePicImageView.frame.maxY - 40, self.profileView.frame.width - self.profileView.profilePicImageView.frame.width - self.edgePadding * 3, 0)
        
        // Rating view
        self.profileView.ratingImageView.frame = CGRectMake(self.profileView.profilePicImageView.frame.width + self.edgePadding * 2 + 8, self.profileView.nameLabel.frame.origin.y, self.profileView.nameLabel.frame.width * 0.9, 0)
        
        // Host count label
        self.profileView.hostCountLabel.frame = CGRectMake(self.edgePadding, self.profileView.profilePicImageView.frame.maxY + self.edgePadding, self.profileView.frame.width - self.edgePadding * 2, 0)
        
        // Attend count label
        self.profileView.attendCountLabel.frame = CGRectMake(self.edgePadding, self.profileView.hostCountLabel.frame.maxY + self.edgePadding, self.profileView.frame.width - self.edgePadding * 2, 0)

    }
    
    func profileOpenValues() {
        // Profile view
        self.profileView.frame = CGRectMake(self.edgePadding, self.edgePadding + 5, self.view.frame.width - self.edgePadding * 2, self.view.frame.width - self.edgePadding * 2)
        
        // Profile button
        self.profileButton.frame = CGRectMake(self.profileView.frame.width - 45 - self.edgePadding, self.profileView.frame.origin.y + self.edgePadding, 50, 30)
        self.profileButton.setTitleColor(UIColor(red: 192/255.0, green: 57/255.0, blue: 43/255.0, alpha: 1), forState: UIControlState.Normal)
        
        // Profile pic image view
        self.profileView.profilePicImageView.frame = CGRectMake(self.edgePadding, self.edgePadding, self.profileView.frame.width * 0.3, self.profileView.frame.width * 0.3)
    }
    
    func profileLabelsShownValues() {
        // Name label
        self.profileView.nameLabel.frame = CGRectMake(self.profileView.profilePicImageView.frame.width + self.edgePadding * 2, self.profileView.profilePicImageView.frame.maxY - 40, self.profileView.frame.width - self.profileView.profilePicImageView.frame.width - self.edgePadding * 3, 40)
        self.profileView.nameLabel.text = "Andrew Carvajal"
        
        // Host count label
        self.profileView.hostCountLabel.frame = CGRectMake(self.edgePadding, self.profileView.profilePicImageView.frame.maxY + self.edgePadding, self.profileView.frame.width - self.edgePadding * 2, 20)
        
        // Attend count label
        self.profileView.attendCountLabel.frame = CGRectMake(self.edgePadding, self.profileView.hostCountLabel.frame.maxY + self.innerPadding, self.profileView.frame.width - self.edgePadding * 2, 20)
    }
    
    func ratingImageViewShownValues() {
        self.profileView.ratingImageView.frame = CGRectMake(self.profileView.profilePicImageView.frame.width + self.edgePadding * 2 + 8, self.profileView.nameLabel.frame.origin.y - 40, self.profileView.ratingImageView.frame.width, 40)
    }
}
