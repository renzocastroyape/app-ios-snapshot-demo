import UIKit
import XCTest
@testable import DesignSystem

final class DSColorTests: XCTestCase {
    func test_primary_resolvesDifferentColorsForLightAndDark() {
        let light = DSColor.primary.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        let dark = DSColor.primary.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))

        XCTAssertNotEqual(light, dark)
    }
}
