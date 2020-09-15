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

struct ContentView<CoordinatorGeneric>: View where CoordinatorGeneric:Coordinatorable{
    @State private var showSettings = false
    @ObservedObject public var env = CoordinatorGeneric()
    
    var body: some View {
        if env.isFetchingLocationDetails || env.isFetchingWeather{
            FetchingView()
        }else{
            ZStack {
                Color("TableHeader")
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    TopView(settingsAction: {
                        self.showSettings.toggle()
                    },
                    locationString: env.locationDescProxy)
                    
                    if let _weather = env.currentWeatherProxy,
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let cvLight = ContentView(env: Environment.Preview)
            cvLight.environment(\.colorScheme, .light)
            
            let cvDark = ContentView(env: Environment.Preview)
            cvDark.environment(\.colorScheme, .dark)
            
            let cvNodata = ContentView(env: Environment.Preview)
            cvNodata.environment(\.colorScheme, .dark)
        }
    }
}
