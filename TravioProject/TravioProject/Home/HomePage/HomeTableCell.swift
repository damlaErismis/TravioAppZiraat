//
//  HomeTableCell.swift
//  TravioProject
//
//  Created by Burak Özer on 26.10.2023.
//

import UIKit
import SnapKit
import Kingfisher

class HomeTableCell: UITableViewCell {
    
    var onItemSelect: ((IndexPath) -> Void)?
    var viewModel = HomeVM()
    private var popularPlaces: [Place] = []
    private lazy var labelSectionName:UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
        cv.backgroundColor = .viewColor
        cv.register(HomeCollectionCell.self, forCellWithReuseIdentifier: "collectionCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func prepareCategory(with model: [Place]) {
        self.popularPlaces = model
        collectionView.reloadData()
    }

    func setupViews(){
        self.contentView.addSubviews(labelSectionName, collectionView)
        setupLayout()
    }
    
    func setupLayout(){
        labelSectionName.snp.makeConstraints({ lbl in
            lbl.trailing.leading.equalToSuperview()
            lbl.centerY.equalToSuperview()
        })
        collectionView.snp.makeConstraints({cv in
            cv.edges.equalToSuperview()
        })
        collectionView.dropShadow()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var selectedIndex:IndexPath?
}

extension HomeTableCell:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onItemSelect?(indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.74, height: collectionView.frame.height)
    }
}

extension HomeTableCell:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularPlaces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? HomeCollectionCell {
            cell.configurePopularPlaces(with: self.popularPlaces[indexPath.row])
            cell.roundAllCorners(radius: 16)
            cell.addShadow(shadowColor: .black, offsetX: 0, offsetY: 0, shadowOpacity: 0.1, shadowRadius: 10.0)
            return cell
        }
        return UICollectionViewCell()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)
     }
}



