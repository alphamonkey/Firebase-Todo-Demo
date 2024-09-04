//
//  LoginViewModel.swift
//  Firebase-Todo-Demo
//
//  Created by Josh Edson on 9/3/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FirebaseAnalytics
@Observable class LoginViewModel {
    var user:User?
    var auth:Auth?
    var errorMessage:String?
    var isLoading:Bool = false
    var email = ""
    var password = ""
    let ghProvider = OAuthProvider(providerID: "github.com")
    
    init() {
        let _ = Auth.auth().addStateDidChangeListener(handleAuthStateChange)
    }
    
    func handleAuthStateChange(auth:Auth, user:User?) {
        errorMessage = nil
        self.user = user
        self.auth = auth
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
    
    func githubLogin() {
        
        ghProvider.customParameters = ["allow_signup":"false"]
        ghProvider.scopes = ["read:user", "user:email"]
        
        ghProvider.getCredentialWith(nil) {(credential, error) in
            
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
}
