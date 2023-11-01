//
//  PopularPlacesCollectionCell.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 1.11.2023.
//

import UIKit
import SnapKit
import TinyConstraints

class PopularPlacesCell: UITableViewCell {
    
    private lazy var imgPlace:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
         
        return iv
    }()
    
    private lazy var labelPlace:UILabelCC = {
        let lbl = UILabelCC(labelText: "Colleseum", font: .poppinsBold16)
        lbl.textColor = .black
        return lbl
    }()
    
    private lazy var imgPin: UIImageView = {
        let pinView = UIImageView(image: UIImage(named: "blackPin"))
        pinView.tintColor = .black
        return pinView
    }()
    
    private lazy var labelCountry:UILabelCC = {
        let lbl = UILabelCC(labelText: "Rome", font: .poppinsRegular16)
        lbl.textColor = .black
        return lbl
    }()
    
    private lazy var containerView:UIView = {
        let container = UIView()
        container.backgroundColor = .white
        return container
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.cornerRadius = 20
        self.containerView.layer.cornerRadius = 20
        //self.containerView.layer.masksToBounds = true
        self.containerView.addShadow(shadowColor: .black, offsetX: 0, offsetY: 0, shadowOpacity: 0.2, shadowRadius: 6)
        
       
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    public func configure(object:PopularPlaces){
        imgPlace.image = object.image
        labelPlace.text = object.labelPlace
        imgPin.image = object.imgPin
        labelCountry.text = object.labelCountry
    }
    private func setupViews() {
        self.backgroundColor = .clear
        self.contentView.addSubview(containerView)
        self.contentView.backgroundColor = .clear
        containerView.addSubviews(imgPlace, labelPlace,imgPin,labelCountry)
        setupLayout()
    }
    private func setupLayout() {
        //containerView.dropShadow()
        containerView.snp.makeConstraints({ container in
            container.top.equalToSuperview().offset(10)
            container.leading.equalToSuperview().offset(16)
            container.trailing.equalToSuperview().offset(-16)
            container.bottom.equalToSuperview().offset(-16)
        })
        
        imgPlace.snp.makeConstraints({ image in
            image.leading.equalToSuperview()
            image.top.equalToSuperview()
            image.bottom.equalToSuperview()
            image.width.equalTo(60)
        })
        
        labelPlace.snp.makeConstraints({ label in
            label.leading.equalTo(imgPlace.snp.trailing).offset(50)
            label.top.equalTo(imgPlace).offset(20)
        })
        imgPin.snp.makeConstraints({ img in
            img.leading.equalTo(imgPlace.snp.trailing).offset(50)
            img.top.equalTo(labelPlace.snp.bottom).offset(8)
        })
        labelCountry.snp.makeConstraints({ label in
            label.leading.equalTo(imgPin.snp.trailing).offset(8)
            label.bottom.equalTo(imgPin.snp.bottom).offset(6)
        })
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
