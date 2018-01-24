//
//  TabBarController.swift
//  PMMX
//
//  Created by ISPMMX on 10/25/17.
//  Copyright © 2017 ISPMMX. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController
{

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.target = revealViewController();
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //print("Selected Index :\(self.selectedIndex)");
        //tabBarController?.viewControllers?.forEach { $0.viewDidLoad()}
    }
}
