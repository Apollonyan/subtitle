//
//  SRT.swift
//  srt
//
//  Created by Zhiyu Zhu on 7/9/17.
//  Copyright © 2017-2020 ApolloZhu. MIT License.
//

import Foundation
@_exported import subtitle

public struct SRT {
    internal var _segments = [Segment]()
}

extension SRT: Subtitle {
    public init(segments: [SubtitleSegment]) {
        self.init(_segments: (segments as? [Segment])
            ?? segments.enumerated().map { (index, segment) in
                SRT.Segment(
                    index: index + 1,
                    from: segment.startTime,
                    to: segment.endTime,
                    contents: segment.contents
                )
            }
        )
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
        return _segments
            .map { $0.description }
            .joined(separator: "\n\n") + "\n"
    }
}
