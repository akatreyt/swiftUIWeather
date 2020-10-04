//
//  MediumWidgetView.swift
//  WeatherWidgetExtension
//
//  Created by Trey Tartt on 9/27/20.
//

import SwiftUI
import NationalWeatherService

struct MediumWidgetView : View {
    let periods : [Forecast.Period]
    let rowFormatter : RowFormattable.Type = RowFormatter.self
    var dateIntervalFormatter = DateIntervalFormatter(){
        didSet{
            dateIntervalFormatter.dateStyle = .short
            dateIntervalFormatter.timeStyle = .medium
        }
    }
    
    var body: some View {
        VStack{
            HStack{
                ForEach(periods, id: \.id){ period in
                    VStack{
                        Text(period.name ?? "")
                            .font(.body)
                            .foregroundColor(Color("TextColor"))
                            .multilineTextAlignment(.center)
                        
                        Text(rowFormatter.degreeToString(fromPeriod: period, forTemp: .Fahrenheit))
                            .font(.body)
                            .foregroundColor(Color("TextColor"))
                        
                        Text(rowFormatter.degreeToString(fromPeriod: period, forTemp: .Celcius))
                            .font(.body)
                            .foregroundColor(Color("TextColor"))
                        
                        Image(uiImage: period.weatherIcon())
                            .renderingMode(.template)
                            .foregroundColor(Color("TextColor"))
                        
                        Text(period.shortForecast)
                            .font(.body)
                            .foregroundColor(Color("TextColor"))
                    }
                    Spacer()
                }
            }
        }
        .padding()
    }
}

struct MediumWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        if let _periods = AppEnvironment.Preview.weather.fullForecast?.periods{
            let periodsToShow =  Array(_periods.prefix(upTo: 3))
            MediumWidgetView(periods: periodsToShow)
        }else{
            Text("shit broke")
        }
    }
}
