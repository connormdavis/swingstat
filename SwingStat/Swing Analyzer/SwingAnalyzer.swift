//
//  SwingAnalyzer.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 3/1/22.
//

import SwiftUI
import AVKit

struct SwingAnalyzer: View {
    @Environment(\.colorScheme) var colorScheme
    
    // Used for communicating to/from CameraView sheet
    @State var showCameraModal: Bool = false
    @State var selectedVideoUrl: URL = ContentView.stockUrl
    @State var newVideoMode: UIImagePickerController.SourceType = .camera
    
    @State var showSwingAnalysis: Bool = false
    
    @State var savedSwingVideoNames: [String] = SavedSwingVideoManager.getSavedSwingVideoNames()
    
    
    func createSwingsFromVideo() -> [Swing] {
        var swings: [Swing] = []
        for name in savedSwingVideoNames {
            let swingUrl = SavedSwingVideoManager.getSavedVideoPathFromName(name: name)
            swings.append(Swing(url: swingUrl))
        }
        return swings
    }
    

    
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SwingEventChooser(avPlayer: AVPlayer(url: selectedVideoUrl), swingVideo: selectedVideoUrl), isActive: $showSwingAnalysis) { EmptyView() }
                
                VStack{
                    Text("Analyze New Swing:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title2)
                }
                .padding(.horizontal, 25)
                .padding(.top, 20)
                
                HStack {
                    Button("Take New Video") {
                        newVideoMode = .camera
                        showCameraModal = true
                    }
                        .padding()
                        .background(Color.green)
                        .clipShape(Capsule())
                    
                    Button("Choose From Photos") {
                        newVideoMode = .photoLibrary
                        showCameraModal = true
                    }
                        .padding()
                        .background(Color.green)
                        .clipShape(Capsule())
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
                
                VStack{
                    Text("Past Swings:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title2)
                }
                .padding(.bottom, 10)
                .padding(.horizontal, 25)
                
                SavedSwingList(savedSwings: createSwingsFromVideo())
                
            }
            
            .onChange(of: selectedVideoUrl) { newUrl in
                // save the vid to documents directory
                SavedSwingVideoManager.saveSwingVideo(videoUrl: selectedVideoUrl)
                // 'refresh' list
                savedSwingVideoNames = SavedSwingVideoManager.getSavedSwingVideoNames()
                // trigger navigation to analysis view
                self.showSwingAnalysis = true
            }
            .sheet(isPresented: $showCameraModal) {
                CameraView(mode: $newVideoMode, isPresented: $showCameraModal, videoUrl: $selectedVideoUrl)
            }
            .navigationTitle("Swing Analyzer")
            .accentColor(Color.white)
        }
    }
}

struct SwingAnalyzer_Previews: PreviewProvider {
    static var previews: some View {
        SwingAnalyzer()
    }
}
