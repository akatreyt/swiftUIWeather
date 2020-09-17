//
//  ContentView.swift
//  Shared
//
//  Created by Trey Tartt on 9/12/20.
//

import SwiftUI
import CoreLocation
import NationalWeatherService

struct ContentView<CoordinatorGeneric>: View where CoordinatorGeneric:Coordinatorable{
    @State private var showSettings = false
    @ObservedObject public var coordinator = CoordinatorGeneric()
    
    var body: some View {
        if coordinator.isFetching{
            FetchingView()
        }else{
            ZStack {
                Color("TableHeader")
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    TopView(settingsAction: {
                        self.showSettings.toggle()
                    },
                    locationString: coordinator.forecast.locationDesc)
                                        
                    if let _weather = coordinator.forecast.fullForecast,
                       _weather.periods.count > 0{
                        HeaderView(period: _weather.periods.first!,
                                   hourlyPeriods: coordinator.forecast.getHourly(forDate: Date(), includingNext: 5))
                        
                        List(_weather.periods.dropFirst()) { item in
                            PeriodRowView(period: item)
                        }
                    }else{
                        NoDataView()
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(zipCodeEntered: { (zipCode) in
                    showSettings = false
                    coordinator.getGps(fromZip: Int(zipCode)!)
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let cvLight = ContentView(coordinator: AppEnvironment.Preview)
            cvLight.environment(\.colorScheme, .light)
            
            let cvDark = ContentView(coordinator: AppEnvironment.Preview)
            cvDark.environment(\.colorScheme, .dark)
            
            let cvNodata = ContentView(coordinator: AppEnvironment.Preview)
            cvNodata.environment(\.colorScheme, .dark)
        }
    }
}
