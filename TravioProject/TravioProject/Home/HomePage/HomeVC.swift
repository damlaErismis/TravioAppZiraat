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
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.separatorColor = .white
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = UIColor(hexString: "F8F8F8")
        tv.register(HomeTableCell.self, forCellReuseIdentifier: "tableCell")
        tv.isPagingEnabled = true
        tv.layer.cornerRadius = 75
        tv.layer.maskedCorners = [.topLeft]
        tv.layer.addShadow(color: UIColor(hexString: "#ff2400"), opacity: 0.8, offset: CGSize(width: 5, height: 5), radius: 5)
        return tv
    }()
    
    //MARK: -- Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        viewModel.delegate = self
        setupViews()
        viewModel.getPopularPlaces()
    }
    
    
    //MARK: -- UI Methods
    func setupViews() {
        self.view.backgroundColor = .mainColor
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
            cv.top.equalToSuperview()
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
        let headerView = UIView()
        
        let lbl = VerticalAlignedLabel()
        lbl.contentMode = .bottom
        lbl.font = UIFont(name: "Poppins-Regular", size: 20)
        lbl.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        let btn = UIButton(type: .system)
        btn.setTitle("See All", for: .normal)
        btn.titleLabel?.numberOfLines = 2
        btn.titleLabel?.lineBreakMode = .byWordWrapping
        btn.contentVerticalAlignment = .bottom
        btn.setTitleColor(.textButtonColor, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 14)
        btn.addTarget(self, action: #selector(btnSeeAllTapped), for: .touchUpInside)
        btn.tag = section
        
        headerView.addSubviews(lbl, btn)
        lbl.snp.makeConstraints { make in
            make.leading.equalTo(headerView).offset(25)
            make.top.equalTo(headerView).offset(15)
            make.bottom.equalTo(headerView)
        }
        btn.snp.makeConstraints { make in
            make.trailing.equalTo(headerView).offset(-20)
            make.top.equalTo(headerView).offset(10)
            make.bottom.equalTo(headerView)
        }
        
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
        if section==0{
            return 80
        }else{
            return 40
        }
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
            case .newPlaces:
                cell.prepareCategory(with: viewModel.newPlaces)
            case .myAddedPlaces:
                cell.prepareCategory(with: viewModel.myAddedPlaces)
            }
            
            cell.onItemSelect = { [weak self] itemIndexPath in
                guard let strongSelf = self else { return }
                var selectedID: String?
                cell.onItemSelect = { [weak self] itemIndexPath in
                    guard let strongSelf = self else { return }
                    var selectedID: String?
                    switch strongSelf.viewModel.tableSection[indexPath.section] {
                    case .popularPlaces:
                        selectedID = strongSelf.viewModel.popularPlaces[itemIndexPath.row].id
                    case .newPlaces:
                        selectedID = strongSelf.viewModel.newPlaces[itemIndexPath.row].id
                    case .myAddedPlaces:
                        selectedID = strongSelf.viewModel.myAddedPlaces[itemIndexPath.row].id
                    }
                    
                    if let id = selectedID {
                        let vc = PlaceDetailVC()
                        vc.selectedID = id
                        strongSelf.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
                if let id = selectedID {
                    let vc = PlaceDetailVC()
                    vc.selectedID = id
                    strongSelf.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            return cell
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
