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
    
    var user:User?
    var auth:Auth?
    var errorMessage:String?
    var toDoItems:[ToDoItem] = []
    var documentCollection:CollectionReference?
    var isLoading:Bool = false
    var email = ""
    var password = ""
    let provider = OAuthProvider(providerID: "github.com")
    private var db = Firestore.firestore()
    private var listener:(any ListenerRegistration)?
    
    init() {
        let _ = Auth.auth().addStateDidChangeListener(handleAuthStateChange)
    }
    func githubLogin() {
        
        provider.customParameters = ["allow_signup":"false"]
        provider.scopes = ["read:user", "user:email"]
        
        provider.getCredentialWith(nil) {(credential, error) in
            guard let credential = credential else {
                self.errorMessage = "No credential retrieved"
                return
            }
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            Auth.auth().signIn(with:credential) {(authResult, error) in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
            }
        }
    }
    func googleLogin() {
        Task {
            guard let clientID = FirebaseApp.app()?.options.clientID else {return}
            
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            if let scene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = await scene.windows.first?.rootViewController {
                let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
                if let idToken = result.user.idToken?.tokenString {
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: result.user.accessToken.tokenString)
                    try await Auth.auth().signIn(with: credential)
                }
            }
        }
    }
    func emailLogin(email:String, password:String) {
        errorMessage = nil
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) {(result, error) in
            if let err = error {
                self.errorMessage = err.localizedDescription
            }
            else if let res = result {
                Analytics.logEvent(AnalyticsEventLogin, parameters:[AnalyticsParameterMethod:res.user.uid] )
            }
            self.isLoading = false
        }
    }
    
    func logout() {
        errorMessage = nil
        try? auth?.signOut()
    }
    
    func handleAuthStateChange(auth:Auth, user:User?) {
        errorMessage = nil
        self.user = user
        self.auth = auth
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
        
        guard let uid = user?.uid else {
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

