//
//  Profile.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 2/23/22.
//

import SwiftUI

struct Profile: View {
    var body: some View {
        NavigationView{
            VStack{
                Text("Profile")
            }
            .navigationTitle("My Profile")
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
