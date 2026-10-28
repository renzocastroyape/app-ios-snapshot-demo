import XCTest
@testable import FeatureSwiftUI

@MainActor
final class LoginViewSnapshotTests: XCTestCase {
    func test_login_empty() {
        assertScreenSnapshots { LoginView(viewModel: makeViewModel()) }
    }

    func test_login_filled() {
        assertScreenSnapshots {
            LoginView(viewModel: makeViewModel(email: "user@example.com", password: "password"))
        }
    }

    func test_login_submitting() {
        assertScreenSnapshots {
            LoginView(
                viewModel: makeViewModel(email: "user@example.com", password: "password", status: .submitting)
            )
        }
    }

    func test_login_failed() {
        assertScreenSnapshots {
            LoginView(
                viewModel: makeViewModel(
                    email: "user@example.com",
                    password: "password",
                    status: .failed("Invalid email or password")
                )
            )
        }
    }

    func test_login_succeeded() {
        assertScreenSnapshots {
            LoginView(
                viewModel: makeViewModel(email: "user@example.com", password: "password", status: .succeeded)
            )
        }
    }

    private func makeViewModel(
        email: String = "",
        password: String = "",
        status: LoginViewModel.Status = .idle
    ) -> LoginViewModel {
        LoginViewModel(authService: StubAuthService(), email: email, password: password, status: status)
    }
}
