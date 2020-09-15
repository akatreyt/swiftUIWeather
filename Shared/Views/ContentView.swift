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

struct ContentView<LocationGeneric>: View where LocationGeneric:LocationManagable{
    @State private var showSettings = false
    @ObservedObject public var lm = LocationGeneric()
    
    var body: some View {
        ZStack {
            Color("TableHeader")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                TopView(settingsAction: {
                    self.showSettings.toggle()
                },
                locationString: lm.locationDescProxy!)
                
                if let _weather = lm.publicDataLayer.currentWeather,
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
            let cvLight = ContentView<MockLocationLayer<MockNetworkFetch, DataLayer>>()
            cvLight.environment(\.colorScheme, .light)

            let cvDark = ContentView<MockLocationLayer<MockNetworkFetch, DataLayer>>()
            cvDark.environment(\.colorScheme, .dark)

            let cvNodata = ContentView<MockLocationLayer<MockNetworkFetch, DataLayer>>()
            cvNodata.environment(\.colorScheme, .dark)
        }
    }
}
