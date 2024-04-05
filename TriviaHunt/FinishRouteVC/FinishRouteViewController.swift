import UIKit

final class FinishRouteViewController: UIViewController {
    let vm: FinishRouteViewModel
    
    init(vm: FinishRouteViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var saveRouteButton = {
        let button = UIBarButtonItem(
            title: "Finish",
            image: UIImage(systemName: "Finish"),
            target: self,
            action: #selector(saveRouteButtonPressed)
        )
        return button
    }()
    
    private lazy var nameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "name"
        field.textAlignment = .left
        field.layer.borderWidth = 1
        field.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var descriptionTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Description"
        field.textAlignment = .left
        field.layer.borderWidth = 1
        field.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    private func setUpViews() {
        view.backgroundColor = .triviaGreen
        
        navigationItem.rightBarButtonItem = saveRouteButton
        
        view.addSubview(nameTextField)
        view.addSubview(descriptionTextField)
        
        NSLayoutConstraint.activate([
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200),
            nameTextField.widthAnchor.constraint(equalToConstant: 200),
            nameTextField.heightAnchor.constraint(equalToConstant: 100),
            
            descriptionTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200),
            descriptionTextField.widthAnchor.constraint(equalToConstant: 200),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc private func saveRouteButtonPressed() {
        vm.saveRoute(vm.createRoute(name: nameTextField.text!, description: descriptionTextField.text!))
        
        guard let number = navigationController?.viewControllers.count else { return }
        guard let navigationController = navigationController else { return }
        navigationController.popToViewController(navigationController.viewControllers[number - 3], animated: true)
    }
}
