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

class VisitsVC: UIViewController {
    
    lazy var vm: MyVisitsVM = {
        
        return MyVisitsVM()
    }()
    
    private lazy var viewMain:UIView = {
        let view = UIView()
        view.backgroundColor = .viewColor
        view.layer.cornerRadius = 75
        view.layer.maskedCorners = [.topLeft]
        return view
    }()
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 20, right: 0)
        cv.backgroundColor = .clear
        cv.register(VisitsCell.self, forCellWithReuseIdentifier: "collectionCell")
        cv.layer.cornerRadius = 75
        cv.layer.maskedCorners = [.topLeft]
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private lazy var labelMyVisits:UILabel = {
        let lbl = UILabel()
        lbl.text = "My Visits"
        lbl.font = UIFont(name: "Poppins-Bold", size: 36)
        lbl.textColor = .white
        return lbl
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.getMyVisits()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        initVM()
        setupViews()
    }

    private func initVM(){
        vm.reloadCollectionViewForVisits = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    private func setupViews(){
        
        self.view.addSubviews(viewMain, labelMyVisits)
        self.view.backgroundColor = .mainColor
        viewMain.addSubview(collectionView)
        setupLayout()
    }
    
    private func setupLayout(){

        labelMyVisits.snp.makeConstraints({ img in
            img.top.equalToSuperview().offset(55)
            img.centerX.equalToSuperview()
            img.height.equalTo(52)
            img.leading.equalToSuperview().offset(40)
        })
        viewMain.snp.makeConstraints({ view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.80)
        })
        collectionView.snp.makeConstraints({view in
            view.bottom.equalToSuperview()
            view.top.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalToSuperview()
        })
    }
    
}

extension VisitsVC:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedID = vm.visits[indexPath.row].place.id
        let vc = PlaceDetailVC()
        vc.selectedID = selectedID
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 46, height: 219 )
    }
}
extension VisitsVC:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.visits.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! VisitsCell
        cell.configure(with: vm.visits[indexPath.item])
        cell.addShadow(shadowColor: .black, offsetX: 0, offsetY: 0, shadowOpacity: 0.3, shadowRadius: 10)
        return cell
    }
}
