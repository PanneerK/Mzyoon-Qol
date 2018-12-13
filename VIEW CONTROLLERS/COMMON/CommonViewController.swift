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

    let tab1Button = UIButton()
    let tab2Button = UIButton()
    let tab3Button = UIButton()
    let tab4Button = UIButton()
    
    var activeView = UIView()
    var activityView = UIActivityIndicatorView()
        
    override func viewDidLoad()
    {
        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
        
        navigationContents()
        tabContents()
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
        userImage.frame = CGRect(x: (2 * x), y: (2 * y), width: 40, height: 40)
//        userImage.image = UIImage(named: "women")
        userImage.image = FileHandler().getImageFromDocumentDirectory()
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.layer.masksToBounds = true
        navigationBar.addSubview(userImage)
        
        let notificationButton = UIButton()
        notificationButton.frame = CGRect(x: navigationBar.frame.width - 50, y: navigationTitle.frame.minY, width: 30, height: 30)
        notificationButton.setImage(UIImage(named: "notification"), for: .normal)
        //        notificationButton.addTarget(self, action: #selector(self.selectionButtonAction(sender:)), for: .touchUpInside)
        navigationBar.addSubview(notificationButton)
    }
    
    func tabContents()
    {
        let slideMenuButton = UIButton()
        slideMenuButton.frame = CGRect(x: 0, y: ((view.frame.height - 65) / 2), width: 30, height: 65)
        slideMenuButton.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        slideMenuButton.setImage(UIImage(named: "openMenu"), for: .normal)
        slideMenuButton.addTarget(self, action: #selector(self.slideMenuButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(slideMenuButton)
        
        let tabBar = UIView()
        tabBar.frame = CGRect(x: 0, y: view.frame.height - (5 * y), width: view.frame.width, height: (5 * y))
        tabBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        view.addSubview(tabBar)

        tab1Button.frame = CGRect(x: 0, y: 0, width: (9.37 * x), height: (5 * y))
        tab1Button.tag = 0
        tab1Button.addTarget(self, action: #selector(self.tabBarButtonAction(sender:)), for: .touchUpInside)
        tabBar.addSubview(tab1Button)
        
        tab2Button.frame = CGRect(x: tab1Button.frame.maxX, y: 0, width: (9.37 * x), height: (5 * y))
        tab2Button.tag = 1
        tab2Button.addTarget(self, action: #selector(self.tabBarButtonAction(sender:)), for: .touchUpInside)
        tabBar.addSubview(tab2Button)
        
        tab3Button.frame = CGRect(x: tab2Button.frame.maxX, y: 0, width: (9.37 * x), height: (5 * y))
        tab3Button.tag = 2
        tab3Button.addTarget(self, action: #selector(self.tabBarButtonAction(sender:)), for: .touchUpInside)
        tabBar.addSubview(tab3Button)
        
        tab4Button.frame = CGRect(x: tab3Button.frame.maxX, y: 0, width: (9.37 * x), height: (5 * y))
        tab4Button.tag = 3
        tab4Button.addTarget(self, action: #selector(self.tabBarButtonAction(sender:)), for: .touchUpInside)
        tabBar.addSubview(tab4Button)
        
        let tabTitle = ["Home", "Order", "Cart", "Contact-Us"]
        let tabImages = ["home", "order", "cart", "contact-us"]
        
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
        }
    }
    
    @objc func slideMenuButtonAction(sender : UIButton)
    {
        sender.setImage(UIImage(named: "closeMenu"), for: .normal)
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @objc func tabBarButtonAction(sender : UIButton)
    {
        var navigateScreen = UIViewController()
        let alertControls = UIAlertController(title: "Alert", message: "Under development", preferredStyle: .alert)
        alertControls.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        if sender.tag == 0
        {
            navigateScreen = HomeViewController()
            window = UIWindow(frame: UIScreen.main.bounds)
            let navigationScreen = UINavigationController(rootViewController: navigateScreen)
            navigationScreen.isNavigationBarHidden = true
            window?.rootViewController = navigationScreen
            window?.makeKeyAndVisible()
        }
        else
        {
            stopActivity()
            self.present(alertControls, animated: true, completion: nil)
        }
        /*else if sender.tag == 1
        {
            stopActivity()
            navigateScreen = OrdersViewController()
            self.present(alertControls, animated: true, completion: nil)
        }
        else if sender.tag == 2
        {
            stopActivity()
            navigateScreen = CartViewController()
        }
        else if sender.tag == 3
        {
            stopActivity()
            navigateScreen = ContactUsViewController()
        }*/
        
     
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

extension UIImageView {
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
