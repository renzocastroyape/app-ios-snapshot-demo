import SnapshotTesting
import SwiftUI
import UIKit
import XCTest

// Single reference device: iPhone 17 (402x874 pt).
extension ViewImageConfig {
    static let referenceDevice = ViewImageConfig(
        safeArea: UIEdgeInsets(top: 62, left: 0, bottom: 34, right: 0),
        size: CGSize(width: 402, height: 874),
        traits: UITraitCollection(traitsFrom: [
            UITraitCollection(displayScale: 3),
            UITraitCollection(userInterfaceIdiom: .phone)
        ])
    )
}

enum SnapshotVariant: String, CaseIterable {
    case light
    case dark
    case largeText

    var traits: UITraitCollection {
        switch self {
        case .light:
            return UITraitCollection(userInterfaceStyle: .light)
        case .dark:
            return UITraitCollection(userInterfaceStyle: .dark)
        case .largeText:
            return UITraitCollection(traitsFrom: [
                UITraitCollection(userInterfaceStyle: .light),
                UITraitCollection(preferredContentSizeCategory: .accessibilityExtraLarge)
            ])
        }
    }
}

/// Snapshots a screen in light, dark and large Dynamic Type variants.
func assertScreenSnapshots(
    of makeViewController: () -> UIViewController,
    file: StaticString = #filePath,
    testName: String = #function,
    line: UInt = #line
) {
    for variant in SnapshotVariant.allCases {
        assertSnapshot(
            of: makeViewController(),
            as: .image(
                on: .referenceDevice,
                precision: 0.99,
                perceptualPrecision: 0.98,
                traits: variant.traits
            ),
            named: variant.rawValue,
            file: file,
            testName: testName,
            line: line
        )
    }
}

func assertScreenSnapshots<Content: View>(
    of makeView: () -> Content,
    file: StaticString = #filePath,
    testName: String = #function,
    line: UInt = #line
) {
    assertScreenSnapshots(
        of: { UIHostingController(rootView: makeView()) },
        file: file,
        testName: testName,
        line: line
    )
}
