//
//  PopularPlacesCollectionCell.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 1.11.2023.
//

import UIKit
import SnapKit
import TinyConstraints
import Kingfisher

class PopularPlacesCell: UICollectionViewCell {
    
    lazy var imgPopularPlace:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var labelPlace:UILabelCC = {
        let lbl = UILabelCC()
        lbl.textColor = .black
        lbl.addFont = .poppinsRegular24
        return lbl
    }()
    
    private lazy var labelCity:UILabelCC = {
        let lbl = UILabelCC()
        lbl.addFont = .poppinsRegular14
        lbl.textColor = .black
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
    
    override func layoutSubviews() {
        
        imgPopularPlace.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public func configure(with object:Place){
        if let imageURL = URL(string: object.cover_image_url) {
                imgPopularPlace.kf.setImage(with: imageURL)
            }
        labelPlace.text = object.title
        print(object.place)
        labelCity.text = object.place
    }
    private func setupViews() {
        
        self.backgroundColor = .clear
        self.contentView.addSubview(containerView)
        self.contentView.backgroundColor = .clear
        self.contentView.addShadow(shadowColor: .black, offsetX: 0, offsetY: 0, shadowOpacity: 0.1, shadowRadius: 8)
        containerView.addSubviews(imgPopularPlace, labelPlace,imageVector,labelCity)
        setupLayout()
    }
    private func setupLayout() {

        containerView.snp.makeConstraints({ container in
            container.top.equalToSuperview().offset(6)
            container.leading.equalToSuperview().offset(16)
            container.trailing.equalToSuperview().offset(-16)
            container.bottom.equalToSuperview().offset(-6)
        })
        
        imgPopularPlace.snp.makeConstraints({ image in
            image.leading.equalToSuperview()
            image.top.equalToSuperview()
            image.bottom.equalToSuperview()
            image.width.equalTo(90)
        })
        
        labelPlace.snp.makeConstraints({ label in
            label.leading.equalTo(imgPopularPlace.snp.trailing).offset(20)
            label.top.equalTo(imgPopularPlace).offset(10)
        })
        imageVector.snp.makeConstraints({ img in
            img.leading.equalTo(imgPopularPlace.snp.trailing).offset(20)
            img.top.equalTo(labelPlace.snp.bottom)
        })
        labelCity.snp.makeConstraints({ label in
            label.leading.equalTo(imageVector.snp.trailing).offset(8)
            label.bottom.equalTo(imageVector.snp.bottom).offset(6)
        })
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
