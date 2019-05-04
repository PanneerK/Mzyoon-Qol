//
//  TailorTypeViewController.swift
//  Mzyoon
//
//  Created by QOL on 02/05/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class TailorTypeViewController: CommonViewController,ServerAPIDelegate
{
   
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()
    
    let serviceCall = ServerAPI()
    var applicationDelegate = AppDelegate()
    
    var TailorTypeImageArray = NSArray()
    var TailorTypeEnglishNameArray = NSArray()
    var TailorTypeArabicNameArray = NSArray()
    var TailorTypeIdArray = NSArray()
    
    override func viewDidLoad()
    {
        navigationBar.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 1 to desired number of seconds
            // Your code with delay
           // self.selfScreenNavigationContents()
            self.serviceCall.API_GetTailorListType(delegate: self)
        }
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("ERROR", errorMessage)
        stopActivity()
        applicationDelegate.exitContents()
    }
    func API_CALLBACK_GetTailorListType(tailorType: NSDictionary)
    {
        print("Tailor List REQUEST", tailorType)
        
        let ResponseMsg = tailorType.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = tailorType.object(forKey: "Result") as! NSArray
            print("Result:",Result)
            
         
            TailorTypeImageArray = Result.value(forKey: "Image") as! NSArray
            
            TailorTypeEnglishNameArray = Result.value(forKey: "OrderTypeNameInEnglish") as! NSArray
            
            TailorTypeArabicNameArray = Result.value(forKey: "OrderTypeInArabic") as! NSArray
            
            TailorTypeIdArray = Result.value(forKey: "Id") as! NSArray
            
          
           self.selfScreenNavigationContents()
        }
    }
    func selfScreenNavigationContents()
    {
        selfScreenNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        selfScreenNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(selfScreenNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 1
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        selfScreenNavigationBar.addSubview(backButton)
        
        selfScreenNavigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: selfScreenNavigationBar.frame.width, height: (3 * y))
        selfScreenNavigationTitle.text = "TAILORS TYPE"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationTitle.font = selfScreenNavigationTitle.font.withSize(2 * x)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                pageBar.image = UIImage(named: "ServiceBar")
            }
            else if language == "ar"
            {
                pageBar.image = UIImage(named: "serviceArabicHintImage")
            }
        }
        else
        {
            pageBar.image = UIImage(named: "ServiceBar")
        }
        
        TailorTypeScreenContents()
    }
    
    func TailorTypeScreenContents()
    {
        stopActivity()
        
        let quoteButton = UIButton()
        quoteButton.frame = CGRect(x: x, y: pageBar.frame.maxY + y, width: view.frame.width - (2 * x), height: (20 * y))
        quoteButton.layer.cornerRadius = x
        quoteButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        quoteButton.setTitle(TailorTypeEnglishNameArray[0] as? String, for: .normal)
        quoteButton.setTitleColor(UIColor.white, for: .normal)
        quoteButton.contentVerticalAlignment = .center
        
        let quoteButtonImage = UIImageView()
        quoteButtonImage.frame = CGRect(x: 0, y: 0, width: quoteButton.frame.width, height: quoteButton.frame.height)
        if let imageName =  TailorTypeImageArray[0] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/TailorList/\(imageName)"
            let apiurl = URL(string: api)
            if apiurl != nil
            {
                quoteButtonImage.dowloadFromServer(url: apiurl!)
            }
        }
        quoteButtonImage.contentMode = .scaleToFill
        quoteButton.addSubview(quoteButtonImage)
        
        quoteButton.tag = 1
        quoteButton.addTarget(self, action: #selector(self.tailorTypeButtonACtion(sender:)), for: .touchUpInside)
        view.addSubview(quoteButton)
        
        /*
        let quoteButtonImage = UIImageView()
        quoteButtonImage.frame = CGRect(x: 0, y: 0, width: quoteButton.frame.width, height: quoteButton.frame.height - (2 * y))
        quoteButtonImage.image = UIImage(named: "")
        quoteButton.addSubview(quoteButtonImage)
        */
        
        let directButton = UIButton()
        directButton.frame = CGRect(x: x, y: quoteButton.frame.maxY + y, width: view.frame.width - (2 * x), height: (20 * y))
        directButton.layer.cornerRadius = x
        directButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        directButton.setTitle(TailorTypeEnglishNameArray[1] as? String, for: .normal)
        directButton.setTitleColor(UIColor.white, for: .normal)
        directButton.contentVerticalAlignment = .center
        
        let directButtonImage = UIImageView()
        directButtonImage.frame = CGRect(x: 0, y: 0, width: directButton.frame.width, height: directButton.frame.height)
        if let imageName =  TailorTypeImageArray[1] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/TailorList/\(imageName)"
            let apiurl = URL(string: api)
            if apiurl != nil
            {
                directButtonImage.dowloadFromServer(url: apiurl!)
            }
        }
        directButtonImage.contentMode = .scaleToFill
        directButton.addSubview(directButtonImage)
        
        directButton.tag = 2
        directButton.addTarget(self, action: #selector(self.tailorTypeButtonACtion(sender:)), for: .touchUpInside)
        view.addSubview(directButton)
        
        /*
        let directButtonImage = UIImageView()
        directButtonImage.frame = CGRect(x: 0, y: 0, width: directButton.frame.width, height: directButton.frame.height - (2 * y))
        directButtonImage.image = UIImage(named: "")
        directButton.addSubview(directButtonImage)
        */
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tailorTypeButtonACtion(sender : UIButton)
    {
        if sender.tag == 1
        {
            Variables.sharedManager.tailorType = 0
            let tailorScreen = TailorListViewController()
            self.navigationController?.pushViewController(tailorScreen, animated: true)
        }
        else
        {
            Variables.sharedManager.tailorType = 1
            let tailorScreen = TailorListViewController()
            self.navigationController?.pushViewController(tailorScreen, animated: true)
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
