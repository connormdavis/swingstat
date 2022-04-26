//
//  CameraViewModel.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 4/25/22.
//

import CoreImage


class CameraViewModel: ObservableObject {
    
    @Published var frame: CGImage?
    
    private let frameManager = FrameManager.shared
    
    init() {
        setupSubscriptions()
    }
    
    func setupSubscriptions() {
        frameManager.$current
            .receive(on: RunLoop.main)
            .compactMap { buffer -> CGImage? in
                print("-- recieved frame in pipeline")
                return CGImage.create(from: buffer)
            }
            .assign(to: &$frame)
    }
}
