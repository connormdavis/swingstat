//
//  FileManager.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 3/1/22.
//

import Foundation


class SavedSwingVideoManager {
    
    static func getSavedVideoPathFromName(name: String) -> URL {
        let dd = self.getDocumentsDirectory()
        let vidDir = dd.appendingPathComponent("videos")
        return vidDir.appendingPathComponent(name)
    }
    
    static func saveSwingVideo(videoUrl: URL) {
        let docDirectory = self.getDocumentsDirectory()
        let vidDir = docDirectory.appendingPathComponent("videos")
        let name = videoUrl.lastPathComponent
        let filePath = vidDir.appendingPathComponent(name)
        do {
            if !FileManager.default.fileExists(atPath: vidDir.path) {
                try FileManager.default.createDirectory(at: vidDir, withIntermediateDirectories: true)
            }
            try FileManager.default.createFile(atPath: filePath.path, contents: Data(contentsOf: videoUrl), attributes: nil)
        } catch {
            print("Couldn't save video (\(name)): \(error)")
        }
    }
    
    static func getSavedSwingVideoNames() -> [String] {
        let docDirectory = self.getDocumentsDirectory()
        let vidDir = docDirectory.appendingPathComponent("videos")
        do {
            if !FileManager.default.fileExists(atPath: vidDir.path) {
                try FileManager.default.createDirectory(at: vidDir, withIntermediateDirectories: true)
            }
            let items = try FileManager.default.contentsOfDirectory(atPath: vidDir.path)
            return items
        } catch {
            print("Unexpected error: \(error)")
        }
        return []
    }
    
    static func getSavedSwingVideoURL(videoName: String) -> URL? {
        let docDirectory = self.getDocumentsDirectory()
        let vidDir = docDirectory.appendingPathComponent("videos")
        
        do {
            if !FileManager.default.fileExists(atPath: vidDir.path) {
                try FileManager.default.createDirectory(at: vidDir, withIntermediateDirectories: true)
            }
            let items = try FileManager.default.contentsOfDirectory(atPath: vidDir.path)
            for item in items {
                if item == videoName {
                    return vidDir.appendingPathComponent(videoName)
                }
            }
        } catch {
            print("Unexpected error: \(error)")
        }
        return nil
    }
    
    
    
    
    private static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
