//
//  ToDoListItemView.swift
//  Firebase-Todo-Demo
//
//  Created by Josh Edson on 8/30/24.
//

import SwiftUI

struct ToDoListItemView: View {
    @State var item:ToDoItem
    @State var viewModel:ToDoListViewModel
    
    init(item:ToDoItem, viewModel:ToDoListViewModel) {
        self.item = item
        self.viewModel = viewModel
    }
    var body: some View {
        HStack {
            Button("", systemImage: item.done ? "checkmark.circle.fill":"circle") {
                item.done.toggle()
                viewModel.saveToDoItem(item)
            }.sensoryFeedback(.success, trigger: item.done)
            Text(item.name)
        }
    }
}
/*
 #Preview {
 ToDoListItemView()
 }
 */
