//
//  SwingAnalysis.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 3/1/22.
//

import SwiftUI
import UIKit

struct SwingAnalysis: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss

    @ObservedObject var swing: Swing
    @Binding var analysisFailed: Bool
    
    @State var viewingAnnotatedImage: Bool = false
    @State var selectedImageIdx = 0
    
    func getSetupImage() -> UIImage {
        if swing.setupImage != nil {
            return swing.setupImage!
        }
        return UIImage(systemName: "photo")!
    }
    
    func getBackswingImage() -> UIImage {
        if swing.backswingImage != nil {
            return swing.backswingImage!
        }
        return UIImage(systemName: "photo")!
    }
    
    func getImpactImage() -> UIImage {
        if swing.impactImage != nil {
            return swing.impactImage!
        }
        return UIImage(systemName: "photo")!
    }
    
    var body: some View {
        // Display loading when processing
        // TODO: Update swing's processing state to include posture generation AND analysis
        if swing.noPostureDetected {
            VStack(alignment: .center) {
                Text("No person detected")
                    .font(.headline)
                    .foregroundColor(Color.red)
                Text("Make sure the chosen video contains a golf swing!")
                    .font(.subheadline)
                Button("Choose new video") {
                    // Trigger previous view to dismiss as well
                    self.analysisFailed = true
                    // Return to previous screen
                    dismiss()
                }
                    .padding()
                    .background(Color.green)
                    .clipShape(Capsule())
                    .accentColor(Color.white)
            }
            .padding()
        }
        else if swing.processing {
            VStack(alignment: .center) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.green))
                    .scaleEffect(3.0, anchor: .center)
                    .padding()
                Text("Analyzing...")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.green)
                    .padding()
            }
        } else {
            VStack {
                Text(swing.video!.lastPathComponent)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.green)
                    .padding()
                
                HStack(alignment: .center) {
//                    PosturePhoto(image: UIImage(named: "dustin_thumbnail")!)
////                        .resize(width: 100, height: 100)
//                    PosturePhoto(image: UIImage(named: "dustin_thumbnail")!)
////                        .resize(width: 100, height: 100)
//                    PosturePhoto(image: UIImage(named: "dustin_thumbnail")!)
//                        .resize(width: 100, height: 100)
                    VStack(alignment: .center, spacing: 0) {
                        Image(uiImage: getSetupImage())
                            .resizable()
                            .cornerRadius(10.0)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 130)
                            .cornerRadius(10.0)
                        Text("Setup")
                            .font(.caption)
                    }
                    .onTapGesture {
                        selectedImageIdx = 0
                        viewingAnnotatedImage = true
                    }
                    VStack(alignment: .center, spacing: 0) {
                        Image(uiImage: getBackswingImage())
                            .resizable()
                            .cornerRadius(10.0)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 130)
                        Text("Backswing")
                            .font(.caption)
                    }
                    .onTapGesture {
                        selectedImageIdx = 1
                        viewingAnnotatedImage = true
                    }
                    VStack(alignment: .center, spacing: 0) {
                        Image(uiImage: getImpactImage())
                            .resizable()
                            .cornerRadius(10.0)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 130)
                        Text("Impact")
                            .font(.caption)
                    }
                    .onTapGesture {
                        selectedImageIdx = 2
                        viewingAnnotatedImage = true
                    }
                }
                .padding()
                
                Spacer()
                
                Text("Swing tips")
                    .font(.headline)
                
                SwingTipList()

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
//                Button("Create annotated images") {
//                    print("Creating images and saving!!!!!")
//                    if swing.imagesGenerated() {
//                        swing.setupImage = Swing.createAnnotatedUIImage(image: swing.setupImage!, pose: swing.landmarks[swing.setupFrame]!)
//                        swing.backswingImage = Swing.createAnnotatedUIImage(image: swing.backswingImage!, pose: swing.landmarks[swing.backswingFrame]!)
//                        swing.impactImage = Swing.createAnnotatedUIImage(image: swing.impactImage!, pose: swing.landmarks[swing.impactFrame]!)
//                    }
//                }
//                .padding()
            }
            .sheet(isPresented: $viewingAnnotatedImage) {
                if selectedImageIdx == 0 {
                    Image(uiImage: swing.setupImage!)
                        .resizable()
                        .aspectRatio(swing.setupImage!.size, contentMode: .fill)
                } else if selectedImageIdx == 1 {
                    Image(uiImage: swing.backswingImage!)
                        .resizable()
                        .aspectRatio(swing.backswingImage!.size, contentMode: .fill)
                } else {
                    Image(uiImage: swing.impactImage!)
                        .resizable()
                        .aspectRatio(swing.impactImage!.size, contentMode: .fill)
                }
            }
            .navigationTitle("Swing Analysis")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct SwingAnalysis_Previews: PreviewProvider {
    static var swing: Swing = Swing(url: ContentView.stockUrl)
    @State static var status = false
    
    static var previews: some View {
        SwingAnalysis(swing: self.swing, analysisFailed: $status)
    }
}
