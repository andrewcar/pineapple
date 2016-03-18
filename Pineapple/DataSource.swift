//
//  DataSource.swift
//  Pineapple
//
//  Created by Andrew Carvajal on 2/27/16.
//  Copyright © 2016 Andrew Carvajal. All rights reserved.
//

import UIKit
import MapKit
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON

class DataSource {
    
    static let sharedInstance = DataSource()
    var profilePic = UIImage()
    var userName = String()
    var lastHood: String?

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
    
    func getCurrentHoodName(currentLocation: CLLocationCoordinate2D) -> String {
        var filePath = String()
        
        // Based on user loc, point to varying GeoJSON files.
        filePath = NSBundle.mainBundle().pathForResource("manualNYC", ofType: "geojson")!

        let data = NSData(contentsOfFile: filePath)
        let json = JSON(data: data!)
        
        if lastHood == nil {
            lastHood = currentHoodNameFromAllHoods(currentLocation)
        } else {
            // 1. check against same hood
            // 2. check against neighboring hoods
            for (_, jsonHood) in json["features"] {
                var coords: [CLLocationCoordinate2D] = []
                
                if let geometryDict = jsonHood["geometry"].dictionary {
                    if let coordsArray = geometryDict["coordinates"]!.array {
                        for nextCoordsArray in coordsArray {
                            for coord in nextCoordsArray {
                                let latitude = CLLocationDegrees(coord.1[1].double!)
                                let longitutde = CLLocationDegrees(coord.1[0].double!)
                                coords.append(CLLocationCoordinate2DMake(latitude, longitutde))
                            }
                        }
                        let polygon = MKPolygon(coordinates: &coords, count: coords.count)
                        let polygonRenderer = MKPolygonRenderer(polygon: polygon)
                        
                        let currentMapPoint: MKMapPoint = MKMapPointForCoordinate(currentLocation)
                        let polygonViewPoint: CGPoint = polygonRenderer.pointForMapPoint(currentMapPoint)
                        
                        if CGPathContainsPoint(polygonRenderer.path, nil, polygonViewPoint, true) {
                            if let propertiesDict = jsonHood["properties"].dictionary {
                                if let name = propertiesDict["neighborhood"] {
                                    lastHood = String(name)
                                }
                            }
                        }
                    }
                }
            }
        }
        return lastHood!
    }
    
    func currentHoodNameFromAllHoods(currentLocation: CLLocationCoordinate2D) -> String {
        var filePath = String()
        
        // Based on user loc, point to varying GeoJSON files.
        if currentLocation.latitude > 24 && currentLocation.latitude < 31 {
            filePath = NSBundle.mainBundle().pathForResource("sofla", ofType: "geojson")!
        } else {
            filePath = NSBundle.mainBundle().pathForResource("manualNYC", ofType: "geojson")!
        }
        
        let data = NSData(contentsOfFile: filePath)
        let json = JSON(data: data!)
        
        // Check all hoods
        for (_, jsonHood) in json["features"] {
            var coords: [CLLocationCoordinate2D] = []
            
            if let geometryDict = jsonHood["geometry"].dictionary {
                if let coordsArray = geometryDict["coordinates"]!.array {
                    for nextCoordsArray in coordsArray {
                        for coord in nextCoordsArray {
                            let latitude = CLLocationDegrees(coord.1[1].double!)
                            let longitutde = CLLocationDegrees(coord.1[0].double!)
                            coords.append(CLLocationCoordinate2DMake(latitude, longitutde))
                        }
                    }
                    let polygon = MKPolygon(coordinates: &coords, count: coords.count)
                    let polygonRenderer = MKPolygonRenderer(polygon: polygon)
                    
                    let currentMapPoint: MKMapPoint = MKMapPointForCoordinate(currentLocation)
                    let polygonViewPoint: CGPoint = polygonRenderer.pointForMapPoint(currentMapPoint)
                    
                    if CGPathContainsPoint(polygonRenderer.path, nil, polygonViewPoint, true) {
                        if let propertiesDict = jsonHood["properties"].dictionary {
                            if let name = propertiesDict["neighborhood"] {
                                lastHood = String(name)
                                return lastHood!
                            }
                        }
                    }
                }
            }
        }
        return ""
    }
}