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
    
    init(viewModel:ToDoListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            
            GoogleSignInButton {
                viewModel.googleLogin()
            }
            Button {

                viewModel.githubLogin()
                    
                
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
                
                TextField("Email Address", text:$viewModel.email).textInputAutocapitalization(.never)
                
                SecureField("Password", text: $viewModel.password)
                
                Button("Log in") {
                    guard !viewModel.email.isEmpty && !viewModel.password.isEmpty else {
                        return;
                    }
                    viewModel.emailLogin(email: viewModel.email, password: viewModel.password)
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
