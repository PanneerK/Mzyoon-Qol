//
//  CommonViewController.swift
//  Mzyoon
//
//  Created by QOL on 16/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit
import SideMenu
import SideMenuSwift

class CommonViewController: UIViewController
{
    var window: UIWindow?
    let blurBlackView = UIView()

    var x = CGFloat()
    var y = CGFloat()
    
    let selfScreenContents1 = UIView()
    
    let backgroundImage = UIImageView()
    let navigationBar = UIView()
    let navigationTitle = UILabel()
    let userImage = UIImageView()
    let notificationButton = UIButton()

    
    let slideMenuButton = UIButton()
    let tabBar = UIView()
    
    
    let tab1Button = UIButton()
    let tab1ImageView = UIImageView()
    let tab1Text = UILabel()
    
    let tab2Button = UIButton()
    let tab2ImageView = UIImageView()
    let tab2Text = UILabel()
    
    let tab3Button = UIButton()
    let tab3ImageView = UIImageView()
    let tab3Text = UILabel()
    
    let tab4Button = UIButton()
    let tab4ImageView = UIImageView()
    let tab4Text = UILabel()
    
    var activeView = UIView()
    var activityView = UIActivityIndicatorView()
    
    let pageBar = UIImageView()
    let button1 = UIButton()
    let button2 = UIButton()
    let button3 = UIButton()
    let button4 = UIButton()
    let button5 = UIButton()
    let button6 = UIButton()
    let button7 = UIButton()
    let button8 = UIButton()
    let button9 = UIButton()
    
    let hintsView = UIView()
    let gotItButton = UIButton()
    
    let hintsBackButton = UIButton()
    let hintsSkipButton = UIButton()
    let hintsNextButton = UIButton()

    
//    let slideScreen = SlideViewController()
//    let selfScreen = CommonViewController()
    
