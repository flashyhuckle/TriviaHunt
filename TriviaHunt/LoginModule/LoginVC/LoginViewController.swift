import UIKit

final class LoginViewController: UIViewController {
    
    private let vm: LoginViewModel
    
    init(vm: LoginViewModel = LoginViewModel()) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "logo")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
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
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log in", for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("New user? Sign up here", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var devLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("developer log in", for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(devLogIn), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .triviaGreen
        setUpViews()
        
        vm.userAuthenticated = {
            self.login()
        }
        
        vm.userLoginError = { error in
            self.loginAlert(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.viewWillAppear()
        navigationController?.navigationBar.isHidden = true
        clearCredentials()
    }

    private func setUpViews() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        view.addSubview(imageView)
        
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        
        view.addSubview(devLoginButton)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -250),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            usernameTextField.widthAnchor.constraint(equalToConstant: 200),
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.widthAnchor.constraint(equalToConstant: 200),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.widthAnchor.constraint(equalToConstant: 100),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 120),
            
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.widthAnchor.constraint(equalToConstant: 200),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            
            devLoginButton.heightAnchor.constraint(equalToConstant: 50),
            devLoginButton.widthAnchor.constraint(equalToConstant: 200),
            devLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            devLoginButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 50)
        ])
    }
    
    @objc private func loginButtonPressed() {
        vm.loginButtonPressed(username: usernameTextField.text!, password: passwordTextField.text!)
        endEditing()
    }
    
    func progress() {
        let progress = UIProgressView()
        progress.setProgress(1, animated: true)
        progress.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("", for: .normal)
        loginButton.addSubview(progress)
        NSLayoutConstraint.activate([
            progress.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            progress.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
        ])
    }
    
    private func login() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(RouteListViewController(), animated: true)
        self.navigationController?.navigationBar.isHidden = false
        self.clearCredentials()
    }
    
    @objc private func signUpButtonPressed() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc private func devLogIn() {
        vm.loginButtonPressed(username: "flashyhuckle", password: "Test123")
        endEditing()
    }
    
    private func clearCredentials() {
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    private func loginAlert(_ error: Error) {
        self.clearCredentials()
        let alert = CustomAlertViewController(title: "Incorrect login/password.", message: "Have you tried Password2?", config: .oneButton)
        present(alert, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
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
            loginButtonPressed()
        }
        return true
    }
}

//Keyboard methods
extension LoginViewController {
    private func endEditing() {
        usernameTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        endEditing()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= ( keyboardSize.height / 4 )
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
