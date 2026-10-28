import SwiftUI
import UIKit

public enum DSColor {
    public static let primary = UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.40, green: 0.65, blue: 1.00, alpha: 1)
            : UIColor(red: 0.00, green: 0.35, blue: 0.85, alpha: 1)
    }

    public static let success = UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.20, green: 0.70, blue: 0.40, alpha: 1)
            : UIColor(red: 0.10, green: 0.55, blue: 0.25, alpha: 1)
    }

    public static let warning = UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.85, green: 0.55, blue: 0.10, alpha: 1)
            : UIColor(red: 0.70, green: 0.40, blue: 0.00, alpha: 1)
    }

    public static let error = UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.90, green: 0.35, blue: 0.35, alpha: 1)
            : UIColor(red: 0.75, green: 0.10, blue: 0.10, alpha: 1)
    }

    public static let background = UIColor.systemBackground
    public static let secondaryBackground = UIColor.secondarySystemBackground
    public static let textPrimary = UIColor.label
    public static let textSecondary = UIColor.secondaryLabel
}

public extension Color {
    static let dsPrimary = Color(DSColor.primary)
    static let dsSuccess = Color(DSColor.success)
    static let dsWarning = Color(DSColor.warning)
    static let dsError = Color(DSColor.error)
    static let dsBackground = Color(DSColor.background)
    static let dsTextPrimary = Color(DSColor.textPrimary)
    static let dsTextSecondary = Color(DSColor.textSecondary)
}
