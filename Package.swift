// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "vii",
    platforms: [
       .macOS(.v10_14)
    ],
    products: [
      .executable(name: "Vii", targets: ["Vii"]),
      .library(name: "ViiLibrary", targets: ["ViiLibrary"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/console-kit.git", from: "4.0.0-beta.2"),
        .package(url: "https://github.com/vapor/mysql-kit.git", from: "4.0.0-beta.3"),
        .package(url: "https://github.com/vapor/postgres-kit.git", from: "2.0.0-beta.3.1"),
        .package(url: "https://github.com/vapor/sql-kit.git", from: "3.0.0-beta.3"),
    ],
    targets: [
        .target(
            name: "Vii",
            dependencies: ["ConsoleKit", "ViiLibrary"]),
        .target(
            name: "ViiLibrary",
            dependencies: ["SQLKit", "PostgresKit", "MySQLKit"]),
        .testTarget(
            name: "ViiTests",
            dependencies: ["ViiLibrary"]),
    ]
)
