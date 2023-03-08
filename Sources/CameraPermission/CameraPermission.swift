//
//  File.swift
//
//
//  Created by 荆文征 on 2023/3/8.
//

import AVKit
import PermissionKit

public extension Permissions {
    static var Camera: CameraPermission {
        return CameraPermission()
    }
}

public struct CameraPermission: PermissionProtocol {
    public var status: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }

    public func status(for type: AVMediaType) -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: type)
    }

    public func reqStatus(completion: @escaping (AVAuthorizationStatus) -> Void) {
        reqStatus(for: .video, completion: completion)
    }

    @MainActor public func reqStatus() async -> AVAuthorizationStatus {
        await reqStatus(for: .video)
    }

    public func reqStatus(for type: AVMediaType, completion: @escaping (AVAuthorizationStatus) -> Void) {
        AVCaptureDevice.requestAccess(for: type) { _ in
            completion(self.status(for: type))
        }
    }

    @MainActor public func reqStatus(for type: AVMediaType) async -> AVAuthorizationStatus {
        await withUnsafeContinuation { contin in
            self.reqStatus(for: type) { status in
                contin.resume(returning: status)
            }
        }
    }

    public typealias StatusType = AVAuthorizationStatus
}

extension AVAuthorizationStatus: StatusType {
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
