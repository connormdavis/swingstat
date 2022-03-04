//
//  PosturePhoto.swift.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 3/1/22.
//

import Foundation
import SwiftUI
import UIKit
import MLKitPoseDetectionAccurate


struct PosturePhoto: UIViewRepresentable {
    @State var image: UIImage
    @State var pose: Pose?
    
    func createImageViewWithAnnotations() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = self.image
        return imageView
        // use UIUtilities.addCircle() & shite to add subviews to the main 'imageView' and return it
    }
    
    func makeUIView(context: Context) -> UIImageView {
        return createImageViewWithAnnotations()
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
    }
}
