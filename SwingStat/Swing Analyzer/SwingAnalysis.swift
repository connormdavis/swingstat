//
//  SwingAnalysis.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 3/1/22.
//

import SwiftUI
import UIKit
import AVFoundation

struct SwingAnalysis: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss

    @ObservedObject var swing: Swing
    @State var swingTips: [SwingTip]?
    @Binding var analysisFailed: Bool
    @State var previouslySavedSwing: Bool
    
    @State var viewingAnnotatedImage: Bool = false
    @State var selectedImageIdx = 0
    @State var showSwingAnalyzer = false
    
    @State var isEditingName = false
    @State var currName = ""
    
    func beginEditingName() {
        currName = swing.swingName
        isEditingName = true
        print("edit button pressed")
    }
    
    
    func endEditingName() {
        print("save button pressed")
        swing.swingName = currName
        isEditingName = false
        
        Task {
            await swing.updateSwingName(name: currName)
        }
    }
   
    
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
    
    func showVideoAnalyzer() {
        showSwingAnalyzer = true
    }
    
    func createPlayer() -> AVPlayer {
        let player = AVPlayer(url: swing.video!)
        return player
    }
    
    
    func shareJSON() {
        print("share JSON")
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
        else if (swing.regeneratingImages) {
            VStack(alignment: .center) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.green))
                    .scaleEffect(3.0, anchor: .center)
                    .padding()
                Text("Retrieving analysis...")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.green)
                    .padding()
                
            }
        }
        else if (!previouslySavedSwing && (swing.processing || swing.analyzing)) {
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
                if !previouslySavedSwing {
                    let tips = await swing.analyzePostureInformation()
                    self.swingTips = tips
                    self.swing.analyzing = false
                    
                    // Now store this new swing analysis in the backend
                    let analysis = self.swing.createSavableAnalysisItem(tips: tips)
                    analysis.saveToBackend()
                    
                    
//                    let analysisJson = analysis.getJson()
//
//                    print("ANALYSIS JSON -> \(analysisJson)")
//
//
//
//
//                    var request = URLRequest(url: URL(string: "https://us-east-1.aws.data.mongodb-api.com/app/swingstat_swings-lotdm/endpoint/swing")!)
//                    request.httpMethod = "POST"
//                    request.httpBody = analysisJson
//                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//
//                    //request.addValue("\(analysisJson.count)", forHTTPHeaderField: "Content-Length")
//
//
////                    print("body: \(String(decoding: request.httpBody!, as: UTF8.self))")
//
//                    do {
//                        // Send request
//                        let (data, _) = try await URLSession.shared.data(for: request)
//                        print("Success saving new analysis to MongoDB.")
////                        let swingTipResults = try JSONDecoder().decode(SwingTipResults.self, from: data)
//                    } catch {
//                        print("Error (couldn't save new swing analysis): \(error.localizedDescription)")
//                    }
                } else {
                    // don't request analysis, used previously saved tips
                    self.swingTips = swing.swingTips
                }
            }
        } else {
            VStack {
                
                HStack(alignment: .center) {
                    if isEditingName {
                        TextField("", text: $currName)
                            .multilineTextAlignment(.center)
                            .font(Font.system(size: 30, weight: .bold, design: .default))
                            .foregroundColor(Color.green)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(20.0)
//                            .padding()
                        
                        VStack {
                            Text("???").frame(width: 50, height: 30)
//                            Spacer().frame(height: 50)
                            Text("Save")
                                .font(.caption)
                        }
                        .background(Color.green.opacity(0.2))
                        .contentShape(Rectangle())
                        .cornerRadius(10)
                        .onTapGesture {
                            endEditingName()
                        }
                        
//                        Button(action: {
//                            print("editing done")
//                            endEditingName()
//                        }, label: {
//                            Text("???")
//
//                                .frame(minWidth: 40, minHeight: 40, alignment: .center)
//                                .clipped()
//                                .background(Color.green.opacity(0.2))
//                                .cornerRadius(7)
////                                .padding()
//                        })
                            
                            
                        
                        
                    } else {
                        Text(swing.swingName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.green)
//                            .padding()
                        
                        VStack {
                            Text("??????").frame(width: 50, height: 30)
//                            Spacer().frame(height: 50)
                            Text("Edit")
                                .font(.caption)
                        }
                        .background(Color.green.opacity(0.2))
                        .contentShape(Rectangle())
                        .cornerRadius(10)
                        .onTapGesture {
                            beginEditingName()
                        }
                        
//                        Button(action: {
//                            print("began editing")
//                            beginEditingName()
//                        }, label: {
//                            Text("??????")
//                                .frame(minWidth: 40, minHeight: 40, alignment: .center)
//                                .clipped()
//                                .background(Color.green.opacity(0.2))
//                                .cornerRadius(7)
////                                .padding()
//                        })
            
                            
                            
                        
               
                    }
                }
//                .zIndex(1)
                .padding(.top, 20)
                .padding(.leading, 10)
                .padding(.trailing, 10)
 
                
                HStack(alignment: .center) {
                    VStack(alignment: .center, spacing: 0) {
                        Image(uiImage: getSetupImage())
                            .resizable()
                            .cornerRadius(30.0)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150)
                        Text("Setup")
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                    .onTapGesture {
                        selectedImageIdx = 0
                        viewingAnnotatedImage = true
                    }
                    VStack(alignment: .center, spacing: 0) {
                        Image(uiImage: getBackswingImage())
                            .resizable()
                            .cornerRadius(30.0)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150)
                        Text("Backswing")
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                    .onTapGesture {
                        selectedImageIdx = 1
                        viewingAnnotatedImage = true
                    }
                    VStack(alignment: .center, spacing: 0) {
                        Image(uiImage: getImpactImage())
                            .resizable()
                            .cornerRadius(30.0)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150)
                        Text("Impact")
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                    .onTapGesture {
                        selectedImageIdx = 2
                        viewingAnnotatedImage = true
                    }
                }
                .padding(.bottom, 10)
                .padding(.leading, 10)
                .padding(.trailing, 10)

                
                Spacer()
                
                Button(action: showVideoAnalyzer) {
                    Text("Video analyzer ????")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                }
                .padding()
                .background(Color.green)
                .clipShape(Capsule())
                
                VStack {
                    Text("Estimated Drive Distance")
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("\(String(format: "%.1f", swing.estimatedDistance)) yds")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .padding()
                
                
//                Button(action: shareJSON) {
//                    Text("JSON ????")
//                        .font(.headline)
//                        .foregroundColor(Color.white)
//                        .fontWeight(.bold)
//                }
//                .padding()
//                .background(Color.gray)
//                .clipShape(Capsule())
                
                Text("Swing tips")
                    .font(.headline)
                    .padding()
                
                if previouslySavedSwing {
                    SwingTipList(savedTips: swing.swingTips, swing: swing)
                } else {
                    SwingTipList(savedTips: self.swingTips!, swing: swing)
                }
                
            }
            .sheet(isPresented: $viewingAnnotatedImage) {
                if selectedImageIdx == 0 {
                    VStack {
                        Text("Setup")
                            .font(.largeTitle)
                            .foregroundColor(Color.green)
                        Text("Swipe down to hide")
                            .font(.subheadline)
                            .foregroundColor(Color.gray)
                        Image(uiImage: swing.setupImage!)
                            .resizable()
                            .aspectRatio(swing.setupImage!.size, contentMode: .fill)
                            .cornerRadius(25)
                    }
                    .padding()
                    
                } else if selectedImageIdx == 1 {
                    VStack {
                        Text("Backswing")
                            .font(.largeTitle)
                            .foregroundColor(Color.green)
                        Text("Swipe down to hide")
                            .font(.subheadline)
                            .foregroundColor(Color.gray)
                        Image(uiImage: swing.backswingImage!)
                            .resizable()
                            .aspectRatio(swing.backswingImage!.size, contentMode: .fill)
                            .cornerRadius(25)
                    }
                    .padding()
                } else {
                    VStack {
                        Text("Impact")
                            .font(.largeTitle)
                            .foregroundColor(Color.green)
                        Text("Swipe down to hide")
                            .font(.subheadline)
                            .foregroundColor(Color.gray)
                        Image(uiImage: swing.impactImage!)
                            .resizable()
                            .aspectRatio(swing.impactImage!.size, contentMode: .fill)
                            .cornerRadius(25)
                    }
                    .padding()
                }
            }
            .sheet(isPresented: $showSwingAnalyzer) {
                VideoAnalyzer(avPlayer: createPlayer())
            }
            
//            ShareAnalysisItem(swing: swing)

            .navigationTitle("Swing Analysis")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        print("sharing analysis")
                        
                        var leftArmAngleTip: SwingTip?
                        var latHeadMovTip: SwingTip?
                        var vertHeadMovTip: SwingTip?
                        var swingTempoTip: SwingTip?
                        var hipSwayTip: SwingTip?
                        if previouslySavedSwing {
                            for tip in swing.swingTips {
                                if tip.type == "Left arm angle" {
                                    leftArmAngleTip = tip
                                } else if tip.type == "Lateral head movement" {
                                    latHeadMovTip = tip
                                } else if tip.type == "Vertical head movement" {
                                    vertHeadMovTip = tip
                                } else if tip.type == "Swing tempo" {
                                    swingTempoTip = tip
                                } else {
                                    hipSwayTip = tip
                                }
                            }
                        } else {
                            for tip in self.swingTips! {
                                if tip.type == "Left arm angle" {
                                    leftArmAngleTip = tip
                                } else if tip.type == "Lateral head movement" {
                                    latHeadMovTip = tip
                                } else if tip.type == "Vertical head movement" {
                                    vertHeadMovTip = tip
                                } else if tip.type == "Swing tempo" {
                                    swingTempoTip = tip
                                } else {
                                    hipSwayTip = tip
                                }
                            }
                        }
                        
                        
                        let shareAnalysisView = ShareAnalysisItem(swing: self.swing, leftArmAngleTip: leftArmAngleTip!, latHeadMovTip: latHeadMovTip!, vertHeadMovTip: vertHeadMovTip!, swingTempoTip: swingTempoTip!, hipSwayTip: hipSwayTip!)
                        
                        
//                        try await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
                        
//                        print(shareAnalysisView.leftArmAngleTip)
//                        print(shareAnalysisView.latHeadMovTip)
                        
                        let sharableImage = shareAnalysisView.snapshot()
                        let activityController = UIActivityViewController(activityItems: [sharableImage], applicationActivities: nil)

                        UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
                        
                    } label: {
                        Image(systemName: "square.and.arrow.up").font(.body)
                    }
                    
//                    NavigationLink(destination: ContentView()) {
//                        Image(systemName: "person.crop.circle").font(.title)
//                    }
                }
            }
        }
    }
}


struct SwingAnalysis_Previews: PreviewProvider {
    static var swing: Swing = Swing(url: ContentView.stockUrl)
    @State static var status = false
    
    static var previews: some View {
        SwingAnalysis(swing: self.swing, analysisFailed: $status, previouslySavedSwing: false)
    }
}
