//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import AVFoundation

enum ItemState: Equatable {
    case unknown
    case readyToPlay
    case ended
    case failed(error: Error)

    static func itemState(for item: AVPlayerItem?) -> ItemState {
        guard let item else { return .unknown }
        return itemState(for: item.status, error: item.error)
    }

    static func itemState(for status: AVPlayerItem.Status, error: Error?) -> ItemState {
        switch status {
        case .readyToPlay:
            return .readyToPlay
        case .failed:
            return .failed(error: error ?? PlaybackError.unknown)
        default:
            return .unknown
        }
    }

    static func == (lhs: ItemState, rhs: ItemState) -> Bool {
        switch (lhs, rhs) {
        case (.unknown, .unknown), (.readyToPlay, .readyToPlay), (.ended, .ended):
            return true
        case let (.failed(error: lhsError), .failed(error: rhsError)):
            return lhsError as NSError == rhsError as NSError
        default:
            return false
        }
    }
}
