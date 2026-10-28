public protocol AuthService {
    func signIn(email: String, password: String) async throws
}

public struct StubAuthService: AuthService {
    public init() {}

    public func signIn(email: String, password: String) async throws {
        if password != "password" {
            throw LoginError.invalidCredentials
        }
    }
}

public enum LoginError: Error {
    case invalidCredentials
}
