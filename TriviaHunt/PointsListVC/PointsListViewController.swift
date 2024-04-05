import UIKit

final class PointsListViewController: UIViewController {
    
    let vm: PointsListViewModel
    
    init(vm: PointsListViewModel) {
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
    }
    
    private func setUpViews() {
        view.backgroundColor = .triviaGreen
        view.addSubview(table)
        
        table.delegate = self
        table.dataSource = self
        
        NSLayoutConstraint.activate([
            table.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
}

extension PointsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.getListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        cell.accessoryType = .none
        cell.textLabel?.text = vm.getPointTitle(number: indexPath.row)
        cell.backgroundColor = .clear
        if vm.isDiscovered(number: indexPath.row) {
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
}

extension PointsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if vm.isDiscovered(number: indexPath.row) {
            navigationController?.pushViewController(LocationDetailViewController(vm: LocationDetailViewModel(point: vm.getListItem(number: indexPath.row))), animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
