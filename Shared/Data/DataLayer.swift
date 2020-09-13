//
//  DataLayer.swift
//  Weather
//
//  Created by Trey Tartt on 9/13/20.
//

import Foundation
import CoreLocation

protocol DataLayer : ObservableObject {
    var currentWeather : WeatherData? { get }
}

public class RealDataLayer : DataLayer, LocationManagerDelegate {
    private var lm = LocationManager()
    private let network = NetworkFetch()
    @Published public var currentWeather : WeatherData?
    
    public init(){
        lm.delegate = self
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
    var currentWeather: WeatherData? =  MockDataLayer.createMockWeather()
    
    private static func createMockWeather()->WeatherData{
        let path = Bundle.main.path(forResource: "Sample", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let weather: WeatherData = try! JSONDecoder().decode(WeatherData.self, from: data)
        return weather
    }
}

public class MockEmptyWeatherDataLayer : DataLayer{
    var currentWeather: WeatherData?
}
