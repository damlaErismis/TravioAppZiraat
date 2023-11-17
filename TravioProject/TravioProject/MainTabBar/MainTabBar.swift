//
//  MainTabBar.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 27.10.2023.
//

import UIKit

class MainTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .viewColor
        self.tabBar.unselectedItemTintColor = .lightGray
        self.viewControllers = setupControllers()
        self.tabBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupControllers()->[UIViewController] {
        
        let homeVC = HomeVC()
        let homeNC = createNavController(vc: homeVC, title: "Home", image: "Home")
        
        let visitsVC = VisitsVC()
        let visitsNC = createNavController(vc: visitsVC, title: "Visits", image: "Visits")
        
        let mapVC = MapVC()
        let mapNC = createNavController(vc: mapVC, title: "Map", image: "Map")
        
        let menuVC = SettingsVC()
        let menuNC = createNavController(vc: menuVC, title: "Menu", image: "Menu")
        
        return [homeNC, visitsNC, mapNC, menuNC]
    }

    private func createNavController(vc: UIViewController, title: String, image: String) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: image)
        navController.navigationBar.isHidden = true 
        return navController
    }
    
}
