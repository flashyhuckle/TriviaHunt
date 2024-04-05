import Foundation
import CoreLocation
import CoreLocationUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    //ios17 CLMonitor
    private var monitor: CLMonitor?

    var didReachAPoint: ((String) -> Void)?

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        
        //ios17
        Task {
            monitor = await CLMonitor("Monitor")
        }
    }
    
    func monitor(for points: [MapPoint]) {
//        for point in points {
//            let region = CLCircularRegion(
//                center: point.coordinate.locationCoordinate(),
//                radius: 20,
//                identifier: point.title
//            )
//            manager.startMonitoring(for: region)
//        }
//        manager.requestLocation()
        
        Task {
            await monitor2(for: points)
        }
    }
    
    //ios17
    func monitor2(for points: [MapPoint]) async {
        guard let monitor = monitor else { return }
        for identifier in await monitor.identifiers {
            await monitor.remove(identifier)
        }
        for point in points {
            let condition = CLMonitor.CircularGeographicCondition(center: point.coordinate.locationCoordinate(), radius: 20)
            await monitor.add(condition, identifier: point.title, assuming: .unsatisfied)
        }
        
        for condition in await monitor.identifiers {
            print(condition)
        }
        
        do {
            for try await event in await monitor.events {
                print("new event")
                if event.state == .satisfied {
                    print("\(event.identifier) is discovered")
                    await monitor.remove(event.identifier)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let region = region as? CLCircularRegion else { return }
        didReachAPoint?(region.identifier)
        manager.stopMonitoring(for: region)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first?.coordinate else { return }
        checkPoint(with: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    private func checkPoint(with location: CLLocationCoordinate2D) {
        guard let regions = manager.monitoredRegions as? Set<CLCircularRegion> else { return }
        for region in regions {
            if region.contains(location) {
                self.didReachAPoint?(region.identifier)
                manager.stopMonitoring(for: region)
            }
        }
    }
}
