import DesignSystem
import UIKit

public final class ItemDetailViewController: UIViewController {
    private let item: Item

    public init(item: Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
        title = "Detail"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DSColor.background

        let titleLabel = UILabel()
        titleLabel.text = item.title
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.textColor = DSColor.textPrimary

        let subtitleLabel = UILabel()
        subtitleLabel.text = item.subtitle
        subtitleLabel.font = .preferredFont(forTextStyle: .body)
        subtitleLabel.textColor = DSColor.textSecondary

        for label in [titleLabel, subtitleLabel] {
            label.adjustsFontForContentSizeCategory = true
            label.numberOfLines = 0
        }

        let doneButton = DSPrimaryButton(title: "Mark as done")

        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, doneButton])
        stack.axis = .vertical
        stack.spacing = 12
        stack.setCustomSpacing(24, after: subtitleLabel)
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
}
