import FirebaseAuth
import Foundation

enum LogInResult {
    case success
    case failure(error: Error)
}

enum RegisterResult {
    case success
    case failure(error: Error)
}

enum AuthError: Error {
    case networkOff
}

final class FirebaseAuthenticator {
    static let shared = FirebaseAuthenticator()
    
    private let monitor: PathMonitorType
    
    private init() {
        self.monitor = PathMonitor()
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
    
    func logIn(username: String, password: String) async -> LogInResult {
        return await withCheckedContinuation { continuation in
            if self.monitor.isNetworkOn {
                Auth.auth().signIn(withEmail: username.makeEmail(), password: password) { result, error in
                    if let error = error {
                        continuation.resume(returning: LogInResult.failure(error: error))
                    } else {
                        continuation.resume(returning: LogInResult.success)
                    }
                }
            } else {
                continuation.resume(returning: LogInResult.failure(error: AuthError.networkOff))
            }
        }
    }
    
    func signUp(username: String, password: String) async -> RegisterResult {
        return await withCheckedContinuation { continuation in
            Auth.auth().createUser(withEmail: username.makeEmail(), password: password) { result, error in
                
                if let error = error {
                    continuation.resume(returning: RegisterResult.failure(error: error))
                } else {
                    continuation.resume(returning: RegisterResult.success)
                }
            }
        }
    }
    
    func currentUsername() -> String {
        Auth.auth().currentUser?.email?.makeLogin() ?? ""
    }
}


