//
//  SRT.swift
//  srt
//
//  Created by Apollo Zhu on 5/21/20.
//  Copyright © 2017-2020 ApolloZhu. MIT License.
//

import Foundation

public protocol SubtitleSegment {
    /// Index of the subtitle.
    var startTime: TimeInterval { get }
    /// Time when the subtitle disappears.
    var endTime: TimeInterval { get }
    /// Actual content of the subtitle.
    var contents: [String] { get }
}

public protocol Subtitle {
    var segments: [SubtitleSegment] { get }
    init(segments: [SubtitleSegment])

    init(url: URL) throws
    init(path: String) throws
    func write(to url: URL) throws
    func write(to path: String) throws
}

extension Subtitle {
    public init(path: String) throws {
        try self.init(url: URL(fileURLWithPath: path))
    }

    public func write(to path: String) throws {
        try write(to: URL(fileURLWithPath: path))
    }
}
