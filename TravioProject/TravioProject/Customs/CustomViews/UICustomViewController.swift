//
//  UICustomViewController.swift
//  TravioProject
//
//  Created by Burak Özer on 14.11.2023.
//

import UIKit
import SnapKit

class UICustomViewController: UIViewController {
    
    lazy var buttonBack: UIButton = {
        let button = UIButton()
//        button.isUserInteractionEnabled = true
        if let image = UIImage(named: "vector") {
            button.setImage(image, for: .normal)
        }
        return button
    }()
    
    lazy var viewMain: UIView = {
        let view = UIView()
        view.backgroundColor = .viewColor
        view.layer.cornerRadius = 75
        view.layer.maskedCorners = [.topLeft]
        return view
    }()

    lazy var labelTitle: UILabelCC = {
        let lbl = UILabelCC(labelText: "Label", font: .poppinsBold30)
        lbl.textColor = .white
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        self.view.backgroundColor = .mainColor
        self.view.addSubviews(viewMain, labelTitle, buttonBack)
        setupLayout()
    }

    func setupLayout() {
        buttonBack.snp.makeConstraints({img in
            img.centerY.equalTo(labelTitle)
            img.leading.equalToSuperview().offset(25)
            img.width.equalTo(30)
            img.height.equalTo(26.75)
        })
        labelTitle.snp.makeConstraints({ img in
            img.top.equalToSuperview().offset(50)
            img.leading.equalTo(buttonBack.snp.trailing).offset(24)
        })
        viewMain.snp.makeConstraints({ view in
            view.bottom.equalToSuperview()
            view.leading.trailing.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.82)
        })
    }
}

