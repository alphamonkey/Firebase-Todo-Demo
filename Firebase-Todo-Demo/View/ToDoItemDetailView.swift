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
            List {
                VStack {
                    TextField("", text:$viewModel.name).fontWeight(.bold)
                    Divider().overlay(Color.accentColor)
                    HStack {
                        TextField("Description", text:$viewModel.description, axis:.vertical).lineLimit(5...10)
                        if let image = viewModel.image {
                            Image(uiImage: image).resizable().scaledToFit().clipShape(.rect(cornerRadius: 10.0)).onTapGesture {
                                showSourcePicker = true
                            }
                        } else if viewModel.isDownloadingImage || viewModel.isUploading {
                            ProgressView().controlSize(.extraLarge).tint(Color.accentColor)
                        } else {
                            
                            Image(systemName: "photo.badge.plus").font(.system(size:72)).foregroundStyle(Color.secondary).onTapGesture {
                                showSourcePicker = true
                            }
                            
                            
                        }
                    }
                }
                Section {
                    HStack {
                        Button("", systemImage: viewModel.hasDueDate ? "checkmark.circle.fill":"circle") {
                            viewModel.hasDueDate.toggle()
                        }.buttonStyle(.plain).foregroundStyle(Color.accentColor)
                        VStack {
                            Text("Due Date")
                            
                            if (viewModel.hasDueDate) {
                                DatePicker("", selection:$viewModel.dueDate).frame(height:50.0).clipped().buttonStyle(.plain)
                            }
                        }
                        
                    }
                }
                Section {
                    HStack {
                        Button("", systemImage: viewModel.hasPriority ? "checkmark.circle.fill":"circle") {
                            viewModel.hasPriority.toggle()
                        }.buttonStyle(.plain).foregroundStyle(Color.accentColor)
                        Text("Priority")
                        
                        if (viewModel.hasPriority) {
                            Picker("", selection:$viewModel.priority) {
                                Text("💤 Low").tag(0)
                                Text("⏰ Medium").tag(1)
                                Text("‼️ High").tag(2)
                                Text("🔥 Urgent").tag(3)
                            }.buttonStyle(.plain)
                        }
                    }
                }
            }

            Spacer()

            HStack {
                if(!viewModel.isUploading) {
                    Button("Save") {
                        isPresented = false
                        viewModel.saveToDoItem()
                        
                    }.buttonStyle(.borderedProminent).tint(.accentColor).frame(height:44.0).shadow(radius:5.0, y:2.0)

                }
                Spacer()
                Button("Cancel") {
                    isPresented = false
                }.buttonStyle(.borderedProminent).tint(.themeRed).frame(height:44.0).shadow(radius:5.0, y:2.0)
            }.padding([.leading, .trailing], 100.0)
            
            
        }.confirmationDialog("Choose a source", isPresented: $showSourcePicker, titleVisibility: .hidden) {
            Button("Take photo with camera", systemImage: "camera") {
                sourceType = .camera
                showPicker = true
            }
            Button("Choose photo from photo library", systemImage: "photo") {
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
