import UIKit

final class CreateRouteViewController: UIViewController {
    let vm: CreateRouteViewModel
    
    init(vm: CreateRouteViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var cancelButton = {
        let button = UIBarButtonItem(
            title: "Cancel",
            image: UIImage(systemName: "cancel"),
            target: self,
            action: #selector(cancelButtonPressed)
        )
        return button
    }()
    
    private lazy var finishRouteButton = {
        let button = UIBarButtonItem(
            title: "Finish",
            image: UIImage(systemName: "Finish"),
            target: self,
            action: #selector(finishRouteButtonPressed)
        )
        return button
    }()
    
    private lazy var table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.reloadData()
    }
    
    private func setUpViews() {
        table.dataSource = self
        table.delegate = self
        view.backgroundColor = .triviaGreen
        
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem = finishRouteButton
        navigationItem.leftBarButtonItem = cancelButton
        
        view.addSubview(table)
        
        NSLayoutConstraint.activate([
            table.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func cancelButtonPressed() {
        let action: (() -> Void) = {
            self.navigationController?.popViewController(animated: true)
        }
        showAlert(
            title: "Are you sure you want to cancel?",
            message: "This route is unsaved, any changes will be lost.",
            action: action
        )
    }
    
    @objc private func finishRouteButtonPressed() {
        let action: (() -> Void) = {
            self.navigationController?.pushViewController(FinishRouteViewController(vm: FinishRouteViewModel(mapPoints: self.vm.points)), animated: true)
        }
        
        for mapPoint in vm.points {
            if mapPoint.isInvalid() {
                showAlert(
                    title: "Something is missing",
                    message: "Add description to all of your points!",
                    action: nil
                )
                return
            }
        }
        
        if vm.points.count < 3 {
            showAlert(
                title: "Add more points",
                message: "There is not enough points to create a route",
                action: nil
            )
            return
        }
        
        showAlert(
            title: "Are you sure you are done?",
            message: "There is no edit button.",
            action: action
        )
    }
    
    private func showAlert(title: String, message: String, action: (() -> Void)?) {
        
        let ac = CustomAlertViewController(title: title, message: message, config: (action == nil) ? .oneButton : .twoButton)
//        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .destructive, handler: action)
//        let cancel = UIAlertAction(title: "cancel", style: .cancel)
//        ac.addAction(cancel)
//        ac.addAction(okAction)
        ac.okButtonAction = action
        present(ac, animated: true)
    }
}

extension CreateRouteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.points.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < vm.points.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
            cell.textLabel?.text = vm.points[indexPath.row].title
            return cell
        } else {
            let cell = AddMapPointCell()
            let closure: ((MapPoint) -> Void) = { point in
                self.vm.points.append(point)
                self.table.reloadData()
            }
            cell.mapPointButtonPressed = {
                let view = AddMapPointViewController()
                view.addMapPoint = closure
                self.navigationController?.pushViewController(view, animated: true)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < vm.points.count {
            navigationController?.pushViewController(EditMapPointDataViewController(vm: EditMapPointDataViewModel(point: vm.points[indexPath.row])), animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
