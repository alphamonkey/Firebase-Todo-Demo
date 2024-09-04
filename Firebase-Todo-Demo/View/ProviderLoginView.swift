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
struct ProviderLoginView: View {
    @State var viewModel:ToDoListViewModel
    @State var loginViewModel:LoginViewModel
    @State private var navPath = NavigationPath()
    
    init(viewModel:ToDoListViewModel, loginViewModel:LoginViewModel) {
        self.viewModel = viewModel
        self.loginViewModel = loginViewModel
    }
    
    var body: some View {
        VStack {
            NavigationStack(path:$navPath) {
                
                Spacer()
                GoogleSignInButton {
                    loginViewModel.googleLogin()
                }.padding([.leading, .trailing], 48.0).padding([.bottom], 8.0).cornerRadius(8.0)
                Button {
                    
                    loginViewModel.githubLogin()
                    
                    
                } label: {
                    Image("githublight").resizable().scaledToFit().frame(height: 44.0)
                }.shadow(radius:5.0, y:2.0)
                VStack {
                    if viewModel.isLoading {
                        ProgressView()
                    }
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage).foregroundStyle(Color.themeRed)
                    }
                    

                    
                        Button("Log in with email account") {
                            navPath.append(EmailAddressLoginView.ViewMode.login)
                            
                        }.buttonStyle(.borderedProminent).tint(.accent).frame(height:44.0).shadow(radius:5.0, y:2.0)
                        
                        Button("Create an account with your email address") {
                            navPath.append(EmailAddressLoginView.ViewMode.create)
                        }.buttonStyle(.borderedProminent).tint(.themeBlue).frame(height:44.0).shadow(radius:5.0, y:2.0)
                    

                }.navigationDestination(for: EmailAddressLoginView.ViewMode.self) {mode in
                        EmailAddressLoginView(viewModel: loginViewModel, mode:mode)
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
