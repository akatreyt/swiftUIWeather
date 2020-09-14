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
    public var zipcode:String?
    
    var zipCodeCompletion : ((String?) ->Void)?
    
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
        if let _comp = zipCodeCompletion{
            getZip(forLoction: location, completion: _comp)
        }
    }
    
    func getZip(forLoction location : CLLocation , completion: @escaping (String?) -> Void){
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Failed getting zip code: \(error)")
                completion(nil)
            }
            if let postalCode = placemarks?.first?.postalCode,
               let state = placemarks?.first?.administrativeArea,
               let locality = placemarks?.first?.locality{
                completion(locality + "," + state + " - " + postalCode)
            } else {
                print("Failed getting zip code from placemark(s): \(placemarks?.description ?? "nil")")
                completion(nil)
            }
        }
    }
}
