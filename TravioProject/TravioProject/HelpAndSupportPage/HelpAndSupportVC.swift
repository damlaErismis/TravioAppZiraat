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
        HelpAndSupportContent(question: "How can I create a new account on Travio?", answer: "her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem her şeyi ben bilemem"),
        HelpAndSupportContent(question: "How can I save a visit?", answer: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. ")
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
    
    private lazy var btnBack: UIButton = {
        let image = UIImage(named: "btnBack")
        let btn = UIButton()
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor(hexString: "#38ada9")
        navigationController?.navigationBar.isHidden = true
        self.view.addSubviews(viewMain, labelHelpAndSupport, btnBack)
        viewMain.addSubviews(labelFAQ, tableView)
        setupLayout()
    }
    
    func setupLayout() {
        
        btnBack.snp.makeConstraints({ btn in
            btn.top.equalTo(labelHelpAndSupport).offset(15)
            btn.leading.equalToSuperview().offset(25)
            btn.width.equalTo(25)
            btn.height.equalTo(25)
        })
        labelHelpAndSupport.snp.makeConstraints ({ img in
            img.top.equalToSuperview().offset(50)
            img.centerX.equalToSuperview()
            img.leading.equalTo(btnBack.snp.trailing).offset(30)
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
    var selectedIndex: IndexPath = IndexPath(row: -1, section: 0)
}

extension HelpAndSupportVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath { return UITableView.automaticDimension }
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
        let isExpanded = selectedIndex == indexPath
        let previousSelectedIndex = selectedIndex

        if isExpanded {
            selectedIndex = IndexPath(row: -1, section: 0)
        } else {
            selectedIndex = indexPath
        }
        tableView.beginUpdates()
        if let previousCell = tableView.cellForRow(at: previousSelectedIndex) as? HelpAndSupportCell {
            previousCell.updateChevronStatus(isExpanded: false)
            previousCell.animate()
        }
        if let cell = tableView.cellForRow(at: indexPath) as? HelpAndSupportCell {
            cell.updateChevronStatus(isExpanded: !isExpanded)
            cell.animate()
        }
        tableView.endUpdates()
    }

}
