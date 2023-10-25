//
//  UILabelVC.swift
//  TravioProject
//
//  Created by Burak Özer on 15.10.2023.
//

import UIKit

class UILabelVC: UILabel {
    
    var addFont: FontStatus? = nil {
        didSet{
            applyFont()
        }
    }

    func applyFont(){
        
        self.font = addFont?.defineFont
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(labelText:String, font: FontStatus) {
        self.init(frame: .zero)
        set(labelText: labelText, font: font )

    }
    
    func configure(){
        self.addFont = .poppinsRegular14
        
    }
    
    func set(labelText: String, font: FontStatus){
        self.text = labelText
        self.addFont = font
        
    }

    

}
