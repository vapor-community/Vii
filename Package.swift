// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "vii",
    platforms: [
       .macOS(.v10_15)
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
            dependencies: [
                .product(name: "ConsoleKit", package: "console-kit"),
                .byName(name: "ViiLibrary")
            ]
        ),
        .target(
            name: "ViiLibrary",
            dependencies: [
                .product(name: "SQLKit", package: "sql-kit"),
                .product(name: "PostgresKit", package: "postgres-kit"),
                .product(name: "MySQLKit", package: "mysql-kit")
            ]
        ),
        .testTarget(
            name: "ViiTests",
            dependencies: [
                .byName(name: "ViiLibrary")
            ]
        )
    ]
)
