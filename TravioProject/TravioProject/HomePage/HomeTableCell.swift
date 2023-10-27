//
//  HomeTableCell.swift
//  TravioProject
//
//  Created by Burak Özer on 26.10.2023.
//

import UIKit
import SnapKit
import TinyConstraints
class HomeTableCell: UITableViewCell {

    private lazy var labelSectionName:UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
        
        cv.register(HomeCollectionCell.self, forCellWithReuseIdentifier: "cell")
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    func setUpDataSource() {
        self.collectionView.reloadData()
    }
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }

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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension HomeTableCell:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.width-10)*0.8, height: (collectionView.frame.height-10) )
    }
}

extension HomeTableCell:UICollectionViewDataSource {
 

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionCell
        cell.imagePlace.image = UIImage(named: "placeImage")
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        return cell
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)

     }
}


