//
//  ContentView.swift
//  Shared
//
//  Created by Trey Tartt on 9/12/20.
//

import SwiftUI
import CoreLocation
import NationalWeatherService

extension Forecast.Period : Identifiable{
    public var id: Date {
        return self.date.start
    }
}

struct ContentView<DataLayerGeneric>: View where DataLayerGeneric:DataLayer {
    
    @ObservedObject var dataLayer : DataLayerGeneric
    @State private var showSettings = false
    
    var body: some View {
        ZStack {
            Color("TableHeader")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                TopView(settingsAction: {
                    self.showSettings.toggle()
                },
                locationString: dataLayer.currentZipCode ?? "")
                
                if let _weather = dataLayer.currentWeather,
                   _weather.periods.count > 0{
                    HeaderView(period: _weather.periods.first!)
                    
                    List(_weather.periods.dropFirst()) { item in
                        PeriodRowView(period: item)
                    }
                }else{
                    NoDataView()
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let cvLight = ContentView(dataLayer: MockDataLayer())
            cvLight.environment(\.colorScheme, .light)

            let cvDark = ContentView(dataLayer: MockDataLayer())
            cvDark.environment(\.colorScheme, .dark)

            let cvNodata = ContentView(dataLayer: MockEmptyWeatherDataLayer())
            cvNodata.environment(\.colorScheme, .dark)
        }
    }
}
