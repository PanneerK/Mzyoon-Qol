//
//  SlideViewController.swift
//  Mzyoon
//
//  Created by QOL on 31/10/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit
import SideMenu

class SlideViewController: UIViewController
{
    
    var x = CGFloat()
    var y = CGFloat()
    
    var slideViewWidth = CGFloat()
    
    var window: UIWindow?
    
    let userImage = UIImageView()
    let userName = UILabel()

    let commonScreen = CommonViewController()
    
    override func viewDidLoad()
    {
        print("MENU WIDTH", view.frame.width)
        
        slideViewWidth = (view.frame.width / 2) + (view.frame.width / 4)
        
        x = 10 / 375 * 100
        x = x * slideViewWidth / 100
        
        print("SLIDE MENU", x, slideViewWidth)
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
        
        view.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
                
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                screenContents()
            }
            else
            {
                screenContentsInArabic()
            }
        }
        else
        {
            screenContents()
        }
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        commonScreen.slideMenuButton.setImage(UIImage(named: "openMenu"), for: .normal)
        print("WELCOME TO DISAPPEAR")
    }
    
    func screenContents()
    {
        userImage.frame = CGRect(x: ((slideViewWidth - (10 * x)) / 2), y: (5 * y), width: (10 * x), height: (10 * x))
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.layer.borderWidth = 0.50
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.masksToBounds = true
        userImage.image = FileHandler().getImageFromDocumentDirectory()
        view.addSubview(userImage)
        
        userName.frame = CGRect(x: 0, y: userImage.frame.maxY + y, width: slideViewWidth, height: (3 * y))
        if let name = UserDefaults.standard.value(forKey: "userName") as? String
        {
            userName.text = name
        }
        else
        {
            userName.text = ""
        }
        
        userName.textColor = UIColor.white
        userName.textAlignment = .center
        userName.font = UIFont(name: "Avenir-Regular", size: (2 * x))
        userName.font = userName.font.withSize((2 * x))
        view.addSubview(userName)
        
        let underline = UILabel()
        underline.frame = CGRect(x: 0, y: userName.frame.maxY + y, width: slideViewWidth, height: 0.25)
        underline.backgroundColor = UIColor.white
        view.addSubview(underline)
        
//        let buttonTitle = ["My Account", "Address", "Book an Appointment", "Transaction" ,"Rewards", "Refer Friends", "FAQ", "Terms and Conditions", "Settings", "Log Out"]
//        let buttonImage = ["my_account", "Address", "appointment-1", "transaction", "rewards", "refer_friends", "FAQ", "terms&condition", "settings", "logout"]
        
        let buttonTitle = ["My Account", "Address", "Add new measurements", "Settings", "Log Out"]
        let buttonImage = ["my_account", "Address", "Add new measurements", "settings", "logout"]
        
        var y1:CGFloat = userName.frame.maxY + (2 * y)
        
        for i in 0..<buttonTitle.count
        {
            let slideMenusButton = UIButton()
            slideMenusButton.frame = CGRect(x: 0, y: y1, width: slideViewWidth, height: (4 * y))
            slideMenusButton.tag = i
            
//            if i == 0 || i == 1 || i == 9 || i == 8
//            {
//                slideMenusButton.addTarget(self, action: #selector(self.menuButtonAction(sender:)), for: .touchUpInside)
//            }
            
            slideMenusButton.addTarget(self, action: #selector(self.menuButtonAction(sender:)), for: .touchUpInside)

            view.addSubview(slideMenusButton)
            
            let slideMenuButonImage = UIImageView()
            slideMenuButonImage.frame = CGRect(x: (2 * x), y: y, width: (3 * x), height: (2 * y))
            slideMenuButonImage.image = UIImage(named: buttonImage[i])
            slideMenusButton.addSubview(slideMenuButonImage)
            
            let slideMenuButtonTitle = UILabel()
            slideMenuButtonTitle.frame = CGRect(x: slideMenuButonImage.frame.maxX + x, y: y, width: slideMenusButton.frame.width - (4 * x), height: (2 * y))
            slideMenuButtonTitle.text = buttonTitle[i]
            slideMenuButtonTitle.textColor = UIColor.white
            slideMenuButtonTitle.textAlignment = .left
            slideMenuButtonTitle.font = slideMenuButtonTitle.font.withSize(2 * x)
            slideMenusButton.addSubview(slideMenuButtonTitle)
            
            let lineLabel = UILabel()
            lineLabel.frame = CGRect(x: 0, y: slideMenusButton.frame.maxY, width: slideViewWidth, height: 1)
            lineLabel.backgroundColor = UIColor.white
            view.addSubview(lineLabel)
            
            y1 = slideMenusButton.frame.maxY + y
        }
    }
    
    func screenContentsInArabic()
    {
        let userImage = UIImageView()
        userImage.frame = CGRect(x: ((slideViewWidth - (10 * x)) / 2), y: (2.5 * y), width: (10 * x), height: (10 * x))
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.layer.borderWidth = 0.50
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.masksToBounds = true
        userImage.image = FileHandler().getImageFromDocumentDirectory()
        view.addSubview(userImage)
        
        let userName = UILabel()
        userName.frame = CGRect(x: 0, y: userImage.frame.maxY + y, width: slideViewWidth, height: (3 * y))
        if let name = UserDefaults.standard.value(forKey: "userName") as? String
        {
            userName.text = name
        }
        else
        {
            userName.text = ""
        }
        
        userName.textColor = UIColor.white
        userName.textAlignment = .center
        userName.font = UIFont(name: "Avenir-Regular", size: (2 * x))
        userName.font = userName.font.withSize((2 * x))
        view.addSubview(userName)
        
        let underline = UILabel()
        underline.frame = CGRect(x: 0, y: userName.frame.maxY + y, width: slideViewWidth, height: 0.25)
        underline.backgroundColor = UIColor.white
        view.addSubview(underline)
        
//        let buttonTitle = ["حسابي", "عنوان", "حجز موعد", "عملية تجارية" ,"المكافآت", "إحالة الأصدقاء", "أسئلة شائعة", "الأحكام والشروط", "الإعدادات", "الخروج"]
//        let buttonImage = ["my_account", "Address", "appointment-1", "transaction", "rewards", "refer_friends", "FAQ", "terms&condition", "settings", "logout"]
        
        
        let buttonTitle = ["حسابي", "عنوان", "إضافة قياسات جديدة", "الإعدادات", "الخروج"]
        let buttonImage = ["my_account", "Address", "Add new measurements", "settings", "logout"]
        
        var y1:CGFloat = userName.frame.maxY + (2 * y)
        
        
        for i in 0..<buttonTitle.count
        {
            let slideMenusButton = UIButton()
            slideMenusButton.frame = CGRect(x: 0, y: y1, width: slideViewWidth, height: (4 * y))
            slideMenusButton.tag = i
            
//            if i == 0 || i == 1 || i == 9
//            {
//                slideMenusButton.addTarget(self, action: #selector(self.menuButtonAction(sender:)), for: .touchUpInside)
//            }
            
            slideMenusButton.addTarget(self, action: #selector(self.menuButtonAction(sender:)), for: .touchUpInside)
            
            view.addSubview(slideMenusButton)
            
            y1 = slideMenusButton.frame.maxY + y
            
            let slideMenuButonImage = UIImageView()
            slideMenuButonImage.frame = CGRect(x: slideMenusButton.frame.width - (4 * x), y: y, width: (3 * x), height: (2 * y))
            slideMenuButonImage.image = UIImage(named: buttonImage[i])
            slideMenusButton.addSubview(slideMenuButonImage)
            
            let slideMenuButtonTitle = UILabel()
            slideMenuButtonTitle.frame = CGRect(x: x, y: y, width: slideMenusButton.frame.width - (6 * x), height: (2 * y))
            slideMenuButtonTitle.text = buttonTitle[i]
            slideMenuButtonTitle.textColor = UIColor.white
            slideMenuButtonTitle.textAlignment = .left
            slideMenuButtonTitle.font = slideMenuButtonTitle.font.withSize(2 * x)
            slideMenuButtonTitle.textAlignment = .right
            slideMenusButton.addSubview(slideMenuButtonTitle)
        }
    }
    
    @objc func menuButtonAction(sender : UIButton)
    {
        if sender.tag == 0
        {
            let profileScreen = ProfileViewController()
            self.navigationController?.pushViewController(profileScreen, animated: true)
        }
        else if sender.tag == 1
        {
            let addressScreen = AddressViewController()
            addressScreen.viewController = "slide"
            self.navigationController?.pushViewController(addressScreen, animated: true)
        }
        else if sender.tag == 2
        {
            let measureScreen = AddNewMeasurementViewController()
            self.navigationController?.pushViewController(measureScreen, animated: true)
        }
        else if sender.tag == 3
        {
            let settingsScreen = SettingsViewController()
            self.navigationController?.pushViewController(settingsScreen, animated: true)
        }
        else if sender.tag == 4
        {
            var logoutAlert = UIAlertController()
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    logoutAlert = UIAlertController(title: "Alert", message: "Are you sure want to logout", preferredStyle: .alert)
                    logoutAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: logoutAlertOkAction(action:)))
                    logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                }
                else if language == "ar"
                {
                    logoutAlert = UIAlertController(title: "تنبيه", message: "هل أنت متأكد أنك تريد الخروج؟", preferredStyle: .alert)
                    logoutAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: logoutAlertOkAction(action:)))
                    logoutAlert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: nil))
                }
            }
            else
            {
                logoutAlert = UIAlertController(title: "Alert", message: "Are you sure want to logout", preferredStyle: .alert)
                logoutAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: logoutAlertOkAction(action:)))
                logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            }
            
            self.present(logoutAlert, animated: true, completion: nil)
        }
        /*else
        {
            let alertControls = UIAlertController(title: "Alert", message: "No Data", preferredStyle: .alert)
            alertControls.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertControls, animated: true, completion: nil)
        }*/
    }
    
    func logoutAlertOkAction(action : UIAlertAction)
    {
        
        SideMenuManager.default.menuLeftNavigationController?.dismiss(animated: true, completion: nil)
        SideMenuManager.default.menuRightNavigationController?.dismiss(animated: true, completion: nil)

        let navigateScreen = LoginViewController()
        navigateScreen.findString = "logout"
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationScreen = UINavigationController(rootViewController: navigateScreen)
        navigationScreen.isNavigationBarHidden = true
        window?.rootViewController = navigationScreen
        window?.makeKeyAndVisible()
        
    }
    
    @objc func slideMenuButtonAction(sender : UIButton)
    {
        view.removeFromSuperview()
    }
    
    func hintsAlertAction(action : UIAlertAction)
    {
        let onOrOff = Variables.sharedManager.hintsEnableTag
        
        if onOrOff == 1
        {
            Variables.sharedManager.hintsEnableTag = 0
        }
        else
        {           
            Variables.sharedManager.hintsEnableTag = 1
        }
        
        print("AFTER ASSIGNING", onOrOff)
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
