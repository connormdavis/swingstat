//
//  CameraView.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 4/26/22.
//

import SwiftUI

struct CameraView: View {
    @StateObject var model = CameraViewModel()
    @StateObject var analyzerViewModel: SwingAnalyzerViewModel
    
    
    
    var captureButton: some View {
        Button(action: {
            model.toggleRecording()
        }, label: {
            Circle()
                .foregroundColor(.white)
                .frame(width: 80, height: 80, alignment: .center)
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.8), lineWidth: 2)
                        .frame(width: 65, height: 65, alignment: .center)
                )
        })
    }
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
//                    Button(action: {
//                        model.switchFlash()
//                    }, label: {
//                        Image(systemName: model.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
//                            .font(.system(size: 20, weight: .medium, design: .default))
//                    })
//                    .accentColor(model.isFlashOn ? .yellow : .white)
                    
                    if model.isRecording {
                        HStack {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 10, height: 10)
                            Text("Recording...")
                                .foregroundColor(Color.red)
                                .font(.subheadline)
                        }
                        .padding()
                        
                    } else {
                        Text("Record your swing")
                            .foregroundColor(Color.gray)
                            .font(.subheadline)
                            .padding()
                    }
                    
                    CameraPreview(session: model.session)
                        .onAppear {
                            model.configure()
                        }
                        .alert(isPresented: $model.showAlertError, content: {
                            Alert(title: Text(model.alertError.title), message: Text(model.alertError.message), dismissButton: .default(Text(model.alertError.primaryButtonTitle), action: {
                                model.alertError.primaryAction?()
                            }))
                        })
                        .animation(.easeInOut)
                    
                    HStack {
                        
                        Spacer()
                        
                        captureButton
                        
                        Spacer()
                        
                    }
                    .padding(.horizontal, 20)
                }
            }
            .onChange(of: model.videoUrl) { newUrl in
                analyzerViewModel.videoUrl = newUrl!
            }
        }
    }
}
