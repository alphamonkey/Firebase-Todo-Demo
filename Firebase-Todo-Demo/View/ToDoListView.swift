//
//  ToDoListView.swift
//  Firebase-Todo-Demo
//
//  Created by Josh Edson on 8/30/24.
//

import SwiftUI

struct ToDoListView: View {
    @State var newToDoItemName:String = ""
    
    let viewModel:ToDoListViewModel
    
    init(viewModel:ToDoListViewModel){
        self.viewModel = viewModel
    }
    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(viewModel.toDoItems, id:\.self) { item in
                        ToDoListItemView(item:item, viewModel:ToDoItemViewModel(item))
                        
                    }.onDelete {(offsets) in
                        withAnimation {
                            for offset in offsets {
                                let i = viewModel.toDoItems.index(viewModel.toDoItems.startIndex, offsetBy:offset)
                                viewModel.deleteToDoItem(viewModel.toDoItems[i])
                            }
                        }

                        
                    }
                }

                Section {
                    HStack {
                        Image(systemName: "plus.circle").renderingMode(.template).foregroundColor(.accentColor)
                        TextField("New Task", text: $newToDoItemName) {
                            
                            guard !newToDoItemName.isEmpty else {return}

                            withAnimation {
                                viewModel.addToDoItemNamed(newToDoItemName)
                            }
                            
                            
                        }
                        
                    }

                }

            }.onSubmit {
                newToDoItemName = ""
            }
            if let message = viewModel.errorMessage {
                Text(message).foregroundStyle(Color.themeRed)
            }
            Button("Log Out") {
                viewModel.logout()
            }.foregroundColor(Color.themeRed)
        }
        
    }
}

/*
 #Preview {
    ToDoListView()
 }
 */
