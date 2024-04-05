import UIKit

final class EditMapPointDataViewController: UIViewController {
    
    let vm: EditMapPointDataViewModel
    
    init(vm: EditMapPointDataViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Title"
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
    
    private lazy var cancelButton = {
        let button = UIBarButtonItem(
            title: "Cancel",
            image: UIImage(systemName: "cancel"),
            target: self,
            action: #selector(cancelButtonPressed)
        )
        return button
    }()
    
    private lazy var saveMapPointButton = {
        let button = UIBarButtonItem(
            title: "Save",
            image: UIImage(systemName: "save"),
            target: self,
            action: #selector(saveMapPointButtonPressed)
        )
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    private func setUpViews() {
        view.backgroundColor = .triviaGreen
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem = saveMapPointButton
        navigationItem.leftBarButtonItem = cancelButton
        
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextField)
        
        NSLayoutConstraint.activate([
            titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200),
            titleTextField.widthAnchor.constraint(equalToConstant: 200),
            titleTextField.heightAnchor.constraint(equalToConstant: 100),
            
            descriptionTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200),
            descriptionTextField.widthAnchor.constraint(equalToConstant: 200),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        titleTextField.text = vm.point.title
        descriptionTextField.text = vm.point.description
    }
    
    @objc private func cancelButtonPressed() {
        showAlert(title: "Are you sure you want to cancel?", message: "Any changes will be lost.")
    }
    
    @objc private func saveMapPointButtonPressed() {
        vm.overrideMapPointData(title: titleTextField.text!, description: descriptionTextField.text!)
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive) { action in
            self.navigationController?.popViewController(animated: true)
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        ac.addAction(cancel)
        ac.addAction(okAction)
        present(ac, animated: true)
    }
}
