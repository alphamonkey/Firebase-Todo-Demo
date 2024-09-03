//
//  CreateEMailAddressAccountView.swift
//  Firebase-Todo-Demo
//
//  Created by Josh Edson on 8/29/24.
//

import SwiftUI
import FirebaseAuth
struct CreateEmailAddressAccountView: View {
    @State var usernameToCreate:String = ""
    @State var passwordToUse:String = ""
    @State var errorMessage:String?
    @State var user:User? = Auth.auth().currentUser
    
    var body: some View {
        
        if let errorMessage = errorMessage {
            Text(errorMessage).foregroundStyle(Color.red)
        }
        if let user = user {
            Text(user.email ?? "Created but no display name").foregroundStyle(Color.green)
        }
        TextField("Email Address", text: $usernameToCreate).textInputAutocapitalization(.never)
        
        SecureField("Password", text: $passwordToUse)
        
        Button("Create User") {
            Task {
                errorMessage = nil;
                guard !usernameToCreate.isEmpty && !passwordToUse.isEmpty else {
                    return;
                }
                Auth.auth().createUser(withEmail: usernameToCreate, password: passwordToUse, completion: {result, error in
                    if let err = error {
                        errorMessage = err.localizedDescription
                    }
                    if let authResult = result {
                        user = authResult.user
                    }
                    
                })
                
            }
        }
    }
}

#Preview {
    CreateEmailAddressAccountView()
}
