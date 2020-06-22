// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// swiftlint:disable:next prefixed_toplevel_constant
let package = Package(
    name: "BasicNetwork",
    products: [
        .library(
            name: "BasicNetwork",
            targets: ["BasicNetwork"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "BasicNetwork",
            dependencies: [])
    ]
)
