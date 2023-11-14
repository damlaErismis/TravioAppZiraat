//
//  HomeCollectionCell.swift
//  TravioProject
//
//  Created by Burak Özer on 26.10.2023.
//

import UIKit
import SnapKit
import TinyConstraints
import Kingfisher

class HomeCollectionCell: UICollectionViewCell {
    
    lazy var imagePlace:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 20
        img.clipsToBounds = true
        return img
    }()
    
    public lazy var labelPlace:UILabelCC = {
        let lbl = UILabelCC()
        lbl.textColor = .red
        lbl.addFont = .poppinsRegular24
        return lbl
    }()
    
    public lazy var labelCity:UILabelCC = {
        let lbl = UILabelCC()
        lbl.addFont = .poppinsRegular14
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
    
    public func configurePopularPlaces(with object:Place){
        if let imageURL = URL(string: object.cover_image_url) {
            imagePlace.kf.setImage(with: imageURL)
            }
        labelPlace.text = object.title
        labelCity.text = object.place
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
            lbl.bottom.equalTo(imageVektor)
            lbl.leading.equalTo(imageVektor.snp.leading).offset(15)
            lbl.centerY.equalTo(imageVektor)
            
        })
        
        labelPlace.snp.makeConstraints({ lbl in
            lbl.leading.equalTo(imageVektor)
            lbl.bottom.equalTo(imageVektor.snp.top).offset(-5)
        })
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
