import UIKit

public final class DSPrimaryButton: UIButton {
    public var title: String {
        get { configuration?.title ?? "" }
        set { configuration?.title = newValue }
    }

    public init(title: String) {
        super.init(frame: .zero)
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.baseBackgroundColor = DSColor.primary
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .large
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 20, bottom: 14, trailing: 20)
        self.configuration = configuration
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
