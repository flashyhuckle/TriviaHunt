import Foundation

final class UserRouteListViewModel {
    var routes = [Route]()
    
    var isEditEnabled = false
    
    var didUpdateRoutes: (() -> Void)?
    
    func viewDidLoad() {
//        loadData()
    }
    
    func viewWillAppear() {
//        routes = Storage.routes
//        didUpdateRoutes?()
//        if !routes.isEmpty {
//            saveData()
//        }
        loadData()
    }
    
    private func saveData() {
        Task {
            try? await FirebaseStorageHandler.shared.saveUserStorage(routes: routes)
        }
    }
    
    private func loadData() {
        Task {
            guard let routes = try? await FirebaseStorageHandler.shared.loadUserStorage() else { return }
//            Storage.routes = routes
            self.routes = routes
            DispatchQueue.main.async {
                self.didUpdateRoutes?()
            }
        }
    }
}
