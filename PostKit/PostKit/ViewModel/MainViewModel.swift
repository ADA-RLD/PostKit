//
//  MainViewModel.swift
//  PostKit
//
//  Created by Kim Andrew on 11/4/23.
//

import Foundation
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
}

enum CloudKitError: String, LocalizedError {
    case iCloudAccountUnavailable
    case iCloudAccountNotFound
    case iCloudAccountNotDetermined
    case iCloudAccountRestricted
    case iCloudAccountUnknown
}

extension CloudKitUserModel {
    private func getCloudStatus() {
        CKContainer.default().accountStatus { [weak self] status, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch status {
                case .couldNotDetermine:
                    self._error = CloudKitError.iCloudAccountNotDetermined.rawValue
                case .available:
                    self._isSignedInCloud = true
                case .restricted:
                    self._error = CloudKitError.iCloudAccountRestricted.rawValue
                case .noAccount:
                    self._error = CloudKitError.iCloudAccountNotFound.rawValue
                case .temporarilyUnavailable:
                    self._error = CloudKitError.iCloudAccountUnavailable.rawValue
                @unknown default:
                    self._error = CloudKitError.iCloudAccountUnknown.rawValue
                }
            }
        }
    }

    private func requestPermission() {
        CKContainer.default().requestApplicationPermission([.userDiscoverability]) { [weak self] returnedStatus, returnedError in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if returnedStatus == .granted {
                    self._permissionStatus = true
                }
            }
        }
    }

    private func fetchiCloudUserRecordID() {
        CKContainer.default().fetchUserRecordID { [weak self] returnedId, returnedError in
            guard let self = self else { return }
            if let id = returnedId {
                self.discoveriCloudUser(id: id)
            }
        }
    }

    private func discoveriCloudUser(id: CKRecord.ID) {
        CKContainer.default().discoverUserIdentity(withUserRecordID: id) { [weak self] returnedIdentity, returnedError in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let name = returnedIdentity?.nameComponents?.givenName {
                    self._userName = name
                }
            }
        }
    }
}
