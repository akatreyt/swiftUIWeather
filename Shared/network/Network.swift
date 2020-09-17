//
//  Network.swift
//  Weather (iOS)
//
//  Created by Trey Tartt on 9/12/20.
//

import Foundation
import CoreLocation
import NationalWeatherService
import CoreLocation

public typealias WeatherReturn = Result<Forecast, Error>

protocol NetworkFetchable {
    init()
    func fetchCurrentWeather(forLocation location:CLLocation, completion: @escaping (WeatherReturn) -> Void)
    func fetchHourlyFor(forLocation location:CLLocation, completion: @escaping (WeatherReturn) -> Void)
}

public class Network : NetworkFetchable{
    required public init(){}
    
    let nws = NationalWeatherService(userAgent: "(MyWeatherApp, mycontact@example.com)")
    
    public func fetchCurrentWeather(forLocation location:CLLocation, completion: @escaping (WeatherReturn) -> Void) {
        nws.forecast(for: location) { result in
            switch result {
            case .success(let forecast):
                completion(.success(forecast))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchHourlyFor(forLocation location:CLLocation, completion: @escaping (WeatherReturn) -> Void) {
        nws.hourlyForecast(for: location) { result in
            switch result {
            case .success(let forecast):
                completion(.success(forecast))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


public class MockNetwork : NetworkFetchable{
    var isFetching: Bool = false
    required public init(){}
    
    func fetchHourlyFor(forLocation location:CLLocation, completion: @escaping (WeatherReturn) -> Void) {
        
    }
    
    public func fetchCurrentWeather(forLocation location:CLLocation, completion: @escaping (WeatherReturn) -> Void) {
        let path = Bundle.main.path(forResource: "Sample", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let weather: Forecast = try! JSONDecoder().decode(Forecast.self, from: data)
        completion(.success(weather))
    }
}
