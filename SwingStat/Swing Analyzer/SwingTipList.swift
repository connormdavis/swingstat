//
//  SwingTipList.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 3/6/22.
//

import SwiftUI

struct SwingTipList: View {
    
    // uncocmment when getting data from backend
//    var savedTips: [SwingTip]

    var body: some View {
        
        // uncomment when getting data from backend
//        List(savedTips, id: \.type) { tip in
//            NavigationLink {
//                SwingTipDetailed()
//            } label: {
//                SwingTipItem(swingTip: tip)
//            }
//        }
        
        List {
            NavigationLink(destination: SwingTipDetailed()) {
                SwingTipItem(swingTip: SwingTip(type: "Left arm angle bfasl afd asdf afsd", passed: false, description: "Your left arm is overly bent.", help: ""))
            }
            
            NavigationLink(destination: SwingTipDetailed()) {
                SwingTipItem(swingTip: SwingTip(type: "Vertical head movement", passed: true, description: "You had very little vertical head movement. Nice!", help: ""))
            }
        }
    }
}

struct SwingTipList_Previews: PreviewProvider {
    static var previews: some View {
        SwingTipList()
    }
}
