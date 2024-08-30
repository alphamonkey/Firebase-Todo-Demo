//
//  EmailAddressLoginView.swift
//  Firebase-Todo-Demo
//
//  Created by Josh Edson on 8/29/24.
//

import SwiftUI


struct EmailAddressLoginView: View {
    @State var email:String = ""
    @State var password:String = ""
    
    @State var viewModel:ToDoListViewModel
    
    init(viewModel:ToDoListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            }
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage).foregroundStyle(Color.red)
            }
            
            TextField("Email Address", text:$email).textInputAutocapitalization(.never)
            
            SecureField("Password", text: $password)
            
            Button("Log in") {
                guard !email.isEmpty && !password.isEmpty else {
                    return;
                }
                viewModel.emailLogin(email: email, password: password)
            }
            
        }
    }
    
    
    
    
    
    
}
/*
 #Preview {
 EmailAddressLoginView()
 }
 */
