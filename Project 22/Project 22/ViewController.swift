//
//  ViewController.swift
//  Project 22
//
//  Created by Tee Becker on 9/15/20.
//  Intro to Core Location, CLBeaconRegion, and iBeacon

import UIKit        //framework
import CoreLocation //framework

class ViewController: UIViewController, CLLocationManagerDelegate {
    // core location class that lets us configure how we want to be notified about location, and deliver updates to us. 
    var locationManager: CLLocationManager?
    var uuidStrings = [String]()
    
    // this label will show one of 4 messages dependsing on how close we are to our test beacon
    @IBOutlet weak var distanceReading: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .lightGray
        
        distanceReading.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            distanceReading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            distanceReading.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        uuidStrings += ["E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"]
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager, status: CLAuthorizationStatus) {
        //did we get authorized by user? / is device available to monitor iBeacons? / is ranging available to tell roughly how far something is from device?
        if status == .authorizedAlways{
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
                if CLLocationManager.isRangingAvailable(){
                    // do work ONLY AFTER we have permission to do so and met all other requirements above(permission, monitor, ranging)
                    startScanning()
                    
                }
            }
        }
    }
    
    func startScanning(){
        
        //UUID - universally unique ID + major and minor number
        //For example, all apple stores have the same UUID number, a different Major for different branch ( SF store, pleasnton store), and a minor(optional) for each department ( ipad section, macbook section)
        
        let uuidString = UUID(uuidString: uuidStrings[0])!
        let beaconRegion = CLBeaconRegion(uuid: uuidString, major: 123, identifier: "smolIpadBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: uuidString))
    }
    
    func update(distance: CLProximity){
        
        UIView.animate(withDuration: 1){
            
            switch distance{
            
            case .far:
                self.view.backgroundColor = UIColor.yellow
                self.distanceReading.text = "STILL KINDA FAR "
                    
            case .near:
                self.view.backgroundColor = UIColor.systemTeal
                self.distanceReading.text = "YOU ARE NEAR BY"
                
            case .immediate:
                self.view.backgroundColor = UIColor.green
                self.distanceReading.text = "FOUND IT"
                
            default:
                self.view.backgroundColor = UIColor.lightGray
                self.distanceReading.text = "UNKNOWN"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first{
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
    
    
    
}

