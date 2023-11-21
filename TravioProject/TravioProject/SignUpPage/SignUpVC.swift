//
//  SignUpVC.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 25.10.2023.
//

import UIKit
import SnapKit

class SignUpVC: UIViewController {
    
    private var viewModel = SignUpViewModel()
    
    private var isFormComplete: Bool = false
    
    private lazy var viewMain:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "F8F8F8")
        view.layer.cornerRadius = 75
        view.layer.maskedCorners = [.topLeft]
        return view
    }()
    
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
    private lazy var btnBack: UIButton = {
        let image = UIImage(named: "vector")
        let btn = UIButton()
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private lazy var labelSignUp:UILabelCC = {
        let lbl = UILabelCC(labelText: "Sign Up", font: .poppinsBold36)
        lbl.textColor = .white
        return lbl
    }()

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
    
    func initVM(){
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
        setupView()
        initView()
        initVM()
    }
    
    private func setupView() {
        
        self.navigationItem.leftBarButtonItem = createLeftBarButton()
        
        self.view.backgroundColor = .mainColor
        self.view.addSubviews(viewMain, labelSignUp, btnBack)
        viewMain.addSubviews(stackView, buttonSignup)
        stackView.addArrangedSubviews(viewUserName, viewEmail, viewPassword, viewPasswordConfirm)
        setupLayout()
    }

    
    func initView(){
        setupView()
    }

    private func createLeftBarButton() -> UIBarButtonItem {
        let image = UIImage(named: "vector")
        let leftBarButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        leftBarButton.tintColor = .white
        return leftBarButton
    }
    
    private func setupLayout() {
        btnBack.snp.makeConstraints({ btn in
            btn.top.equalTo(labelSignUp).offset(15)
            btn.leading.equalToSuperview().offset(25)
            btn.width.equalTo(25)
            btn.height.equalTo(25)
        })
        
        labelSignUp.snp.makeConstraints({ img in
            img.top.equalToSuperview().offset(55)
            img.centerX.equalToSuperview()
            img.leading.equalTo(btnBack.snp.trailing).offset(30)
            img.height.equalTo(52)
            img.width.equalTo(150)
        })
        
        viewMain.snp.makeConstraints({ view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.80)
        })
        
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

//#if DEBUG
//import SwiftUI
//
//@available(iOS 13, *)
//struct SignUpVC_Preview: PreviewProvider {
//    static var previews: some View{
//        
//        SignUpVC().showPreview()
//    }
//}
//#endif
