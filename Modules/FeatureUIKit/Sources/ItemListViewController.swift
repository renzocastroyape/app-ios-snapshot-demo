import DesignSystem
import UIKit

public final class ItemListViewController: UIViewController {
    private let viewModel: ItemListViewModel
    private let onSelect: (Item) -> Void

    private var items: [Item] = []
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let messageLabel = UILabel()
    private let retryButton = DSPrimaryButton(title: "Retry")
    private let messageStack = UIStackView()

    public init(viewModel: ItemListViewModel, onSelect: @escaping (Item) -> Void) {
        self.viewModel = viewModel
        self.onSelect = onSelect
        super.init(nibName: nil, bundle: nil)
        title = "Items"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DSColor.background
        setUpTableView()
        setUpMessage()
        viewModel.onStateChange = { [weak self] state in self?.render(state) }
        render(viewModel.state)
    }

    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setUpMessage() {
        messageLabel.font = .preferredFont(forTextStyle: .body)
        messageLabel.adjustsFontForContentSizeCategory = true
        messageLabel.textColor = DSColor.textSecondary
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        retryButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            Task { await self.viewModel.load() }
        }, for: .touchUpInside)

        messageStack.axis = .vertical
        messageStack.spacing = 16
        messageStack.alignment = .center
        messageStack.addArrangedSubview(messageLabel)
        messageStack.addArrangedSubview(retryButton)
        messageStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageStack)
        NSLayoutConstraint.activate([
            messageStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messageStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            messageStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }

    private func render(_ state: ItemListViewModel.State) {
        var message: String?
        var showsRetry = false

        switch state {
        case .loading:
            items = []
            message = "Loading..."
        case .content(let newItems):
            items = newItems
        case .empty:
            items = []
            message = "No items yet"
        case .error(let text):
            items = []
            message = text
            showsRetry = true
        }

        tableView.reloadData()
        tableView.isHidden = message != nil
        messageLabel.text = message
        messageStack.isHidden = message == nil
        retryButton.isHidden = !showsRetry
    }
}

extension ItemListViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        var content = cell.defaultContentConfiguration()
        content.text = item.title
        content.secondaryText = item.subtitle
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onSelect(items[indexPath.row])
    }
}
