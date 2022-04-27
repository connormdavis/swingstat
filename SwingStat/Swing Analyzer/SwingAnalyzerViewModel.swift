//
//  SwingAnalyzerViewModel.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 4/26/22.
//

import Foundation
import UIKit


class SwingAnalyzerViewModel: ObservableObject {
    @Published var videoUrl: URL
    @Published var newVideoMode: UIImagePickerController.SourceType = .camera
    
    init(videoUrl: URL = ContentView.stockUrl) {
        self.videoUrl = videoUrl
    }
}
