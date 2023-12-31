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

class HelpAndSupportVC: UICustomViewController {
    
    private let data: [HelpAndSupportContent] = [
        HelpAndSupportContent(question: "How can I create a new account on Travio?", answer: "To create a new account on Travio, first visit the Travio website and click on the 'Sign Up' button located at the top right corner of the homepage. You will be directed to a registration form where you need to provide your personal information, including your full name, email address, and a preferred password. After filling out the form, check the box to agree to Travio's terms and conditions, then click the 'Create Account' button. You'll receive a confirmation email shortly."),
        HelpAndSupportContent(question: "How can I save a visit?", answer: "Click on the verification link in the email to activate your Travio account. Once your account is activated, you can start exploring all the features Travio offers for your travel needs. ")
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
    
    private lazy var labelFAQ:UILabelCC = {
        let lbl = UILabelCC(labelText: "FAQ", font: .poppinsSemiBold24)
        lbl.textColor = .mainColor
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()

    func configureView(){
        labelTitle.text = "Help&Support"
        buttonBack.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupViews()
    }
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupViews() {
        navigationController?.navigationBar.isHidden = true
        viewMain.addSubviews(labelFAQ, tableView)
        setupLayouts()
    }
    
    func setupLayouts() {
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
