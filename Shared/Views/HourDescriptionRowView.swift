//
//  HourDescriptionRowView.swift
//  Weather
//
//  Created by Trey Tartt on 9/24/20.
//

import SwiftUI
import NationalWeatherService

struct HourDescriptionRowView: View {
    let hourlyPeriods : [Forecast.Period]
    let period : Forecast.Period
    
    var body: some View {
        VStack{
            HourlyView(periods: hourlyPeriods)
                .padding([.leading, .trailing])
            
            Text(period.detailedForecast ?? "")
                .lineLimit(5)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .font(.footnote)
                .padding([.top, .leading, .trailing])
        }
        .listRowBackground(Color("TableHeader"))
    }
}

struct HourDescriptionRowView_Previews: PreviewProvider {
    static var previews: some View {
        HourDescriptionRowView(hourlyPeriods: AppEnvironment.Preview.weather.getHourly(forDate: Date(), includingNext: 5),
                               period: (AppEnvironment.Preview.weather.fullForecast?.periods[1])!)
    }
}
