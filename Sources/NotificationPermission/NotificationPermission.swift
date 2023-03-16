//
//  File.swift
//
//
//  Created by 荆文征 on 2023/3/8.
//

import PermissionKit
import UserNotifications

public extension Permissions {
    static var Notification: NotificationPermission {
        return NotificationPermission()
    }
}

public struct NotificationPermission: PermissionProtocol {
    public var status: UNAuthorizationStatus {
        var notificationSettings: UNNotificationSettings?
        let semaphore = DispatchSemaphore(value: 0)
        UNUserNotificationCenter.current().getNotificationSettings { setttings in
            notificationSettings = setttings
            semaphore.signal()
        }
        semaphore.wait()
        return notificationSettings!.authorizationStatus
    }

    public func reqStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization { _, _ in
            DispatchQueue.main.async {
                completion(self.status)
            }
        }
    }

    @MainActor public func reqStatus() async -> UNAuthorizationStatus {
        await withUnsafeContinuation { contin in
            self.reqStatus { status in
                contin.resume(returning: status)
            }
        }
    }

    public func reqStatus(options: UNAuthorizationOptions, completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: options) { _, _ in
            DispatchQueue.main.async {
                completion(self.status)
            }
        }
    }

    @MainActor public func reqStatus(options: UNAuthorizationOptions) async -> UNAuthorizationStatus {
        await withUnsafeContinuation { contin in
            self.reqStatus(options: options) { status in
                contin.resume(returning: status)
            }
        }
    }

    public typealias StatusType = UNAuthorizationStatus
}

extension UNAuthorizationStatus: StatusType {
    public var warp: PermissionKit.Permissions.Status {
        switch self {
        case .authorized: return .authorized
        case .denied: return .denied
        case .notDetermined: return .notDetermined
        case .provisional: return .authorized
        case .ephemeral: return .authorized
        @unknown default: return .denied
        }
    }
}
