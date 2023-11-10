//
//  BaseUIViewVC.swift
//  TravioProject
//
//  Created by Burak Özer on 14.10.2023.
//

import UIKit

class UIViewCC: UIView{

    private lazy var label:UILabelCC = {
        
        let lbl = UILabelCC()
        lbl.addFont = .poppinsRegular14
        lbl.textColor = .black
        return lbl
    }()
    
    private lazy var textField:UITextFieldCC = {
 
        let txt = UITextFieldCC()
        txt.addFont = .poppinsRegular16
        return txt
    }()
    
    var labelText: String?{
        get {return label.text}
        set { label.text = newValue}
    }
    
    var placeholder: String? {
            get { return textField.placeholder }
            set {
                textField.attributedPlaceholder = NSAttributedString(string: newValue ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Thin", size: 12)!, NSAttributedString.Key.foregroundColor: UIColor.black])
            }
        }
    var text: String?{
        get {return textField.text}
        set { textField.text = newValue}
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hexString: "FFFFFF")
        self.layer.cornerRadius = 16
        self.addShadow(shadowColor: UIColor(hexString: "#000000"), offsetX: 0, offsetY: 0, shadowOpacity: 0.1, shadowRadius: 10.0)
        self.height(74)
        setupView()
    }
    
    convenience init(labeltext: String, placeholderText:String) {
        
        self.init(frame: .zero)
        self.labelText = labeltext
        
        self.placeholder = placeholderText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.addSubviews(label, textField)
        setupLayout()
    }
    
    func setupLayout(){
        
        label.snp.makeConstraints({ lbl in
            lbl.top.equalToSuperview().offset(8)
            lbl.leading.equalToSuperview().offset(12)
            
        })
        
        textField.snp.makeConstraints({ txt in
            txt.top.equalTo(label.snp.bottom).offset(8)
            txt.leading.equalToSuperview().offset(12)
            txt.height.equalTo(30)
        })
    }

}
