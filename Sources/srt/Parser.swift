//
//  File.swift
//
//
//  Created by Apollo Zhu on 5/21/20.
//

import Foundation

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

extension SRT.Segment {
    /// Initialize a subtitle by parsing timestamp string.
    ///
    /// - Parameters:
    ///   - index: Index of the subtitle.
    ///   - time: String of format: start --> end.
    ///   - content: Actual content of the subtitle.
    fileprivate init(index: Int, time: String, contents: [String]) {
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

