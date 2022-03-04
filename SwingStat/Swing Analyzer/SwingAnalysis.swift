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
            VStack {
                Text(swing.video!.lastPathComponent)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.green)
                    .padding()
                
                HStack(alignment: .center) {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 100, height: 100)
                }
                .padding()
                
                Spacer()
                
                Text("Swing tips")
                    .font(.headline)
                List {
                    HStack {
                        Text("Left arm angle ❌")
                            .font(.subheadline)
                            .foregroundColor(Color.red)
                            .padding()
                        Spacer()
                        Text("Your left arm is overly bent.")
                            .font(.caption)
                    }
                    
                    HStack {
                        Text("Vertical head movement ✅")
                            .font(.subheadline)
                            .foregroundColor(Color.green)
                            .padding()
                        Spacer()
                        Text("You had very little vertical head movement. Nice!")
                            .font(.caption)
                    }
                    
                    HStack {
                        Text("Horizontal head movement ❌")
                            .font(.subheadline)
                            .foregroundColor(Color.red)
                            .padding()
                        Spacer()
                        Text("Your head moved laterally more than it should.")
                            .font(.caption)
                    }
                    
                    HStack {
                        Text("Hip sway ❌")
                            .font(.subheadline)
                            .foregroundColor(Color.red)
                            .padding()
                        Spacer()
                        Text("Your hips moved too much during your backswing.")
                            .font(.caption)
                    }
                }
                
            }
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
