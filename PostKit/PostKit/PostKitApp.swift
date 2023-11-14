//
//  PostKitApp.swift
//  PostKit
//
//  Created by 김다빈 on 10/10/23.
//

import SwiftUI
import Firebase

@main
struct PostKitApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    // Naviagtion path Controll
    @StateObject var pathManager = PathManager()
    // AppStorage Controll
    @StateObject private var appstorageManager = AppstorageManager()
    
    //Core Data Manager
    let storeDataManager = CoreDataManager.instance

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appstorageManager)
                .environmentObject(pathManager)
                .environment(\.managedObjectContext, storeDataManager.container.viewContext)
        }
    }
}
