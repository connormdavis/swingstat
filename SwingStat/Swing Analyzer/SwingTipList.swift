//
//  SwingTipList.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 3/6/22.
//

import SwiftUI

struct SwingTipList: View {
    @State var savedTips: [SwingTip]
    
    var swing: Swing
    

    var body: some View {
        
        List(savedTips, id: \.type) { tip in
            NavigationLink {
                SwingTipDetailed(swingTip: tip, swing: swing)
            } label: {
                SwingTipItem(swingTip: tip)
            }
        }
    }
}

struct SwingTipList_Previews: PreviewProvider {
    static var tipList = [SwingTip(type: "", passed: false, miniDescription: "", passedDescription: "", failedDescription: "", help: "")]
    
    static let test_swing: Swing = Swing(url: nil)
    
    static var previews: some View {
        SwingTipList(savedTips: tipList,swing: test_swing)
    }
}
