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

class SecuritySettingsVC: UICustomViewController{
    private lazy var vm:SecuritySettingsVM = {
        return SecuritySettingsVM()
    }()
    
    //MARK: -- Properties
    private var isFormComplete: Bool = false
    
    let locationManager = CLLocationManager()
    
    //MARK: -- Views
    private lazy var containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var labelPrivacy:UILabelCC = {
        let lbl = UILabelCC(labelText: "Privacy", font: .poppinsSemiBold16)
        lbl.textColor =  .mainColor
        return lbl
    }()
    
    private lazy var labelChangePassword:UILabelCC = {
        let lbl = UILabelCC(labelText: "Change Password", font: .poppinsSemiBold16)
        lbl.textColor = .mainColor
        return lbl
    }()
    
    private lazy var viewCamera = UICustomTextField()
    private lazy var viewPhotoLibrary = UICustomTextField()
    private lazy var viewLocation = UICustomTextField()
    
    private lazy var labelSecuritySetting:UILabelCC = {
        let lbl =  UILabelCC(labelText: "Security Setting", font: .poppinsSemiBold32)
        lbl.textColor = .white
        return lbl
    }()
    
    private lazy var labelCamera = UILabelCC(labelText: "Camera", font: .poppinsMedium14)
    private lazy var labelPhotoLibrary = UILabelCC(labelText: "Photo Library", font: .poppinsMedium14)
    private lazy var labelLocation = UILabelCC(labelText: "Location", font: .poppinsMedium14)
    
