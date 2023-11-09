//
//  
//  SecuritySettingsVCVC.swift
//  TravioProject
//
//  Created by Burak Özer on 6.11.2023.
//
//
import UIKit
import TinyConstraints


class SecuritySettingsVC: UIViewController {
    
    //MARK: -- Properties
    private var isFormComplete: Bool = false
    
    //MARK: -- Views
    
    private lazy var imageBack:UIImageView = {
        let img = UIImageView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleBack))
        img.addGestureRecognizer(tap)
        img.isUserInteractionEnabled = true
        img.image = UIImage(named: "Vector")
        return img
    }()
    private lazy var viewMain:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "F8F8F8")
        view.layer.cornerRadius = 75
        view.layer.maskedCorners = [.topLeft]
        return view
    }()
    private lazy var labelSecuritySetting:UILabelCC = {
        
        let lbl =  UILabelCC(labelText: "Security Setting", font: .poppinsMedium30)
        lbl.textColor = .white
        return lbl
    }()
    private lazy var labelPassword = UILabelCC(labelText: "New Password", font: .poppinsRegular14)
    private lazy var labelPasswordConfirm = UILabelCC(labelText: "New Password Confirm", font: .poppinsRegular14)
    private lazy var labelCamera = UILabelCC(labelText: "Camera", font: .poppinsRegular14)
    private lazy var labelPhotoLibrary = UILabelCC(labelText: "Photo Library", font: .poppinsRegular14)
    private lazy var labelLocation = UILabelCC(labelText: "Location", font: .poppinsRegular14)
    
    private lazy var labelChangePassword:UILabelCC = {
        let lbl = UILabelCC(labelText: "Change Password", font: .poppinsRegular24)
        lbl.textColor =  UIColor(hexString: "#38ADA9")
        return lbl
    }()
    private lazy var labelPrivacy:UILabelCC = {
        let lbl = UILabelCC(labelText: "Privacy", font: .poppinsRegular24)
        lbl.textColor =  UIColor(hexString: "#38ADA9")
        return lbl
    }()
    private lazy var textFieldPassword:UITextFieldCC = {
        let txt = UITextFieldCC(placeholderText: "*************")
        txt.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        txt.isSecureTextEntry = true
        txt.delegate = self
        return txt
    }()
    private lazy var textFieldPasswordConfirm:UITextFieldCC = {
        let txt = UITextFieldCC(placeholderText: "*************")
        txt.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        txt.isSecureTextEntry = true
        txt.delegate = self
        return txt
    }()

    private lazy var labelPasswordControl:UILabelCC = {
        let lbl = UILabelCC(labelText: "En az 6 karakter giriniz", font: .poppinsRegular14)
        lbl.textColor = .red
        lbl.isHidden = true
        return lbl
    }()
    
    private lazy var labelPasswordMismatch:UILabelCC = {
        let lbl = UILabelCC(labelText: "Parola Eşleşmiyor", font: .poppinsRegular14)
        lbl.textColor = .red
        lbl.isHidden = true
        return lbl
    }()
    
    private lazy var stackViewPassword:UIStackView = {
        
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillProportionally
        sv.spacing = 5
        sv.backgroundColor = .white
        sv.layer.cornerRadius = 16
        return sv
    }()
    
    private lazy var stackViewPasswordConfirm:UIStackView = {
        
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillProportionally
        sv.spacing = 5
        sv.backgroundColor = .white
        sv.layer.cornerRadius = 16
        return sv
    }()
    
    private lazy var stackViewCamera:UIStackView = UIStackViewSettingHorizontal()
    private lazy var stackViewPhotoLibrary:UIStackView = UIStackViewSettingHorizontal()
    private lazy var stackViewLocation:UIStackView = UIStackViewSettingHorizontal()

    private lazy var stackViewChangePassword:UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillProportionally
        sv.spacing = 10
        sv.addShadow(shadowColor: UIColor(hexString: "#000000"), offsetX: 0, offsetY: 0, shadowOpacity: 0.1, shadowRadius: 10.0)
        return sv
    }()
    

    private lazy var stackViewPrivacy:UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 10
        sv.addShadow(shadowColor: UIColor(hexString: "#000000"), offsetX: 0, offsetY: 0, shadowOpacity: 0.1, shadowRadius: 10.0)
        return sv
    }()

    private lazy var toggleSwitchCamera = {
        let s = UISwitch()
        s.addTarget(self, action: #selector(toggleSwitcChangeForCamera), for: .valueChanged)
        return s
    }()
    private lazy var toggleSwitchPhotoLibrary = {
        let s = UISwitch()
        s.addTarget(self, action: #selector(toggleSwitcChangeForPhotoLibrary), for: .valueChanged)
        return s
    }()
    private lazy var toggleSwitchLocation = {
        let s = UISwitch()
        s.addTarget(self, action: #selector(toggleSwitcChangeForLocation), for: .valueChanged)
        return s
    }()
    @objc func handleBack(){
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func toggleSwitcChangeForCamera(){
        
    }
    @objc func toggleSwitcChangeForPhotoLibrary(){
        
    }
    @objc func toggleSwitcChangeForLocation(){
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        
        if textField == textFieldPassword || textField == textFieldPasswordConfirm {
            
            let passwordText = textFieldPassword.text ?? ""
            let passwordConfirmText = textFieldPasswordConfirm.text ?? ""
            let passwordsMatch = passwordText == passwordConfirmText && passwordConfirmText.count > 6
            labelPasswordMismatch.isHidden = passwordsMatch
            let passwordLenght = passwordText.count > 6
            labelPasswordControl.isHidden = passwordLenght
            isFormComplete = passwordText.count > 6 && passwordsMatch
            buttonSave.isEnabled = isFormComplete
            buttonSave.backgroundColor = isFormComplete ? UIColor(hexString: "#38ada9") : .lightGray
  
            
        }
        if textField == textFieldPassword{
            let passwordText = textFieldPassword.text ?? ""
            let passwordChracterCountControl = passwordText.count > 6
            labelPasswordControl.isHidden = passwordChracterCountControl
        }
    }
    
    
    private lazy var buttonSave:UIButton = {
        let btn = UIButton()
        btn.setTitle("Save", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(hexString: "#38ada9")
        btn.layer.cornerRadius = 12
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        
        return btn
    }()
    @objc func handleSave(){
        
    }
    
    //MARK: -- Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupViews()
    }
    
    //MARK: -- Component Actions
    
    
    //MARK: -- Private Methods
    
    
    //MARK: -- UI Methods
    func setupViews() {
        // Add here the setup for the UI
        self.view.backgroundColor = UIColor(hexString: "#38ada9")
        self.view.addSubviews(imageBack, labelSecuritySetting, viewMain)
        self.viewMain.addSubviews(labelChangePassword, labelPrivacy , stackViewChangePassword, stackViewPrivacy, buttonSave)
        stackViewPassword.addArrangedSubviews(labelPassword, textFieldPassword, labelPasswordControl)
        stackViewPasswordConfirm.addArrangedSubviews(labelPasswordConfirm, textFieldPasswordConfirm, labelPasswordMismatch)
        stackViewChangePassword.addArrangedSubviews(stackViewPassword, stackViewPasswordConfirm)
        
        stackViewCamera.addArrangedSubviews(labelCamera, toggleSwitchCamera)
        stackViewPhotoLibrary.addArrangedSubviews(labelPhotoLibrary, toggleSwitchPhotoLibrary)
        stackViewLocation.addArrangedSubviews(labelLocation, toggleSwitchLocation)
        stackViewPrivacy.addArrangedSubviews(stackViewCamera, stackViewPhotoLibrary, stackViewLocation)
        setupLayout()
    }
    func setupLayout() {
        // Add here the setup for layout
        imageBack.snp.makeConstraints({img in
            img.top.equalToSuperview().offset(60)
            img.leading.equalToSuperview().offset(25)
            img.width.equalTo(24)
            img.height.equalTo(21)
        })
        labelSecuritySetting.snp.makeConstraints({lbl in
            lbl.centerY.equalTo(imageBack.snp.centerY)
            lbl.trailing.equalToSuperview().offset(-45)
        })
        viewMain.snp.makeConstraints({ view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.80)
        })
        labelChangePassword.snp.makeConstraints({lbl in
            lbl.top.equalToSuperview().offset(45)
            lbl.leading.equalToSuperview().offset(25)
        })
        labelPassword.snp.makeConstraints({lbl in
            lbl.top.equalToSuperview().offset(8)
            lbl.leading.equalToSuperview().offset(10)
        })
        textFieldPassword.snp.makeConstraints({ txt in
            txt.leading.equalToSuperview().offset(10)
            txt.height.equalTo(25)
        })
        labelPasswordControl.snp.makeConstraints({lbl in
            lbl.leading.equalToSuperview().offset(10)
        })
        labelPasswordMismatch.snp.makeConstraints({lbl in
            lbl.leading.equalToSuperview().offset(10)
        })
        labelPasswordConfirm.snp.makeConstraints({lbl in
            lbl.top.equalToSuperview().offset(8)
            lbl.leading.equalToSuperview().offset(10)
        })
        textFieldPasswordConfirm.snp.makeConstraints({ txt in
            txt.leading.equalToSuperview().offset(10)
            txt.height.equalTo(25)
        })
        stackViewPassword.snp.makeConstraints({sv in
            sv.height.equalTo(75)
        })
        stackViewChangePassword.snp.makeConstraints({sv in
            sv.top.equalTo(labelChangePassword.snp.bottom).offset(8)
            sv.leading.equalToSuperview().offset(25)
            sv.trailing.equalToSuperview().offset(-25)
            sv.height.equalTo(160)
        })
        labelPrivacy.snp.makeConstraints({lbl in
            lbl.top.equalTo(stackViewChangePassword.snp.bottom).offset(25)
            lbl.leading.equalToSuperview().offset(25)
        })
        
        labelCamera.snp.makeConstraints({lbl in
            lbl.leading.equalTo(15)
        })
        toggleSwitchCamera.snp.makeConstraints({ts in
            ts.height.equalTo(30)
            ts.width.equalTo(50)
        })
        labelPhotoLibrary.snp.makeConstraints({lbl in
            lbl.leading.equalTo(15)
        })
        toggleSwitchPhotoLibrary.snp.makeConstraints({ts in
            ts.trailing.equalToSuperview().offset(-15)
            ts.height.equalTo(30)
            ts.width.equalTo(50)
        })
        labelLocation.snp.makeConstraints({lbl in
            lbl.leading.equalTo(15)
        })
        toggleSwitchLocation.snp.makeConstraints({ts in
//            ts.trailing.equalToSuperview().offset(-30)
            ts.height.equalTo(30)
            ts.width.equalTo(50)
        })
        stackViewPrivacy.snp.makeConstraints({sv in
            sv.top.equalTo(labelPrivacy.snp.bottom).offset(8)
            sv.leading.equalToSuperview().offset(25)
            sv.trailing.equalToSuperview().offset(-25)
            sv.height.equalTo(245)
        })
        buttonSave.snp.makeConstraints({ btn in
            btn.bottom.equalToSuperview().offset(-40)
            btn.centerX.equalToSuperview()
            btn.height.equalTo(54)
            btn.width.equalTo(342)
        })
    }
}

extension SecuritySettingsVC:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //        guard let textPassword = textFieldPassword.text else{
        //            return false
        //        }
        //
        //        if textField == textFieldPassword {
        //
        //        }
        return true
        
    }
}


