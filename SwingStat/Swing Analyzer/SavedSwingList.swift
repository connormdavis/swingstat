//
//  SavedSwingList.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 3/1/22.
//

import SwiftUI
import AVKit

struct SavedSwingList: View {
    @State var savedSwings: [Swing] = []
    @State var analyzerViewModels: [SwingAnalyzerViewModel] = []
    
    func updateSavedSwings() {
        let savedSwingVideoNames = SavedSwingVideoManager.getSavedSwingVideoNames()
        var swings: [Swing] = []
        for name in savedSwingVideoNames {
            let swingUrl = SavedSwingVideoManager.getSavedVideoPathFromName(name: name)
            swings.append(Swing(url: swingUrl))
        }
        self.savedSwings = swings
    }
    
    var body: some View {
        List {
            ForEach(savedSwings, id: \.id) { swing in
                NavigationLink {
                    SwingEventChooser(analyzerViewModel: SwingAnalyzerViewModel(videoUrl: swing.video!), avPlayer: AVPlayer(url: swing.video!))
                } label: {
                    SavedSwingItem(swing: swing)
                }
            }
            .onDelete { idxSet in
                for idx in idxSet {
                    savedSwings[idx].delete()
                    self.savedSwings.remove(at: idx)
                }
            }
        }
        .onAppear() {
            updateSavedSwings()
        }
    }
}

struct SavedSwingList_Previews: PreviewProvider {
    static let swings = [Swing(url: ContentView.stockUrl)]
    static var previews: some View {
        SavedSwingList(savedSwings: self.swings)
    }
}
