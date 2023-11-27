//
//  VisitsCustomCell.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 27.10.2023.
//

import Foundation
import UIKit
import SnapKit
import TinyConstraints
import Kingfisher

class VisitsCell:UICollectionViewCell {
    
    lazy var imagePlace:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 20
        img.clipsToBounds = true
        return img
    }()
    lazy var labelPlace:UILabelCC = {
        let lbl = UILabelCC()
        lbl.textColor = .white
        lbl.addFont = .poppinsSemiBold30
        return lbl
    }()
    lazy var labelCity:UILabelCC = {
        let lbl = UILabelCC()
            lbl.addFont = .poppinsLight16
        lbl.textColor = .white
        return lbl
    }()
    
    private lazy var imageVektor:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "visitLogo")
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    public func configure(with object:Visit){
        if let url = URL(string: object.place.cover_image_url) {
            imagePlace.kf.setImage(with: url)
        }
        labelCity.text = object.place.place
        labelPlace.text = object.place.title
    }
    
    func setupViews(){
        self.contentView.addSubviews(imagePlace)
        imagePlace.addSubviews(imageVektor, labelCity, labelPlace)
        setupLayout()
    }
    func setupLayout(){
        imagePlace.edgesToSuperview()
        imageVektor.snp.makeConstraints({ image in
            image.leading.equalToSuperview().offset(15)
            image.bottom.equalToSuperview().offset(-10)
            image.width.equalTo(9)
            image.height.equalTo(12)
        })
        
        labelCity.snp.makeConstraints({lbl in
            lbl.bottom.equalToSuperview().offset(-8)
            lbl.leading.equalTo(imageVektor.snp.leading).offset(15)
            lbl.centerY.equalTo(imageVektor)
        })
        labelPlace.snp.makeConstraints({ lbl in
            lbl.leading.equalTo(imageVektor)
            lbl.trailing.equalToSuperview().offset(-10)
            lbl.bottom.equalTo(imageVektor.snp.top).offset(-5)
        })
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

