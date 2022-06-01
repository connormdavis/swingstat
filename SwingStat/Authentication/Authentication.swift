//
//  Login.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 2/22/22.
//

import SwiftUI

class AuthenticationState: ObservableObject {
    @Published var loggedIn = false
}

struct Authentication: View {
    @ObservedObject var authState = AuthenticationState()
    
    @State var invalidInput = false
    @State var invalidInputReason = "Invalid input."
    
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    
    
    @State var index = 0
    @Namespace var name
    
    func loginSuccess(id: String) {
        UserData.saveUserId(userId: id)
        authState.loggedIn = true
    }
    
    func loginFailed(reason: String) {
        print("Login failed: \(reason)")
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func validateInput(email: String, password: String, confirmPassword: String = "", method: String) -> Bool {
        var valid = true
        var invalidReason = ""
        
        // Require valid length values
        let emailLength = email.count
        let passwordLength = password.count
        
        // Require valid email
        let emailCheck = isValidEmail(email)
        
        // Require at least one number
        let numbers = CharacterSet(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"])
        let passwordNumberCheck = password.rangeOfCharacter(from: numbers) != nil
        
        var matchingPasswords = true
        if method == "signup" {
            // Check for matching passwords
            if password != confirmPassword {
                matchingPasswords = false
            }
        }
        
        
        if emailLength == 0 {
            valid = false
            invalidReason = "An e-mail is required for \(method)."
        } else if passwordLength == 0 {
            valid = false
            invalidReason = "A password is required for \(method)."
        } else if !emailCheck {
            valid = false
            invalidReason = "Please enter a valid e-mail address for \(method)."
        } else if !passwordNumberCheck {
            valid = false
            invalidReason = "Your password requires at least one number."
        } else if !matchingPasswords {
            valid = false
            invalidReason = "Please make sure the passwords match."
        }
        
        // Update UI to  indicate invalid input
        if !valid {
            self.invalidInput = true
            self.invalidInputReason = invalidReason
            
            // Hide view after some time
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (_) in
                withAnimation {
                    self.invalidInput = false
                }
            }
        }
        
        return valid
    }
    
    func requestLogin() async {
        if !validateInput(email: email, password: password, method: "login") {
            return
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "us-east-1.aws.data.mongodb-api.com"
        components.path = "/app/swingstat_swings-lotdm/endpoint/login"
        let url = components.url!

        //create the session object
        let session = URLSession.shared

        //now create the Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        let signupCreds: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        var signinData: Data = Data()
        do {
            signinData = try JSONSerialization.data(withJSONObject: signupCreds)
        } catch {
            print("Couldn't serialize signin credentials.")
        }
        

        request.httpBody = signinData

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
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                let result = json?["result"] as? String
                
                if result == "success" {
                    let id = json?["id"] as? String
                    loginSuccess(id: id!)
                } else {
                    let reason = json?["reason"] as? String
                    loginFailed(reason: reason!)
                }
                
    //            print("Recieved JSON: \(String(data: data, encoding: .utf8))")
                
                 
                
//                print("recieved: \(String(bytes: data, encoding: String.Encoding.utf8))")
//                let cleanJsonData = SavedSwingAnalysis.cleanEjsonTypes(data: data)

                
            

            } catch let error {
                print(String(describing: error))
            }
        })

        task.resume()
    }
    
    func signupSuccess(id: String) {
        UserData.saveUserId(userId: id)
        UserData.saveDesiredTempo(tempo: 3.0)
        authState.loggedIn = true
    }
    
    func signupFailed() {
        print("too bad")
    }
    
    func requestSignup() async {
        if !validateInput(email: email, password: password, confirmPassword: confirmPassword, method: "signup") {
            return
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "us-east-1.aws.data.mongodb-api.com"
        components.path = "/app/swingstat_swings-lotdm/endpoint/signup"
        let url = components.url!

        //create the session object
        let session = URLSession.shared

        //now create the Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        let signupCreds: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        var signupData: Data = Data()
        do {
            signupData = try JSONSerialization.data(withJSONObject: signupCreds)
        } catch {
            print("Couldn't serialize signup credentials.")
        }
        

        request.httpBody = signupData

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
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                var id = json?["id"] as? String
                
                if id != nil {
                    signupSuccess(id: id!)
                } else {
                    signupFailed()
                }
    //            print("Recieved JSON: \(String(data: data, encoding: .utf8))")
                
                 
                
//                print("recieved: \(String(bytes: data, encoding: String.Encoding.utf8))")
//                let cleanJsonData = SavedSwingAnalysis.cleanEjsonTypes(data: data)

                
            

            } catch let error {
                print(String(describing: error))
            }
        })

        task.resume()
    }
    
    var body: some View{
        VStack {
            if authState.loggedIn {
                Main().transition(.opacity)
            } else {
                VStack{
                    HStack {
                        Text("SwingStat")
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                            .foregroundColor(Color.green)
                    }
          
                    HStack {
                        Text("Helping you go low!")
                            .font(.subheadline)
                            .fontWeight(.light)
                            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.498))
                    }
                }
                .offset(y: 20)
                .padding(.bottom, 30)
                
                if invalidInput {
                    Text("\(invalidInputReason)")
                        .padding()
                        .background(.red)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(20.0)
                }
                                
                HStack(spacing: 0){
                    Button(action: {
                        
                        withAnimation(.spring()) {
                            index = 0
                        }
                        
                    }) {
                        VStack{
                            Text("Login")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(index == 0 ? .black : .gray)
                            
                            ZStack{
                                
                                // Slide animation
                                
                                Capsule()
                                    .fill(Color.black.opacity(0.04))
                                    .frame( height: 4)
                                
                                if index == 0{
                                    Capsule()
                                        .fill(Color("Color"))
                                        .frame( height: 4)
                                        .matchedGeometryEffect(id: "Tab", in: name)
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        
                        withAnimation(.spring()) {
                            
                            index = 1
                        }
                        
                    }) {
                        VStack{
                            Text("Sign Up")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(index == 1 ? .black : .gray)
                            
                            ZStack{
                                
                                // Slide animation
                                
                                Capsule()
                                    .fill(Color.black.opacity(0.04))
                                    .frame( height: 4)
                                
                                if index == 1{
                                    Capsule()
                                        .fill(Color("Color"))
                                        .frame( height: 4)
                                        .matchedGeometryEffect(id: "Tab", in: name)
                                }
                            }
                        }
                    }
                }
                .padding(.top,30)
                                
                
                // Change views based on index
                if index == 0{
                    SignIn(email: self.$email, password: self.$password)
                    
                    VStack{
                        // Log in
                        Button(action: {
                            Task {
                                await requestLogin()
                            }
                        }, label: {
                            Text("Login")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 100)
                                .background(Color.green)
                                .cornerRadius(8)
                        })
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                    
                } else{
                    SignUp(email: self.$email, password: self.$password, confirmPassword: self.$confirmPassword)

                    VStack{
                        // Sign up
                        Button(action: {
                            Task {
                                await requestSignup()
                            }
                        }, label: {
                            Text("Sign up")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 100)
                                .background(Color.green)
                                .cornerRadius(8)
                        })
                        Spacer()
                    }
                    .padding(.top, 30)

                }
            }
            
        }
        .preferredColorScheme(.light)
        .onAppear() {
            if UserData.getUserId() != "" {
                authState.loggedIn = true
            }
        }
    }
}


struct Authentication_Previews: PreviewProvider {
    static var previews: some View {
            Authentication()
                .previewInterfaceOrientation(.portrait)
    }
}
