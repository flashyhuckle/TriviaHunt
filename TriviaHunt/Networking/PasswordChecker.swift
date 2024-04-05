import Foundation

enum PasswordCheckResult {
    case good
    case tooShort
    case noNumbers
    case noUppercase
    case noLowercase
    case noSpecialSign
}

final class PasswordChecker {
    static func check(_ password: String) -> PasswordCheckResult {
        if password.count < 5 {
            return .tooShort
        }
        
        if !password.containsNumber() {
            return .noNumbers
        }
        
        if !password.hasUppercased() {
            return .noUppercase
        }
        
        if !password.hasLowercased() {
            return .noLowercase
        }
        
        if !password.hasSpecial() {
            return .noSpecialSign
        }
        
        return .good
    }
}
