//
//  CompleteWeather.swift
//  Weather
//
//  Created by Trey Tartt on 9/17/20.
//

import Foundation
import NationalWeatherService
import UIKit

struct CompleteWeather : Codable{
    var fullForecast : Forecast?
    var hourlyForecast : Forecast?
    var locationDesc : String = Constants.locationDesc
    var lastFetch = Date()
    var latitude : Double?
    var longitdue : Double?
    
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
    
    func get(forDate date : Date) -> Forecast.Period?{
        if let hourlyPeriods = hourlyForecast?.periods{
            let period = hourlyPeriods.filter({
                ($0.startTime ... $0.endTime).contains(date)
            }).first
            
            return period
        }
        return nil
    }
}

extension Forecast.Period{
    func weatherIcon() -> UIImage{
        var image : UIImage = UIImage(systemName: "cloud.rain")!

        guard let firstCondition = self.conditions.first else {
            return image
        }
        
        switch firstCondition {
        case .skc:
            image = UIImage(systemName: "sun.min")!
        case .few:
            image = UIImage(systemName: "cloud.sun")!
        case .sct:
            image = UIImage(systemName: "cloud")!
        case .bkn:
            image = UIImage(systemName: "cloud")!
        case .ovc:
            image = UIImage(systemName: "cloud.drizzle")!
        case .wind_skc:
            image = UIImage(systemName: "cloud.sun")!
        case .wind_few:
            image = UIImage(systemName: "cloud.sun")!
        case .wind_sct:
            image = UIImage(systemName: "win")!
        case .wind_bkn:
            image = UIImage(systemName: "win")!
        case .wind_ovc:
            image = UIImage(systemName: "win")!
        case .snow:
            image = UIImage(systemName: "snow")!
        case .rain_snow:
            image = UIImage(systemName: "cloud.snow")!
        case .rain_sleet:
            image = UIImage(systemName: "cloud.snow")!
        case .snow_sleet:
            image = UIImage(systemName: "cloud.snow")!
        case .fzra:
            image = UIImage(systemName: "cloud.snow")!
        case .rain_fzra:
            image = UIImage(systemName: "cloud.snow")!
        case .snow_fzra:
            image = UIImage(systemName: "cloud.snow")!
        case .sleet:
            image = UIImage(systemName: "cloud.rain")!
        case .rain:
            image = UIImage(systemName: "cloud.rain")!
        case .rain_showers:
            image = UIImage(systemName: "cloud.rain")!
        case .rain_showers_hi:
            image = UIImage(systemName: "cloud.rain")!
        case .tsra:
            image = UIImage(systemName: "cloud.rain")!
        case .tsra_sct:
            image = UIImage(systemName: "cloud.rain")!
        case .tsra_hi:
            image = UIImage(systemName: "cloud.bolt.rain")!
        case .tornado:
            image = UIImage(systemName: "tornado")!
        case .hurricane:
            image = UIImage(systemName: "hurricane")!
        case .tropical_storm:
            image = UIImage(systemName: "tropicalstorm")!
        case .dust:
            image = UIImage(systemName: "sun.dust")!
        case .smoke:
            image = UIImage(systemName: "smoke")!
        case .haze:
            image = UIImage(systemName: "sun.haze")!
        case .hot:
            image = UIImage(systemName: "thermometer.sun")!
        case .cold:
            image = UIImage(systemName: "thermometer.snowflake")!
        case .blizzard:
            image = UIImage(systemName: "cloud.snow")!
        case .fog:
            image = UIImage(systemName: "cloud.fog")!
        case .other:
            image = UIImage(systemName: "exclamationmark.icloud")!
        }
        
        return image
    }
}
