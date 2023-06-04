import Foundation
import UIKit

class DetailsViewModel {
    private let plushieUseCase: PlushieUseCase!
    var id: Int = 0
    
    init(id: Int, plushieUseCase: PlushieUseCase) {
            self.id = id
            self.plushieUseCase = plushieUseCase
    }
}
