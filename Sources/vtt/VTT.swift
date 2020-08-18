//
//  VTT.swift
//  vtt
//
//  Created by Apollo Zhu on 5/21/20.
//  Copyright © 2017-2020 ApolloZhu. MIT License.
//

@_exported import subtitle
import Foundation

public struct VTT {
    public let language: String
    internal let _segments: [Segment]
}

extension VTT: PlainTextSubtitle {
    public var segments: [SubtitleSegment] {
        return _segments
    }

    public init(segments: [SubtitleSegment]) {
        self._segments = (segments as? [Segment]) ?? segments.map {
            Segment(
                startTime: $0.startTime,
                endTime: $0.endTime,
                contents: $0.contents
            )
        }
        let tagger = NSLinguisticTagger(tagSchemes: [.language], options: 0)
        tagger.string = _segments
            .flatMap { $0.contents }
            .joined(separator: "\n")
        if #available(macOS 10.13, *) {
            language = tagger.dominantLanguage ?? "en"
        } else {
            language = "en"
        }
    }
}

extension VTT: CustomStringConvertible {
    public var description: String {
        return """
        WEBVTT
        Kind: captions
        Language: \(language)

        \(_segments.map { $0.description }.joined(separator: "\n\n"))

        """
    }
}
