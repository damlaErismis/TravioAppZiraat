//
//  
//  SettingCollectionCellVC.swift
//  LoginPageOdev
//
//  Created by Burak Özer on 2.11.2023.
//
//
import UIKit
import SnapKit

class SettingCollectionCell: UICollectionViewCell {
    
    //MARK: -- Properties
    
    
    //MARK: -- Views
    
    
    
    private lazy var viewItem:UIViewCC = {
        let view = UIViewCC()
        return view
        
    }()
    
    private lazy var imageIcon:UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    private lazy var imageDirection:UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    private lazy var labelItem:UILabelCC = {
        let lbl = UILabelCC()
        lbl.font = UIFont(name:"Poppins-Thin", size: 14)
        
        return lbl
    }()
    
    public func getSettingCollectionData(imageIconString:String, imageDirectionString:String, itemString: String){
        
        imageIcon.image = UIImage(named: imageIconString)
        imageDirection.image = UIImage(named: imageDirectionString)
        labelItem.text = itemString
        
    }
    
    
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
        self.contentView.addSubviews(viewItem)
        self.viewItem.addSubviews(imageIcon, labelItem, imageDirection)
        setupLayout()
    }
    
    func setupLayout() {
        // Add here the setup for layout
        viewItem.snp.makeConstraints({ view in
//            view.top.equalToSuperview()
//            view.leading.equalToSuperview()
//            view.trailing.equalToSuperview()
//            view.bottom.equalToSuperview()
            view.height.equalTo(54)
            view.width.equalTo(358)
        })
        
        imageIcon.snp.makeConstraints({img in
            img.centerY.equalTo(viewItem.snp.centerY)
            img.leading.equalToSuperview().offset(17)
            img.height.equalTo(20)
            img.width.equalTo(20)
        })
        
        labelItem.snp.makeConstraints({lbl in
            lbl.centerY.equalTo(viewItem.snp.centerY)
            lbl.leading.equalTo(imageIcon.snp.trailing).offset(8)
        })
        
        imageDirection.snp.makeConstraints({img in
            img.centerY.equalTo(viewItem.snp.centerY)
            img.trailing.equalToSuperview().offset(-17)
            img.height.equalTo(15)
            img.width.equalTo(10)
        })
        
       
    }
  
}
