//
//  CommonViewController.swift
//  Mzyoon
//
//  Created by QOL on 16/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit
import SideMenu

class CommonViewController: UIViewController
{
    var window: UIWindow?
    
    var x = CGFloat()
    var y = CGFloat()
    
    let backgroundImage = UIImageView()
    let navigationBar = UIView()
    let navigationTitle = UILabel()
    
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
    
    override func viewDidLoad()
    {
        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
        
        navigationContents()
//        navigationContentsInArabic()
        tabContents()
//        tabContentsInArabic()
        self.activityContents()
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func activityContents()
    {
        activeView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        activeView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        view.addSubview(activeView)
        
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
        view.addSubview(backgroundImage)
        
        let testImage = UIImageView()
        testImage.frame = CGRect(x: 50, y: 100, width: view.frame.width - 100, height: 200)
        testImage.image = UIImage(named: "go-to-tailor-shop")
        //        view.addSubview(testImage)
        
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        navigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        view.addSubview(navigationBar)
        
        navigationTitle.frame = CGRect(x: 0, y: (2 * y), width: navigationBar.frame.width, height: (3 * y))
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        navigationBar.addSubview(navigationTitle)
        
        let userImage = UIImageView()
        userImage.frame = CGRect(x: (2 * x), y: (2 * y), width: (4 * y), height: (4 * y))
        //        userImage.image = UIImage(named: "women")
        userImage.image = FileHandler().getImageFromDocumentDirectory()
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.layer.borderWidth = 1
        userImage.layer.masksToBounds = true
        navigationBar.addSubview(userImage)
        
        let notificationButton = UIButton()
        notificationButton.frame = CGRect(x: navigationBar.frame.width - 50, y: navigationTitle.frame.minY, width: 30, height: 30)
        notificationButton.setImage(UIImage(named: "notification"), for: .normal)
        //        notificationButton.addTarget(self, action: #selector(self.selectionButtonAction(sender:)), for: .touchUpInside)
        navigationBar.addSubview(notificationButton)
    }
    
    func navigationContentsInArabic()
    {
        backgroundImage.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        backgroundImage.image = UIImage(named: "background")
        view.addSubview(backgroundImage)
        
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        navigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        view.addSubview(navigationBar)
        
        navigationTitle.frame = CGRect(x: 0, y: (2 * y), width: navigationBar.frame.width, height: (3 * y))
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        navigationBar.addSubview(navigationTitle)
        
        let userImage = UIImageView()
        userImage.frame = CGRect(x: navigationBar.frame.width - (6 * x), y: (2 * y), width: (4 * y), height: (4 * y))
        userImage.image = FileHandler().getImageFromDocumentDirectory()
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.layer.borderWidth = 1
        userImage.layer.masksToBounds = true
        navigationBar.addSubview(userImage)
        
        let notificationButton = UIButton()
        notificationButton.frame = CGRect(x: (2 * x), y: navigationTitle.frame.minY, width: (4 * x), height: (4 * y))
        notificationButton.setImage(UIImage(named: "notification"), for: .normal)
        //        notificationButton.addTarget(self, action: #selector(self.selectionButtonAction(sender:)), for: .touchUpInside)
        navigationBar.addSubview(notificationButton)
    }
    
    func tabContents()
    {
        //let slideMenuButton = UIButton()
        slideMenuButton.frame = CGRect(x: 0, y: ((view.frame.height - (6.5 * y)) / 2), width: (2.5 * x), height: (6.5 * y))
        slideMenuButton.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        slideMenuButton.setImage(UIImage(named: "openMenu"), for: .normal)
        slideMenuButton.addTarget(self, action: #selector(self.slideMenuButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(slideMenuButton)
        
        // let tabBar = UIView()
        tabBar.frame = CGRect(x: 0, y: view.frame.height - (5 * y), width: view.frame.width, height: (5 * y))
        tabBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        view.addSubview(tabBar)
        
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
        tab4ImageView.image = UIImage(named: "cart")
        tab4Button.addSubview(tab4ImageView)
        
        tab4Text.frame = CGRect(x: 0, y: tab4ImageView.frame.maxY, width: (9.37 * x), height: y)
        tab4Text.text = "Cart"
        tab4Text.textColor = UIColor.white
        tab4Text.textAlignment = .center
        tab4Text.font = tab4Text.font.withSize(10)
        tab4Button.addSubview(tab4Text)
        
        /*let tabTitle = ["Home", "Request", "Order", "Cart"]
         let tabImages = ["home", "request", "order", "cart"]
         
         for i in 0..<4
         {
         let tabButtonImageView = UIImageView()
         tabButtonImageView.frame = CGRect(x: ((tab1Button.frame.width - (3 * x)) / 2), y: (y / 2), width: (3 * x), height: (3 * y))
         tabButtonImageView.image = UIImage(named: tabImages[i])
         
         let tabButtonTitleLabel = UILabel()
         tabButtonTitleLabel.frame = CGRect(x: 0, y: (3.5 * y), width: (9.37 * x), height: y)
         tabButtonTitleLabel.text = tabTitle[i]
         tabButtonTitleLabel.textColor = UIColor.white
         tabButtonTitleLabel.textAlignment = .center
         tabButtonTitleLabel.font = tabButtonTitleLabel.font.withSize(10)
         
         if i == 0
         {
         tab1Button.addSubview(tabButtonImageView)
         tab1Button.addSubview(tabButtonTitleLabel)
         }
         else if i == 1
         {
         tab2Button.addSubview(tabButtonImageView)
         tab2Button.addSubview(tabButtonTitleLabel)
         }
         else if i == 2
         {
         tab3Button.addSubview(tabButtonImageView)
         tab3Button.addSubview(tabButtonTitleLabel)
         }
         else if i == 3
         {
         tab4Button.addSubview(tabButtonImageView)
         tab4Button.addSubview(tabButtonTitleLabel)
         }
         }*/
    }
    
    func tabContentsInArabic()
    {
        //let slideMenuButton = UIButton()
        slideMenuButton.frame = CGRect(x: view.frame.width - (2.5 * x), y: ((view.frame.height - (6.5 * y)) / 2), width: (2.5 * x), height: (6.5 * y))
        slideMenuButton.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        slideMenuButton.setImage(UIImage(named: "openMenu"), for: .normal)
        slideMenuButton.addTarget(self, action: #selector(self.slideMenuButtonActionArabic(sender:)), for: .touchUpInside)
        view.addSubview(slideMenuButton)
        
        // let tabBar = UIView()
        tabBar.frame = CGRect(x: 0, y: view.frame.height - (5 * y), width: view.frame.width, height: (5 * y))
        tabBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        view.addSubview(tabBar)
        
        tab1Button.frame = CGRect(x: 0, y: 0, width: (9.37 * x), height: (5 * y))
        tab1Button.tag = 3
        tab1Button.addTarget(self, action: #selector(self.tabBarButtonAction(sender:)), for: .touchUpInside)
        tabBar.addSubview(tab1Button)
        
        tab1ImageView.frame = CGRect(x: ((tab1Button.frame.width - (3 * x)) / 2), y: (y / 3), width: (3 * x), height: (3 * y))
        tab1ImageView.image = UIImage(named: "cart")
        tab1Button.addSubview(tab1ImageView)
        
        tab1Text.frame = CGRect(x: 0, y: tab1ImageView.frame.maxY, width: (9.37 * x), height: y)
        tab1Text.text = "عربة التسوق"
        tab1Text.textColor = UIColor.white
        tab1Text.textAlignment = .center
        tab1Text.font = tab1Text.font.withSize(15)
        tab1Button.addSubview(tab1Text)
        
        tab2Button.frame = CGRect(x: tab1Button.frame.maxX, y: 0, width: (9.37 * x), height: (5 * y))
        tab2Button.tag = 2
        tab2Button.addTarget(self, action: #selector(self.tabBarButtonAction(sender:)), for: .touchUpInside)
        tabBar.addSubview(tab2Button)
        
        tab2ImageView.frame = CGRect(x: ((tab1Button.frame.width - (3 * x)) / 2), y: (y / 3), width: (3 * x), height: (3 * y))
        tab2ImageView.image = UIImage(named: "order")
        tab2Button.addSubview(tab2ImageView)
        
        tab2Text.frame = CGRect(x: 0, y: tab2ImageView.frame.maxY, width: (9.37 * x), height: y)
        tab2Text.text = "طلب"
        tab2Text.textColor = UIColor.white
        tab2Text.textAlignment = .center
        tab2Text.font = tab2Text.font.withSize(10)
        tab2Button.addSubview(tab2Text)
        
        tab3Button.frame = CGRect(x: tab2Button.frame.maxX, y: 0, width: (9.37 * x), height: (5 * y))
        tab3Button.tag = 1
        tab3Button.addTarget(self, action: #selector(self.tabBarButtonAction(sender:)), for: .touchUpInside)
        tabBar.addSubview(tab3Button)
        
        tab3ImageView.frame = CGRect(x: ((tab1Button.frame.width - (3 * x)) / 2), y: (y / 3), width: (3 * x), height: (3 * y))
        tab3ImageView.image = UIImage(named: "request")
        tab3Button.addSubview(tab3ImageView)
        
        tab3Text.frame = CGRect(x: 0, y: tab3ImageView.frame.maxY, width: (9.37 * x), height: y)
        tab3Text.text = "طلب"
        tab3Text.textColor = UIColor.white
        tab3Text.textAlignment = .center
        tab3Text.font = tab3Text.font.withSize(10)
        tab3Button.addSubview(tab3Text)
        
        tab4Button.frame = CGRect(x: tab3Button.frame.maxX, y: 0, width: (9.37 * x), height: (5 * y))
        tab4Button.tag = 0
        tab4Button.addTarget(self, action: #selector(self.tabBarButtonAction(sender:)), for: .touchUpInside)
        tabBar.addSubview(tab4Button)
        
        tab4ImageView.frame = CGRect(x: ((tab1Button.frame.width - (3 * x)) / 2), y: (y / 3), width: (3 * x), height: (3 * y))
        tab4ImageView.image = UIImage(named: "home")
        tab4Button.addSubview(tab4ImageView)
        
        let templateImage = tab4ImageView.image?.withRenderingMode(.alwaysTemplate)
        tab4ImageView.image = templateImage
        tab4ImageView.tintColor = UIColor.orange
        
        tab4Text.frame = CGRect(x: 0, y: tab4ImageView.frame.maxY, width: (9.37 * x), height: y)
        tab4Text.text = "الصفحة الرئيسية"
        tab4Text.textColor = UIColor.orange
        tab4Text.textAlignment = .center
        tab4Text.font = tab4Text.font.withSize(10)
        tab4Button.addSubview(tab4Text)
    }
    
    @objc func slideMenuButtonAction(sender : UIButton)
    {
        self.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @objc func slideMenuButtonActionArabic(sender : UIButton)
    {
        self.present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
    }
    
    @objc func tabBarButtonAction(sender : UIButton)
    {
        selectedButton(tag: sender.tag)
        
        var navigateScreen = UIViewController()
        let alertControls = UIAlertController(title: "Alert", message: "No Data", preferredStyle: .alert)
        alertControls.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
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
             stopActivity()
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
             stopActivity()
             navigateScreen = CartViewController()
             */
        }
        else
        {
            stopActivity()
            self.present(alertControls, animated: true, completion: nil)
        }
        /*  // Cart..
         else if sender.tag == 3
         {
         stopActivity()
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
