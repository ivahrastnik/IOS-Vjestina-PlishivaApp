import Foundation

enum Defaults {
    private static let favoritePlushiesIdsKey = "favoritePlushiesIdsKey"
    
    static var favoritePlushiesIds: [Int]? {
        get {
            guard let _ = UserDefaults.standard.array(forKey: favoritePlushiesIdsKey) as? [Int] else {
                let list: [Int] = .init()
                UserDefaults.standard.set(list, forKey: favoritePlushiesIdsKey)
                return list
            }
            return UserDefaults.standard.array(forKey: favoritePlushiesIdsKey) as? [Int]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: favoritePlushiesIdsKey)
        }
    }
}
