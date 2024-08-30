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
    

    var body: some View {
        VStack {
            if let _ = viewModel.user {
                ToDoListView(viewModel:viewModel)
            }
            else {
                EmailAddressLoginView(viewModel: viewModel)
            }
        }
        
    }
}



#Preview {
    RootView()
}
