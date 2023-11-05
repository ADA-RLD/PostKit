//
//  CloudKitUserModel.swift
//  PostKit
//
//  Created by Kim Andrew on 11/4/23.
//

import Foundation
import SwiftUI
import CloudKit

class CloudKitUserModel: ObservableObject {
    @Published var _permissionStatus: Bool = false
    @Published var _isSignedInCloud: Bool = false
    @Published var _error: String = ""
    @Published var _userName: String = ""
    
    init() {
        getCloudStatus()
        requestPermission()
        fetchiCloudUserRecordID()
    }
    
    enum CloudKitError: String, LocalizedError {
        case iCloudAccountUnavailable
        case iCloudAccountNotFound
        case iCloudAccountNotDetermined
        case iCloudAccountRestricted
        case iCloudAccountUnknown
    }
    
    private func getCloudStatus() {
        CKContainer.default().accountStatus { [unowned self] status, error in
            DispatchQueue.main.async {
                switch status {
                case .couldNotDetermine:
                    self._error = CloudKitError.iCloudAccountNotDetermined.rawValue
                    break
                case .available:
                    self._isSignedInCloud = true
                    break
                case .restricted:
                    self._error = CloudKitError.iCloudAccountRestricted.rawValue
                    break
                case .noAccount:
                    self._error = CloudKitError.iCloudAccountNotFound.rawValue
                    break
                case .temporarilyUnavailable:
                    self._error = CloudKitError.iCloudAccountUnavailable.rawValue
                    break
                @unknown default:
                    self._error = CloudKitError.iCloudAccountUnknown.rawValue
                    break
                }
            }
        }
    }
    
    func requestPermission() {
        CKContainer.default().requestApplicationPermission([.userDiscoverability]) { [unowned self] returnedStatus, returnedError in
            DispatchQueue.main.async {
                if returnedStatus == .granted {
                    self._permissionStatus = true
                }
            }
        }
    }
    
     func fetchiCloudUserRecordID() {
        CKContainer.default().fetchUserRecordID { [unowned self] returnedId, returnedError in
            if let id = returnedId {
                self.discoveriCloudUser(id: id)
            }
        }
    }
    
    func discoveriCloudUser(id: CKRecord.ID) {
        CKContainer.default().discoverUserIdentity(withUserRecordID: id) { [unowned self] returnedIdentity, returnedError in
            DispatchQueue.main.async {
                if let name = returnedIdentity?.nameComponents?.givenName {
                    self._userName = name
                }
            }
        }
    }
}
