import CoreLocation

class Database {
    let allPlushies: [Plushie]
    let storeLocations: [StoreLocation]

    init() {
        storeLocations =
            [StoreLocation(name: "Arena Centar", coordinates: CLLocationCoordinate2D(latitude: 45.771195,  longitude: 15.939294)),
             StoreLocation(name: "City Center One", coordinates: CLLocationCoordinate2D(latitude: 45.798503,  longitude: 15.886054)),
             StoreLocation(name: "Avenue Mall", coordinates: CLLocationCoordinate2D(latitude: 45.777281,   longitude: 15.979214))]
        
        allPlushies =
            [Plushie(name: "Sloth", imageName: "sloth", storeLocations: [storeLocations[0], storeLocations[1], storeLocations[2]], categories: ["Large animals"], colors: ["beige", "brown"]),
            Plushie(name: "Blue teddy bear", imageName: "blueTeddyBear", storeLocations: [storeLocations[0], storeLocations[2]], categories: ["Teddy bears"], colors: ["blue"]),
            Plushie(name: "Robot", imageName: "robot", storeLocations: [storeLocations[2]], categories: [], colors: ["grey", "orange"]),
            Plushie(name: "Lion", imageName: "lion", storeLocations: [storeLocations[0], storeLocations[2]], categories: [""], colors: ["beige", "brown"]),
             Plushie(name: "Sea turtle", imageName: "seaTurtle", storeLocations: [storeLocations[0]], categories: ["Sea animals"], colors: ["blue", "purple"]),
             Plushie(name: "Beige teddy bear", imageName: "beigeTeddyBear", storeLocations: [storeLocations[2]], categories: ["Teddy bears"], colors: ["beige"]),
             Plushie(name: "Crab", imageName: "crab", storeLocations: [storeLocations[1], storeLocations[2]], categories: ["Sea animals"], colors: ["red"]),
             Plushie(name: "Frog", imageName: "frog", storeLocations: [storeLocations[1], storeLocations[2]], categories: [""], colors: ["green"]),
             Plushie(name: "Deer", imageName: "deer", storeLocations: [storeLocations[0], storeLocations[1], storeLocations[2]], categories: [""], colors: ["beige"]),
             Plushie(name: "Large beige bear", imageName: "largeBeigeBear", storeLocations: [storeLocations[1]], categories: ["Teddy bears"], colors: ["beige"]),
             Plushie(name: "Blue giraffe", imageName: "giraffe", storeLocations: [storeLocations[2]], categories: [""], colors: ["blue"])]
    }
    
    func getPlushie(id: Int) -> Plushie {
        return allPlushies[id]
    }
}

public struct Plushie {
    let name: String
    let imageName: String
    let storeLocations: [StoreLocation]
    let categories: [String]
    let colors: [String]
}

public struct StoreLocation {
    let name: String
    let coordinates: CLLocationCoordinate2D
}
