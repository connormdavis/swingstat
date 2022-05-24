//
//  SavedSwingList.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 3/1/22.
//

import SwiftUI
import AVKit
import Tabler
import AVFoundation
import CoreMedia
import Foundation

struct SavedSwingList: View {
    @State var savedSwings: [Swing] = []
    @State var analyzerViewModels: [SwingAnalyzerViewModel] = []
    
    @State private var selected: Swing.ID? = nil
    @State private var selectedSwingIdx: Int = -1
    
    @State var bocceBool: Bool = false
    @State var navigateToAnalysis: Bool = false
    
    var gridItems: [GridItem] = [
        GridItem(.flexible(minimum: 35, maximum: 40), alignment: .leading),
        GridItem(.flexible(minimum: 100, maximum: 100), alignment: .leading),
        GridItem(.flexible(minimum: 10, maximum: 65), alignment: .center),
        GridItem(.flexible(minimum: 40, maximum: 80), alignment: .center),
        GridItem(.flexible(minimum: 10, maximum: 65), alignment: .center),
    ]

    typealias Context = TablerContext<Swing>
    typealias Sort = TablerSort<Swing>

    func header(ctx: Binding<Context>) -> some View {
        LazyVGrid(columns: gridItems) {
            Text("    ").font(.system(size: 10))
            Text("Name").font(.system(size: 10))
            Text("Score").font(.system(size: 10))
//            Sort.columnTitle("Score", ctx, \.swingScore).font(.system(size: 10))
//                .onTapGesture{tablerSort(ctx, &savedSwings, \.swingScore) { $0.swingScore < $1.swingScore }}
            Sort.columnTitle("Date", ctx, \.creationDate).font(.system(size: 10))
                .onTapGesture{tablerSort(ctx, &savedSwings, \.creationDate) { $0.creationDate < $1.creationDate }}
            Sort.columnTitle("Duration", ctx, \.videoDuration).font(.system(size: 8))
                .onTapGesture{tablerSort(ctx, &savedSwings, \.videoDuration) { $0.videoDuration < $1.videoDuration }}
       }
    }

    func row(swing: Swing) -> some View {
        LazyVGrid(columns: gridItems) {
            Image(uiImage: swing.thumbnail)
                .resizable()
                .scaledToFit()

          
            Text(swing.filename).lineLimit(1).font(.caption)
            
            Text("5/6").font(.caption2)

            
            // might want to change this to be the day of the analysis of the video, which we can store in the database
            Text(getDateString(date: swing.creationDate)).font(.caption2)
            
            Text(String(format: "%.fs", swing.videoDuration)).font(.caption2)
                
        }
        .onTapGesture {
            // Update selected swing
            selected = swing.id
        }
    }
    
    /*
     Takes the creationDate of a swing which is a Date object, and turns it into the appropriate string
     */
    func getDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY"
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
    
    func swingsUpdated(swings: [Swing]) {
        self.savedSwings = swings
    }
    
    func updateSavedSwings() {
        Task {
            await SavedSwingAnalysis.retrieveAllSavedSwings(handler: swingsUpdated)
            
//            print("Saved swings: \(savedSwings)")
        }
        
        
        
//        let savedSwingVideoNames = SavedSwingVideoManager.getSavedSwingVideoNames()
//        var swings: [Swing] = []
//        for name in savedSwingVideoNames {
//            let swingUrl = SavedSwingVideoManager.getSavedVideoPathFromName(name: name)
//            swings.append(Swing(url: swingUrl))
//        }
//        self.savedSwings = swings
    }
    
    func printSwings() {
        print(savedSwings)
        print(savedSwings.count)
    }
    
    var body: some View {
        VStack {
            TablerList1(header: header,
                row: row,
                results: savedSwings,
                selected: $selected);
            if selectedSwingIdx > -1 {
                NavigationLink(destination: SwingAnalysis(swing: savedSwings[selectedSwingIdx], analysisFailed: $bocceBool, previouslySavedSwing: true), isActive: $navigateToAnalysis) { EmptyView() }
            }
        }
        .onAppear() {
            selected = nil
            
            
            updateSavedSwings()
        }
        .onChange(of: selected, perform: { id in
            
            var i = 0
            while i < savedSwings.count {
                if savedSwings[i].id == id {
                    selectedSwingIdx = i
                }
                i += 1
            }
            
            if selectedSwingIdx == -1 {
                print("ERROR no such swing")
            }
            
            // Trigger navigation
            navigateToAnalysis = true
        })
//        List {
//            ForEach(savedSwings, id: \.id) { swing in
//                NavigationLink {
//                    SwingEventChooser(analyzerViewModel: SwingAnalyzerViewModel(videoUrl: swing.video!), avPlayer: AVPlayer(url: swing.video!))
//                } label: {
//                    SavedSwingItem(swing: swing)
//                }
//            }
//            .onDelete { idxSet in
//                for idx in idxSet {
//                    Task {
//                        await savedSwings[idx].delete()
//                    }
//
//                    self.savedSwings.remove(at: idx)
//                }
//            }
//        }
//
        
//        List {
//            ForEach(savedSwings, id: \.id) { swing in
//                NavigationLink {
//                } label: {
//                    SavedSwingItem(swing: swing)
//                }
//            }
//            .onDelete { idxSet in
//                for idx in idxSet {
//                    savedSwings[idx].delete()
//                    self.savedSwings.remove(at: idx)
//                }
//            }
//        }
//        .onAppear() {
//            updateSavedSwings()
//        }
    }
}

struct SavedSwingList_Previews: PreviewProvider {
    static let swings = [Swing(url: ContentView.stockUrl)]
    
    static let test_swing: Swing = Swing(url: nil)
    
    static var previews: some View {
        Group {
            SavedSwingList(savedSwings: self.swings)
            SavedSwingList(savedSwings: self.swings)
        }
    }
}
