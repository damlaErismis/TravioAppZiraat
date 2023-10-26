//
//  LoginVC.swift
//  TravioProject
//
//  Created by Burak Özer on 13.10.2023.
//

import UIKit
import SnapKit
import Alamofire

class LoginVC: UIViewController {
    
    //MARK: -- Properties
    
    var loginResponse:LoginResponse?
    
    
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
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
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
    private lazy var textFieldEmail: UITextFieldCC = {
        let txt = UITextFieldCC(placeholderText: "developer@bilgeadam.com")
        txt.delegate = self
        return txt
    }()
    private lazy var textFieldPassword:UITextFieldCC = {
        let txt = UITextFieldCC(placeholderText: "*************")
        txt.isSecureTextEntry = true
        txt.delegate = self
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
    
    @objc func handleLogin(){
        
        let params = [
            "email": textFieldEmail.text,
            "password": textFieldPassword.text
            ]
        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .login(params: params as Parameters), callback: { [self](result: Result<LoginResponse,Error>) in
            
            switch result {
            case .success(let success):
                self.loginResponse = success
                let vc = HomeVC()
                self.navigationController?.pushViewController(vc, animated: true)
            case .failure(let failure):
                showAlert(title: "Wrong Password!", message: failure.localizedDescription)
            }
        })
    }
    
    //MARK: -- Private Methods
    private func showAlert(title:String, message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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

extension LoginVC:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textPassword = textFieldPassword.text else{
            return false
        }
        guard let textEmail = textFieldEmail.text else{
            return false
        }
        if textField == textFieldPassword {
            buttonLogin.isEnabled = true
            if textPassword.count < 6 || textPassword.count > 8 {
                buttonLogin.isEnabled = false
            }else{
                buttonLogin.isEnabled = true
            }
        }
        if textField == textFieldEmail{
            buttonLogin.isEnabled = true
            if textEmail.isValidEmail {
                buttonLogin.isEnabled = true
            }else{
                buttonLogin.isEnabled = false
            }
        }
        return true
    }
}
