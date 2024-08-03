//
//  BudgetPlanApp.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 26.05.2024..
//

import SwiftUI
import Firebase
import FirebaseCore

@main
struct BudgetPlanApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
 
    var body: some Scene {
        WindowGroup {
            RootView().background(Color("BackgroundColor").ignoresSafeArea())
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = 
        nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

