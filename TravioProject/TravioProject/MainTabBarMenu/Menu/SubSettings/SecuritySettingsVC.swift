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


class SecuritySettingsVC: UIViewController{
    
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
    private lazy var labelPrivacy:UILabelCC = {
        let lbl = UILabelCC(labelText: "Privacy", font: .poppinsRegular20)
        lbl.textColor =  UIColor(hexString: "#38ADA9")
        return lbl
    }()
    private lazy var labelChangePassword:UILabelCC = {
        let lbl = UILabelCC(labelText: "Change Password", font: .poppinsRegular20)
        lbl.textColor =  UIColor(hexString: "#38ADA9")
        return lbl
    }()
    
    private lazy var viewCamera = UIViewCC()
    private lazy var viewPhotoLibrary = UIViewCC()
    private lazy var viewLocation = UIViewCC()
    private lazy var labelSecuritySetting:UILabelCC = {
        let lbl =  UILabelCC(labelText: "Security Setting", font: .poppinsMedium30)
        lbl.textColor = .white
        return lbl
    }()
    private lazy var labelCamera = UILabelCC(labelText: "Camera", font: .poppinsRegular14)
    private lazy var labelPhotoLibrary = UILabelCC(labelText: "Photo Library", font: .poppinsRegular14)
    private lazy var labelLocation = UILabelCC(labelText: "Location", font: .poppinsRegular14)
    private lazy var viewPassword:UIViewCC = {
        let view = UIViewCC(labeltext: "New Password", placeholderText: "***********")
        view.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view.textField.autocapitalizationType = .none
        return view
    }()
    private lazy var viewPasswordConfirm:UIViewCC = {
        let view = UIViewCC(labeltext: "New Password Confirm", placeholderText: "***********")
        view.textField.isSecureTextEntry = true
        view.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return view
    }()
    
    private lazy var stackViewTop:UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 12
        sv.distribution = .fillProportionally
        return sv
    }()
    private lazy var stackViewBottom:UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 12
        sv.distribution = .fillProportionally
        return sv
    }()
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

    
    //MARK: -- Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupViews()
    }
    
    //MARK: -- Component Actions
    @objc func handleBack(){
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func toggleSwitcChangeForCamera(){
        
    }
    @objc func toggleSwitcChangeForPhotoLibrary(){
        
    }
    @objc func toggleSwitcChangeForLocation(){
        
    }
    
    @objc func handleSave(){
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField == viewPassword.textField || textField == viewPasswordConfirm.textField {
            
            let passwordText = viewPassword.textField.text ?? ""
            let passwordConfirmText = viewPasswordConfirm.textField.text ?? ""
            let passwordsMatch = passwordText == passwordConfirmText && passwordConfirmText.count > 6
            labelPasswordMismatch.isHidden = passwordsMatch
            let passwordLenght = passwordText.count > 6
            labelPasswordControl.isHidden = passwordLenght
            isFormComplete = passwordText.count > 6 && passwordsMatch
            buttonSave.isEnabled = isFormComplete
            buttonSave.backgroundColor = isFormComplete ? UIColor(hexString: "#38ada9") : .lightGray
        }
        if textField == viewPassword.textField{
            let passwordText = viewPassword.textField.text ?? ""
            let passwordChracterCountControl = passwordText.count > 6
            labelPasswordControl.isHidden = passwordChracterCountControl
        }
    }

    //MARK: -- Private Methods
    
    
    //MARK: -- UI Methods
    func setupViews() {
        // Add here the setup for the UI
        self.view.backgroundColor = UIColor(hexString: "#38ada9")
        self.view.addSubviews(imageBack, labelSecuritySetting, viewMain)
        self.viewMain.addSubviews(labelChangePassword,stackViewTop,labelPrivacy, stackViewBottom, buttonSave)
 
        stackViewTop.addArrangedSubviews(viewPassword,viewPasswordConfirm)
        viewPassword.addSubviews(labelPasswordControl)
        viewPasswordConfirm.addSubviews(labelPasswordMismatch)
        stackViewBottom.addArrangedSubviews(viewCamera,viewPhotoLibrary,viewLocation)
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
            lbl.centerX.equalToSuperview()
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
        labelPasswordControl.snp.makeConstraints({lbl in
            lbl.bottom.equalToSuperview()
            lbl.leading.equalToSuperview().offset(12)
        })
        labelPasswordMismatch.snp.makeConstraints({lbl in
            lbl.bottom.equalToSuperview()
            lbl.leading.equalToSuperview().offset(12)
        })
        stackViewTop.snp.makeConstraints({sv in
            sv.top.equalTo(labelChangePassword.snp.bottom).offset(8)
            sv.leading.equalToSuperview().offset(25)
            sv.trailing.equalToSuperview().offset(-25)
        })
        labelPrivacy.snp.makeConstraints({lbl in
            lbl.top.equalTo(viewPasswordConfirm.snp.bottom).offset(25)
            lbl.leading.equalToSuperview().offset(25)
        })
        stackViewBottom.snp.makeConstraints({sv in
            sv.top.equalTo(labelPrivacy.snp.bottom).offset(8)
            sv.leading.equalToSuperview().offset(25)
            sv.trailing.equalToSuperview().offset(-25)
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
            btn.bottom.equalToSuperview().offset(-50)
            btn.centerX.equalToSuperview()
            btn.height.equalTo(54)
            btn.width.equalTo(342)
        })
    }
}

