//
//  UIStackViewSettingHorizontal.swift
//  TravioProject
//
//  Created by Burak Özer on 9.11.2023.
//

import Foundation
import UIKit

class UIStackViewSettingHorizontal: UIStackView {

    override init(frame: CGRect) {
        
        super.init(frame: frame)

        self.axis = .horizontal
        self.distribution = .fillProportionally
        self.alignment = .center
        self.spacing = 170
        self.backgroundColor = .white
        self.layer.cornerRadius = 16

        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
