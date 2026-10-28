import ProjectDescription

let bundleIdPrefix = "dev.snapshotdemo"
let deploymentTargets: DeploymentTargets = .iOS("15.6")
let modules = ["DesignSystem", "FeatureUIKit", "FeatureSwiftUI"]

// Each module is a framework with its own unit tests and snapshot tests.
func moduleTargets(name: String, dependencies: [TargetDependency]) -> [Target] {
    [
        .target(
            name: name,
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleIdPrefix).\(name)",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: ["Modules/\(name)/Sources/**/*.swift"],
            dependencies: dependencies
        ),
        .target(
            name: "\(name)Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleIdPrefix).\(name)Tests",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: ["Modules/\(name)/Tests/**/*.swift"],
            dependencies: [.target(name: name)]
        ),
        .target(
            name: "\(name)SnapshotTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleIdPrefix).\(name)SnapshotTests",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: [
                "Modules/\(name)/SnapshotTests/**/*.swift",
                "Shared/SnapshotSupport/**/*.swift"
            ],
            dependencies: [
                .target(name: name),
                .external(name: "SnapshotTesting")
            ]
        )
    ]
}

let project = Project(
    name: "SnapshotDemo",
    settings: .settings(base: ["SWIFT_VERSION": "5.0"]),
    targets: [
        .target(
            name: "App",
            destinations: .iOS,
            product: .app,
            bundleId: "\(bundleIdPrefix).App",
            deploymentTargets: deploymentTargets,
            infoPlist: .extendingDefault(with: ["UILaunchScreen": [:]]),
            sources: ["App/Sources/**/*.swift"],
            dependencies: [
                .target(name: "FeatureUIKit"),
                .target(name: "FeatureSwiftUI")
            ]
        )
    ]
    + moduleTargets(name: "DesignSystem", dependencies: [])
    + moduleTargets(name: "FeatureUIKit", dependencies: [.target(name: "DesignSystem")])
    + moduleTargets(name: "FeatureSwiftUI", dependencies: [.target(name: "DesignSystem")]),
    schemes: [
        .scheme(
            name: "App",
            shared: true,
            buildAction: .buildAction(targets: ["App"]),
            runAction: .runAction(executable: "App")
        ),
        .scheme(
            name: "UnitTests",
            shared: true,
            buildAction: .buildAction(targets: modules.map { TargetReference(stringLiteral: "\($0)Tests") }),
            testAction: .targets(modules.map { TestableTarget(stringLiteral: "\($0)Tests") })
        ),
        .scheme(
            name: "SnapshotTests",
            shared: true,
            buildAction: .buildAction(targets: modules.map { TargetReference(stringLiteral: "\($0)SnapshotTests") }),
            testAction: .targets(modules.map { TestableTarget(stringLiteral: "\($0)SnapshotTests") })
        )
    ]
)
