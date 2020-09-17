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
    static func save(completeWeather cw : CompleteWeather) throws
    
    static func getLatestForcast() throws -> CompleteWeather
}

public class CoreDataStorage : Storable {
    static func getLatestForcast() throws -> CompleteWeather {
        throw NSError(domain: "", code: 33, userInfo: [:])
    }
    
    required public init(){}
    
    class func save(completeWeather cw : CompleteWeather) throws{
        print("save")
    }
}

public class PlistStorage : Storable{
    required init() {}
    
    static let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Weather.plist")
    
    static var encoder = PropertyListEncoder()
    static var decoder = PropertyListDecoder()
    
    static func getLatestForcast() throws -> CompleteWeather {
        do {
            let data = try Data.init(contentsOf: fileURL!)
            return try decoder.decode(CompleteWeather.self, from: data)
        } catch {
            throw error
        }
    }
    
    static func save(completeWeather cw : CompleteWeather) throws{
        do {
            let data = try encoder.encode(cw)
            try data.write(to: PlistStorage.fileURL!)
        } catch {
            throw error
        }
    }
}

