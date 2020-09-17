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
    
    var dateFormatter : DateFormatter = {
        let datef = DateFormatter()
        datef.dateFormat = "h a"
        return datef
    }()
    
    var body: some View {
        HStack{
            ForEach(periods, id: \.id){ period in
                VStack{
                    Text(rowFormatter.degreeToString(fromPeriod: period, forTemp: .Fahrenheit))
                    Text(rowFormatter.degreeToString(fromPeriod: period, forTemp: .Celcius))
                    Text(dateFormatter.string(from: period.startTime))
                }
                Spacer()
            }
        }
    }
}

struct HourlyView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyView(periods: [Forecast.Period]())
    }
}
