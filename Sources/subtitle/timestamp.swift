//
//  timestamp.swift
//  subtitle
//
//  Created by Apollo Zhu on 8/18/20.
//  Copyright © 2017-2020 ApolloZhu. MIT License.
//

import Foundation

/// Convert time interval to timestamp components.
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
