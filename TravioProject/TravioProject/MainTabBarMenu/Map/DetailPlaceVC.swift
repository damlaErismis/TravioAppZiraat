//
//  
//  DetailPlaceVC.swift
//  LoginPageOdev
//
//  Created by Burak Özer on 30.10.2023.
//
//

import UIKit
import SnapKit
import CoreLocation
class DetailPlaceVC: UIViewController {

    //MARK: -- Properties
    weak var delegate:DataTransferDetailPlaceVCToMapVC?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    //MARK: -- Views

    private lazy var txtPlaceName:UITextField = {
            let tf = UITextField()
            tf.placeholder = "place name"
            tf.autocorrectionType = .no
            tf.autocapitalizationType = .none
            return tf
        }()
        
        private lazy var btnSave:UIButton = {
            let b = UIButton()
            b.setTitle("Kaydet", for: .normal)
            b.setTitleColor(.black, for: .normal)
            b.backgroundColor = .systemBlue
            b.addTarget(self, action: #selector(btnSaveTapped), for: .touchUpInside)
            b.tintColor = .white
            return b
        }()

         @objc func btnSaveTapped(){
             delegate?.getAnnotationInfo(isSaved: true, titlePlace: "Title Place", description: "Description   ddvdvdv")
         }

    //MARK: -- Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -- Component Actions
    
    
    //MARK: -- Private Methods
    
    
    //MARK: -- UI Methods
    func setupViews() {
        // Add here the setup for the UI
        
        self.view.backgroundColor = .white
        self.view.addSubviews(txtPlaceName, btnSave)
        setupLayout()
    }
    
    func setupLayout() {
        
        txtPlaceName.snp.makeConstraints({txt in
            txt.top.equalToSuperview().offset(100)
            txt.centerX.equalToSuperview()
            txt.height.equalTo(50)
            txt.width.equalTo(300)
        })
        
        btnSave.snp.makeConstraints({btn in
            btn.top.equalTo(txtPlaceName.snp.bottom).offset(20)
            btn.centerX.equalToSuperview()
            btn.height.equalTo(50)
            btn.width.equalTo(300)
        })
        
        
       
    }
  
}

