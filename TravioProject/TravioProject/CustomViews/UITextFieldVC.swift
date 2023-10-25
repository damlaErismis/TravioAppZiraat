//
//  BaseTextFieldVC.swift
//  TravioProject
//
//  Created by Burak Özer on 14.10.2023.
//

import UIKit

class UITextFieldVC: UITextField {
    
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
    
    
    func configure(){
        
        self.addFont = .poppinsRegular20
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    convenience init(placeholderText:String) {
        self.init(frame: .zero)
        set(placeholderText: placeholderText)

    }
    
    

    
    func set(placeholderText:String){
        let attributedString = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Thin", size: 12)!, NSAttributedString.Key.foregroundColor: UIColor.black])
        self.attributedPlaceholder = attributedString
    }
}
