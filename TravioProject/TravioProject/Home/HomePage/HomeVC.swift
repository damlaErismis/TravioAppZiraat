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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .black
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var viewMain:UIView = {
        let view = UIView()
        view.backgroundColor = .viewColor
        view.layer.cornerRadius = 75
        view.layer.maskedCorners = [.topLeft]
        return view
    }()
    
    private lazy var tableView:UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.separatorColor = .white
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .viewColor
        tv.register(HomeTableCell.self, forCellReuseIdentifier: "tableCell")
        tv.isPagingEnabled = true
        tv.layer.cornerRadius = 75
        tv.layer.maskedCorners = [.topLeft]
        tv.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
        return tv
    }()

    
    
    
    //MARK: -- Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        viewModel.onReloadData = { [weak self] in
            self?.tableView.reloadData()
        }
        setupViews()
        initVM()
        viewModel.fetchDataDispatch()
    }
    
    func initVM() {
        viewModel.updateLoadingStatus = { [weak self] (staus) in
            DispatchQueue.main.async {
                if staus {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    @objc func btnSeeAllTapped(sender: UIButton) {
        let sectionType = viewModel.tableSection[sender.tag]
        var viewController: UIViewController?
        
        switch sectionType {
        case .popularPlaces:
            viewController = PopularPlacesVC()
        case .newPlaces:
            viewController = NewPlacesVC()
        case .myAddedPlaces:
            viewController = MyAddedPlacesVC()
        }
        
        if let viewController = viewController {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    //MARK: -- UI Methods
    func setupViews() {
        self.view.backgroundColor = .mainColor
        self.view.addSubviews(imageLogo, viewMain, activityIndicator)
        self.viewMain.addSubviews(tableView)
        setupLayout()
    }
    
    func setupLayout() {
        activityIndicator.snp.makeConstraints({ai in
            ai.edges.equalToSuperview()
        })
        
        imageLogo.snp.makeConstraints({ img in
            img.bottom.equalTo(viewMain.snp.top).offset(-28)
            img.leading.equalToSuperview().offset(16)
            img.height.equalTo(60)
            img.width.equalTo(170)
        })
        viewMain.snp.makeConstraints({ view in
            view.leading.trailing.bottom.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.80)
        })
        tableView.snp.makeConstraints({cv in
            cv.edges.equalToSuperview()
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
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as? CustomHeaderView else {
            return nil
        }
        guard let title = self.tableView(tableView, titleForHeaderInSection: section) else { return nil }
        headerView.configure(title: title, section: section)
        headerView.btnSeeAll.addTarget(self, action: #selector(btnSeeAllTapped), for: .touchUpInside)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section==0{
            return 80
        }else{
            return 40
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 3.5
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
            return cell
        }
        return UITableViewCell()
    }
}

