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
        
        initView()
        
        initVM()
        
    }
    
    
    func initView(){
        self.navigationController?.navigationBar.isHidden = true
        setupViews()
    }

    func initVM(){
        
        vm.initFetch()
    }
    
    func addPins(){
        vm.getData?.data.places.forEach({ place in
            let latitude = place.latitude
            let longitude = place.longitude
            
            let placeTitle = place.title
 
            let mapItem = MKMapItem()
            let pin = PlaceAnnotation(mapItem: mapItem)
            pin.coordinate = CLLocationCoordinate2D(
                latitude: latitude, longitude: longitude)
            pin.title = placeTitle
            
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
        
        addPins()
        reloadCollectionView()
        
//        let allAnnotations = mapView.annotations
//        mapView.removeAnnotations(allAnnotations)
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
        guard let selectedAnnotation = annotation as? PlaceAnnotation else {return}
        
//        guard let firstItem = vm.getData?.data.places.first else {
//            return
//        }
        guard let places = vm.getData?.data.places else{

            return
        }
        places.enumerated().forEach({ placeIndex, place in
         
            if place.latitude == selectedAnnotation.coordinate.latitude && place.longitude == selectedAnnotation.coordinate.longitude {
                if placeIndex < places.count, placeIndex > 0 {
                    let temp = self.vm.places[0]
                    self.vm.places[0] = self.vm.places[placeIndex]
                    self.vm.places[placeIndex]  = temp
                }
            }
        })

        var selectedItemIndex = vm.getData?.data.places.filter({place in
 
           place.title == selectedAnnotation.titlePlace
        })
        reloadCollectionView()
    
//    let vc = PlaceDetailPageVC()
//    vc.placeInfo?.mapItem = selectedAnnotation.mapItem
//    vc.placeInfo?.visitDescription = selectedAnnotation.visitDescription
//    vc.placeInfo?.titlePlace = selectedAnnotation.titlePlace
//    vc.placeInfo?.addedBy = selectedAnnotation.addedBy
//    vc.placeInfo?.addedDate = selectedAnnotation.addedDate
//    self.navigationController?.pushViewController(vc, animated: true)
    
    
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
            
            let pinImage = UIImage(named: "mapPin")?.resize(targetSize: CGSize(width: 50, height: 50))
            annotationView.image = pinImage

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
        print(locations)
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

//            let vc = PlaceDetailPageVC()
//        
//            vc.placeInfo?.mapItem = selectedAnnotation.mapItem
//            vc.placeInfo?.visitDescription = selectedAnnotation.visitDescription
//            vc.placeInfo?.titlePlace = selectedAnnotation.titlePlace
//            vc.placeInfo?.addedBy = selectedAnnotation.addedBy
//            vc.placeInfo?.addedDate = selectedAnnotation.addedDate
//        
//            self.navigationController?.pushViewController(vc, animated: true)

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
        cell.labelPlace.text = vm.places[indexPath.row].place
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
