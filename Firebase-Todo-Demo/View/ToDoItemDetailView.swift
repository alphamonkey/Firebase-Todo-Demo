//
//  ToDoItemDetailView.swift
//  Firebase-Todo-Demo
//
//  Created by Josh Edson on 8/30/24.
//

import SwiftUI

struct ToDoItemDetailView: View {
    
    @State var viewModel:ToDoItemViewModel
    @Binding var isPresented:Bool
    
    init(viewModel:ToDoItemViewModel, isPresented:Binding<Bool>) {
        self.viewModel = viewModel
        self._isPresented = isPresented
    }
    var body: some View {
        VStack {
            
            TextField("", text:$viewModel.name)
            TextField("Description", text:$viewModel.description, axis:.vertical).lineLimit(5...10)
            
            Button("Due Date", systemImage: viewModel.hasDueDate ? "checkmark.circle.fill":"circle") {
                viewModel.hasDueDate.toggle()
            }
            
            if (viewModel.hasDueDate) {
                DatePicker("Due Date", selection:$viewModel.dueDate)
            }
            
            Button("Priority", systemImage: viewModel.hasPriority ? "checkmark.circle.fill":"circle") {
                viewModel.hasPriority.toggle()
            }
            
            if (viewModel.hasPriority) {
                Picker("Priority", selection:$viewModel.priority) {
                    Text("💤 Low").tag(0)
                    Text("⏰ Medium").tag(1)
                    Text("‼️ High").tag(2)
                    Text("🔥 Urgent").tag(3)
                }
            }
             
            Spacer()
            HStack {
                Button("Save") {
                    isPresented = false
                    viewModel.saveToDoItem()

                }.foregroundStyle(Color.accentColor)
                Spacer()
                Button("Cancel") {
                    isPresented = false
                }.foregroundStyle(Color.themeRed)
            }.padding([.leading, .trailing], 100.0)
            
        }

    }
}

/*
 #Preview {
 ToDoItemDetailView()
 }
 */
