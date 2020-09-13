//
//  Forecase.swift
//  Weather (iOS)
//
//  Created by Trey Tartt on 9/12/20.
//

import Foundation

public struct Forecast: Codable, Identifiable {
    public var id = UUID()
    
    let name: String
    let temperature: Int
    let unit: Unit
    let forecastDescription: String
    
    enum CodingKeys: String, CodingKey {
        case name, temperature, unit
        case forecastDescription = "description"
    }
}
