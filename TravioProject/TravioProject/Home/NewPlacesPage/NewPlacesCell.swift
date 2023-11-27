//
//  NewPlacesCell.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 6.11.2023.
//

import Kingfisher
import SnapKit
import TinyConstraints
import UIKit

class NewPlacesCell:UICollectionViewCell {
    
    lazy var imgNewPlace:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var labelPlace:UILabelCC = {
       let lbl = UILabelCC()
       lbl.textColor = .darkGrayText
       lbl.addFont = .poppinsSemiBold24
       return lbl
   }()
   
   private lazy var labelCity:UILabelCC = {
       let lbl = UILabelCC()
       lbl.addFont = .poppinsLight14
       lbl.textColor = .darkGrayText
       return lbl
   }()
    
    private lazy var imageVector:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "blackPin")
        return img
    }()
    private lazy var containerView:UIView = {
        let container = UIView()
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 16
        container.backgroundColor = .white
        return container
    }()
    public func configureNewPlaces(with object:Place){
        if let imageURL = URL(string: object.cover_image_url) {
            imgNewPlace.kf.setImage(with: imageURL)
        }
        labelPlace.text = object.title
        labelCity.text = object.place
    }
    override func layoutSubviews() {
        
        imgNewPlace.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    private func setupViews() {
        
        self.backgroundColor = .clear
        self.contentView.addSubview(containerView)
        self.contentView.backgroundColor = .clear
        self.contentView.addShadow(shadowColor: .black, offsetX: 0, offsetY: 0, shadowOpacity: 0.07, shadowRadius: 4)
        containerView.addSubviews(imgNewPlace, labelPlace,imageVector,labelCity)
        setupLayout()
    }
    private func setupLayout() {

        containerView.snp.makeConstraints({ container in
            container.top.equalToSuperview().offset(6)
            container.leading.equalToSuperview().offset(16)
            container.trailing.equalToSuperview().offset(-16)
            container.bottom.equalToSuperview().offset(-6)
        })
        
        imgNewPlace.snp.makeConstraints({ image in
            image.leading.equalToSuperview()
            image.top.equalToSuperview()
            image.bottom.equalToSuperview()
            image.width.equalTo(90)
        })
        
        labelPlace.snp.makeConstraints({ label in
            label.leading.equalTo(imgNewPlace.snp.trailing).offset(20)
            label.top.equalTo(imgNewPlace).offset(10)
        })
        imageVector.snp.makeConstraints({ img in
            img.leading.equalTo(imgNewPlace.snp.trailing).offset(20)
            img.top.equalTo(labelPlace.snp.bottom)
        })
        labelCity.snp.makeConstraints({ label in
            label.leading.equalTo(imageVector.snp.trailing).offset(8)
            label.bottom.equalTo(imageVector.snp.bottom).offset(4)
        })
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
