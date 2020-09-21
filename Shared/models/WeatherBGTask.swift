//
//  BGTask.swift
//  Weather
//
//  Created by Trey Tartt on 9/21/20.
//

import Foundation

enum WeatherBGTask : String{
    case refreshWeather = "com.88oak.Weather.update"
}

struct WeatherQueues{
    static let updateQueue = DispatchQueue(label: "com.88oak.update", attributes: .concurrent)
}
