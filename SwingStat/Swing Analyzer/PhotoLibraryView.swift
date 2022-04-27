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

struct PhotoLibraryView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var videoUrl: URL
    
    typealias UIViewControllerType = UIImagePickerController
    
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let viewController = UIViewControllerType()
        
        viewController.delegate = context.coordinator
        viewController.sourceType = .photoLibrary
        viewController.videoQuality = .typeHigh
        viewController.allowsEditing = true
        viewController.mediaTypes = ["public.movie"]
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> PhotoLibraryView.Coordinator {
        return Coordinator(self)
    }
}

extension PhotoLibraryView {
    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: PhotoLibraryView
        
        init(_ parent: PhotoLibraryView) {
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
