//
//  SignUpVC.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 25.10.2023.
//

import UIKit
import SnapKit

class SignUpVC: UICustomViewController {
    
    private var viewModel = SignUpViewModel()
    
    private var isFormComplete: Bool = false
    
    private lazy var txtUsername:UICustomTextField = {
        let txt = UICustomTextField(labeltext: "Username", placeholderText: "bilge_adam")
        txt.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        txt.textField.autocapitalizationType = .none
        return txt
    }()
    
    private lazy var txtEmail:UICustomTextField = {
        let txt = UICustomTextField(labeltext: "Email", placeholderText: "developer@bilgeadam.com")
        txt.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        txt.textField.autocapitalizationType = .none
        return txt
        
    }()
    
    private lazy var txtPassword:UICustomTextField = {
        let txt = UICustomTextField(labeltext: "Password", placeholderText: "********", isStatusImageViewVisible: true)
        txt.textField.isSecureTextEntry = true
        txt.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        txt.statusImageView.image = UIImage(systemName: "eye.slash.fill")
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handlePasswordLongPress(_:)))
        txt.addGestureRecognizer(longPressGesture)
        return txt
    }()
    
    private lazy var txtPasswordConfirm:UICustomTextField = {
        let txt = UICustomTextField(labeltext: "Password Confirm", placeholderText: "********", isStatusImageViewVisible: true)
        txt.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        txt.textField.autocapitalizationType = .none
        txt.textField.isSecureTextEntry = true
        return txt
    }()
    
    private lazy var stackView:UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 24
        sv.distribution = .fillProportionally
        return sv
    }()

    private lazy var buttonSignup:UIButton = {
        let btn = UIButton()
        btn.setTitle("Sign Up", for: .normal)
        btn.titleLabel?.font = FontStatus.poppinsSemiBold16.defineFont
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .lightGray
        btn.layer.cornerRadius = 12
        btn.addTarget(self, action: #selector(btnSignUpTapped), for: .touchUpInside)
        return btn
    }()
    
    func initVM(){
        viewModel.updateLoadingStatus = { [weak self] (staus) in
            DispatchQueue.main.async {
                if staus {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert(title: "Sign Up Failed ", message: message)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        configureView()
        setupViews()
        initVM()
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
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == txtPassword.textField || textField == txtPasswordConfirm.textField {
            let usernameText = txtUsername.textField.text ?? ""
            let emailText = txtEmail.textField.text ?? ""
            let passwordText = txtPassword.textField.text ?? ""
            let passwordConfirmText = txtPasswordConfirm.textField.text ?? ""
            
            if textField == txtPasswordConfirm.textField{
                let passwordsMatch = passwordText == passwordConfirmText && passwordConfirmText.count >= 6
                txtPasswordConfirm.showPasswordMatched(passwordsMatch)
            }
            let passwordsMatch = passwordText == passwordConfirmText
            
            isFormComplete = !usernameText.isEmpty && !emailText.isEmpty && !passwordText.isEmpty && !passwordConfirmText.isEmpty && passwordsMatch
    
            buttonSignup.isEnabled = isFormComplete
            buttonSignup.backgroundColor = isFormComplete ?.mainColor : .lightGray
        }
    }
    
    @objc func btnSignUpTapped(){
        guard let textUsername = txtUsername.textField.text else{return}
        guard let textEmail = txtEmail.textField.text else{return}
        guard let textPassword = txtPassword.textField.text else{return}
        viewModel.postSignUpData(userName: textUsername, email: textEmail, password: textPassword)
        
        viewModel.showAlertClosure = { [weak self] in
            if let message = self?.viewModel.alertMessage {
                self?.showAlert(title: "Success!", message: message)
            }
        }
    }
    
    private func configureView(){
        labelTitle.text = "Sign Up"
        self.viewMain.backgroundColor = .viewColor
        buttonBack.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupViews() {
        self.view.backgroundColor = .mainColor
        viewMain.addSubviews(stackView, buttonSignup)
        stackView.addArrangedSubviews(txtUsername, txtEmail, txtPassword, txtPasswordConfirm)
        setupLayouts()
    }
    
    private func setupLayouts() {
        stackView.snp.makeConstraints({ sv in
            sv.top.equalToSuperview().offset(65)
            sv.leading.equalToSuperview().offset(25)
            sv.trailing.equalToSuperview().offset(-25)
        })
        
        buttonSignup.snp.makeConstraints({ btn in
            btn.centerX.equalToSuperview()
            btn.height.equalTo(54)
            btn.width.equalTo(342)
            btn.bottom.equalToSuperview().offset(-30)
        })
    }
}