    private lazy var txtPassword: UICustomTextField = {
        let txt = UICustomTextField(labeltext: "New Password", placeholderText: "***********", isStatusImageViewVisible: true)
        txt.textField.isSecureTextEntry = true
        txt.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        txt.statusImageView.image = UIImage(systemName: "eye.slash.fill")
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handlePasswordLongPress(_:)))
        txt.addGestureRecognizer(longPressGesture)
        return txt
    }()
    
    private lazy var txtPasswordConfirm: UICustomTextField = {
        let txt = UICustomTextField(labeltext: "New Password Confirm", placeholderText: "***********", isStatusImageViewVisible: true)
        txt.textField.isSecureTextEntry = true
        txt.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return txt
    }()
    
    private lazy var scrollViewAll:UIScrollView = {
        let sv = UIScrollView()
        sv.isScrollEnabled = true
        sv.layer.cornerRadius = 75
        sv.layer.maskedCorners = [.topLeft]
        sv.isDirectionalLockEnabled = true
        sv.contentInsetAdjustmentBehavior = .always
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
        sv.backgroundColor = .viewColor
        sv.spacing = 12
        sv.distribution = .fillProportionally
        return sv
    }()
    
    private lazy var buttonSave:UIButton = {
        let btn = UIButton()
        btn.setTitle("Save", for: .normal)
        btn.titleLabel?.font = FontStatus.poppinsSemiBold16.defineFont
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
    
    //MARK: -- Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
        initVM()
    }
    
    //MARK: -- Component Actions
    
    @objc func toggleSwitcChangeForLocation() {
        if toggleSwitchLocation.isOn {
            requestLocationPermission()
        }else {
            toggleSwitchLocation.isOn = true
            showPermissionPopup(permissionType: "Location", toggleSwitch: self.toggleSwitchLocation)
        }
    }
    
    @objc func toggleSwitcChangeForCamera() {
        if toggleSwitchCamera.isOn {
            requestCameraPermission()
        }else {
            toggleSwitchCamera.isOn = true
            showPermissionPopup(permissionType: "Camera", toggleSwitch: self.toggleSwitchCamera)
        }
    }
    @objc func toggleSwitcChangeForPhotoLibrary() {
        if toggleSwitchPhotoLibrary.isOn {
            requestPhotoLibraryPermission()
        }else {
            toggleSwitchPhotoLibrary.isOn = true
            showPermissionPopup(permissionType: "Photo Library", toggleSwitch: self.toggleSwitchPhotoLibrary)
        }
    }
    
    @objc func handleBack(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSave(){
        vm.changePassword(newPassword: txtPassword.textField.text!)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let passwordText = txtPassword.textField.text ?? ""
        let passwordConfirmText = txtPasswordConfirm.textField.text ?? ""
        let passwordLenght = passwordText.count >= 6
        let passwordConfirmLenght = passwordConfirmText.count >= 6
        
        if textField == txtPassword.textField || textField == txtPasswordConfirm.textField {
            let passwordsMatch = passwordText == passwordConfirmText && passwordConfirmLenght
            isFormComplete = passwordLenght && passwordsMatch && !passwordText.isEmpty && !passwordConfirmText.isEmpty
            buttonSave.isEnabled = isFormComplete
            buttonSave.backgroundColor = isFormComplete ? .mainColor : .lightGray
        }
        
        if textField == txtPasswordConfirm.textField{
            let passwordsMatch = passwordText == passwordConfirmText && passwordConfirmLenght
            txtPasswordConfirm.showPasswordMatched(passwordsMatch)
        }
    }
    
    @objc func handlePasswordLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            txtPassword.statusImageView.image = UIImage(systemName: "eye.fill")
            txtPassword.textField.isSecureTextEntry = false
        } else if gesture.state == .ended {
            txtPassword.statusImageView.image = UIImage(systemName: "eye.slash.fill")
            txtPassword.textField.isSecureTextEntry = true
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
                self.toggleSwitchCamera.isOn = false
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
                        self?.toggleSwitchCamera.isOn = false
                        self?.showPermissionPopup(permissionType: "Camera", toggleSwitch: self?.toggleSwitchCamera)
                    }
                }
            }
        @unknown default:
            return
        }
    }
    
    func requestPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            DispatchQueue.main.async {
                self.toggleSwitchPhotoLibrary.isOn = true
            }
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.toggleSwitchPhotoLibrary.isOn = false
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
                        self?.toggleSwitchPhotoLibrary.isOn = false
                        self?.showPermissionPopup(permissionType: "Photo Library", toggleSwitch: self?.toggleSwitchPhotoLibrary)
                    }
                }
            }
        case .limited:
            break
        @unknown default:
            break
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
            
            if toggleSwitch?.isOn == false {
                toggleSwitch?.isOn = false
            }
            else {
                toggleSwitch?.isOn = true
            }
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func checkCameraPermission() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    func checkLocationPermission() -> Bool {
        let locationManager = CLLocationManager()
        return locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways
    }
    func checkPhotoLibraryPermission() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }
    
    func photoLibraryAuthorizationDidChange() {
        DispatchQueue.main.async {
            self.toggleSwitchPhotoLibrary.isOn = self.checkPhotoLibraryPermission()
        }
    }
    func locationAuthorizationDidChange() {
        DispatchQueue.main.async {
            self.toggleSwitchLocation.isOn = self.checkLocationPermission()
        }
    }
    func cameraAuthorizationDidChange() {
        DispatchQueue.main.async {
            self.toggleSwitchCamera.isOn = self.checkCameraPermission()
        }
    }
    
    func initVM(){
        vm.updateLoadingStatus = { [weak self] (staus) in
            DispatchQueue.main.async {
                if staus {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
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
        toggleSwitchCamera.isOn = checkCameraPermission()
        toggleSwitchLocation.isOn = checkLocationPermission()
        toggleSwitchPhotoLibrary.isOn = checkPhotoLibraryPermission()
        
        labelTitle.text = "Security Settings"
        buttonBack.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        setupViews()
    }
    
    //MARK: -- UI Methods
    func setupViews() {
        viewMain.addSubviews(scrollViewAll)
        scrollViewAll.addSubviews(containerView)
        containerView.addSubviews(labelChangePassword, stackViewTop, labelPrivacy, stackViewBottom, buttonSave)
        stackViewTop.addArrangedSubviews(txtPassword,txtPasswordConfirm)
        stackViewBottom.addArrangedSubviews(viewCamera,viewPhotoLibrary,viewLocation)
        viewCamera.addSubviews(labelCamera, toggleSwitchCamera)
        viewPhotoLibrary.addSubviews(labelPhotoLibrary, toggleSwitchPhotoLibrary)
        viewLocation.addSubviews(labelLocation, toggleSwitchLocation)
        
        setupLayouts()
    }
    
    func setupLayouts() {
        containerView.snp.makeConstraints({ view in
            view.width.equalToSuperview()
            view.trailing.leading.top.equalToSuperview()
            view.bottom.equalToSuperview()
        })
        scrollViewAll.snp.makeConstraints({sv in
            sv.trailing.leading.top.equalToSuperview()
            sv.height.width.equalToSuperview()
        })
        labelChangePassword.snp.makeConstraints({lbl in
            lbl.top.equalToSuperview().offset(50)
            lbl.trailing.leading.equalToSuperview().inset(24)
            lbl.height.equalTo(25)
        })
        stackViewTop.snp.makeConstraints({sv in
            sv.top.equalTo(labelChangePassword.snp.bottom).offset(8)
            sv.leading.trailing.equalToSuperview().inset(24)
        })
        labelPrivacy.snp.makeConstraints({lbl in
            lbl.top.equalTo(stackViewTop.snp.bottom).offset(30)
            lbl.trailing.leading.equalToSuperview().inset(24)
            lbl.height.equalTo(25)
        })
        stackViewBottom.snp.makeConstraints({sv in
            sv.top.equalTo(labelPrivacy.snp.bottom).offset(8)
            sv.leading.trailing.equalToSuperview().inset(24)
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
            btn.leading.trailing.equalToSuperview().inset(24)
            btn.height.equalTo(54)
            btn.bottom.equalToSuperview().offset(-30)
        })
    }
}
extension SecuritySettingsVC: CLLocationManagerDelegate{
    func requestLocationPermission() {
        let locationManager = CLLocationManager()
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            DispatchQueue.main.async {
                self.toggleSwitchLocation.isOn = true
            }
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.toggleSwitchLocation.isOn = false
                self.showPermissionPopup(permissionType: "Location", toggleSwitch: self.toggleSwitchLocation)
            }
        case .notDetermined:
            self.toggleSwitchLocation.isOn = false
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}
