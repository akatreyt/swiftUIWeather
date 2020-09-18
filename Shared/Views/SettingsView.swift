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
    public var completeWeather : CompleteWeather
    
    var body: some View {
        let taskDateFormat: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter
        }()
        
        let binding = Binding<String>(get: {
            self.zipCode
        }, set: {
            self.zipCode = $0
            testZipCode()
        })
        
        VStack{
            VStack{
                TextField("Enter zip code", text: binding)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Locate") {
                    self.zipCodeEntered(zipCode)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .disabled(!zipCodeValid)
                .padding()
                .foregroundColor(zipCodeValid ? Color(UIColor.label) : Color(UIColor.secondaryLabel))
            }
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(8)
            
            
            Spacer()
            Text("Last data fetch\n\(completeWeather.lastFetch, formatter:taskDateFormat)")
                .foregroundColor(Color("TextColor"))
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
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
            }, completeWeather: CompleteWeather())
            cvLight.environment(\.colorScheme, .light)
            
            
            let cvDark = SettingsView(zipCodeEntered: {(value) in
                print(value)
            }, completeWeather: CompleteWeather())
            cvDark.environment(\.colorScheme, .dark)
        }
    }
}

