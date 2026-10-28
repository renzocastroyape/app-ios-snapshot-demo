import SwiftUI

public struct DSPrimaryButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        StyledButton(configuration: configuration)
    }

    private struct StyledButton: View {
        @Environment(\.isEnabled) private var isEnabled
        let configuration: ButtonStyleConfiguration

        var body: some View {
            configuration.label
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .padding(.horizontal, 20)
                .background(Color.dsPrimary.opacity(isEnabled ? 1 : 0.4))
                .cornerRadius(12)
                .opacity(configuration.isPressed ? 0.8 : 1)
        }
    }
}
