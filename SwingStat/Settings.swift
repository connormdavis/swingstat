//
//  Settings.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 2/23/22.
//

import SwiftUI

struct Settings: View {
    @State private var height = false
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User")) {
                    Toggle(isOn: $height,
                           label:{
                        Text("Height")
                    })
                    
                }
            }
            .navigationTitle("Settings")
        }
        
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
