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

    var item:ToDoItem
    var errorMessage:String?
    var description:String
    
    var name:String
    var hasDueDate:Bool = false
    var dueDate:Date = Date()
    var hasPriority:Bool = false
    var priority:Int = 0
    var documentCollection:CollectionReference?
    private var db = Firestore.firestore()
    var isLoading = false
    
    var isOverDue:Bool {
        if let _ = item.dueDate {
            if dueDate.timeIntervalSinceNow < 0 {
                return true
            }
        }
        return false
    }
    
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
    func formattedDate() -> String? {
        if let date = item.dueDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/YY hh:mm"
            return dateFormatter.string(from: date)
        }
        return nil
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
