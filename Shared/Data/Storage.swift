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
    static func save<CodableGeneric:Codable>(item it : CodableGeneric) throws
    static func getLatest<CodableGeneric:Codable>(asType type : CodableGeneric.Type) throws -> CodableGeneric
}

public class CoreDataStorage : Storable {
    static func getLatest<CodableGeneric>(asType type: CodableGeneric.Type) throws -> CodableGeneric where CodableGeneric : Decodable, CodableGeneric : Encodable {
        throw NSError(domain: "", code: 33, userInfo: [:])
    }
    
    static func save<CodableGeneric:Codable>(item it : CodableGeneric) throws {
        print("save")
    }
    
    required public init(){}
}

public class PlistStorage : Storable{
    required init() {}
    
    static let fileURL = AppGroup.weather.containerURL.appendingPathComponent("weather.plist")
    
    static var encoder = PropertyListEncoder()
    static var decoder = PropertyListDecoder()
    
    static func save<CodableGeneric:Codable>(item it : CodableGeneric) throws{
        do {
            let data = try encoder.encode(it)
            try data.write(to: PlistStorage.fileURL)
        } catch {
            throw error
        }
    }
    
    static func getLatest<CodableGeneric>(asType type: CodableGeneric.Type) throws -> CodableGeneric where CodableGeneric : Decodable, CodableGeneric : Encodable {
        do {
            let data = try Data.init(contentsOf: PlistStorage.fileURL)
            return try decoder.decode(type.self, from: data)
        } catch {
            throw error
        }
    }
}

