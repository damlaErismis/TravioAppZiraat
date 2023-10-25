//
//  BaseUIViewVC.swift
//  TravioProject
//
//  Created by Burak Özer on 14.10.2023.
//

import UIKit

class UIViewCC: UIView {

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor(hexString: "FFFFFF")
        self.layer.cornerRadius = 16
        self.addShadow(shadowColor: UIColor(hexString: "#000000"), offsetX: 0, offsetY: 0, shadowOpacity: 0.2, shadowRadius: 15.0)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
