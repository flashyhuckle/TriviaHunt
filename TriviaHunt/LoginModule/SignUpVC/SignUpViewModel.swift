import Foundation
import FirebaseAuth

enum SignUpError {
    case passwordTooShort
    case passwordNoNumbers
    case passwordNoUppercase
    case passwordNoLowercase
    case passwordNoSpecial
    case usernameTaken
}

final class SignUpViewModel {
    var didRegister: (() -> Void)?
    var userSignupError: ((SignUpError) -> Void)?
    
    func signUpPressed(username: String, password: String) {
        let passwordResult = PasswordChecker.check(password)
        
        switch passwordResult {
        case .good:
            print("good password")
        case .tooShort:
            userSignupError?(.passwordTooShort)
            return
        case .noNumbers:
            userSignupError?(.passwordNoNumbers)
            return
        case .noUppercase:
            userSignupError?(.passwordNoUppercase)
            return
        case .noLowercase:
            userSignupError?(.passwordNoLowercase)
            return
        case .noSpecialSign:
            userSignupError?(.passwordNoSpecial)
            return
        }
        
        Task {
            let signUpResult = await FirebaseAuthenticator.shared.signUp(username: username, password: password)
            switch signUpResult {
            case .success:
                DispatchQueue.main.async {
                    self.didRegister?()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.userSignupError?(.usernameTaken)
                }
            }
        }
    }
}
