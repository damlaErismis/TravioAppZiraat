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
        let view = UIViewCC(labeltext: "Password Confirm", placeholderText: "********")
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
    
    private lazy var labelPasswordMismatch:UILabelCC = {
        let lbl = UILabelCC(labelText: "Passwords do not match", font: .poppinsRegular14)
        lbl.textColor = .red
        lbl.isHidden = true
        return lbl
    }()
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == viewPassword.textField || textField == viewPasswordConfirm.textField {
            let usernameText = viewUserName.textField.text ?? ""
            let emailText = viewEmail.textField.text ?? ""
            let passwordText = viewPassword.textField.text ?? ""
            let passwordConfirmText = viewPasswordConfirm.textField.text ?? ""
            
            let passwordsMatch = passwordText == passwordConfirmText
            labelPasswordMismatch.isHidden = passwordsMatch
            
            isFormComplete = !usernameText.isEmpty && !emailText.isEmpty && !passwordText.isEmpty && !passwordConfirmText.isEmpty && passwordsMatch
            
            buttonSignup.isEnabled = isFormComplete
            buttonSignup.backgroundColor = isFormComplete ? UIColor(hexString: "#38ada9") : .lightGray
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
    
    @objc func backButtonTapped(){
        let login = LoginVC()
        self.navigationController?.pushViewController(login, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        initView()
        initVM()
    }
    
    private func setupView() {
        
        self.navigationItem.leftBarButtonItem = createLeftBarButton()
        
        self.view.backgroundColor = UIColor(hexString: "#38ada9")
        self.view.addSubviews(viewMain, labelSignUp)
        viewMain.addSubviews(stackView, labelPasswordMismatch, buttonSignup)
        stackView.addArrangedSubviews(viewUserName, viewEmail, viewPassword, viewPasswordConfirm)
        setupLayout()
    }
    private func showAlert(title:String, message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func initView(){
        setupView()
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
    
    private func createLeftBarButton() -> UIBarButtonItem {
        let image = UIImage(named: "Vector")
        let leftBarButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        leftBarButton.tintColor = .white
        return leftBarButton
    }
    
    private func setupLayout() {
        
        labelSignUp.snp.makeConstraints({ img in
            img.top.equalToSuperview().offset(55)
            img.centerX.equalToSuperview()
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
        
        labelPasswordMismatch.snp.makeConstraints({ label in
            label.top.equalTo(viewPasswordConfirm.snp.bottom).offset(8)
            label.leading.equalTo(viewPasswordConfirm.label)
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
