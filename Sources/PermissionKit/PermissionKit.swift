public protocol StatusType {
    var warp: Permissions.Status { get }
}

public protocol PermissionProtocol {
    associatedtype Status: StatusType

    var status: Status { get }
    func reqStatus(completion: @escaping (Status) -> Void)
    func reqStatus() async -> Status
}

public enum Permissions {
    @objc public enum Status: Int, CustomStringConvertible {
        case authorized = 3
        case denied = 2
        case notDetermined = 1
        case notSupported = 0

        public var authorized: Bool {
            return self == .authorized
        }

        public var denied: Bool {
            return self == .denied
        }

        public var notDetermined: Bool {
            return self == .notDetermined
        }

        public var description: String {
            switch self {
            case .authorized: return "authorized"
            case .denied: return "denied"
            case .notDetermined: return "not determined"
            case .notSupported: return "not supported"
            }
        }
    }
}
