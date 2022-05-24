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
    var videoName: String
    
    var swingTips: [SwingTip]
    var goodSwing: Bool
    
    var setupFrame: Int
    var setupImage: String
    var setupFramePose: PoseSerializable
    
    var backswingFrame: Int
    var backswingImage: String
    var backswingFramePose: PoseSerializable
    
    var impactFrame: Int
    var impactImage: String
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
    
    
    static func retrieveAllSavedSwings(handler: @escaping ([Swing]) -> Void) async {
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

                
//                let cleanJsonData = SavedSwingAnalysis.cleanEjsonTypes(data: data)

                
                // de-serialize swing JSON
                let savedSwings = try JSONDecoder().decode(SavedSwingAnalysisCollection.self, from: data)
//                print("SAVED SWINGS: \(savedSwings)")

                for savedSwing in savedSwings.swings {
                    let s = Swing.loadFromSavedAnalysis(savedAnalysis: savedSwing)
//                    print("swing: \(s)")
                    swingsList.append(s)
                }

            } catch let error {
                print(String(describing: error))
            }
            
            // pass back
            handler(swingsList)
        })

        task.resume()
        
        
        
        
        
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
    
    private static func cleanEjsonTypes(data: Data) -> Data? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
            
            
//            print("Recieved JSON: \(String(data: data, encoding: .utf8))")
            
            if var swings = json?["swings"] as? [[String: Any]] {
                let numSwings = swings.count
                var i = 0
                while i < numSwings {
                    var swing = swings[i]
//                    let setupLandmarks = swing["setupFramePose"]["poseLandmarks"]
                    // SETUP FRAME -------------------------------------------------
                    if var setupFramePose = swing["setupFramePose"] as? [String: Any] {
                        if var setupLandmarks = setupFramePose["poseLandmarks"] as? [String: Any] {
                            for (key, _) in setupLandmarks {
                                if var landmark = setupLandmarks[key] as? [String: Any] {
                                    if var position = landmark["position"] as? [String: Any] {
                                        let x = position["x"] as? [String: Any]
                                        let y = position["y"] as? [String: Any]
                                        let z = position["z"] as? [String: Any]
                                        let nestedXVal = x!["$numberDouble"] as? String
                                        let nestedYVal = y!["$numberDouble"] as? String
                                        let nestedZVal = z!["$numberDouble"] as? String
                                        
                                        // Update position values
                                        position["x"] = Float(nestedXVal!)
                                        position["y"] = Float(nestedYVal!)
                                        position["z"] = Float(nestedZVal!)
                                        
                                        landmark["position"] = position
                                        
                                        // Update type & inFrameLikelihood
                                        if var landmarkType = landmark["landmarkType"] as? [String: Any] {
                                            landmark["landmarkType"] = Int(landmarkType["$numberDouble"] as! String)
                                        }
                                        if var inFrame = landmark["inFrameLikelihood"] as? [String: Any] {
                                            landmark["inFrameLikelihood"] = Float(inFrame["$numberDouble"] as! String)
                                        }

                                        
                                    }
                                    setupLandmarks[key] = landmark
                                    
//                                        print("updated setup landmarks: \(setupLandmarks[key])")
                                }

                            }
                            setupFramePose["poseLandmarks"] = setupLandmarks
                        }
                        swing["setupFramePose"] = setupFramePose
//                        print("setupframePose: \(swing["setupFramePose"])")
                    }
                    
                    // BACKSWING FRAME -------------------------------------------------
                    if var backswingFramePose = swing["backswingFramePose"] as? [String: Any] {
                        if var backswingLandmarks = backswingFramePose["poseLandmarks"] as? [String: Any] {
                            for (key, _) in backswingLandmarks {
                                if var landmark = backswingLandmarks[key] as? [String: Any] {
                                    if var position = landmark["position"] as? [String: Any] {
                                        let x = position["x"] as? [String: Any]
                                        let y = position["y"] as? [String: Any]
                                        let z = position["z"] as? [String: Any]
                                        let nestedXVal = x!["$numberDouble"] as? String
                                        let nestedYVal = y!["$numberDouble"] as? String
                                        let nestedZVal = z!["$numberDouble"] as? String
                                        
                                        // Update position values
                                        position["x"] = Float(nestedXVal!)
                                        position["y"] = Float(nestedYVal!)
                                        position["z"] = Float(nestedZVal!)
                                        
                                        landmark["position"] = position
                                        
                                        // Update type & inFrameLikelihood
                                        if var landmarkType = landmark["landmarkType"] as? [String: Any] {
                                            landmark["landmarkType"] = Int(landmarkType["$numberDouble"] as! String)
                                        }
                                        if var inFrame = landmark["inFrameLikelihood"] as? [String: Any] {
                                            landmark["inFrameLikelihood"] = Float(inFrame["$numberDouble"] as! String)
                                        }

                                        
                                    }
                                    backswingLandmarks[key] = landmark
                                    
//                                        print("updated setup landmarks: \(setupLandmarks[key])")
                                }

                            }
                            backswingFramePose["poseLandmarks"] = backswingLandmarks
                        }
                        swing["backswingFramePose"] = backswingFramePose

                    }
                    
                    // IMPACT FRAME -------------------------------------------------
                    if var impactFramePose = swing["impactFramePose"] as? [String: Any] {
                        if var impactLandmarks = impactFramePose["poseLandmarks"] as? [String: Any] {
                            for (key, _) in impactLandmarks {
                                if var landmark = impactLandmarks[key] as? [String: Any] {
                                    if var position = landmark["position"] as? [String: Any] {
                                        let x = position["x"] as? [String: Any]
                                        let y = position["y"] as? [String: Any]
                                        let z = position["z"] as? [String: Any]
                                        let nestedXVal = x!["$numberDouble"] as? String
                                        let nestedYVal = y!["$numberDouble"] as? String
                                        let nestedZVal = z!["$numberDouble"] as? String
                                        
                                        // Update position values
                                        position["x"] = Float(nestedXVal!)
                                        position["y"] = Float(nestedYVal!)
                                        position["z"] = Float(nestedZVal!)
                                        
                                        landmark["position"] = position
                                        
                                        // Update type & inFrameLikelihood
                                        if var landmarkType = landmark["landmarkType"] as? [String: Any] {
                                            landmark["landmarkType"] = Int(landmarkType["$numberDouble"] as! String)
                                        }
                                        if var inFrame = landmark["inFrameLikelihood"] as? [String: Any] {
                                            landmark["inFrameLikelihood"] = Float(inFrame["$numberDouble"] as! String)
                                        }

                                        
                                    }
                                    impactLandmarks[key] = landmark
                                    
//                                        print("updated setup landmarks: \(setupLandmarks[key])")
                                }

                            }
                            impactFramePose["poseLandmarks"] = impactLandmarks
                        }
                        swing["impactFramePose"] = impactFramePose
                    }
                    
                    if var setupFrame = swing["setupFrame"] as? [String: Any] {
                        swing["setupFrame"] = Int(setupFrame["$numberDouble"] as! String)
                    }
                    
                    if var backswingFrame = swing["backswingFrame"] as? [String: Any] {
                        swing["backswingFrame"] = Int(backswingFrame["$numberDouble"] as! String)
                    }
                    
                    if var impactFrame = swing["impactFrame"] as? [String: Any] {
                        swing["impactFrame"] = Int(impactFrame["$numberDouble"] as! String)
                    }
                    
                    if var leftArmAngleFrame = swing["leftArmAngleFrame"] as? [String: Any] {
                        swing["leftArmAngleFrame"] = Int(leftArmAngleFrame["$numberDouble"] as! String)
                    }
                    
                    if var totalFrames = swing["totalFrames"] as? [String: Any] {
                        swing["totalFrames"] = Int(totalFrames["$numberDouble"] as! String)
                    }
                    
                    swings[i] = swing
//                    print("swing[\(i)]: \(swings[i])")
                    
//                    do {
//                        if i == 0 {
//                            if let swingData = try? JSONSerialization.data(withJSONObject: swings[i], options: []) {
//    //                            print("jsonData: \(String(data: cleanJsondata, encoding: .utf8))")
//
//                                let savedSwing = try JSONDecoder().decode(SavedSwingAnalysis.self, from: swingData)
//                                print("savedSwing: \(savedSwing)")
//                            }
//
//                        }
//                    } catch {
//                        print(String(describing: error))
//                    }
                    
                    
                    i += 1
                }
                
                var collection: [String: Any] = [:]
                collection["swings"] = swings
                
                if let cleanJsondata = try? JSONSerialization.data(withJSONObject: collection, options: []) {
//                    print("jsonData: \(String(data: cleanJsondata, encoding: .utf8))")
                    
                    return cleanJsondata
                    

                }
            }
        
            
        } catch {
            print("Error: \(error)")
            return nil
        }
        
        return nil
    }
}
