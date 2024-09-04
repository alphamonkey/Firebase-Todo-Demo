//
//  EmailAddressLoginView.swift
//  Firebase-Todo-Demo
//
//  Created by Josh Edson on 8/29/24.
//

import SwiftUI


struct EmailAddressLoginView: View {
    enum ViewMode {
        case create
        case login
    }
    @State var viewModel:LoginViewModel
    
    let mode:ViewMode
    let title:String
    let color:Color
    let function:() -> (Void)
    
    init(viewModel:LoginViewModel, mode:ViewMode) {
        self.viewModel = viewModel
        self.mode = mode
        
        switch self.mode {
        case .login:
            self.title = "Log in"
            self.color = .accentColor
            self.function = viewModel.emailLogin
        case .create:
            self.title = "Create Account"
            self.color = .themeBlue
            self.function = viewModel.createEmailUser
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage).foregroundStyle(Color.red)
                }

                TextField("Email Address", text: $viewModel.email).textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                    .padding([.bottom], 8.0)
                
                SecureField("Password", text: $viewModel.password).textFieldStyle(.roundedBorder)
                    .padding([.bottom], 8.0)
                
                Button(title) {
                    function()
                    
                }.foregroundStyle(.white)
                    .buttonStyle(.bordered)
                
            }.padding(18.0).navigationTitle(title)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(color, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .background(color)
                .shadow(radius:5.0, y:2.0)
            
        }.padding(18.0)
    
    }
    
    
    
    
    
    
}
/*
 #Preview {
 EmailAddressLoginView()
 }
 */
