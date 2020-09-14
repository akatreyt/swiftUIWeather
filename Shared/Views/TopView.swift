//
//  TopView.swift
//  Weather
//
//  Created by Trey Tartt on 9/14/20.
//

import SwiftUI


struct TopView: View{
    var settingsAction : (()->Void)
    var locationString : String
    
    var body: some View {
        HStack{
            Text(locationString)
                .font(.body)
                .fontWeight(.heavy)
                .foregroundColor(Color("ButtonColor"))
                .padding()
                
            Spacer()
            Button(action: {
                settingsAction()
            }) {
                Image(systemName: "gear")
                    .padding(.trailing)
            }
            .foregroundColor(Color("ButtonColor"))
        }
    }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView(settingsAction: {
            print("settigns hit")
        }, locationString: "")
    }
}
