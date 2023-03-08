public protocol PermissionProtocol {
    associatedtype StatusType

    var status: StatusType { get }
    func reqStatus(completion: @escaping (StatusType) -> Void)
    func reqStatus() async -> StatusType
}

public struct Permissions {}
