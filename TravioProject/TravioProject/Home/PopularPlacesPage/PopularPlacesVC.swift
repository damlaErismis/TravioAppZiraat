//
//
//  PopularPlacesVC.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 1.11.2023.
//
//
import UIKit
import TinyConstraints
import SnapKit
import Kingfisher



class PopularPlacesVC: UICustomViewController {
    
    enum OrderState {
        case ascending
        case descending
    }
    var currentOrderState: OrderState = .ascending

    var viewModel = PopularPlacesVM()

    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .viewColor
        cv.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 5, right: 0)
        cv.register(PopularPlacesCell.self, forCellWithReuseIdentifier: "collectionCell")
        cv.layer.cornerRadius = 20
        cv.layer.maskedCorners = [.topLeft]
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private lazy var btnOrder: UIButton = {
        let image = UIImage(named: "orderAZ")
        let btn = UIButton()
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(btnOrderTapped), for: .touchUpInside)
        return btn
    }()
    
    func configureView(){
        labelTitle.text = "Popular Places"
        imageBack.image = UIImage(named: "vector")
        self.viewMain.backgroundColor = .viewColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        imageBack.addGestureRecognizer(tap)
    }
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func btnOrderTapped() {
        let newImageName = (currentOrderState == .ascending) ? "orderZA" : "orderAZ"
        btnOrder.setImage(UIImage(named: newImageName), for: .normal)
        currentOrderState = (currentOrderState == .ascending) ? .descending : .ascending
        if currentOrderState == .ascending {
            viewModel.popularPlaces.sort { $0.title < $1.title }
        } else {
            viewModel.popularPlaces.sort { $0.title > $1.title }
        }
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        configureView()
        initVM()
        bindViewModel()
        setupViews()
    }
    
    private func bindViewModel() {
        viewModel.popularPlacesChange = { [weak self] in
            self?.collectionView.reloadData()
        }
        viewModel.getPopularPlaces() { result in
        }
    }
    private func initVM(){
        viewModel.reloadCollectionViewForPopularPlaces = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    func setupViews() {
        viewMain.addSubviews(collectionView, btnOrder)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        setupLayouts()
    }
    
    func setupLayouts() {
        
        btnOrder.snp.makeConstraints({ btn in
            btn.top.equalToSuperview().offset(20)
            btn.trailing.equalToSuperview().offset(-25)
        })

        collectionView.snp.makeConstraints({view in
            view.bottom.equalToSuperview()
            view.top.equalToSuperview().offset(50)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
        })
    }
    
}
extension PopularPlacesVC:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedID = viewModel.popularPlaces[indexPath.row].id
        let vc = PlaceDetailVC()
        vc.selectedID = selectedID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 90 )
    }
}
extension PopularPlacesVC:UICollectionViewDataSource {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.popularPlaces.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! PopularPlacesCell
        
        cell.configure(with: viewModel.popularPlaces[indexPath.item])
        return cell
    }
    
}
