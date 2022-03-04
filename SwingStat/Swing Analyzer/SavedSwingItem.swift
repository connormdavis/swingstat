//
//  SavedSwingItem.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 3/1/22.
//

import SwiftUI

struct SavedSwingItem: View {
    
    var swing: Swing
    
    
    var body: some View {
        HStack {
            Image(systemName: "video.fill")
                .resizable()
                .frame(width: 50, height: 35)
            Text(swing.getFilename()).lineLimit(1).font(.subheadline)
            Spacer()
            Text("03/4/22").font(.caption)
            Text("8s").font(.caption)
        }
    }
}

struct SavedSwingItem_Previews: PreviewProvider {
    static let test_swing: Swing = Swing(url: nil)
    
    static var previews: some View {
        SavedSwingItem(swing: test_swing)
    }
}
