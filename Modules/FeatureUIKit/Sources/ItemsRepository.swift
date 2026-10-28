public protocol ItemsRepository {
    func fetchItems() async throws -> [Item]
}

public struct StubItemsRepository: ItemsRepository {
    public init() {}

    public func fetchItems() async throws -> [Item] {
        [
            Item(id: 1, title: "Groceries", subtitle: "Milk, eggs and bread"),
            Item(id: 2, title: "Book flight", subtitle: "Compare prices before Friday"),
            Item(id: 3, title: "Call the bank", subtitle: "Ask about the new card"),
            Item(id: 4, title: "Water plants", subtitle: "Living room and balcony")
        ]
    }
}
