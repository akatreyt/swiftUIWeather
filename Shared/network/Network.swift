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

protocol NetworkFetchable : ObservableObject {
    init()
    var isFetching: Bool { get }
    func fetchCurrentWeather(forLocation location:CLLocation, completion: @escaping (WeatherReturn) -> Void)
}

public class NetworkFetch : NetworkFetchable{
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


public class MockNetworkFetch : NetworkFetchable{
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
