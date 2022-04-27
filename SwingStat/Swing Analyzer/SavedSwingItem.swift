//
//  SavedSwingItem.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 3/1/22.
//

import SwiftUI
import AVKit
import AVFoundation
import CoreMedia
import Foundation

struct SavedSwingItem: View {
    
    var swing: Swing
    
    

    
    var body: some View {
        HStack {
            VStack {
                Image(uiImage: getThumbnailFrom(path: swing.getVideoURL())!)
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 60, height: 60)
            HStack {
                Text(swing.getFilename()).lineLimit(1).font(.subheadline)
                Spacer()
                Text("03/4/22").font(.caption)
                    .fontWeight(.bold)
                Text(getDurationFrom(path: swing.getVideoURL())).font(.caption)
                    .fontWeight(.bold)
            }
        }
    }
}
                  
// https://stackoverflow.com/questions/31779150/creating-thumbnail-from-local-video-in-swift
/*
 Returns the thumbnail of a file given its URL
 */
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

/*
 Returns the duration of a file given its URL
 */
func getDurationFrom(path: URL) -> String {
 
    let asset = AVAsset(url: path)

    let duration = asset.duration
    let durationTime = CMTimeGetSeconds(duration)
    let durationTimeStr = String(format: "%.fs", durationTime)
    
    return durationTimeStr
}

/*
 Returns the date a file was created given its URL
 */
func getDateCreatedFrom(path: URL) -> String {
 
    let asset = AVAsset(url: path)

    let date = asset.creationDate
    let dateConverted = (date?.dateValue)!
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/YY"
    return dateFormatter.string(from: dateConverted)
    
}

                  

struct SavedSwingItem_Previews: PreviewProvider {
    static let test_swing: Swing = Swing(url: nil)
    
    static var previews: some View {
        SavedSwingItem(swing: test_swing)
    }
}
