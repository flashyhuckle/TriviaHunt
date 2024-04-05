import MapKit

final class MapViewModel {
    private let locationManager: LocationManager
    private let route: Route
    
    var refreshAnnotationTitles: (() -> Void)?
    
    init(
        locationManager: LocationManager = LocationManager(),
        route: Route
    ) {
        self.locationManager = locationManager
        self.route = route
    }
    
    func viewDidLoad() {
//        locationManager.didReceiveLocation = { location in
//            self.checkPoint(with: location)
//        }
        
        locationManager.didReachAPoint = { name in
            self.foundAPoint(name)
        }
        
        locationManager.monitor(for: route.mapPoints)
    }
    
    func getPoints() -> [MapPoint] {
        route.mapPoints
    }
    
    func getTitle(for mapPoint: MapPoint) -> String {
        mapPoint.isDiscovered ? mapPoint.title : "location " + String((route.mapPoints.firstIndex(of: mapPoint) ?? 0) + 1)
    }
    
    private func foundAPoint(_ name: String) {
        let point = route.mapPoints.first { point in
            point.title == name
        }
        
        guard let point = point else { return }
        print("discovered \(point.title)")
        
        point.isDiscovered = true
        saveRoute()
        refreshAnnotationTitles?()
    }
    
//    private func checkPoint(with location: CLLocationCoordinate2D) {
//        let accuracy = 0.002
//        
//        let lat = round(location.latitude/accuracy)
//        let lon = round(location.longitude/accuracy)
//        
//        for testPoint in route.mapPoints {
//            let pointLat = round(testPoint.coordinate.latitude/accuracy)
//            let pointLon = round(testPoint.coordinate.longitude/accuracy)
//            
//            if pointLat == lat {
//                if pointLon == lon {
//                    testPoint.isDiscovered = true
//                    self.saveRoute()
//                    refreshAnnotationTitles?()
//                }
//            }
//        }
//    }
    
    private func saveRoute() {
        Task {
            do {
                try await FirebaseStorageHandler.shared.saveUserRoute(route: route)
            } catch {
                throw error
            }
        }
    }
}
