//
//  SwingAnalysis.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 3/1/22.
//

import SwiftUI

struct SwingAnalysis: View {
    var name: String
    var body: some View {
        Text(name)
            .navigationTitle("Swing Analysis")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct SwingAnalysis_Previews: PreviewProvider {
    static var previews: some View {
        SwingAnalysis(name: "test")
    }
}
