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

class VisitsCustomCell:UITableViewCell {
    
    private lazy var imgPlace:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private lazy var imgPin: UIImageView = {
        let pinView = UIImageView(image: UIImage(named: "whitePin"))
        return pinView
    }()
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = imgPlace.layer.cornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var labelPlace: UILabelCC = {
        let label = UILabelCC(labelText: "Süleymaniye Camii", font: .poppinsBold30)
        label.textColor = .white
        return label
    }()
    private lazy var labelLocation: UILabelCC = {
        let label = UILabelCC(labelText: "İstanbul", font: .poppinsRegular16)
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    public func configure(object:Images){
        imgPlace.image = object.image
    }
    
    private func setupViews() {
        self.contentView.addSubviews(imgPlace)
        imgPlace.addSubview(overlayView)
        overlayView.addSubviews(labelPlace, labelLocation, imgPin)
        self.contentView.backgroundColor = UIColor(hexString: "#F8F8F8")
        setupLayout()
    }
    
    private func setupLayout() {
        imgPlace.snp.makeConstraints({ image in
            image.leading.equalToSuperview().offset(12)
            image.top.equalToSuperview().offset(12)
            image.bottom.equalToSuperview().offset(-12)
        })
        overlayView.snp.makeConstraints({ overlay in
            overlay.leading.trailing.equalTo(imgPlace)
            overlay.top.equalTo(imgPlace).offset(140)
            overlay.bottom.equalTo(imgPlace)
        })
        labelPlace.snp.makeConstraints({ label in
            label.leading.trailing.equalTo(imgPlace)
        })
        labelLocation.snp.makeConstraints({ label in
            label.leading.equalTo(imgPin.snp.trailing).offset(5)
            label.top.equalTo(labelPlace.snp.bottom).offset(5)
        })
        imgPin.snp.makeConstraints({ pin in
            pin.leading.equalTo(imgPlace.snp.leading).offset(5)
            pin.centerY.equalTo(labelLocation)
        })
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

