//
//  EmbeddedVideoView.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 4/27/22.
//

import SwiftUI
import WebKit

struct EmbeddedVideoView: UIViewRepresentable {
    let videoID: String
    
    func makeUIView(context: Context) -> some WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)") else {return}
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: youtubeURL))
    }
}

