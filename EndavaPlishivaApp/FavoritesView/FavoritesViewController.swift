import Foundation
import UIKit
import PureLayout

class FavoritesViewController: UIViewController {
    private var flowLayout: UICollectionViewFlowLayout!
    private var favoritesCollectionView: UICollectionView!
    private var collectionCellHeight: Int = 142
    private var titleLabel: UILabel!
    
    private var router: RouterProtocol!
    private var favPlushies: [Plushie]!
    private var allPlushies: [Plushie]!
    private var favoritesViewModel: FavoritesViewModel!
    private var favIds: [Int] = .init()
    private var id: Int!
    
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
        loadData()
        buildViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.favoritesCollectionView.alpha = 0
        getFavPlushies()
    }
    
    override func viewDidAppear(_ animated: Bool) { super.viewDidAppear(animated)
        UIView.animate(
            withDuration: 0.5,
            delay: 0.2,
                animations: {
                    self.favoritesCollectionView.alpha = 1.0
            })
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        flowLayout.invalidateLayout()
    }
    
    private func loadData(){
        allPlushies = Database().allPlushies
        favIds = []
        favIds = Defaults.favoritePlushiesIds ?? []
        print(favIds)
    }
    
    private func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
        getFavPlushies()
    }
    
    private func createViews(){
        titleLabel = UILabel()
        view.addSubview(titleLabel)
        
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
        titleLabel.text = "My favorite plushies"
        titleLabel.font = Fonts.navTitleFont
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        favoritesCollectionView.backgroundColor = Colors.backgroundColor
    }
    
    private func defineLayoutForViews(){
        titleLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 8)
        titleLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 12)
        titleLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 12)
        
        favoritesCollectionView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 16)
        favoritesCollectionView.autoPinEdge(toSuperviewSafeArea: .bottom)
        favoritesCollectionView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 12)
        favoritesCollectionView.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 12)
    }
    
    private func getFavPlushies() {
        guard let favPlushies = Defaults.favoritePlushiesIds else { return }
        favIds = favPlushies
        print(favIds)
        favoritesCollectionView.reloadData()
    }
}
extension FavoritesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Defaults.favoritePlushiesIds?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reuseIdentifier, for: indexPath)
                as? CollectionCell
        else { return UICollectionViewCell() }
        
        if indexPath.row >= Defaults.favoritePlushiesIds?.count ?? 0 { return cell }
        
        print("DEBUG: cellForItemAt: \(indexPath)")
        
        let index = Defaults.favoritePlushiesIds?[indexPath.row] ?? 0
        let plushie = allPlushies[index]
        let plushieId = plushie.id
        
        cell.configure(with: plushie.imageName, name: plushie.name, plushieId: plushieId) {
            collectionView.reloadData()
            guard let favoritePlushies = Defaults.favoritePlushiesIds else { return }
              var plushieIds = Defaults.favoritePlushiesIds!
            if favoritePlushies.contains(plushieId) {
                plushieIds.removeAll { id in
                    id == plushieId
                }
                Defaults.favoritePlushiesIds = plushieIds
                self.getFavPlushies()
              } else {
                  plushieIds.append(plushieId)
                  Defaults.favoritePlushiesIds = plushieIds
              }
            collectionView.reloadData()
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
