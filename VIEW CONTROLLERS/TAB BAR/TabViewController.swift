//
//  TabViewController.swift
//  Mzyoon
//
//  Created by QOL on 29/10/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController, UITabBarControllerDelegate, UIGestureRecognizerDelegate
{
    var x = CGFloat()
    var y = CGFloat()
    let navigationTitle = UILabel()


    override func viewDidLoad()
    {
        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated:false);
        
        let nav = self.navigationController?.navigationBar
        nav?.barTintColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let rightButton = UIButton()
        rightButton.frame = CGRect(x: view.frame.width - 50, y: 7, width: 30, height: 30)
        rightButton.setImage(UIImage(named: "notification"), for: .normal)
        self.navigationController?.navigationBar.addSubview(rightButton)
        
        // to the tintcolour for selected tabs
        self.tabBar.unselectedItemTintColor = UIColor.white
        self.tabBar.tintColor = UIColor(red: 0.9725, green: 0.6353, blue: 0.3333, alpha: 1.0)
        self.tabBar.barTintColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        
        // tabbar colour
        self.tabBarController?.tabBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        
        // Create Tab one
        let tabOne = HomeViewController()
        let tabOneBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home"))
        tabOne.tabBarItem = tabOneBarItem
        
        // Create Tab two
        let tabTwo = ProfileViewController()
        let tabTwoBarItem2 = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), selectedImage: UIImage(named: "profile"))
        tabTwo.tabBarItem = tabTwoBarItem2
        
        // Create Tab three
        let tabthree = OrdersViewController()
        let tabThreeBarItem3 = UITabBarItem(title: "Order", image: UIImage(named: "order"), selectedImage: UIImage(named: "order"))
        tabthree.tabBarItem = tabThreeBarItem3
        
        // Create Tab four
        let tabFour = CartViewController()
        let tabFourBarItem4 = UITabBarItem(title: "Cart", image: UIImage(named: "cart"), selectedImage: UIImage(named: "cart"))
        tabFour.tabBarItem = tabFourBarItem4
        
        // Create Tab Five
        let tabFive = ContactUsViewController()
        let tabFiveBarItem5 = UITabBarItem(title: "Contact-Us", image: UIImage(named: "contact-us"), selectedImage: UIImage(named: "contact-us"))
        tabFive.tabBarItem = tabFiveBarItem5
        
        self.viewControllers = [tabOne, tabthree, tabFour, tabFive]
        
        let slideMenuButton = UIButton()
        slideMenuButton.frame = CGRect(x: 0, y: ((view.frame.height - 65) / 2), width: 30, height: 65)
        //        slideMenuButton.backgroundColor = UIColor.orange
        slideMenuButton.setImage(UIImage(named: "sidemenu"), for: .normal)
        //        slideMenuButton.addTarget(self, action: #selector(self.selectionButtonAction(sender:)), for: .touchUpInside)
//        view.addSubview(slideMenuButton)
    }
    
    override func viewWillLayoutSubviews()
    {
        var tabFrame = self.tabBar.frame
        
        // - 40 is editable , the default value is 49 px, below lowers the tabbar and above increases the tab bar size
        tabFrame.size.height = 50
        tabFrame.origin.y = self.view.frame.size.height - 50
        self.tabBar.frame = tabFrame
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
