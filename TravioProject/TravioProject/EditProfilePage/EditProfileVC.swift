//
//  
//  EditProfileVCVC.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 7.11.2023.
//
//
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
//        iv.roundAllCorners(radius: 50)
        iv.clipsToBounds = true
        iv.image = UIImage(named: "bruce")
        return iv
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
    @objc func btnChangePhotoTapped(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setupViews()
       
    }
    

    func setupViews() {
        self.navigationItem.rightBarButtonItem = createCrossButton()
        self.view.addSubviews(viewMain, labelEditProfile)
        self.view.backgroundColor = UIColor(hexString: "#38ada9")
        viewMain.addSubviews(imgProfilePic, buttonChangePhoto ,buttonSave)
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
        
        buttonSave.snp.makeConstraints({ btn in
            btn.centerX.equalToSuperview()
            btn.height.equalTo(54)
            btn.width.equalTo(342)
            btn.bottom.equalToSuperview().offset(-30)
        })
    }
  
}

