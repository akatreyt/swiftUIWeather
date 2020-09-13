//
//  Network.swift
//  Weather (iOS)
//
//  Created by Trey Tartt on 9/12/20.
//

import Foundation
import CoreLocation

public typealias WeatherReturn = Result<WeatherData, Error>

struct MyNetwork{
    static let fetch : NetworkFetchable.Type = NetworkFetch.self
}

protocol NetworkFetchable {
    func fetchCurrentWeather(forLocation location:CLLocation, completion: @escaping (WeatherReturn) -> Void)
}

public class NetworkFetch : NetworkFetchable{
    public init(){}
    
    public func fetchCurrentWeather(forLocation location:CLLocation, completion: @escaping (WeatherReturn) -> Void) {
        let realURL = URL(string: "https://api.lil.software/weather?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)")!
       
        let url = URL(string: "https://api.lil.software/weather?latitude=40.709335&longitude=-73.956558")!
        URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let _ = response else {
                // Handle Empty Response
                return
            }
            guard let data = data else {
                // Handle Empty Data
                return
            }
            let weather: WeatherData = try! JSONDecoder().decode(WeatherData.self, from: data)
            completion(.success(weather))
        }.resume()
    }
}
