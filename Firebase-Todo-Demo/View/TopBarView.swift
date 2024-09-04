//
//  TopBarView.swift
//  Firebase-Todo-Demo
//
//  Created by Josh Edson on 9/4/24.
//

import SwiftUI

struct TopBarView: View {
    @State var loginViewModel:LoginViewModel
    
    init(viewModel:LoginViewModel) {
        self.loginViewModel = viewModel
    }
    var body: some View {
        HStack {
            
            if let pic = loginViewModel.user?.photoURL
            {
                AsyncImage(url: pic, content: {image in
                    image.circleProfileImage().padding([.leading], 18.0)
                    
                }, placeholder: {ProgressView()})
            }
            
            else {
                Image("firebaselogo").circleProfileImage().padding([.leading], 18.0)
            }
            
            Text(loginViewModel.user?.displayName ?? (loginViewModel.user?.email ?? ""))
            
            Spacer()
            Button("", systemImage: "rectangle.portrait.and.arrow.forward") {
                loginViewModel.logout()
            }.foregroundStyle(Color.themeRed)
        }
    }
}

extension Image {
    func circleProfileImage() -> some View {
        return self.resizable().scaledToFit().frame(width:33.0, height:33.0).clipShape(Circle())
    }
}
/*
 #Preview {
 TopBarView()
 }
 */
