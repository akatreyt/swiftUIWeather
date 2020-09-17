//
//  DataLayer.swift
//  Weather
//
//  Created by Trey Tartt on 9/13/20.
//

import Foundation
import CoreLocation
import NationalWeatherService

public enum AppGroup: String {
  case weather = "group.com.88oak.weather"

  public var containerURL: URL {
    switch self {
    case .weather:
      return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.rawValue)!
    }
  }
}

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
    
    static let fileURL = AppGroup.weather.containerURL.appendingPathComponent("weather.plist")
    
    static var encoder = PropertyListEncoder()
    static var decoder = PropertyListDecoder()
    
    static func getLatestForcast() throws -> CompleteWeather {
        do {
            let data = try Data.init(contentsOf: PlistStorage.fileURL)
            return try decoder.decode(CompleteWeather.self, from: data)
        } catch {
            throw error
        }
    }
    
    static func save(completeWeather cw : CompleteWeather) throws{
        do {
            let data = try encoder.encode(cw)
            try data.write(to: PlistStorage.fileURL)
        } catch {
            throw error
        }
    }
}

