//
//  EmailAddressLoginView.swift
//  Firebase-Todo-Demo
//
//  Created by Josh Edson on 8/29/24.
//

import SwiftUI


struct EmailAddressLoginView: View {

    @State var viewModel:LoginViewModel
    
    init(viewModel:LoginViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
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
/*
 #Preview {
 EmailAddressLoginView()
 }
 */
