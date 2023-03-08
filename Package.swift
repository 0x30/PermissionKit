// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PermissionKit",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PermissionKit",
            targets: ["PermissionKit"]
        ),
        .library(
            name: "ContactsPermission",
            targets: ["ContactsPermission"]
        ),
        .library(
            name: "LocationPermission",
            targets: ["LocationPermission"]
        ),
        .library(
            name: "TrackingPermission",
            targets: ["TrackingPermission"]
        ),
        .library(
            name: "MicrophonePermission",
            targets: ["MicrophonePermission"]
        ),
        .library(
            name: "CameraPermission",
            targets: ["CameraPermission"]
        ),
        .library(
            name: "PhotosPermission",
            targets: ["PhotosPermission"]
        ),
        .library(
            name: "NotificationPermission",
            targets: ["NotificationPermission"]
        ),

    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PermissionKit"
        ),
        .target(
            name: "ContactsPermission",
            dependencies: ["PermissionKit"]
        ),
        .target(
            name: "LocationPermission",
            dependencies: ["PermissionKit"]
        ),
        .target(
            name: "TrackingPermission",
            dependencies: ["PermissionKit"]
        ),
        .target(
            name: "MicrophonePermission",
            dependencies: ["PermissionKit"]
        ),
        .target(
            name: "CameraPermission",
            dependencies: ["PermissionKit"]
        ),
        .target(
            name: "PhotosPermission",
            dependencies: ["PermissionKit"]
        ),
        .target(
            name: "NotificationPermission",
            dependencies: ["PermissionKit"]
        ),
    ]
)
