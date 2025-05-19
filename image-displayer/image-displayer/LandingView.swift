//
//  ContentView.swift
//  image-displayer
//
//  Created by Erik Egers on 2025/05/19.
//

import SwiftUI

struct LandingView: View {
    var body: some View {
        VStack {
            Button(action: {
                        
                    }) {
                        Text("Pick Imaage")
                            .padding()
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
        }
        .padding()
    }
}

#Preview {
    LandingView()
}
