//
//  SwingFilterTag.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 5/18/22.
//

import SwiftUI

struct SwingFilterTag: View {

    var swingFilterData: SwingFilterData

    var body: some View {
        Label(swingFilterData.title, systemImage: swingFilterData.imageName)
            .labelStyle(.titleOnly)
            .font(.system(size: 10))
            .padding(8)
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 16)  // 3
                    .foregroundColor(swingFilterData.status.color)
            )
            .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
    }
}

//struct SwingFilterTag_Previews: PreviewProvider {
//    
//    var swingFilterModel = SwingFilterModel()
//
//    static var previews: some View {
//        List {
//           ForEach(0..<swingFilterModel.data.count) { index in
//               SwingFilterTag(swingFilterData: swingFilterModel.data[index])
//        }
//    }
//}
