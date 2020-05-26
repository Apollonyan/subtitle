//
//  Segment.swift
//  srt
//
//  Created by Apollo Zhu on 7/9/17.
//  Copyright © 2017-2020 ApolloZhu. MIT License.
//

import Foundation

/// A segment of a .srt file.
extension SRT {
    public struct Segment: SubtitleSegment {
        /// Index of the subtitle.
        public let index: Int
        /// Time when the subtitle appears.
        public let startTime: TimeInterval
        /// Time when the subtitle disappears.
        public let endTime: TimeInterval
        /// Actual content of the subtitle.
        public let contents: [String]

        /// Initialize a subtitle with given information.
        ///
        /// - Parameters:
        ///   - index: the index of the subtitle.
        ///   - start: time of which the subtitle appears.
        ///   - end: time of which the subtitle disappears.
        ///   - content: the actual content of the subtitle.
        public init(index: Int, from start: TimeInterval, to end: TimeInterval, contents: [String]) {
            self.index = index
            self.startTime = start
            self.endTime = end
            self.contents = contents
        }

        /// Initialize a subtitle with given information.
        ///
        /// - Parameters:
        ///   - index: the index of the subtitle.
        ///   - start: time of which the subtitle appears.
        ///   - end: time of which the subtitle disappears.
        ///   - content: the actual content of the subtitle.
        public init(index: Int, from start: TimeInterval, to end: TimeInterval, contents: String...) {
            self.init(index: index, from: start, to: end, contents: contents)
        }
    }
}

extension SRT.Segment: CustomStringConvertible {
    /// SubRip representation of the subtitle.
    public var description: String {
        return """
        \(index)
        \(Self.timestamp(from: startTime)) --> \(Self.timestamp(from: endTime))
        \(contents.joined(separator: "\n"))
        """
    }

    /// Convert time interval to SubRip timestamp format.
    ///
    /// - Parameter interval: non-negative time interval to format.
    /// - Returns: valid string timestamp.
    public static func timestamp(from interval: TimeInterval) -> String {
        let (h, m, s, c) = subtitle.timestamp(from: interval)
        return String(format: "%02d:%02d:%02d,%03d", h, m, s, c)
    }
}
