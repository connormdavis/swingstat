//
//  ContentView.swift
//  Shared
//
//  Created by Connor Davis on 2/14/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var swing = Swing()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                HStack {
                    Text("SwingStat")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.blue)
                }
                HStack {
                    Text("Golf Swing Analyzer")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text("COSC 98")
                        .font(.subheadline)
                        .fontWeight(.light)
                }
                HStack {
                    NavigationLink(destination: Dashboard(swing: swing)) {
                        Text("Begin")
                            .frame(minWidth: 0, maxWidth: 100, maxHeight: 15)
                            .padding()
                            .foregroundColor(.white)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(40)
                            .font(.title)
                    }
                }
            }
        }
        .navigationTitle("splash")
        .navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
