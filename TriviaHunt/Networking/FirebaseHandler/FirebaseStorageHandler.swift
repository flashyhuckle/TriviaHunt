import Foundation
import Firebase

final class FirebaseStorageHandler {
    private var userRoutes = [Route]()
    let db = Firestore.firestore()
    let communityRoutesCollection = "CommunityRoutes"
    let routeKey = "Route"
    
    static let shared = FirebaseStorageHandler()
    private init() {}
    
    func loadCommunityStorage() async throws -> [Route] {
        do {
            let query = try await db.collection(communityRoutesCollection).getDocuments()
            let documents = query.documents
            var routes = [Route]()
            for document in documents {
                let data = document.data()
                let decoded = try JSONDecoder().decode(Route.self, from: data[routeKey] as! Data)
                routes.append(decoded)
            }
            return routes
        } catch {
            throw error
        }
    }
    
    func saveToCommunityStorage(_ route: Route) async throws {
        do {
            let encoded = try JSONEncoder().encode(route)
            try await db.collection(communityRoutesCollection).document(route.id.string()).setData([routeKey: encoded])
        } catch {
            throw error
        }
    }
    
    func loadUserStorage() async throws -> [Route] {
        let username = FirebaseAuthenticator.shared.currentUsername()
        guard !username.isEmpty else { return [] }
        
        do {
            let query = try await db.collection(username).getDocuments()
            let documents = query.documents
            var routes = [Route]()
            for document in documents {
                let data = document.data()
                let decoded = try JSONDecoder().decode(Route.self, from: data[routeKey] as! Data)
                routes.append(decoded)
            }
            return routes
        } catch {
            throw error
        }
    }
    
    func saveUserStorage(routes: [Route]) async throws {
        let username = FirebaseAuthenticator.shared.currentUsername()
        guard !username.isEmpty else { return }
        
        do {
            for route in routes {
                let encoded = try JSONEncoder().encode(route)
                try await db.collection(username).document(route.id.string()).setData([routeKey: encoded])
            }
        } catch {
            throw error
        }
    }
    
    func saveUserRoute(route: Route) async throws {
        let username = FirebaseAuthenticator.shared.currentUsername()
        guard !username.isEmpty else { return }
        
        do {
            let encoded = try JSONEncoder().encode(route)
            try await db.collection(username).document(route.id.string()).setData([routeKey: encoded])
        } catch {
            throw error
        }
    }
    
    func deleteUserRoute(route: Route) async throws {
        let username = FirebaseAuthenticator.shared.currentUsername()
        guard !username.isEmpty else { return }
        
        do {
            try await db.collection(username).document(route.id.string()).delete()
        } catch {
            throw error
        }
    }
}

