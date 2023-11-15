//
//  
//  AboutUsVCVC.swift
//  TravioProject
//
//  Created by Burak Özer on 14.11.2023.
//
//

import UIKit
import SnapKit
import WebKit

class AboutUsVC: UICustomViewController {
    
    private lazy var webView:WKWebView = {
        let wb = WKWebView()
        wb.backgroundColor = .red
        wb.layer.cornerRadius = 75
        wb.layer.maskedCorners = [.topLeft]
        return wb
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: "https://iosclass.ams3.digitaloceanspaces.com/1631234567890.jpg") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        labelTitle.text = "About Us"
        imageBack.image = UIImage(named: "Vector")
        buttonAction.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleBack))
        imageBack.addGestureRecognizer(tap)
        setupViews()
    }
    
    @objc func handleBack(){
        navigationController?.popViewController(animated: true)
    }
    
    func setupViews() {
        self.viewMain.addSubviews(webView)
        setupLayouts()
    }
    func setupLayouts() {
        webView.snp.makeConstraints({wb in
            wb.top.equalToSuperview().offset(100)
            wb.trailing.equalToSuperview()
            wb.leading.equalToSuperview()
            wb.bottom.equalToSuperview()
        })
    }
}
