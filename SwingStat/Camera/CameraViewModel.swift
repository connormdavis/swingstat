//
//  CameraViewModel.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 4/26/22.
//

import Foundation
import Combine
import AVFoundation
import SwiftUI


final class CameraViewModel: ObservableObject {
    
    private let service = CameraService()
    
    @Published var isRecording = false
        
    @Published var showAlertError = false
    
    @Published var isFlashOn = false
    
    @Published var videoUrl: URL?

    
    var alertError: AlertError!
    
    var session: AVCaptureSession
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        self.session = service.session
        
//        service.$photo.sink { [weak self] (photo) in
//            guard let pic = photo else { return }
//            self?.photo = pic
//        }
//        .store(in: &self.subscriptions)
        
        service.$shouldShowAlertView.sink { [weak self] (val) in
            self?.alertError = self?.service.alertError
            self?.showAlertError = val
        }
        .store(in: &self.subscriptions)
        
        service.$isRecording.sink { [weak self] (val) in
            self?.isRecording = val
        }
        .store(in: &self.subscriptions)
        
        service.$videoUrl.sink { [weak self] (val) in
            self?.videoUrl = val
        }
        .store(in: &self.subscriptions)
        
    }
    
    func configure() {
        service.checkForPermissions()
        service.configure()
    }
    
    func toggleRecording() {
        if isRecording {
            print("-- Stopping video capture")
            service.stopCaptureVideo()
        } else {
            print("-- Starting video capture")
            service.startCaptureVideo()
        }
    }
    
    
}
