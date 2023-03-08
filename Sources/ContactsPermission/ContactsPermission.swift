//
//  File.swift
//
//
//  Created by 荆文征 on 2023/3/8.
//

import PermissionKit

import Contacts

public extension Permissions {
    static var Contacts: ContactsPermission {
        return ContactsPermission()
    }
}

public struct ContactsPermission: PermissionProtocol {
    public var status: CNAuthorizationStatus {
        return CNContactStore.authorizationStatus(for: .contacts)
    }

    public func reqStatus(completion: @escaping (CNAuthorizationStatus) -> Void) {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { _, _ in
            completion(self.status)
        }
    }

    @MainActor public func reqStatus() async -> CNAuthorizationStatus {
        await withUnsafeContinuation { contin in
            self.reqStatus { status in
                contin.resume(returning: status)
            }
        }
    }

    public typealias StatusType = CNAuthorizationStatus
}

extension CNAuthorizationStatus: StatusType {
    public var warp: PermissionKit.Permissions.Status {
        switch self {
        case .authorized: return .authorized
        case .denied: return .denied
        case .notDetermined: return .notDetermined
        case .restricted: return .denied
        @unknown default: return .denied
        }
    }
}
