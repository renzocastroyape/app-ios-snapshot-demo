import UIKit

public enum ItemsFlow {
    @MainActor
    public static func makeRootViewController(
        repository: ItemsRepository = StubItemsRepository()
    ) -> UIViewController {
        let viewModel = ItemListViewModel(repository: repository)
        let navigationController = UINavigationController()
        let list = ItemListViewController(viewModel: viewModel) { [weak navigationController] item in
            navigationController?.pushViewController(ItemDetailViewController(item: item), animated: true)
        }
        navigationController.viewControllers = [list]
        Task { await viewModel.load() }
        return navigationController
    }
}
