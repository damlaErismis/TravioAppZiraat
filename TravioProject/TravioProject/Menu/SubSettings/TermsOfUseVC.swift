//
//  TermsOfUseVC.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 21.11.2023.
//

import UIKit
import SnapKit
import WebKit

class TermsOfUseVC: UICustomViewController {
    
    private lazy var webView:WKWebView = {
        let wb = WKWebView()
        wb.layer.cornerRadius = 75
        wb.layer.maskedCorners = [.topLeft]
        wb.layer.masksToBounds = true
        return wb
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: "https://api.iosclass.live/terms") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        self.navigationController?.navigationBar.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        navigationController?.isNavigationBarHidden = true
        labelTitle.text = "Terms of Use"
        imageBack.image = UIImage(named: "Vector")
        self.viewMain.backgroundColor = .viewColor
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
        webView.snp.makeConstraints({ wb in
            wb.top.equalToSuperview()
            wb.leading.equalToSuperview()
            wb.trailing.equalToSuperview()
            wb.bottom.equalToSuperview()
            
        })
    }
}
