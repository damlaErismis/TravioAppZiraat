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
    
//    var popularPlacesPage: [PopularPlaces] = [
////        PopularPlaces(image: UIImage(named: "suleymaniyee"), labelPlace: "Süleymaniye", imgPin: UIImage(named: "blackPin"), labelCountry: "İstanbul")
//    ]
    
    var viewModel = HomeVM()
    
//    private lazy var collectionView:UICollectionView = {
//        let tv = UICollectionView()
//        tv.delegate = self
//        tv.dataSource = self
//        tv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//        tv.register(PopularPlacesCell.self, forCellWithReuseIdentifier: "customCell")
//        tv.backgroundColor = UIColor(hexString: "F8F8F8")
//        tv.layer.cornerRadius = 20
//        return tv
//    }()
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
    
    private lazy var imgOrderAZ:UIImage = {
        let img = UIImage(named: "orderAZ")
        return img!
    }()
    
    private lazy var imgOrderZA:UIImage = {
        let img = UIImage(named: "orderZA")
        return img!
    }()
    
    private func createLeftBarButton() -> UIBarButtonItem {
        let image = UIImage(named: "Vector")
        let leftBarButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        leftBarButton.tintColor = .white
        return leftBarButton
    }
    @objc func backButtonTapped(){
        let home = HomeVC()
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVM()
        setupViews()
        bindViewModel()
        
    }
    func bindViewModel() {
        viewModel.popularPlacesChange = { [weak self] in
            self?.collectionView.reloadData()
        }
        viewModel.getPopularPlaces() { result in
        }
    }
    func initVM(){
        viewModel.reloadCollectionView = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    func setupViews() {
        
        self.navigationItem.leftBarButtonItem = createLeftBarButton()
        self.view.addSubviews(viewMain, labelPopularPlaces)
        self.view.backgroundColor = UIColor(hexString: "#38ada9")
        viewMain.addSubview(collectionView)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        setupLayout()
    }
    
    func setupLayout() {
        
        labelPopularPlaces.snp.makeConstraints({ img in
            img.top.equalToSuperview().offset(50)
            img.centerX.equalToSuperview()
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
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//         super.setSelected(selected, animated: animated)
//
//     }
}
