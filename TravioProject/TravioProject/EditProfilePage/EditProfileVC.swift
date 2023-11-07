//
//
//  EditProfileVCVC.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 7.11.2023.


import UIKit
import TinyConstraints
import SnapKit


class EditProfileVC: UIViewController {
    
    private lazy var viewMain:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "F8F8F8")
        view.layer.cornerRadius = 75
        view.layer.maskedCorners = [.topLeft]
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
        //        iv.image = UIImage(named: "bruce")
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 60
        iv.layer.masksToBounds = true
        return iv
    }()
    private lazy var viewCreatedAtTime = UIViewCC()
    private lazy var viewUserRole = UIViewCC()
    private lazy var viewFullName = UIViewCC()
    private lazy var viewEmail = UIViewCC()
    
    private lazy var labelFullNameTitle = UILabelCC(labelText: "Bruce Willis", font: .poppinsRegular24)
    private lazy var labelCreatedAtTime = UILabelCC(labelText: "Aug 30, 2023", font: .poppinsRegular14)
    private lazy var labelUserRole = UILabelCC(labelText: "Admin", font: .poppinsRegular14)
    private lazy var labelFullName = UILabelCC(labelText: "Full Name", font: .poppinsRegular14)
    private lazy var labelEmail = UILabelCC(labelText: "Email", font: .poppinsRegular14)
    
    private lazy var textFieldFullName:UITextFieldCC = {
        let txt = UITextFieldCC(placeholderText: "bilge_adam")
        txt.autocapitalizationType = .none
        return txt
    }()
    private lazy var textFieldEmail:UITextFieldCC = {
        let txt = UITextFieldCC(placeholderText: "developer@bilgeadam.com")
        txt.autocapitalizationType = .none
        return txt
    }()
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
    
    private lazy var buttonSave:UIButton = {
        let btn = UIButton()
        btn.setTitle("Save", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(hexString: "#38ada9")
        btn.layer.cornerRadius = 12
        btn.addTarget(self, action: #selector(btnSaveTapped), for: .touchUpInside)
        return btn
    }()
    private lazy var buttonChangePhoto:UIButton = {
        let btn = UIButton()
        btn.setTitle("Change Photo", for: .normal)
        btn.setTitleColor(UIColor(hexString: "#17C0EB"), for: .normal)
        btn.frame = CGRect(x: view.frame.width - 120, y: 10, width: 149, height: 30)
        btn.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 14)
        btn.addTarget(self, action: #selector(btnChangePhotoTapped), for: .touchUpInside)
        return btn
        
    }()
    private func createCrossButton() -> UIBarButtonItem {
        let image = UIImage(named: "cross")
        let rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(crossButtonTapped))
        rightBarButtonItem.tintColor = .white
        return rightBarButtonItem
    }
    
    @objc func crossButtonTapped(){
        let home = HomeVC()
        self.navigationController?.pushViewController(home, animated: true)
    }
    @objc func btnSaveTapped(){
        
    }
    
    @objc func btnChangePhotoTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
    }
    
    func setupViews() {
        self.navigationItem.rightBarButtonItem = createCrossButton()
        self.view.addSubviews(viewMain, labelEditProfile)
        self.view.backgroundColor = UIColor(hexString: "#38ada9")
        viewMain.addSubviews(imgProfilePic, buttonChangePhoto ,buttonSave,viewCreatedAtTime,viewUserRole,viewFullName,viewEmail, labelFullNameTitle)
        viewCreatedAtTime.addSubviews(imageCreatedAtTime, labelCreatedAtTime)
        viewUserRole.addSubviews(imageUserRole, labelUserRole)
        viewFullName.addSubviews(labelFullName, textFieldFullName)
        viewEmail.addSubviews(labelEmail, textFieldEmail)
        setupLayout()
    }
    
    func setupLayout() {
        labelEditProfile.snp.makeConstraints({ img in
            img.top.equalToSuperview().offset(50)
            img.leading.equalToSuperview().offset(30)
            img.height.equalTo(52)
            img.width.equalTo(250)
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
        viewFullName.snp.makeConstraints({ view in
            view.top.equalTo(viewUserRole.snp.bottom).offset(24)
            view.trailing.equalToSuperview().offset(-20)
            view.leading.equalToSuperview().offset(20)
            view.height.equalTo(74)
            view.centerX.equalToSuperview()
        })
        labelFullName.snp.makeConstraints({ label in
            label.top.equalToSuperview().offset(13)
            label.leading.equalToSuperview().offset(13)
            label.trailing.equalToSuperview().offset(-13)
            label.bottom.equalTo(textFieldFullName.snp.top)
        })
        
        textFieldFullName.snp.makeConstraints({ txt in
            txt.bottom.equalToSuperview().offset(-13)
            txt.leading.equalToSuperview().offset(13)
            txt.trailing.equalToSuperview().offset(-13)
            txt.height.equalTo(30)
        })
        viewEmail.snp.makeConstraints({ view in
            view.top.equalTo(viewFullName.snp.bottom).offset(24)
            view.trailing.equalToSuperview().offset(-20)
            view.leading.equalToSuperview().offset(20)
            view.height.equalTo(74)
            view.centerX.equalToSuperview()
        })
        labelEmail.snp.makeConstraints({ label in
            label.top.equalToSuperview().offset(13)
            label.leading.equalToSuperview().offset(13)
            label.trailing.equalToSuperview().offset(-13)
            label.bottom.equalTo(textFieldEmail.snp.top)
        })
        
        textFieldEmail.snp.makeConstraints({ txt in
            txt.bottom.equalToSuperview().offset(-13)
            txt.leading.equalToSuperview().offset(13)
            txt.trailing.equalToSuperview().offset(-13)
            txt.height.equalTo(30)
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
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
