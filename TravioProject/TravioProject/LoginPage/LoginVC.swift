//
//  LoginVC.swift
//  TravioProject
//
//  Created by Burak Özer on 13.10.2023.
//

import UIKit
import SnapKit
import TinyConstraints

class LoginVC: UIViewController {
    
    //MARK: -- Properties
    
    
    
    //    MARK: -- Views
    private lazy var imageLogo:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "travio")

        return img
        
    }()
    
    private lazy var labelWelcome:UILabelCC = {
        let lbl = UILabelCC(labelText: "Welcome to Travio", font: .poppinsRegular24)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private lazy var labelEmail = UILabelCC(labelText: "Email", font: .poppinsRegular14)
    private lazy var labelPassword = UILabelCC(labelText: "Password", font: .poppinsRegular14)
    private lazy var labelSuggestion = UILabelCC(labelText: "Don’t have any account?", font: .poppinsRegular14)
    
    private lazy var buttonLogin:UIButton = {
        let btn = UIButton()
        btn.setTitle("Login", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(hexString: "#38ada9")
        btn.layer.cornerRadius = 12
        return btn
    }()
    
    private lazy var buttonSignUp:UIButton = {
        let btn = UIButton()
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 14)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return btn
    }()
    
    private lazy var viewMain:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "F8F8F8")
        view.layer.cornerRadius = 75
        view.layer.maskedCorners = [.topLeft]
        return view
    }()
    
    private lazy var viewEmail = UIViewCC()
    private lazy var viewPassword = UIViewCC()
    private lazy var textFieldEmail = UITextFieldCC(placeholderText: "developer@bilgeadam.com")
    private lazy var textFieldPassword:UITextFieldCC = {
        let txt = UITextFieldCC(placeholderText: "*************")
        txt.isSecureTextEntry = true
        return txt
    }()

    private lazy var stackViewSignUp:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        stack.distribution = .fillProportionally
        return stack
    }()
    

    
    //MARK: -- Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView()
    }
    
    //MARK: -- Component Actions
    @objc func handleSignUp(){
        let vc = SignUpVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: -- UI Methods
    private func setupView(){
        self.view.backgroundColor = UIColor(hexString: "#38ada9")
        self.view.addSubviews(viewMain, imageLogo)
        viewMain.addSubviews(labelWelcome,viewEmail, viewPassword, buttonLogin, stackViewSignUp)
        viewEmail.addSubviews(labelEmail, textFieldEmail)
        viewPassword.addSubviews(labelPassword, textFieldPassword)
        stackViewSignUp.addArrangedSubviews(labelSuggestion, buttonSignUp)
        setupLayout()
    }
    
    private func setupLayout(){
        imageLogo.snp.makeConstraints({ img in
            img.top.equalToSuperview().offset(50)
            img.centerX.equalToSuperview()
            img.height.equalTo(178)
            img.width.equalTo(149.0)
        })

        viewMain.snp.makeConstraints({ view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.70)
        })
        
        labelWelcome.snp.makeConstraints({label in
            label.top.equalToSuperview().offset(64)
            label.centerX.equalToSuperview()
            label.height.equalTo(36)
            label.width.equalTo(226)
        })

        viewEmail.snp.makeConstraints({ view in
            view.top.equalTo(labelWelcome.snp.bottom).offset(40)
            view.centerX.equalTo(labelWelcome.snp.centerX)
            view.height.equalTo(74)
            view.width.equalTo(342)
        })
        
        labelEmail.snp.makeConstraints({label in
            label.top.equalToSuperview().offset(13)
            label.leading.equalToSuperview().offset(13)
            label.trailing.equalToSuperview().offset(-13)
            label.bottom.equalTo(textFieldEmail.snp.top)
 
        })
        
        textFieldEmail.snp.makeConstraints({txt in
            txt.bottom.equalToSuperview().offset(-13)
            txt.leading.equalToSuperview().offset(13)
            txt.trailing.equalToSuperview().offset(-13)
            txt.height.equalTo(30)
        })
        
        viewPassword.snp.makeConstraints({ view in
            view.top.equalTo(viewEmail.snp.bottom).offset(24)
            view.centerX.equalTo(labelWelcome.snp.centerX)
            view.height.equalTo(74)
            view.width.equalTo(342)
        })
        
        labelPassword.snp.makeConstraints({label in
            label.top.equalToSuperview().offset(13)
            label.leading.equalToSuperview().offset(13)
            label.trailing.equalToSuperview().offset(-13)
            label.bottom.equalTo(textFieldPassword.snp.top)
        })

        textFieldPassword.snp.makeConstraints({txt in
            txt.top.equalTo(labelPassword.snp.bottom)
            txt.bottom.equalToSuperview().offset(-13)
            txt.leading.equalToSuperview().offset(13)
            txt.trailing.equalToSuperview().offset(-13)
            txt.height.equalTo(30)
        })
        
        buttonLogin.snp.makeConstraints({ btn in
            btn.top.equalTo(viewPassword.snp.bottom).offset(48)
            btn.centerX.equalTo(labelWelcome.snp.centerX)
            btn.height.equalTo(54)
            btn.width.equalTo(342)
        })

        stackViewSignUp.snp.makeConstraints({stack in
            stack.bottom.equalToSuperview().offset(-27)
            stack.centerX.equalTo(labelWelcome.snp.centerX)
            stack.width.equalTo(238)
        })
    }
}

