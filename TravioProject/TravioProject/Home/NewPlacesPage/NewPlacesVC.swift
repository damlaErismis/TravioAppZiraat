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

class NewPlacesVC: UIViewController {
    
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
        cv.backgroundColor = UIColor(hexString: "F8F8F8")
        cv.register(NewPlacesCell.self, forCellWithReuseIdentifier: "collectionCell")
        cv.layer.cornerRadius = 20
        cv.layer.maskedCorners = [.topLeft]
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    private lazy var viewMain:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "F8F8F8")
        view.layer.cornerRadius = 75
        view.layer.maskedCorners = [.topLeft]
        return view
    }()
    private lazy var labelNewPlaces:UILabelCC = {
        let lbl = UILabelCC(labelText: "New Places", font: .poppinsBold30)
        lbl.textColor = .white
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
    func setupViews() {
        self.view.addSubviews(viewMain, labelNewPlaces, btnBack)
        self.view.backgroundColor = .mainColor
        viewMain.addSubviews(collectionView, btnOrder)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        setupLayout()
    }
    
    func setupLayout() {
        
        btnBack.snp.makeConstraints({ btn in
            btn.top.equalTo(labelNewPlaces).offset(15)
            btn.leading.equalToSuperview().offset(25)
            btn.width.equalTo(25)
            btn.height.equalTo(25)
        })
        
        labelNewPlaces.snp.makeConstraints({ img in
            img.top.equalToSuperview().offset(50)
            img.centerX.equalToSuperview()
            img.leading.equalTo(btnBack.snp.trailing).offset(30)
            img.height.equalTo(52)
            img.width.equalTo(250)
        })
        
        viewMain.snp.makeConstraints({ view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.80)
        })
        
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
        print(indexPath)
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
