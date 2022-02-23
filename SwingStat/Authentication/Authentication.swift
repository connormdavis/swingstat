//
//  Login.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 2/22/22.
//

import SwiftUI

struct Authentication: View {
    @State var index = 0
    @Namespace var name
    @StateObject var swing = Swing()
    
    var body: some View{
        NavigationView {
            VStack{
                HStack {
                    Text("SwingStat")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .foregroundColor(Color.green)
                }
                .offset(y: -20)
                
                HStack {
                    Text("Helping you go low!")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.498))
                }
                .offset(y: -20)
                
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
                    
                    // Login button leads to Dashboard
                    NavigationLink(destination: Main()) {

                        Text("Login")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 100)
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                    Spacer()
                    
                } else{
                    
                    VStack{
                        SignUp()
                        Spacer()
                            
                        // Sign up button leading to dashboard
                        NavigationLink(destination: Main()) {

                            Text("Sign Up")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 100)
                                .background(Color.green)
                                .cornerRadius(8)
                        }
                    }
                    
                }
            }
        }
        
    }
}


struct Authentication_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Authentication()
                .previewInterfaceOrientation(.portrait)
            Authentication()
                .previewInterfaceOrientation(.portraitUpsideDown)
        }
    }
}
