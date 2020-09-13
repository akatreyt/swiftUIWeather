//
//  LocationManager.swift
//  Weather
//
//  Created by Trey Tartt on 9/13/20.
//

import Foundation
import Combine
import CoreLocation

protocol LocationManagerDelegate : class {
    func updatedLocation()
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate{
    var userLatitude: Double = 0
    var userLongitude: Double = 0
    
    weak var delegate: LocationManagerDelegate?
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLatitude = location.coordinate.latitude
        userLongitude = location.coordinate.longitude
        if let _delegate = delegate{
            _delegate.updatedLocation()
        }
    }
}

