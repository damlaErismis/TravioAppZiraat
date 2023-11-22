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
    private var isFormComplete: Bool = false
    var imagesFromLibrary:[UIImage] = []
    var newPlaceId:String?
    func closePage() {
        self.dismiss(animated: true) {
            self.delegate?.didDismissPlaceDetailVC()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        closePage()
    }
    
    var selectedPlace = CustomAnnotation()
    var vm:AddNewPlaceVM = {
        AddNewPlaceVM()
    }()
    
    private lazy var viewMain:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "F8F8F8")
        return view
    }()
    
    private lazy var viewDescription:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "FFFFFF")
        view.layer.cornerRadius = 16
        view.addShadow(shadowColor: UIColor(hexString: "#000000"), offsetX: 0, offsetY: 0, shadowOpacity: 0.1, shadowRadius: 10.0)
        return view
    }()
    
    private lazy var labelDescription = UILabelCC(labelText: "Visit Description", font: .poppinsRegular14)
    private lazy var textViewDescription: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.autocapitalizationType = .none
        return tv
    }()
    private lazy var viewPlaceName:UIViewCC = {
        let view = UIViewCC(labeltext: "Place Name", placeholderText: "Please write a place name")
        view.textField.delegate = self
        view.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view.textField.autocapitalizationType = .none
        return view
    }()
    
    lazy var viewCountryCity:UIViewCC = {
        let view = UIViewCC(labeltext: "Country, City", placeholderText: "France, Paris")
        view.textField.delegate = self
        view.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view.textField.autocapitalizationType = .none
        return view
    }()
    
    private lazy var btnAddPlace:UIButton = {
        let btn = UIButton()
        btn.setTitle("Add Place", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .mainColor
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
    
    func initView(){
        self.navigationController?.navigationBar.isHidden = true
        setupViews()
    }
    
    func initVM(){
        vm.showErrorAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.vm.errorStatusMessage?.message, let title = self?.vm.errorStatusMessage?.status {
                    self?.showAlert(title:title, message: message)
                }
            }
        }
        vm.showSuccessAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.vm.galleryResponse?.message {
                    self?.showAlert(title: "Success", message: message)
                }
            }
        }
        vm.showErrorGalleryAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.vm.galleryResponse?.message {
                    self?.showAlert(title: "Error", message: message)
                }
            }
        }
    }
    @objc func handleAddPlace(){
        uploadImages()
        vm.addNewPlaceClosure = {
            guard let imageResponse = self.vm.imageUrls,
                  let placeTitle = self.viewPlaceName.textField.text,
                  let place = self.viewCountryCity.textField.text,
                  let placeDescription = self.textViewDescription.text else {
                return  }
            let latitude = self.selectedPlace.coordinate.latitude
            let longitude = self.selectedPlace.coordinate.longitude
            self.vm.addNewPlace( place: place, placeTitle: placeTitle, placeDescription: placeDescription, imageString: imageResponse[0], latitude: latitude, longitude: longitude)
        }
        vm.addGalleriesClosure = {
            guard let imageResponse = self.vm.imageUrls,
                  let placeId = self.vm.placeId else {return}
            imageResponse.forEach({ imageURL in
                self.vm.createGalleryImage(placeId: placeId, imageURL: imageURL)
            })
        }
    }
    
    func uploadImages(){
        let images = imagesFromLibrary
        if images.count >= 2 {
            vm.uploadImages(images: images)
        }else{
            self.showAlert(title: "Error", message: "Please add at least 2 photos")
            return
        }
    }
    
    func imageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func setupViews() {
        self.view.backgroundColor = .mainColor
        self.view.addSubview(viewMain)
        viewMain.addSubviews(viewPlaceName, viewDescription, viewCountryCity, collectionView, btnAddPlace)
        viewDescription.addSubviews(labelDescription, textViewDescription)
        setupLayout()
    }
    
    func setupLayout() {
        viewMain.snp.makeConstraints({ view in
            view.bottom.leading.trailing.height.equalToSuperview()
        })
        viewPlaceName.snp.makeConstraints({ view in
            view.top.equalToSuperview().offset(64)
            view.leading.trailing.equalToSuperview().inset(24)
            view.height.equalTo(74)
        })
        viewDescription.snp.makeConstraints({ view in
            view.top.equalTo(viewPlaceName.snp.bottom).offset(12)
            view.leading.trailing.equalToSuperview().inset(24)
            view.height.equalTo(215)
        })
        labelDescription.snp.makeConstraints({ label in
            label.top.equalToSuperview().offset(11)
            label.leading.trailing.equalToSuperview().inset(11)
            label.bottom.equalTo(textViewDescription.snp.top)
        })
        textViewDescription.snp.makeConstraints({ txt in
            txt.top.equalTo(labelDescription.snp.bottom).offset(11)
            txt.bottom.equalToSuperview()
            txt.leading.trailing.equalToSuperview().inset(11)
        })
        viewCountryCity.snp.makeConstraints({ view in
            view.top.equalTo(viewDescription.snp.bottom).offset(12)
            view.leading.trailing.equalToSuperview().inset(24)
            view.height.equalTo(74)
        })
        collectionView.snp.makeConstraints({ cv in
            cv.top.equalTo(viewCountryCity.snp.bottom).offset(11)
            cv.leading.equalToSuperview()
            cv.trailing.equalToSuperview().offset(-11)
            cv.bottom.equalTo(btnAddPlace.snp.top).offset(-11)
        })
        btnAddPlace.snp.makeConstraints({ btn in
            btn.height.equalTo(54)
            btn.leading.trailing.equalToSuperview().inset(24)
            btn.bottom.equalToSuperview().offset(-50)
        })
    }
}
extension AddNewPlaceVC:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath
        self.imageTapped()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: (collectionView.frame.width - 20) * 0.8, height: (collectionView.frame.height-10))
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
        cell.addShadow(shadowColor: .black, offsetX: 0, offsetY: 0, shadowOpacity: 0.1, shadowRadius: 10.0)
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

extension AddNewPlaceVC: UITextFieldDelegate{
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == viewPlaceName.textField || textField == viewCountryCity.textField{
            let placeTitle = viewPlaceName.textField.text ?? ""
            let placeLocation = viewCountryCity.textField.text ?? ""
            isFormComplete = !placeTitle.isEmpty && !placeLocation.isEmpty
            btnAddPlace.isEnabled = isFormComplete
            btnAddPlace.backgroundColor = isFormComplete ? .mainColor : .lightGray
        }
    }
    
}

