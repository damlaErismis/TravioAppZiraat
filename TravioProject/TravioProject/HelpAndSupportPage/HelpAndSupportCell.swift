//
//  HelpAndSupportCollectionCell.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 7.11.2023.
//

import UIKit
import SnapKit
import TinyConstraints
import Kingfisher


class HelpAndSupportCell: UITableViewCell {
    
    var data: HelpAndSupportContent? {
        didSet {
            guard let data = data else { return }
            self.lblQuestion.text = data.question
            self.lblAnswer.text = data.answer
        }
    }
 
    private lazy var imageChevron: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "iconChevron")
        return img
    }()
    
    private lazy var lblQuestion:UILabelCC = {
        let lbl = UILabelCC(labelText: " ", font: .poppinsBold16)
        lbl.numberOfLines = -1
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var lblAnswer:UILabelCC = {
        let lbl = UILabelCC(labelText: " ", font: .poppinsRegular16)
        lbl.numberOfLines = -1
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let container: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        v.backgroundColor = .white
        v.layer.cornerRadius = 16
        return v
    }()
    
    func updateChevronStatus(isExpanded: Bool){
        let imageName = isExpanded ? "chevronUp" : "chevronDown"
        imageChevron.image = UIImage(named: imageName)
    }
    
    func animate() {
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        updateChevronStatus(isExpanded: false)
    }
    
    private func setupViews(){
        self.contentView.addSubview(container)
        self.contentView.backgroundColor = UIColor(hexString: "F8F8F8")
        
        container.addSubviews(lblQuestion, lblAnswer)
        lblQuestion.addSubview(imageChevron)
        setupLayout()
    }
    
    private func setupLayout(){
        container.snp.makeConstraints ({ make in
            make.top.equalTo(contentView.snp.top).offset(4)
            make.leading.equalTo(contentView.snp.leading).offset(4)
            make.trailing.equalTo(contentView.snp.trailing).offset(-4)
            make.bottom.equalTo(contentView.snp.bottom).offset(-4)
        })
        lblQuestion.snp.makeConstraints ({ make in
            make.top.equalTo(container.snp.top)
            make.leading.equalTo(container.snp.leading).offset(4)
            make.trailing.equalTo(container.snp.trailing).offset(-4)
            make.height.equalTo(60)
        })
        
        imageChevron.snp.makeConstraints({ img in
            img.centerY.equalTo(lblQuestion.snp.centerY)
            img.trailing.equalTo(container.snp.trailing).offset(-10)
            img.width.equalTo(18)
            img.height.equalTo(13)
        })
        
        lblAnswer.snp.makeConstraints ({ make in
            make.top.equalTo(lblQuestion.snp.bottom).offset(10)
            make.leading.equalTo(container.snp.leading).offset(4)
            make.trailing.equalTo(container.snp.trailing).offset(-4)
            make.height.equalTo(140)
        })
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
