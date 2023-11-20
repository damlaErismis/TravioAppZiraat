//
//  
//  SecuritySettingsVCVC.swift
//  TravioProject
//
//  Created by Burak Özer on 6.11.2023.
//
//

import UIKit
import SnapKit
import AVFoundation
import CoreLocation
import Photos

class SecuritySettingsVC: UICustomViewController, CLLocationManagerDelegate {

    private lazy var vm:SecuritySettingsVM = {
        return SecuritySettingsVM()
    }()
    
    //MARK: -- Properties
    private var isFormComplete: Bool = false
    let locationManager = CLLocationManager()
    
    //MARK: -- Views
    
    private lazy var labelPrivacy:UILabelCC = {
        let lbl = UILabelCC(labelText: "Privacy", font: .poppinsRegular20)
        lbl.textColor =  .mainColor
        return lbl
    }()
    private lazy var labelChangePassword:UILabelCC = {
        let lbl = UILabelCC(labelText: "Change Password", font: .poppinsRegular20)
        lbl.textColor = .mainColor
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
    
    private lazy var viewPassword: UIViewCC = {
        let view = UIViewCC(labeltext: "New Password", placeholderText: "***********")
        view.textField.isSecureTextEntry = true
        view.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return view
    }()

    private lazy var viewPasswordConfirm: UIViewCC = {
        let view = UIViewCC(labeltext: "New Password Confirm", placeholderText: "***********", isStatusImageViewVisible: true)
        view.textField.isSecureTextEntry = true
        view.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return view
    }()
    private lazy var scrollViewAll:UIScrollView = {
        let sv = UIScrollView()
        sv.isScrollEnabled = true
        sv.layer.cornerRadius = 75
        sv.layer.maskedCorners = [.topLeft]
        return sv
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
        sv.backgroundColor = UIColor(hexString: "F8F8F8")
        sv.spacing = 12
        sv.distribution = .fillProportionally
  
        return sv
    }()
    private lazy var buttonSave:UIButton = {
        let btn = UIButton()
        btn.setTitle("Save", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .lightGray
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
    
    @objc func toggleSwitcChangeForLocation() {
        if toggleSwitchLocation.isOn {
            requestLocationPermission()
        }
    }
    @objc func toggleSwitcChangeForCamera() {
        if toggleSwitchCamera.isOn {
            requestCameraPermission()
        }
    }
    @objc func toggleSwitcChangeForPhotoLibrary() {
        if toggleSwitchPhotoLibrary.isOn {
            requestPhotoLibraryPermission()
        }
    }
    
    func requestCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            DispatchQueue.main.async {
                self.toggleSwitchCamera.isOn = true
            }
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.showPermissionPopup(permissionType: "Camera", toggleSwitch: self.toggleSwitchCamera)
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] (granted) in
                if granted {
                    DispatchQueue.main.async {
                        self?.toggleSwitchCamera.isOn = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.showPermissionPopup(permissionType: "Camera", toggleSwitch: self?.toggleSwitchCamera)
                    }
                }
            }
        @unknown default:
            break
        }
    }
    
    func requestLocationPermission() {
        let locationManager = CLLocationManager()
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            DispatchQueue.main.async {
                self.toggleSwitchLocation.isOn = true
            }
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.showPermissionPopup(permissionType: "Location", toggleSwitch: self.toggleSwitchLocation)
            }
        case .notDetermined:
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }

    func requestPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            DispatchQueue.main.async {
                self.toggleSwitchCamera.isOn = true
            }
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.showPermissionPopup(permissionType: "Photo Library", toggleSwitch: self.toggleSwitchPhotoLibrary)
            }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] (newStatus) in
                if newStatus == .authorized {
                    
                    DispatchQueue.main.async {
                        self?.toggleSwitchPhotoLibrary.isOn = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.showPermissionPopup(permissionType: "Photo Library", toggleSwitch: self?.toggleSwitchPhotoLibrary)
                    }
                }
            }
        case .limited:
            print("???????????")
        @unknown default:
            print("***********")
        }
    }

    func showPermissionPopup(permissionType: String, toggleSwitch: UISwitch?) {
        let alertController = UIAlertController(title: "Permission Denied",
                                                message: "\(permissionType) permission denied. You can enable it in Settings.",
                                                preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            toggleSwitch?.isOn = false
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    func checkCameraPermission() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    func checkLocationPermission() -> Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways
    }
    func checkPhotoLibraryPermission() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }


    //MARK: -- Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toggleSwitchCamera.isOn = checkCameraPermission()
        toggleSwitchLocation.isOn = checkLocationPermission()
        toggleSwitchPhotoLibrary.isOn = checkPhotoLibraryPermission()
        
        labelTitle.text = "Security Settings"
        imageBack.image = UIImage(named: "btnBack")
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleBack))
        imageBack.addGestureRecognizer(tap)
        
        initVC()
        initVM()
    }
    
    //MARK: -- Component Actions
    
    func initVM(){
        vm.showSuccessAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                guard let message = self?.vm.successMessage else {
                    return
                }
                self?.showAlert(title: "Success", message: message)
            }
        }
        vm.showErrorAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.vm.errorStatusMessage?.message, let title = self?.vm.errorStatusMessage?.status {
                    self?.showAlert(title:title, message: message)
                }
            }
        }
    }
    
    func initVC(){
        setupViews()
    }
    
    @objc func handleBack(){
        navigationController?.popViewController(animated: true)
    }

    @objc func handleSave(){
        vm.changePassword(newPassword: viewPassword.textField.text!)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let passwordText = viewPassword.textField.text ?? ""
        let passwordConfirmText = viewPasswordConfirm.textField.text ?? ""
        
        if textField == viewPassword.textField || textField == viewPasswordConfirm.textField {
            let passwordsMatch = passwordText == passwordConfirmText && passwordConfirmText.count >= 6
            let passwordLenght = passwordText.count >= 6
            isFormComplete = passwordText.count >= 6 && passwordsMatch && !passwordText.isEmpty && !passwordConfirmText.isEmpty
            buttonSave.isEnabled = isFormComplete
            buttonSave.backgroundColor = isFormComplete ? .mainColor : .lightGray
        }
        
        if textField == viewPasswordConfirm.textField{
            let passwordsMatch = passwordText == passwordConfirmText && passwordConfirmText.count >= 6
            viewPasswordConfirm.showPasswordMatched(passwordsMatch)
        }
    }

    //MARK: -- Private Methods
    
    
    //MARK: -- UI Methods
    func setupViews() {
        // Add here the setup for the UI
        self.view.backgroundColor = .mainColor
        self.viewMain.addSubviews(scrollViewAll)
        scrollViewAll.addSubviews(labelChangePassword, stackViewTop, labelPrivacy, stackViewBottom, buttonSave)
        stackViewTop.addArrangedSubviews(viewPassword,viewPasswordConfirm)
        stackViewBottom.addArrangedSubviews(viewCamera,viewPhotoLibrary,viewLocation)
        viewCamera.addSubviews(labelCamera, toggleSwitchCamera)
        viewPhotoLibrary.addSubviews(labelPhotoLibrary, toggleSwitchPhotoLibrary)
        viewLocation.addSubviews(labelLocation, toggleSwitchLocation)
        
        setupLayouts()
    }
    
    func setupLayouts() {
        scrollViewAll.snp.makeConstraints({sv in
            sv.top.equalToSuperview()
            sv.leading.equalToSuperview().offset(10)
            sv.trailing.equalToSuperview().offset(-10)
            sv.bottom.equalToSuperview().offset(-10)
        })
        labelChangePassword.snp.makeConstraints({lbl in
            lbl.top.equalToSuperview().offset(50)
            lbl.leading.equalToSuperview().offset(14)
        })
        stackViewTop.snp.makeConstraints({sv in
            sv.top.equalTo(labelChangePassword.snp.bottom).offset(8)
            sv.leading.equalToSuperview().offset(14)
            sv.trailing.equalToSuperview().offset(-14)
            sv.width.equalToSuperview().multipliedBy(0.95)
        })
        labelPrivacy.snp.makeConstraints({lbl in
            lbl.top.equalTo(stackViewTop.snp.bottom).offset(50)
            lbl.leading.equalToSuperview().offset(14)
        })
        stackViewBottom.snp.makeConstraints({sv in
            sv.top.equalTo(labelPrivacy.snp.bottom).offset(8)
            sv.leading.equalToSuperview().offset(14)
            sv.trailing.equalToSuperview().offset(-14)
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
            btn.top.equalTo(stackViewBottom.snp.bottom).offset(50)
            btn.leading.equalToSuperview().offset(14)
            btn.trailing.equalToSuperview().offset(-14)
            btn.height.equalTo(54)
            btn.bottom.equalToSuperview()
        })
    }
}





