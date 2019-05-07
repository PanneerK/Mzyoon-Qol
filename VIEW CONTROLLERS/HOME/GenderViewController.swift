//
//  GenderViewController.swift
//  Mzyoon
//
//  Created by QOL on 16/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class GenderViewController: CommonViewController, ServerAPIDelegate
{
    let serviceCall = ServerAPI()

    let selfScreenContents = UIView()

    //GENDER API PARAMETERS
    var genderArray = NSArray()
    var genderIdArray = NSArray()
    var genderInArabicArray = NSArray()
    var genderImageArray = NSArray()
    var convertedGenderImageArray = [UIImage]()
    
   // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    
    var applicationDelegate = AppDelegate()
    
    override func viewDidLoad()
    {
        Variables.sharedManager.screenNavigationBarTag = 0
        commonBackButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        selectedButton(tag: 0)
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                self.navigationTitle.text = "Gender Selection"
                self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            else if language == "ar"
            {
                self.navigationTitle.text = "اختيار الجنس"
                self.navigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            }
        }
        else
        {
            self.navigationTitle.text = "Gender Selection"
            self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        serviceCall.API_Gender(delegate: self)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        for allViews in selfScreenContents.subviews
        {
            allViews.removeFromSuperview()
        }
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                slideMenu()
                changeViewToEnglish()
                self.newOrderContents(getInputArray: genderArray)
            }
            else if language == "ar"
            {
                slideMenuRight()
                changeViewToArabic()
                self.newOrderContents(getInputArray: genderInArabicArray)
            }
        }
        else
        {
            slideMenu()
            changeViewToEnglish()
            self.newOrderContents(getInputArray: genderArray)
        }
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "Customer"
        // ErrorStr = "Default Error"
        PageNumStr = "GenderViewController"
        MethodName = "GetGenders"
        
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("ERROR IN GENDER PAGE", errorMessage)
        stopActivity()
        applicationDelegate.exitContents()
    }
 
    
    func API_CALLBACK_Gender(gender: NSDictionary)
    {
        let ResponseMsg = gender.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let result = gender.object(forKey: "Result") as! NSArray
            
            print("RESPONSE GENDER PAGE", result)
            
            genderArray = result.value(forKey: "gender") as! NSArray
            
            genderImageArray = result.value(forKey: "ImageURL") as! NSArray
            
            genderIdArray = result.value(forKey: "Id") as! NSArray
            
            genderInArabicArray = result.value(forKey: "GenderInArabic") as! NSArray
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    self.newOrderContents(getInputArray: genderArray)
                }
                else if language == "ar"
                {
                    self.newOrderContents(getInputArray: genderInArabicArray)
                }
            }
            else
            {
                self.newOrderContents(getInputArray: genderArray)
            }
        }
        else if ResponseMsg == "Failure"
        {
            let Result = gender.object(forKey: "Result") as! String
            
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func API_CALLBACK_InsertErrorDevice(deviceError: NSDictionary)
    {
        let ResponseMsg = deviceError.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = deviceError.object(forKey: "Result") as! String
        }
    }
    
    func newOrderContents(getInputArray : NSArray)
    {
        let tag = Variables.sharedManager.measurementTag
        
        if tag == 1
        {
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    pageBar.image = UIImage(named: "GenderInMeasurementEnglish")
                }
                else if language == "ar"
                {
                    pageBar.image = UIImage(named: "GenderInMeasurementArabic")
                }
            }
            else
            {
                pageBar.image = UIImage(named: "GenderInMeasurementEnglish")
            }
        }
        else
        {
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    pageBar.image = UIImage(named: "GenderBar")
                }
                else if language == "ar"
                {
                    pageBar.image = UIImage(named: "genderArabicHintImage")
                }
            }
            else
            {
                pageBar.image = UIImage(named: "GenderBar")
            }
        }
        
        selfScreenContents.frame = CGRect(x: x, y: pageBar.frame.maxY, width: view.frame.width - (2 * x), height: view.frame.height - ((5 * y) + navigationBar.frame.maxY + pageBar.frame.height))
        selfScreenContents.backgroundColor = UIColor.clear
        view.addSubview(selfScreenContents)
        
        var buttonYPos:CGFloat = (2 * y)
        
        for i in 0..<genderIdArray.count
        {
            let genderButton = UIButton()
            
            if i == 0 || i == 2
            {
                genderButton.frame = CGRect(x: selfScreenContents.frame.maxX, y: buttonYPos, width: selfScreenContents.frame.width, height: (11 * y))
            }
            else
            {
                genderButton.frame = CGRect(x: -(selfScreenContents.frame.width - (6 * x)), y: buttonYPos, width: selfScreenContents.frame.width, height: (11 * y))
            }
            
            genderButton.backgroundColor = UIColor.clear
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: 0, y: 0, width: genderButton.frame.width, height: genderButton.frame.height)
            if let imageName =  genderImageArray[i] as? String
            {
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/\(imageName)"
                let apiurl = URL(string: api)
                if apiurl != nil
                {
                    buttonImage.dowloadFromServer(url: apiurl!)
                }
            }
            buttonImage.contentMode = .scaleToFill
            genderButton.addSubview(buttonImage)

            genderButton.tag = genderIdArray[i] as! Int
            genderButton.addTarget(self, action: #selector(self.genderButtonAction(sender:)), for: .touchUpInside)
            selfScreenContents.addSubview(genderButton)
            
            if i == genderImageArray.count - 1
            {
                self.stopActivity()
            }
            else
            {
                
            }
            
            let genderButtonLabel = UILabel()
            if i == 0 || i == 2
            {
                genderButtonLabel.frame = CGRect(x: 0, y: ((genderButton.frame.height - (2 * y)) / 2), width: (7 * x), height: (2 * y))
            }
            else
            {
                genderButtonLabel.frame = CGRect(x: genderButton.frame.width - (7 * x), y: ((genderButton.frame.height - (2 * y)) / 2), width: (7 * x), height: (2 * y))
            }
            genderButtonLabel.backgroundColor = UIColor.darkGray
            genderButtonLabel.text = (getInputArray[i] as? String)
            genderButtonLabel.textColor = UIColor.white
            genderButtonLabel.textAlignment = .center
            genderButtonLabel.tag = ((genderButton.tag * 1) + 300)
            genderButton.addSubview(genderButtonLabel)
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    genderButtonLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
                else if language == "ar"
                {
                    genderButtonLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                }
            }
            else
            {
                genderButtonLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            
            UIView.animate(withDuration: 1.0, animations: {
                //self.viewTrack.frame.origin.y = UIScreen.main.bounds.size.height
                genderButton.frame.origin.x = 0
                
            }, completion: { finished in
                if finished{
                    
                }
            })
            
            buttonYPos = genderButton.frame.maxY + y
        }
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                changeViewToEnglishInSelf()
            }
            else if language == "ar"
            {
                changeViewToArabicInSelf()
            }
        }
        else
        {
            changeViewToEnglishInSelf()
        }
    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenContents.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    func changeViewToArabicInSelf()
    {
        selfScreenContents.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func genderButtonAction(sender : UIButton)
    {
        let dressTypeScreen = DressTypeViewController()
        
        Variables.sharedManager.genderId = sender.tag
        
        if let label = view.viewWithTag((sender.tag * 1) + 300) as? UILabel
        {
            Variables.sharedManager.genderType = label.text!
        }
        
        print("GENDER TYPE IN VARIABLES", Variables.sharedManager.genderType)
        
        dressTypeScreen.tag = sender.tag
        self.navigationController?.pushViewController(dressTypeScreen, animated: true)
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
