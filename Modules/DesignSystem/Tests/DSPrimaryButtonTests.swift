import UIKit
import XCTest
@testable import DesignSystem

final class DSPrimaryButtonTests: XCTestCase {
    func test_init_setsTitle() {
        let button = DSPrimaryButton(title: "Continue")

        XCTAssertEqual(button.title, "Continue")
    }

    func test_title_updatesConfiguration() {
        let button = DSPrimaryButton(title: "Continue")

        button.title = "Save"

        XCTAssertEqual(button.configuration?.title, "Save")
    }
}
