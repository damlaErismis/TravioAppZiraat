//
//  AddPlaceCollectionCell.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 31.10.2023.
//

import UIKit

class AddPlaceCollectionCell: UICollectionViewCell {
    
    lazy var imgNewPlace:UIImageView = {
        let img = UIImageView()
        img.contentMode = .center
        img.layer.cornerRadius = 20
        img.clipsToBounds = true
        img.backgroundColor = .white
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        
        self.contentView.addSubviews(imgNewPlace)
//        self.layer.masksToBounds = false
//        self.addShadow(shadowColor: .black, offsetX: 0, offsetY: 0, shadowOpacity: 0.2, shadowRadius: 10)
        setupLayout()
    }
    func setupLayout(){
        
        imgNewPlace.edgesToSuperview()

    }
}
