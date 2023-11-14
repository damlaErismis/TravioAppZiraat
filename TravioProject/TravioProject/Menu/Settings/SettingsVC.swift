//
//
//  SettingVC.swift
//  Travio
//
//  Created by Burak Özer on 2.11.2023.
//
//
import UIKit
import SnapKit

class SettingsVC: UIViewController {
    
    //MARK: -- Properties
    
    private lazy var vm:SettingsVM = {
        return SettingsVM()
        
    }()
    
    //MARK: -- Views
    
    private lazy var collectionView:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 24
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        cv.register(SettingCollectionCell.self, forCellWithReuseIdentifier: "cell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private lazy var buttonSetting:UIButton = {
        let btn = UIButton()
        btn.setTitle("Settings", for: .normal)
        btn.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 32)
        return btn
    }()
    
    private lazy var imageLogout:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "vectorSetting")
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleLogout))
        img.addGestureRecognizer(tap)
        img.isUserInteractionEnabled = true
        return img
    }()
    
    private lazy var viewMain:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "F8F8F8")
        view.layer.cornerRadius = 75
        view.layer.maskedCorners = [.topLeft]
        return view
    }()
    
    private lazy var imageProfile:UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 60
        img.clipsToBounds = true
        
        return img
    }()
    
    private lazy var labelNameSurname:UILabelCC = {
        let lbl = UILabelCC()
        lbl.font = UIFont(name: "Poppins-Medium", size: 16)
        return lbl
    }()
    
    private lazy var buttonEditProfile:UIButton = {
        let btn = UIButton()
        btn.setTitle("Edit Profile", for: .normal)
        btn.setTitleColor(UIColor(hexString: "#17C0EB"), for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 12)
        btn.addTarget(self, action: #selector(buttonEditProfileTapped), for: .touchUpInside)
        return btn
    }()

    //MARK: -- Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        initVC()
        initVM()
    }
    
    //MARK: -- Component Actions
    @objc func handleLogout(){

        let service = "com.travio"
        let account = "travio"
        KeychainHelper.shared.delete(service, account: account)
        let vc = LoginVC()
        self.navigationController?.pushViewController(vc, animated: true)
        showAlert(title: "Ok", message: "Uygulamadan Çıkış Yapıldı")
    }
    
    @objc func buttonEditProfileTapped(){
        let editProfile = EditProfileVC()
        self.navigationController?.pushViewController(editProfile, animated: true)
    }
    
    //MARK: -- Private Methods

    
    //MARK: -- UI Methods
    
    func initVM(){
        
        vm.initFetch()
        
        vm.getUserProfileData = { [weak self] () in
            
            guard let userName = self?.vm.userProfileResponse?.full_name else {return}
            self?.labelNameSurname.text = userName
            guard let imageString = self?.vm.userProfileResponse?.pp_url else {return}
            if let imageURL = URL(string: imageString) {
                if let imageData = try? Data(contentsOf: imageURL) {
                    if let image = UIImage(data: imageData) {
                        self?.imageProfile.image = image
                    }
                }
            }
        }
    }
    
    
    func initVC(){
        
        setupViews()
    }
    
    func setupViews() {
        // Add here the setup for the UI
        self.view.backgroundColor = UIColor(hexString: "#38ada9")
        self.view.addSubviews(viewMain, buttonSetting, imageLogout)
        self.viewMain.addSubviews(imageProfile, labelNameSurname, buttonEditProfile, collectionView)
        setupLayout()
    }
    
    func setupLayout() {
        // Add here the setup for layout
        
        buttonSetting.snp.makeConstraints({btn in
            btn.top.equalToSuperview().offset(40)
            btn.leading.equalToSuperview().offset(20)
            btn.height.equalTo(48)
            btn.width.equalTo(134)
        })
        imageLogout.snp.makeConstraints({img in
            img.centerY.equalTo(buttonSetting.snp.centerY)
            img.trailing.equalTo(-30)
            img.height.equalTo(30)
            img.width.equalTo(30)
        })
        
        viewMain.snp.makeConstraints({ view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.80)
        })
        imageProfile.snp.makeConstraints({img in
            img.top.equalToSuperview().offset(25)
            img.centerX.equalToSuperview()
            img.height.equalTo(120)
            img.width.equalTo(120)
        })
        labelNameSurname.snp.makeConstraints({lbl in
            lbl.top.equalTo(imageProfile.snp.bottom).offset(9)
            lbl.centerX.equalToSuperview()
        })
        buttonEditProfile.snp.makeConstraints({btn in
            btn.top.equalTo(labelNameSurname.snp.bottom).offset(6)
            btn.centerX.equalToSuperview()
            btn.height.equalTo(18)
            btn.width.equalTo(62)
        })
        collectionView.snp.makeConstraints({cv in
            cv.top.equalTo(buttonEditProfile.snp.bottom).offset(24)
            cv.leading.equalToSuperview()
            cv.trailing.equalToSuperview()
            cv.bottom.equalToSuperview()
        })
    }
  
}

extension SettingsVC:UICollectionViewDelegateFlowLayout {
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let vc = SecuritySettingsVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = HelpAndSupportVC()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("Diğer alt settingler gelecek")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        return CGSize(width: (collectionView.frame.width - 20), height: (collectionView.frame.height-10) * 0.1)
//        return CGSize(width: 360, height: 60)
    }
}

extension SettingsVC:UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SettingCollectionCell
        switch indexPath.item{
        case 0:
            cell.getSettingCollectionData(imageIconString: "securitySetting", imageDirectionString: "vektorRight", itemString: "Security Settings")
        case 1:
            cell.getSettingCollectionData(imageIconString: "appDefault", imageDirectionString: "vektorRight", itemString: "App Defaults")
        case 2:
            cell.getSettingCollectionData(imageIconString: "Map", imageDirectionString: "vektorRight", itemString: "My Added Places")
        case 3:
            cell.getSettingCollectionData(imageIconString: "helpAndSupport", imageDirectionString: "vektorRight", itemString: "Help&Support")
        case 4:
            cell.getSettingCollectionData(imageIconString: "about", imageDirectionString: "vektorRight", itemString: "About")
        default:
            cell.getSettingCollectionData(imageIconString: "termOfUse", imageDirectionString: "vektorRight", itemString: "Terms of Use")
        }
        return cell
    }
    
    
}



