//
//  GoogleLoginView.swift
//  Firebase-Todo-Demo
//
//  Created by Josh Edson on 9/3/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseCore
import FirebaseAuth
struct GoogleLoginView: View {
    @State var viewModel:ToDoListViewModel
    
    init(viewModel:ToDoListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GoogleSignInButton {
            viewModel.googleLogin()

        }
    }
}
/*
 #Preview {
 GoogleLoginView()
 }
 */
