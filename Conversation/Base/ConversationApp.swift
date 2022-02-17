//
//  ConversationApp.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI
import Firebase

@main
struct ConversationApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppUserDefault.shared)
                
        }
        .onChange(of: scenePhase, perform: scenePhaseChanged(_:))
    }
    
    private func scenePhaseChanged(_ phase: ScenePhase) {
        
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    static var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        PersistenceController.shared.save()
    }
}
