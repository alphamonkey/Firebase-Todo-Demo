//
//  CreateEMailAddressAccountView.swift
//  Firebase-Todo-Demo
//
//  Created by Josh Edson on 8/29/24.
//

import SwiftUI
import FirebaseAuth
struct CreateEmailAddressAccountView: View {
    @State var viewModel:LoginViewModel
    
    
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
                
                Button("Create Account") {
                    viewModel.createEmailUser()
                }.foregroundStyle(.white).buttonStyle(.bordered)
            }.padding(18.0).navigationTitle("Create Email Account").toolbarBackground(.visible, for: .navigationBar).toolbarBackground(.themeBlue, for: .navigationBar).toolbarColorScheme(.dark, for: .navigationBar).background(.themeBlue).shadow(radius:5.0, y:2.0)
        }.padding(18.0)
    }
}
/*
#Preview {
    CreateEmailAddressAccountView()
}
*/
