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
        layout.minimumLineSpacing = 10
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
        btn.setTitleColor(.white, for: .normal)
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
        view.backgroundColor = .viewColor
        view.layer.cornerRadius = 75
        view.layer.maskedCorners = [.topLeft]
        return view
    }()
    
    private lazy var imageProfile:UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 60
        img.contentMode = .scaleAspectFill
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
        btn.setTitleColor(.textButtonColor, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 12)
        btn.addTarget(self, action: #selector(buttonEditProfileTapped), for: .touchUpInside)
        return btn
    }()
    
    //MARK: -- Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        initVC()
        initVM()
    }
    
    //MARK: -- Component Actions
    @objc func handleLogout(){
        let service = "com.travio"
        let account = "travio"
        KeychainHelper.shared.delete(service, account: account)
        
        let alert = UIAlertController(title: "Alert!", message: "You have been logged out.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok.", style: .default, handler: { _ in
            self.switchToLoginVC()
        }))
        present(alert, animated: true)
    }
    
    func switchToLoginVC() {
        let loginVC = LoginVC()
        let rootViewController = UINavigationController(rootViewController: loginVC)
        UIApplication.shared.windows.first?.rootViewController = rootViewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    @objc func buttonEditProfileTapped(){
        let editProfile = EditProfileVC()
        editProfile.delegate = self
        present(editProfile, animated: true)
    }
    
    //MARK: -- Private Methods
    
    
    //MARK: -- UI Methods
    func loadImageAsync(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }

    func initVM() {
        vm.initFetch()

        vm.getUserProfileData = { [weak self] () in
            guard let self = self,
                  let imageString = self.vm.userProfileResponse?.pp_url,
                  let imageURL = URL(string: imageString) else { return }

            self.loadImageAsync(from: imageURL) { image in
                self.imageProfile.image = image
            }

            guard let userName = self.vm.userProfileResponse?.full_name else { return }
            self.labelNameSurname.text = userName
        }
    }

    func initVC(){
        self.view.backgroundColor = .mainColor
        setupViews()
    }
    
    func setupViews() {
        self.view.addSubviews(viewMain, buttonSetting, imageLogout)
        self.viewMain.addSubviews(imageProfile, labelNameSurname, buttonEditProfile, collectionView)
        setupLayout()
    }
    
    func setupLayout() {
        buttonSetting.snp.makeConstraints({btn in
            btn.top.equalToSuperview().offset(40)
            btn.leading.equalToSuperview().offset(20)
            btn.height.equalTo(48)
            btn.width.equalTo(134)
        })
        imageLogout.snp.makeConstraints({img in
            img.centerY.equalTo(buttonSetting.snp.centerY)
            img.trailing.equalTo(-30)
            img.height.width.equalTo(30)
        })
        viewMain.snp.makeConstraints({ view in
            view.bottom.leading.trailing.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.82)
        })
        imageProfile.snp.makeConstraints({img in
            img.top.equalToSuperview().offset(25)
            img.centerX.equalToSuperview()
            img.height.width.equalTo(120)
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
            cv.leading.trailing.bottom.equalToSuperview()
        })
    }
}

extension SettingsVC:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = SecuritySettingsVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            return
        case 2:
            let vc = MyAddedPlacesVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = HelpAndSupportVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = AboutUsVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = TermsOfUseVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 20), height: (collectionView.frame.height)*0.12)
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
            cell.getSettingCollectionData(imageIconString: "map", imageDirectionString: "vektorRight", itemString: "My Added Places")
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

extension SettingsVC: EditProfileVCDelegate {
    func profilePhotoDidUpdate(_ newPhoto: UIImage) {
        imageProfile.image = newPhoto
    }
    func fullNameDidUpdate(_ newName: String) {
        labelNameSurname.text = newName
    }
}


