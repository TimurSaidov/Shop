//
//  MainTabBarController.swift
//  Shop
//
//  Created by Timur Saidov on 01/07/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    
    // MARK: Private Properties
    
    private var shopViewController: ViewController?
    private let itemsArray = [Titles.shop.rawValue, Titles.sell.rawValue, Titles.buy.rawValue]

    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
        view.backgroundColor = .white
        
        let shopController = self.templateNavController(withIdentifier: "ShopSID", image: #imageLiteral(resourceName: "buy"))
        shopViewController = shopController.viewControllers.first as? ViewController
        let detailController = self.templateNavController(withIdentifier: "DetailSID", image: #imageLiteral(resourceName: "sell"))
        let buyController = self.templateNavController(withIdentifier: "BuySID", image: #imageLiteral(resourceName: "shop"))
        self.viewControllers = [shopController, detailController, buyController]
        
        guard let items = self.tabBar.items else { return }
        
        for index in 0..<items.count {
            items[index].title = itemsArray[index]
            items[index].imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    
    // MARK: Private
    
    private func templateNavController(withIdentifier identifier: String, image: UIImage) -> UINavigationController { //, unselectedImage: String, selectedImage: String) -> UINavigationController {
        let navController = self.storyboard?.instantiateViewController(withIdentifier: identifier) as! UINavigationController
        navController.tabBarItem.image = image
        return navController
    }
    
    
    // MARK: Tab bar controller delegate
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard
            let navDetailController = viewController as? UINavigationController,
            let shopViewController = shopViewController
            else { return }
        guard let detailController = navDetailController.viewControllers.first as? DetailTableViewController else { return }
        if detailController.delegate == nil {
            detailController.delegate = shopViewController
        }
    }
}
