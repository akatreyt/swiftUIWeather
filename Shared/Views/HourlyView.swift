//
//  HourlyView.swift
//  Weather
//
//  Created by Trey Tartt on 9/17/20.
//

import SwiftUI
import NationalWeatherService

struct HourlyView: View {
    let periods : [Forecast.Period]
    let rowFormatter : RowFormattable.Type = RowFormatter.self
    var showWeatherIcon = true
    
    @AppStorage("viewType",
                store: UserDefaults(suiteName: AppGroup.weather.rawValue))
    var selection: ViewTypes = .both
    
    var dateFormatter : DateFormatter = {
        let datef = DateFormatter()
        datef.dateFormat = "h a"
        return datef
    }()
    
    var body: some View {
        HStack{
            ForEach(periods, id: \.id){ period in
                VStack{
                    if [ViewTypes.fahrenheit, ViewTypes.both].contains(selection){
                        Text(rowFormatter.degreeToString(fromPeriod: period, forTemp: .Fahrenheit))
                    }
                    
                    if [ViewTypes.celsius, ViewTypes.both].contains(selection){
                        Text(rowFormatter.degreeToString(fromPeriod: period, forTemp: .Celcius))
                    }
                    
                    Text(dateFormatter.string(from: period.startTime))
                    
                    if showWeatherIcon{
                        Image(uiImage: period.weatherIcon())
                            .foregroundColor(Color("TextColor"))
                    }
                    
                }
                if period.startTime != periods.last?.startTime{
                    Spacer()
                }
            }
        }
    }
}

struct HourlyView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyView(periods: [Forecast.Period]())
    }
}
