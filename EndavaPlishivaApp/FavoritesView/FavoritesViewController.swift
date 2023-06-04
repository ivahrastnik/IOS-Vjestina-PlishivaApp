import Foundation
import UIKit
import PureLayout

class FavoritesViewController: UIViewController {
    private var flowLayout: UICollectionViewFlowLayout!
    private var favoritesCollectionView: UICollectionView!
    private var collectionCellHeight: Int = 142
    
    private var router: RouterProtocol!
    private var favPlushies: [Plushie]!
    private var allPlushies: [Plushie]!
    private var favoritesViewModel: FavoritesViewModel!
    private var favIds: [Int] = .init()
    
    init(router: RouterProtocol, favoritesViewModel: FavoritesViewModel) {
        self.favoritesViewModel = favoritesViewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        loadData()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        flowLayout.invalidateLayout()
    }
    
    private func loadData(){
        allPlushies = Database().allPlushies
    }
    
    private func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
        loadData()
    }
    
    private func createViews(){
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        
        favoritesCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout)
        view.addSubview(favoritesCollectionView)
        
        favoritesCollectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.reuseIdentifier)
        favoritesCollectionView.dataSource = self
        favoritesCollectionView.delegate = self
    }
    
    private func styleViews(){
        view.backgroundColor = Colors.backgroundColor
        favoritesCollectionView.backgroundColor = Colors.backgroundColor
    }
    
    private func defineLayoutForViews(){
        favoritesCollectionView.autoPinEdge(toSuperviewSafeArea: .top)
        favoritesCollectionView.autoPinEdge(toSuperviewSafeArea: .bottom)
        favoritesCollectionView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 12)
        favoritesCollectionView.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 12)
    }
    
    private func getFavoriteMovies() {
        guard let favPlushies = Preferences.favoritePlushiesIds else { return }
        favIds = favPlushies
        loadData()
    }
}
extension FavoritesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allPlushies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reuseIdentifier, for: indexPath)
                as? CollectionCell,
            allPlushies.count > indexPath.item
        else { return UICollectionViewCell() }
        
        print("DEBUG: cellForItemAt: \(indexPath)")
        
        
        let plushieId = indexPath.row
        var image: UIImage?
        if let favoriteIds = Preferences.favoritePlushiesIds {
//              if favoriteIds.contains(plushieId) {
                image = UIImage(systemName: "heart.fill")
//              } else {
//                image = UIImage(systemName: "heart")
//              }
        }
        guard let image else { return cell }
        cell.set(name: allPlushies[indexPath.row].name, imageName: allPlushies[indexPath.row].imageName, heartImage: image)
        cell.configure(with: allPlushies[indexPath.row].imageName, heartImage: image) {
            guard let favoritePlushies = Preferences.favoritePlushiesIds else { return }
              var plushieIds = Preferences.favoritePlushiesIds!
              if favoritePlushies.contains(plushieId) {
                plushieIds.removeAll { id in
                  id == plushieId
                }
                Preferences.favoritePlushiesIds = plushieIds
                self.getFavoriteMovies()
              }
            }
        
        return cell
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let emptySpace = 6
        let collectionCellWidth = (Int(collectionView.bounds.width)/2 - emptySpace)
        return CGSize(width: collectionCellWidth, height: collectionCellHeight)
    }
}

extension FavoritesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router.showDetailsViewController(plushieId: indexPath.row)
    }
    
}
