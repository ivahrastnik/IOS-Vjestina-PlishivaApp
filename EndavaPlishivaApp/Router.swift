import Foundation
import UIKit

protocol RouterProtocol {
    func setStartScreen(in window: UIWindow?)
    func showDetailsViewController(plushieId: Int)
}
class Router: RouterProtocol {
    private let navigationController: UINavigationController!
    private var tabBarController: UITabBarController!
    private var collectionVC: CollectionViewController!
    private var favoritesVC: FavoritesViewController!
    private var detailsVC: DetailsViewController!
    private let plushieUseCase: PlushieUseCase!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.plushieUseCase = PlushieUseCase()
    }
    func setStartScreen(in window: UIWindow?) {
        
        collectionVC = CollectionViewController(router: self, collectionViewModel: CollectionViewModel(plushieUseCase: plushieUseCase))
        
        favoritesVC = FavoritesViewController(router: self, favoritesViewModel: FavoritesViewModel())
        
        tabBarController = UITabBarController()
        
        styleControllers()
        
        navigationController.pushViewController(collectionVC, animated: false)
        
        tabBarController.viewControllers = [navigationController, favoritesVC]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    func styleControllers() {
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Fonts.navTitleFont!]
        navigationController.navigationBar.barTintColor = Colors.backgroundColor
        collectionVC.navigationItem.title = "PlishIva APP"
        
        let home = UIImage(systemName: "house")
        collectionVC.tabBarItem = UITabBarItem(title: "All plushies", image: .some(home!), selectedImage: .some(home!))
        
        let fav = UIImage(systemName: "heart")
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: .some(fav!), selectedImage: .some(fav!))
        
        tabBarController.tabBar.tintColor = Colors.shadowColor
        tabBarController.tabBar.backgroundColor = Colors.backgroundColor
        
    }
    func showDetailsViewController(plushieId: Int) {
        detailsVC = DetailsViewController(router: self, detailsViewModel: DetailsViewModel(id: plushieId, plushieUseCase: plushieUseCase))
        
        detailsVC.navigationItem.title = "Plushie details"
        navigationController.pushViewController(detailsVC, animated: false)
        
    }
}
