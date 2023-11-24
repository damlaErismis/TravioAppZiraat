//
//  UIViewAlertCC.swift
//  TravioProject
//
//  Created by Burak Özer on 19.11.2023.
//

import UIKit
import SnapKit

class UIViewCC: UIView{

    lazy var statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.0
        return imageView
    }()
    
    func showPasswordMatched(_ isMatched: Bool) {
        statusImageView.image = isMatched ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "exclamationmark.circle")
        UIView.animate(withDuration: 5.0) {
            self.statusImageView.alpha = 1.0
        }
    }

    var isStatusImageViewVisible: Bool = false {
        didSet {
            statusImageView.isHidden = !isStatusImageViewVisible
            statusImageView.alpha = isStatusImageViewVisible ? 1.0 : 0.0
        }
    }
    lazy var label:UILabelCC = {
        let lbl = UILabelCC()
        lbl.addFont = .poppinsRegular14
        lbl.textColor = .black
        return lbl
    }()
    
    lazy var textField:UITextFieldCC = {
 
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
        self.backgroundColor = .white
        self.layer.cornerRadius = 16
        self.addShadow(shadowColor: .black, offsetX: 0, offsetY: 0, shadowOpacity: 0.1, shadowRadius: 10.0)
        self.height(74)
        commonInit(isStatusImageViewVisible: false)
    }
    
    convenience init(labeltext: String, placeholderText:String, isStatusImageViewVisible: Bool = false) {
        self.init(frame: .zero)
        self.labelText = labeltext
        self.placeholder = placeholderText
        commonInit(isStatusImageViewVisible: isStatusImageViewVisible)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(isStatusImageViewVisible: Bool) {
        self.isStatusImageViewVisible = isStatusImageViewVisible

        
        setupView()
    }
    
    func setupView(){
        self.addSubviews(label, textField, statusImageView)
        setupLayout()
    }
    
    func setupLayout(){
        label.snp.makeConstraints({ lbl in
            lbl.top.equalToSuperview().offset(8)
            lbl.leading.equalToSuperview().offset(12)
        })
        statusImageView.snp.makeConstraints { imgView in
            imgView.centerY.equalTo(textField)
            imgView.trailing.equalToSuperview().offset(-12)
            imgView.width.equalTo(30)
            imgView.height.equalTo(30)
        }
        textField.snp.makeConstraints({ txt in
            txt.top.equalTo(label.snp.bottom).offset(8)
            txt.leading.equalToSuperview().offset(12)
            txt.height.equalTo(30)
        })
    }

}
