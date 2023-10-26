//
//  SignUpVC.swift
//  TravioProject
//
//  Created by Burak Özer on 15.10.2023.
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
    
    private lazy var labelSignUp:UILabelCC = {
        let lbl = UILabelCC(labelText: "Sign Up", font: .poppinsBold36)
        lbl.textColor = .white
        return lbl
    }()
    
    private lazy var labelUsername = UILabelCC(labelText: "Username", font: .poppinsRegular14)
    private lazy var labelEmail = UILabelCC(labelText: "Email", font: .poppinsRegular14)
    private lazy var labelPassword = UILabelCC(labelText: "Password", font: .poppinsRegular14)
    private lazy var labelPasswordConfirm = UILabelCC(labelText: "Password Confirm", font: .poppinsRegular14)
    
    private lazy var viewEmail = UIViewCC()
    private lazy var viewUsername = UIViewCC()
    private lazy var viewPassword = UIViewCC()
    private lazy var viewPasswordConfirm = UIViewCC()
    
    private lazy var textFieldUsername:UITextFieldCC = {
        let txt = UITextFieldCC(placeholderText: "bilge_adam")
        txt.delegate = self
        return txt
    }()
    private lazy var textFieldEmail:UITextFieldCC = {
        let txt = UITextFieldCC(placeholderText: "developer@bilgeadam.com")
        txt.delegate = self
        return txt
    }()
    private lazy var textFieldPassword:UITextFieldCC  = {
        let txt = UITextFieldCC(placeholderText: "")
        txt.delegate = self
        return txt
    }()
    private lazy var textFieldPasswordConfirm:UITextFieldCC = {
        let txt = UITextFieldCC(placeholderText: "")
        txt.delegate = self
        return txt
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
    
    @objc func btnSignUpTapped(){
        guard let textUsername = textFieldUsername.text else{return}
        guard let textEmail = textFieldEmail.text else{return}
        guard let textPassword = textFieldPassword.text else{return}
        viewModel.postSignUpData(userName: textUsername, email: textEmail, password: textPassword)
        
        viewModel.showAlertClosure = { [weak self] in
            if let message = self?.viewModel.alertMessage {
                self?.showAlert(title: "Alert!", message: message)
            }
        }
    }
    
    @objc func backButtonTapped(){
        var login = LoginVC()
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
        
        viewMain.addSubviews(viewUsername, viewEmail, viewPassword, viewPasswordConfirm, buttonSignup)
        viewUsername.addSubviews(labelUsername, textFieldUsername)
        viewEmail.addSubviews(labelEmail, textFieldEmail)
        viewPassword.addSubviews(labelPassword, textFieldPassword)
        viewPasswordConfirm.addSubviews(labelPasswordConfirm, textFieldPasswordConfirm)
        
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
        
        viewUsername.snp.makeConstraints({ view in
            view.top.equalToSuperview().offset(64)
            view.centerX.equalToSuperview()
            view.height.equalTo(74)
            view.width.equalTo(342)
        })
        
        labelUsername.snp.makeConstraints({ label in
            label.top.equalToSuperview().offset(13)
            label.leading.equalToSuperview().offset(13)
            label.trailing.equalToSuperview().offset(-13)
            label.bottom.equalTo(textFieldUsername.snp.top)
        })
        
        textFieldUsername.snp.makeConstraints({ txt in
            txt.bottom.equalToSuperview().offset(-13)
            txt.leading.equalToSuperview().offset(13)
            txt.trailing.equalToSuperview().offset(-13)
            txt.height.equalTo(30)
        })
        
        viewEmail.snp.makeConstraints({ view in
            view.top.equalTo(viewUsername.snp.bottom).offset(24)
            view.centerX.equalToSuperview()
            view.height.equalTo(74)
            view.width.equalTo(342)
        })
        
        labelEmail.snp.makeConstraints({ label in
            label.top.equalToSuperview().offset(13)
            label.leading.equalToSuperview().offset(13)
            label.trailing.equalToSuperview().offset(-13)
            label.bottom.equalTo(textFieldEmail.snp.top)
        })
        
        textFieldEmail.snp.makeConstraints({ txt in
            txt.top.equalTo(labelEmail.snp.bottom)
            txt.bottom.equalToSuperview().offset(-13)
            txt.leading.equalToSuperview().offset(13)
            txt.trailing.equalToSuperview().offset(-13)
            txt.height.equalTo(30)
        })
        
        viewPassword.snp.makeConstraints({ view in
            view.top.equalTo(viewEmail.snp.bottom).offset(24)
            view.centerX.equalToSuperview()
            view.height.equalTo(74)
            view.width.equalTo(342)
        })
        
        labelPassword.snp.makeConstraints({ label in
            label.top.equalToSuperview().offset(13)
            label.leading.equalToSuperview().offset(13)
            label.trailing.equalToSuperview().offset(-13)
            label.bottom.equalTo(textFieldPassword.snp.top)
        })
        
        textFieldPassword.snp.makeConstraints({ txt in
            txt.top.equalTo(labelPassword.snp.bottom)
            txt.bottom.equalToSuperview().offset(-13)
            txt.leading.equalToSuperview().offset(13)
            txt.trailing.equalToSuperview().offset(-13)
            txt.height.equalTo(30)
        })
        
        viewPasswordConfirm.snp.makeConstraints({ view in
            view.top.equalTo(viewPassword.snp.bottom).offset(24)
            view.centerX.equalToSuperview()
            view.height.equalTo(74)
            view.width.equalTo(342)
        })
        
        labelPasswordConfirm.snp.makeConstraints({ label in
            label.top.equalToSuperview().offset(13)
            label.leading.equalToSuperview().offset(13)
            label.trailing.equalToSuperview().offset(-13)
            label.bottom.equalTo(textFieldPasswordConfirm.snp.top)
        })
        
        textFieldPasswordConfirm.snp.makeConstraints({ txt in
            txt.top.equalTo(labelPasswordConfirm.snp.bottom)
            txt.bottom.equalToSuperview().offset(-13)
            txt.leading.equalToSuperview().offset(13)
            txt.trailing.equalToSuperview().offset(-13)
            txt.height.equalTo(30)
        })
        
        buttonSignup.snp.makeConstraints({ btn in
            btn.centerX.equalToSuperview()
            btn.height.equalTo(54)
            btn.width.equalTo(342)
            btn.bottom.equalToSuperview().offset(-30)
        })
    }
}

extension SignUpVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == textFieldUsername || textField == textFieldEmail || textField == textFieldPassword || textField == textFieldPasswordConfirm {
            isFormComplete = !(textFieldUsername.text?.isEmpty ?? true) &&
            !(textFieldEmail.text?.isEmpty ?? true) &&
            !(textFieldPassword.text?.isEmpty ?? true) &&
            !(textFieldPasswordConfirm.text?.isEmpty ?? true)
        }
        
        buttonSignup.isEnabled = isFormComplete
        
        if isFormComplete {
            buttonSignup.backgroundColor = UIColor(hexString: "#38ada9")
        } else {
            buttonSignup.backgroundColor = .lightGray
        }
        return true
    }
}



#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct SignUpVC_Preview: PreviewProvider {
    static var previews: some View{
        
        SignUpVC().showPreview()
    }
}
#endif
