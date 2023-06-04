import UIKit
import PureLayout
import Kingfisher

class CollectionCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: CollectionCell.self)

    private var nameLabel: UILabel!
    private var imageView: UIImageView!
    private let cornerRadiusSize: CGFloat = 10
    private var didTapHeart: (() -> Void)?
    private var heart: UIButton!
    private var heartImage: UIImage!

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(name: String, imageName: String, heartImage: UIImage) {
        nameLabel.text = name
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFill
        self.heartImage = heartImage
        heart.setImage(heartImage, for: .normal)
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
//        contentView.layer.shadowPath = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 10).cgPath
//        contentView.layer.shadowColor = Colors.shadowColor.cgColor
//        contentView.layer.shadowRadius = 20
//        contentView.layer.shadowOpacity = 5
//        contentView.layer.shadowOffset = CGSize(width: 8, height: 7)
        contentView.layer.position = contentView.center
        
        heart.tintColor = .white
        heart.backgroundColor = Colors.cellColor
        heart.layer.cornerRadius = 10
        heart.setImage(heartImage, for: .normal)
        
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: "Helvetica", size: 12)
        nameLabel.textAlignment = .center
//        nameLabel.backgroundColor = .systemGray
        nameLabel.backgroundColor = Colors.cellColor
//        nameLabel.backgroundColor = UIColor(red: 204, green: 204, blue: 255, alpha: 0.7)
        
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
        heart.addTarget(self, action: #selector(tap), for: .touchUpInside)
      }
      
    @objc
    private func tap() {
        didTapHeart?()
    }
      
    override func prepareForReuse() {
        imageView.image = nil
    }
}

extension CollectionCell {
    @discardableResult
    public func configure(with imageName: String, heartImage: UIImage, didTapHeart: @escaping () -> Void) -> Self {
        imageView.image = UIImage(named: imageName)
        heart.setImage(heartImage, for: .normal)
        self.didTapHeart = didTapHeart
        return self
  }
}
