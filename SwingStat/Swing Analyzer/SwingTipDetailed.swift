//
//  SwingTipDetailed.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 3/6/22.
//

import SwiftUI

struct SwingTipDetailed: View {
    @State var swingTip: SwingTip
    var swing: Swing
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(swingTip.type)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
            HStack {
                Text("Result: ")
                    .fontWeight(.thin)
                if swingTip.passed {
                    Text("Passed ✅")
                        .foregroundColor(Color.green)
                } else {
                    Text("Failed ❌")
                        .foregroundColor(Color.red)
                }
            }

            if swingTip.type == "Left arm angle" {
                HStack {
                    Spacer()
                    Image(uiImage: swing.backswingImage!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250, alignment: .center)
                        .cornerRadius(15)
                    Spacer()
                }
            }
            
            if swingTip.passed {
                Text(swingTip.passedDescription)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
                    .padding(.top, 15.0)
            } else {
                Text(swingTip.failedDescription)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
                    .padding(.top, 15.0)
            }
            
            Spacer()
            
            Text("Helpful Resources:")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title3)
                .padding(.top, 15.0)
            Text("These videos may be helpful in improving this aspect of your swing")
                .fixedSize(horizontal: false, vertical: true)
                .font(.caption)
        }
        .padding()
        List {
            HStack(alignment: .center) {
                Image(uiImage: UIImage(named: "youtube")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                Text("https://www.youtube.com/watch?v=eyNSo4WrWlU")
            }
            .padding()
            
            HStack(alignment: .center) {
                Image(uiImage: UIImage(named: "youtube")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                Text("https://www.youtube.com/channel/UCfi-mPMOmche6WI-jkvnGXw")
            }
            .padding()
            
            HStack(alignment: .center) {
                Image(uiImage: UIImage(named: "youtube")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                Text("https://golfinsideruk.com/golf-backswing-explained/")
            }
            .padding()
            
        }
        
    }
}

struct SwingTipDetailed_Previews: PreviewProvider {
    static var swingTip = SwingTip(type: "", passed: false, miniDescription: "", passedDescription: "", failedDescription: "", help: "")
    
    static let test_swing: Swing = Swing(url: nil)
    
    static var previews: some View {
        SwingTipDetailed(swingTip: swingTip, swing: test_swing)
    }
}
