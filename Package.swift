// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "HierarchyResponder",
	platforms: [.iOS(.v14), .macOS(.v11), .watchOS(.v7), .macCatalyst(.v14), .tvOS(.v14), .visionOS(.v1)],
	products: [
		.library(
			name: "HierarchyResponder",
			targets: ["HierarchyResponder"]),
	],
	dependencies: [],
	targets: [
		.target(
			name: "HierarchyResponder",
			dependencies: []),
	]
)
