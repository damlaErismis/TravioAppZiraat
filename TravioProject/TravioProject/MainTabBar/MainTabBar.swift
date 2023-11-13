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
        self.tabBar.backgroundColor = UIColor(hexString: "#F8f8F8")
        self.tabBar.unselectedItemTintColor = .lightGray
        self.viewControllers = setupControllers()
        self.tabBar.isTranslucent = false
    }
    
    private func setupControllers()->[UIViewController] {
        
        let homeVC = HomeVC()
        let homeNC = UINavigationController(rootViewController: homeVC)
        let homeImage = UIImage(named: "Home")
        let selectedImageHome = UIImage(systemName: "Home")
        homeNC.tabBarItem = UITabBarItem(title: "Home", image: homeImage, selectedImage: selectedImageHome )
        
        let visitsVC = VisitsVC()
        let visitsNC = UINavigationController(rootViewController: visitsVC)
        let visitsImage = UIImage(named: "Visits")
        let selectedImageVisits = UIImage(systemName: "Visits")
        visitsNC.tabBarItem = UITabBarItem(title: "Visits", image: visitsImage, selectedImage: selectedImageVisits )
        
        let mapVC = MapVC()
        let mapNC = UINavigationController(rootViewController: mapVC)
        let mapImage = UIImage(named: "Map")
        let selectedImageMap = UIImage(systemName: "Map")
        mapNC.tabBarItem = UITabBarItem(title: "Map", image: mapImage, selectedImage: selectedImageMap )
        
        let menuVC = SettingsVC()
        let menuNC = UINavigationController(rootViewController: menuVC)
        let menuImage = UIImage(named: "Menu")
        let selectedImageMenu = UIImage(systemName: "Menu")
        menuNC.tabBarItem = UITabBarItem(title: "Menu", image: menuImage, selectedImage: selectedImageMenu )
        
        
        return [homeNC, visitsNC, mapNC, menuNC]
    }
    
}
