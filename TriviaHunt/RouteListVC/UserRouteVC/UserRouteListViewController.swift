import UIKit

final class UserRouteListViewController: UIViewController {
    private let vm: UserRouteListViewModel
    
    init(vm: UserRouteListViewModel = UserRouteListViewModel()) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        
        vm.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        vm.didUpdateRoutes = {
            self.table.reloadData()
        }
        
        vm.viewWillAppear()
    }
    
    private func setUpViews() {
        view.backgroundColor = .triviaGreen
        view.addSubview(table)
        
        table.dataSource = self
        table.delegate = self
        
        table.separatorColor = .white
        table.backgroundColor = .triviaGreen
        
        NSLayoutConstraint.activate([
            table.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension UserRouteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        cell.textLabel?.text = vm.routes[indexPath.row].name
        cell.textLabel?.textColor = .white
        
        cell.tintColor = .white
        
        if let chevron = UIImage(systemName: "chevron.right") {
            cell.accessoryView = UIImageView(image: chevron)
        } else {
            cell.accessoryType = .disclosureIndicator
        }
        
        cell.backgroundColor = .clear
        return cell
    }
}

extension UserRouteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let route = vm.routes[indexPath.row]
        navigationController?.pushViewController(
            RouteDetailsViewController(vm: RouteDetailsViewModel(route: route), fromWhere: .user),
            animated: true
        )
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
