//
//  SRT.swift
//  subtitle
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


/// Convert time interval to SubRip timestamp format.
///
/// - Parameter interval: non-negative time interval to format.
/// - Returns: valid string timestamp.
public func timestamp(from interval: TimeInterval)
    -> (hour: Int, minute: Int, seconds: Int, milliseconds: Int) {
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
    return (h, m, s, c)
}
