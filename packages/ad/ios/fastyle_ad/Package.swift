// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "fastyle_ad",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "fastyle-ad", targets: ["fastyle_ad"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(name: "google_mobile_ads", path: "../google_mobile_ads"),
    ],
    targets: [
        .target(
            name: "fastyle_ad",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "google-mobile-ads", package: "google_mobile_ads"),
            ],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
