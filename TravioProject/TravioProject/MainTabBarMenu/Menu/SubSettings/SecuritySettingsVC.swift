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
    private lazy var viewPassword = UIViewCC()
    private lazy var viewPasswordConfirm = UIViewCC()
    private lazy var viewCamera = UIViewCC()
    private lazy var viewPhotoLibrary = UIViewCC()
    private lazy var viewLocation = UIViewCC()
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
        txt.isSecureTextEntry = true
        txt.delegate = self
        return txt
    }()
    private lazy var textFieldPasswordConfirm:UITextFieldCC = {
        let txt = UITextFieldCC(placeholderText: "*************")
        txt.isSecureTextEntry = true
        txt.delegate = self
        return txt
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
    
    private lazy var buttonSave:UIButton = {
        let btn = UIButton()
        btn.setTitle("Login", for: .normal)
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
        self.viewMain.addSubviews(labelChangePassword, viewPassword, viewPasswordConfirm, labelPrivacy, viewCamera, viewPhotoLibrary, viewLocation, buttonSave)
        viewPassword.addSubviews(labelPassword, textFieldPassword)
        viewPasswordConfirm.addSubviews(labelPasswordConfirm, textFieldPasswordConfirm)
        viewCamera.addSubviews(labelCamera, toggleSwitchCamera)
        viewPhotoLibrary.addSubviews(labelPhotoLibrary, toggleSwitchPhotoLibrary)
        viewLocation.addSubviews(labelLocation, toggleSwitchLocation)
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
        viewPassword.snp.makeConstraints({ view in
            view.top.equalTo(labelChangePassword.snp.bottom).offset(15)
            view.leading.equalToSuperview().offset(25)
            view.trailing.equalToSuperview().offset(-25)
            view.height.equalTo(75)
        })
        labelPassword.snp.makeConstraints({lbl in
            lbl.top.equalToSuperview().offset(8)
            lbl.leading.equalToSuperview().offset(10)
        })
        textFieldPassword.snp.makeConstraints({ txt in
            txt.top.equalTo(labelPassword.snp.bottom).offset(10)
            txt.leading.equalToSuperview().offset(10)
            txt.trailing.equalToSuperview().offset(-10)
            txt.height.equalTo(30)
        })
        viewPasswordConfirm.snp.makeConstraints({ view in
            view.top.equalTo(viewPassword.snp.bottom).offset(15)
            view.leading.equalToSuperview().offset(25)
            view.trailing.equalToSuperview().offset(-25)
            view.height.equalTo(75)
        })
        labelPasswordConfirm.snp.makeConstraints({lbl in
            lbl.top.equalToSuperview().offset(8)
            lbl.leading.equalToSuperview().offset(10)
        })
        textFieldPasswordConfirm.snp.makeConstraints({ txt in
            txt.top.equalTo(labelPasswordConfirm.snp.bottom).offset(10)
            txt.leading.equalToSuperview().offset(10)
            txt.trailing.equalToSuperview().offset(-10)
            txt.height.equalTo(30)
        })
        labelPrivacy.snp.makeConstraints({lbl in
            lbl.top.equalTo(viewPasswordConfirm.snp.bottom).offset(25)
            lbl.leading.equalToSuperview().offset(25)
        })
        viewCamera.snp.makeConstraints({ view in
            view.top.equalTo(labelPrivacy.snp.bottom).offset(8)
            view.leading.equalToSuperview().offset(25)
            view.trailing.equalToSuperview().offset(-25)
            view.height.equalTo(75)
        })
        labelCamera.snp.makeConstraints({lbl in
            lbl.leading.equalTo(15)
            lbl.centerY.equalToSuperview()
        })
        toggleSwitchCamera.snp.makeConstraints({ts in
            ts.trailing.equalToSuperview().offset(-15)
            ts.centerY.equalToSuperview()
            ts.height.equalTo(30)
            ts.width.equalTo(50)
        })
        viewPhotoLibrary.snp.makeConstraints({ view in
            view.top.equalTo(viewCamera.snp.bottom).offset(8)
            view.leading.equalToSuperview().offset(25)
            view.trailing.equalToSuperview().offset(-25)
            view.height.equalTo(75)
        })
        labelPhotoLibrary.snp.makeConstraints({lbl in
            lbl.leading.equalTo(15)
            lbl.centerY.equalToSuperview()
        })
        toggleSwitchPhotoLibrary.snp.makeConstraints({ts in
            ts.trailing.equalToSuperview().offset(-15)
            ts.centerY.equalToSuperview()
            ts.height.equalTo(30)
            ts.width.equalTo(50)
        })
        viewLocation.snp.makeConstraints({ view in
            view.top.equalTo(viewPhotoLibrary.snp.bottom).offset(8)
            view.leading.equalToSuperview().offset(25)
            view.trailing.equalToSuperview().offset(-25)
            view.height.equalTo(75)
        })
        labelLocation.snp.makeConstraints({lbl in
            lbl.leading.equalTo(15)
            lbl.centerY.equalToSuperview()
        })
        toggleSwitchLocation.snp.makeConstraints({ts in
            ts.trailing.equalToSuperview().offset(-15)
            ts.centerY.equalToSuperview()
            ts.height.equalTo(30)
            ts.width.equalTo(50)
        })
        buttonSave.snp.makeConstraints({ btn in
            btn.bottom.equalToSuperview().offset(-20)
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

