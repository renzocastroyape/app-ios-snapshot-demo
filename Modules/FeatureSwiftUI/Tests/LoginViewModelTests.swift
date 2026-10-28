import XCTest
@testable import FeatureSwiftUI

@MainActor
final class LoginViewModelTests: XCTestCase {
    func test_canSubmit_requiresValidEmailAndLongEnoughPassword() {
        let sut = makeSUT()
        XCTAssertFalse(sut.canSubmit)

        sut.email = "user@example.com"
        XCTAssertFalse(sut.canSubmit)

        sut.password = "password"
        XCTAssertTrue(sut.canSubmit)
    }

    func test_submit_withValidCredentials_succeeds() async {
        let sut = makeSUT(email: "user@example.com", password: "password")

        await sut.submit()

        XCTAssertEqual(sut.status, .succeeded)
    }

    func test_submit_withWrongPassword_fails() async {
        let sut = makeSUT(email: "user@example.com", password: "wrong-password")

        await sut.submit()

        XCTAssertEqual(sut.status, .failed("Invalid email or password"))
    }

    func test_submit_whenInvalidInput_doesNothing() async {
        let sut = makeSUT(email: "invalid", password: "short")

        await sut.submit()

        XCTAssertEqual(sut.status, .idle)
    }

    private func makeSUT(email: String = "", password: String = "") -> LoginViewModel {
        LoginViewModel(authService: StubAuthService(), email: email, password: password)
    }
}
