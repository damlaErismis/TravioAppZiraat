//
//  HomeTableCell.swift
//  TravioProject
//
//  Created by Burak Özer on 26.10.2023.
//

import UIKit
import SnapKit
import TinyConstraints
import Kingfisher

class HomeTableCell: UITableViewCell {

    var viewModel = HomeVM()
    
    var data:[String]?
    
    private lazy var labelSectionName:UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
        cv.backgroundColor = UIColor(hexString: "F8F8F8")
        cv.register(HomeCollectionCell.self, forCellWithReuseIdentifier: "collectionCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initVM()
        viewModel.popularPlacesChange = { [weak self] in
            self?.collectionView.reloadData()
        }

        viewModel.getPopularPlacesWithLimit { result in
           
        }
        setupViews()
    }
    
    func configure(data:[String]) {
        self.data = data
        
    }

//    public func configure(data: [PopularPlaces]) {
//        self.data = data
//        print("Configured data: ", data)
//    }
    
    
    func setupViews(){
        self.contentView.addSubviews(labelSectionName, collectionView)
        setupLayout()
    }
    
    func setupLayout(){
        labelSectionName.snp.makeConstraints({ lbl in
            lbl.leading.equalToSuperview()
            lbl.trailing.equalToSuperview()
            lbl.centerY.equalToSuperview()
        })
        collectionView.edgesToSuperview()
    }
    
    func initVM(){
        viewModel.reloadCollectionView = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var selectedIndex:IndexPath?
}


extension HomeTableCell:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 280, height: 178 )
        
    }
}

extension HomeTableCell:UICollectionViewDataSource {
 

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
//        return viewModel.popularPlaces.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! HomeCollectionCell
        

//        if let popularPlace = self.data?[indexPath.row] {
//            cell.configurePopularPlaces(with: popularPlace)
//        }

        cell.labelPlace.text = self.data?[indexPath.row]
//        cell.configurePopularPlaces(with: viewModel.popularPlaces[indexPath.item])
        return cell
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)

     }
}


