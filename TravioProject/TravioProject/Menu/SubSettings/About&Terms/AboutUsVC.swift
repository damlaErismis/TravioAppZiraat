
//  AboutUsVCVC.swift
//  TravioProject
//
//  Created by Burak Özer on 14.11.2023.
//
//

import UIKit
import SnapKit
import WebKit

class AboutUsVC: UICustomViewController{
    
    private lazy var webView:WKWebView = {
        let wb = WKWebView()
        wb.layer.cornerRadius = 75
        wb.layer.maskedCorners = [.topLeft]
        wb.layer.masksToBounds = true
        wb.navigationDelegate = self
        return wb
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()

    }
    
    func initView(){
        if let url = URL(string: "https://api.iosclass.live/about") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        labelTitle.text = "About Us"
        imageBack.image = UIImage(named: "vector")
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

extension AboutUsVC: WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        increaseFontSizeForAllH1()
        injectFontStyle()
    }
    
    func increaseFontSizeForAllH1() {
        let fontName = "Poppins-Bold"
        let h1FontSize = 36
        let jsCode = """
             var h1Basliklar = document.getElementsByTagName('h1');
             for (var i = 0; i < h1Basliklar.length; i++) {
             h1Basliklar[i].style.fontSize = '\(h1FontSize)px';
             h1Basliklar[i].style.fontFamily = '\(fontName)';
        }
        """
        webView.evaluateJavaScript(jsCode)
    }
    
    func injectFontStyle() {
        let fontName = "Poppins-Regular"
        let fontSize = 18
        let jsCode = """
             var style = document.createElement('style');
             style.innerHTML = 'body, p, li { font-family: \(fontName), sans-serif !important; font-size: \(fontSize)px !important; }';
             document.head.appendChild(style);
         """
        webView.evaluateJavaScript(jsCode)
    }
}
