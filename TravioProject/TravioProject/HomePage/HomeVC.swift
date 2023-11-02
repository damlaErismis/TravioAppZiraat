//
//  
//  HomeVCVC.swift
//  TravioProject
//
//  Created by Burak Özer on 25.10.2023.
//
//
import UIKit
import SnapKit

class HomeVC: UIViewController {
    
    var viewModel = HomeVM()
    
    //MARK: -- Properties
    
    
    //MARK: -- Views
    
    private lazy var imageLogo:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "homeLogo")
        return img
        
    }()
    private lazy var viewMain:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "F8F8F8")
        view.layer.cornerRadius = 75
        view.layer.maskedCorners = [.topLeft]
        return view
    }()
    private lazy var tableView:UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.separatorColor = .white
        tv.delegate = self
        tv.dataSource = self
        tv.register(HomeTableCell.self, forCellReuseIdentifier: "tableCell")
        tv.isPagingEnabled = true
        tv.layer.cornerRadius = 50
        tv.layer.maskedCorners = [.topLeft]
        return tv
    }()
    //MARK: -- Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setupViews()
       
    }
    
    //MARK: -- Component Actions
    
    
    //MARK: -- Private Methods
    
    
    //MARK: -- UI Methods
    func setupViews() {
        // Add here the setup for the UI

        self.view.backgroundColor = UIColor(hexString: "#38ada9")
        self.view.addSubviews(imageLogo, viewMain)
        self.viewMain.addSubviews(tableView)
        setupLayout()
    }
    
    func setupLayout() {
        
        imageLogo.snp.makeConstraints({ img in
            img.bottom.equalTo(viewMain.snp.top).offset(-28)
            img.leading.equalToSuperview().offset(16)
            img.height.equalTo(62)
            img.width.equalTo(171)
        })
        viewMain.snp.makeConstraints({ view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.80)
        })
        
        tableView.snp.makeConstraints({cv in
            cv.top.equalToSuperview().offset(30)
            cv.leading.equalToSuperview()
            cv.trailing.equalToSuperview()
            cv.bottom.equalToSuperview()
        })
    }
}
extension HomeVC:UITableViewDelegate{
    
    internal func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Popular Places"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let lbl = UILabel()
        lbl.frame = CGRect(x: 25, y: 10, width: 149, height: 30)
        lbl.font = UIFont(name: "Poppins-Regular", size: 20)
        lbl.text = self.tableView(tableView, titleForHeaderInSection: section)
        tableView.backgroundColor = UIColor(hexString: "F8F8F8")

        let btn = UIButton()
        btn.setTitle("See All", for: .normal)
        btn.setTitleColor(UIColor(hexString: "#17C0EB"), for: .normal)
        btn.frame = CGRect(x: 265, y: 10, width: 149, height: 30)
        btn.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 14)
    
        
        var headerView = UIView()
        headerView.addSubviews(lbl, btn)
    

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}

extension HomeVC:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! HomeTableCell
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        cell.collectionView.reloadData()

        return cell
 
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomContactTable
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
      }

}



