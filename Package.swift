// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "HierarchyResponder",
	platforms: [.iOS(.v13), .macOS(.v10_15), .watchOS(.v6), .macCatalyst(.v13), .tvOS(.v13)],
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
