import Foundation
import FirebaseAuth

final class LoginViewModel {
    var isProcessingLogin = false
    var isUserAuthenticated = false
    
    var userAuthenticated: (() -> Void)?
    var userLoginError: ((Error) -> Void)?
    
    func viewWillAppear() {
        FirebaseAuthenticator.shared.logOut()
    }
    
    func loginButtonPressed(username: String, password: String) {
        if !isProcessingLogin {
            Task {
                self.isProcessingLogin = true
                let loginResult = await FirebaseAuthenticator.shared.logIn(username: username, password: password)
                switch loginResult {
                case .success:
                    DispatchQueue.main.async {
                        self.userAuthenticated?()
                        self.isProcessingLogin = false
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.userLoginError?(error)
                        self.isProcessingLogin = false
                    }
                }
            }
        }
    }
}
