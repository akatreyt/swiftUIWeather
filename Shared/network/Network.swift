//
//  Network.swift
//  Weather (iOS)
//
//  Created by Trey Tartt on 9/12/20.
//

import Foundation
import CoreLocation
import NationalWeatherService

public typealias WeatherReturn = Result<Forecast, Error>

protocol NetworkFetchable {
    init()
    var isFetching: Bool { get }
    func fetchCurrentWeather(forLocation location:CLLocation, completion: @escaping (WeatherReturn) -> Void)
}

public class Network : NetworkFetchable{
    var isFetching: Bool = false
    
    required public init(){}
    
    let nws = NationalWeatherService(userAgent: "(MyWeatherApp, mycontact@example.com)")
    
    public func fetchCurrentWeather(forLocation location:CLLocation, completion: @escaping (WeatherReturn) -> Void) {
        isFetching = true
        nws.forecast(for: location) { result in
            switch result {
            case .success(let forecast):
                completion(.success(forecast))
            case .failure(let error):
                completion(.failure(error))
            }
            self.isFetching = false
        }
    }
}


public class MockNetwork : NetworkFetchable{
    var isFetching: Bool = false
    required public init(){}
    
    public func fetchCurrentWeather(forLocation location:CLLocation, completion: @escaping (WeatherReturn) -> Void) {
        isFetching = true
        let path = Bundle.main.path(forResource: "Sample", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let weather: Forecast = try! JSONDecoder().decode(Forecast.self, from: data)
        isFetching = false
        completion(.success(weather))
    }
    
    public func fetchSampleForecast() -> Forecast{
        let path = Bundle.main.path(forResource: "Sample", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let weather: Forecast = try! JSONDecoder().decode(Forecast.self, from: data)
        return weather
    }
}
