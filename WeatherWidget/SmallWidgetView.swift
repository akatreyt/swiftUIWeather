//
//  SmallWidgetView.swift
//  WeatherWidgetExtension
//
//  Created by Trey Tartt on 9/27/20.
//

import SwiftUI
import NationalWeatherService

struct SmallWidgetView : View {
    let hiLowTemp : HiLowTemp
    let rowFormatter : RowFormattable.Type = RowFormatter.self
    
    var body: some View {
        VStack{
            HStack{
                Text(rowFormatter.degreeToString(fromPeriod: hiLowTemp.current, forTemp: .Fahrenheit))
                    .font(.body)
                    .foregroundColor(Color("TextColor"))
                                
                Image(uiImage: hiLowTemp.current.weatherIcon())
                    .renderingMode(.template)
                    .font(.title)
                    .foregroundColor(Color("TextColor"))
                
                Text(rowFormatter.degreeToString(fromPeriod: hiLowTemp.current,
                                                 forTemp: .Celcius))
                    .font(.body)
                    .foregroundColor(Color("TextColor"))
            }
            .padding([.leading, .trailing])
            
            Divider()
            
            HStack{
                Text(rowFormatter.degreeToString(fromPeriod: hiLowTemp.low,
                                                 forTemp: .Fahrenheit))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.title2)
                    .foregroundColor(Color("TextColor"))
                
                Text(rowFormatter.degreeToString(fromPeriod: hiLowTemp.hi,
                                                 forTemp: .Fahrenheit))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.title2)
                    .foregroundColor(Color("TextColor"))
            }
            
            Divider()
            
            HStack{
                Text(rowFormatter.degreeToString(fromPeriod: hiLowTemp.low,
                                                 forTemp: .Celcius))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.title2)
                    .foregroundColor(Color("TextColor"))
                
                Text(rowFormatter.degreeToString(fromPeriod: hiLowTemp.hi,
                                                 forTemp: .Celcius))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.title2)
                    .foregroundColor(Color("TextColor"))
            }
        }
    }
}

struct SmallWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        if let hiLowTemps = AppEnvironment.Preview.weather.getHiLow(forDate: Date()){
            SmallWidgetView(hiLowTemp: hiLowTemps)
        }else{
            Text("shit broke")
        }
    }
}
