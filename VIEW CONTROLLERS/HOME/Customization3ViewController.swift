//
//  Customization3ViewController.swift
//  Mzyoon
//
//  Created by QOL on 16/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class Customization3ViewController: CommonViewController, ServerAPIDelegate
{
    //SERVICE PARAMETERS
    let serviceCall = ServerAPI()
    
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()
    
    let selfScreenContents = UIView()

    let viewDesignLabel = UILabel()

    //SCREEN PARAMETERS
    let customedImageView = UIImageView()
    let customedFrontButton = UIButton()
    let customedBackButton = UIButton()
    let selectionImage = UIImageView()
    let dropDownButton = UIButton()
    let dropDownImageView = UIImageView()
    let customizationScrollView = UIScrollView()
    
    let selectionImage1 = UIImageView()
    
    //API PARAMETERS
    var customImagesArray = NSArray()
    
    var customAttEnglishNameArray = NSArray()
    var customAttArabicNameArray = NSArray()
    var customAttIdArray = NSArray()
    
    var subCustomAttEnglishNameArray = NSArray()
    var subCustomAttArabicNameArray = NSArray()
    var subCustomAttIdArray = NSArray()
    var subCustomAttImageArray = NSArray()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    var selectedCustomStringArray = [String : String]()
    var selectedCustomString = String()
    var selectedCustomIntArray = [String : String]()
    var selectedCustomInt = Int()
    var customDictValuesCount = 0
    
    var selectedSubCustomInt = Int()
    
    override func viewDidLoad() {
        navigationBar.isHidden = true
        selectedButton(tag: 0)
        
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.serviceCall.API_Customization3(DressTypeId: 5, delegate: self)
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String) {
        print("ERROR MESSAGE", errorMessage)
    }
    
    func API_CALLBACK_Customization3(custom3: NSDictionary) {
        print("CUSTOM 3", custom3)
        
        let ResponseMsg = custom3.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = custom3.object(forKey: "Result") as! NSDictionary
            
            let CustomizationImages = Result.object(forKey: "CustomizationImages") as! NSArray
            
            customImagesArray = CustomizationImages.value(forKey: "Image") as! NSArray
            
            let CustomizationAttributes = Result.object(forKey: "CustomizationAttributes") as! NSArray
            
            customAttEnglishNameArray = CustomizationAttributes.value(forKey: "AttributeNameInEnglish") as! NSArray
            
            customAttArabicNameArray = CustomizationAttributes.value(forKey: "AttributeNameinArabic") as! NSArray
            
            customAttIdArray = CustomizationAttributes.value(forKey: "Id") as! NSArray
            
            let AttributeImages = Result.object(forKey: "AttributeImages") as! NSArray
            print("AttributeImages", AttributeImages)
            
            subCustomAttEnglishNameArray = AttributeImages.value(forKey: "AttributeNameInEnglish") as! NSArray
            
            subCustomAttArabicNameArray = AttributeImages.value(forKey: "AttributeNameInArabic") as! NSArray
            
            subCustomAttIdArray = AttributeImages.value(forKey: "Id") as! NSArray
            
            subCustomAttImageArray = AttributeImages.value(forKey: "Images") as! NSArray
            
            for i in 0..<customAttEnglishNameArray.count
            {
                print("selectedCustomIntArray.keys[i]", selectedCustomIntArray.keys.count)
                
                if let textString = customAttEnglishNameArray[i] as? String
                {
                    selectedCustomStringArray[textString] = ""
                }
                
                if let idString = customAttIdArray[i] as? Int
                {
                    selectedCustomIntArray["\(idString)"] = ""
                }
            }
                        
            print("SORTED DICTIONARY", selectedCustomIntArray.sorted(by: <))
            
            selectedCustomString = customAttEnglishNameArray[0] as! String
            selectedCustomInt = customAttIdArray[0] as! Int
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    customization3Content(inputArray: customAttEnglishNameArray)

                }
                else if language == "ar"
                {
                    customization3Content(inputArray: customAttArabicNameArray)
                }
            }
            else
            {
                customization3Content(inputArray: customAttEnglishNameArray)
            }
        }
        else
        {
            let Result = custom3.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetCustomization3"
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func API_CALLBACK_Customization3Attr(custom3Attr: NSDictionary)
    {
        print("Custom-3 Attributes:", custom3Attr)
        
        let ResponseMsg = custom3Attr.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = custom3Attr.object(forKey: "Result") as! NSArray
            
            subCustomAttEnglishNameArray = Result.value(forKey: "AttributeNameInEnglish") as! NSArray
            
            subCustomAttArabicNameArray = Result.value(forKey: "AttributeNameInArabic") as! NSArray
            
            subCustomAttIdArray = Result.value(forKey: "Id") as! NSArray
            
            subCustomAttImageArray = Result.value(forKey: "Images") as! NSArray
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    subcCustomization3Content(inputArray: subCustomAttEnglishNameArray)
                }
                else if language == "ar"
                {
                    subcCustomization3Content(inputArray: subCustomAttArabicNameArray)
                }
            }
            else
            {
                subcCustomization3Content(inputArray: subCustomAttEnglishNameArray)
            }
        }
        else
        {
            let Result = custom3Attr.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetAttributesByAttributeId"
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        // ErrorStr = "Default Error"
        PageNumStr = "Customization3ViewController"
        // MethodName = "do"
        
        print("UUID", UIDevice.current.identifierForVendor?.uuidString as Any)
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
    }
    
    func changeViewToArabicInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenContents.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        viewDesignLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selectionImage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        dropDownButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        dropDownImageView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        selfScreenNavigationTitle.text = "التخصيص - 3"
        viewDesignLabel.text = "عرض التصميم الخاص بك هنا"
    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenContents.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        viewDesignLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selectionImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

        dropDownButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        dropDownImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        selfScreenNavigationTitle.text = "CUSTOMIZATION-3"
        viewDesignLabel.text = "VIEW YOUR DESIGN HERE"
    }
    
    func customization3Content(inputArray : NSArray)
    {
        selfScreenNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        selfScreenNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(selfScreenNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        backButton.tag = 3
        selfScreenNavigationBar.addSubview(backButton)
        
        selfScreenNavigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: selfScreenNavigationBar.frame.width, height: (3 * y))
        selfScreenNavigationTitle.text = "CUSTOMIZATION-3"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        selfScreenContents.frame = CGRect(x: 0, y: selfScreenNavigationBar.frame.maxY, width: view.frame.width, height: view.frame.height - ((5 * y) + selfScreenNavigationBar.frame.maxY))
        selfScreenContents.backgroundColor = UIColor.clear
        view.addSubview(selfScreenContents)
        
        viewDesignLabel.frame = CGRect(x: (3 * x), y: y, width: (25 * x), height: (4 * y))
        viewDesignLabel.layer.cornerRadius = 10
        viewDesignLabel.layer.masksToBounds = true
        viewDesignLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        viewDesignLabel.text = "VIEW YOUR DESIGN HERE"
        viewDesignLabel.textColor = UIColor.white
        viewDesignLabel.textAlignment = .center
        viewDesignLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        selfScreenContents.addSubview(viewDesignLabel)
        
        customedImageView.frame = CGRect(x: (3 * x), y: viewDesignLabel.frame.maxY + y, width: (25 * x), height: (25 * y))
        customedImageView.layer.borderWidth = 1
        customedImageView.layer.borderColor = UIColor.lightGray.cgColor
        customedImageView.backgroundColor = UIColor.white
        if let imageName = customImagesArray[1] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/Customazation3/\(imageName)"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            if apiurl != nil
            {
                customedImageView.dowloadFromServer(url: apiurl!)
            }
        }
        selfScreenContents.addSubview(customedImageView)
        
        customedFrontButton.frame = CGRect(x: customedImageView.frame.maxX + x, y: customedImageView.frame.minY + (9 * y), width: (7.5 * x), height: (7.5 * y))
        customedFrontButton.layer.borderWidth = 1
        customedFrontButton.layer.borderColor = UIColor.lightGray.cgColor
        customedFrontButton.backgroundColor = UIColor.white
        if let imageName = customImagesArray[1] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/Customazation3/\(imageName)"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: customedFrontButton.frame.width, height: customedFrontButton.frame.height)
            if apiurl != nil
            {
                dummyImageView.dowloadFromServer(url: apiurl!)
            }
            customedFrontButton.addSubview(dummyImageView)
        }
        customedFrontButton.tag = 1
        customedFrontButton.addTarget(self, action: #selector(self.dressSelectionButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(customedFrontButton)
        
        selectionImage.frame = CGRect(x: x, y: y, width: (2 * x), height: (2 * y))
        selectionImage.image = UIImage(named: "selectionImage")
        customedFrontButton.addSubview(selectionImage)
        
        customedBackButton.frame = CGRect(x: customedImageView.frame.maxX + x, y: customedFrontButton.frame.maxY + y, width: (7.5 * x), height: (7.5 * y))
        customedBackButton.layer.borderWidth = 1
        customedBackButton.layer.borderColor = UIColor.lightGray.cgColor
        customedBackButton.backgroundColor = UIColor.white
        if let imageName = customImagesArray[0] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/Customazation3/\(imageName)"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: customedBackButton.frame.width, height: customedBackButton.frame.height)
            if apiurl != nil
            {
                dummyImageView.dowloadFromServer(url: apiurl!)
            }
            customedBackButton.addSubview(dummyImageView)
        }
        customedBackButton.tag = 0
        customedBackButton.addTarget(self, action: #selector(self.dressSelectionButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(customedBackButton)
        
        dropDownButton.frame = CGRect(x: (3 * x), y: customedImageView.frame.maxY + (2 * y), width: view.frame.width - (6 * x), height: (4 * y))
        dropDownButton.layer.cornerRadius = 5
        dropDownButton.layer.masksToBounds = true
        dropDownButton.backgroundColor = UIColor.lightGray
        if let textString = inputArray[0] as? String
        {
            dropDownButton.setTitle(textString.uppercased(), for: .normal)
        }
        dropDownButton.titleLabel?.textAlignment = .right
        dropDownButton.setTitleColor(UIColor.black, for: .normal)
        dropDownButton.addTarget(self, action: #selector(self.dropDownButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(dropDownButton)
        
        dropDownImageView.frame = CGRect(x: dropDownButton.frame.width - (4 * x), y: 0, width: (4 * x), height: (4 * y))
        dropDownImageView.layer.cornerRadius = 5
        dropDownImageView.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        dropDownImageView.image = UIImage(named: "downArrow")
        dropDownButton.addSubview(dropDownImageView)
        
        let templateImage4 = dropDownImageView.image?.withRenderingMode(.alwaysTemplate)
        dropDownImageView.image = templateImage4
        dropDownImageView.tintColor = UIColor.white
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                changeViewToEnglishInSelf()
                subcCustomization3Content(inputArray: subCustomAttEnglishNameArray)
            }
            else if language == "ar"
            {
                changeViewToArabicInSelf()
                subcCustomization3Content(inputArray: subCustomAttArabicNameArray)
            }
        }
        else
        {
            changeViewToEnglishInSelf()
            subcCustomization3Content(inputArray: subCustomAttEnglishNameArray)
        }
    }
    
    func subcCustomization3Content(inputArray : NSArray)
    {
        customizationScrollView.frame = CGRect(x: 0, y: dropDownButton.frame.maxY + y, width: view.frame.width, height: (12 * y))
        selfScreenContents.addSubview(customizationScrollView)
        
        for views in customizationScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        var x3:CGFloat = (2 * x)
        for i in 0..<subCustomAttEnglishNameArray.count
        {
            let customizationButton = UIButton()
            customizationButton.frame = CGRect(x: x3, y: y, width: (12 * x), height: (10 * y))
            customizationButton.backgroundColor = UIColor.white
            customizationButton.tag = subCustomAttIdArray[i] as! Int
            customizationButton.addTarget(self, action: #selector(self.customizationButtonAction(sender:)), for: .touchUpInside)
            customizationScrollView.addSubview(customizationButton)
            
            if selectedCustomIntArray["\(selectedCustomInt)"]!.isEmpty == true
            {
                
            }
            else
            {
                if let id = selectedCustomIntArray["\(selectedCustomInt)"]
                {
                    if id == "\(customizationButton.tag)"
                    {
                        self.customizationButtonAction(sender: customizationButton)
                    }
                }
            }
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    customizationButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
                else if language == "ar"
                {
                    customizationButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                }
            }
            else
            {
                customizationButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            
            
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: (3 * x), y: 0, width: customizationButton.frame.width - (6 * x), height: customizationButton.frame.height - (2 * y))
            buttonImage.backgroundColor = UIColor.white
            if let imageName = subCustomAttImageArray[i] as? String
            {
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/Customazation3/\(imageName)"
                let apiurl = URL(string: api)
                print("IMAGE OF DOWN", apiurl!)
                if apiurl != nil
                {
                    buttonImage.dowloadFromServer(url: apiurl!)
                }
            }
            buttonImage.tag = -1
            customizationButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 0, y: customizationButton.frame.height - (2 * y), width: customizationButton.frame.width, height: (2 * y))
            buttonTitle.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.text = (inputArray[i] as! String)
            buttonTitle.adjustsFontSizeToFitWidth = true
            buttonTitle.textColor = UIColor.white
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 10)
            buttonTitle.tag = -2
            customizationButton.addSubview(buttonTitle)
            
            x3 = customizationButton.frame.maxX + (2 * x)
        }
        
        customizationScrollView.contentSize.width = x3
        
        let customization3NextButton = UIButton()
        customization3NextButton.frame = CGRect(x: view.frame.width - (5 * x), y: customizationScrollView.frame.maxY + y, width: (4 * x), height: (4 * y))
        customization3NextButton.layer.cornerRadius = customization3NextButton.frame.height / 2
        customization3NextButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        customization3NextButton.layer.masksToBounds = true
        customization3NextButton.setImage(UIImage(named: "rightArrow"), for: .normal)
        customization3NextButton.addTarget(self, action: #selector(self.customization3NextButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(customization3NextButton)
        
        self.stopActivity()
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dressSelectionButtonAction(sender : UIButton)
    {
        selectionImage.frame = CGRect(x: x, y: y, width: (2 * x), height: (2 * y))
        selectionImage.image = UIImage(named: "selectionImage")
        sender.addSubview(selectionImage)
        
        if let imageName = customImagesArray[sender.tag] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/Customazation3/\(imageName)"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            if apiurl != nil
            {
                customedImageView.dowloadFromServer(url: apiurl!)
            }
        }
    }
    
    @objc func dropDownButtonAction(sender : UIButton)
    {
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                let customizationAlert = UIAlertController(title: "Customize", message: "Customize your material", preferredStyle: .alert)
                
                for i in 0..<customAttEnglishNameArray.count
                {
                    if let alertString = customAttEnglishNameArray[i] as? String
                    {
                        customizationAlert.addAction(UIAlertAction(title: alertString.uppercased(), style: .default, handler: customizaionAlertAction(action:)))
                    }
                }
                customizationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(customizationAlert, animated: true, completion: nil)
            }
            else if language == "ar"
            {
                let customizationAlert = UIAlertController(title: "يعدل أو يكيف", message: "تخصيص المواد الخاصة بك", preferredStyle: .alert)
                
                for i in 0..<customAttArabicNameArray.count
                {
                    if let alertString = customAttArabicNameArray[i] as? String
                    {
                        customizationAlert.addAction(UIAlertAction(title: alertString.uppercased(), style: .default, handler: customizaionAlertAction(action:)))
                    }
                }
                customizationAlert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: nil))
                self.present(customizationAlert, animated: true, completion: nil)
            }
        }
        else
        {
            let customizationAlert = UIAlertController(title: "Customize", message: "Customize your material", preferredStyle: .alert)
            
            for i in 0..<customAttEnglishNameArray.count
            {
                if let alertString = customAttEnglishNameArray[i] as? String
                {
                    customizationAlert.addAction(UIAlertAction(title: alertString.uppercased(), style: .default, handler: customizaionAlertAction(action:)))
                }
            }
            customizationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(customizationAlert, animated: true, completion: nil)
        }
    }
    
    func customizaionAlertAction(action : UIAlertAction)
    {
        dropDownButton.setTitle(action.title!, for: .normal)
        
        selectedCustomString = (action.title?.lowercased())!
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                for i in 0..<customAttEnglishNameArray.count
                {
                    if let checkAtt = customAttEnglishNameArray[i] as? String
                    {
                        print("CHECK ATT", checkAtt, selectedCustomString, customAttIdArray[i])
                        if selectedCustomString == checkAtt.lowercased()
                        {
                            if let attId = customAttIdArray[i] as? Int
                            {
                                self.activityContents()
                                self.serviceCall.API_Customization3Attr(AttributeId: attId, delegate: self)
                                selectedCustomInt = attId
                            }
                        }
                    }
                }

            }
            else if language == "ar"
            {
                for i in 0..<customAttArabicNameArray.count
                {
                    if let checkAtt = customAttArabicNameArray[i] as? String
                    {
                        if selectedCustomString == checkAtt.lowercased()
                        {
                            if let attId = customAttIdArray[i] as? Int
                            {
                                self.activityContents()
                                self.serviceCall.API_Customization3Attr(AttributeId: attId, delegate: self)
                                selectedCustomInt = attId
                            }
                        }
                    }
                }

            }
        }
        else
        {
            for i in 0..<customAttEnglishNameArray.count
            {
                if let checkAtt = customAttEnglishNameArray[i] as? String
                {
                    print("CHECK ATT", checkAtt, selectedCustomString, customAttIdArray[i])
                    if selectedCustomString == checkAtt.lowercased()
                    {
                        if let attId = customAttIdArray[i] as? Int
                        {
                            self.activityContents()
                            self.serviceCall.API_Customization3Attr(AttributeId: attId, delegate: self)
                            selectedCustomInt = attId
                        }
                    }
                }
            }

        }
    }
    
    @objc func customizationButtonAction(sender : UIButton)
    {
        selectionImage1.frame = CGRect(x: x, y: y, width: (2 * x), height: (2 * y))
        selectionImage1.image = UIImage(named: "selectionImage")
        selectionImage1.tag = sender.tag
        sender.addSubview(selectionImage1)
        
        selectedCustomIntArray["\(selectedCustomInt)"] = "\(sender.tag)"
        
        for i in 0..<subCustomAttEnglishNameArray.count
        {
            if let idInt = subCustomAttIdArray[i] as? Int
            {
                if selectedCustomIntArray["\(selectedCustomInt)"] == "\(idInt)"
                {
                    selectedCustomStringArray[selectedCustomString] = subCustomAttEnglishNameArray[i] as? String
                }
            }
        }
        
        print("SELECTED OF ALL IN ID", selectedCustomIntArray)
        print("SELECTED OF ALL IN STRING", selectedCustomStringArray)
    }
    
    @objc func customization3NextButtonAction(sender : UIButton)
    {
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                for (keys, values) in selectedCustomStringArray
                {
                    print("KEYS - \(keys), VALUES - \(values)")
                    
                    if values.isEmpty == true || values == ""
                    {
                        let customEmptyAlert = UIAlertController(title: "Alert", message: "Please choose your customization for \(keys) and procced to next", preferredStyle: .alert)
                        customEmptyAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(customEmptyAlert, animated: true, completion: nil)
                    }
                    else
                    {
                        if customAttEnglishNameArray.count != customDictValuesCount
                        {
                            customDictValuesCount = customDictValuesCount + 1
                        }
                    }
                }
            }
            else if language == "ar"
            {
                for (keys, values) in selectedCustomStringArray
                {
                    print("KEYS - \(keys), VALUES - \(values)")
                    
                    if values.isEmpty == true || values == ""
                    {
                        let customEmptyAlert = UIAlertController(title: "محزر", message: "يرجى اختيار التخصيص لوالإجراء التالي", preferredStyle: .alert)
                        customEmptyAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(customEmptyAlert, animated: true, completion: nil)
                    }
                    else
                    {
                        if customAttEnglishNameArray.count != customDictValuesCount
                        {
                            customDictValuesCount = customDictValuesCount + 1
                        }
                    }
                }
            }
        }
        else
        {
            for (keys, values) in selectedCustomStringArray
            {
                print("KEYS - \(keys), VALUES - \(values)")
                
                if values.isEmpty == true || values == ""
                {
                    let customEmptyAlert = UIAlertController(title: "Alert", message: "Please choose your customization for \(keys) and procced to next", preferredStyle: .alert)
                    customEmptyAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(customEmptyAlert, animated: true, completion: nil)
                }
                else
                {
                    if customAttEnglishNameArray.count != customDictValuesCount
                    {
                        customDictValuesCount = customDictValuesCount + 1
                    }
                }
            }
        }
        
        if customAttEnglishNameArray.count == customDictValuesCount
        {
            UserDefaults.standard.set(selectedCustomStringArray, forKey: "custom3")
            UserDefaults.standard.set(selectedCustomIntArray, forKey: "custom3Id")
            let measurement1Screen = Measurement1ViewController()
            self.navigationController?.pushViewController(measurement1Screen, animated: true)
        }
        else
        {
            
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
