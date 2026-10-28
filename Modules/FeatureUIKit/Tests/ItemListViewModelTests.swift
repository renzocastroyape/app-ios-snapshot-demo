import XCTest
@testable import FeatureUIKit

@MainActor
final class ItemListViewModelTests: XCTestCase {
    func test_load_withItems_setsContentState() async {
        let items = [Item(id: 1, title: "A", subtitle: "a")]
        let sut = ItemListViewModel(repository: RepositoryStub(result: .success(items)))

        await sut.load()

        XCTAssertEqual(sut.state, .content(items))
    }

    func test_load_withNoItems_setsEmptyState() async {
        let sut = ItemListViewModel(repository: RepositoryStub(result: .success([])))

        await sut.load()

        XCTAssertEqual(sut.state, .empty)
    }

    func test_load_withFailure_setsErrorState() async {
        let sut = ItemListViewModel(repository: RepositoryStub(result: .failure(AnyError())))

        await sut.load()

        XCTAssertEqual(sut.state, .error("Could not load items"))
    }

    func test_load_notifiesLoadingThenResult() async {
        let sut = ItemListViewModel(repository: RepositoryStub(result: .success([])), state: .empty)
        var received: [ItemListViewModel.State] = []
        sut.onStateChange = { received.append($0) }

        await sut.load()

        XCTAssertEqual(received, [.loading, .empty])
    }
}

private struct AnyError: Error {}

private struct RepositoryStub: ItemsRepository {
    let result: Result<[Item], Error>

    func fetchItems() async throws -> [Item] {
        try result.get()
    }
}
