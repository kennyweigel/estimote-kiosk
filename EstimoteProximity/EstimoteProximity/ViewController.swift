//
//  ViewController.swift
//  EstimoteProximity
//
//  Created by Kenneth Weigel on 3/20/15.
//  Copyright (c) 2015 Kenneth Weigel. All rights reserved.
//

import UIKit
// core location is required for estimotes
import CoreLocation

// ViewControll has CLLocationManagerDelegate delagate methods available
class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // outlet for
    @IBOutlet weak var currentVisitCount: UILabel!
    
    // core location manager instance
    let locationManager = CLLocationManager()
    
    // define the core location region, defines whic beacons our regions should care about
    // uses estimote default UUIDString
    // identifier is just arbitrary string
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D"), identifier: "Estimotes")
    
    // define colors based on Estimote Minor values
    let colors = [
        2638: UIColor(red: 158/255, green: 222/255, blue: 218/255, alpha: 1),// green
        64528: UIColor(red: 16/255, green: 194/255, blue: 230/255, alpha: 1),//sky blue
        56493: UIColor(red: 16/255, green: 105/255, blue: 230/255, alpha: 1)// dark blue
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // ViewController should be the delegate (where it should deliver messages) of the locationManager
        locationManager.delegate = self;
        
        // only request authorization if app hasn't already been authorized
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        // start monitoring region for beacons
        locationManager.startRangingBeaconsInRegion(region)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // want to be notified when relative beacon is found
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [CLBeacon]!, inRegion region: CLBeaconRegion!) {
        // strip unknown beacons to create a new array
        // closest beacon comes in first therefore we can assume the first item in array is closest
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        
        if (knownBeacons.count > 0) {
            // closest beacon accuracy value
            var closestAccuracy: CLLocationAccuracy = 1000
            
            // closest beacon, defaults to first beacon
            var closestBeacon: CLBeacon = knownBeacons[0]
            
            // find closest beacon
            for beacon in knownBeacons {
                if (beacon.accuracy > -1 && beacon.accuracy < closestAccuracy) {
                    closestAccuracy = beacon.accuracy
                    closestBeacon = beacon
                }
            }
            
            self.view.backgroundColor = self.colors[closestBeacon.minor.integerValue]
        }
    }
}
