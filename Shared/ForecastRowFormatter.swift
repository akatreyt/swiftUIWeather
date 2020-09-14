//
//  ForecastRowFormatter.swift
//  Weather
//
//  Created by Trey Tartt on 9/13/20.
//

import Foundation
import NationalWeatherService

protocol RowFormattable {
    static func degreeToString(fromPeriod period: Forecast.Period, forTemp temp : TempType)->String
}

public class RowFormatter:RowFormattable{
    private static func convert(temp tmp:Double, to returnType:TempType)->Double{
        switch returnType {
        case .Fahrenheit:
            return tmp * 9 / 5 + 32
        case .Celcius:
            return (Double(tmp - 32)) * 5 / 9
        }
    }
    
    public static func degreeToString(fromPeriod period: Forecast.Period, forTemp temp : TempType)->String{
        switch temp {
        case .Fahrenheit:
            let cel = String(format: "%.0f", RowFormatter.convert(temp: period.temperature.value, to: .Fahrenheit))
            return "\(cel)"  + Constants.degree + "F"
        case .Celcius:
            return String(format: "%.0f", period.temperature.value) + Constants.degree + "C"
        }
    }
}
