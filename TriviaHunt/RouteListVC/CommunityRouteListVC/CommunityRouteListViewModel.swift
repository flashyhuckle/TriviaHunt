import MapKit
import Firebase

final class CommunityRouteListViewModel {
    
    var routes = [Route]()
    
    var gotData: (() -> Void)?
    
    func loadData() {
//        let db = Firestore.firestore()
        
        Task {
            guard let routes = try? await FirebaseStorageHandler.shared.loadCommunityStorage() else { return }
            self.routes = routes
            DispatchQueue.main.async {
                self.gotData?()
            }
        }
    }
}
