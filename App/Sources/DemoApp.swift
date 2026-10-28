import FeatureSwiftUI
import FeatureUIKit
import SwiftUI

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                ItemsFlowView()
                    .tabItem { Label("Items", systemImage: "list.bullet") }

                LoginView(viewModel: LoginViewModel(authService: StubAuthService()))
                    .tabItem { Label("Login", systemImage: "person.crop.circle") }
            }
        }
    }
}

private struct ItemsFlowView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        ItemsFlow.makeRootViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
