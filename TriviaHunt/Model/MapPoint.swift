import MapKit

class MapPoint: Equatable, Codable {
    static func == (lhs: MapPoint, rhs: MapPoint) -> Bool {
        lhs.title == rhs.title
    }
    
    var title: String
    var description: String
    let coordinate: Coordinate
    var isDiscovered: Bool
    
    init(
        title: String,
        description: String,
        coordinate: Coordinate
    ) {
        self.title = title
        self.description = description
        self.coordinate = coordinate
        self.isDiscovered = false
    }
}

extension MapPoint {
    func isInvalid() -> Bool {
        description.isEmpty
    }
}

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double

    func locationCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude,
                                      longitude: self.longitude)
    }
}
