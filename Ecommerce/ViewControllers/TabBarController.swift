//
//  TabBarController.swift
//  Frippy_finall
//
//  Created by Mac Mini 6 on 13/4/2023.
//

import SwiftUI

import DSKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeViewController = Home1ViewController()
        homeViewController.title = "Home"
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let searchViewController = UIViewController()
        searchViewController.title = "Search"
        searchViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        let profileViewController = UIViewController()
        profileViewController.title = "Profile"
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 2)
        
        let viewControllers = [homeViewController, searchViewController, profileViewController]
        
        setViewControllers(viewControllers, animated: false)
    }
    
}
