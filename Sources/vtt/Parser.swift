//
//  Parser.swift
//  vtt
//
//  Created by Apollo Zhu on 5/21/20.
//  Copyright © 2017-2020 ApolloZhu. MIT License.
//

import Foundation

extension VTT {
    public init(content: String) {
        let lineSeparator: String
        if content.contains("\r\n") {
            lineSeparator = "\r\n"
        } else if content.contains("\r") {
            lineSeparator = "\r"
        } else {
            lineSeparator = "\n"
        }

        self.init(segments: content.components(separatedBy: "\(lineSeparator)\(lineSeparator)").compactMap { part in
            let lines = part.components(separatedBy: lineSeparator)
            guard !lines.isEmpty else { return nil }

            let timestampIndex = !lines[0].contains(" --> ") && lines.count > 1 && lines[1].contains(" --> ") ? 1 : 0

            let rawTimestamps = lines[timestampIndex].components(separatedBy: " --> ")
            guard rawTimestamps.count == 2 else { return nil }

            let start = Self.timeInterval(from: rawTimestamps[0])
            let finish = Self.timeInterval(from: rawTimestamps[1])
            let contents = Array(lines[(timestampIndex+1)...])
            guard !contents.isEmpty else { return nil }
            return Segment(startTime: start, endTime: finish, contents: contents)
        })
    }

    private static func timeInterval(from string: String) -> TimeInterval {
        let num = string.split(separator: ".")
            .flatMap { $0.split(separator: ":") }
            .compactMap(Double.init)
        return num[0] * 3600 + num[1] * 60 + num[2] + num[3] / 1000
    }
}
