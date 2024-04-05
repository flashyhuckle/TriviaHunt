import Foundation

final class RouteDetailsViewModel {
    let route: Route
    
    init(route: Route) {
        self.route = route
    }
    
    func creatorLabelText() -> String {
        return "Created by: \(route.creator)"
    }
    
    func countLabelText() -> String {
        return "Points: \(route.mapPoints.count)"
    }
    
    func descriptionLabelText() -> String {
        return route.description
    }
    
    func addToUserRoutesPressed() {
        Task {
            do {
                try await FirebaseStorageHandler.shared.saveUserRoute(route: route)
            } catch {
                throw error
            }
        }
    }
    
    func deleteFromUserRoutesPressed() {
        Task {
            do {
                try await FirebaseStorageHandler.shared.deleteUserRoute(route: route)
            } catch {
                throw error
            }
        }
    }
    
    func shareWithCommunityPressed() {
        let username = FirebaseAuthenticator.shared.currentUsername()
        if route.creator == username {
            Task {
                do {
                    try await FirebaseStorageHandler.shared.saveToCommunityStorage(route)
                } catch {
                    throw error
                }
            }
        }
    }
    
    func isUserGenerated() -> Bool {
        switch route.creator == FirebaseAuthenticator.shared.currentUsername() {
        case true:
            return true
        case false:
            return false
        }
    }
}
