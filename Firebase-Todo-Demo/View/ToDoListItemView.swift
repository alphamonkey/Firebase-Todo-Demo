//
//  ToDoListItemView.swift
//  Firebase-Todo-Demo
//
//  Created by Josh Edson on 8/30/24.
//

import SwiftUI

struct ToDoListItemView: View {
    
    @State var viewModel:ToDoItemViewModel
    @State var isShowingDetail:Bool
    private var priorityicons = ["💤", "⏰", "‼️", "🔥"]
    init(item:ToDoItem, viewModel:ToDoItemViewModel) {
        
        self.viewModel = viewModel
        self.isShowingDetail = false
        
    }
    var body: some View {
        HStack {
            Button("", systemImage: viewModel.item.done ? "checkmark.circle.fill":"circle") {
                withAnimation {
                    
                    viewModel.toggleDoneStatus()
                }
            }.sensoryFeedback(.success, trigger: viewModel.item.done).buttonStyle(.plain)
            
            HStack {
                if let priority = viewModel.item.priority {
                    Text(priorityicons[priority] + " ")
                }
                VStack (alignment:.leading) {
                    Text(viewModel.item.name)
                    if let dueDate = viewModel.item.formattedDate() {
                        Text(dueDate).foregroundStyle(viewModel.item.isOverDue ? Color.themeRed : Color.secondary).font(.footnote)
                    }
                }
            }
            
            
            Spacer()
            Button("", systemImage:"info.circle") {
                isShowingDetail = true
            }.buttonStyle(.plain).foregroundStyle(Color.secondary).sheet(isPresented: $isShowingDetail, content: {
                ToDoItemDetailView(viewModel:viewModel, isPresented:$isShowingDetail)
            })
            
            
        }
    }
}
/*
 #Preview {
 ToDoListItemView()
 }
 */
