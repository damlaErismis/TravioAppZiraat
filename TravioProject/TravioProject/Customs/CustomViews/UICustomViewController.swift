//
//  UICustomViewController.swift
//  TravioProject
//
//  Created by Burak Özer on 14.11.2023.
//

import UIKit
import SnapKit

class UICustomViewController: UIViewController {
    
    lazy var imageBack:UIImageView = {
        let img = UIImageView()
        img.isUserInteractionEnabled = true
        return img
    }()
    
    lazy var viewMain: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.viewColor.uiColor
        view.layer.cornerRadius = 75
        view.layer.maskedCorners = [.topLeft]
        return view
    }()

    lazy var labelTitle: UILabelCC = {
        let lbl = UILabelCC(labelText: "Label", font: .poppinsBold36)
        lbl.textColor = .white
        return lbl
    }()
    
    lazy var buttonAction: UIButton = {
        let btn = UIButton()
        btn.setTitle("", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 12
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {

        self.view.backgroundColor = ThemeColor.mainColor.uiColor
        self.view.addSubviews(viewMain, labelTitle, imageBack)
        viewMain.addSubview(buttonAction)
        setupLayout()
    }

    func setupLayout() {
        
        imageBack.snp.makeConstraints({img in
            img.centerY.equalTo(labelTitle)
            img.leading.equalToSuperview().offset(25)
            img.width.equalTo(24)
            img.height.equalTo(21)
        })
        
        labelTitle.snp.makeConstraints({ img in
            img.top.equalToSuperview().offset(50)
            img.centerX.equalToSuperview()
        })
        viewMain.snp.makeConstraints({ view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.80)
        })
        buttonAction.snp.makeConstraints({ btn in
            btn.leading.equalToSuperview()
            btn.trailing.equalToSuperview()
            btn.height.equalTo(54)
            btn.bottom.equalToSuperview().offset(-30)
        })
    }
}

