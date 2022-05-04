//
//  SwingTipDetailed.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 3/6/22.
//

import SwiftUI
import YouTubePlayerKit

struct SwingTipDetailed: View {
    @State var swingTip: SwingTip
    var swing: Swing
    
    // The YouTube Player
    private let youTubePlayer = YouTubePlayer(
        source: .url(EmbeddedVid.left_arm_angle_1.youTubeURL)
    )
    
    // All possible videos
    private let embeddedVids: [EmbeddedVid] = EmbeddedVid.all
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(swingTip.type)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
            HStack {
                Text("Result: ")
                    .fontWeight(.thin)
                if swingTip.passed {
                    Text("Passed ✅")
                        .foregroundColor(Color.green)
                } else {
                    Text("Failed ❌")
                        .foregroundColor(Color.red)
                }
            }
            // only show annotated image if it's the left arm angle swing tip
            if swingTip.type == "Left arm angle" {
                HStack {
                    Spacer()
                    Image(uiImage: swing.backswingImage!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250, alignment: .center)
                        .cornerRadius(15)
                    Spacer()
                }
            }
            
            if swingTip.passed {
                Text(swingTip.passedDescription)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
                    .padding(.top, 15.0)
            } else {
                Text(swingTip.failedDescription)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
                    .padding(.top, 15.0)
            }
            
            Spacer()
            
