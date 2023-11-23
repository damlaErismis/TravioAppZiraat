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
    
    private lazy var viewUserName:UIViewCC = {
        let view = UIViewCC(labeltext: "Username", placeholderText: "bilge_adam")
        view.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view.textField.autocapitalizationType = .none
        return view
    }()
    
    private lazy var viewEmail:UIViewCC = {
        let view = UIViewCC(labeltext: "Email", placeholderText: "developer@bilgeadam.com")
        view.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view.textField.autocapitalizationType = .none
        return view
        
    }()
    
    private lazy var viewPassword:UIViewCC = {
        let view = UIViewCC(labeltext: "Password", placeholderText: "********")
        view.textField.isSecureTextEntry = true
        view.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return view
    }()
    
    private lazy var viewPasswordConfirm:UIViewCC = {
        let view = UIViewCC(labeltext: "Password Confirm", placeholderText: "********", isStatusImageViewVisible: true)
        view.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view.textField.autocapitalizationType = .none
        view.textField.isSecureTextEntry = true
        return view
    }()
    
    private lazy var stackView:UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 24
        sv.distribution = .fillProportionally
        return sv
    }()
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }

    private lazy var buttonSignup:UIButton = {
        let btn = UIButton()
        btn.setTitle("Sign Up", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .lightGray
        btn.layer.cornerRadius = 12
        btn.addTarget(self, action: #selector(btnSignUpTapped), for: .touchUpInside)
        return btn
    }()
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == viewPassword.textField || textField == viewPasswordConfirm.textField {
            let usernameText = viewUserName.textField.text ?? ""
            let emailText = viewEmail.textField.text ?? ""
            let passwordText = viewPassword.textField.text ?? ""
            let passwordConfirmText = viewPasswordConfirm.textField.text ?? ""
            
            if textField == viewPasswordConfirm.textField{
                let passwordsMatch = passwordText == passwordConfirmText && passwordConfirmText.count >= 6
                viewPasswordConfirm.showPasswordMatched(passwordsMatch)
            }
            let passwordsMatch = passwordText == passwordConfirmText
            
            isFormComplete = !usernameText.isEmpty && !emailText.isEmpty && !passwordText.isEmpty && !passwordConfirmText.isEmpty && passwordsMatch
            

            buttonSignup.isEnabled = isFormComplete
            buttonSignup.backgroundColor = isFormComplete ?.mainColor : .lightGray
        }
    }
    
    @objc func btnSignUpTapped(){
        guard let textUsername = viewUserName.textField.text else{return}
        guard let textEmail = viewEmail.textField.text else{return}
        guard let textPassword = viewPassword.textField.text else{return}
        viewModel.postSignUpData(userName: textUsername, email: textEmail, password: textPassword)
        
        viewModel.showAlertClosure = { [weak self] in
            if let message = self?.viewModel.alertMessage {
                self?.showAlert(title: "Alert!", message: message)
            }
        }
    }
    private func configureView(){
        labelTitle.text = "Sign Up"
        imageBack.image = UIImage(named: "vector")
        self.viewMain.backgroundColor = .viewColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        imageBack.addGestureRecognizer(tap)
    }
    
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
    
    private func setupViews() {
        self.navigationItem.leftBarButtonItem = createLeftBarButton()
        self.view.backgroundColor = .mainColor
        viewMain.addSubviews(stackView, buttonSignup)
        stackView.addArrangedSubviews(viewUserName, viewEmail, viewPassword, viewPasswordConfirm)
        setupLayouts()
    }

    private func createLeftBarButton() -> UIBarButtonItem {
        let image = UIImage(named: "vector")
        let leftBarButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        leftBarButton.tintColor = .white
        return leftBarButton
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

