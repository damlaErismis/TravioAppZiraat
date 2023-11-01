//
//
//  PopularPlacesVC.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 1.11.2023.
//
//
import UIKit
import TinyConstraints
import SnapKit

struct PopularPlaces {
    
    var image:UIImage?
    var labelPlace:String?
    var imgPin:UIImage?
    var labelCountry:String?
}

class PopularPlacesVC: UIViewController {
    
    var popularPlaces: [PopularPlaces] = [
        PopularPlaces(image: UIImage(named: "suleymaniyee"), labelPlace: "Süleymaniye", imgPin: UIImage(named: "blackPin"), labelCountry: "İstanbul"),
        PopularPlaces(image: UIImage(named: "suleymaniyee"), labelPlace: "Süleymaniye", imgPin: UIImage(named: "blackPin"), labelCountry: "İstanbul"),
        PopularPlaces(image: UIImage(named: "suleymaniyee"), labelPlace: "Süleymaniye", imgPin: UIImage(named: "blackPin"), labelCountry: "İstanbul"),
        PopularPlaces(image: UIImage(named: "suleymaniyee"), labelPlace: "Süleymaniye", imgPin: UIImage(named: "blackPin"), labelCountry: "İstanbul"),
        PopularPlaces(image: UIImage(named: "suleymaniyee"), labelPlace: "Süleymaniye", imgPin: UIImage(named: "blackPin"), labelCountry: "İstanbul"),
        PopularPlaces(image: UIImage(named: "suleymaniyee"), labelPlace: "Süleymaniye", imgPin: UIImage(named: "blackPin"), labelCountry: "İstanbul")
    ]
    private lazy var tableView:UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.register(PopularPlacesCell.self, forCellReuseIdentifier: "customCell")
        tv.separatorStyle = .none
        tv.backgroundColor = UIColor(hexString: "F8F8F8")
        tv.layer.cornerRadius = 20
        return tv
    }()
    
    private lazy var viewMain:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "F8F8F8")
        view.layer.cornerRadius = 75
        view.layer.maskedCorners = [.topLeft]
        return view
    }()
    
    private lazy var labelPopularPlaces:UILabelCC = {
        let lbl = UILabelCC(labelText: "Popular Places", font: .poppinsBold30)
        lbl.textColor = .white
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    private lazy var imgOrderAZ:UIImage = {
        let img = UIImage(named: "orderAZ")
        return img!
    }()
    
    private lazy var imgOrderZA:UIImage = {
        let img = UIImage(named: "orderZA")
        return img!
    }()
    
    private func createLeftBarButton() -> UIBarButtonItem {
        let image = UIImage(named: "Vector")
        let leftBarButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        leftBarButton.tintColor = .white
        return leftBarButton
    }
    @objc func backButtonTapped(){
        let home = HomeVC()
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
    }
    
    func setupViews() {
        self.navigationItem.leftBarButtonItem = createLeftBarButton()
        self.view.addSubviews(viewMain, labelPopularPlaces)
        self.view.backgroundColor = UIColor(hexString: "#38ada9")
        viewMain.addSubview(tableView)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        setupLayout()
    }
    
    func setupLayout() {
        
        labelPopularPlaces.snp.makeConstraints({ img in
            img.top.equalToSuperview().offset(50)
            img.centerX.equalToSuperview()
            img.height.equalTo(52)
            img.width.equalTo(250)
        })
        
        viewMain.snp.makeConstraints({ view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.80)
        })
        
        tableView.snp.makeConstraints({view in
            view.bottom.equalTo(self.viewMain.safeAreaLayoutGuide)
            view.top.equalToSuperview().offset(50)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalToSuperview()
        })
    }
    
}

extension PopularPlacesVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 110
    }
    
}
extension PopularPlacesVC:UITableViewDataSource {
    
    //MARK: -- Kaç tane section olacağını belirler.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: -- Her bir section içinde kaç adet cell olacağına karar verir.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return popularPlaces.count
        
    }
    
    
    //MARK: -- Her bir satıra denk gelen cell'lerin hangisi olacağı ve veri kaynağını belirler
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! PopularPlacesCell
        
        let object = popularPlaces[indexPath.row]
        cell.configure(object: object)
        
        return cell
        
    }
}
