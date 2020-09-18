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
    
    @AppStorage("viewType",
                store: UserDefaults(suiteName: AppGroup.weather.rawValue))
    var selection: ViewTypes = .both
    
    var body: some View {
        VStack{
            HStack{
                Text(period.name!)
                Image(systemName: "cloud")
                    .foregroundColor(Color("TextColor"))
            }
            HStack{
                Spacer()
                if [ViewTypes.fahrenheit, ViewTypes.both].contains(selection){
                    Text(rowFormatter.degreeToString(fromPeriod: period, forTemp: .Fahrenheit))
                        .font(.body)
                        .foregroundColor(Color("TextColor"))
                }
                
                if [ViewTypes.both].contains(selection){
                    Text("|")
                        .padding([.leading, .trailing])
                }
                
                if [ViewTypes.celsius, ViewTypes.both].contains(selection){
                    Text(rowFormatter.degreeToString(fromPeriod: period, forTemp: .Celcius))
                        .font(.body)
                        .foregroundColor(Color("TextColor"))
                }
                Spacer()
            }
        }
        .padding(.vertical)
        .listRowBackground(Color.red)
    }
}

struct PeriodRowView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
