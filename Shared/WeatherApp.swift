//
//  WeatherApp.swift
//  Shared
//
//  Created by Trey Tartt on 9/12/20.
//

import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(dataLayer: RealDataLayer())
        }
    }
}

struct WeatherApp_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
