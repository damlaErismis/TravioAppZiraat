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
    
    func didDismissPlaceDetailVC() {
        
        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)
        initVM()
        
    }
    private lazy var mapView:MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.delegate = self
        return map
    }()
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
        cv.backgroundColor = .clear
        cv.register(MapImageCollectionCell.self, forCellWithReuseIdentifier: "collectionCellMap")
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
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        mapView.addGestureRecognizer(longPressGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        initView()
        initVM()
        
    }
    
    func initView(){
        self.navigationController?.navigationBar.isHidden = true
        setupViews()
    }

    func initVM(){
        
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
            
            let pin = PlaceAnnotation()
            pin.coordinate = CLLocationCoordinate2D(
                latitude: latitude, longitude: longitude)
            pin.title = placeTitle
            pin.placeId = placeId
            
            pin.visitDescription = place.description
            pin.image = place.cover_image_url.absoluteString
            pin.addedBy = place.creator
            pin.addedDate = place.updated_at
            mapView.addAnnotation(pin)
        })
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
            let place = PlaceAnnotation()
            place.coordinate = coordinate
            mapView.addAnnotation(place)
            let placesTVC = AddNewPlaceVC()
            placesTVC.delegate = self
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    return
                }
                if let placemark = placemarks?.first {
                    if let city = placemark.locality, let country = placemark.country {
                        let place = "\(city), \(country)"
                        placesTVC.selectedPlace.coordinate = coordinate
                        placesTVC.labelCountryCity.text = place
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
        
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        
//        let allAnnotations = mapView.annotations
//        mapView.removeAnnotations(allAnnotations)
    }

    //MARK: -- Private Methods
    private func checkLocationAuthorization(){
        
        guard let locationManager = locationManager,
              let location = locationManager.location else{
            return
        }
        switch locationManager.authorizationStatus{
        case .authorizedWhenInUse, .authorizedAlways:
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
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
        self.view.addSubviews(mapView, collectionView)
        setupLayout()
    }
    
    func setupLayout() {
        // Add here the setup for layout
        mapView.snp.makeConstraints({mv in
            mv.top.equalToSuperview()
            mv.leading.equalToSuperview()
            mv.trailing.equalToSuperview()
            mv.bottom.equalToSuperview()
        })
        collectionView.snp.makeConstraints({cv in
            cv.bottom.equalToSuperview().offset(-60)
            cv.leading.equalToSuperview()
            cv.trailing.equalToSuperview()
            cv.height.equalTo(200)
        })
    }
}

extension MapVC: MKMapViewDelegate {
  
func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    
//    guard let unSelectedAnnotation = view.annotation as? PlaceAnnotation else {return}
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        
        guard let selectedAnnotation = annotation as? PlaceAnnotation else { return }
        
        
        guard let selectedID = selectedAnnotation.placeId else {return}
        let vc = PlaceDetailVC()
 
        
        vc.selectedID = selectedID
        self.navigationController?.pushViewController(vc, animated: true)
    }
func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? PlaceAnnotation else {
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

            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.text = "\(annotation.titlePlace ?? "")"
            annotationView.detailCalloutAccessoryView = detailLabel
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
        
        let selectedPlace = vm.places[indexPath.row]
        let selectedCoordinate = CLLocationCoordinate2D(latitude: selectedPlace.latitude, longitude: selectedPlace.longitude)
        let region = MKCoordinateRegion(center: selectedCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 310, height: 180 )
    }
}
extension MapVC:UICollectionViewDataSource {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.places.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCellMap", for: indexPath) as! MapImageCollectionCell
        
        
       let url = vm.places[indexPath.row].cover_image_url
        cell.imagePlace.kf.setImage(with: url)
        
        cell.labelCity.text = vm.places[indexPath.row].place
        cell.labelPlace.text = vm.places[indexPath.row].title
        return cell
    }
}

