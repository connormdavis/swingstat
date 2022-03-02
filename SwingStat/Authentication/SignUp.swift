//
//  SignUp.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 2/22/22.
//

import SwiftUI

struct SignUp: View {
    @State var user = ""
    @State var password = ""
    @State var confirmPassword = ""
    
    var body: some View{
        
        VStack{
            
            HStack{
                
                VStack(alignment: .center, spacing: 12){

                    Text("Create Account")
                        .font(.title)
                        .fontWeight(.bold)

                }
                
                Spacer(minLength: 0)
                
                
            }
            .padding(.horizontal, 25)
            .padding(.top,30)
            
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
                    .textContentType(.newPassword)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                // shadow effect
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: -5)
                
                Text("Confirm Password")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                
                SecureField("password", text: $confirmPassword)
                    .keyboardType(.asciiCapable)
                    .textContentType(.password)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                // shadow effect
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: -5)
                
                
            }
            .padding(.horizontal,25)
            .padding(.top,25)
            
    
        }

    }
}




struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
