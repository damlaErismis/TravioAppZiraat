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
        let lbl = UILabelCC(labelText: "Welcome to Travio", font: .poppinsRegular24)
        lbl.textAlignment = .center
        return lbl
    }()
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
    
    private lazy var labelPasswordControl:UILabelCC = {
        let lbl = UILabelCC(labelText: "Enter at least 6 characters", font: .poppinsRegular14)
        lbl.textColor = .red
        lbl.isHidden = true
        return lbl
    }()

    private lazy var viewEmail:UIViewCC = {
        let view = UIViewCC(labeltext: "Email", placeholderText: "developer@bilgeadam.com")
        view.textField.delegate = self
        view.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view.textField.autocapitalizationType = .none
        return view
        
    }()
    private lazy var viewPassword:UIViewCC = {
        let view = UIViewCC(labeltext: "Password", placeholderText: "***************")
        view.textField.delegate = self
        view.textField.isSecureTextEntry = true
        view.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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
        setupView()
    }
    func initVM(){
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
                let vc = HomeVC()
                self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField == viewEmail.textField || textField == viewPassword.textField {
            let emailText = viewEmail.textField.text ?? ""
            let passwordText = viewPassword.textField.text ?? ""
            
            isFormComplete = (passwordText.count > 6) && emailText.isValidEmail
            buttonLogin.isEnabled = isFormComplete
            buttonLogin.backgroundColor = isFormComplete ? UIColor(hexString: "#38ada9") : .lightGray
        }
        if textField == viewPassword.textField{
            let passwordText = viewPassword.textField.text ?? ""
            let passwordChracterCountControl = passwordText.count > 6
            labelPasswordControl.isHidden = passwordChracterCountControl
        }
    }
    
    //MARK: -- Private Methods
    
    
    //MARK: -- UI Methods
    private func setupView(){
        self.view.backgroundColor = UIColor(hexString: "#38ada9")
        self.view.addSubviews(viewMain, imageLogo)
        viewMain.addSubviews(labelWelcome, stackView,  buttonLogin, stackViewSignUp, labelPasswordControl)
        stackView.addArrangedSubviews(viewEmail, viewPassword)
        viewPassword.addSubviews(labelPasswordControl)
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
        labelWelcome.snp.makeConstraints({lbl in
            lbl.top.equalToSuperview().offset(64)
            lbl.centerX.equalToSuperview()
            lbl.height.equalTo(36)
            lbl.width.equalTo(226)
        })
        
        labelPasswordControl.snp.makeConstraints({lbl in
            lbl.bottom.equalToSuperview()
            lbl.leading.equalToSuperview().offset(12)
        })
        stackView.snp.makeConstraints({ sv in
            sv.top.equalTo(labelWelcome.snp.bottom).offset(45)
            sv.leading.equalToSuperview().offset(25)
            sv.trailing.equalToSuperview().offset(-25)
        })
        buttonLogin.snp.makeConstraints({ btn in
            btn.top.equalTo(viewPassword.snp.bottom).offset(48)
            btn.centerX.equalTo(labelWelcome.snp.centerX)
            btn.height.equalTo(54)
            btn.width.equalTo(342)
        })
        stackViewSignUp.snp.makeConstraints({sv in
            sv.bottom.equalToSuperview().offset(-27)
            sv.centerX.equalTo(labelWelcome.snp.centerX)
            sv.width.equalTo(238)
        })
        
    }
}
extension LoginVC:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textPassword = viewPassword.textField.text else{
            return false
        }
        guard let textEmail = viewEmail.textField.text else{
            return false
        }
        if textField == viewPassword.textField {
            buttonLogin.isEnabled = true
            if textPassword.count < 6{
                buttonLogin.isEnabled = false
            }else{
                buttonLogin.isEnabled = true
            }
        }
        if textField == viewEmail.textField{
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
