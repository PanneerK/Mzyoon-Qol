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
    let serviceCall = ServerAPI()
    var applicationDelegate = AppDelegate()
    
    var TailorTypeImageArray = NSArray()
    var TailorTypeEnglishNameArray = NSArray()
    var TailorTypeArabicNameArray = NSArray()
    var TailorTypeIdArray = NSArray()
    
    override func viewDidLoad()
    {
        Variables.sharedManager.screenNavigationBarTag = 0
        commonBackButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        selectedButton(tag: 0)
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                self.navigationTitle.text = "TAILORS TYPE"
                self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            else if language == "ar"
            {
                self.navigationTitle.text = "ملخص الطلب"
                self.navigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            }
        }
        else
        {
            self.navigationTitle.text = "TAILORS TYPE"
            self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
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
            
          
           TailorTypeScreenContents()
        }
    }
    
    func TailorTypeScreenContents()
    {
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
        
        stopActivity()
        
        let quoteButton = UIButton()
        quoteButton.frame = CGRect(x: x, y: pageBar.frame.maxY + y, width: view.frame.width - (2 * x), height: (20 * y))
        quoteButton.layer.cornerRadius = x
        quoteButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
//        quoteButton.setTitle(TailorTypeEnglishNameArray[0] as? String, for: .normal)
//        quoteButton.setTitleColor(UIColor.white, for: .normal)
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
        
        let quoteButtonLabel = UILabel()
        quoteButtonLabel.frame = CGRect(x: 0, y: ((quoteButton.frame.height - (3 * y)) / 2), width: quoteButton.frame.width, height: (3 * y))
        quoteButtonLabel.backgroundColor = UIColor(red: 0.2039, green: 0.2941, blue: 0.4157, alpha: 1.0).withAlphaComponent(0.5)
        quoteButtonLabel.text = TailorTypeEnglishNameArray[0] as? String
        quoteButtonLabel.textColor = UIColor.white
        quoteButtonLabel.textAlignment = .center
        quoteButtonLabel.font = UIFont(name: "Avenir-Regular", size: (2 * x))
        quoteButtonLabel.font = quoteButtonLabel.font.withSize(2 * x)
        quoteButton.addSubview(quoteButtonLabel)
        
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
//        directButton.setTitle(TailorTypeEnglishNameArray[1] as? String, for: .normal)
//        directButton.setTitleColor(UIColor.white, for: .normal)
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
        
        let directButtonLabel = UILabel()
        directButtonLabel.frame = CGRect(x: 0, y: ((directButton.frame.height - (3 * y)) / 2), width: directButton.frame.width, height: (3 * y))
        directButtonLabel.backgroundColor = UIColor(red: 0.2039, green: 0.2941, blue: 0.4157, alpha: 1.0).withAlphaComponent(0.5)
        directButtonLabel.text = TailorTypeEnglishNameArray[1] as? String
        directButtonLabel.textColor = UIColor.white
        directButtonLabel.textAlignment = .center
        directButtonLabel.font = UIFont(name: "Avenir-Regular", size: (2 * x))
        directButtonLabel.font = directButtonLabel.font.withSize(2 * x)
        directButton.addSubview(directButtonLabel)
        
        
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
