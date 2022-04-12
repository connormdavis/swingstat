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
import AVFoundation


struct PosturePhoto {
    @State var image: UIImage
    @State var pose: Pose?
    
    static func createImageViewFromImage(image: UIImage, pose: Pose) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image
        
        let screenSize: CGRect = UIScreen.main.bounds
        let imageSize = CGSize(width: image.size.width, height: image.size.width)
        let screenRect = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        let imageRect = AVMakeRect(aspectRatio: imageSize, insideRect: screenRect)
        imageView.frame = imageRect
        
        let renderer = UIGraphicsImageRenderer(size: imageView.bounds.size)
        let image = renderer.image { ctx in
            let res = imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
            print("res: \(res)")
        }
        
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    
        return imageView
    }
}
