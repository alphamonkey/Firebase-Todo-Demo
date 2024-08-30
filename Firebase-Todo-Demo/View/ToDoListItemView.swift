//
//  ToDoListItemView.swift
//  Firebase-Todo-Demo
//
//  Created by Josh Edson on 8/30/24.
//

import SwiftUI

struct ToDoListItemView: View {
    @State var item:ToDoItem
    @State var viewModel:ToDoItemViewModel
    
    init(item:ToDoItem, viewModel:ToDoItemViewModel) {
        self.item = item
        self.viewModel = viewModel
    }
    var body: some View {
        HStack {
            Button("", systemImage: viewModel.doneState ? "checkmark.circle.fill":"circle") {
                withAnimation {
                    viewModel.toggleDoneStatus(item)
                }
            }.sensoryFeedback(.success, trigger: item.done)
            Text(item.name)
            Spacer()
            Button("", systemImage:"info.circle") {
                return
            }.foregroundStyle(Color.secondary)
                
        }
    }
}
/*
 #Preview {
 ToDoListItemView()
 }
 */
