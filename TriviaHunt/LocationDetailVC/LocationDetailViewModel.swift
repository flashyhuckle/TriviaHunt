import Foundation

final class LocationDetailViewModel {
    private let point: MapPoint
    
    init(point: MapPoint) {
        self.point = point
    }
    
    func getPointTitle() -> String {
        switch point.isDiscovered {
        case true:
            return point.title
        case false:
            return "point not yet discovered"
        }
    }
    
    func getPointDescription() -> String{
        switch point.isDiscovered {
        case true:
            return point.description
        case false:
            return "point not yet discovered"
        }
    }
}
