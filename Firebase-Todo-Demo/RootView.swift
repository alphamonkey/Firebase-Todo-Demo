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
            if let user = viewModel.user {
                ForEach(viewModel.toDoItems) { item in
                    Text(item.name)
                }
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage).foregroundStyle(Color.red)
                }
                Button("Upload ") {
                    let testItem = ToDoItem(uid: user.uid, name: "Test Task", dueDate: nil, description: nil, priority: nil)
                    viewModel.addToDoItem(testItem)
                }

                Text("Logged in as \(user.email ?? "Unknown user")")
                
                Button("Log Out") {
                    viewModel.logout()
                }
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
