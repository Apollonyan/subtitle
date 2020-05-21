//
//  SubtitleFileFormat.swift
//  convert
//
//  Created by Apollo Zhu on 5/21/20.
//  Copyright © 2017-2020 ApolloZhu. MIT License.
//

import ArgumentParser

enum SubtitleFileFormat: ExpressibleByArgument {
    init?(argument: String) {
        switch argument {
        case "srt":
            self = .srt
        case "bcc":
            self = .bcc
        default:
            self = .detectFromFileName
        }
    }

    case detectFromFileName
    case srt, bcc

    var defaultValueDescription: String {
        switch self {
        case .detectFromFileName:
            return "detect from file name"
        case .bcc:
            return "bcc"
        case .srt:
            return "srt"
        }
    }
}
