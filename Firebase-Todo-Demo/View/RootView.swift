//
//  RootView.swift
//  Firebase-Todo-Demo
//
//  Created by Josh Edson on 8/29/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
struct RootView: View {
    
    
    @State var viewModel:ToDoListViewModel = ToDoListViewModel()
    @State var loginViewModel:LoginViewModel = LoginViewModel()
    
    var body: some View {
        VStack(alignment:.leading) {
            if let _ = loginViewModel.user {
                HStack {
                    if let pic = loginViewModel.user?.photoURL
                    {
                        AsyncImage(url: pic, content: {image in
                            image.resizable().scaledToFit().frame(width: 33.0, height:33.0).clipShape(Circle()).padding([.leading], 18.0)
                            
                        }, placeholder: {ProgressView()})
                    }
                    else {
                        Image(systemName: "person.crop.circle").resizable().scaledToFit().frame(width: 33.0, height:33.0).clipShape(Circle()).padding([.leading], 18.0).foregroundStyle(Color.accentColor)
                    }
                    if let displayName = loginViewModel.user?.displayName {
                        Text(displayName)
                    }
                    else {
                        Text(loginViewModel.user?.email ?? "")
                    }
                    Spacer()
                    Button("", systemImage: "rectangle.portrait.and.arrow.forward") {
                        loginViewModel.logout()
                    }.foregroundStyle(Color.themeRed)
                }
                Divider().overlay(Color.accentColor)
                 ToDoListView(viewModel:viewModel)
            }
            else {
                //EmailAddressLoginView(viewModel: viewModel)
                GoogleLoginView(viewModel:viewModel, loginViewModel: loginViewModel)
            }
        }
        
    }
}



#Preview {
    RootView()
}
