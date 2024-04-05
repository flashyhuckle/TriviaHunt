import UIKit

final class RouteListViewController: UITabBarController {
    
    
    private var vc: [UIViewController] = [UserRouteListViewController(), CommunityRouteListViewController()]
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var createRouteButton = {
        let button = UIBarButtonItem(
            title: "Create",
            image: UIImage(systemName: "plus"),
            target: self,
            action: #selector(addRouteButtonPressed)
        )
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setUpTabBarVC()
    }
    
    private func setUpTabBarVC() {
        navigationItem.rightBarButtonItem = createRouteButton
        
        let icons = [
            UITabBarItem(title: "User", image: UIImage(systemName: "person.crop.circle"), selectedImage: UIImage(systemName: "person.crop.circle.fill")),
            UITabBarItem(title: "Community", image: UIImage(systemName: "person.3"), selectedImage: UIImage(systemName: "person.3.fill"))
        ]
        
        for (number, view) in vc.enumerated() {
            view.tabBarItem.title = icons[number].title
            view.tabBarItem.selectedImage = icons[number].selectedImage?.withTintColor(.white, renderingMode: .alwaysOriginal)
            view.tabBarItem.image = icons[number].image?.withTintColor(.black, renderingMode: .alwaysOriginal)
        }
        self.viewControllers = vc
    }
    
    @objc private func addRouteButtonPressed() {
        navigationController?.pushViewController(CreateRouteViewController(vm: CreateRouteViewModel()), animated: true)
    }
}

extension RouteListViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
