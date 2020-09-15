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

protocol LocationManagable : ObservableObject{
    init()
    
    associatedtype Network : NetworkFetchable
    var publicNetwork : Network { get }
    
    associatedtype DataLayer : DataWorkable
    var publicDataLayer : DataLayer { get }
    
    var locationDescProxy : String? { get }
}


class LocationManager<NetworkFetcherGeneric, DataLayerGeneric>: NSObject, LocationManagable, CLLocationManagerDelegate where NetworkFetcherGeneric:NetworkFetchable, DataLayerGeneric:DataWorkable{
    required override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        locationDescProxy = publicDataLayer.locationDesc
    }
    
    typealias Network = NetworkFetcherGeneric
    public var publicNetwork = Network()
    
    typealias DataLayer = DataLayerGeneric
    public var publicDataLayer = DataLayer()
    @Published var locationDescProxy : String?
    
    private let locationManager = CLLocationManager()
    
    private func updateWeather(atLocation location:CLLocation){
        let location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        publicNetwork.fetchCurrentWeather(forLocation: location) { (weatherReturn) in
            switch weatherReturn{
            case .success(let newWeather):
                DispatchQueue.main.async {
                    self.publicDataLayer.currentWeather = newWeather
                    self.locationDescProxy = self.publicDataLayer.locationDesc
                }
            case .failure(_):
                print("error")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        updateWeather(atLocation: location)
        getZip(forLoction: location)
    }
    
    func getZip(forLoction location : CLLocation){
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Failed getting zip code: \(error)")
                self.publicDataLayer.locationDesc = Constants.locationDesc
                self.locationDescProxy = self.publicDataLayer.locationDesc
            }
            if let postalCode = placemarks?.first?.postalCode,
               let state = placemarks?.first?.administrativeArea,
               let locality = placemarks?.first?.locality{
                self.publicDataLayer.locationDesc = locality + "," + state + " - " + postalCode
                self.locationDescProxy = self.publicDataLayer.locationDesc
            } else {
                print("Failed getting zip code from placemark(s): \(placemarks?.description ?? "nil")")
                self.publicDataLayer.locationDesc = Constants.locationDesc
                self.locationDescProxy = self.publicDataLayer.locationDesc
            }
        }
    }
}


class MockLocationLayer<NetworkFetcherGeneric, DataLayerGeneric> : LocationManagable where NetworkFetcherGeneric:NetworkFetchable, DataLayerGeneric:DataWorkable{
    
    required init() {
        locationDescProxy = publicDataLayer.locationDesc
    }
    var locationDescProxy: String?
    
    typealias Network = NetworkFetcherGeneric
    public var publicNetwork = Network()
    
    typealias DataLayer = DataLayerGeneric
    public var publicDataLayer = DataLayer()
    
    var currentWeather: Forecast? =  MockLocationLayer.createMockWeather()
    
    private static func createMockWeather()->Forecast{
        let path = Bundle.main.path(forResource: "Sample", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let weather: Forecast = try! JSONDecoder().decode(Forecast.self, from: data)
        return weather
    }
}

class MockEmptyLocationData<NetworkFetcherGeneric, DataLayerGeneric> : LocationManagable where NetworkFetcherGeneric:NetworkFetchable, DataLayerGeneric:DataWorkable{
    required init() {
        locationDescProxy = publicDataLayer.locationDesc
    }
    var locationDescProxy: String?
    
    typealias Network = NetworkFetcherGeneric
    public var publicNetwork = Network()
    
    typealias DataLayer = DataLayerGeneric
    public var publicDataLayer = DataLayer()
    
    var currentWeather: Forecast?
}
