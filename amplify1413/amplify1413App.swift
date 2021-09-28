//
//  amplify1413App.swift
//  amplify1413
//
//  Created by Law, Michael on 9/27/21.
//

import SwiftUI
import Amplify
import AmplifyPlugins

@main
struct amplify1413App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Amplify.Logging.logLevel = .verbose
        do {
            // AmplifyModels is generated in the previous step
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: AmplifyModels()))
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Amplify configured with DataStore plugin")
        } catch {
            print("Failed to initialize Amplify with \(error)")
            return false
        }
        
        return true
    }
}
