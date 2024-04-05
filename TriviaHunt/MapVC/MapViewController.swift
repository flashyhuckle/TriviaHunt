import MapKit
import UIKit

final class MapViewController: UIViewController {
    
    private let vm: MapViewModel
    
    init(vm: MapViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true
        map.userTrackingMode = .follow
        return map
    }()
    
    private lazy var viewListButton = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "list.bullet"),
            style: .plain,
            target: self,
            action: #selector(viewListButtonPressed)
        )
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        setupAnnotations()
        
        vm.refreshAnnotationTitles = {
            self.refreshAnnotationTitles()
        }
        
        vm.viewDidLoad()
    }
    
    private func setUpViews() {
        
        view.backgroundColor = .triviaGreen
        
        navigationItem.rightBarButtonItem = viewListButton
        view.addSubview(mapView)
        mapView.delegate = self
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupAnnotations() {
        let currentAnnotations = mapView.annotations
        mapView.removeAnnotations(currentAnnotations)
        
        for point in vm.getPoints() {
            let annotation = CustomMKPointAnnotation()
            annotation.mapPoint = point
            annotation.coordinate = point.coordinate.locationCoordinate()
            mapView.addAnnotation(annotation)
        }
        refreshAnnotationTitles()
    }
    
    @objc private func viewListButtonPressed() {
        navigationController?.pushViewController(
            PointsListViewController(
                vm: PointsListViewModel(
                    list: vm.getPoints()
                )
            ),
            animated: true
        )
    }
    
    private func refreshAnnotationTitles() {
        let currentAnnotations = mapView.annotations
        for annotation in currentAnnotations {
            if let customAnnotation = annotation as? CustomMKPointAnnotation {
                if let mapPoint = customAnnotation.mapPoint {
                    customAnnotation.title = vm.getTitle(for: mapPoint)
                }
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? CustomMKPointAnnotation else { return }
        guard let point = annotation.mapPoint else { return }
        
        if point.isDiscovered {
            navigationController?.pushViewController(LocationDetailViewController(vm: LocationDetailViewModel(point: point)), animated: true)
        }
        mapView.deselectAnnotation(view.annotation, animated: true)
    }
}
