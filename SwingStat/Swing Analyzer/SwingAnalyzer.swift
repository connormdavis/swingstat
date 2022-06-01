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
    
    @StateObject var swingAnalyzerViewModel = SwingAnalyzerViewModel()
    
    // Used for communicating to/from CameraView sheet
    @State var showCameraModal: Bool = false
    @State var selectedVideoUrl: URL = ContentView.stockUrl
    
    @State var showSwingAnalysis: Bool = false
    
    @State var savedSwingVideoNames: [String] = SavedSwingVideoManager.getSavedSwingVideoNames()
    
    @ObservedObject var swingFilterModel = SwingFilterModel()
    
    
    // set initial state of filters to be none
    @State var filterButtonState: FilterButtonState = .none()
    
    
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
                NavigationLink(destination: SwingEventChooser(analyzerViewModel: swingAnalyzerViewModel, avPlayer: AVPlayer(url: self.selectedVideoUrl)), isActive: $showSwingAnalysis) { EmptyView() }
                
                VStack {
                    Text("Analyze New Swing:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title2)
                }
                .onAppear() {
                    
                    
//                    savedSwingVideoNames = SavedSwingVideoManager.getSavedSwingVideoNames()
//                    print("VIDEO NAMES: \(savedSwingVideoNames)")
                }
                
                .padding(.horizontal, 25)
                .padding(.top, 20)
                
                HStack {
                    Button("Take New Video") {
                        self.swingAnalyzerViewModel.newVideoMode = .camera
                        self.showCameraModal = true
                    }
                        .padding()
                        .background(Color.green)
                        .clipShape(Capsule())
                    
                    Button("Choose From Photos") {
                        self.swingAnalyzerViewModel.newVideoMode = .photoLibrary
                        self.showCameraModal = true
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
                
                VStack {
                    Text("Filter swings by:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        ForEach(0..<swingFilterModel.data.count) { index in
                            SwingFilterTag(swingFilterData: swingFilterModel.data[index])
                               .onTapGesture {
                                   switch swingFilterModel.data[index].status {
                                   case .none:
                                       swingFilterModel.toggleFilter(at: index, state: .passed())
                                   case .passed:
                                       swingFilterModel.toggleFilter(at: index, state: .failed())
                                   case .failed:
                                       swingFilterModel.toggleFilter(at: index, state: .none())
                                   }
                                   
                                   //
                               }
                               .contextMenu {
                                   Button {
                                       swingFilterModel.toggleFilter(at: index, state: .passed())
                                   } label: {
                                       Label("Passed \(swingFilterModel.data[index].title) 🟢", systemImage: "checkmark")
                                           .labelStyle(.titleOnly)
                                   }
 
                                   Button {
                                       swingFilterModel.toggleFilter(at: index, state: .failed())
                                   } label: {
                                       Label("Failed \(swingFilterModel.data[index].title) 🔴", systemImage: "xmark")
                                           .labelStyle(.titleOnly)
                                   }
                  
                                   Button {
                                       swingFilterModel.toggleFilter(at: index, state: .none())
                                   } label: {
                                       Label("Don't filter by \(swingFilterModel.data[index].title) ⚪", systemImage: "").labelStyle(.titleOnly)
                                   }
         
                               }
                        }
                    }
                }
                .padding(.bottom, 10)
                .padding(.horizontal, 25)
                
               
                SavedSwingList(selectionStatus: self.$swingFilterModel.selectionStatus)
                
            }
            .onChange(of: selectedVideoUrl) { newUrl in
                swingAnalyzerViewModel.videoUrl = newUrl
                // trigger navigation to analysis view
                self.showSwingAnalysis = true
            }
            .onChange(of: swingAnalyzerViewModel.videoUrl) { newUrl in
                // trigger navigation to analysis view
                self.showSwingAnalysis = true
                self.showCameraModal = false
            }
            .sheet(isPresented: self.$showCameraModal) {
                if self.swingAnalyzerViewModel.newVideoMode == .photoLibrary {
                    PhotoLibraryView(isPresented: $showCameraModal, videoUrl: $selectedVideoUrl)
                } else {
                    CameraView(analyzerViewModel: swingAnalyzerViewModel)
                }
                
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