            Text("Helpful Resources:")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title3)
                .padding(.top, 15.0)
            Text("These videos may be helpful in improving this aspect of your swing")
                .fixedSize(horizontal: false, vertical: true)
                .font(.caption)
        }
        .padding()
        
        // Display embeded YouTube videos using YouTubePlayerKit
        ScrollView {
            VStack(spacing: 20) {
//                if swingTip.type == "Left arm angle" {
//                    ForEach(self.embeddedVids) { embeddedVid in
//                        if embeddedVid.category == 1 {
//                            Button(
//                                action: {
//                                    self.youTubePlayer.source = .url(embeddedVid.youTubeURL)
//                                },
//                                label: {
//                                    YouTubePlayerView(
//                                        .init(
//                                            source: .url(embeddedVid.youTubeURL),
//                                            configuration: .init(
//                                                isUserInteractionEnabled: true
//                                            )
//                                        )
//                                    )
//                                    .frame(height: 220)
//                                    .background(Color(.systemBackground))
//                                    .cornerRadius(12)
//                                    .shadow(
//                                        color: .black.opacity(0.1),
//                                        radius: 46,
//                                        x: 0,
//                                        y: 15
//                                    )
//                                }
//                            )
//                        }
//                    }
//                }
//                if swingTip.type == "Lateral head movement" {
//                    ForEach(self.embeddedVids) { embeddedVid in
//                        if embeddedVid.category == 2 {
//                            Button(
//                                action: {
//                                    self.youTubePlayer.source = .url(embeddedVid.youTubeURL)
//                                },
//                                label: {
//                                    YouTubePlayerView(
//                                        .init(
//                                            source: .url(embeddedVid.youTubeURL),
//                                            configuration: .init(
//                                                isUserInteractionEnabled: true
//                                            )
//                                        )
//                                    )
//                                    .frame(height: 220)
//                                    .background(Color(.systemBackground))
//                                    .cornerRadius(12)
//                                    .shadow(
//                                        color: .black.opacity(0.1),
//                                        radius: 46,
//                                        x: 0,
//                                        y: 15
//                                    )
//                                }
//                            )
//                        }
//                    }
//                }
//                if swingTip.type == "Vertical head movement" {
//                    ForEach(self.embeddedVids) { embeddedVid in
//                        if embeddedVid.category == 3 {
//                            Button(
//                                action: {
//                                    self.youTubePlayer.source = .url(embeddedVid.youTubeURL)
//                                },
//                                label: {
//                                    YouTubePlayerView(
//                                        .init(
//                                            source: .url(embeddedVid.youTubeURL),
//                                            configuration: .init(
//                                                isUserInteractionEnabled: true
//                                            )
//                                        )
//                                    )
//                                    .frame(height: 220)
//                                    .background(Color(.systemBackground))
//                                    .cornerRadius(12)
//                                    .shadow(
//                                        color: .black.opacity(0.1),
//                                        radius: 46,
//                                        x: 0,
//                                        y: 15
//                                    )
//                                }
//                            )
//                        }
//                    }
//                }
//                if swingTip.type == "Hip sway" {
//                    ForEach(self.embeddedVids) { embeddedVid in
//                        if embeddedVid.category == 4 {
//                            Button(
//                                action: {
//                                    self.youTubePlayer.source = .url(embeddedVid.youTubeURL)
//                                },
//                                label: {
//                                    YouTubePlayerView(
//                                        .init(
//                                            source: .url(embeddedVid.youTubeURL),
//                                            configuration: .init(
//                                                isUserInteractionEnabled: true
//                                            )
//                                        )
//                                    )
//                                    .frame(height: 220)
//                                    .background(Color(.systemBackground))
//                                    .cornerRadius(12)
//                                    .shadow(
//                                        color: .black.opacity(0.1),
//                                        radius: 46,
//                                        x: 0,
//                                        y: 15
//                                    )
//                                }
//                            )
//                        }
//                    }
//                }
                
                ForEach(self.embeddedVids) { embeddedVid in
                
                    if embeddedVid.category == 1 && swingTip.type == "Left arm angle"{
                        Button(
                            action: {
                                self.youTubePlayer.source = .url(embeddedVid.youTubeURL)
                            },
                            label: {
                                YouTubePlayerView(
                                    .init(
                                        source: .url(embeddedVid.youTubeURL),
                                        configuration: .init(
                                            isUserInteractionEnabled: true
                                        )
                                    )
                                )
                                .frame(height: 220)
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .shadow(
                                    color: .black.opacity(0.1),
                                    radius: 46,
                                    x: 0,
                                    y: 15
                                )
                            }
                        )
                    }
                    else if embeddedVid.category == 2 && swingTip.type == "Lateral head movement" {
                        Button(
                            action: {
                                self.youTubePlayer.source = .url(embeddedVid.youTubeURL)
                            },
                            label: {
                                YouTubePlayerView(
                                    .init(
                                        source: .url(embeddedVid.youTubeURL),
                                        configuration: .init(
                                            isUserInteractionEnabled: true
                                        )
                                    )
                                )
                                .frame(height: 220)
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .shadow(
                                    color: .black.opacity(0.1),
                                    radius: 46,
                                    x: 0,
                                    y: 15
                                )
                            }
                        )
                    }
                    else if embeddedVid.category == 3 && swingTip.type == "Vertical head movement" {
                        Button(
                            action: {
                                self.youTubePlayer.source = .url(embeddedVid.youTubeURL)
                            },
                            label: {
                                YouTubePlayerView(
                                    .init(
                                        source: .url(embeddedVid.youTubeURL),
                                        configuration: .init(
                                            isUserInteractionEnabled: true
                                        )
                                    )
                                )
                                .frame(height: 220)
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .shadow(
                                    color: .black.opacity(0.1),
                                    radius: 46,
                                    x: 0,
                                    y: 15
                                )
                            }
                        )
                    }
                    else if embeddedVid.category == 4 && swingTip.type == "Hip sway" {
                        Button(
                            action: {
                                self.youTubePlayer.source = .url(embeddedVid.youTubeURL)
                            },
                            label: {
                                YouTubePlayerView(
                                    .init(
                                        source: .url(embeddedVid.youTubeURL),
                                        configuration: .init(
                                            isUserInteractionEnabled: true
                                        )
                                    )
                                )
                                .frame(height: 220)
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .shadow(
                                    color: .black.opacity(0.1),
                                    radius: 46,
                                    x: 0,
                                    y: 15
                                )
                            }
                        )
                    }
                }
                .padding()
            }
        }
    }
}

struct SwingTipDetailed_Previews: PreviewProvider {
    static var swingTip = SwingTip(type: "", passed: false, miniDescription: "", passedDescription: "", failedDescription: "", help: "")
    
    static let test_swing: Swing = Swing(url: nil)
    
    static var previews: some View {
        SwingTipDetailed(swingTip: swingTip, swing: test_swing)
    }
}
