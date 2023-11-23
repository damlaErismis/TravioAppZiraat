//
//
//  EditProfileVCVC.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 7.11.2023.


import UIKit
import TinyConstraints
import SnapKit
import Kingfisher
import Photos

protocol EditProfileVCDelegate: AnyObject {
    func profilePhotoDidUpdate(_ newPhoto: UIImage)
    func fullNameDidUpdate(_ newName: String)
}

class EditProfileVC: UIViewController {
    
    weak var delegate: EditProfileVCDelegate?
    
    private var viewModel = EditProfileVM()
    var imagesFromLibrary:[UIImage] = []
    
    private lazy var viewMain:UIView = {
        let view = UIView()
        view.backgroundColor = .viewColor
        view.layer.cornerRadius = 75
        view.layer.maskedCorners = [.topLeft]
        return view
    }()
    
    private lazy var viewFullName:UIViewCC = {
        let view = UIViewCC(labeltext: "Full Name", placeholderText: "bilge_adam")
        view.textField.autocapitalizationType = .none
        return view
    }()
    private lazy var viewEmail:UIViewCC = {
        let view = UIViewCC(labeltext: "Email", placeholderText: "developer@bilgeadam.com")
        view.textField.autocapitalizationType = .none
        return view
    }()
    
    private lazy var labelEditProfile:UILabelCC = {
        let lbl = UILabelCC(labelText: "Edit Profile", font: .poppinsBold30)
        lbl.textColor = .white
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    private lazy var imgProfilePic:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 60
        iv.layer.masksToBounds = true
        return iv
    }()
    private lazy var viewCreatedAtTime = UIViewCC()
    private lazy var viewUserRole = UIViewCC()
    
    
    private lazy var labelFullNameTitle = UILabelCC(labelText: " ", font: .poppinsRegular24)
    
    private lazy var labelCreatedAtTime = UILabelCC(labelText: "Aug 30, 2023", font: .poppinsRegular14)
    private lazy var labelUserRole = UILabelCC(labelText: "Admin", font: .poppinsRegular14)
    
