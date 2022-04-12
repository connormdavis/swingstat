//
//  Main.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 2/23/22.
//

import SwiftUI

struct Main: View {
    
    @StateObject var swing = Swing(url: ContentView.stockUrl)
    
    var body: some View {
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
            Profile()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
            Settings()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .accentColor(Color.green)
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
