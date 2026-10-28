import SwiftUI
import UIKit
import XCTest
@testable import DesignSystem

final class DesignSystemSnapshotTests: XCTestCase {
    func test_primaryButton_enabled() {
        assertScreenSnapshots {
            makeButtonViewController(isEnabled: true)
        }
    }

    func test_primaryButton_disabled() {
        assertScreenSnapshots {
            makeButtonViewController(isEnabled: false)
        }
    }

    func test_primaryButtonStyle() {
        assertScreenSnapshots {
            VStack(spacing: 16) {
                Button("Enabled") {}
                    .buttonStyle(DSPrimaryButtonStyle())
                Button("Disabled") {}
                    .buttonStyle(DSPrimaryButtonStyle())
                    .disabled(true)
            }
            .padding()
        }
    }

    func test_badges() {
        assertScreenSnapshots {
            VStack(spacing: 12) {
                ForEach(DSBadge.Style.allCases, id: \.self) { style in
                    DSBadge("Badge", style: style)
                }
            }
            .padding()
        }
    }
}

private func makeButtonViewController(isEnabled: Bool) -> UIViewController {
    let viewController = UIViewController()
    viewController.view.backgroundColor = DSColor.background

    let button = DSPrimaryButton(title: "Continue")
    button.isEnabled = isEnabled
    button.translatesAutoresizingMaskIntoConstraints = false
    viewController.view.addSubview(button)
    NSLayoutConstraint.activate([
        button.leadingAnchor.constraint(equalTo: viewController.view.layoutMarginsGuide.leadingAnchor),
        button.trailingAnchor.constraint(equalTo: viewController.view.layoutMarginsGuide.trailingAnchor),
        button.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor)
    ])
    return viewController
}
