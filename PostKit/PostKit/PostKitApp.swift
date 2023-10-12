//
//  PostKitApp.swift
//  PostKit
//
//  Created by 김다빈 on 10/10/23.
//

import SwiftUI

@main
struct PostKitApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var pathManager = PathManager()
    
    //Core Data Manager
    let storeDataManager = StoreDataManager.instance
    let menuDataManager = MenuDataManager.instance
    let dailyDataManager = DailyDataManager.instance

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(pathManager)
                .environment(\.managedObjectContext, storeDataManager.container.viewContext)
                .environment(\.managedObjectContext, menuDataManager.container.viewContext)
                .environment(\.managedObjectContext, dailyDataManager.container.viewContext)
            
            //            ContentView()
            //                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
