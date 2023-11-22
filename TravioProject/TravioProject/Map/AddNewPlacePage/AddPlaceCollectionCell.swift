//
//  AddPlaceCollectionCell.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 31.10.2023.
//

import UIKit
import SnapKit

class AddPlaceCollectionCell: UICollectionViewCell {
    
    lazy var imgNewPlace:UIImageView = {
        let img = UIImageView()
        img.contentMode = .center
        img.layer.cornerRadius = 20
        img.clipsToBounds = true
        img.backgroundColor = .white
        img.isUserInteractionEnabled = true
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
        setupLayout()
    }
    func setupLayout(){
        
        imgNewPlace.snp.makeConstraints({img in
            img.edges.equalToSuperview()
        })

    }
}
