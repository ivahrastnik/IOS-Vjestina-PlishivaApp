import Foundation

class CollectionViewModel {
    
//    @Published var movieCategories: [[MovieListModel]] = []
    private let plushieUseCase: PlushieUseCase!
        
    init(plushieUseCase: PlushieUseCase!) {
        self.plushieUseCase = plushieUseCase
    }
}
