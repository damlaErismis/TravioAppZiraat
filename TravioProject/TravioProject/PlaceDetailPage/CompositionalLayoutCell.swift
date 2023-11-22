//
//  
//  CompositionalLayoutCellVC.swift
//  TravioProject
//
//  Created by Burak Özer on 1.11.2023.
//
//
import UIKit
import SnapKit

class CompositionalLayoutCell: UICollectionViewCell {
    
    //MARK: -- Properties
    
    static let identifier = "placeDetail"
    
    //MARK: -- Views
    
    private lazy var viewTop: UIView = {
        let vt = UIView()
        return vt
    }()
    
    lazy var imagePlace:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        img.addBlackGradientLayerInBackground(frame: CGRect(x: 0, y: 140, width: frame.width, height: 110), colors:[.clear, .white])
        return img
    }()
    
    //MARK: -- Life Cycles
    override init(frame: CGRect) {
         super.init(frame: frame)
         setupViews()
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -- Component Actions
    
    
    //MARK: -- Private Methods
    
    
    //MARK: -- UI Methods
    func setupViews() {
        // Add here the setup for the UI
        self.contentView.addSubviews(viewTop)
        viewTop.addSubview(imagePlace)
        setupLayout()
    }
    
    func setupLayout() {
        // Add here the setup for layout
        viewTop.snp.makeConstraints({ view in
            view.top.leading.trailing.equalToSuperview()
            view.height.equalTo(250)
        })
        imagePlace.snp.makeConstraints({ view in
            view.top.equalToSuperview()
            view.leading.trailing.equalToSuperview()
            view.height.equalTo(250)
        })
    }
}
