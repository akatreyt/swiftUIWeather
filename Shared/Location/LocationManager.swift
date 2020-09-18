//
//  LocationManager.swift
//  Weather
//
//  Created by Trey Tartt on 9/13/20.
//

import Foundation
import Combine
import CoreLocation
import NationalWeatherService
import SwiftUI


protocol Locatable{
    init(withUpdateLocationHandler handler : ((CLLocation) -> Void)?)
    var newLocationCompletion : ((CLLocation) -> Void)? { get set }
}


class LocationManager: NSObject, Locatable, CLLocationManagerDelegate {
    var newLocationCompletion: ((CLLocation) -> Void)?
    private let locationManager = CLLocationManager()
    private var lastLocation : CLLocation?
    
    required init(withUpdateLocationHandler handler : ((CLLocation) -> Void)?) {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
            
        if location.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        if location.horizontalAccuracy < 0 {
            return
        }
        var distance = CLLocationDistanceMax
        if let _last = lastLocation{
            distance = _last.distance(from: location)
        }
        
        if distance > 25 {
            lastLocation = location
            if let _comp = newLocationCompletion{
                _comp(location)
            }
        }
    }
}


class MockLocationManager: NSObject, Locatable, CLLocationManagerDelegate{
    var newLocationCompletion: ((CLLocation) -> Void)?
    
    required init(withUpdateLocationHandler handler : ((CLLocation) -> Void)?) {
        newLocationCompletion = handler
        
        super.init()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if let _comp = self.newLocationCompletion{
                _comp(CLLocation(latitude: 33.031741, longitude: -97.078818))
            }
        }
    }
}

class MockEmptyLocationManager: NSObject, Locatable, CLLocationManagerDelegate{
    var newLocationCompletion: ((CLLocation) -> Void)?
    
    required init(withUpdateLocationHandler handler : ((CLLocation) -> Void)?) {
        newLocationCompletion = handler
        
        super.init()
    }
}

