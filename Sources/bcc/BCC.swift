//
//  BCC.swift
//  bcc
//
//  Created by Apollo Zhu on 10/19/18.
//  Copyright © 2017-2020 ApolloZhu. MIT License.
//

import Foundation
@_exported import subtitle

public struct BCC: Codable {
    public private(set) var fontSize = 0.4
    public private(set) var fontColor = "#FFFFFF"
    public private(set) var backgroundAlpha = 0.5
    public private(set) var backgroundColor = "#9C27B0"
    public private(set) var stroke = "none"
    private var _segments: [Segment]

    enum CodingKeys: String, CodingKey {
        case fontSize = "font_size"
        case fontColor = "font_color"
        case backgroundAlpha = "background_alpha"
        case backgroundColor = "background_color"
        case stroke = "Stroke"
        case _segments = "body"
    }

    public struct Segment: Codable, SubtitleSegment {
        public var contents: [String] {
            return content.components(separatedBy: .newlines)
        }

        public let startTime: TimeInterval
        public let endTime: TimeInterval
        public private(set) var location = 2
        private let content: String

        public init(from startTime: Double, to endTime: Double, content: String) {
            self.startTime = startTime
            self.endTime = endTime
            self.content = content
        }

        enum CodingKeys: String, CodingKey {
            case startTime = "from"
            case endTime = "to"
            case location
            case content
        }
    }
}

extension BCC: Subtitle {
    public init(segments: [SubtitleSegment]) {
        self.init(_segments: segments.map {
            BCC.Segment(
                from: $0.startTime,
                to: $0.endTime,
                content: $0.contents.joined(separator: "\n")
            )
        })
    }

    public var segments: [SubtitleSegment] {
        return _segments
    }

    /// Write the contents of self to a location in bcc format.
    ///
    /// - parameter url: The location to write the data into.
    /// - parameter options: Options for writing the data. Default value is `[]`.
    /// - throws: `EncodingError.invalidValue` if a non-conforming floating-point value is encountered during encoding, and the encoding strategy is `.throw`.
    /// - throws: An error if any value throws an error during encoding.
    /// - throws: An error in the Cocoa domain, if there is an error writing to the `URL`.
    public func write(to url: URL) throws {
        let data = try JSONEncoder().encode(self)
        try data.write(to: url)
    }

    public init(url: URL) throws {
        self = try JSONDecoder().decode(BCC.self, from: Data(contentsOf: url))
    }
}
