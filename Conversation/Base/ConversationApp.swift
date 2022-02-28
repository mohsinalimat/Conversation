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
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                InBoxView()
            }
            .navigationViewStyle(.stack)
            .environmentObject(CurrentUser.shared)
            .environmentObject(IncomingSocket.shared)
            .environmentObject(AppUserDefault.shared)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Persistence.setup()
        return true
    }
    
//    static var orientationLock = UIInterfaceOrientationMask.portrait
//
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        return AppDelegate.orientationLock
//    }
//    
    func applicationWillTerminate(_ application: UIApplication) {
        Persistence.shared.save()
    }
}
