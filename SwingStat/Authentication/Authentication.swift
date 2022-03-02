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
    
    @State var index = 0
    @Namespace var name
    
    var body: some View{
        VStack {
            if authState.loggedIn {
                Main().transition(.opacity)
            } else {
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
                    SignIn()
                    
                    // Log in
                    Button(action: {
                        authState.loggedIn = true
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
                    
                    Spacer()
                    
                } else{
                    
                    VStack{
                        SignUp()
                        Spacer()
                            
                        // Sign up
                        Button(action: {
                            authState.loggedIn = true
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
                    }
                    
                }
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
