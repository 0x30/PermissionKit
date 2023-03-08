//
//  File.swift
//
//
//  Created by 荆文征 on 2023/3/8.
//

import AVFoundation
import PermissionKit

public extension Permissions {
    static var Microphone: MicrophonePermission {
        MicrophonePermission()
    }
}

public struct MicrophonePermission: PermissionProtocol {
    public var status: AVAudioSession.RecordPermission {
        AVAudioSession.sharedInstance().recordPermission
    }

    public func reqStatus(completion: @escaping (AVAudioSession.RecordPermission) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { _ in
            completion(self.status)
        }
    }

    @MainActor public func reqStatus() async -> AVAudioSession.RecordPermission {
        await withUnsafeContinuation { contin in
            self.reqStatus { status in
                contin.resume(returning: status)
            }
        }
    }

    public typealias StatusType = AVAudioSession.RecordPermission
}
