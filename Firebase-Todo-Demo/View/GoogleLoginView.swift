//
//  GoogleLoginView.swift
//  Firebase-Todo-Demo
//
//  Created by Josh Edson on 9/3/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseCore
import FirebaseAuth
struct GoogleLoginView: View {
    @State var viewModel:ToDoListViewModel
    @State var loginViewModel:LoginViewModel
    
    init(viewModel:ToDoListViewModel, loginViewModel:LoginViewModel) {
        self.viewModel = viewModel
        self.loginViewModel = loginViewModel
    }
    
    var body: some View {
        VStack {
            
            GoogleSignInButton {
                loginViewModel.googleLogin()
            }
            Button {

                loginViewModel.githubLogin()
                    
                
            } label: {
                Image("githublight").resizable().scaledToFit()
            }
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                }
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage).foregroundStyle(Color.themeRed)
                }
                
                TextField("Email Address", text:$loginViewModel.email).textInputAutocapitalization(.never)
                
                SecureField("Password", text: $loginViewModel.password)
                
                Button("Log in") {
                    guard !loginViewModel.email.isEmpty && !loginViewModel.password.isEmpty else {
                        return
                    }
                    
                    loginViewModel.emailLogin(email: loginViewModel.email, password: loginViewModel.password)
                }
                
            }
        }

    }
}
/*
 #Preview {
 GoogleLoginView()
 }
 */
