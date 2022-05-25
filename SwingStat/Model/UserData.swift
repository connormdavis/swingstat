//
//  UserData.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 5/10/22.
//

import Foundation


struct UserData: Codable {
    var id: String
    var firstName: String
    var lastName: String
    var height: Float   // number of inches

    
//    static func requestSignup(email: String, password: String) -> Bool {
        
//        let userId = UserData.getUserId()
//        
//        var components = URLComponents()
//        components.scheme = "https"
//        components.host = "us-east-1.aws.data.mongodb-api.com"
//        components.path = "/app/swingstat_swings-lotdm/endpoint/signup"
//        let url = components.url!
//
//        //create the session object
//        let session = URLSession.shared
//
//        //now create the Request object using the url object
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST" //set http method as POST
//        
//        let signupCreds: [String: Any] = [
//            "email": email,
//            "password": password
//        ]
//        
//        var signupData: Data
//        do {
//            signupData = try JSONSerialization.data(withJSONObject: signupCreds)
//        } catch {
//            print("Couldn't serialize signup credentials.")
//        }
//        
//
//        request.httpBody = signupData
//
//        //HTTP Headers
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//        //create dataTask using the session object to send data to the server
//        let task = session.dataTask(with: request, completionHandler: { data, response, error in
//
//            guard error == nil else {
//                print(error!)
//                return
//            }
//
//            guard let data = data else {
//                print("Data returned is nil. Error.")
//                return
//            }
//
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
//                var id = json?["id"] as? String
//                
//                if id != nil {
//                    UserData.saveUserId(userId: id!)
//                    return true
//                }
//    //            print("Recieved JSON: \(String(data: data, encoding: .utf8))")
//                
//                 
//                
//                print("recieved: \(String(bytes: data, encoding: String.Encoding.utf8))")
////                let cleanJsonData = SavedSwingAnalysis.cleanEjsonTypes(data: data)
//
//                
//            
//
//            } catch let error {
//                print(String(describing: error))
//            }
//        })
//
//        task.resume()
//    }
    
    static func saveUserId(userId: String) {
        UserDefaults.standard.set(userId, forKey: "userId")
    }
    
    static func getUserId() -> String {
        let id = UserDefaults.standard.string(forKey: "userId")
//        let tempId = "628e4c291caa1512e05d7172"
        return id!
    }
}
