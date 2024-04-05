import Foundation

final class FinishRouteViewModel {
    let mapPoints: [MapPoint]
    
    init(mapPoints: [MapPoint]) {
        self.mapPoints = mapPoints
    }
    
    func createRoute(name: String, description: String) -> Route {
        let creator = FirebaseAuthenticator.shared.currentUsername()
        let route = Route(name: name, description: description, creator: creator, mapPoints: mapPoints)
        return route
    }
    
    func saveRoute(_ route: Route) {
        Task {
            do {
                try await FirebaseStorageHandler.shared.saveUserRoute(route: route)
            } catch {
                throw error
            }
        }
    }
}
