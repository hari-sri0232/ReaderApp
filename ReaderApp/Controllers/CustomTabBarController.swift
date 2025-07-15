//
//  CustomTabBarController.swift
//  ReaderApp
//
//  Created by  HBK on 15/07/25.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
    }
    
    func setupTabs() {
        let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsInfoController") as! NewsInfoController
        firstVC.title = "News"
       
        
        let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookMarksController") as! BookMarksController
        secondVC.title = "Bookmarks"
        
        let navA = UINavigationController(rootViewController: firstVC)
        navA.tabBarItem = UITabBarItem(title: "News", image: UIImage(named: "News-Unselected"), selectedImage: UIImage(named: "News-Selected"))
        navA.tabBarItem.tag = 1

        
        let navB = UINavigationController(rootViewController: secondVC)
        navB.tabBarItem = UITabBarItem(title: "Bookmarks", image: UIImage(named: "Bookmark-Unselcted"), selectedImage: UIImage(named: "Bookmark-Selected"))
        navB.tabBarItem.tag = 2
        
        viewControllers = [navA, navB]
    }
}

extension CustomTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Handle the user selecting a different tab
    }
}
