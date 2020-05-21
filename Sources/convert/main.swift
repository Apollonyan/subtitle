//
//  main.swift
//  convert
//
//  Created by Apollo Zhu on 10/19/18.
//  Copyright © 2017-2020 ApolloZhu. MIT License.
//

import ArgumentParser
import Foundation
import Rainbow

import subtitle
import bcc
import srt

enum ConversionError: Swift.Error, LocalizedError {
    case unknownFileFormat

    var errorDescription: String? {
        switch self {
        case .unknownFileFormat:
            return "cannot recognize the subtitle format".bold.red
        }
    }
}

struct Convert: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A utility for converting subtitles.",
        version: "2.0.0"
    )

    @Argument(help: "The input file name with proper extension")
    var input: String

    @Argument(help: "The output file name with proper extension")
    var output: String

    @Option(default: .detectFromFileName, help: "Input file format")
    var inputFormat: SubtitleFileFormat

    @Option(default: .detectFromFileName, help: "Output file format")
    var outputFormat: SubtitleFileFormat

    func run() throws {
        print("Loading".bold.blue + " \(input)")
        let sub = try fileFormat(of: input, hint: inputFormat).init(path: input)
        print("Converting...".bold.blue)
        let converted = try fileFormat(of: output, hint: outputFormat)
            .init(segments: sub.segments)
        print("Saving".bold.blue + " to \(output)")
        try converted.write(to: output)
        print("Completed".bold.green)
    }
}

fileprivate func fileFormat(
    of path: String, hint: SubtitleFileFormat
) throws -> Subtitle.Type {
    switch hint {
    case .detectFromFileName:
        if path.hasSuffix(".bcc") {
            return BCC.self
        } else if path.hasSuffix(".srt") {
            return SRT.self
        } else {
            throw ConversionError.unknownFileFormat
        }
    case .bcc:
        return BCC.self
    case .srt:
        return SRT.self
    }
}

Convert.main()