    override func viewDidLoad()
    {
        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
        
        declaringMenu()
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                slideMenu()
            }
            else if language == "ar"
            {
                slideMenuRight()
            }
        }
        else
        {
            slideMenu()
        }
        
        self.activityContents()
        
        selfScreenContents1.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        selfScreenContents1.backgroundColor = UIColor.clear
        view.addSubview(selfScreenContents1)
        
        navigationContents()
        tabContents()
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                slideMenu()
                changeViewToEnglish()
            }
            else if language == "ar"
            {
                slideMenuRight()
                changeViewToArabic()
            }
        }
        else
        {
            slideMenu()
            changeViewToEnglish()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("DISAPPEAR VIEW")
    }
    
    func declaringMenu()
    {
        let slideScreen = SlideViewController()
        let leftSlideScreen = UISideMenuNavigationController(rootViewController: slideScreen)
        leftSlideScreen.menuWidth = (view.frame.width / 2) + (view.frame.width / 4)
        SideMenuManager.default.menuLeftNavigationController = leftSlideScreen        
    }
    
    func slideMenu()
    {
        let slideScreen = SlideViewController()
        let leftSlideScreen = UISideMenuNavigationController(rootViewController: slideScreen)
        leftSlideScreen.menuWidth = (view.frame.width / 2) + (view.frame.width / 4)
        SideMenuManager.default.menuLeftNavigationController = leftSlideScreen
    }
    
    func slideMenuRight()
    {
        let slideScreen = SlideViewController()
        let leftSlideScreen = UISideMenuNavigationController(rootViewController: slideScreen)
        leftSlideScreen.menuWidth = (view.frame.width / 2) + (view.frame.width / 4)
        SideMenuManager.default.menuRightNavigationController = leftSlideScreen
    }
    
    func activityContents()
    {
        activeView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        activeView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        backgroundImage.addSubview(activeView)
        
        self.view.bringSubviewToFront(activeView)
    
        activityView.frame = CGRect(x: ((activeView.frame.width - 50) / 2), y: ((activeView.frame.height - 50) / 2), width: 50, height: 50)
        activityView.style = .whiteLarge
        activityView.color = UIColor.white
        activityView.startAnimating()
        activeView.addSubview(activityView)
    }
    
    func stopActivity()
    {
        activeView.removeFromSuperview()
        activityView.stopAnimating()
    }
    
    func navigationContents()
    {
        backgroundImage.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        backgroundImage.image = UIImage(named: "background")
        selfScreenContents1.addSubview(backgroundImage)
        
        let testImage = UIImageView()
        testImage.frame = CGRect(x: 50, y: 100, width: view.frame.width - 100, height: 200)
        testImage.image = UIImage(named: "go-to-tailor-shop")
        //        view.addSubview(testImage)
        
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        navigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        selfScreenContents1.addSubview(navigationBar)
        
        navigationTitle.frame = CGRect(x: 0, y: (2 * y), width: navigationBar.frame.width, height: (3 * y))
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        navigationTitle.font = navigationTitle.font.withSize(2 * x)
        navigationBar.addSubview(navigationTitle)
        
        userImage.frame = CGRect(x: (2 * x), y: (2 * y), width: (4 * y), height: (4 * y))
        //        userImage.image = UIImage(named: "women")
        userImage.image = FileHandler().getImageFromDocumentDirectory()
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.layer.borderWidth = 1
        userImage.layer.masksToBounds = true
        navigationBar.addSubview(userImage)
        
        notificationButton.frame = CGRect(x: navigationBar.frame.width - 50, y: navigationTitle.frame.minY, width: 30, height: 30)
        notificationButton.setImage(UIImage(named: "notification"), for: .normal)
        //        notificationButton.addTarget(self, action: #selector(self.selectionButtonAction(sender:)), for: .touchUpInside)
//        navigationBar.addSubview(notificationButton)
        
        pageBar.frame = CGRect(x: 0, y: navigationBar.frame.maxY, width: view.frame.width, height: (5 * y))
        pageBar.backgroundColor = UIColor.clear
        view.addSubview(pageBar)
        
        /*button1.frame = CGRect(x: 0, y: 0, width: pageBar.frame.width / 9, height: (3 * y))
        button1.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.white.cgColor
        button1.backgroundColor = UIColor.orange
        button1.setTitle("\(1)", for: .normal)
        button1.setTitleColor(UIColor.white, for: .normal)
        pageBar.addSubview(button1)
        
        button2.frame = CGRect(x: button1.frame.maxX, y: 0, width: pageBar.frame.width / 9, height: (3 * y))
        button2.layer.borderWidth = 1
        button2.layer.borderColor = UIColor.white.cgColor
        button2.backgroundColor = UIColor.orange
        button2.setTitle("\(2)", for: .normal)
        button2.setTitleColor(UIColor.white, for: .normal)
        pageBar.addSubview(button2)
        
        button3.frame = CGRect(x: button2.frame.maxX, y: 0, width: pageBar.frame.width / 9, height: (3 * y))
        button3.layer.borderWidth = 1
        button3.layer.borderColor = UIColor.white.cgColor
        button3.backgroundColor = UIColor.orange
        button3.setTitle("\(3)", for: .normal)
        button3.setTitleColor(UIColor.white, for: .normal)
        pageBar.addSubview(button3)
        
        button4.frame = CGRect(x: button3.frame.maxX, y: 0, width: pageBar.frame.width / 9, height: (3 * y))
        button4.layer.borderWidth = 1
        button4.layer.borderColor = UIColor.white.cgColor
        button4.backgroundColor = UIColor.orange
        button4.setTitle("\(4)", for: .normal)
        button4.setTitleColor(UIColor.white, for: .normal)
        pageBar.addSubview(button4)
        
        button5.frame = CGRect(x: button4.frame.maxX, y: 0, width: pageBar.frame.width / 9, height: (3 * y))
        button5.layer.borderWidth = 1
        button5.layer.borderColor = UIColor.white.cgColor
        button5.backgroundColor = UIColor.orange
        button5.setTitle("\(5)", for: .normal)
        button5.setTitleColor(UIColor.white, for: .normal)
        pageBar.addSubview(button5)
        
        button6.frame = CGRect(x: button5.frame.maxX, y: 0, width: pageBar.frame.width / 9, height: (3 * y))
        button6.layer.borderWidth = 1
        button6.layer.borderColor = UIColor.white.cgColor
        button6.backgroundColor = UIColor.orange
        button6.setTitle("\(6)", for: .normal)
        button6.setTitleColor(UIColor.white, for: .normal)
        pageBar.addSubview(button6)
        
        button7.frame = CGRect(x: button6.frame.maxX, y: 0, width: pageBar.frame.width / 9, height: (3 * y))
        button7.layer.borderWidth = 1
        button7.layer.borderColor = UIColor.white.cgColor
        button7.backgroundColor = UIColor.orange
        button7.setTitle("\(7)", for: .normal)
        button7.setTitleColor(UIColor.white, for: .normal)
        pageBar.addSubview(button7)
        
        button8.frame = CGRect(x: button7.frame.maxX, y: 0, width: pageBar.frame.width / 9, height: (3 * y))
        button8.layer.borderWidth = 1
        button8.layer.borderColor = UIColor.white.cgColor
        button8.backgroundColor = UIColor.orange
        button8.setTitle("\(8)", for: .normal)
        button8.setTitleColor(UIColor.white, for: .normal)
        pageBar.addSubview(button8)
        
        button9.frame = CGRect(x: button8.frame.maxX, y: 0, width: pageBar.frame.width / 9, height: (3 * y))
        button9.layer.borderWidth = 1
        button9.layer.borderColor = UIColor.white.cgColor
        button9.backgroundColor = UIColor.orange
        button9.setTitle("\(9)", for: .normal)
        button9.setTitleColor(UIColor.white, for: .normal)
        pageBar.addSubview(button9)*/
        
        /*var x1:CGFloat = 0
        
        for i in 0..<9
        {
            let button = UIButton()
            button.frame = CGRect(x: x1, y: 0, width: pageBar.frame.width / 9, height: (3 * y))
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
            button.backgroundColor = UIColor.clear
            button.setTitle("\(i + 1)", for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.tag = (i * 1) + 1000
            pageBar.addSubview(button)
            
            x1 = button.frame.maxX
        }*/
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                changeViewToEnglish()
            }
            else if language == "ar"
            {
                changeViewToArabic()
            }
        }
        else
        {
            changeViewToEnglish()
        }
    }
    
    func changeViewToEnglish()
    {
        selfScreenContents1.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
//        navigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

//        tabBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        slideMenuButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        userImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        tab1ImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        tab1Text.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        tab1Text.text = "Home"
        tab2ImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        tab2Text.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        tab2Text.text = "Request"
        tab3ImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        tab3Text.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        tab3Text.text = "Orders"
        tab4ImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        tab4Text.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        tab4Text.text = "Rewards"
    }
    
    func changeViewToArabic()
    {
        selfScreenContents1.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
//        navigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)

//        tabBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        slideMenuButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        userImage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        tab1ImageView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        tab1Text.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        tab1Text.text = "منزل"
        tab2ImageView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        tab2Text.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        tab2Text.text = "طلب"
        tab3ImageView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        tab3Text.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        tab3Text.text = "أوامر"
        tab4ImageView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        tab4Text.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        tab4Text.text = "كارة"
    }
    
    func tabContents()
    {
        slideMenuButton.isHidden = true
        slideMenuButton.frame = CGRect(x: 0, y: ((view.frame.height - (6.5 * y)) / 2), width: (2.5 * x), height: (6.5 * y))
        slideMenuButton.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        slideMenuButton.setImage(UIImage(named: "openMenu"), for: .normal)
        slideMenuButton.tag = 0
        slideMenuButton.addTarget(self, action: #selector(self.slideMenuButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents1.addSubview(slideMenuButton)
        
        tabBar.frame = CGRect(x: 0, y: view.frame.height - (5 * y), width: view.frame.width, height: (5 * y))
        tabBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        selfScreenContents1.addSubview(tabBar)
        
        tab1Button.frame = CGRect(x: 0, y: 0, width: (9.37 * x), height: (5 * y))
        tab1Button.tag = 0
        tab1Button.addTarget(self, action: #selector(self.tabBarButtonAction(sender:)), for: .touchUpInside)
        tabBar.addSubview(tab1Button)
        
        tab1ImageView.frame = CGRect(x: ((tab1Button.frame.width - (3 * x)) / 2), y: (y / 3), width: (3 * x), height: (3 * y))
        tab1ImageView.image = UIImage(named: "home")
        tab1Button.addSubview(tab1ImageView)
        
        let templateImage = tab1ImageView.image?.withRenderingMode(.alwaysTemplate)
        tab1ImageView.image = templateImage
        tab1ImageView.tintColor = UIColor.orange
        
        tab1Text.frame = CGRect(x: 0, y: tab1ImageView.frame.maxY, width: (9.37 * x), height: y)
        tab1Text.text = "Home"
        tab1Text.textColor = UIColor.orange
        tab1Text.textAlignment = .center
        tab1Text.font = tab1Text.font.withSize(15)
        tab1Button.addSubview(tab1Text)
        
        tab2Button.frame = CGRect(x: tab1Button.frame.maxX, y: 0, width: (9.37 * x), height: (5 * y))
        tab2Button.tag = 1
        tab2Button.addTarget(self, action: #selector(self.tabBarButtonAction(sender:)), for: .touchUpInside)
        tabBar.addSubview(tab2Button)
        
        tab2ImageView.frame = CGRect(x: ((tab1Button.frame.width - (3 * x)) / 2), y: (y / 3), width: (3 * x), height: (3 * y))
        tab2ImageView.image = UIImage(named: "request")
        tab2Button.addSubview(tab2ImageView)
        
        tab2Text.frame = CGRect(x: 0, y: tab2ImageView.frame.maxY, width: (9.37 * x), height: y)
        tab2Text.text = "Request"
        tab2Text.textColor = UIColor.white
        tab2Text.textAlignment = .center
        tab2Text.font = tab2Text.font.withSize(10)
        tab2Button.addSubview(tab2Text)
        
        tab3Button.frame = CGRect(x: tab2Button.frame.maxX, y: 0, width: (9.37 * x), height: (5 * y))
        tab3Button.tag = 2
        tab3Button.addTarget(self, action: #selector(self.tabBarButtonAction(sender:)), for: .touchUpInside)
        tabBar.addSubview(tab3Button)
        
        tab3ImageView.frame = CGRect(x: ((tab1Button.frame.width - (3 * x)) / 2), y: (y / 3), width: (3 * x), height: (3 * y))
        tab3ImageView.image = UIImage(named: "order")
        tab3Button.addSubview(tab3ImageView)
        
        tab3Text.frame = CGRect(x: 0, y: tab3ImageView.frame.maxY, width: (9.37 * x), height: y)
        tab3Text.text = "Order"
        tab3Text.textColor = UIColor.white
        tab3Text.textAlignment = .center
        tab3Text.font = tab3Text.font.withSize(10)
        tab3Button.addSubview(tab3Text)
        
        tab4Button.frame = CGRect(x: tab3Button.frame.maxX, y: 0, width: (9.37 * x), height: (5 * y))
        tab4Button.tag = 3
        tab4Button.addTarget(self, action: #selector(self.tabBarButtonAction(sender:)), for: .touchUpInside)
        tabBar.addSubview(tab4Button)
        
        tab4ImageView.frame = CGRect(x: ((tab1Button.frame.width - (3 * x)) / 2), y: (y / 3), width: (3 * x), height: (3 * y))
        tab4ImageView.image = UIImage(named: "rewards")
        tab4Button.addSubview(tab4ImageView)
        
        tab4Text.frame = CGRect(x: 0, y: tab4ImageView.frame.maxY, width: (9.37 * x), height: y)
        tab4Text.text = "Rewards"
        tab4Text.textColor = UIColor.white
        tab4Text.textAlignment = .center
        tab4Text.font = tab4Text.font.withSize(10)
        tab4Button.addSubview(tab4Text)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                changeViewToEnglish()
            }
            else if language == "ar"
            {
                changeViewToArabic()
            }
        }
        else
        {
            changeViewToEnglish()
        }
    }
    
    @objc func slideMenuButtonAction(sender : UIButton)
    {
        UserDefaults.standard.set(1, forKey: "sideValue")
        
        sender.setImage(UIImage(named: "closeMenu"), for: .normal)
        
        SideMenuManager.default.menuLeftNavigationController?.dismiss(animated: true, completion: nil)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                self.dismiss(animated: true, completion: nil)
                self.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
            }
            else if language == "ar"
            {
                self.present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
            }
        }
        else
        {
            self.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        }
        
        
//        if let container = self.so_containerViewController {
//            container.isSideViewControllerPresented = true
//        }
        
//        self.sideMenuController?.cache(viewController: SlideViewController(), with: "true")
//        self.sideMenuController?.setContentViewController(to: SlideViewController())
        
        /*if sender.tag == 0
        {
            sender.setImage(UIImage(named: "closeMenu"), for: .normal)

            blurBlackView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            blurBlackView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            view.addSubview(blurBlackView)
            
            self.view.bringSubviewToFront(sender)
            window = UIWindow(frame: CGRect(x: 0, y: 0, width: view.frame.width - 100, height: view.frame.height))
            let navigationScreen = UINavigationController(rootViewController: SlideViewController())
            navigationScreen.isNavigationBarHidden = true
            window?.rootViewController = navigationScreen
            window?.makeKeyAndVisible()
            
            
            sender.frame = CGRect(x: view.frame.width - 100, y: ((view.frame.height - (6.5 * y)) / 2), width: (2.5 * x), height: (6.5 * y))
            sender.tag = 1
            
            blurBlackView.addSubview(sender)
        }
        else
        {
            sender.setImage(UIImage(named: "openMenu"), for: .normal)

            blurBlackView.removeFromSuperview()
            
            view.addSubview(sender)
            
            let views = Variables()
            
            views.viewController.view.isUserInteractionEnabled = true
            
            print("VIEW CONTROLLER NAME", views.viewController)
            
            sender.frame = CGRect(x: 0, y: ((view.frame.height - (6.5 * y)) / 2), width: (2.5 * x), height: (6.5 * y))
            sender.tag = 0
            
            window = UIWindow(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            let navigationScreen = UINavigationController(rootViewController: views.viewController)
            navigationScreen.isNavigationBarHidden = true
            window?.rootViewController = navigationScreen
            window?.makeKeyAndVisible()
        }*/
    }
    
    @objc func tabBarButtonAction(sender : UIButton)
    {
        selectedButton(tag: sender.tag)
        
        var navigateScreen = UIViewController()
        
        var cartAlert = UIAlertController()
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                cartAlert = UIAlertController(title: "Alert", message: "Reward is Empty", preferredStyle: .alert)
                cartAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            }
            else if language == "ar"
            {
                cartAlert = UIAlertController(title: "تنبيه", message: "المكافأة فارغة", preferredStyle: .alert)
                cartAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: nil))
            }
        }
        else
        {
            cartAlert = UIAlertController(title: "Alert", message: "Reward is Empty", preferredStyle: .alert)
            cartAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        
        // Home..
        if sender.tag == 0
        {
            navigateScreen = HomeViewController()
            window = UIWindow(frame: UIScreen.main.bounds)
            let navigationScreen = UINavigationController(rootViewController: navigateScreen)
            navigationScreen.isNavigationBarHidden = true
            window?.rootViewController = navigationScreen
            window?.makeKeyAndVisible()
        }
            // Request..
        else if sender.tag == 1
        {
            navigateScreen = OrderRequestListViewController()
            window = UIWindow(frame: UIScreen.main.bounds)
            let navigationScreen = UINavigationController(rootViewController: navigateScreen)
            navigationScreen.isNavigationBarHidden = true
            window?.rootViewController = navigationScreen
            window?.makeKeyAndVisible()
            
            /*
             navigateScreen = OrdersViewController()
             self.present(alertControls, animated: true, completion: nil)
             */
        }
            // Orders...
        else if sender.tag == 2
        {
            navigateScreen = ListOfOrdersViewController()
            window = UIWindow(frame: UIScreen.main.bounds)
            let navigationScreen = UINavigationController(rootViewController: navigateScreen)
            navigationScreen.isNavigationBarHidden = true
            window?.rootViewController = navigationScreen
            window?.makeKeyAndVisible()
            
            /*
             navigateScreen = CartViewController()
             */
        }
        else
        {
            stopActivity()
            self.present(cartAlert, animated: true, completion: nil)
        }
        /*  // Cart..
         else if sender.tag == 3
         {
         navigateScreen = ContactUsViewController()
         }*/
    }
    
    func selectedButton(tag : Int)
    {
        let templateImage = tab1ImageView.image?.withRenderingMode(.alwaysTemplate)
        tab1ImageView.image = templateImage
        
        let templateImage2 = tab2ImageView.image?.withRenderingMode(.alwaysTemplate)
        tab2ImageView.image = templateImage2
        
        let templateImage3 = tab3ImageView.image?.withRenderingMode(.alwaysTemplate)
        tab3ImageView.image = templateImage3
        
        let templateImage4 = tab4ImageView.image?.withRenderingMode(.alwaysTemplate)
        tab4ImageView.image = templateImage4
        
        if tag == 0
        {
            tab1Text.font = tab1Text.font.withSize(15)
            tab1Text.textColor = UIColor.orange
            
            tab1ImageView.tintColor = UIColor.orange
            
            tab2Text.font = tab2Text.font.withSize(10)
            tab2Text.textColor = UIColor.white
            
            tab2ImageView.tintColor = UIColor.white
            
            tab3Text.font = tab3Text.font.withSize(10)
            tab3Text.textColor = UIColor.white
            
            tab3ImageView.tintColor = UIColor.white
            
            tab4Text.font = tab4Text.font.withSize(10)
            tab4Text.textColor = UIColor.white
            
            tab4ImageView.tintColor = UIColor.white
        }
        else if tag == 1
        {
            tab1Text.font = tab1Text.font.withSize(10)
            tab1Text.textColor = UIColor.white
            
            tab1ImageView.tintColor = UIColor.white
            
            tab2Text.font = tab2Text.font.withSize(15)
            tab2Text.textColor = UIColor.orange
            
            tab2ImageView.tintColor = UIColor.orange
            
            tab3Text.font = tab3Text.font.withSize(10)
            tab3Text.textColor = UIColor.white
            
            tab3ImageView.tintColor = UIColor.white
            
            tab4Text.font = tab4Text.font.withSize(10)
            tab4Text.textColor = UIColor.white
            
            tab4ImageView.tintColor = UIColor.white
        }
        else if tag == 2
        {
            tab1Text.font = tab1Text.font.withSize(10)
            tab1Text.textColor = UIColor.white
            
            tab1ImageView.tintColor = UIColor.white
            
            tab2Text.font = tab2Text.font.withSize(10)
            tab2Text.textColor = UIColor.white
            
            tab2ImageView.tintColor = UIColor.white
            
            tab3Text.font = tab3Text.font.withSize(15)
            tab3Text.textColor = UIColor.orange
            
            tab3ImageView.tintColor = UIColor.orange
            
            tab4Text.font = tab4Text.font.withSize(10)
            tab4Text.textColor = UIColor.white
            
            tab4ImageView.tintColor = UIColor.white
        }
        else if tag == 3
        {
            tab1Text.font = tab1Text.font.withSize(10)
            tab1Text.textColor = UIColor.white
            
            tab1ImageView.tintColor = UIColor.white
            
            tab2Text.font = tab2Text.font.withSize(10)
            tab2Text.textColor = UIColor.white
            
            tab2ImageView.tintColor = UIColor.white
            
            tab3Text.font = tab3Text.font.withSize(10)
            tab3Text.textColor = UIColor.white
            
            tab3ImageView.tintColor = UIColor.white
            
            tab4Text.font = tab4Text.font.withSize(15)
            tab4Text.textColor = UIColor.orange
            
            tab4ImageView.tintColor = UIColor.orange
        }
    }
    
    func pageContent(tag : Int)
    {
        if tag == 1
        {
            button1.backgroundColor = UIColor.blue
        }
        else if tag == 2
        {
            button1.backgroundColor = UIColor.blue
            button2.backgroundColor = UIColor.blue
        }
        else if tag == 3
        {
            button1.backgroundColor = UIColor.blue
            button2.backgroundColor = UIColor.blue
            button3.backgroundColor = UIColor.blue
        }
        else if tag == 4
        {
            button1.backgroundColor = UIColor.blue
            button2.backgroundColor = UIColor.blue
            button3.backgroundColor = UIColor.blue
            button4.backgroundColor = UIColor.blue
        }
        else if tag == 5
        {
            button1.backgroundColor = UIColor.blue
            button2.backgroundColor = UIColor.blue
            button3.backgroundColor = UIColor.blue
            button4.backgroundColor = UIColor.blue
            button5.backgroundColor = UIColor.blue
        }
        else if tag == 6
        {
            button1.backgroundColor = UIColor.blue
            button2.backgroundColor = UIColor.blue
            button3.backgroundColor = UIColor.blue
            button4.backgroundColor = UIColor.blue
            button5.backgroundColor = UIColor.blue
            button6.backgroundColor = UIColor.blue
        }
        else if tag == 7
        {
            button1.backgroundColor = UIColor.blue
            button2.backgroundColor = UIColor.blue
            button3.backgroundColor = UIColor.blue
            button4.backgroundColor = UIColor.blue
            button5.backgroundColor = UIColor.blue
            button6.backgroundColor = UIColor.blue
            button7.backgroundColor = UIColor.blue
        }
        else if tag == 8
        {
            button1.backgroundColor = UIColor.blue
            button2.backgroundColor = UIColor.blue
            button3.backgroundColor = UIColor.blue
            button4.backgroundColor = UIColor.blue
            button5.backgroundColor = UIColor.blue
            button6.backgroundColor = UIColor.blue
            button7.backgroundColor = UIColor.blue
            button8.backgroundColor = UIColor.blue
        }
        else if tag == 9
        {
            button1.backgroundColor = UIColor.blue
            button2.backgroundColor = UIColor.blue
            button3.backgroundColor = UIColor.blue
            button4.backgroundColor = UIColor.blue
            button5.backgroundColor = UIColor.blue
            button6.backgroundColor = UIColor.blue
            button7.backgroundColor = UIColor.blue
            button8.backgroundColor = UIColor.blue
            button9.backgroundColor = UIColor.blue
        }
    }
    
    func hintsViewContents()
    {
        hintsView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        hintsView.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        
        let onOrOffValue = UserDefaults.standard.value(forKey: "hintsSwitch") as! Int

        if onOrOffValue == 1
        {
            view.addSubview(hintsView)
        }
        else
        {
            hintsView.removeFromSuperview()
        }
        
        gotItButton.frame = CGRect(x: hintsView.frame.width - (12 * x), y: hintsView.frame.height - (6 * y), width: (10 * x), height: (4 * y))
        gotItButton.backgroundColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0)
        gotItButton.setTitle("Got it", for: .normal)
        gotItButton.setTitleColor(UIColor.white, for: .normal)
        gotItButton.addTarget(self, action: #selector(self.hintsButtonAction(sender:)), for: .touchUpInside)
        hintsView.addSubview(gotItButton)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                hintsView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                gotItButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                gotItButton.setTitle("Got it", for: .normal)
            }
            else if language == "ar"
            {
                hintsView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                gotItButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                gotItButton.setTitle("حصلت عليك", for: .normal)
            }
        }
        else
        {
            hintsView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            gotItButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            gotItButton.setTitle("Got it", for: .normal)
        }
    }
    
    @objc func hintsButtonAction(sender : UIButton)
    {
        hintsView.removeFromSuperview()
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

extension UIImageView
{
    func dowloadFromServer(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func dowloadFromServer(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        dowloadFromServer(url: url, contentMode: mode)
    }
}


extension CommonViewController: UISideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }
    
    func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }
    
    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }
    
    func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
        slideMenuButton.setImage(UIImage(named: "openMenu"), for: .normal)
    }
    
}
