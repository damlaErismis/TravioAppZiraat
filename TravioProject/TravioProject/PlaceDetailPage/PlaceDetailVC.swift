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
import Kingfisher

class PlaceDetailVC: UIViewController {
    
    let dispatchGroup = DispatchGroup()
    
    var selectedID:String = ""
    
    lazy var vm: PlaceDetailVM = {
        
        return PlaceDetailVM(selectedID: selectedID)
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .black
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var collectionTopView:UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        collectionView.register(CompositionalLayoutCell.self, forCellWithReuseIdentifier: CompositionalLayoutCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    private lazy var pageControl:UIPageControl = {
        let pageControl = UIPageControl()
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
        cv.register(PlaceDetailCollectionCell.self, forCellWithReuseIdentifier: "collectionCellBottom")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private lazy var btnBack:UIButton = {
        let btn = UIButton()
        if let image = UIImage(named: "backLogo") {
            btn.setImage(image, for: .normal)
        }
        btn.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return btn
    }()
    
    private lazy var imageFavorite:UIImageView = {
        let img = UIImageView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleVisitedPlace))
        img.addGestureRecognizer(tap)
        img.isUserInteractionEnabled = true
        return img
    }()
    
    //MARK: -- Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initVM()
    }
    
    func initView(){
        self.navigationController?.navigationBar.isHidden = true
        setupViews()
    }
    
    func initVM(){
        vm.updateLoadingStatus = { [weak self] (staus) in
            DispatchQueue.main.async {
                if staus {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
        vm.initFetchImages()
        vm.initFetchLayersAndMap()
        vm.checkVisit(placeId: vm.selectedID)
        
        vm.errorCheckId = { [weak self] () in
            DispatchQueue.main.async {
                self?.imageFavorite.image = UIImage(named: "emptyFavorite")
            }
        }
        vm.successCheckId = { [weak self] () in
            DispatchQueue.main.async {
                self?.imageFavorite.image = UIImage(named: "fullyFavorite")
            }
        }
        vm.reloadCompositionalLayoutClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionTopView.reloadData()
            }
        }
        vm.reloadClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionBottomView.reloadData()
            }
        }
        vm.reloadPageControlPages = { [weak self] () in
            DispatchQueue.main.async {
                let numberOfPages = self?.vm.galleryData?.data.images.count ?? 0
                self?.pageControl.numberOfPages = numberOfPages
            }
        }
    }
    
    //MARK: -- Component Actions
    
    @objc func handleVisitedPlace(){
        
        if self.imageFavorite.image == UIImage(named: "emptyFavorite"){
            vm.postAVisit(placeId: selectedID)
            vm.showAlertClosure = { [weak self] () in
                DispatchQueue.main.async {
                    self?.showAlert(title: "Success", message: "Visit successfully added your visits")
                    self?.imageFavorite.image = UIImage(named: "fullyFavorite")
                }
            }
        }else{
            vm.deleteAVisit(placeId: selectedID)
            vm.showAlertClosure = { [weak self] () in
                DispatchQueue.main.async {
                    if let message = self?.vm.successMessage {
                        self?.showAlert(title: "Success", message: message)
                        self?.imageFavorite.image = UIImage(named: "emptyFavorite")
                    }
                }
            }
        }
    }
    @objc func handleBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func pageControlDidChange(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionTopView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    
    
    //MARK: -- UI Methods
    func setupViews() {
        self.view.backgroundColor = .white
        self.view.addSubviews(collectionBottomView, collectionTopView, btnBack, imageFavorite, pageControl, activityIndicator)
        self.view.bringSubviewToFront(pageControl)
        setupLayout()
    }
    
    func setupLayout() {
        activityIndicator.snp.makeConstraints({ai in
            ai.edges.equalToSuperview()
        })
        pageControl.snp.makeConstraints({ pc in
            pc.centerX.equalToSuperview()
            pc.height.equalTo(44)
            pc.width.equalTo(200)
            pc.bottom.equalTo(collectionTopView.snp.bottom).offset(-10)
        })
        imageFavorite.snp.makeConstraints({img in
            img.top.equalToSuperview().offset(40)
            img.trailing.equalToSuperview().offset(-15)
            img.height.width.equalTo(50)
        })
        btnBack.snp.makeConstraints({img in
            img.centerY.equalTo(imageFavorite)
            img.leading.equalToSuperview().offset(25)
            img.height.width.equalTo(40)
        })
        collectionTopView.snp.makeConstraints({ cv in
            cv.top.leading.trailing.equalToSuperview()
            cv.height.equalTo(250)
        })
        collectionBottomView.snp.makeConstraints({ cv in
            cv.top.equalTo(collectionTopView.snp.bottom)
            cv.leading.trailing.bottom.equalToSuperview()
        })
        
    }
}
extension PlaceDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionBottomView {
            let placeDetailData = vm.place
            let updateDate = vm.formatServerDate(dateString: placeDetailData?.updated_at ?? "")
            let placeDetailInfo = PlaceDetailCellInfo(
                latitude: placeDetailData?.latitude, longitude: placeDetailData?.longitude, labelCityText: placeDetailData?.place, labelDateText: updateDate, labelAddedByText: "addedby " + (placeDetailData?.creator ?? ""),
                labelDescriptionText: placeDetailData?.description
            )
            let cell = PlaceDetailCollectionCell()
            cell.getDetailPlaceCollectionCellData(data: placeDetailInfo)
            let size = cell.contentView.systemLayoutSizeFitting(
                CGSize(width: collectionView.bounds.width, height: 1),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
            return CGSize(width: collectionView.bounds.width, height: size.height)
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
}


extension PlaceDetailVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfImages = vm.galleryData?.data.images.count ?? 0
        if collectionView == collectionBottomView {
            return 1
        }
        else{
            return numberOfImages
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == collectionTopView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompositionalLayoutCell.identifier, for: indexPath) as! CompositionalLayoutCell
            let visibleCells = collectionView.visibleCells
            pageControl.currentPage = indexPath.item
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionTopView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompositionalLayoutCell.identifier, for: indexPath) as! CompositionalLayoutCell
            if let imageUrlString = vm.galleryData?.data.images[indexPath.row].image_url,
               let imageUrl = URL(string: imageUrlString) {
                cell.imagePlace.kf.setImage(with: imageUrl)
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCellBottom", for: indexPath) as! PlaceDetailCollectionCell
            let placeDetailData = vm.place
            var placeDetailInfo = PlaceDetailCellInfo()
            let updateDate =  self.vm.formatServerDate(dateString: placeDetailData?.updated_at ?? "")
            placeDetailInfo.labelAddedByText = "added by @" + (placeDetailData?.creator ?? "")
            placeDetailInfo.labelCityText = placeDetailData?.place
            placeDetailInfo.labelDateText = updateDate
            placeDetailInfo.labelDescriptionText = placeDetailData?.description
            placeDetailInfo.latitude = placeDetailData?.latitude
            placeDetailInfo.longitude = placeDetailData?.longitude
            cell.getDetailPlaceCollectionCellData(data: placeDetailInfo)
            return cell
        }
    }
}
extension PlaceDetailVC {
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            return PlaceDetailLayout.shared.makePlacesLayout()
        }
    }
}


