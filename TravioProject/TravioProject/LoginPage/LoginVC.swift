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
    
    private lazy var viewEmaill:UIViewCC = {
        let view = UIViewCC(labeltext: "deneme", placeholderText: "deneme")
        return view
        
    }()
    
    
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
        
        
        txt.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        txt.autocapitalizationType = .none
        
        txt.delegate = self
        return txt
    }()
    private lazy var textFieldPassword:UITextFieldCC = {
        let txt = UITextFieldCC(placeholderText: "*************")
        txt.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        txt.isSecureTextEntry = true
        txt.delegate = self
        return txt
    }()
    
    private lazy var labelPasswordControl:UILabelCC = {
        let lbl = UILabelCC(labelText: "En az 6 karakter giriniz", font: .poppinsRegular14)
        lbl.textColor = .red
        lbl.isHidden = true
        return lbl
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
        
        initView()
        initVM()
    }
    
    func initView(){
        setupView()
    }
    func initVM(){
        vm.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.vm.alertMessage {
                    self?.showAlert(title: "Invalid Password/Email ", message: message)
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
        guard let textEmail = textFieldEmail.text else{return}
        guard let textPassword = textFieldPassword.text else{return}
      
        vm.postLoginData(email:textEmail , password: textPassword)
        vm.makeLogin = { [weak self] () in
                let vc = HomeVC()
                self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        
        if textField == textFieldPassword || textField == textFieldEmail {
            
            let emailText = textFieldEmail.text ?? ""
            let passwordText = textFieldPassword.text ?? ""
            isFormComplete = (passwordText.count > 6) && emailText.isValidEmail
            buttonLogin.isEnabled = isFormComplete
            buttonLogin.backgroundColor = isFormComplete ? UIColor(hexString: "#38ada9") : .lightGray
            
        }
        if textField == textFieldPassword{
            let passwordText = textFieldPassword.text ?? ""
            let passwordChracterCountControl = passwordText.count > 6
            labelPasswordControl.isHidden = passwordChracterCountControl
        }
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
        viewMain.addSubviews(labelWelcome, viewEmaill, viewEmail, viewPassword, buttonLogin, stackViewSignUp, labelPasswordControl)
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
        
        viewEmaill.snp.makeConstraints({view in
            
            view.top.equalTo(labelWelcome.snp.bottom).offset(40)
            view.centerX.equalTo(labelWelcome.snp.centerX)
            view.height.equalTo(74)
            view.width.equalTo(342)
            
        })
        
        viewEmail.snp.makeConstraints({ view in
            view.top.equalTo(viewEmaill.snp.bottom).offset(40)
            view.centerX.equalTo(viewEmaill.snp.centerX)
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
        
        labelPasswordControl.snp.makeConstraints({lbl in
            lbl.top.equalTo(labelPassword.snp.bottom).offset(14)
            lbl.leading.equalTo(labelPassword)
            
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
            if textPassword.count < 6{
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
