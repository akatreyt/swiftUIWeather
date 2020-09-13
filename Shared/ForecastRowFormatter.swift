//
//  ForecastRowFormatter.swift
//  Weather
//
//  Created by Trey Tartt on 9/13/20.
//

import Foundation

protocol RowFormattable {
    static func degreeToString(fromForecast forecast: Forecast, forTemp temp : TempType)->String
}

public class RowFormatter:RowFormattable{
    private static func toCelcius(fromTemp temp:Int)->Double{
        var celsius: Double
        celsius = (Double(temp - 32)) * 5 / 9
        return celsius
    }
    
    public static func degreeToString(fromForecast forecast: Forecast, forTemp temp : TempType)->String{
        switch temp {
        case .Fahrenheit:
            return String(format: "%.0f", Float(forecast.temperature)) + Constants.degree + "F"
        case .Celcius:
            let cel = String(format: "%.0f", RowFormatter.toCelcius(fromTemp: forecast.temperature))
            return "\(cel)"  + Constants.degree + "C"
        }
    }
}
