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


class PopularPlacesVC: UIViewController {
    
    var viewModel = PopularPlacesVM()

    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(hexString: "F8F8F8")
        cv.register(PopularPlacesCell.self, forCellWithReuseIdentifier: "collectionCell")
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
    
    private lazy var labelPopularPlaces:UILabelCC = {
        let lbl = UILabelCC(labelText: "Popular Places", font: .poppinsBold30)
        lbl.textColor = .white
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    private lazy var imgOrderAscending:UIImage = {
        let img = UIImage(named: "orderAZ")
        return img!
    }()
    
    private lazy var imgOrderDescending:UIImage = {
        let img = UIImage(named: "orderZA")
        return img!
    }()
    
    private lazy var btnBack: UIButton = {
        let image = UIImage(named: "btnBack")
        let btn = UIButton()
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return btn
    }()
    
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
        
        self.view.addSubviews(viewMain, labelPopularPlaces, btnBack)
        self.view.backgroundColor = UIColor(hexString: "#38ada9")
        viewMain.addSubview(collectionView)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        setupLayout()
    }
    
    func setupLayout() {
        
        btnBack.snp.makeConstraints({ btn in
            btn.top.equalTo(labelPopularPlaces).offset(15)
            btn.leading.equalToSuperview().offset(25)
            btn.width.equalTo(25)
            btn.height.equalTo(25)
        })
        
        labelPopularPlaces.snp.makeConstraints({ img in
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

        collectionView.snp.makeConstraints({view in
            view.bottom.equalToSuperview()
            view.top.equalToSuperview().offset(60)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
        })
    }
    
}
extension PopularPlacesVC:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
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
        
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        return cell
    }
    
}
