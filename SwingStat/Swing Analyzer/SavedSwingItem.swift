//
//  SavedSwingItem.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 3/1/22.
//

import SwiftUI
import AVKit

struct SavedSwingItem: View {
    
    var swing: Swing

    
    var body: some View {
        HStack {
            Image(uiImage: getThumbnailFrom(path: swing.getVideoURL())!)
                .frame(width: 30, height: 20)
            Text(swing.getFilename()).lineLimit(1).font(.subheadline)
            Spacer()
            Text("03/4/22").font(.caption)
                .fontWeight(.bold)
            Text("8s").font(.caption)
                .fontWeight(.bold)
        }
        .padding()
    }
}
                  
// https://stackoverflow.com/questions/31779150/creating-thumbnail-from-local-video-in-swift
func getThumbnailFrom(path: URL) -> UIImage? {

    do {

        let asset = AVURLAsset(url: path , options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
        let thumbnail = UIImage(cgImage: cgImage)

        return thumbnail

    } catch let error {

        print("*** Error generating thumbnail: \(error.localizedDescription)")
        return nil

    }

}
                  

struct SavedSwingItem_Previews: PreviewProvider {
    static let test_swing: Swing = Swing(url: nil)
    
    static var previews: some View {
        SavedSwingItem(swing: test_swing)
    }
}
