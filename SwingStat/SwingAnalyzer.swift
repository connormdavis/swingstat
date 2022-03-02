//
//  SwingAnalyzer.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 3/1/22.
//

import SwiftUI

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
    
    
    func doSomething() {
        
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SwingAnalysis(name: selectedVideoUrl.lastPathComponent), isActive: $showSwingAnalysis) { EmptyView() }
                
                HStack {
                    Button("Record new video") {
                        newVideoMode = .camera
                        showCameraModal = true
                    }
                        .padding()
                        .background(colorScheme == .dark ? Color.white : Color.black)
                        .clipShape(Capsule())
                    
                    Button("Choose new video") {
                        newVideoMode = .photoLibrary
                        showCameraModal = true
                    }
                        .padding()
                        .background(colorScheme == .dark ? Color.white : Color.black)
                        .clipShape(Capsule())
                }
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
        }
        .navigationTitle("Swing Analyzer")
    }
}

struct SwingAnalyzer_Previews: PreviewProvider {
    static var previews: some View {
        SwingAnalyzer()
    }
}
