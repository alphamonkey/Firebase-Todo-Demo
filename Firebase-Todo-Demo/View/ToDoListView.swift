//
//  ToDoListView.swift
//  Firebase-Todo-Demo
//
//  Created by Josh Edson on 8/30/24.
//

import SwiftUI

struct ToDoListView: View {
    @State var newToDoItemName:String = ""
    @State var hideCompletedItems = UserDefaults.standard.bool(forKey: "hideComplete")
    let viewModel:ToDoListViewModel
    
    init(viewModel:ToDoListViewModel){
        self.viewModel = viewModel
    }
    var body: some View {
        VStack {
            
            if let message = viewModel.errorMessage {
                Text(message).foregroundStyle(Color.themeRed)
            }

            List {
                Section("To Do List") {
                    ForEach(hideCompletedItems ? viewModel.toDoItems.filter {$0.done == false } : viewModel.toDoItems, id:\.self) { item in
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
                
                Section {
                    HStack {
                        Toggle("Hide completed items", isOn: $hideCompletedItems).onChange(of:hideCompletedItems) {(_, newValue) in
                            UserDefaults.standard.setValue(hideCompletedItems, forKey: "hideComplete")
                        }
                    }
                }
                
            }.onSubmit {
                newToDoItemName = ""
            }
        }
        
    }
}

/*
 #Preview {
 ToDoListView()
 }
 */
