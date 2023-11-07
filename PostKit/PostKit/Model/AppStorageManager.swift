//
//  AppStorageModel.swift
//  PostKit
//
//  Created by 김다빈 on 10/13/23.
//

import SwiftUI

class AppstorageManager: ObservableObject {
    @AppStorage("_cafeName") var cafeName: String = ""
    @AppStorage("_cafeTone") var cafeTone: String = ""
}