    private lazy var imageCreatedAtTime:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "createdAtTime")
        return img
    }()
    private lazy var imageUserRole:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "userRole")
        return img
    }()
    
    private lazy var stackView:UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 24
        sv.distribution = .fillProportionally
        return sv
    }()
    
    private lazy var buttonSave:UIButton = {
        let btn = UIButton()
        btn.setTitle("Save", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .mainColor
        btn.layer.cornerRadius = 12
        btn.addTarget(self, action: #selector(btnSaveTapped), for: .touchUpInside)
        return btn
    }()
    private lazy var buttonChangePhoto:UIButton = {
        let btn = UIButton()
        btn.setTitle("Change Photo", for: .normal)
        btn.setTitleColor(.textButtonColor, for: .normal)
        btn.frame = CGRect(x: view.frame.width - 120, y: 10, width: 149, height: 30)
        btn.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 14)
        btn.addTarget(self, action: #selector(btnChangePhotoTapped), for: .touchUpInside)
        return btn
        
    }()
    
    private lazy var btnCross: UIButton = {
        let image = UIImage(named: "cross")
        let btn = UIButton()
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(btnCrossTapped), for: .touchUpInside)
        return btn
    }()
    
    @objc func btnCrossTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    var selectedImageURL: URL?

    @objc func btnSaveTapped() {
        guard let fullName = viewFullName.textField.text,
              let email = viewEmail.textField.text else {return }
        let pp_url = self.viewModel.imageUrls?.first ?? self.viewModel.userProfile?.pp_url ?? ""

        self.viewModel.updateUserProfile(fullName: fullName, email: email, pp_url: pp_url)
        
        viewModel.showAlertClosure = { [weak self] in
            if let message = self?.viewModel.alertMessage {
                self?.showAlert(title: "Success!", message: message)
            }
        }
        delegate?.profilePhotoDidUpdate(imgProfilePic.image!)
        delegate?.fullNameDidUpdate(viewFullName.textField.text ?? "")
    }
    
    @objc func btnChangePhotoTapped() {
        presentPhotoActionSheet()
    }
    
    private func bindViewModel() {
        viewModel.userProfileDidChange = { [weak self] userProfile in
            self?.labelFullNameTitle.text = userProfile.full_name
            self?.labelUserRole.text = userProfile.role
            self?.viewFullName.textField.text = userProfile.full_name
            self?.viewEmail.textField.text = userProfile.email
            
            if let formattedDate = self?.viewModel.formatServerDate(dateString: userProfile.created_at) {
                self?.labelCreatedAtTime.text = formattedDate
                
            } else {
                self?.labelCreatedAtTime.text = userProfile.created_at
            }
            
            if let imageURL = URL(string: userProfile.pp_url) {
                self?.imgProfilePic.kf.setImage(with: imageURL)
            }
        }
    }
    func uploadImages(){
        let images = imagesFromLibrary
        viewModel.uploadImages(images: images)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getPersonalInfo()
        bindViewModel()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupViews() {
        self.view.addSubviews(viewMain, btnCross, labelEditProfile)
        self.view.backgroundColor = .mainColor
        viewMain.addSubviews(imgProfilePic, buttonChangePhoto ,buttonSave,viewCreatedAtTime,viewUserRole,viewFullName,viewEmail, labelFullNameTitle, stackView)
        viewCreatedAtTime.addSubviews(imageCreatedAtTime, labelCreatedAtTime)
        viewUserRole.addSubviews(imageUserRole, labelUserRole)
        stackView.addArrangedSubviews(viewFullName, viewEmail)
        setupLayout()
    }
    
    func setupLayout() {
        
        labelEditProfile.snp.makeConstraints({ img in
            img.top.equalToSuperview().offset(25)
            img.leading.equalToSuperview().offset(50)
            img.height.equalTo(52)
            img.width.equalTo(250)
        })
        
        btnCross.snp.makeConstraints({ btn in
            btn.top.equalTo(labelEditProfile).offset(15)
            btn.trailing.equalToSuperview().offset(-25)
            btn.width.equalTo(25)
            btn.height.equalTo(25)
        })
        
        viewMain.snp.makeConstraints({ view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.80)
        })
        
        imgProfilePic.snp.makeConstraints({ img in
            img.top.equalToSuperview().offset(20)
            img.centerX.equalTo(viewMain)
            img.height.equalTo(120)
            img.width.equalTo(120)
            
        })
        buttonChangePhoto.snp.makeConstraints({ btn in
            btn.top.equalTo(imgProfilePic.snp.bottom)
            btn.centerX.equalTo(viewMain)
        })
        labelFullNameTitle.snp.makeConstraints({ lbl in
            lbl.top.equalTo(buttonChangePhoto.snp.bottom)
            lbl.centerX.equalTo(viewMain)
        })
        viewCreatedAtTime.snp.makeConstraints({ view in
            view.top.equalTo(labelFullNameTitle.snp.bottom).offset(20)
            view.leading.equalToSuperview().offset(20)
            view.height.equalTo(55)
            view.width.equalTo(163)
        })
        imageCreatedAtTime.snp.makeConstraints ({ img in
            img.centerY.equalToSuperview()
            img.leading.equalToSuperview().offset(13)
        })
        
        labelCreatedAtTime.snp.makeConstraints ({ lbl in
            lbl.centerY.equalToSuperview()
            lbl.leading.equalTo(imageCreatedAtTime.snp.trailing).offset(13)
        })
        viewUserRole.snp.makeConstraints({ view in
            view.top.equalTo(labelFullNameTitle.snp.bottom).offset(20)
            view.leading.equalTo(viewCreatedAtTime.snp.trailing).offset(13)
            view.trailing.equalToSuperview().offset(-20)
            view.height.equalTo(55)
            view.width.equalTo(163)
        })
        imageUserRole.snp.makeConstraints ({ img in
            img.centerY.equalToSuperview()
            img.leading.equalToSuperview().offset(13)
        })
        labelUserRole.snp.makeConstraints ({ lbl in
            lbl.centerY.equalToSuperview()
            lbl.leading.equalTo(imageUserRole.snp.trailing).offset(13)
        })
        
        stackView.snp.makeConstraints({ sv in
            sv.top.equalTo(viewUserRole.snp.bottom).offset(24)
            sv.trailing.equalToSuperview().offset(-20)
            sv.leading.equalToSuperview().offset(20)
            sv.centerX.equalToSuperview()
        })
        
        buttonSave.snp.makeConstraints({ btn in
            btn.centerX.equalToSuperview()
            btn.height.equalTo(54)
            btn.width.equalTo(342)
            btn.bottom.equalToSuperview().offset(-30)
        })
    }
    
}
extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            imgProfilePic.image = selectedImage
            viewModel.uploadImages(images: [selectedImage])
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: nil ))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentPhotoPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .authorized {
                present(imagePicker, animated: true, completion: nil)
            } else if status == .denied || status == .restricted {
                showAlertForSettings()
            } else if status == .notDetermined {
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if newStatus == .authorized {
                        DispatchQueue.main.async {
                            self.present(imagePicker, animated: true, completion: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showAlertForSettings()
                        }
                    }
                })
            }
        }
    }

    func showAlertForSettings() {
        let alert = UIAlertController(title: "Access Permission",
                                      message: "Permission to access the photo library is required. You can enable it in Settings.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { action in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
