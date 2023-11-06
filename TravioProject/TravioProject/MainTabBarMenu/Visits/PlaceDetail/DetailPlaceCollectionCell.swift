//
//  DetailPlaceCollectionCell.swift
//  TravioProject
//
//  Created by Burak Özer on 1.11.2023.
//

import UIKit
import SnapKit
import MapKit
class DetailPlaceCollectionCell: UICollectionViewCell {
    
    
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
        return map
    }()
    private lazy var labelCity:UILabelCC = {
        let lbl = UILabelCC()
        lbl.text = "İstanbul"
        lbl.addFont = .poppinsMedium30
        return lbl
        
    }()
    private lazy var labelDate:UILabelCC = {
        let lbl = UILabelCC()
        lbl.text = "22-12-2023"
        lbl.addFont = .poppinsRegular14
        return lbl
        
    }()
    private lazy var labelAddedBy:UILabelCC = {
        let lbl = UILabelCC()
        lbl.text = "added by @burakozer"
        lbl.textColor = UIColor(hexString: "#999999")
        lbl.addFont = .poppinsRegular10
        return lbl
        
    }()
    private lazy var labelDescription:UILabelCC = {
        let lbl = UILabelCC()
        lbl.numberOfLines = 0
        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl.textAlignment = .left
        lbl.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        
      lbl.addFont = .poppinsRegular14
        return lbl
        
    }()

//    public func getDetailPlaceCollectionCellData(labelCityText:String, labelDateText:String, labelAddedByText:String, labelDescriptionText:String){
////        self.mapView = mapView
//        self.labelCity.text = labelCityText
//        self.labelDate.text = labelDateText
//        self.labelAddedBy.text = labelAddedByText
//        self.labelDescription.text = labelDescriptionText
//    }
    
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

