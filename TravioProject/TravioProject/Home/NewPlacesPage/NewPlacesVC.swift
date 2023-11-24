//
//  
//  NewPlacesVC.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 6.11.2023.
//
//
import UIKit
import TinyConstraints
import SnapKit
import Kingfisher

class NewPlacesVC: UICustomViewController {
    
    enum OrderState {
        case ascending
        case descending
    }
    var currentOrderState: OrderState = .ascending
    
    var viewModel = NewPlacesVM()
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .viewColor
        cv.register(NewPlacesCell.self, forCellWithReuseIdentifier: "collectionCell")
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
    @objc func btnOrderTapped() {
        let newImageName = (currentOrderState == .ascending) ? "orderZA" : "orderAZ"
        btnOrder.setImage(UIImage(named: newImageName), for: .normal)
        currentOrderState = (currentOrderState == .ascending) ? .descending : .ascending
        if currentOrderState == .ascending {
            viewModel.newPlaces.sort { $0.title < $1.title }
        } else {
            viewModel.newPlaces.sort { $0.title > $1.title }
        }
        collectionView.reloadData()
    }
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
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
        viewModel.newPlacesChange = { [weak self] in
            self?.collectionView.reloadData()
        }
        viewModel.getNewPlaces() { result in
        }
    }
    private func initVM(){
        viewModel.reloadCollectionViewForNewPlaces = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    func configureView(){
        labelTitle.text = "New Places"
        imageBack.image = UIImage(named: "vector")
        self.viewMain.backgroundColor = .viewColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        imageBack.addGestureRecognizer(tap)
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

extension NewPlacesVC:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedID = viewModel.newPlaces[indexPath.row].id
        let vc = PlaceDetailVC()
        vc.selectedID = selectedID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 90 )
    }
}
extension NewPlacesVC:UICollectionViewDataSource {
 

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.newPlaces.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! NewPlacesCell
        
        cell.configureNewPlaces(with: viewModel.newPlaces[indexPath.item])
        return cell
    }
    
}
