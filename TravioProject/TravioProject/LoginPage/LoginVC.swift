//
//  LoginVC.swift
//  TravioProject
//
//  Created by Burak Özer on 13.10.2023.
//

import UIKit
import SnapKit

class LoginVC: UIViewController {
    
    //MARK: -- Properties
    
    private lazy var vm:LoginVM = {
        return LoginVM()
    }()
    
    private var isFormComplete: Bool = false
    
    //    MARK: -- Views
    
    private lazy var imageLogo:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "travio")
        return img
        
    }()
    
    private lazy var labelWelcome:UILabelCC = {
        let lbl = UILabelCC(labelText: "Welcome to Travio", font: .poppinsMedium24)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .black
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var labelSuggestion = UILabelCC(labelText: "Don’t have any account?", font: .poppinsSemiBold14)
    
    private lazy var buttonLogin:UIButton = {
        let btn = UIButton()
        btn.setTitle("Login", for: .normal)
        btn.titleLabel?.font = FontStatus.poppinsSemiBold16.defineFont
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .lightGray
        btn.layer.cornerRadius = 12
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return btn
    }()
    
    private lazy var buttonSignUp:UIButton = {
        let btn = UIButton()
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = FontStatus.poppinsSemiBold14.defineFont
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return btn
    }()
    
    private lazy var viewMain:UIView = {
        let view = UIView()
        view.backgroundColor = .viewColor
        view.layer.cornerRadius = 75
        view.layer.maskedCorners = [.topLeft]
        return view
    }()
    
    private lazy var viewEmail:UIViewCC = {
        let view = UIViewCC(labeltext: "Email", placeholderText: "developer@bilgeadam.com")
        view.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view.textField.autocapitalizationType = .none
        return view
    }()
    
    private lazy var viewPassword:UIViewCC = {
        let view = UIViewCC(labeltext: "Password", placeholderText: "***************", isStatusImageViewVisible: true)
        view.textField.isSecureTextEntry = true
        view.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view.statusImageView.image = UIImage(systemName: "eye.slash.fill")
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handlePasswordLongPress(_:)))
        view.addGestureRecognizer(longPressGesture)
        return view
    }()
    
    private lazy var stackViewSignUp:UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 2
        sv.distribution = .fillProportionally
        return sv
    }()
    
    private lazy var stackView:UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 24
        sv.distribution = .fillProportionally
        return sv
    }()
    
    //MARK: -- Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initVM()
    }
    
    func initView(){
        navigationController?.navigationBar.isHidden = true
        setupView()
    }
    
    func initVM(){
        vm.updateLoadingStatus = { [weak self] (status) in
            DispatchQueue.main.async {
                if status {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
        vm.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.vm.errorStatusMessage?.message, let title = self?.vm.errorStatusMessage?.status {
                    self?.showAlert(title:title, message: message)
                }
            }
        }
    }
    
    //MARK: -- Component Actions
    
    @objc func handleSignUp(){
        let vc = SignUpVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleLogin(){
        guard let textEmail = viewEmail.textField.text else{return}
        guard let textPassword = viewPassword.textField.text else{return}
        vm.postLoginData(email:textEmail , password: textPassword)
        vm.makeLogin = { [weak self] () in
                let vc = MainTabBar()
                self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == viewEmail.textField || textField == viewPassword.textField {
            let emailText = viewEmail.textField.text ?? ""
            let passwordText = viewPassword.textField.text ?? ""
            isFormComplete = (passwordText.count >= 6) && emailText.isValidEmail && !passwordText.isEmpty && !emailText.isEmpty
            buttonLogin.isEnabled = isFormComplete
            buttonLogin.backgroundColor = isFormComplete ? .mainColor : .lightGray
        }
    }
    
    @objc func handlePasswordLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            viewPassword.statusImageView.image = UIImage(systemName: "eye.fill")
            viewPassword.textField.isSecureTextEntry = false
        } else if gesture.state == .ended {
            viewPassword.statusImageView.image = UIImage(systemName: "eye.slash.fill")
            viewPassword.textField.isSecureTextEntry = true
        }
    }
    
    //MARK: -- UI Methods
    private func setupView(){
        self.view.backgroundColor = .mainColor
        self.view.addSubviews(viewMain, imageLogo, activityIndicator)
        viewMain.addSubviews(labelWelcome, stackView,  buttonLogin, stackViewSignUp)
        stackView.addArrangedSubviews(viewEmail, viewPassword)

        stackViewSignUp.addArrangedSubviews(labelSuggestion, buttonSignUp)
        setupLayout()
    }
    
    private func setupLayout(){
        
        activityIndicator.snp.makeConstraints({ai in
            ai.edges.equalToSuperview()
        })
        
        imageLogo.snp.makeConstraints({ img in
            img.top.equalToSuperview().offset(50)
            img.centerX.equalToSuperview()
            img.height.equalToSuperview().multipliedBy(0.2)
            img.width.equalToSuperview().multipliedBy(0.34)
        })
        viewMain.snp.makeConstraints({ view in
            view.bottom.leading.trailing.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.70)
        })
        labelWelcome.snp.makeConstraints({lbl in
            lbl.top.equalToSuperview().offset(64)
            lbl.centerX.equalToSuperview()
            lbl.height.equalTo(36)
        })
        stackView.snp.makeConstraints({ sv in
            sv.top.equalTo(labelWelcome.snp.bottom).offset(45)
            sv.leading.trailing.equalToSuperview().inset(25)
        })
        buttonLogin.snp.makeConstraints({ btn in
            btn.top.equalTo(viewPassword.snp.bottom).offset(48)
            btn.leading.trailing.equalToSuperview().inset(25)
            
            btn.height.equalTo(54)
        })
        stackViewSignUp.snp.makeConstraints({sv in
            sv.bottom.equalToSuperview().offset(-20)
            sv.centerX.equalTo(labelWelcome.snp.centerX)
            sv.width.equalTo(238)
        })
        
    }
}
