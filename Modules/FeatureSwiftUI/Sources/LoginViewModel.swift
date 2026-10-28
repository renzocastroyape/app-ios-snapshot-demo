import Foundation

@MainActor
public final class LoginViewModel: ObservableObject {
    public enum Status: Equatable {
        case idle
        case submitting
        case failed(String)
        case succeeded
    }

    @Published public var email: String
    @Published public var password: String
    @Published public private(set) var status: Status

    private let authService: AuthService

    public init(
        authService: AuthService,
        email: String = "",
        password: String = "",
        status: Status = .idle
    ) {
        self.authService = authService
        self.email = email
        self.password = password
        self.status = status
    }

    public var canSubmit: Bool {
        email.contains("@") && password.count >= 8 && status != .submitting
    }

    public func submit() async {
        guard canSubmit else { return }
        status = .submitting
        do {
            try await authService.signIn(email: email, password: password)
            status = .succeeded
        } catch {
            status = .failed("Invalid email or password")
        }
    }
}
