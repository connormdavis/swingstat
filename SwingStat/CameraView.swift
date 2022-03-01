//
//  CameraView.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 2/22/22.
//

import Foundation
import UIKit
import SwiftUI
import UniformTypeIdentifiers
import MobileCoreServices

struct CameraView: UIViewControllerRepresentable {
    @Binding var mode: UIImagePickerController.SourceType
    @Binding var isPresented: Bool
    @Binding var videoUrl: URL
    
    typealias UIViewControllerType = UIImagePickerController
    
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let viewController = UIViewControllerType()
        
        if self.mode == .photoLibrary {
            viewController.delegate = context.coordinator
            viewController.sourceType = .photoLibrary
            viewController.videoQuality = .typeHigh
            viewController.allowsEditing = true
            viewController.mediaTypes = ["public.movie"]
            return viewController
        } else {
            viewController.delegate = context.coordinator
            viewController.sourceType = .camera
            viewController.mediaTypes = ["public.movie"]
            viewController.cameraCaptureMode = .video
            viewController.videoQuality = .typeHigh
            viewController.cameraDevice = .rear
            viewController.allowsEditing = true
            return viewController
        }
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> CameraView.Coordinator {
        return Coordinator(self)
    }
}

extension CameraView {
    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // Pressed 'cancel' so hide the sheet
            parent.isPresented = false
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as! URL
            parent.isPresented = false
        }
    }
}
