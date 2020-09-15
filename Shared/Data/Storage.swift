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
    var locationDesc : String { get set }
    var currentWeather : Forecast? { get set }
}

public class CoreDataStorage : Storable {
    required public init(){}
    
    var locationDesc: String = Constants.locationDesc
    var currentWeather : Forecast?
}

public class PlistStorage : Storable{
    required init() {}
    
    var locationDesc: String = Constants.locationDesc
    var currentWeather: Forecast?
}

