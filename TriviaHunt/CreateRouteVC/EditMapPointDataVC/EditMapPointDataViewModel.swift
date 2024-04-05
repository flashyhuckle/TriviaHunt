import Foundation

final class EditMapPointDataViewModel {
    let point: MapPoint
    
    init(point: MapPoint) {
        self.point = point
    }
    
    func overrideMapPointData(title: String, description: String) {
        point.title = title
        point.description = description
    }
}
