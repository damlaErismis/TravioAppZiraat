//
//
//  HelpAndSupportVC.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 7.11.2023.
//
//
import UIKit
import TinyConstraints
import SnapKit

struct  HelpAndSupportContent {
    var question: String?
    var answer: String?
}

class HelpAndSupportVC: UIViewController {

   
    private let data: [HelpAndSupportContent] = [
        HelpAndSupportContent(question: "How can I create a new account on Travio?", answer: "her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem "),
        HelpAndSupportContent(question: "How can I save a visit?", answer: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.")
    ]
    
    private lazy var tableView:UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(HelpAndSupportCell.self, forCellReuseIdentifier: "cell")
        tv.separatorStyle = .none
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()

    private lazy var viewMain:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "F8F8F8")
        view.layer.cornerRadius = 75
        view.layer.maskedCorners = [.topLeft]
        return view
    }()
    
    private lazy var labelHelpAndSupport:UILabelCC = {
        let lbl = UILabelCC(labelText: "Help&Support", font: .poppinsBold30)
        lbl.textColor = .white
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    private lazy var labelFAQ:UILabelCC = {
        let lbl = UILabelCC(labelText: "FAQ", font: .poppinsBold24)
        lbl.textColor = UIColor(hexString: "#38ada9")
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    private func createLeftBarButton() -> UIBarButtonItem {
        let image = UIImage(named: "Vector")
        let leftBarButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        leftBarButton.tintColor = .white
        return leftBarButton
    }
    //setting sayfasına gidecek.
    @objc func backButtonTapped(){
        let home = HomeVC()
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
    }
    
    func setupViews() {
        self.navigationItem.leftBarButtonItem = createLeftBarButton()
        self.view.backgroundColor = UIColor(hexString: "#38ada9")
        self.view.addSubviews(viewMain, labelHelpAndSupport)
        viewMain.addSubviews(labelFAQ, tableView)
        setupLayout()
    }
    
    
    func setupLayout() {
        labelHelpAndSupport.snp.makeConstraints ({ img in
            img.top.equalToSuperview().offset(50)
            img.centerX.equalToSuperview()
            img.height.equalTo(52)
            img.width.equalTo(250)
        })

        viewMain.snp.makeConstraints ({ view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.80)
        })
        tableView.snp.makeConstraints ({ make in
            make.top.equalToSuperview().offset(70)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        })
        labelFAQ.snp.makeConstraints({ lbl in
            lbl.top.equalToSuperview().offset(30)
            lbl.leading.equalToSuperview().offset(30)
            lbl.trailing.equalToSuperview().offset(-20)
        })
        

    }
    var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    
}

extension HelpAndSupportVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if selectedIndex == indexPath { return 200 }
            return 80
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data.count
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HelpAndSupportCell
            cell.data = data[indexPath.row]
            cell.selectionStyle = .none
            cell.animate()
            return cell
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [selectedIndex], with: .none)
        tableView.endUpdates()
    }
}
