import UIKit

final class SignUpViewController: UIViewController {
    
    private let vm: SignUpViewModel
    
    init(vm: SignUpViewModel = SignUpViewModel()) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var usernameTextField: UITextField = {
        let field = TriviaLoginTextField()
        field.setPlaceholder("username")
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var passwordTextField: UITextField = {
        let field = TriviaLoginTextField()
        field.setPlaceholder("Password1")
        field.isSecureTextEntry = true
        field.returnKeyType = .go
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .triviaGreen
        setUpViews()
        
        vm.didRegister = {
            self.navigationController?.popViewController(animated: true)
        }
        
        vm.userSignupError = { error in
            self.showSignupAlert(with: error)
        }
    }
    
    private func setUpViews() {
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            usernameTextField.widthAnchor.constraint(equalToConstant: 200),
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -250),
            
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.widthAnchor.constraint(equalToConstant: 200),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150),
            
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.widthAnchor.constraint(equalToConstant: 100),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func signUpButtonPressed() {
        vm.signUpPressed(username: usernameTextField.text!, password: passwordTextField.text!)
    }
    
    private func showSignupAlert(with error: SignUpError) {
        let ac = CustomAlertViewController(title: "Error signing up", message: "something went wrong")
        switch error {
        case .passwordTooShort:
            ac.message = "Password needs to be 5 characters or longer"
        case .passwordNoNumbers:
            ac.message = "Password needs to have at least 1 number"
        case .passwordNoUppercase:
            ac.message = "Password needs to have at least 1 uppercase letter"
        case .passwordNoLowercase:
            ac.message = "Password needs to have at least 1 lowercase letter"
        case .passwordNoSpecial:
            ac.message = "Password needs to have at least 1 special character"
        case .usernameTaken:
            ac.message = "The username you chose is taken"
        }
        present(ac, animated: true)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == " " {
            return false
        }
        
        if textField == usernameTextField {
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
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            signUpButtonPressed()
        }
        return true
    }
}

//Keyboard methods
extension SignUpViewController {
    private func endEditing() {
        usernameTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        endEditing()
    }
}
