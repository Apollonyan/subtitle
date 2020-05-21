//
//  SRT.swift
//  srt
//
//  Created by Zhiyu Zhu on 7/9/17.
//  Copyright © 2017-2020 ApolloZhu. MIT License.
//

import Foundation
import subtitle

public struct SRT {
    private var _segments = [Segment]()
}

extension SRT {
    /// Initialize a srt with its content.
    ///
    /// - Parameter content: content of a srt file.
    public init(content: String) {
        /// Indicating what the next piece of information is
        enum ParsingState { case index, time, content }

        let lineSeparator: String
        if content.contains("\r\n") {
            lineSeparator = "\r\n"
        } else if content.contains("\r") {
            lineSeparator = "\r"
        } else {
            lineSeparator = "\n"
        }

        for part in content.components(separatedBy: "\(lineSeparator)\(lineSeparator)").lazy {
            var state = ParsingState.index
            var index: Int? = nil
            var time: String? = nil
            var content = [String]()
            for line in part.components(separatedBy: lineSeparator) {
                let line = line.trimmingCharacters(in: .whitespacesAndNewlines)
                switch state {
                case .index:
                    if let i = Int(line) {
                        index = i
                        state = .time
                    }
                case .time:
                    if line.contains("-->") {
                        time = line
                        state = .content
                    }
                case .content:
                    if line.count > 0 {
                        content.append(line)
                    }
                }
            }
            if let i = index, let t = time, content.count > 0 {
                _segments.append(Segment(index: i, time: t, contents: content))
            }
        }
    }
}

extension SRT: Subtitle {
    public init(segments: [SubtitleSegment]) {
        self.init(_segments: segments.enumerated().map { (index, segment) in
            SRT.Segment(
                index: index + 1,
                from: segment.startTime,
                to: segment.endTime,
                contents: segment.contents
            )
        })
    }

    public var segments: [SubtitleSegment] {
        return _segments
    }

    public init(url: URL) throws {
        let content = try String(contentsOf: url)
        self.init(content: content)
    }

    public func write(to url: URL) throws {
        try description.write(to: url, atomically: true, encoding: .utf8)
    }
}

extension SRT: CustomStringConvertible {
    /// Convert back to what it would be like in a .srt file.
    public var description: String {
        return _segments.map(\.description).joined(separator: "\n\n") + "\n"
    }
}
