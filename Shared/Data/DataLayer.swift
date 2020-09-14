//
//  DataLayer.swift
//  Weather
//
//  Created by Trey Tartt on 9/13/20.
//

import Foundation
import CoreLocation
import NationalWeatherService

protocol DataLayer : ObservableObject {
    var currentWeather : Forecast? { get }
    var currentZipCode : String? {get}
}

public class RealDataLayer : DataLayer, LocationManagerDelegate {
    private var lm = LocationManager()
    private let network = NetworkFetch()
    
    @Published public var currentWeather : Forecast?
    @Published public var currentZipCode : String?
    
    
    public init(){
        lm.delegate = self
        lm.zipCodeCompletion = { (newZipCode:String?) in
            self.currentZipCode = newZipCode ?? "?"
        }
    }
    
    private func updateWeather(){
        let location = CLLocation(latitude: lm.userLatitude, longitude: lm.userLongitude)
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
}

extension RealDataLayer{
    func updatedLocation() {
        updateWeather()
    }
}

public class MockDataLayer : DataLayer{
    var currentZipCode: String? = "77445"
    
    var currentWeather: Forecast? =  MockDataLayer.createMockWeather()
    
    private static func createMockWeather()->Forecast{
        let path = Bundle.main.path(forResource: "Sample", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let weather: Forecast = try! JSONDecoder().decode(Forecast.self, from: data)
        return weather
    }
}

public class MockEmptyWeatherDataLayer : DataLayer{
    var currentZipCode: String?
    var currentWeather: Forecast?
}
