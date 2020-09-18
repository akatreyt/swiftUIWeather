//
//  FetchingView.swift
//  Weather
//
//  Created by Trey Tartt on 9/15/20.
//

import SwiftUI

struct FetchingView: View {
    var body: some View {
        HStack{
            Text("Updating")
                .padding()
            ProgressView()
        }
        .padding([.leading, .trailing])
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(23)
    }
}

struct FetchingView_Previews: PreviewProvider {
    static var previews: some View {
        FetchingView()
    }
}
