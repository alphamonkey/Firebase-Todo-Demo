//
//  ToDoItemViewModel.swift
//  Firebase-Todo-Demo
//
//  Created by Josh Edson on 8/30/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore

@Observable class ToDoItemViewModel {
    var doneState:Bool
    var item:ToDoItem
    var errorMessage:String?
    var documentCollection:CollectionReference?
    private var db = Firestore.firestore()
    var isLoading = false
    init(_ item:ToDoItem) {
        self.item = item
        self.doneState = item.done
        documentCollection = db.collection("Users/\(item.uid)/ToDoItems")
        
    }
    
    func toggleDoneStatus(_ item:ToDoItem) {
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
    func saveToDoItem(_ item:ToDoItem) {
        errorMessage = nil
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
