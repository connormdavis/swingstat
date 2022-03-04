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
            Text(swing.getFilename())
                .padding()
            Spacer()
        }
    }
}

struct SavedSwingItem_Previews: PreviewProvider {
    static let test_swing: Swing = Swing(url: nil)
    
    static var previews: some View {
        SavedSwingItem(swing: test_swing)
    }
}
