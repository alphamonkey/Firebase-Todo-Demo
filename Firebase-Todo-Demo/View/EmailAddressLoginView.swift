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
            VStack {
                
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage).foregroundStyle(Color.red)
                }
                if let user = viewModel.user {
                    Text(user.email ?? "Created but no display name").foregroundStyle(Color.green)
                }
                TextField("Email Address", text: $viewModel.email).textInputAutocapitalization(.never).textFieldStyle(.roundedBorder).padding([.bottom], 8.0)
                
                SecureField("Password", text: $viewModel.password).textFieldStyle(.roundedBorder).padding([.bottom], 8.0)
                
                Button("Log in") {
                    viewModel.emailLogin()
                }.foregroundStyle(.white).buttonStyle(.bordered)
            }.padding(18.0).navigationTitle("Log In").toolbarBackground(.visible, for: .navigationBar).toolbarBackground(.accent, for: .navigationBar).toolbarColorScheme(.dark, for: .navigationBar).background(.accent).shadow(radius:5.0, y:2.0)
        }.padding(18.0)
    
    }
    
    
    
    
    
    
}
/*
 #Preview {
 EmailAddressLoginView()
 }
 */
