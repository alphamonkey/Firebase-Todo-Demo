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
    @State var showPicker = false
    @State var imageToUpload = UIImage()
    @State var showSourcePicker = false
    @State var sourceType:UIImagePickerController.SourceType?
    
    init(viewModel:ToDoItemViewModel, isPresented:Binding<Bool>) {
        self.viewModel = viewModel
        self._isPresented = isPresented
        self.viewModel.downloadImage()
    }
    
    var body: some View {
        VStack {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage).foregroundStyle(Color.themeRed)
            }
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
            if(viewModel.isUploading) {
                ProgressView().frame(width:400, height:400)
            }
            else if let image = viewModel.image {
                Image(uiImage: image).resizable().scaledToFit().frame(width: 400.0, height:400.0)
            }
            Spacer()
            
           
            
            
 
            
            HStack {
                if(!viewModel.isUploading) {
                    Button("Save") {
                        isPresented = false
                        viewModel.saveToDoItem()

                    }.foregroundStyle(Color.accentColor)
                    Spacer()
                    Button("Upload") {
                        showSourcePicker = true
                    }
                    Spacer()
                }

                Button("Cancel") {
                    isPresented = false
                }.foregroundStyle(Color.themeRed)
            }.padding([.leading, .trailing], 100.0)
            
        
        }.confirmationDialog("Choose a source", isPresented: $showSourcePicker, titleVisibility: .hidden) {
            Button("Take photo with camera") {
                sourceType = .camera
                showPicker = true
            }
            Button("Choose photo from photo library") {
                sourceType = .photoLibrary
                showPicker = true
            }
        }
            .sheet(isPresented: $showPicker) {
                if let sourceType = sourceType {
                    ImagePicker(selectedImage: $imageToUpload, sourceType: sourceType)
                }
                
        }.onChange(of: imageToUpload) {
            showPicker = false
            if let data = imageToUpload.jpegData(compressionQuality: 0.8){
                viewModel.image = imageToUpload
                viewModel.uploadImage(data: data)
            }
            
        }

    }
}

/*
 #Preview {
 ToDoItemDetailView()
 }
 */
