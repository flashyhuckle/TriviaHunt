import MapKit
import UIKit

final class FromWebRouteListViewController: UIViewController {
    
    private let vm: FromWebRouteListViewModel
    
    init(vm: FromWebRouteListViewModel = FromWebRouteListViewModel()) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var editListButton = {
        let button = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(editListButtonPressed)
        )
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        vm.gotData = {
            self.table.reloadData()
        }
        
        vm.loadData()
    }
    
    private func setUpViews() {
        view.addSubview(table)
        navigationItem.rightBarButtonItem = editListButton
        
        table.dataSource = self
        table.delegate = self
        
        NSLayoutConstraint.activate([
            table.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func editListButtonPressed() {
        vm.editListButtonPressed()
    }
}

extension FromWebRouteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        cell.textLabel?.text = vm.routes[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .clear
        return cell
    }
}

extension FromWebRouteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapData = vm.routes[indexPath.row].route
        if vm.isEditEnabled {
            navigationController?.pushViewController(
                EditRouteListViewController(vm: EditRouteListViewModel()),
                animated: true
            )
        } else {
            navigationController?.pushViewController(
                MapViewController(vm: MapViewModel(mapPoints: mapData)),
                animated: true
            )
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
