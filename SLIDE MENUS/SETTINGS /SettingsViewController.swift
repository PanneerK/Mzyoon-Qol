//
//  SettingsViewController.swift
//  Mzyoon
//
//  Created by QOL on 05/02/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ServerAPIDelegate
{

    var x = CGFloat()
    var y = CGFloat()
    
    let serviceCall = ServerAPI()
    
    let selfScreenContents = UIView()
    
    let backgroundImage = UIImageView()
    let navigationBar = UIView()
    let navigationTitle = UILabel()
    let languageButton = UIButton()
    let hintsButton = UIButton()
    let hintsSwitch = UISwitch()

    
    override func viewDidLoad()
    {
        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
        
        screenContents()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String) {
        print("ERROR MESSAGE", errorMessage)
    }
    
    func API_CALLBACK_InsertLanguage(insertLang: NSDictionary) {
        print("insertLang", insertLang)
    }
    
    func screenContents()
    {
        backgroundImage.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        backgroundImage.image = UIImage(named: "background")
        view.addSubview(backgroundImage)
        
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        navigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        view.addSubview(navigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(self.backButtonAction(sender:)), for: .touchUpInside)
        backButton.tag = 3
        navigationBar.addSubview(backButton)
        
        navigationTitle.frame = CGRect(x: 0, y: (2 * y), width: navigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "SETTINGS"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
        navigationTitle.font = navigationTitle.font.withSize(1.5 * x)
        navigationBar.addSubview(navigationTitle)
        
        let settingsTableView = UITableView()
        settingsTableView.frame = CGRect(x: (2 * x), y: navigationBar.frame.maxY + y, width: view.frame.width - (4 * x), height: view.frame.height)
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
//        view.addSubview(settingsTableView)
        
        selfScreenContents.frame = CGRect(x: x, y: navigationBar.frame.maxY, width: view.frame.width - (2 * x), height: view.frame.height - (navigationBar.frame.maxY))
        selfScreenContents.backgroundColor = UIColor.clear
        view.addSubview(selfScreenContents)
        
        languageButton.frame = CGRect(x: (2 * x), y: (3 * y), width: view.frame.width - (4 * x), height: (5 * y))
        languageButton.layer.cornerRadius = 10
        languageButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        languageButton.setTitle("Language Setting - English", for: .normal)
        languageButton.setTitleColor(UIColor.white, for: .normal)
        languageButton.titleLabel?.font = UIFont(name: "Avenir-Regular", size: (1.25 * x))
        languageButton.titleLabel?.font = languageButton.titleLabel?.font?.withSize(1.25 * x)
        languageButton.addTarget(self, action: #selector(self.languageFunction), for: .touchUpInside)
        selfScreenContents.addSubview(languageButton)
        
        hintsButton.frame = CGRect(x: (2 * x), y: languageButton.frame.maxY + y, width: view.frame.width - (4 * x), height: (5 * y))
        hintsButton.layer.cornerRadius = 10
        hintsButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        hintsButton.setTitleColor(UIColor.white, for: .normal)
        hintsButton.titleLabel?.font = UIFont(name: "Avenir-Regular", size: (1.25 * x))
        hintsButton.titleLabel?.font = hintsButton.titleLabel?.font?.withSize(1.25 * x)
        hintsButton.addTarget(self, action: #selector(self.hintsSwicthAction), for: .touchUpInside)
        selfScreenContents.addSubview(hintsButton)
        
        hintsSwitch.frame = CGRect(x: hintsButton.frame.maxX - (7 * x), y: ((hintsButton.frame.height - 31) / 2), width: (5.1 * x), height: 31)
//        hintsSwitch.tintColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        hintsSwitch.onTintColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        hintsSwitch.addTarget(self, action: #selector(self.hintsSwicthAction), for: .valueChanged)
        hintsButton.addSubview(hintsSwitch)
        
        let onOrOffValue = UserDefaults.standard.value(forKey: "hintsSwitch") as! Int
        
        if onOrOffValue == 1
        {
            hintsSwitch.isOn = true
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    hintsButton.setTitle("Hints off", for: .normal)
                }
                else if language == "ar"
                {
                    hintsButton.setTitle("إيقاف تلميحات", for: .normal)
                }
            }
            else
            {
                hintsButton.setTitle("Hints off", for: .normal)
            }
        }
        else
        {
            hintsSwitch.isOn = false
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    hintsButton.setTitle("Hints on", for: .normal)
                }
                else if language == "ar"
                {
                    hintsButton.setTitle("تلميحات على", for: .normal)
                }
            }
            else
            {
                hintsButton.setTitle("Hints on", for: .normal)
            }
        }
        
        
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
    }
    
    @objc func hintsSwicthAction()
    {
        let onOrOffValue = UserDefaults.standard.value(forKey: "hintsSwitch") as! Int
        
        if onOrOffValue == 1
        {
            UserDefaults.standard.set(0, forKey: "hintsSwitch")
            hintsSwitch.isOn = false
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    hintsButton.setTitle("Hints on", for: .normal)
                }
                else if language == "ar"
                {
                    hintsButton.setTitle("تلميحات على", for: .normal)
                }
            }
            else
            {
                hintsButton.setTitle("Hints on", for: .normal)
            }
        }
        else
        {
            UserDefaults.standard.set(1, forKey: "hintsSwitch")
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    hintsButton.setTitle("Hints off", for: .normal)
                }
                else if language == "ar"
                {
                    hintsButton.setTitle("إيقاف تلميحات", for: .normal)
                }
            }
            else
            {
                hintsButton.setTitle("Hints off", for: .normal)
            }
            hintsSwitch.isOn = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath as IndexPath)
        cell.textLabel?.text = "Language Setting"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        languageFunction()
    }
    
    @objc func languageFunction()
    {
        var languageAlert = UIAlertController()
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                languageAlert = UIAlertController(title: "Alert", message: "Please choose your language", preferredStyle: .alert)
                languageAlert.addAction(UIAlertAction(title: "English", style: .default, handler: languageAlertAction(action:)))
                languageAlert.addAction(UIAlertAction(title: "عربى", style: .default, handler: languageAlertAction(action:)))
                languageAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            }
            else if language == "ar"
            {
                languageAlert = UIAlertController(title: "تنبيه", message: "يرجى اختيار لغتك", preferredStyle: .alert)
                languageAlert.addAction(UIAlertAction(title: "English", style: .default, handler: languageAlertAction(action:)))
                languageAlert.addAction(UIAlertAction(title: "عربى", style: .default, handler: languageAlertAction(action:)))
                languageAlert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: nil))
            }
        }
        else
        {
            languageAlert = UIAlertController(title: "Alert", message: "Please choose your language", preferredStyle: .alert)
            languageAlert.addAction(UIAlertAction(title: "English", style: .default, handler: languageAlertAction(action:)))
            languageAlert.addAction(UIAlertAction(title: "عربى", style: .default, handler: languageAlertAction(action:)))
            languageAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        }
        
        self.present(languageAlert, animated: true, completion: nil)
    }
    
    func languageAlertAction(action : UIAlertAction)
    {
        
        if action.title == "English"
        {
            if let id = UserDefaults.standard.value(forKey: "userId") as? Int
            {
                serviceCall.API_InsertLanguage(Id: id, language: "English", delegate: self)
            }
            UserDefaults.standard.set("en", forKey: "language")
            changeViewToEnglish()
        }
        else if action.title == "Arabic" || action.title == "عربى"
        {
            if let id = UserDefaults.standard.value(forKey: "userId") as? Int
            {
                serviceCall.API_InsertLanguage(Id: id, language: "Arabic", delegate: self)
            }

            UserDefaults.standard.set("ar", forKey: "language")
            changeViewToArabic()
        }
    }
    
    @objc func backButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    

    func changeViewToArabic()
    {
        self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        navigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        navigationTitle.text = "الإعدادات"
        
        selfScreenContents.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
//        languageButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        languageButton.setTitle("إعداد اللغة - العربية", for: .normal)
        
//        hintsButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        hintsSwitch.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        if hintsSwitch.isOn == true
        {
            hintsButton.setTitle("إيقاف تلميحات", for: .normal)
        }
        else
        {
            hintsButton.setTitle("تلميحات على", for: .normal)
        }
    }
    
    func changeViewToEnglish()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        navigationTitle.text = "SETTINGS"
        
        selfScreenContents.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        languageButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        languageButton.setTitle("Language Setting - English", for: .normal)
        
        hintsButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        hintsSwitch.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        if hintsSwitch.isOn == true
        {
            hintsButton.setTitle("Hints off", for: .normal)
        }
        else
        {
            hintsButton.setTitle("Hints on", for: .normal)
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
