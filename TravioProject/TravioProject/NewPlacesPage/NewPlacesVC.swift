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
        self.view.backgroundColor = .red
        super.viewDidLoad()
        initVM()
        bindViewModel()
        setupViews()
       
    }
    func bindViewModel() {
        viewModel.newPlacesChange = { [weak self] in
            self?.collectionView.reloadData()
        }
        viewModel.getNewPlaces() { result in
        }
    }
    func initVM(){
        viewModel.reloadCollectionViewForNewPlaces = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    func setupViews() {
        self.navigationItem.leftBarButtonItem = createLeftBarButton()
        self.view.addSubviews(viewMain, labelNewPlaces)
        self.view.backgroundColor = UIColor(hexString: "#38ada9")
        viewMain.addSubview(collectionView)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        setupLayout()
    }
    
    func setupLayout() {
        labelNewPlaces.snp.makeConstraints({ img in
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

extension NewPlacesVC:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
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
