//
//  SwingTipItem.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 3/6/22.
//

import SwiftUI

struct SwingTipItem: View {
    
    @State var swingTip: SwingTip
    
    var body: some View {
        HStack {
            if swingTip.passed {
                Text("✅")
                Text(swingTip.type)
                    .foregroundColor(Color.green)
                    .frame(maxWidth: 100)
            } else {
                Text("❌")
                Text(swingTip.type)
                    .foregroundColor(Color.red)
                    .frame(maxWidth: 100)
            }
            
            Spacer()
            Text(swingTip.miniDescription)
                .font(.caption)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 75, maxHeight: .infinity, alignment: .center)
    }
}

struct SwingTipItem_Previews: PreviewProvider {
    static var previews: some View {
        SwingTipItem(swingTip: SwingTip(type: "Left arm angle", passed: false, miniDescription: "", passedDescription: "", failedDescription: "Your left arm is overly bent.", help: ""))
    }
}
