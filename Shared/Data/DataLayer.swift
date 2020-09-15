//
//  DataLayer.swift
//  Weather
//
//  Created by Trey Tartt on 9/13/20.
//

import Foundation
import CoreLocation
import NationalWeatherService

protocol DataWorkable : ObservableObject {
    init()
    var locationDesc : String { get set }
    var currentWeather : Forecast? { get set }
}

public class DataLayer : DataWorkable {
    required public init(){}
    @Published var locationDesc: String = Constants.locationDesc
    @Published var currentWeather : Forecast?
}



