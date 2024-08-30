//
//  Firebase_Todo_DemoApp.swift
//  Firebase-Todo-Demo
//
//  Created by Josh Edson on 8/29/24.
//

import SwiftUI
import SwiftData
import FirebaseCore

class AppDelegate:NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
@main
struct Firebase_Todo_DemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate;
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
