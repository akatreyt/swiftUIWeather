//
//  PeriodRowView.swift
//  Weather
//
//  Created by Trey Tartt on 9/14/20.
//

import Foundation
import NationalWeatherService
import SwiftUI

struct PeriodRowView: View {
    let period:Forecast.Period
    let rowFormatter : RowFormattable.Type = RowFormatter.self
    
    var body: some View {
        VStack{
            Text(period.name!)
            HStack{
                Spacer()
                Text(rowFormatter.degreeToString(fromPeriod: period, forTemp: .Fahrenheit))
                    .font(.body)
                    .foregroundColor(Color("TextColor"))
                Image(systemName: "cloud")
                    .foregroundColor(Color("TextColor"))
                Text(rowFormatter.degreeToString(fromPeriod: period, forTemp: .Celcius))
                    .font(.body)
                    .foregroundColor(Color("TextColor"))
                Spacer()
            }
        }
        .padding(.vertical)
        .listRowBackground(Color.red)
    }
}
