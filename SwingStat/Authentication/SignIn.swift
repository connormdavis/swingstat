//
//  SignIn.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 2/22/22.
//

import SwiftUI

struct SignIn : View {
    
    @State var user = ""
    @State var password = ""
    
    
    var body: some View{
        VStack{
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Email")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                
                TextField("email", text: $user)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                // shadow effect
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: -5)
                
                Text("Password")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                
                SecureField("password", text: $password)
                    .keyboardType(.asciiCapable)
                    .textContentType(.password)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                // shadow effect
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: -5)
                
                
                
                Button(action: {}) {
                    
                    Text("Forgot Password")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(Color.blue)
                }
                .padding(.top,10)
                
            }
            .padding(.horizontal,25)
            
        }
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}
