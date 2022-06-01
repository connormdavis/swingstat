//
//  Main.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 2/23/22.
//

import SwiftUI

struct Main: View {
    
    @StateObject var swing = Swing(url: ContentView.stockUrl)
    
    @State var loggedOut = false

    
    var body: some View {
        if loggedOut {
            Authentication().transition(.opacity)
        } else {
            TabView {
                SwingAnalyzer()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                Stats()
                    .tabItem {
                        Image(systemName: "chart.bar.xaxis")
                        Text("Stats")
                    }
                Profile(loggedOut: $loggedOut)
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
            }
            .preferredColorScheme(.light)
            .accentColor(Color.green)
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
