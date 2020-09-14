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

    var body: some View {
        VStack{
            Text(period.name!)
            HStack{
                Spacer()
                Text(rowFormatter.degreeToString(fromPeriod: period, forTemp: .Fahrenheit))
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("HeaderTextColor"))
                Image(systemName: "cloud")
                    .font(.largeTitle)
                    .foregroundColor(Color("HeaderTextColor"))
                Text(rowFormatter.degreeToString(fromPeriod: period, forTemp: .Celcius))
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("HeaderTextColor"))
                Spacer()
            }
        }
    }
}
