//
//  CompleteWeather.swift
//  Weather
//
//  Created by Trey Tartt on 9/17/20.
//

import Foundation
import NationalWeatherService

struct CompleteWeather : Codable{
    var fullForecast : Forecast?
    var hourlyForecast : Forecast?
    var locationDesc : String = Constants.locationDesc
    
    func getHourly(forDate date : Date, includingNext next : Int) -> [Forecast.Period]{
        if let hourlyPeriods = hourlyForecast?.periods{
            let period = hourlyPeriods.filter({
                ($0.startTime ... $0.endTime).contains(date)
            }).first
            
            if let _period = period,
               let startIdx = hourlyPeriods.firstIndex(where: { $0.startTime == _period.startTime }){
                var endIdx = 0
                if startIdx+next < hourlyPeriods.count{
                    endIdx = startIdx+next
                }else{
                    endIdx = hourlyPeriods.count-1
                }
                let items = hourlyForecast?.periods[startIdx..<endIdx]
                return Array(items!)
            }
        }
        return [Forecast.Period]()
    }
}

