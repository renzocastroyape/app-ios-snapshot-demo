import SwiftUI

public struct DSBadge: View {
    public enum Style: CaseIterable {
        case info
        case success
        case warning
        case error

        var color: Color {
            switch self {
            case .info: return .dsPrimary
            case .success: return .dsSuccess
            case .warning: return .dsWarning
            case .error: return .dsError
            }
        }
    }

    private let text: String
    private let style: Style

    public init(_ text: String, style: Style) {
        self.text = text
        self.style = style
    }

    public var body: some View {
        Text(text)
            .font(.caption.bold())
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(style.color)
            .clipShape(Capsule())
    }
}
