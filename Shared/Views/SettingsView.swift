//
//  SettingsView.swift
//  Shared
//
//  Created by Trey Tartt on 9/12/20.
//

import SwiftUI

struct SettingsView: View {
    @State private var zipCode : String = ""
    public var zipCodeEntered : ((String) -> Void)
    @State private var zipCodeValid = false
    
    var body: some View {
        let binding = Binding<String>(get: {
            self.zipCode
        }, set: {
            self.zipCode = $0
            testZipCode()
        })
        VStack{
            VStack{
                TextField("Enter zip code", text: binding)
                Button("Locate") {
                    self.zipCodeEntered(zipCode)
                }.disabled(!zipCodeValid)
            }
            .background(Color.white)
            Spacer()
        }
        .padding()
        .background(Color.red)
    }
    
    private func testZipCode(){
        if let _ = Int(zipCode),
           zipCode.count == 5{
            zipCodeValid = true
            return
        }
        zipCodeValid = false
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let cvLight = SettingsView(zipCodeEntered: {(value) in
                print(value)
            })
            cvLight.environment(\.colorScheme, .light)
            
            
            let cvDark = SettingsView(zipCodeEntered: {(value) in
                print(value)
            })
            cvDark.environment(\.colorScheme, .dark)
        }
    }
}

