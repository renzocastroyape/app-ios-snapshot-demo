import UIKit
import XCTest
@testable import FeatureUIKit

@MainActor
final class FeatureUIKitSnapshotTests: XCTestCase {
    private let items = [
        Item(id: 1, title: "Groceries", subtitle: "Milk, eggs and bread"),
        Item(id: 2, title: "Book flight", subtitle: "Compare prices before Friday"),
        Item(id: 3, title: "Call the bank", subtitle: "Ask about the new card")
    ]

    func test_list_loading() {
        assertScreenSnapshots { makeList(state: .loading) }
    }

    func test_list_content() {
        assertScreenSnapshots { makeList(state: .content(items)) }
    }

    func test_list_empty() {
        assertScreenSnapshots { makeList(state: .empty) }
    }

    func test_list_error() {
        assertScreenSnapshots { makeList(state: .error("Could not load items")) }
    }

    func test_detail() {
        assertScreenSnapshots {
            UINavigationController(rootViewController: ItemDetailViewController(item: items[0]))
        }
    }

    private func makeList(state: ItemListViewModel.State) -> UIViewController {
        let viewModel = ItemListViewModel(repository: NeverCalledRepository(), state: state)
        return UINavigationController(
            rootViewController: ItemListViewController(viewModel: viewModel) { _ in }
        )
    }
}

private struct NeverCalledRepository: ItemsRepository {
    func fetchItems() async throws -> [Item] {
        fatalError("Snapshot tests inject the state directly")
    }
}
