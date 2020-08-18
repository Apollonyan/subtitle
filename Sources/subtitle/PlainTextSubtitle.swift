//
//  PlainTextSubtitle.swift
//  subtitle
//
//  Created by Apollo Zhu on 8/18/20.
//  Copyright © 2017-2020 ApolloZhu. MIT License.
//

import Foundation

public protocol PlainTextSubtitle: Subtitle, CustomStringConvertible {
    init(content: String)
}

extension PlainTextSubtitle {
    public init(data: Data) throws {
        guard let content = String(data: data, encoding: .utf8) else {
            throw CocoaError(.fileReadInapplicableStringEncoding)
        }
        self.init(content: content)
    }

    public func asData() throws -> Data {
        guard let data = description.data(using: .utf8) else {
            throw CocoaError(.fileWriteInapplicableStringEncoding)
        }
        return data
    }
}
