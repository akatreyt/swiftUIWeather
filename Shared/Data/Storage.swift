//
//  DataLayer.swift
//  Weather
//
//  Created by Trey Tartt on 9/13/20.
//

import Foundation
import CoreLocation
import NationalWeatherService

protocol Storable {
    init()
    static func save(forecast fc : Forecast) throws
    
    static func getLatestForcast() throws -> Forecast
}

public class CoreDataStorage : Storable {
    static func getLatestForcast() throws -> Forecast {
        throw NSError(domain: "", code: 33, userInfo: [:])
    }
    
    required public init(){}
    
    class func save(forecast fc : Forecast) throws{
        print("save")
    }
}

public class PlistStorage : Storable{
    required init() {}
    
    static let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Weather.plist")
    
    static var encoder = PropertyListEncoder()
    static var decoder = PropertyListDecoder()
    
    static func getLatestForcast() throws -> Forecast {
        do {
            let data = try Data.init(contentsOf: fileURL!)
            return try decoder.decode(Forecast.self, from: data)
        } catch {
            throw error
        }
    }
    
    static func save(forecast fc : Forecast) throws{
        do {
            let data = try encoder.encode(fc)
            try data.write(to: PlistStorage.fileURL!)
        } catch {
            throw error
        }
    }
}

