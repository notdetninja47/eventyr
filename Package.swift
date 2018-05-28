// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "HelloVapor",
    dependencies: [
        
        
        // Vapor
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

        // ORM
        .package(url: "https://github.com/vapor/fluent-mysql.git", from: "3.0.0-rc"),
        
        // Authentication
        .package(url: "https://github.com/vapor/auth.git", from: "2.0.0-rc")
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentMySQL", "Vapor", "Authentication"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

