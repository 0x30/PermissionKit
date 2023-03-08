//
//  File.swift
//
//
//  Created by 荆文征 on 2023/3/8.
//

import PermissionKit

import CoreLocation

public extension Permissions {
    static var Location: LocationPermission {
        return LocationPermission()
    }
}

public struct LocationPermission: PermissionProtocol {
    public var status: CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return CLLocationManager().authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }

    /// WhenInUse
    public func reqStatus(completion: @escaping (CLAuthorizationStatus) -> Void) {
        LocationPermissionRequester.requestWhenInUseAuthorization(complete: completion)
    }

    /// WhenInUse
    @MainActor public func reqStatus() async -> CLAuthorizationStatus {
        await withUnsafeContinuation { contin in
            self.reqStatus { status in
                contin.resume(returning: status)
            }
        }
    }

    /// Always
    public func reqAlwaysStatus(completion: @escaping (CLAuthorizationStatus) -> Void) {
        LocationPermissionRequester.requestAlwaysAuthorization(complete: completion)
    }

    /// Always
    @MainActor public func reqAlwaysStatus() async -> CLAuthorizationStatus {
        await withUnsafeContinuation { contin in
            self.reqAlwaysStatus { status in
                contin.resume(returning: status)
            }
        }
    }

    public typealias StatusType = CLAuthorizationStatus
}

@available(iOS 14.0, *)
public extension LocationPermission {
    var accuracyAuthorization: CLAccuracyAuthorization {
        CLLocationManager().accuracyAuthorization
    }

    func reqAccuracy(withPurposeKey: String, completion: @escaping (CLAccuracyAuthorization) -> Void) {
        if accuracyAuthorization == .fullAccuracy {
            completion(accuracyAuthorization)
        } else {
            CLLocationManager().requestTemporaryFullAccuracyAuthorization(withPurposeKey: withPurposeKey) { _ in
                completion(self.accuracyAuthorization)
            }
        }
    }

    func reqAccuracy(withPurposeKey key: String) async -> CLAccuracyAuthorization {
        await withUnsafeContinuation { contin in
            self.reqAccuracy(withPurposeKey: key) { status in
                contin.resume(returning: status)
            }
        }
    }
}

class LocationPermissionRequester: NSObject, CLLocationManagerDelegate {
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .notDetermined { return }
        completionHandler?(manager.authorizationStatus)
    }

    func locationManager(_: CLLocationManager, didChangeAuthorization authorizationStatus: CLAuthorizationStatus) {
        if authorizationStatus == .notDetermined { return }
        completionHandler?(authorizationStatus)
    }

    private static var requesters: Set<LocationPermissionRequester> = Set()

    private var completionHandler: ((CLAuthorizationStatus) -> Void)?

    fileprivate lazy var manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()

    static func requestWhenInUseAuthorization(complete: @escaping (CLAuthorizationStatus) -> Void) {
        let requester = LocationPermissionRequester()
        requesters.insert(requester)
        requester.completionHandler = { status in
            requester.completionHandler = nil
            requesters.remove(requester)
            complete(status)
        }
        requester.manager.requestWhenInUseAuthorization()
    }

    static func requestAlwaysAuthorization(complete: @escaping (CLAuthorizationStatus) -> Void) {
        let requester = LocationPermissionRequester()
        requesters.insert(requester)
        requester.completionHandler = { status in
            requester.completionHandler = nil
            requesters.remove(requester)
            complete(status)
        }
        requester.manager.requestAlwaysAuthorization()
    }

    deinit {
        manager.delegate = nil
    }
}

extension CLAuthorizationStatus: StatusType {
    public var warp: PermissionKit.Permissions.Status {
        switch self {
        case .authorized: return .authorized
        case .denied: return .denied
        case .notDetermined: return .notDetermined
        case .restricted: return .denied
        case .authorizedAlways: return .authorized
        case .authorizedWhenInUse: return .authorized
        @unknown default: return .denied
        }
    }
}
