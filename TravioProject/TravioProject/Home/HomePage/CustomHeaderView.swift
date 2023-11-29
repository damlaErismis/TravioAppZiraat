//
//  CustomHeaderView.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 29.11.2023.
//

import Foundation
import UIKit
import SnapKit

class CustomHeaderView: UITableViewHeaderFooterView {
    
    
    private lazy var lblPlaceType:VerticalAlignedLabel = {
        let lbl = VerticalAlignedLabel()
        lbl.contentMode = .bottom
        lbl.font = FontStatus.poppinsMedium20.defineFont
        return lbl
    }()
    
    lazy var btnSeeAll:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("See All", for: .normal)
        btn.titleLabel?.numberOfLines = 2
        btn.titleLabel?.lineBreakMode = .byWordWrapping
        btn.contentVerticalAlignment = .bottom
        btn.setTitleColor(.textButtonColor, for: .normal)
        btn.titleLabel?.font = FontStatus.poppinsMedium14.defineFont
        return btn
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        textLabel?.isHidden = true
        setupView()
    }
    
    private func setupView(){
        addSubviews(lblPlaceType,btnSeeAll)
        setupLayout()
    }
    
    private func setupLayout(){
        lblPlaceType.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview()
        }
        btnSeeAll.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(lblPlaceType.snp.centerY)
            make.top.equalToSuperview().offset(10)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, section: Int) {
        lblPlaceType.text = title
        btnSeeAll.tag = section
    }
}
