// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "subtitle",
    products: [
        .executable(
            name: "convert",
            targets: ["convert"]),
        .library(
            name: "subtitle",
            targets: ["subtitle"]),
        .library(
            name: "bcc",
            targets: ["bcc"]),
        .library(
            name: "srt",
            targets: ["srt"]),
        .library(
            name: "vtt",
            targets: ["vtt"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
        .package(url: "https://github.com/onevcat/Rainbow.git", from: "3.1.4"),
    ],
    targets: [
        .target(
            name: "subtitle",
            dependencies: []),
        .target(
            name: "bcc",
            dependencies: ["subtitle"]),
        .target(
            name: "srt",
            dependencies: ["subtitle"]),
        .target(
            name: "vtt",
            dependencies: ["subtitle"]),
        .target(
            name: "convert",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Rainbow", "subtitle", "bcc", "srt", "vtt"]),
        .testTarget(
            name: "subtitleTests",
            dependencies: ["subtitle"]),
    ]
)
