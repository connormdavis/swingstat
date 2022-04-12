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
    @State var swingTips: [SwingTip]?
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
        if swing.noPostureDetected {
            VStack(alignment: .center) {
                Text("No person  ")
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
        else if swing.processing || swing.analyzing {
            VStack(alignment: .center) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.green))
                    .scaleEffect(3.0, anchor: .center)
                    .padding()
                if swing.processing {
                    Text("Processing video for posture information...")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.green)
                        .padding()
                }
                
                if swing.analyzing {
                    Text("Analyzing...")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.green)
                        .padding()
                }
                
            }
            .task {
                let tips = await swing.analyzePostureInformation()
                self.swingTips = tips
                self.swing.analyzing = false
            }
        } else {
            
            VStack {
                Text(swing.video!.lastPathComponent)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.green)
                    .padding()
                
                Button("Share posture file") {
                    if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
                        let fileUrl = documentsDirectory.appendingPathComponent("swing.json")
                        
                        let activityVC = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
                        
                        print("presenting activity VC")
                        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
                    } else {
                        print("Failed to load documents directory.")
                        return
                    }
                }
                
                HStack(alignment: .center) {
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
                
                SwingTipList(savedTips: self.swingTips!)
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
