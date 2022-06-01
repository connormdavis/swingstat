//
//  ShareAnalysisItem.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 5/31/22.
//

import SwiftUI

struct ShareAnalysisItem: View {
    
    @State var swing: Swing

    @State var leftArmAngleTip: SwingTip
    @State var latHeadMovTip: SwingTip
    @State var vertHeadMovTip: SwingTip
    @State var swingTempoTip: SwingTip
    @State var hipSwayTip: SwingTip
    
    
//    init(swing: Swing, swingTips: [SwingTip]) {
//        self.swingTips = swingTips
//        self.swing = swing
//        for tip in swing.swingTips {
//            if tip.type == "Left arm angle" {
//                self.leftArmAngleTip = tip
//            } else if tip.type == "Lateral head movement" {
//                self.latHeadMovTip = tip
//            } else if tip.type == "Vertical head movement" {
//                self.vertHeadMovTip = tip
//            } else if tip.type == "Swing tempo" {
//                self.swingTempoTip = tip
//            } else {
//                self.hipSwayTip = tip
//            }
//
//
////            if tip.type == "Lateral head movement" && tip.passed  {
////                Text("Lateral Head Movement ✅")
////            } else {
////                Text("Lateral Head Movement ❌")
////            }
////
////            if tip == "Vertical head movement" && tip.passed  {
////                Text("Vertical Head Movement ✅")
////            } else {
////                Text("Vertical Head Movement ❌")
////            }
////
////            if tip == "Swing tempo" && tip.passed  {
////                Text("Swing Tempo ✅")
////            } else {
////                Text("Swing Tempo ❌")
////            }
////
////            if tip == "Hip sway" && tip.passed  {
////                Text("Hip Sway ✅")
////            } else {
////                Text("Hip Sway ❌")
////            }
//        }
//    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 15) {
                    
                    if leftArmAngleTip.passed {
                        Text("Left arm angle ✅")
                            .foregroundColor(Color.black)
                    } else {
                        Text("Left arm angle ❌")
                            .foregroundColor(Color.black)
                    }
                    
                    if latHeadMovTip.passed {
                        Text("Lateral Head Movement ✅")
                            .foregroundColor(Color.black)
                    } else {
                        Text("Lateral Head Movement ❌")
                            .foregroundColor(Color.black)
                    }
                    
                    if vertHeadMovTip.passed {
                        Text("Vertical Head Movement ✅")
                            .foregroundColor(Color.black)
                    } else {
                        Text("Vertical Head Movement ❌")
                            .foregroundColor(Color.black)
                    }
                    
                    if swingTempoTip.passed {
                        Text("Swing Tempo ✅")
                            .foregroundColor(Color.black)
                    } else {
                        Text("Swing Tempo ❌")
                            .foregroundColor(Color.black)
                    }
                    
                    if hipSwayTip.passed {
                        Text("Hip Sway ✅")
                            .foregroundColor(Color.black)
                    } else {
                        Text("Hip Sway ❌")
                            .foregroundColor(Color.black)
                    }
                    
                    
                    
                   
                }
                .font(.subheadline)
                .padding()
                VStack {
                    Image(uiImage: getImpactImage())
                        .resizable()
                        .cornerRadius(20.0)
                        .aspectRatio(contentMode: .fit)
                        
                        .frame(width: 250)
                        
                }
            }
            HStack {
                Text("Estimated distance: ")
                    .font(.largeTitle)
                    .foregroundColor(Color.black)
                Text("\(String(format: "%.1f", swing.estimatedDistance)) yards")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.green)
            }
            .padding()
            HStack {
                Text("Powered by SwingStat")
                    .font(.callout)
                    .foregroundColor(Color.gray)
                    .padding()
            }
        }
        .background(Color.white)
    }
    func getImpactImage() -> UIImage {
        if swing.impactImage != nil {
            return swing.impactImage!
        }
        return UIImage(systemName: "photo")!
    }
}



//struct ShareAnalysisItem_Previews: PreviewProvider {
//    static var previews: some View {
//        ShareAnalysisItem()
//    }
//}
