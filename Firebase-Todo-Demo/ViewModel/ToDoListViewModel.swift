//
//  ToDoListViewModel.swift
//  Firebase-Todo-Demo
//
//  Created by Josh Edson on 8/29/24.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseAnalytics
import FirebaseCore
import GoogleSignIn
@Observable class ToDoListViewModel {
    
    var toDoItems:[ToDoItem] = []
    var documentCollection:CollectionReference?
    var errorMessage:String?
    var isLoading:Bool = false
    
    private var db = Firestore.firestore()
    private var listener:(any ListenerRegistration)?
    private var uid:String?
    
    init() {
        let _ = Auth.auth().addStateDidChangeListener(handleAuthStateChange)
    }

    func handleAuthStateChange(auth:Auth, user:User?) {
        uid = user?.uid
        errorMessage = nil

        if let user = user {
            documentCollection = db.collection("Users/\(user.uid)/ToDoItems")
            listener = documentCollection?.addSnapshotListener(snapshotListener)
        }
        
        else {
            listener?.remove()
        }
    }
    
    func snapshotListener(_ snapshot:QuerySnapshot?, error:(any Error)?) {
        errorMessage = nil
        
        guard (error == nil) else {
            errorMessage = error?.localizedDescription
            return
        }
        
        guard let documents = snapshot?.documents else {
            errorMessage = "Snapshot has no documents"
            return
        }
        
        toDoItems = documents.compactMap{(snapshot:QueryDocumentSnapshot) in
            let result = Result { try snapshot.data(as: ToDoItem.self)}
            switch result {
            case .success(let item):
                return item
            case .failure(let err):
                errorMessage = err.localizedDescription
            }
            return nil
        }.sorted {$0.createDate < $1.createDate}
        
    }
    
    func deleteToDoItem(_ item:ToDoItem) {
        errorMessage = nil
        if let id = item.id {
            documentCollection?.document(id).delete {(error) in
                self.errorMessage = error?.localizedDescription
            }
        }
        
    }
    func addToDoItemNamed(_ name:String) {
        
        guard let uid = uid else {
            errorMessage = "User not signed in"
            return
        }
        let item = ToDoItem(uid: uid, name: name)
        addToDoItem(item)
    }
    
    func addToDoItem(_ item:ToDoItem) {
        errorMessage = nil
        do {
            let _ = try documentCollection?.addDocument(from: item)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    
}

