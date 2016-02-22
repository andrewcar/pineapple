//
//  MapViewController.swift
//  Pineapple
//
//  Created by Andrew Carvajal on 2/7/16.
//  Copyright © 2016 Andrew Carvajal. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate {
    
    var mapboxView: MGLMapView!
    var locationManager: CLLocationManager = CLLocationManager()
    var mapCenter: CLLocationCoordinate2D?
    var profileView = ProfileView()
    var profileButton = UIButton()
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMap()
        setCamera()
        addLocationManager()
        addProfileButton()
    }
    
    // MARK: Helper Functions
    
    func addMap() {
        mapboxView = MGLMapView(frame: view.bounds)
        mapboxView.delegate = self
        mapboxView.styleURL = NSURL(string: "mapbox://styles/andrewcar/cigjifhox00059em63qbqemcm")
        mapboxView.showsUserLocation = true
        mapboxView.tintColor = UIColor.clearColor()
        mapboxView.allowsRotating = false
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
    
    func addProfileButton() {
        profileView = ProfileView(frame: CGRectMake(20, 20, view.frame.width * 0.15, view.frame.width * 0.15))
        profileView.backgroundColor = UIColor.whiteColor()
        profileView.layer.cornerRadius = profileView.frame.width / 2
        profileView.layer.masksToBounds = true
                
        profileButton = UIButton(frame: CGRectMake(profileView.frame.origin.x, profileView.frame.origin.y, profileView.frame.width, profileView.frame.height))
        profileButton.addTarget(self, action: "closeOrOpenProfile", forControlEvents: UIControlEvents.TouchUpInside)
        mapboxView.addSubview(profileView)
        profileView.addSubview(profileButton)
    }
    
    func closeOrOpenProfile() {
        if profileView.profileState == ProfileState.ProfileClosed {
            openProfile()
        } else {
            closeProfile()
        }
    }
    
    func openProfile() {
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
        
            // Profile view
            self.profileView.frame = CGRectMake(20, 20, self.view.frame.width - 40, self.view.frame.width - 40)
            self.profileView.profilePicImageView.frame = CGRectMake(20, 20, self.profileView.frame.width * 0.3, self.profileView.frame.width * 0.3)
            
            // Profile button
            self.profileButton.setTitle("close", forState: UIControlState.Normal)
            self.profileButton.frame = CGRectMake(self.profileView.frame.width - 70, self.profileView.frame.origin.y, 50, 30)
            self.profileButton.setTitleColor(UIColor(red: 192/255.0, green: 57/255.0, blue: 43/255.0, alpha: 1), forState: UIControlState.Normal)
            self.profileButton.titleLabel!.font = UIFont.boldSystemFontOfSize(18)
            }) { (Bool) -> Void in
                self.profileView.profileState = ProfileState.ProfileOpen
        }
    }
    
    func closeProfile() {
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            // Profile view
            self.profileView.frame = CGRectMake(20, 20, self.view.frame.width * 0.15, self.view.frame.width * 0.15)
            self.profileView.profilePicImageView.frame = CGRectMake(2, 2, self.profileView.frame.width - 4, self.profileView.frame.height - 4)
            
            // Profile button
            self.profileButton.frame = CGRectMake(self.profileView.frame.origin.x, self.profileView.frame.origin.y, self.profileView.frame.width, self.profileView.frame.height)
            self.profileButton.backgroundColor = UIColor.clearColor()
            self.profileButton.setTitle("", forState: UIControlState.Normal)
            self.profileButton.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
            }) { (Bool) -> Void in
                self.profileView.profileState = ProfileState.ProfileClosed
        }
    }
}
