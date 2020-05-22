//
//  Segment.swift
//  vtt
//
//  Created by Apollo Zhu on 5/21/20.
//  Copyright © 2017-2020 ApolloZhu. MIT License.
//

import Foundation
import subtitle

extension VTT {
    public struct Segment: SubtitleSegment {
        /// Time when the subtitle appears.
        public let startTime: TimeInterval
        /// Time when the subtitle disappears.
        public let endTime: TimeInterval
        /// Actual content of the subtitle.
        public let contents: [String]
    }
}

extension VTT.Segment: CustomStringConvertible {
    private static func timestamp(from interval: TimeInterval) -> String {
        let (h, m, s, c) = subtitle.timestamp(from: interval)
        return String(format: "%02d:%02d:%02d.%03d", h, m, s, c)
    }

    public var description: String {
        return """
        \(Self.timestamp(from: startTime)) --> \(Self.timestamp(from: endTime))
        \(contents.joined(separator: "\n"))
        """
    }
}
