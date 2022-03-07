//
//  SwingTipDetailed.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 3/6/22.
//

import SwiftUI

struct SwingTipDetailed: View {
    
    var body: some View {
        VStack{
            Text("[Swing Tip Title]")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
            Text("[Description]")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.body)
                .padding(.top, 20)
        }
        .padding(.horizontal, 25)
        .padding(.top, 20)
        
        VStack{
            
            Text("Helpful Resources:")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title3)
                .padding(.horizontal, 25)
                .padding(.top, 20)
            List {
                Text("https://www.youtube.com/watch?v=eyNSo4WrWlU")
                Text("https://www.youtube.com/channel/UCfi-mPMOmche6WI-jkvnGXw")
                Text("https://golfinsideruk.com/golf-backswing-explained/")
            }
        }

    }
}

struct SwingTipDetailed_Previews: PreviewProvider {
    static var previews: some View {
        SwingTipDetailed()
    }
}
