// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "FLShared",
	platforms: [
		.iOS(.v15),
		.macOS(.v13),
		.visionOS(.v1),
		.watchOS(.v9)
	],
	products: [
		.library(
			name: "FLShared",
			targets: ["FLShared"]),
	],
	targets: [
		.target(
			name: "FLShared"),
		.testTarget(
			name: "FLSharedTests",
			dependencies: ["FLShared"]
		),
	]
)
