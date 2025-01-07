// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SQLite.swift",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_13),
        .watchOS(.v4),
        .tvOS(.v11),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SQLite",
            targets: ["SQLite"]
        )
    ],
    targets: [
        .target(
            name: "SQLite",
            exclude: [
                "Info.plist"
            ]
        ),
        .testTarget(
            name: "SQLiteTests",
            dependencies: [
                "SQLite"
            ],
            path: "Tests/SQLiteTests",
            exclude: [
                "Info.plist"
            ],
            resources: [
                .copy("Resources")
            ]
        )
    ]
)

import Foundation
// Android does not permit linking to its vendored sqlite3.so, so we need to
// include a bundled version of SQLite when cross-compiling to Android
if ProcessInfo.processInfo.environment["TARGET_OS_ANDROID"] == "1" {
package.dependencies = [
    .package(url: "https://github.com/swift-everywhere/CSQLite.git", from: "3.47.2")
]
package.targets.first?.dependencies += [
    .product(name: "CSQLite", package: "CSQLite", condition: .when(platforms: [.android]))
]
} else {
#if os(Linux)
package.dependencies = [
    .package(url: "https://github.com/stephencelis/CSQLite.git", from: "0.0.3")
]
package.targets.first?.dependencies += [
    .product(name: "CSQLite", package: "CSQLite")
]
#endif
}
