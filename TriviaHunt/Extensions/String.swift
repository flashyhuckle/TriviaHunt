import Foundation

extension String {
    func makeEmail() -> Self {
        self + "@triviatreasurehuntappfakeemail.com"
    }
    
    func makeLogin() -> Self {
        guard let atIndex = self.firstIndex(of: "@") else { return self }
        let login = String(self[..<atIndex])
        return login
    }
    
    func containsNumber() -> Bool {
        let numberRegEx  = ".*[0-9]+.*"
        let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluate(with: self)

        return containsNumber
    }
    
    func hasUppercased() -> Bool {
        for c in self {
            if c.isUppercase {
                return true
            }
        }
        return false
    }
    
    func hasLowercased() -> Bool {
        for c in self {
            if c.isLowercase {
                return true
            }
        }
        return false
    }
    
    func hasSpecial() -> Bool {
        let characterSet = NSCharacterSet.alphanumerics.inverted
        if self.rangeOfCharacter(from: characterSet) != nil {
            return true
        }
        return false
    }
}
