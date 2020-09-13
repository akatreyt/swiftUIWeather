//
//  ContentView.swift
//  Shared
//
//  Created by Trey Tartt on 9/12/20.
//

import SwiftUI
import CoreLocation



struct ContentView<DataLayerGeneric>: View where DataLayerGeneric:DataLayer {
    
    @ObservedObject var dataLayer : DataLayerGeneric
    @State private var showSettings = false
    
    var body: some View {
        ZStack {
            Color("TableHeader")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack{
                    Spacer()
                    Button(action: {
                        self.showSettings.toggle()
                    }) {
                        Image(systemName: "gear")
                            .padding(.trailing)
                    }
                    .foregroundColor(Color("ButtonColor"))
                }
                
                if let _weather = dataLayer.currentWeather{
                    var varWeather = _weather
                    let first = varWeather.forecast.removeFirst()
                    
                    HeaderView(forcast: first)
                    
                    List(varWeather.forecast) { item in
                        ForcastRow(forcast: item)
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

struct NoDataView: View{
    var body: some View {
        VStack{
            Spacer()
            Text("nothing to show")
            Spacer()
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


struct ForcastRow: View {
    let forcast:Forecast
    let rowFormatter : RowFormattable.Type = RowFormatter.self
    
    var body: some View {
        VStack{
            Text(forcast.name)
            HStack{
                Spacer()
                Text(rowFormatter.degreeToString(fromForecast: forcast, forTemp: .Fahrenheit))
                    .font(.body)
                    .foregroundColor(Color("TextColor"))
                Image(systemName: "cloud")
                    .foregroundColor(Color("TextColor"))
                Text(rowFormatter.degreeToString(fromForecast: forcast, forTemp: .Celcius))
                    .font(.body)
                    .foregroundColor(Color("TextColor"))
                Spacer()
            }
        }
        .padding(.vertical)
        .listRowBackground(Color.red)
    }
}

struct HeaderView: View {
    let forcast:Forecast
    let rowFormatter : RowFormattable.Type = RowFormatter.self

    var body: some View {
        VStack{
            Text(forcast.name)
            HStack{
                Spacer()
                Text(rowFormatter.degreeToString(fromForecast: forcast, forTemp: .Fahrenheit))
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("HeaderTextColor"))
                Image(systemName: "cloud")
                    .font(.largeTitle)
                    .foregroundColor(Color("HeaderTextColor"))
                Text(rowFormatter.degreeToString(fromForecast: forcast, forTemp: .Celcius))
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("HeaderTextColor"))
                Spacer()
            }
        }
    }
}
