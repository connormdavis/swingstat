//
//  SavedSwingList.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 3/1/22.
//

import SwiftUI

struct SavedSwingList: View {
    var savedSwings: [Swing]
    
    var body: some View {
        List(savedSwings, id: \.id) { swing in
            NavigationLink {
                SwingAnalysis(name: swing.video!.lastPathComponent)
            } label: {
                SavedSwingItem(swing: swing)
            }
        }
    }
}

struct SavedSwingList_Previews: PreviewProvider {
    static let swings = [Swing(url: ContentView.stockUrl)]
    static var previews: some View {
        SavedSwingList(savedSwings: self.swings)
    }
}
