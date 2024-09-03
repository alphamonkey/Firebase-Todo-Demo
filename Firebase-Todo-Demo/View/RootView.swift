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
        VStack(alignment:.leading) {
            if let _ = viewModel.user {
                HStack {
                    if let pic = viewModel.user?.photoURL
                    {
                        AsyncImage(url: pic, content: {image in
                            image.resizable().scaledToFit().frame(width: 44.0, height:44.0).clipShape(Circle()).padding([.leading], 18.0)
                            
                        }, placeholder: {ProgressView()})
                    }
                    if let displayName = viewModel.user?.displayName {
                        Text(displayName)
                    }
                    else {
                        Text(viewModel.user?.email ?? "")
                    }
                }
                Divider().overlay(Color.accentColor)
                 ToDoListView(viewModel:viewModel)
            }
            else {
                //EmailAddressLoginView(viewModel: viewModel)
                GoogleLoginView(viewModel:viewModel)
            }
        }
        
    }
}



#Preview {
    RootView()
}
