//
//  HomeCollectionCell.swift
//  TravioProject
//
//  Created by Burak Özer on 26.10.2023.
//

import UIKit
import SnapKit
class HomeCollectionCell: UICollectionViewCell {
    
    lazy var imagePlace:UIImageView = {
        let img = UIImageView()
        return img
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){
        self.contentView.backgroundColor = .blue
        self.contentView.addSubviews(imagePlace)
        setupLayout()
    }
    func setupLayout(){
        imagePlace.snp.makeConstraints({ img in
            img.top.equalToSuperview()
            img.bottom.equalToSuperview()
            img.leading.equalToSuperview()
            img.trailing.equalToSuperview()
        })

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
