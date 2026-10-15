import UIKit

@MainActor
final class AppCoordinator {
    private let window: UIWindow
    private let homeRepository: HomeRepository

    init(window: UIWindow, homeRepository: HomeRepository = MockHomeRepository()) {
        self.window = window
        self.homeRepository = homeRepository
    }

    func start() {
        window.rootViewController = SplashViewController()

        let homeViewModel = HomeViewModel(repository: homeRepository)
        Task { [weak self] in
            await homeViewModel.load()
            guard let self else { return }

            UIView.transition(with: self.window, duration: 0.25, options: .transitionCrossDissolve) {
                self.window.rootViewController = HomeViewController(viewModel: homeViewModel)
            }
        }
    }
}
