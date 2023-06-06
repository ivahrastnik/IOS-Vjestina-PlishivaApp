import UIKit
import PureLayout
import Kingfisher

class CollectionCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: CollectionCell.self)

    private var nameLabel: UILabel!
    private var imageView: UIImageView!
    private let cornerRadiusSize: CGFloat = 10
    private var didTapHeart: (() -> Void)?
    private var plushieId: Int!
    private var heart: UIButton!
    private var heartImage: UIImage!

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CollectionCell {

    private func buildViews() {
        createViews()
        styleViews()
        defineLayout()
        setupActions()
    }

    private func createViews() {
        nameLabel = UILabel()
        imageView = UIImageView()
        
        heart = UIButton()
        heartImage = UIImage()
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(heart)
    }

    private func styleViews() {
        contentView.backgroundColor = Colors.backgroundColor
        contentView.layer.cornerRadius = cornerRadiusSize
        contentView.clipsToBounds = true
        contentView.layer.position = contentView.center
        
        heart.tintColor = .white
        heart.backgroundColor = Colors.cellColor
        heart.layer.cornerRadius = 10
        heart.setImage(UIImage(systemName: "heart"), for: .normal)
        heart.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: "Helvetica", size: 12)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = Colors.cellColor
    }

    private func defineLayout() {
        nameLabel.autoSetDimension(.height, toSize: 20)
        nameLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 0)
        nameLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        nameLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 0)
        
        imageView.autoPinEdge(toSuperviewSafeArea: .trailing)
        imageView.autoPinEdge(toSuperviewEdge: .top)
        imageView.autoPinEdge(toSuperviewEdge: .bottom)
        imageView.autoPinEdge(toSuperviewEdge: .leading)
        
        heart.autoPinEdge(toSuperviewEdge: .top, withInset: 6)
        heart.autoPinEdge(toSuperviewEdge: .leading, withInset: 6)
        heart.autoSetDimensions(to: CGSize(width: 24, height: 24))
    }
    
    private func setupActions() {
        heart.addTarget(self, action: #selector(tap(_:)), for: .touchUpInside)
      }
      
    @objc
    private func tap(_ sender: UIButton!) {
        heart.isSelected = !heart.isSelected
        if heart.isSelected {
            Defaults.favoritePlushiesIds?.append(plushieId)
        } else {
            let index = Defaults.favoritePlushiesIds?.firstIndex(of: plushieId)
            if let index = index {
                Defaults.favoritePlushiesIds?.remove(at: index)
            }
        }
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    public func configure(with imageName: String, name: String, plushieId: Int, didTapHeart: @escaping () -> Void) {
        
        nameLabel.text = name
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFill
        
        self.didTapHeart = didTapHeart
        self.plushieId = plushieId
        
        let favIds = Defaults.favoritePlushiesIds
        if let favIds = favIds {
            if favIds.contains(plushieId) {
                heart.isSelected = true
            } else {
                heart.isSelected = false
            }
        } else {
            heart.isSelected = false
        }
  }
}

