//
//
//  VisitsVC.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 27.10.2023.
//
//
import UIKit
import TinyConstraints
import SnapKit

struct Images {
    var image:UIImage?
}

class VisitsVC: UIViewController {
    
    var images: [Images] = [
        Images(image: UIImage(named: "suleymaniye")),
        Images(image: UIImage(named: "suleymaniye")),
        Images(image: UIImage(named: "suleymaniye")),
        Images(image: UIImage(named: "suleymaniye")),
        Images(image: UIImage(named: "suleymaniye"))
    ]
    private lazy var viewMain:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "F8F8F8")
        view.layer.cornerRadius = 75
        view.layer.maskedCorners = [.topLeft]
        return view
    }()
    
    private lazy var tableView:UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.register(VisitsCustomCell.self, forCellReuseIdentifier: "customCell")
        tv.separatorStyle = .none
        return tv
    }()
    private lazy var labelMyVisits:UILabelCC = {
        let lbl = UILabelCC(labelText: "My Visits", font: .poppinsBold36)
        lbl.textColor = .white
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews(){
        
        self.view.addSubviews(viewMain, labelMyVisits)
        self.view.backgroundColor = UIColor(hexString: "#38ada9")
        viewMain.addSubview(tableView)
        setupLayout()
    }
    
    private func setupLayout(){

        labelMyVisits.snp.makeConstraints({ img in
            img.top.equalToSuperview().offset(55)
            img.centerX.equalToSuperview()
            img.height.equalTo(52)
            img.width.equalTo(165)
            img.leading.equalToSuperview().offset(40)
        })
        
        viewMain.snp.makeConstraints({ view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.80)
        })
        tableView.snp.makeConstraints({view in
            view.bottom.equalTo(self.viewMain.safeAreaLayoutGuide)
            view.top.equalToSuperview().offset(40)
            view.leading.equalToSuperview().offset(10)
            view.trailing.equalToSuperview().offset(-10)
            view.height.equalToSuperview()
        })
    }
    
}

extension VisitsVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 250
        }else {
            return 100
        }
    }
    
}

extension VisitsVC:UITableViewDataSource {
    
    //MARK: -- Kaç tane section olacağını belirler.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: -- Her bir section içinde kaç adet cell olacağına karar verir.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return images.count
        
    }
    
    
    //MARK: -- Her bir satıra denk gelen cell'lerin hangisi olacağı ve veri kaynağını belirler
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! VisitsCustomCell
        
        let object = images[indexPath.row]
        cell.configure(object: object)
        
        return cell
        
    }
}
