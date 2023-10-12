//
//  Menu.swift
//  PostKit
//
//  Created by Kim Andrew on 10/12/23.
//

import Foundation

 final class MenuModel : ObservableObject{
     let storeName : String?
     let storeTone : String

     @Published var recordID = UUID()
     @Published var recordDate : Date?
     @Published var menuName : String
     @Published var menuPoint : String

     init(_storeName: String?, _storeTone: String, _recordID: UUID = UUID(), _recordDate: Date? = nil, _menuName: String, _menuPoint: String) {
         self.storeName = _storeName
         self.storeTone = _storeTone
         self.recordID = _recordID
         self.recordDate = _recordDate
         self.menuName = _menuName
         self.menuPoint = _menuPoint
     }
 }
