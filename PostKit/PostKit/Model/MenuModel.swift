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

     @Published var menuName : String
     @Published var menuPoint : String

     init(_storeName: String? = nil, _storeTone: String, _menuName: String, _menuPoint: String) {
         self.storeName = _storeName
         self.storeTone = _storeTone
         self.menuName = _menuName
         self.menuPoint = _menuPoint
     }
 }
