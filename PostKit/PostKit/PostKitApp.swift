//
//  PostKitApp.swift
//  PostKit
//
//  Created by 김다빈 on 10/10/23.
//

import SwiftUI

@main
struct PostKitApp: App {
    // Naviagtion path Controll
    @StateObject var pathManager = PathManager()
    // AppStorage Controll
    @StateObject private var appstorageManager = AppstorageManager()
    

    
    //Core Data Manager
    let storeDataManager = StoreDataManager.instance
    let menuDataManager = MenuDataManager.instance
    let dailyDataManager = DailyDataManager.instance

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appstorageManager)
                .environmentObject(pathManager)
                .environment(\.managedObjectContext, storeDataManager.container.viewContext)
                .environment(\.managedObjectContext, menuDataManager.container.viewContext)
                .environment(\.managedObjectContext, dailyDataManager.container.viewContext)
        }
    }
}
