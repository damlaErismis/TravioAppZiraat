//
//  
//  MapVC.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 27.10.2023.
//
//


import UIKit
import SnapKit
import MapKit
import Kingfisher

protocol ViewControllerDelegate: AnyObject {
    func didDismissPlaceDetailVC()
}

class MapVC: UIViewController, ViewControllerDelegate{
    
    //MARK: -- Properties
    
    lazy var vm: MapVM = {
        
        return MapVM()
    }()
    var locationManager:CLLocationManager?

    //MARK: -- Views
    private lazy var mapView:MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.delegate = self
        return map
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .black
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
        cv.backgroundColor = .clear
        cv.register(MapImageCollectionCell.self, forCellWithReuseIdentifier: "collectionCellMap")
        cv.layer.addShadow(color: .black, opacity: 0.2, offset: CGSize(width: 5, height: 5), radius: 7)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    //MARK: -- Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
        locationManager?.requestAlwaysAuthorization()
        
        let authorizationStatus = locationManager?.authorizationStatus
        if authorizationStatus == .notDetermined {
            locationManager?.requestWhenInUseAuthorization()
        }
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        mapView.addGestureRecognizer(longPressGesture)
        initView()
        initVM()
    }
    
    func initView(){
        self.navigationController?.navigationBar.isHidden = true
        setupViews()
    }
    
    func initVM(){
        vm.updateLoadingStatus = { [weak self] (staus) in
            DispatchQueue.main.async {
                if staus {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
        vm.initFetch()
        vm.addPins = {
            self.addPins()
            self.reloadCollectionView()
        }
    }
    func addPins(){
        vm.getData?.data.places.forEach({ place in
            let latitude = place.latitude
            let longitude = place.longitude
            let placeTitle = place.title
            let placeId = place.id
            let pin = CustomAnnotation()
            pin.coordinate = CLLocationCoordinate2D(
                latitude: latitude, longitude: longitude)
            pin.placeId = placeId
            pin.visitDescription = place.description
            pin.image = place.cover_image_url
            pin.addedBy = place.creator
            pin.addedDate = place.updated_at
            mapView.addAnnotation(pin)
        })
    }
    
    func didDismissPlaceDetailVC() {
        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)
        initVM()
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began {
            let touchPoint = gesture.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let geocoder = CLGeocoder()
            let place = CustomAnnotation()
            place.coordinate = coordinate
            mapView.addAnnotation(place)
            let placesTVC = AddNewPlaceVC()
            placesTVC.delegate = self
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if error != nil {
                    return
                }
                if let placemark = placemarks?.first {
                    if let city = placemark.locality, let country = placemark.country {
                        let place = "\(city), \(country)"
                        placesTVC.selectedPlace.coordinate = coordinate
                        placesTVC.viewCountryCity.textField.text = place
                    }
                }
            }
            placesTVC.modalPresentationStyle = .pageSheet
            if let sheet = placesTVC.sheetPresentationController{
                sheet.prefersGrabberVisible = true
                sheet.detents = [.large(), .large()]
                present(placesTVC, animated: true)
            }
        }
    }
    
    
    //MARK: -- Private Methods
    private func checkLocationAuthorization(){
        
        guard let locationManager = locationManager,
              let location = locationManager.location else{
            return
        }
        switch locationManager.authorizationStatus{
        case .authorizedWhenInUse, .authorizedAlways:
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
            mapView.setRegion(region, animated: true)
        case .denied:
            print("location is denied")
        case .notDetermined, .restricted:
            print("location is not determined or restricted")
        @unknown default:
            print("Unknown error")
        }
    }
    
    //MARK: -- UI Methods
    func setupViews() {
        self.view.addSubviews(mapView, collectionView, activityIndicator)
        setupLayout()
    }
    
    func setupLayout() {
        activityIndicator.snp.makeConstraints({ai in
            ai.edges.equalToSuperview()
        })
        
        mapView.snp.makeConstraints({mv in
            mv.edges.equalToSuperview()
        })
        
        collectionView.snp.makeConstraints({cv in
            cv.leading.trailing.equalToSuperview()
            cv.height.equalToSuperview().multipliedBy(0.26)
            cv.bottom.equalToSuperview().offset(-30)
        })
    }
}

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard let selectedAnnotation = annotation as? CustomAnnotation else {return}
        let location = CLLocation(latitude: selectedAnnotation.coordinate.latitude, longitude: selectedAnnotation.coordinate.longitude)
        let zoomRadius: CLLocationDistance = 5000
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: zoomRadius, longitudinalMeters: zoomRadius)
        let places = vm.places
        let index = places.firstIndex(where: { $0.latitude == selectedAnnotation.coordinate.latitude && $0.longitude == selectedAnnotation.coordinate.longitude })
        let indexPath = IndexPath(item: index!, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomAnnotation else {
            return nil
        }
        let identifier = "customPin"
        var annotationView: MKAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView = dequeuedView
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
            let pinImage = UIImage(named: "mapPin")
            annotationView.image = pinImage
        }
        return annotationView
    }
}

extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        checkLocationAuthorization()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

extension MapVC:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedID = vm.places[indexPath.row].id
        let vc = PlaceDetailVC()
        vc.selectedID = selectedID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.7, height: collectionView.frame.height - 30)
    }
}

extension MapVC:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.places.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCellMap", for: indexPath) as! MapImageCollectionCell
        if let url = URL(string: vm.places[indexPath.row].cover_image_url) {
            cell.imagePlace.kf.setImage(with: url)
        }
        cell.labelCity.text = vm.places[indexPath.row].place
        cell.labelPlace.text = vm.places[indexPath.row].title
        cell.roundAllCorners(radius: 20)
        return cell
    }
}

