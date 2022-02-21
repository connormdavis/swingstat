//
//  CircleImage.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 2/14/22.
//

import SwiftUI
import AVKit

struct Dashboard: View {
    @ObservedObject var swing: Swing
    
    let avPlayer = AVPlayer(url: Bundle.main.url(forResource: "reg_swing", withExtension: "mov")!)
    
    var body: some View {
        VStack(alignment: .center) {
            Button("Record new video") {
                // TODO: Show camera and allow new swing recording
                print("NEW VIDEO - launch camera")
            }
                .padding()
                .background(Color.black)
                .clipShape(Capsule())
            
            VideoPlayer(player: avPlayer)
                .frame(width: 325, height: 335)
                .cornerRadius(25)

            Text("Landmark data:")
                .font(.title)
                .fontWeight(.bold)
            
            if swing.landmarksGenerated {
                TextEditor(text: $swing.landmarksText)
            } else {
                if swing.processing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Text("No landmark data generated yet.")
                        .font(.body)
                        .foregroundColor(Color.gray)
                        .padding()
                }
            }
            
            Spacer()
            // If we haven't generated or aren't generating - show button
            if !swing.landmarksGenerated && !swing.processing {
                Button("Generate landmarks") {
                    swing.generateLandmarks(desiredFrames: [1, 100, 500, 1000])
                }
                    .padding()
                    .background(Color.black)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .navigationTitle("Dashboard")
    }
}

struct Dashboard_Previews: PreviewProvider {
    static let swing = Swing()
    
    static var previews: some View {
        Dashboard(swing: swing)
    }
}
