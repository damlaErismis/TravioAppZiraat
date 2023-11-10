//
//  AddNewPlaceVC.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 31.10.2023.
//

import UIKit
import SnapKit
import TinyConstraints
import MapKit

class AddNewPlaceVC: UIViewController{
    
    weak var delegate: ViewControllerDelegate?
    
    var selectedIndex:IndexPath?
    
    var imagesFromLibrary:[UIImage] = []
    var newPlaceId:String?
    
    func closePage() {
        self.dismiss(animated: true) {
            self.delegate?.didDismissViewController()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        closePage()
    }
    
    var selectedPlace = PlaceAnnotation(mapItem: MKMapItem())
    
    var vm:AddNewPlaceVM = {
        AddNewPlaceVM()
    }()
    
    private lazy var viewMain:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "F8F8F8")
        return view
    }()
    
    private lazy var viewPlaceName = UIViewCC()
    private lazy var viewDescription = UIViewCC()
    private lazy var viewLocation = UIViewCC()
    
    private lazy var labelPlaceName = UILabelCC(labelText: "Place Name", font: .poppinsRegular14)
    private lazy var labelDescription = UILabelCC(labelText: "Visit Description", font: .poppinsRegular14)
    lazy var labelCountryCity = UILabelCC(labelText: "Country, City", font: .poppinsRegular14)
    
    private lazy var labelCountryCityData:UILabelCC = {
        let lbl = UILabelCC(labelText: "country,city verisi gelecek!!", font: .poppinsRegular14)
        lbl.isHidden = true
        return lbl
    }()

    private lazy var textFieldPlaceName:UITextFieldCC = {
        let txt = UITextFieldCC(placeholderText: "Please write a place name")
        txt.autocapitalizationType = .none
        return txt
    }()
    
    private lazy var textViewDescription: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.autocapitalizationType = .none
        return tv
    }()

    private lazy var btnAddPlace:UIButton = {
        let btn = UIButton()
        btn.setTitle("Add Place", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(hexString: "#38ada9")
        btn.layer.cornerRadius = 12
        btn.addTarget(self, action: #selector(handleAddPlace), for: .touchUpInside)
        return btn
    }()
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
        cv.backgroundColor = UIColor(hexString: "F8F8F8")
        cv.register(AddPlaceCollectionCell.self, forCellWithReuseIdentifier: "collectionCell")
        cv.dataSource = self
        
        cv.delegate = self
        
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        initView()
        initVM()
    }
    
    @objc func handleAddPlace(){
        
        uploadImages()
        
        vm.addNewPlaceClosure = {
            
            guard let imageResponse = self.vm.imageUrls else {return }
            guard let place = self.labelCountryCity.text else {return }
            guard let placeTitle = self.textFieldPlaceName.text else {
                return  }
            guard let placeDescription = self.textViewDescription.text else {
                return  }
            let latitude = self.selectedPlace.coordinate.latitude
            let longitude = self.selectedPlace.coordinate.longitude
            
            var addPlacerequest = AddPlaceRequest(place: place, title: placeTitle, description: placeDescription, cover_image_url: imageResponse[0], latitude: latitude, longitude: longitude)
            
            self.vm.addNewPlace( place: place, placeTitle: placeTitle, placeDescription: placeDescription, imageString: imageResponse[0], latitude: latitude, longitude: longitude)
        }
        
        vm.addGalleriesClosure = {
            guard let imageResponse = self.vm.imageUrls else {return }
            guard let placeId = self.vm.placeId else {return}
            imageResponse.forEach({ imageURL in
                self.vm.createGalleryImage(placeId: placeId, imageURL: imageURL)
            })
        }
  }
    func uploadImages(){
        
        let images = imagesFromLibrary
        if images.count >= 2 {
            vm.uploadImage(images: images)
        }else{
            self.showAlert(title: "Alert", message: "En az 2 fotoğraf ekleyiniz'")
            return
        }
    }
    
    
   func showAlert(title:String, message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imageTapped() {
             let imagePicker = UIImagePickerController()
             imagePicker.delegate = self
             imagePicker.sourceType = .photoLibrary
             present(imagePicker, animated: true, completion: nil)
     }
 
    func initView(){
        self.navigationController?.navigationBar.isHidden = true
        setupViews()
    }

    func initVM(){
       
    }

    func setupViews() {
        self.view.backgroundColor = UIColor(hexString: "#38ada9")
        self.view.addSubview(viewMain)
        viewMain.addSubviews(viewPlaceName, viewDescription, viewLocation, collectionView, btnAddPlace)
        viewPlaceName.addSubviews(labelPlaceName, textFieldPlaceName)
        viewDescription.addSubviews(labelDescription, textViewDescription)
        viewLocation.addSubviews(labelCountryCity,labelCountryCityData)
        
        setupLayout()
    }
    
    func setupLayout() {
        
        viewMain.snp.makeConstraints({ view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalToSuperview()
        })
        viewPlaceName.snp.makeConstraints({ view in
            view.top.equalToSuperview().offset(64)
            view.centerX.equalToSuperview()
            view.height.equalTo(74)
            view.width.equalTo(342)
        })
        labelPlaceName.snp.makeConstraints({ label in
            label.top.equalToSuperview().offset(11)
            label.leading.equalToSuperview().offset(11)
            label.trailing.equalToSuperview().offset(-11)
            label.bottom.equalTo(textFieldPlaceName.snp.top)
        })
        textFieldPlaceName.snp.makeConstraints({ txt in
            txt.bottom.equalToSuperview().offset(-11)
            txt.leading.equalToSuperview().offset(11)
            txt.trailing.equalToSuperview().offset(-11)
            txt.height.equalTo(30)
        })
        viewDescription.snp.makeConstraints({ view in
            view.top.equalTo(viewPlaceName.snp.bottom).offset(24)
            view.centerX.equalToSuperview()
            view.height.equalTo(215)
            view.width.equalTo(342)
        })
        labelDescription.snp.makeConstraints({ label in
            label.top.equalToSuperview().offset(11)
            label.leading.equalToSuperview().offset(11)
            label.trailing.equalToSuperview().offset(-11)
            label.bottom.equalTo(textViewDescription.snp.top)
        })
        textViewDescription.snp.makeConstraints({ txt in
            txt.top.equalTo(labelDescription.snp.bottom).offset(11)
            txt.bottom.equalToSuperview()
            txt.leading.equalToSuperview().offset(11)
            txt.trailing.equalToSuperview().offset(-11)
        })
        viewLocation.snp.makeConstraints({ view in
            view.top.equalTo(viewDescription.snp.bottom).offset(24)
            view.centerX.equalToSuperview()
            view.height.equalTo(74)
            view.width.equalTo(342)
        })
        labelCountryCity.snp.makeConstraints({ label in
            label.top.equalToSuperview().offset(11)
            label.leading.equalToSuperview().offset(11)
            label.trailing.equalToSuperview().offset(-11)
            label.bottom.equalTo(labelCountryCityData.snp.top)
        })
        labelCountryCityData.snp.makeConstraints({ label in
            label.top.equalTo(labelCountryCity.snp.bottom).offset(11)
            label.leading.equalToSuperview().offset(11)
            label.trailing.equalToSuperview().offset(-11)
        })
        collectionView.snp.makeConstraints({ cv in
            cv.top.equalTo(viewLocation.snp.bottom).offset(11)
            cv.leading.equalToSuperview()
            cv.trailing.equalToSuperview().offset(-11)
            cv.bottom.equalTo(btnAddPlace.snp.top).offset(-11)
        })
        btnAddPlace.snp.makeConstraints({ btn in
            btn.centerX.equalToSuperview()
            btn.height.equalTo(54)
            btn.width.equalTo(342)
            btn.bottom.equalToSuperview().offset(-30)
        })
    }
    
}
extension AddNewPlaceVC:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath
        self.imageTapped()

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (collectionView.frame.width-10)*0.8, height: (collectionView.frame.height-10) )
        return CGSize(width: 270, height: 225 )
        
    }
}

extension AddNewPlaceVC:UICollectionViewDataSource {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! AddPlaceCollectionCell
        cell.imgNewPlace.image = UIImage(named: "addPhoto")
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        return cell
    }
}

extension AddNewPlaceVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {

            if let cell = collectionView.cellForItem(at: selectedIndex!) as? AddPlaceCollectionCell {
                cell.imgNewPlace.image = selectedImage
                imagesFromLibrary.append(selectedImage)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
