//
//  LargeWidgetView.swift
//  WeatherWidgetExtension
//
//  Created by Trey Tartt on 9/27/20.
//

import SwiftUI
import NationalWeatherService

struct LargeWidgetView : View {
    let hourlyPeriods : [Forecast.Period]
    let todayHiLow : HiLowTemp
    let rowFormatter : RowFormattable.Type = RowFormatter.self
    
    var body: some View {
        VStack{
            Text(todayHiLow.current.shortForecast)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.title2)
                .foregroundColor(Color("TextColor"))
            
            SmallWidgetView(hiLowTemp: todayHiLow)
            
            Divider()
            Spacer()
            HourlyView(periods: hourlyPeriods, showWeatherIcon: true)
                .padding([.leading, .trailing])
            Spacer()
        }
        .padding([.top, .bottom])
    }
}

struct LargeWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        if let hiLowTemps = AppEnvironment.Preview.weather.getHiLow(forDate: Date()),
           let _periods = AppEnvironment.Preview.weather.fullForecast?.periods{
            let periodsToShow =  Array(_periods.prefix(upTo: 5))
            LargeWidgetView(hourlyPeriods: periodsToShow, todayHiLow: hiLowTemps)
        }else{
            Text("shit broke")
        }
    }
}
