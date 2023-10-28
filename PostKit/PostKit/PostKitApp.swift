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
    let storeDataManager = CoreDataManager.instance

    var body: some Scene {
        WindowGroup {
            HashtagView()
                .environmentObject(appstorageManager)
                .environmentObject(pathManager)
                .environment(\.managedObjectContext, storeDataManager.container.viewContext)
        }
    }
}
