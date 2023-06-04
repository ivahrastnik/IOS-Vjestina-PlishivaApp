import Foundation
import UIKit
import PureLayout

class CollectionViewController: UIViewController {
    
    private var flowLayout: UICollectionViewFlowLayout!
    private var collectionView: UICollectionView!
    private var collectionCellHeight: Int = 142
    
    private var router: RouterProtocol!
    private var collectionViewModel: CollectionViewModel!
//    private var database: Database!
    private var allPlushies: [Plushie]!
    private var model: [CollectionCellProtocol] = .init()
    
    init(router: RouterProtocol, collectionViewModel: CollectionViewModel) {
        self.collectionViewModel = collectionViewModel
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
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) { super.willTransition(to: newCollection, with: coordinator)
        flowLayout.invalidateLayout()
    }
    
    private func loadData(){
        allPlushies = Database().allPlushies
    }
    
    private func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    private func createViews(){
        
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout)
        view.addSubview(collectionView)
        
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    private func styleViews(){
        view.backgroundColor = Colors.backgroundColor
        collectionView.backgroundColor = Colors.backgroundColor
    }
    
    private func defineLayoutForViews(){
        collectionView.autoPinEdge(toSuperviewSafeArea: .top)
        collectionView.autoPinEdge(toSuperviewSafeArea: .bottom)
        collectionView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 12)
        collectionView.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 12)
    }
    
}

extension CollectionViewController: UICollectionViewDataSource {
    
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
        let plushie = allPlushies[indexPath.row]
        let plushieId = indexPath.row
        var image: UIImage?
        if let favoriteIds = Preferences.favoritePlushiesIds {
              if favoriteIds.contains(plushieId) {
                image = UIImage(systemName: "heart.fill")
              } else {
                image = UIImage(systemName: "heart")
              }
        }
//        let currentModel = model[indexPath.row]
        guard let image else { return cell }
        image.withTintColor(.white)
        cell.set(name: plushie.name, imageName: plushie.imageName, heartImage: image)
        
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let emptySpace = 8
        let collectionCellWidth = (Int(collectionView.bounds.width)/3 - emptySpace)
        return CGSize(width: collectionCellWidth, height: collectionCellHeight)
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router.showDetailsViewController(plushieId: indexPath.row)
    }
    
}
