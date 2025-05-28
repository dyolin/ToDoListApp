//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by 23 on 2025/3/17.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import Firebase
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    
    //Function to connect to the Firebase Emulator
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        //emulator setting for host and port
        let useEmulator  = UserDefaults.standard.bool(forKey: "useEmulator")
        if useEmulator{
            let settings = Firestore.firestore().settings
            settings.host = "localhost:8080"
            settings.isSSLEnabled = false
            Firestore.firestore().settings = settings
            
            Auth.auth().useEmulator(withHost: "localhost", port: 9099)
        }
        
        return true
    }
    
    //Function to send notification for phone number verification
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
        
        completionHandler(.noData)
    }
}

@main
struct ToDoListApp: App {
    //delegate: class A delegate other class B to do something
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isLoggedIn{ //already login
                ToDoListView().environmentObject(ToDoListViewModel())
                
            }else{ //not login yet
                LoginView(onPasswordHidden: {}, onRememberMe: {}).environmentObject(AuthViewModel())
            }
        }
    }
}
