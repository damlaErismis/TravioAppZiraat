//
//  
//  MyAddedPlacesVC.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 6.11.2023.
//
//
import UIKit
import TinyConstraints

class MyAddedPlacesVC: UIViewController {
    
    //MARK: -- Properties
    
    
    //MARK: -- Views
    
    
    //MARK: -- Life Cycles
    override func viewDidLoad() {
        self.view.backgroundColor = .blue
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true

        
       setupViews()
       
    }
    
    //MARK: -- Component Actions
    
    
    //MARK: -- Private Methods
    
    
    //MARK: -- UI Methods
    func setupViews() {
        // Add here the setup for the UI
        self.view.addSubviews()
        setupLayout()
    }
    
    func setupLayout() {
        // Add here the setup for layout
       
    }
  
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct MyAddedPlacesVC_Preview: PreviewProvider {
    static var previews: some View{
         
        MyAddedPlacesVC().showPreview()
    }
}
#endif
