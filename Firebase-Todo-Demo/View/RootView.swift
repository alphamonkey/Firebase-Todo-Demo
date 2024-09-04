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
                TopBarView(viewModel: loginViewModel)
                Divider().overlay(Color.accentColor)
                ToDoListView(viewModel:viewModel)
            }
            
            else {
                ProviderLoginView(viewModel:viewModel, loginViewModel: loginViewModel)
            }
        }
        
    }
}



#Preview {
    RootView()
}
