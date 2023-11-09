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
    
    
    //MARK: -- Properties
    var viewModel = HomeVM()
    
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
        let tv = UITableView()
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
        viewModel.delegate = self
        setupViews()
        viewModel.getPopularPlaces()
//        viewModel.getNewPlaces()
//        viewModel.getMyAddedPlaces()
        
    }
    
    
    //MARK: -- UI Methods
    func setupViews() {
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
        switch viewModel.tableSection[section] {
        case .popularPlaces:
            return "Popular Places"
        case .newPlaces:
            return "New Places"
        case .myAddedPlaces:
            return "My Added Places"
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lbl = UILabel()
        lbl.frame = CGRect(x: 25, y: 10, width: 180, height: 30)
        lbl.font = UIFont(name: "Poppins-Regular", size: 20)
        lbl.text = self.tableView(tableView, titleForHeaderInSection: section)
        tableView.backgroundColor = UIColor(hexString: "F8F8F8")

        let btn = UIButton()
        btn.setTitle("See All", for: .normal)
        btn.setTitleColor(UIColor(hexString: "#17C0EB"), for: .normal)
        btn.frame = CGRect(x: view.frame.width - 120, y: 10, width: 149, height: 30)
        btn.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 14)
        btn.addTarget(self, action: #selector(btnSeeAllTapped), for: .touchUpInside)
        btn.tag = section

        let headerView = UIView()
        headerView.addSubviews(lbl, btn)

        return headerView
    }

    @objc func btnSeeAllTapped(sender: UIButton) {
        switch sender.tag {
        case 0:
            let popPlaces = PopularPlacesVC()
            self.navigationController?.pushViewController(popPlaces, animated: true)
        case 1:
            let newPlaces = NewPlacesVC()
            self.navigationController?.pushViewController(newPlaces, animated: true)
        case 2:
            let myAddedPlaces = MyAddedPlacesVC()
            self.navigationController?.pushViewController(myAddedPlaces, animated: true)
        default:
            break
        }
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
        return viewModel.tableSection.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.tableSection[section] {
        case .popularPlaces:
            return 1
        case .newPlaces:
            return 1
        case .myAddedPlaces:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as? HomeTableCell {
            switch viewModel.tableSection[indexPath.section] {
            case .popularPlaces:
                cell.prepareCategory(with: viewModel.popularPlaces)
                return cell
            case .newPlaces:
                cell.prepareCategory(with: viewModel.newPlaces)
                return cell
            case .myAddedPlaces:
                cell.prepareCategory(with: viewModel.myAddedPlaces)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    

    
}

extension HomeVC: HomeViewModelDelegate {
    func reloadTableView() {
        self.tableView.reloadData()
    }
}

//extension UIApplication {
//    public class func topViewController(base: UIViewController? =
//        UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
//        if let nav = base as? UINavigationController {
//            return topViewController(base: nav.visibleViewController)
//        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
//            return topViewController(base: selected)
//        } else if let presented = base?.presentedViewController {
//            return topViewController(base: presented)
//        }
//        return base
//    }
//}
