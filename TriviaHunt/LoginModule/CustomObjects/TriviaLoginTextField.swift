import UIKit

class TriviaLoginTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
//        delegate = self
        textAlignment = .center
        textColor = .white
        returnKeyType = .continue
        layer.borderWidth = 1
        layer.cornerRadius = 10
        autocapitalizationType = .none
        layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func setPlaceholder(_ placeholder: String) {
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor(_colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.6)])
    }
}

extension TriviaLoginTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == " " {
            return false
        }
        
        if textField.layer.name == "usernameTextField" {
            if string.hasSpecial() {
                return false
            }
        }
        
        let currentText = textField.text ?? ""

        guard let stringRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        let limit = 15
        
        return updatedText.count <= limit
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.layer.name == "usernameTextField" {
            textField.resignFirstResponder()
            
        } else if textField.layer.name == "passwordTextField" {
            textField.resignFirstResponder()
//            loginButtonPressed()
        }
        return true
    }
}
