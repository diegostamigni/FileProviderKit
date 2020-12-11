// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "FileProviderKit",
	platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "FileProviderKit",
            targets: ["FileProviderKit"]),
    ],
    dependencies: [
		.package(name: "GoogleAPIClientForREST", url: "https://github.com/google/google-api-objectivec-client-for-rest", from: "1.5.1"),
		.package(url: "https://github.com/dropbox/SwiftyDropbox", from: "6.0.3"),
		.package(url: "https://github.com/sugarpac/SwiftGoogleSignIn.git", .branch("main")),
        .package(name: "AppAuth", url: "https://github.com/openid/AppAuth-iOS.git", from: "1.3.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "FileProviderKit",
            dependencies: [
				"SwiftyDropbox",
                "AppAuth",
				.product(name: "GoogleSignIn", package: "SwiftGoogleSignIn"),
				.product(name: "GoogleAPIClientForREST_Drive", package: "GoogleAPIClientForREST")
			],
			path: "Sources"),
        .testTarget(
            name: "FileProviderKitTests",
            dependencies: ["FileProviderKit"]),
    ]
)
