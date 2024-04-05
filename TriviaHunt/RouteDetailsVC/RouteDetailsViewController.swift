import MapKit
import UIKit

enum FromWhere {
    case user
    case community
}

final class RouteDetailsViewController: UIViewController {
    let vm: RouteDetailsViewModel
    let fromWhere: FromWhere
    
    init(
        vm: RouteDetailsViewModel,
        fromWhere: FromWhere
    ) {
        self.vm = vm
        self.fromWhere = fromWhere
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let creatorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true
        map.layer.cornerRadius = 10
        map.userTrackingMode = .follow
        return map
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("button", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareWithCommunityButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Share with community", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(shareWithCommunityButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        setupLabels()
        setupAnnotations()
    }
    
    private func setUpViews() {
        view.backgroundColor = .triviaGreen
        title = vm.route.name
        
        view.addSubview(creatorLabel)
        view.addSubview(countLabel)
        view.addSubview(descriptionLabel)
        
        view.addSubview(mapView)
        
        view.addSubview(button)
        
        switch fromWhere {
        case .user:
            button.setTitle("Do the route", for: .normal)
        case .community:
            button.setTitle("Add route", for: .normal)
        }
        
        var constraintArray = [
            creatorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            creatorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            creatorLabel.heightAnchor.constraint(equalToConstant: 20),
            creatorLabel.widthAnchor.constraint(equalToConstant: 300),
            
            countLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countLabel.topAnchor.constraint(equalTo: creatorLabel.bottomAnchor, constant: 10),
            countLabel.heightAnchor.constraint(equalToConstant: 20),
            countLabel.widthAnchor.constraint(equalToConstant: 300),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 10),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 100),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 300),
            
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 300),
            mapView.widthAnchor.constraint(equalToConstant: 300),
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 100),
        ]
        
        if fromWhere == .user {
            view.addSubview(deleteButton)
            view.addSubview(shareWithCommunityButton)
            
            constraintArray += [
                deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                deleteButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 300),
                deleteButton.heightAnchor.constraint(equalToConstant: 50),
                deleteButton.widthAnchor.constraint(equalToConstant: 100),
                
                shareWithCommunityButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                shareWithCommunityButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 400),
                shareWithCommunityButton.heightAnchor.constraint(equalToConstant: 50),
                shareWithCommunityButton.widthAnchor.constraint(equalToConstant: 100),
            ]
        }
        
        NSLayoutConstraint.activate(constraintArray)
    }
    
    private func setupLabels() {
        creatorLabel.text = vm.creatorLabelText()
        countLabel.text = vm.countLabelText()
        descriptionLabel.text = vm.descriptionLabelText()
    }
    
    private func setupAnnotations() {
        for point in vm.route.mapPoints {
            let annotation = CustomMKPointAnnotation()
            annotation.mapPoint = point
            annotation.coordinate = point.coordinate.locationCoordinate()
            mapView.addAnnotation(annotation)
        }
        mapView.region = vm.route.mapRegion
        
//        mapView.region = MKCoordinateRegion(
//            center: vm.route.mapPoints[0].coordinate.locationCoordinate(),
//            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//        )
        
    }
    
    @objc func buttonPressed() {
        switch fromWhere {
        case .user:
            navigationController?.pushViewController(MapViewController(vm: MapViewModel(route: vm.route)), animated: true)
        case .community:
            vm.addToUserRoutesPressed()
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func deleteButtonPressed() {
        if fromWhere == .user {
            vm.deleteFromUserRoutesPressed()
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func shareWithCommunityButtonPressed() {
        if fromWhere == .user {
            vm.shareWithCommunityPressed()
        }
    }
}
