//
//  SwingAnalysis.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 3/1/22.
//

import SwiftUI

struct SwingAnalysis: View {
    
    @ObservedObject var swing: Swing
    
    var body: some View {
        // Display loading when processing
        // TODO: Update swing's processing state to include posture generation AND analysis
        if swing.processing {
            VStack(alignment: .center) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                Text("Analyzing...")
                    .font(.subheadline)
            }
        } else {
            Text(swing.video!.lastPathComponent)
                .navigationTitle("Swing Analysis")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SwingAnalysis_Previews: PreviewProvider {
    static var swing: Swing = Swing(url: ContentView.stockUrl)
    
    static var previews: some View {
        SwingAnalysis(swing: self.swing)
    }
}
