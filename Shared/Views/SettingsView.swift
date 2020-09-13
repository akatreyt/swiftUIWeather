//
//  SettingsView.swift
//  Shared
//
//  Created by Trey Tartt on 9/12/20.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Text("hell world")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let cvLight = SettingsView()
            cvLight.environment(\.colorScheme, .light)
            
            
            let cvDark = SettingsView()
            cvDark.environment(\.colorScheme, .dark)
        }
    }
}

