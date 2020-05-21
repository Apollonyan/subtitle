//
//  Segment.swift
//  srt
//
//  Created by Apollo Zhu on 7/9/17.
//  Copyright © 2017-2020 ApolloZhu. MIT License.
//

import Foundation
import subtitle

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

extension SRT.Segment {
    /// Initialize a subtitle by parsing timestamp string.
    ///
    /// - Parameters:
    ///   - index: Index of the subtitle.
    ///   - time: String of format: start --> end.
    ///   - content: Actual content of the subtitle.
    init(index: Int, time: String, contents: [String]) {
        self.index = index
        self.contents = contents
        let timestamps = time.components(separatedBy: " --> ")
        self.startTime = Self.timeInterval(from: timestamps[0])
        self.endTime = Self.timeInterval(from: timestamps[1])
    }

    /// Parsing SubRip timestamp to time interval.
    ///
    /// - Parameter string: valid string timestamp.
    /// - Returns: non-negative time interval.
    private static func timeInterval(from string: String) -> TimeInterval {
        let num = string.split(separator: ",")
            .flatMap { $0.split(separator: ":") }
            .compactMap(Double.init)
        return num[0] * 3600 + num[1] * 60 + num[2] + num[3] / 1000
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
    private static func timestamp(from interval: TimeInterval) -> String {
        let h = Int(interval / 3600)
        var interval = interval.remainder(dividingBy: 3600)
        if interval < 0 { interval += 3600 }
        let m = Int(interval / 60)
        interval = interval.remainder(dividingBy: 60)
        if interval < 0 { interval += 60 }
        let s = Int(interval)
        interval = interval.remainder(dividingBy: 1)
        if interval < 0 { interval += 1 }
        let c = Int(round(interval * 1000))
        return String(format: "%02d:%02d:%02d,%03d", h, m, s, c)
    }
}
