import DesignSystem
import SwiftUI

public struct LoginView: View {
    @ObservedObject private var viewModel: LoginViewModel

    public init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sign in")
                .font(.largeTitle.bold())
                .foregroundColor(.dsTextPrimary)

            TextField("Email", text: $viewModel.email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)

            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)

            statusView

            Button(viewModel.status == .submitting ? "Signing in..." : "Sign in") {
                Task { await viewModel.submit() }
            }
            .buttonStyle(DSPrimaryButtonStyle())
            .disabled(!viewModel.canSubmit)

            Spacer()
        }
        .padding()
        .background(Color.dsBackground.ignoresSafeArea())
    }

    @ViewBuilder
    private var statusView: some View {
        switch viewModel.status {
        case .failed(let message):
            DSBadge(message, style: .error)
        case .succeeded:
            DSBadge("Welcome back", style: .success)
        case .idle, .submitting:
            EmptyView()
        }
    }
}
