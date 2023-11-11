//
//  DetailPlaceCollectionCell.swift
//  TravioProject
//
//  Created by Burak Özer on 1.11.2023.
//

import UIKit
import SnapKit
import MapKit
class PlaceDetailCollectionCell: UICollectionViewCell,MKMapViewDelegate {
    
    
    private lazy var viewBottom: UIView = {
        let backView = UIView()
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 16
        return backView
    }()

    private lazy var mapView:MKMapView = {
        
        let map = MKMapView()
        map.showsUserLocation = true
        map.clipsToBounds = true
        map.layer.cornerRadius = 16
        map.delegate = self
        return map
    }()
    private lazy var labelCity:UILabelCC = {
        let lbl = UILabelCC()
        lbl.addFont = .poppinsMedium30
        return lbl
        
    }()
    private lazy var labelDate:UILabelCC = {
        let lbl = UILabelCC()
        lbl.addFont = .poppinsRegular14
        return lbl
        
    }()
    private lazy var labelAddedBy:UILabelCC = {
        let lbl = UILabelCC()
        lbl.textColor = UIColor(hexString: "#999999")
        lbl.addFont = .poppinsRegular10
        return lbl
        
    }()
    private lazy var labelDescription:UILabelCC = {
        let lbl = UILabelCC()
        lbl.numberOfLines = 0
        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl.textAlignment = .left
        lbl.addFont = .poppinsRegular14
        return lbl
    }()

    public func getDetailPlaceCollectionCellData(data: PlaceDetailCellInfo){

        let latitude: CLLocationDegrees = data.latitude ?? 0
        let longitude: CLLocationDegrees = data.longitude ?? 0
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = PlaceAnnotation()
        annotation.coordinate = locationCoordinate
//        annotation.customImage = UIImage(named: "mapPin")
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: span)
        mapView.setRegion(region, animated: true)
        self.labelCity.text = data.labelCityText
        self.labelDate.text = data.labelDateText
        self.labelAddedBy.text = data.labelAddedByText
        self.labelDescription.text = data.labelDescriptionText
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
        }
        return annotationView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){
        self.contentView.addSubviews(viewBottom)
        viewBottom.addSubviews(labelCity, labelDate, labelAddedBy, mapView, labelDescription)
        setupLayout()
    }
    
    func setupLayout(){
   
        viewBottom.snp.makeConstraints({ vb in
            vb.top.equalToSuperview()
            vb.leading.equalToSuperview()
            vb.trailing.equalToSuperview()
            vb.bottom.equalToSuperview()
        })
        
        labelCity.snp.makeConstraints({lbl in
            lbl.top.equalToSuperview().offset(20)
            lbl.leading.equalToSuperview().offset(20)
        })
        
        labelDate.snp.makeConstraints({lbl in
            lbl.top.equalTo(labelCity.snp.bottom).offset(7)
            lbl.leading.equalTo(labelCity.snp.leading)
        })
        
        labelAddedBy.snp.makeConstraints({lbl in
            lbl.top.equalTo(labelDate.snp.bottom).offset(5)
            lbl.leading.equalTo(labelCity.snp.leading)
        })
        
        labelDescription.snp.makeConstraints({lbl in
            lbl.top.equalTo(mapView.snp.bottom).offset(20)
            lbl.leading.equalTo(labelCity.snp.leading)
            lbl.trailing.equalToSuperview().offset(-20)
            lbl.bottom.equalToSuperview()
        })
        mapView.snp.makeConstraints({mv in
            mv.top.equalTo(labelAddedBy.snp.bottom).offset(20)
            mv.leading.equalTo(labelCity.snp.leading).offset(-10)
            mv.height.equalTo(230)
            mv.width.equalTo(360)
        })

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}




