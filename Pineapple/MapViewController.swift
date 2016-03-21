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
import AVFoundation

enum FeedState {
    case FeedHidden
    case FeedMinimized
    case FeedShowing
}

class MapViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    var feedState = FeedState?()
    
    var feedPan = UIPanGestureRecognizer()

    var openProfileSound: AVAudioPlayer!
    var closeProfileSound: AVAudioPlayer!

    var lastLocation: CGPoint = CGPointMake(0, 0)
    var padding: CGFloat = 20
    var profileClosedWidth = CGFloat()
    var profileOpenWidth = CGFloat()
    var labelWidth = CGFloat()
    var switchSize = CGSize()
    var feedHiddenHeight = CGFloat()
    var feedShowingHeight = CGFloat()
    
    var locationManager = CLLocationManager()
    var mapboxView: MGLMapView!
    var mapCenter: CLLocationCoordinate2D?
    var profileView = ProfileView()
    var profileButton = UIButton()
    var feedView = FeedView()
    
    // MARK: View Lifecycle
    
    override func awakeFromNib() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateProfilePic", name: "GotCurrentProfilePic", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateProfileUserName", name: "GotCurrentUserName", object: nil)
        DataSource.sharedInstance.getCurrentProfilePic()
        DataSource.sharedInstance.getCurrentUserName()
        view.userInteractionEnabled = true
        view.addGestureRecognizer(feedPan)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        feedState = .FeedMinimized
        feedPan = UIPanGestureRecognizer(target: self, action: "panDetected:")
        profileOpenWidth = self.view.frame.width - self.padding * 2
        
        addSounds()
        addMap()
        addProfile()
        setCamera()
        addLocationManager()
        addFeed()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.updateFeedMeetingPointLabel()
        self.updateFeedCurrentPlaceLabel()
    }
    
    // MARK: Helper Functions
    
    // MARK: --MAP
    
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
    
    // MARK: --PROFILE
    
    func addProfile() {
        profileView.profileState = ProfileState.ProfileClosed
        profileClosedValues()
        profileContentHiddenValues()
        
        profileView.layer.cornerRadius = profileView.frame.width / 2
        profileView.layer.masksToBounds = true

        profileView.profilePicImageView.layer.cornerRadius = profileView.profilePicImageView.frame.width / 2
        profileView.profilePicImageView.layer.masksToBounds = true
        
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
        
        playAudioFile("FartSound", type: "m4a")

        // Animate the profile opening and then its content appearing.
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
        
        playAudioFile("Pop", type: "m4a")

        // Hide all the profile content and then animate the profile closed.
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.profileClosedValues()
            
            }) { (Bool) -> Void in
                self.profileContentHiddenValues()
        }
    }
    
    func showProfileContent() {
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.profileLabelsShownValues()
            
            UIView.animateWithDuration(0.1, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                
                self.ratingImageViewShownValues()
                self.profileView.showLocationSwitch.setOn(true, animated: true)
                
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
    
    func updateProfilePic() {
        self.profileView.profilePicImageView.image = DataSource.sharedInstance.profilePic
    }
    
    func updateProfileUserName() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.profileView.nameLabel.text = DataSource.sharedInstance.userName
            })
        })
    }
    
    // MARK: --FEED
    
    func addFeed() {
        self.feedView = FeedView(frame: CGRectMake(0, self.view.frame.maxY - self.feedView.partyListViewMaxY, self.view.frame.width, self.view.frame.height))
        self.view.addSubview(self.feedView)
    }
    
    func toggleFeed() {
        if feedState == .FeedMinimized {
            
        } else if feedState == .FeedShowing {
            
        }
    }
    
    func updateFeedMeetingPointLabel() {
        self.feedView.meetingPointLabel.text = "Meet out front at 2:00 AM"
    }
    
    func updateFeedCurrentPlaceLabel() {
        self.feedView.currentPlaceLabel.text = "Pianos"
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    // MARK: UIGestureRecognizerDelegate
    
    func panDetected(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(feedView)
        
        if feedView.frame.contains(sender.locationInView(sender.view)) {
            feedView.center = CGPointMake(lastLocation.x, lastLocation.y + translation.y)
        }
        
        if feedPan.state == UIGestureRecognizerState.Began {
            UIView.animateWithDuration(2, animations: { () -> Void in
                }, completion: { (Bool) -> Void in
                    return
            })
        }
        
        if feedPan.state == UIGestureRecognizerState.Ended {
            
            if feedView.frame.contains(sender.locationInView(sender.view)) {
                
                if translation.y > 360 {
                    UIView.animateWithDuration(0.426, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                        self.feedView.frame = CGRectMake(0, self.view.frame.height - self.feedView.partyListView.frame.maxY, self.feedView.frame.width, self.feedView.frame.height)
                        }, completion: { (Bool) -> Void in
                            self.feedState = .FeedShowing
                    })
                } else {
                    UIView.animateWithDuration(0.426, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                        self.feedView.frame = CGRectMake(0, self.view.frame.origin.y, self.feedView.frame.width, self.feedView.frame.height)
                        }, completion: { (Bool) -> Void in
                            return
                    })
                }
            } else {
                return
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.bringSubviewToFront(feedView)
        lastLocation = feedView.center
    }
    
    // MARK: Sound
    
    func addSounds() {
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.otherAudioPlaying {
            _ = try? audioSession.setCategory(AVAudioSessionCategoryAmbient, withOptions: .MixWithOthers)
            _ = try? audioSession.setActive(true, withOptions: [])
        }
    }
    
    func playAudioFile(file: NSString, type: NSString) {
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)!
        let url = NSURL.fileURLWithPath(path)
        
        do {
            let sound = try AVAudioPlayer(contentsOfURL: url)
            openProfileSound = sound
            sound.play()
        } catch {
            print("Player not available")
        }
    }
    
    // MARK: Profile Animation Values
    
    func profileClosedValues() {
        // Profile view
        self.profileView.frame = CGRectMake(self.padding, self.padding + 5, self.view.frame.width * 0.15, self.view.frame.width * 0.15)
        self.profileClosedWidth = self.profileView.frame.width
        
        // Profile button
        self.profileButton.frame = CGRectMake(self.profileView.frame.origin.x, self.profileView.frame.origin.y, self.profileClosedWidth, self.profileView.frame.height)
        self.profileButton.setTitle("", forState: UIControlState.Normal)
        self.profileButton.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
        
        // Profile pic
        self.profileView.profilePicImageView.frame = CGRectMake(2, 2, self.profileClosedWidth - 4, self.profileView.frame.height - 4)
        
        self.profileView.showLocationSwitch.hidden = true
    }
    
    func profileContentHiddenValues() {
        // Name label
        self.profileView.nameLabel.frame = CGRectMake(self.profileView.profilePicImageView.frame.width + self.padding * 2, self.profileView.profilePicImageView.frame.maxY - 40, self.profileOpenWidth - self.profileView.profilePicImageView.frame.width - self.padding * 3, 0)
        
        // Rating view
        self.profileView.ratingImageView.frame = CGRectMake(self.profileView.bounds.maxX, self.profileView.nameLabel.frame.origin.y - 40, self.profileView.nameLabel.frame.width * 0.9, 40)
        
        // Host count label
        self.profileView.hostCountLabel.frame = CGRectMake(self.padding, self.profileView.profilePicImageView.frame.maxY + self.padding, self.profileOpenWidth - self.padding * 2, 0)
        
        // Attend count label
        self.profileView.attendCountLabel.frame = CGRectMake(self.padding, self.profileView.hostCountLabel.frame.maxY + self.padding, self.profileOpenWidth - self.padding * 2, 0)
        
        labelWidth = self.profileOpenWidth - self.profileView.showLocationSwitch.frame.width - self.padding * 2
        switchSize = CGSizeMake(CGRectGetWidth(self.profileView.showLocationSwitch.frame), CGRectGetHeight(self.profileView.showLocationSwitch.frame))
        
        // Show location label
        self.profileView.showLocationLabel.frame = CGRectMake(self.profileView.showLocationSwitch.frame.minX - labelWidth - self.padding * 2, self.profileView.attendCountLabel.frame.maxY + 10, labelWidth, 0)
        
        // Show location switch
        self.profileView.showLocationSwitch.frame = CGRectMake(self.profileView.frame.maxX - self.switchSize.width - self.padding * 2, self.profileView.attendCountLabel.frame.maxY + 10, self.switchSize.width, self.profileView.showLocationSwitch.frame.height)
        self.profileView.showLocationSwitch.hidden = true
    }
    
    func profileOpenValues() {
        // Profile view
        self.profileView.frame = CGRectMake(self.padding, self.padding + 5, self.view.frame.width - self.padding * 2, self.view.frame.width - self.padding * 2)
        
        // Profile button
        self.profileButton.frame = CGRectMake(self.profileOpenWidth - 45 - self.padding, self.profileView.frame.origin.y + self.padding, 50, 30)
        self.profileButton.setTitleColor(UIColor(red: 192/255.0, green: 57/255.0, blue: 43/255.0, alpha: 1), forState: UIControlState.Normal)
        
        // Profile pic image view
        self.profileView.profilePicImageView.frame = CGRectMake(self.padding, self.padding, self.profileOpenWidth * 0.3, self.profileOpenWidth * 0.3)
    }
    
    func profileLabelsShownValues() {
        // Name label
        self.profileView.nameLabel.frame = CGRectMake(self.profileView.profilePicImageView.frame.width + self.padding * 2, self.profileView.profilePicImageView.frame.maxY - 40, self.profileOpenWidth - self.profileView.profilePicImageView.frame.width - self.padding * 3, 40)
        
        // Host count label
        self.profileView.hostCountLabel.frame = CGRectMake(self.padding, self.profileView.profilePicImageView.frame.maxY + self.padding, self.profileOpenWidth - self.padding * 2, 22)
        
        // Attend count label
        self.profileView.attendCountLabel.frame = CGRectMake(self.padding, self.profileView.hostCountLabel.frame.maxY + 10, self.profileOpenWidth - self.padding * 2, 22)

        // Show location switch
        self.profileView.showLocationSwitch.frame = CGRectMake(self.profileView.frame.maxX - self.switchSize.width - self.padding * 2 - 10, self.profileView.attendCountLabel.frame.maxY + self.padding, self.switchSize.width, self.profileView.showLocationSwitch.frame.height)
        self.profileView.showLocationSwitch.hidden = false

        // Show location label
        self.profileView.showLocationLabel.frame = CGRectMake(self.profileView.showLocationSwitch.frame.minX - labelWidth - self.padding * 2, self.profileView.attendCountLabel.frame.maxY + self.padding, labelWidth, self.switchSize.height)
    }
    
    func ratingImageViewShownValues() {
        self.profileView.ratingImageView.frame = CGRectMake(self.profileView.profilePicImageView.frame.width + self.padding * 2 + 8, self.profileView.nameLabel.frame.origin.y - 40, self.profileView.ratingImageView.frame.width, 40)
    }
    
    // MARK: Feed Animation Values
    
    func feedHiddenValues() {
        self.feedView.frame = CGRectMake(0, self.view.frame.maxY, self.view.frame.width, self.view.frame.height)
    }
    
    func feedMinimizedValues() {
        self.feedView.frame = CGRectMake(0, self.view.frame.maxY - self.feedView.partyListViewMaxY, self.view.frame.width, self.view.frame.height)
    }
    
    func feedShowingValues() {
        self.feedView.frame = CGRectMake(0, self.view.frame.minY, self.view.frame.width, self.view.frame.height)
    }
}
