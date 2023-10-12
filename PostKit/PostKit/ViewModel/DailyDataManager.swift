//
//  DailyDataManager.swift
//  PostKit
//
//  Created by Kim Andrew on 10/12/23.
//

import Foundation
import CoreData

 struct DailyDataManager  {

     static let instance = DailyDataManager()
        let container: NSPersistentContainer
        let context: NSManagedObjectContext

        init() {
            // Container 지정 = Database
            container = NSPersistentContainer(name: "DailyData")
            container.loadPersistentStores { description, error in
                if let error = error {
                    print("Error loading Core Data. \(error)")
                }
            }
            //Database 저장 관리자
            context = container.viewContext
        }

        func save() {
            do {
                try context.save()
                print("Saved Successfully!")
            } catch let error {
                print("Saving error. \(error.localizedDescription)")
            }
        }

 }
