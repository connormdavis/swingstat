//
//  SavedSwingAnalysis.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 5/10/22.
//

import Foundation

struct SavedSwingAnalysis: Codable {
    var id: String
    var _id: String
    var video: URL
    
    var swingTips: [SwingTip]
    var goodSwing: Bool
    
    var setupFrame: Int
    var setupFramePose: PoseSerializable
    
    var backswingFrame: Int
    var backswingFramePose: PoseSerializable
    
    var impactFrame: Int
    var impactFramePose: PoseSerializable
    
    var leftArmAngleFrame: Int
    var totalFrames: Int
    
    func getJson() -> Data {
        let encoder = JSONEncoder()
        let analysisJson = try! encoder.encode(self)
        return analysisJson
    }
    
    // Sends this swing analysis object to the backend DB
    func saveToBackend() {

        //create the url with NSURL
        let url = URL(string: "https://us-east-1.aws.data.mongodb-api.com/app/swingstat_swings-lotdm/endpoint/swing")!

        //create the session object
        let session = URLSession.shared

        //now create the Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        let json = self.getJson()

        request.httpBody = json

        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                print(error!)
                return
            }

            guard let data = data else {
                print("Data returned is nil. Error.")
                return
            }

            do {
                //create json object from data
//                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
//                    print("Invalid JSON type error.")
//                    return
//                }
                
                print(response)
            } catch let error {
                print(error.localizedDescription)
            }
        })

        task.resume()
    }
    
    
    static func retrieveAllSavedSwings() async -> [Swing] {
        var swingsList: [Swing] = []
        
        //create the url with NSURL
        let url = URL(string: "https://us-east-1.aws.data.mongodb-api.com/app/swingstat_swings-lotdm/endpoint/swings")!

        //create the session object
        let session = URLSession.shared

        //now create the Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "GET" //set http method as POST

        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                print(error!)
                return
            }

            guard let data = data else {
                print("Data returned is nil. Error.")
                return
            }

            do {
//                let jsonStr = String(decoding: data, as: UTF8.self)
//                let jsonData = Data(jsonStr.utf8)
//                print(jsonStr)
                print("jsonData: \(String(data: data, encoding: .utf8))")
                
                // de-serialize swing JSON
                let savedSwings = try JSONDecoder().decode(SavedSwingAnalysisCollection.self, from: data)
                
                for savedSwing in savedSwings.swings {
                    let s = Swing.loadFromSavedAnalysis(savedAnalysis: savedSwing)
                    swingsList.append(s)
                }

            } catch let error {
                print(error.localizedDescription)
            }
        })

        task.resume()
        
        return swingsList
        
        
        
//        var request = URLRequest(url: URL(string: "https://us-east-1.aws.data.mongodb-api.com/app/swingstat_swings-lotdm/endpoint/swings")!)
//        request.httpMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        do {
//            // Send request
//            let (data, _) = try await URLSession.shared.data(for: request)
//            let savedSwings = try JSONDecoder().decode(SavedSwingAnalysisCollection.self, from: data)
//
//            for savedSwing in savedSwings.swings {
//                let s = Swing.loadFromSavedAnalysis(savedAnalysis: savedSwing)
//                swingsList.append(s)
//            }
//
////            print("Success deleting swing w/ ID \(self.id) from DB.")
////                        let swingTipResults = try JSONDecoder().decode(SwingTipResults.self, from: data)
//        } catch {
//            print("Error (couldn't get saved swings): \(error.localizedDescription)")
//        }
//
//        return swingsList
    }
}
