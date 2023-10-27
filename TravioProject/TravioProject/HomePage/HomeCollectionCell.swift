//
//  HomeCollectionCell.swift
//  TravioProject
//
//  Created by Burak Özer on 26.10.2023.
//

import UIKit
import SnapKit
import TinyConstraints
class HomeCollectionCell: UICollectionViewCell {
    
    lazy var imagePlace:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 20
        img.clipsToBounds = true
    
        return img
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){

        self.contentView.addSubviews(imagePlace)
        setupLayout()
    }
    func setupLayout(){
        
        imagePlace.edgesToSuperview()

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
