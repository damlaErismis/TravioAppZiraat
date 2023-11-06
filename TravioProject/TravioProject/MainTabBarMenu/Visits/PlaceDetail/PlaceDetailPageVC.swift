//
//
//  CompositionalLayoutVC.swift
//  TravioProject
//
//  Created by Burak Özer on 31.10.2023.
//
//
import UIKit
import SnapKit

class PlaceDetailPageVC: UIViewController {
    

    var placeInfo:PlaceAnnotation?
    
    private lazy var collectionTopView:UICollectionView = {
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.backgroundColor = .white
        collectionView.register(CompositionalLayoutCell.self, forCellWithReuseIdentifier: CompositionalLayoutCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var pageControl:UIPageControl = {
      let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        return pageControl
    }()

    lazy var collectionBottomView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
        cv.backgroundColor = .white
        cv.register(DetailPlaceCollectionCell.self, forCellWithReuseIdentifier: "collectionCellBottom")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private lazy var imageBack:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "backLogo")
        img.contentMode = .scaleToFill
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageBackTapped(tapGestureRecognizer:)))
         img.isUserInteractionEnabled = true
         img.addGestureRecognizer(tapGestureRecognizer)
        return img
    }()
    
    @objc func imageBackTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        self.navigationController?.popViewController(animated: true)

        
    }
    private lazy var imageFavorite:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "emptyFavorite")
        return img
    }()
    
    @objc func pageControlDidChange(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionTopView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    //MARK: -- Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        navigationController?.navigationBar.isHidden = true
    }
    //MARK: -- UI Methods
    func setupViews() {
        // Add here the setup for the UI
        self.view.backgroundColor = .white
        self.view.addSubviews(collectionBottomView, collectionTopView, imageBack, imageFavorite, pageControl)
    
        setupLayout()
    }
    func setupLayout() {
        pageControl.snp.makeConstraints({ pc in
            pc.centerX.equalToSuperview()
            pc.height.equalTo(44)
            pc.width.equalTo(200)
            pc.bottom.equalTo(collectionTopView.snp.bottom)
        })
        imageFavorite.snp.makeConstraints({img in
            img.top.equalTo(self.view.safeAreaLayoutGuide)
            img.trailing.equalToSuperview().offset(-15)
            img.height.equalTo(50)
            img.width.equalTo(50)
        })
        imageBack.snp.makeConstraints({img in
            img.centerY.equalTo(imageFavorite)
            img.leading.equalToSuperview().offset(25)
            img.height.equalTo(40)
            img.width.equalTo(40)
        })
        collectionTopView.snp.makeConstraints({ cv in
            cv.top.equalTo(self.view.safeAreaLayoutGuide)
            cv.leading.equalToSuperview()
            cv.trailing.equalToSuperview()
            cv.height.equalTo(250)
        })
        collectionBottomView.snp.makeConstraints({ cv in
            cv.top.equalTo(collectionTopView.snp.bottom)
            cv.leading.equalToSuperview()
            cv.trailing.equalToSuperview()
            cv.bottom.equalToSuperview()
        })

    }
}

extension PlaceDetailPageVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionBottomView {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        else{
            return CGSize(width: collectionView.frame.width-100, height: collectionView.frame.height-100)
        }
    }
}

extension PlaceDetailPageVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if collectionView == collectionBottomView {
                return 1
            }
            else{
                return 3
            }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionTopView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompositionalLayoutCell.identifier, for: indexPath) as! CompositionalLayoutCell
            
            
            cell.imagePlace.image = UIImage(named: "suleymaniyeMosque")
            
            pageControl.currentPage = indexPath.row
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCellBottom", for: indexPath) as! DetailPlaceCollectionCell
            return cell
        }
    }
}

extension PlaceDetailPageVC {
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in

                    return PlaceDetailLayout.shared.makePlacesLayout()
        }
    }
}


