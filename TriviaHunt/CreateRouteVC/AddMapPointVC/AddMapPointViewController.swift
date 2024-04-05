import MapKit
import UIKit

final class AddMapPointViewController: UIViewController {
    
    let vm: AddMapPointViewModel
    
    init(vm: AddMapPointViewModel = AddMapPointViewModel()) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var addMapPoint: ((MapPoint) -> Void)?
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true
        map.userTrackingMode = .follow
        
        return map
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
            title: "Add point",
            image: UIImage(systemName: "save"),
            target: self,
            action: #selector(saveMapPointButtonPressed)
        )
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpGestureRecognizer()
        
    }
    
    private func setUpViews() {
        view.backgroundColor = .triviaGreen
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem = saveMapPointButton
        navigationItem.leftBarButtonItem = cancelButton
        
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        mapView.addGestureRecognizer(recognizer)
    }
    
    @objc private func cancelButtonPressed() {
        showAlert(
            title: "Are you sure you want to cancel?",
            message: "Any changes will be lost."
        ) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func saveMapPointButtonPressed() {
        guard let coordinate = vm.coordinate else {
            showAlert(
                title: "Something went wrong",
                message: "Have you chosen a point?",
                action: nil
            )
            return
        }
        showAlert(
            title: "Are you sure?",
            message: "Have you chosen correct point?"
        ) {
            self.addMapPoint?(MapPoint(title: (String(format: "%.2f", coordinate.latitude) + ", " + String(format: "%.2f", coordinate.longitude)), description: "", coordinate: coordinate))
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    private func showAlert(title: String, message: String, action: (() -> Void)?) {
        let ac = CustomAlertViewController(title: title, message: message, config: (action == nil) ? .oneButton : .twoButton)
        ac.okButtonAction = action
//        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .destructive) { action in
//            self.navigationController?.popViewController(animated: true)
//        }
//        let cancel = UIAlertAction(title: "cancel", style: .cancel)
//        ac.addAction(cancel)
//        ac.addAction(okAction)
        present(ac, animated: true)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        
        let touch = sender.location(in: mapView)
        let coordinate = mapView.convert(touch, toCoordinateFrom: mapView)
        
        vm.coordinate = Coordinate(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        mapView.addAnnotation(annotation)
    }
}

