//
//  
//  NewPlacesVC.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 6.11.2023.
//
//
import UIKit
import TinyConstraints

class NewPlacesVC: UIViewController {
    
    //MARK: -- Properties
    
    
    //MARK: -- Views
    
    
    //MARK: -- Life Cycles
    override func viewDidLoad() {
        self.view.backgroundColor = .red
        super.viewDidLoad()
        
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
struct NewPlacesVC_Preview: PreviewProvider {
    static var previews: some View{
         
        NewPlacesVC().showPreview()
    }
}
#endif
