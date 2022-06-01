//
//  ShareAnalysisItem.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 5/31/22.
//

import SwiftUI

struct ShareAnalysisItem: View {
    
    var swing: Swing

    var leftArmAngleTip: SwingTip
    var latHeadMovTip: SwingTip
    var vertHeadMovTip: SwingTip
    var swingTempoTip: SwingTip
    var hipSwayTip: SwingTip
    
    init() {
        for tip in swing.swingTips {
            if tip.type == "Left arm angle" {
                leftArmAngleTip = tip
            } else if tip.type == "Lateral head movement" {
                latHeadMovTip = tip
            } else if tip.type == "Vertical head movement" {
                vertHeadMovTip = tip
            } else if tip.type == "Swing tempo" {
                swingTempoTip = tip
            } else {
                hipSwayTip = tip
            }

            
//            if tip.type == "Lateral head movement" && tip.passed  {
//                Text("Lateral Head Movement ✅")
//            } else {
//                Text("Lateral Head Movement ❌")
//            }
//
//            if tip == "Vertical head movement" && tip.passed  {
//                Text("Vertical Head Movement ✅")
//            } else {
//                Text("Vertical Head Movement ❌")
//            }
//
//            if tip == "Swing tempo" && tip.passed  {
//                Text("Swing Tempo ✅")
//            } else {
//                Text("Swing Tempo ❌")
//            }
//
//            if tip == "Hip sway" && tip.passed  {
//                Text("Hip Sway ✅")
//            } else {
//                Text("Hip Sway ❌")
//            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 15) {
                    
                    if leftArmAngleTip.passed {
                        Text("Left arm angle ✅")
                    } else {
                        Text("Left arm angle ❌")
                    }
                    
                    if latHeadMovTip.passed {
                        Text("Lateral Head Movement ✅")
                    } else {
                        Text("Lateral Head Movement ❌")
                    }
                    
                    if vertHeadMovTip.passed {
                        Text("Vertical Head Movement ✅")
                    } else {
                        Text("Vertical Head Movement ❌")
                    }
                    
                    if swingTempoTip.passed {
                        Text("Swing Tempo ✅")
                    } else {
                        Text("Swing Tempo ❌")
                    }
                    
                    if hipSwayTip.passed {
                        Text("Hip Sway ✅")
                    } else {
                        Text("Hip Sway ❌")
                    }
                   
                }.font(.subheadline)
                VStack {
                    Image(uiImage: getImpactImage())
                }
            }
            HStack {
                Text("\(swing.estimatedDistance) yards").font(.headline)
            }
        }
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
