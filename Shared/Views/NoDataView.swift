//
//  NoDataView.swift
//  Weather
//
//  Created by Trey Tartt on 9/14/20.
//

import Foundation
import SwiftUI

struct NoDataView: View{
    var body: some View {
        VStack{
            Spacer()
            Text("nothing to show")
            Spacer()
        }
    }
}

struct NoDataView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
