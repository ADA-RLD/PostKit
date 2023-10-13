//
//  SettingStoreView.swift
//  PostKit
//
//  Created by 김다빈 on 10/11/23.
//

import SwiftUI

struct SettingStoreView: View {
    @EnvironmentObject var pathManager: PathManager
    @EnvironmentObject var appstorageManager: AppstorageManager
    var body: some View {
        VStack {
            CustomTextfield(menuName: appstorageManager.$cafeName, placeHolder: appstorageManager.cafeName)
        }
            
    }
}

