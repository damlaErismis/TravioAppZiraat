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
        let lbl = UILabelCC(labelText: "Label", font: .poppinsSemiBold32)
        lbl.textColor = .white
        return lbl
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .black
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        self.view.backgroundColor = .mainColor
        self.view.addSubviews(viewMain, labelTitle,buttonBack, activityIndicator)
        setupLayout()
    }

    func setupLayout() {
        activityIndicator.snp.makeConstraints({ai in
            ai.edges.equalToSuperview()
        })
        
        buttonBack.snp.makeConstraints({btn in
            btn.centerY.equalTo(labelTitle)
            btn.leading.equalToSuperview().offset(25)
            btn.width.equalTo(30)
            btn.height.equalTo(26.75)
        })
        labelTitle.snp.makeConstraints({ lbl in
            lbl.top.equalToSuperview().offset(50)
            lbl.leading.equalTo(buttonBack.snp.trailing).offset(12)
            
        })
        viewMain.snp.makeConstraints({ view in
            view.bottom.equalToSuperview()
            view.leading.trailing.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.82)
        })
    }
}


