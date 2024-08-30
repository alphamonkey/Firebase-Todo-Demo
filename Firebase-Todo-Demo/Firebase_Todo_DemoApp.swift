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
        print("-- Firebase Init --")
        FirebaseApp.configure()
        return true
    }
}
@main
struct Firebase_Todo_DemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate;
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(sharedModelContainer)
    }
}
