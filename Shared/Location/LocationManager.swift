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


protocol LocationManagable : ObservableObject{
    var currentWeather : Forecast? { get }
    var locationDesc : String { get }
}


class LocationManager: NSObject, LocationManagable, CLLocationManagerDelegate{
    @Published var currentWeather : Forecast?
    @Published var locationDesc : String = LocationManager.locationDescPlaceholder
    
    private static let locationDescPlaceholder = ""

        
    private let locationManager = CLLocationManager()
    
    private let network : NetworkFetchable = NetworkFetch()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    private func updateWeather(atLocation location:CLLocation){
        let location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        network.fetchCurrentWeather(forLocation: location) { (weatherReturn) in
            switch weatherReturn{
            case .success(let newWeather):
                DispatchQueue.main.async {
                    self.currentWeather = newWeather
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
                self.locationDesc = LocationManager.locationDescPlaceholder
            }
            if let postalCode = placemarks?.first?.postalCode,
               let state = placemarks?.first?.administrativeArea,
               let locality = placemarks?.first?.locality{
                self.locationDesc = locality + "," + state + " - " + postalCode
            } else {
                print("Failed getting zip code from placemark(s): \(placemarks?.description ?? "nil")")
                self.locationDesc = LocationManager.locationDescPlaceholder
            }
        }
    }
}


public class MockLocationLayer : LocationManagable{
    required public init(){}
    var locationDesc: String = "Hempstead, TX - 77445"
    
    var currentWeather: Forecast? =  MockLocationLayer.createMockWeather()
    
    private static func createMockWeather()->Forecast{
        let path = Bundle.main.path(forResource: "Sample", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let weather: Forecast = try! JSONDecoder().decode(Forecast.self, from: data)
        return weather
    }
}

public class MockEmptyLocationData : LocationManagable{
    required public init(){}
    var locationDesc: String = ""
    var currentWeather: Forecast?
}
