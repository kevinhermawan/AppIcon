// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppIcon",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "AppIcon",
            targets: ["AppIcon"]),
    ],
    targets: [
        .target(
            name: "AppIcon"),
        .testTarget(
            name: "AppIconTests",
            dependencies: ["AppIcon"]),
    ]
)
