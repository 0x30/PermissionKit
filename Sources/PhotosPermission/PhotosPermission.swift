//
//  File.swift
//
//
//  Created by 荆文征 on 2023/3/8.
//

import PermissionKit
import Photos

public extension Permissions {
    static var Photos: PhotosPermission {
        return PhotosPermission()
    }
}

public struct PhotosPermission: PermissionProtocol {
    public var status: PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus()
    }

    public func reqStatus(completion: @escaping (PHAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            completion(status)
        }
    }

    @MainActor public func reqStatus() async -> PHAuthorizationStatus {
        await withUnsafeContinuation { contin in
            self.reqStatus { status in
                contin.resume(returning: status)
            }
        }
    }

    @available(iOS 14, *)
    public func status(for accessLevel: PHAccessLevel) -> PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus(for: accessLevel)
    }

    @available(iOS 14, *)
    public func reqStatus(for accessLevel: PHAccessLevel, completion: @escaping (PHAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: accessLevel) { status in
            completion(status)
        }
    }

    @available(iOS 14, *)
    @MainActor public func reqStatus(for accessLevel: PHAccessLevel) async -> PHAuthorizationStatus {
        await withUnsafeContinuation { contin in
            self.reqStatus(for: accessLevel) { status in
                contin.resume(returning: status)
            }
        }
    }

    public typealias StatusType = PHAuthorizationStatus
}

extension PHAuthorizationStatus: StatusType {
    public var warp: PermissionKit.Permissions.Status {
        switch self {
        case .authorized: return .authorized
        case .denied: return .denied
        case .notDetermined: return .notDetermined
        case .restricted: return .denied
        case .limited: return .authorized
        @unknown default: return .denied
        }
    }
}
