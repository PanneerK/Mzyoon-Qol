//
//  SettingsViewController.swift
//  Mzyoon
//
//  Created by QOL on 05/02/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    var x = CGFloat()
    var y = CGFloat()
    
    let backgroundImage = UIImageView()
    let navigationBar = UIView()
    let navigationTitle = UILabel()
    let languageButton = UIButton()

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
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        navigationBar.addSubview(navigationTitle)
        
        let settingsTableView = UITableView()
        settingsTableView.frame = CGRect(x: (2 * x), y: navigationBar.frame.maxY + y, width: view.frame.width - (4 * x), height: view.frame.height)
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
//        view.addSubview(settingsTableView)
        
        languageButton.frame = CGRect(x: (2 * x), y: navigationBar.frame.maxY + (3 * y), width: view.frame.width - (4 * x), height: (5 * y))
        languageButton.layer.cornerRadius = 10
        languageButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        languageButton.setTitle("Language Setting - English", for: .normal)
        languageButton.setTitleColor(UIColor.white, for: .normal)
        languageButton.addTarget(self, action: #selector(self.languageFunction), for: .touchUpInside)
        view.addSubview(languageButton)
        
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
        let alert = UIAlertController(title: "Alert", message: "Please choose your language", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "English", style: .default, handler: languageAlertAction(action:)))
        alert.addAction(UIAlertAction(title: "Arabic", style: .default, handler: languageAlertAction(action:)))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func languageAlertAction(action : UIAlertAction)
    {
        if action.title == "English"
        {
            UserDefaults.standard.set("en", forKey: "language")
            changeViewToEnglish()
        }
        else if action.title == "Arabic"
        {
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
        
        languageButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        let textString = "عربى"
        languageButton.setTitle("\(textString) - إعدادات اللغة", for: .normal)
    }
    
    func changeViewToEnglish()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        navigationTitle.text = "SETTINGS"
        
        languageButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        languageButton.setTitle("Language Setting - English", for: .normal)
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