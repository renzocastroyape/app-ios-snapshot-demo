@MainActor
public final class ItemListViewModel {
    public enum State: Equatable {
        case loading
        case content([Item])
        case empty
        case error(String)
    }

    public private(set) var state: State {
        didSet { onStateChange?(state) }
    }

    public var onStateChange: ((State) -> Void)?

    private let repository: ItemsRepository

    public init(repository: ItemsRepository, state: State = .loading) {
        self.repository = repository
        self.state = state
    }

    public func load() async {
        state = .loading
        do {
            let items = try await repository.fetchItems()
            state = items.isEmpty ? .empty : .content(items)
        } catch {
            state = .error("Could not load items")
        }
    }
}
