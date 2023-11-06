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

protocol DataTransferDetailPlaceVCToMapVC:AnyObject{
    func getAnnotationInfo(isSaved:Bool, titlePlace:String, description:String)
}

class MapVC: UIViewController, DataTransferDetailPlaceVCToMapVC {
    
    //MARK: -- Properties
    
    lazy var vm: MapVM = {
        
        return MapVM()
    }()
    
    private var places:[PlaceAnnotation] = []
    
    private var place:PlaceAnnotation?
 
    var locationManager:CLLocationManager?
    
    //MARK: -- Views
    
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
        setupViews()
    }
    
    //MARK: -- Component Actions
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        
        guard let locationManager = locationManager,
              let userLocation = locationManager.location else{
            return
        }
        self.place = PlaceAnnotation(mapItem: MKMapItem(), isSelected: false)
        if gesture.state == .began {
            
            let touchPoint = gesture.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            place!.coordinate = coordinate
            mapView.addAnnotation(place!)
            let placesTVC = DetailPlaceVC()
            placesTVC.delegate = self
            placesTVC.modalPresentationStyle = .pageSheet
            if let sheet = placesTVC.sheetPresentationController{
                sheet.prefersGrabberVisible = true
                sheet.detents = [.medium(), .large()]
                present(placesTVC, animated: true)
            }
        }
    }
        
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)
    }

    func getAnnotationInfo(isSaved: Bool, titlePlace: String, description: String) {
        
        self.place?.isSaved = isSaved
        self.place?.titlePlace = titlePlace
        self.place?.visitDescription = description
        places.append(place!)
    }

    //MARK: -- Private Methods
    private func checkLocationAuthorization(){
        guard let locationManager = locationManager,
              let location = locationManager.location else{
            return
        }
        switch locationManager.authorizationStatus{
        case .authorizedWhenInUse, .authorizedAlways:
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
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

//    guard let selectedAnnotation = annotation as? PlaceAnnotation else {return}
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
            
            // Özel pin resmi ve boyutu burada ayarlanabilir
            let pinImage = UIImage(named: "mapPin")?.resize(targetSize: CGSize(width: 50, height: 50))
            annotationView.image = pinImage
            // Eğer annotasyonun başlık ve açıklama gibi bilgileri varsa, bunları da göstermek isterseniz burada ayarlayabilirsiniz.
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.text = "\(annotation.title ?? "")\n\(annotation.subtitle ?? "")"
            annotationView.detailCalloutAccessoryView = detailLabel
        }
        return annotationView
    }
}

extension MapVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

extension MapVC:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (collectionView.frame.width-10)*0.8, height: (collectionView.frame.height-10) )
        return CGSize(width: 309, height: 180 )
    }
}

extension MapVC:UICollectionViewDataSource {
 

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCellMap", for: indexPath) as! MapImageCollectionCell
        cell.imagePlace.image = UIImage(named: "placeImage")
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        return cell
    }
}

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        let rect = CGRect(origin: .zero, size: newSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
}
