//
//  ToDoItemViewModel.swift
//  Firebase-Todo-Demo
//
//  Created by Josh Edson on 8/30/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseStorage

@Observable class ToDoItemViewModel {
    
    var item:ToDoItem
    var errorMessage:String?
    var description:String
    var image:UIImage?
    var name:String
    var hasDueDate:Bool = false
    var dueDate:Date = Date()
    var hasPriority:Bool = false
    var priority:Int = 0
    var documentCollection:CollectionReference?
    var isDownloadingImage = false
    var isLoading = false
    var isUploading = false
    
    
    private var db = Firestore.firestore()

    init(_ item:ToDoItem) {
        self.item = item
        self.name = item.name
        self.description = item.description ?? ""
        
        if let itemDueDate = item.dueDate {
            hasDueDate = true
            self.dueDate = itemDueDate
        }
        if let itemPriority = item.priority {
            hasPriority = true
            self.priority = itemPriority
        }
        documentCollection = db.collection("Users/\(item.uid)/ToDoItems")
    }
    
    func downloadImage() {
        if image != nil {
            return
        }
        
        guard let urlString = item.imageDownloadURL,
        let maxSize = item.imageDownloadSize else {
            return
        }
        isDownloadingImage = true
        let storage = Storage.storage()
        let downloadRef = storage.reference(forURL: urlString)
        
        downloadRef.getData(maxSize: maxSize, completion: {(data, error) in
            if let err = error {
                self.errorMessage = err.localizedDescription
                return
            }
            else if let data = data {
                self.image = UIImage(data: data)
            }
            self.isDownloadingImage = false
        })
        
    }
    func uploadImage(data:Data) {
        
        let storage = Storage.storage()
        let imageRef = storage.reference().child("images/\(item.uid)")
        let fileName = "\(item.id!).jpg"
        let fullPathRef = imageRef.child(fileName)
        
        isUploading = true
        let _ = fullPathRef.putData(data) {(metadata, error) in
            self.isUploading = false
            if let error = error {
                self.errorMessage = error.localizedDescription
            }
            
            guard let metadata = metadata else {
                self.errorMessage = "Unknown upload error"
                return
            }
            
            fullPathRef.downloadURL {(url, error) in
                if let error = error {
                    self.errorMessage = "Unable to retrieve download URL: \(error.localizedDescription)"
                    return
                }
                self.image = UIImage(data: data)
                self.item.imageDownloadURL = url?.absoluteString
                self.item.imageDownloadSize = metadata.size
            }
        }
    }
    func toggleDoneStatus() {
        errorMessage = nil
        isLoading = true
        if let id = item.id {
            documentCollection?.document(id).updateData(["done":!item.done]) {(error) in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    
                }
                self.isLoading = false
            }
            
        }
    }
    func saveToDoItem() {
        errorMessage = nil
        if !name.isEmpty {
            self.item.name = name
        }
        
        if !self.description.isEmpty {
            self.item.description = description
        }

        if self.hasDueDate {
            self.item.dueDate = dueDate
        }
        
        else {
            self.item.dueDate = nil
        }
 
        if (self.hasPriority) {
            self.item.priority = self.priority
        }
        
        else {
            self.item.priority = nil
        }
        
        isLoading = true
        if let id = item.id {
            do {
                try documentCollection?.document(id).setData(from: item) {(error) in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        
                    }
                    self.isLoading = false
                }
            } catch  {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
