//
//  File.swift
//
//
//  Created by 荆文征 on 2023/3/8.
//

import AppTrackingTransparency
import PermissionKit

public extension Permissions {
    @available(iOS 14, *)
    static var Tracking: TrackingPermission {
        return TrackingPermission()
    }
}

@available(iOS 14, *)
public struct TrackingPermission: PermissionProtocol {
    public var status: ATTrackingManager.AuthorizationStatus {
        ATTrackingManager.trackingAuthorizationStatus
    }

    public func reqStatus(completion: @escaping (ATTrackingManager.AuthorizationStatus) -> Void) {
        ATTrackingManager.requestTrackingAuthorization { _ in
            completion(self.status)
        }
    }

    @MainActor public func reqStatus() async -> ATTrackingManager.AuthorizationStatus {
        await withUnsafeContinuation { contin in
            self.reqStatus { status in
                contin.resume(returning: status)
            }
        }
    }

    public typealias StatusType = ATTrackingManager.AuthorizationStatus
}

@available(iOS 14, *)
extension ATTrackingManager.AuthorizationStatus: StatusType {
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
