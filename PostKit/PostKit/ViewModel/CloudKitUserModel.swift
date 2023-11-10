////
////  CloudKitUserModel.swift
////  PostKit
////
////  Created by Kim Andrew on 11/4/23.
////
//
//import SwiftUI
//import CloudKit
//
//class CloudKitUserModel: ObservableObject {
//    @Published var permissionStatus: Bool = false
//    @Published var isSignedIntoiCloud: Bool = false
//    @Published var error: String = ""
//    @Published var userName: String = ""
//    
//    init() {
//        getiCloudStatus()
//        requestPermission()
//        fetchiCloudUserRecordID()
//    }
//    
//    private func getiCloudStatus() {
//        CKContainer.default().accountStatus { [weak self] status, error in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                switch status {
//                case .couldNotDetermine:
//                    self.error = CloudKitError.iCloudAccountNotDetermined.rawValue
//                    break
//                case .available:
//                    self.isSignedIntoiCloud = true
//                    break
//                case .restricted:
//                    self.error = CloudKitError.iCloudAccountRestricted.rawValue
//                    break
//                case .noAccount:
//                    self.error = CloudKitError.iCloudAccountNotFound.rawValue
//                    break
//                case .temporarilyUnavailable:
//                    self.error = CloudKitError.iCloudAccountUnavailable.rawValue
//                    break
//                @unknown default:
//                    self.error = CloudKitError.iCloudAccountUnknown.rawValue
//                    break
//                }
//            }
//        }
//    }
//    
//    enum CloudKitError: String, LocalizedError {
//        case iCloudAccountUnavailable
//        case iCloudAccountNotFound
//        case iCloudAccountNotDetermined
//        case iCloudAccountRestricted
//        case iCloudAccountUnknown
//    }
//    
//    func requestPermission() {
//        CKContainer.default().requestApplicationPermission([.userDiscoverability]) { [weak self] returnedStatus, returnedError in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                if returnedStatus == .granted {
//                    self.permissionStatus = true
//                }
//            }
//        }
//    }
//    
//    func fetchiCloudUserRecordID() {
//        CKContainer.default().fetchUserRecordID { [weak self] returnedId, returnedError in
//            guard let self = self else { return }
//            if let id = returnedId {
//                self.discoveriCloudUser(id: id)
//            }
//        }
//    }
//    
//    func discoveriCloudUser(id: CKRecord.ID) {
//        CKContainer.default().discoverUserIdentity(withUserRecordID: id) { [weak self] returnedIdentity, returnedError in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                if let name = returnedIdentity?.nameComponents?.givenName {
//                    self.userName = name
//                }
//            }
//        }
//    }
//}
