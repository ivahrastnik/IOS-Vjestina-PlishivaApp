import Foundation
import UIKit

protocol CollectionCellProtocol {
  var cellType: UICollectionViewCell.Type { get }
  var identifier: String { get }
}

extension CollectionCellProtocol {
  var identifier: String {
    String(describing: cellType)
  }
}
