//
//  HeaderView.swift
//  Weather
//
//  Created by Trey Tartt on 9/14/20.
//

import Foundation
import NationalWeatherService
import SwiftUI

struct HeaderView: View {
    let period:Forecast.Period
    let rowFormatter : RowFormattable.Type = RowFormatter.self
    let hourlyPeriods : [Forecast.Period]
    
    @AppStorage("viewType",
                store: UserDefaults(suiteName: AppGroup.weather.rawValue))
    var selection: ViewTypes = .both
    
    var body: some View {
        VStack{
            Text(period.name!)
            
            Image(systemName: "cloud")
                .font(.largeTitle)
                .foregroundColor(Color("HeaderTextColor"))
            
            HStack{
                Spacer()
                if [ViewTypes.fahrenheit, ViewTypes.both].contains(selection){
                    Text(rowFormatter.degreeToString(fromPeriod: period, forTemp: .Fahrenheit))
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("HeaderTextColor"))
                }
                
                if [ViewTypes.both].contains(selection){
                    Text("|")
                        .padding([.leading, .trailing])
                }
                
                if [ViewTypes.celsius, ViewTypes.both].contains(selection){
                    Text(rowFormatter.degreeToString(fromPeriod: period, forTemp: .Celcius))
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("HeaderTextColor"))
                }
                Spacer()
            }
            HourlyView(periods: hourlyPeriods)
                .padding()
        }
    }
}
