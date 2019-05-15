//
//  Customization3ViewController.swift
//  Mzyoon
//
//  Created by QOL on 16/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class Customization3ViewController: CommonViewController, ServerAPIDelegate, UITableViewDataSource, UITableViewDelegate
{
    //SERVICE PARAMETERS
    let serviceCall = ServerAPI()
    
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
    
    //ACTIVITY INDICATOR PARAMETERS
    let activeViewSub = UIView()
    let activityIndicatorSub = UIActivityIndicatorView()
    
    //HINTS PARAMETERS
    var hintTag = 0
    let hintsImage = UIImageView()
    let detailedLabel = UILabel()
    
    //CUSTOMIZATION PARAMETERS
    let customBlurView = UIView()
    let customTitleLabel = UILabel()
    let customTableView = UITableView()
    
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
                self.navigationTitle.text = "CUSTOMIZATION"
                self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            else if language == "ar"
            {
                self.navigationTitle.text = "التخصيص"
                self.navigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            }
        }
        else
        {
            self.navigationTitle.text = "CUSTOMIZATION"
            self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        self.serviceCall.API_Customization3(DressTypeId: "\(Variables.sharedManager.dressSubTypeId)", delegate: self)
        
//        self.serviceCall.API_Customization3(DressTypeId: "112", delegate: self)
        
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
    
    func activeStart1()
    {
        activeViewSub.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        activeViewSub.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(activeViewSub)
        
        activityIndicatorSub.frame = CGRect(x: ((activeViewSub.frame.width - (5 * x)) / 2), y: ((activeViewSub.frame.height - (5 * y)) / 2), width: (5 * x), height: (5 * y))
        activityIndicatorSub.color = UIColor.white
        activityIndicatorSub.style = .whiteLarge
        activityIndicatorSub.startAnimating()
        activeViewSub.addSubview(activityIndicatorSub)
    }
    
    func activeStop1()
    {
        activeViewSub.removeFromSuperview()
        activityIndicatorSub.stopAnimating()
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("ERROR MESSAGE", errorMessage)
        stopActivity()
        applicationDelegate.exitContents()
    }
    
    func API_CALLBACK_Customization3(custom3: NSDictionary)
    {
        print("CUSTOM 3 RESPONSE", custom3)
        
        let ResponseMsg = custom3.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = custom3.object(forKey: "Result") as! NSDictionary
            
            let CustomizationImages = Result.object(forKey: "CustomizationImages") as! NSArray
            
            if CustomizationImages.count != 0
            {
                customImagesArray = CustomizationImages.value(forKey: "Image") as! NSArray
                
                let CustomizationAttributes = Result.object(forKey: "CustomizationAttributes") as! NSArray
                
                let customAttImage = CustomizationAttributes.value(forKey: "AttributeImage") as! NSArray
                print("ATTRIBTE IMAGES", customAttImage)
                
                customAttEnglishNameArray = CustomizationAttributes.value(forKey: "AttributeNameInEnglish") as! NSArray
                
                customAttArabicNameArray = CustomizationAttributes.value(forKey: "AttributeNameinArabic") as! NSArray
                
                customAttIdArray = CustomizationAttributes.value(forKey: "Id") as! NSArray
                
                let AttributeImages = Result.object(forKey: "AttributeImages") as! NSArray
                
                subCustomAttEnglishNameArray = AttributeImages.value(forKey: "AttributeNameInEnglish") as! NSArray
                
                subCustomAttArabicNameArray = AttributeImages.value(forKey: "AttributeNameInArabic") as! NSArray
                
                subCustomAttIdArray = AttributeImages.value(forKey: "Id") as! NSArray
                
                subCustomAttImageArray = AttributeImages.value(forKey: "Images") as! NSArray
                
                for i in 0..<customAttEnglishNameArray.count
                {
                    if let language = UserDefaults.standard.value(forKey: "language") as? String
                    {
                        if language == "en"
                        {
                            if let textString = customAttEnglishNameArray[i] as? String
                            {
                                selectedCustomStringArray[textString] = ""
                                selectedCustomString = customAttEnglishNameArray[0] as! String
                            }
                        }
                        else if language == "ar"
                        {
                            if let textString = customAttArabicNameArray[i] as? String
                            {
                                selectedCustomStringArray[textString] = ""
                                selectedCustomString = customAttArabicNameArray[0] as! String
                            }
                        }
                    }
                    else
                    {
                        if let textString = customAttEnglishNameArray[i] as? String
                        {
                            selectedCustomStringArray[textString] = ""
                            selectedCustomString = customAttEnglishNameArray[0] as! String
                        }
                    }
                    
                    if let idString = customAttIdArray[i] as? Int
                    {
                        selectedCustomIntArray["\(idString)"] = ""
                    }
                }
                
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
                stopActivity()
                let responseEmptyAlert = UIAlertController(title: "Alert", message: "Customization not available for this dress type", preferredStyle: .alert)
                responseEmptyAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: responseEmptyAlertAction(action:)))
                self.present(responseEmptyAlert, animated: true, completion: nil)
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
    
    func responseEmptyAlertAction(action : UIAlertAction)
    {
        UserDefaults.standard.set(1, forKey: "custom3Response")
        let measurement1Screen = Measurement1ViewController()
        self.navigationController?.pushViewController(measurement1Screen, animated: true)
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
        
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
    }
    
    func changeViewToArabicInSelf()
    {
        selfScreenContents.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        viewDesignLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selectionImage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        dropDownButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        dropDownImageView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        viewDesignLabel.text = "معاينة"
    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenContents.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        viewDesignLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selectionImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

        dropDownButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        dropDownImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        viewDesignLabel.text = "PREVIEW"
    }
    
    func customization3Content(inputArray : NSArray)
    {
        selfScreenContents.frame = CGRect(x: x, y: pageBar.frame.maxY, width: view.frame.width - (2 * x), height: view.frame.height - ((5 * y) + navigationBar.frame.maxY + pageBar.frame.height))
        selfScreenContents.backgroundColor = UIColor.clear
        view.addSubview(selfScreenContents)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                pageBar.image = UIImage(named: "CustomizationBar")
            }
            else if language == "ar"
            {
                pageBar.image = UIImage(named: "customizationArabicHintImage")
            }
        }
        else
        {
            pageBar.image = UIImage(named: "CustomizationBar")
        }
        
        self.view.bringSubviewToFront(slideMenuButton)
        
        viewDesignLabel.frame = CGRect(x: 0, y: y, width: (25 * x), height: (4 * y))
        viewDesignLabel.layer.cornerRadius = 10
        viewDesignLabel.layer.masksToBounds = true
        viewDesignLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        viewDesignLabel.text = "PREVIEW"
        viewDesignLabel.textColor = UIColor.white
        viewDesignLabel.textAlignment = .center
        viewDesignLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        selfScreenContents.addSubview(viewDesignLabel)
        
        customedImageView.frame = CGRect(x: 0, y: viewDesignLabel.frame.maxY + y, width: (25 * x), height: (20 * y))
        customedImageView.layer.borderWidth = 1
        customedImageView.layer.borderColor = UIColor.lightGray.cgColor
        customedImageView.backgroundColor = UIColor.white
        if let imageName = customImagesArray[0] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/Customazation3/\(imageName)"
            let apiurl = URL(string: api)
            
            if apiurl != nil
            {
                customedImageView.dowloadFromServer(url: apiurl!)
            }
        }
        selfScreenContents.addSubview(customedImageView)
        
        customedFrontButton.frame = CGRect(x: customedImageView.frame.maxX + x, y: customedImageView.frame.minY + y, width: (7.5 * x), height: (7.5 * y))
        customedFrontButton.layer.borderWidth = 1
        customedFrontButton.layer.borderColor = UIColor.lightGray.cgColor
        customedFrontButton.backgroundColor = UIColor.white
        if let imageName = customImagesArray[0] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/Customazation3/\(imageName)"
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: customedFrontButton.frame.width, height: customedFrontButton.frame.height)
            if apiurl != nil
            {
                dummyImageView.dowloadFromServer(url: apiurl!)
            }
            customedFrontButton.addSubview(dummyImageView)
        }
        customedFrontButton.tag = 0
        customedFrontButton.addTarget(self, action: #selector(self.dressSelectionButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(customedFrontButton)
        
        selectionImage.frame = CGRect(x: x, y: y, width: (2 * x), height: (2 * y))
        selectionImage.image = UIImage(named: "selectionImage")
        customedFrontButton.addSubview(selectionImage)
        
        customedBackButton.frame = CGRect(x: customedImageView.frame.maxX + x, y: customedFrontButton.frame.maxY + y, width: (7.5 * x), height: (7.5 * y))
        customedBackButton.layer.borderWidth = 1
        customedBackButton.layer.borderColor = UIColor.lightGray.cgColor
        customedBackButton.backgroundColor = UIColor.white
        
        if customImagesArray.count > 1
        {
            if let imageName = customImagesArray[1] as? String
            {
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/Customazation3/\(imageName)"
                let apiurl = URL(string: api)
                
                let dummyImageView = UIImageView()
                dummyImageView.frame = CGRect(x: 0, y: 0, width: customedBackButton.frame.width, height: customedBackButton.frame.height)
                if apiurl != nil
                {
                    dummyImageView.dowloadFromServer(url: apiurl!)
                }
                customedBackButton.addSubview(dummyImageView)
            }
        }
        
        customedBackButton.tag = 1
        customedBackButton.addTarget(self, action: #selector(self.dressSelectionButtonAction(sender:)), for: .touchUpInside)
        
        if customImagesArray.count > 1
        {
            selfScreenContents.addSubview(customedBackButton)
        }
        
        dropDownButton.frame = CGRect(x: 0, y: customedImageView.frame.maxY + (2 * y), width: selfScreenContents.frame.width, height: (4 * y))
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
        
        let onOrOffValue = UserDefaults.standard.value(forKey: "hintsSwitch") as! Int
        
        if onOrOffValue == 1
        {
            hintsViewContents()
            hintsContents()
        }
        else
        {
            
        }
    }
    
    func hintsContents()
    {
        let headingLabel = UILabel()
        headingLabel.frame = CGRect(x: (2 * x), y: (15 * y), width: hintsView.frame.width - (4 * x), height: (3 * y))
        headingLabel.text = "Customizations"
        headingLabel.textAlignment = .left
        headingLabel.textColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0)
        headingLabel.font = UIFont(name: "Avenir-Regular", size: (2 * x))
        hintsView.addSubview(headingLabel)
       
        hintsBackButton.isHidden = true
        hintsBackButton.frame = CGRect(x: x, y: hintsView.frame.height - (6 * y), width: (11.16 * x), height: (4 * y))
        hintsBackButton.backgroundColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0)
        hintsBackButton.setTitle("Back", for: .normal)
        hintsBackButton.setTitleColor(UIColor.white, for: .normal)
        hintsBackButton.tag = 0
        hintsBackButton.addTarget(self, action: #selector(self.threeButtonAction(sender:)), for: .touchUpInside)
        hintsView.addSubview(hintsBackButton)
        
        hintsSkipButton.frame = CGRect(x: hintsBackButton.frame.maxX + x, y: hintsView.frame.height - (6 * y), width: (11.16 * x), height: (4 * y))
        hintsSkipButton.backgroundColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0)
        hintsSkipButton.setTitle("Skip", for: .normal)
        hintsSkipButton.setTitleColor(UIColor.white, for: .normal)
        hintsSkipButton.tag = 1
        hintsSkipButton.addTarget(self, action: #selector(self.threeButtonAction(sender:)), for: .touchUpInside)
        hintsView.addSubview(hintsSkipButton)
        
        hintsNextButton.frame = CGRect(x: hintsSkipButton.frame.maxX + x, y: hintsView.frame.height - (6 * y), width: (11.16 * x), height: (4 * y))
        hintsNextButton.backgroundColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0)
        hintsNextButton.setTitle("Next", for: .normal)
        hintsNextButton.setTitleColor(UIColor.white, for: .normal)
        hintsNextButton.tag = 2
        hintsNextButton.addTarget(self, action: #selector(self.threeButtonAction(sender:)), for: .touchUpInside)
        hintsView.addSubview(hintsNextButton)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                hintsBackButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                hintsBackButton.setTitle("Back", for: .normal)
                
                hintsSkipButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                hintsSkipButton.setTitle("Skip", for: .normal)
                
                hintsNextButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                hintsNextButton.setTitle("Next", for: .normal)
            }
            else if language == "ar"
            {
                hintsBackButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                hintsBackButton.setTitle("الى الخلف", for: .normal)
                
                hintsSkipButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                hintsSkipButton.setTitle("تخطى", for: .normal)
                
                hintsNextButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                hintsNextButton.setTitle("التالى", for: .normal)
            }
        }
        else
        {
            hintsBackButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            hintsBackButton.setTitle("Back", for: .normal)
            
            hintsSkipButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            hintsSkipButton.setTitle("Skip", for: .normal)
            
            hintsNextButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            hintsNextButton.setTitle("Next", for: .normal)
        }
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                headingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                headingLabel.text = "Customizations"
                headingLabel.textAlignment = .left
            }
            else if language == "ar"
            {
                headingLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                headingLabel.text = "التخصيصات"
                headingLabel.textAlignment = .right
            }
        }
        else
        {
            headingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            headingLabel.text = "Customizations"
            headingLabel.textAlignment = .left
        }
        
        firstHint()
    }
    
    @objc func threeButtonAction(sender : UIButton)
    {
        if sender.tag == 0
        {
            if hintTag != 0
            {
                hintTag = hintTag - 1
            }
            
            if hintTag == 0
            {
                firstHint()
                hintsBackButton.isHidden = true

            }
            else if hintTag == 1
            {
                secondHint()
                hintsBackButton.isHidden = false
            }
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    hintsNextButton.setTitle("Next", for: .normal)
                }
                else if language == "ar"
                {
                    hintsNextButton.setTitle("التالى", for: .normal)
                }
            }
            else
            {
                hintsNextButton.setTitle("Next", for: .normal)
            }
        }
        else if sender.tag == 1
        {
            hintsView.removeFromSuperview()
        }
        else if sender.tag == 2
        {
            if hintTag < 5
            {
                hintTag = hintTag + 1
            }
            
            if hintTag == 0
            {
                firstHint()
            }
            else if hintTag == 1
            {
                secondHint()
                hintsBackButton.isHidden = false
                
                if let language = UserDefaults.standard.value(forKey: "language") as? String
                {
                    if language == "en"
                    {
                        sender.setTitle("Got it", for: .normal)
                    }
                    else if language == "ar"
                    {
                        sender.setTitle("أنا أخذت", for: .normal)
                    }
                }
                else
                {
                    sender.setTitle("Got it", for: .normal)
                }
            }
            else
            {
                hintTag = 0
                hintsView.removeFromSuperview()
            }
        }
    }
    
    func firstHint()
    {
        hintsImage.frame = CGRect(x: x, y: customedImageView.frame.maxY + (13.5 * y), width: selfScreenContents.frame.width, height: (4 * y))
        hintsImage.layer.borderWidth = 2
        hintsImage.layer.borderColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0).cgColor
        hintsImage.image = UIImage(named: "custom3Image")
        hintsView.addSubview(hintsImage)
        
        detailedLabel.frame = CGRect(x: (2 * x), y: hintsImage.frame.maxY + y, width: hintsView.frame.width - (4 * x), height: (5 * y))
        detailedLabel.text = "Please click and select the part to be customized."
        detailedLabel.textAlignment = .left
        detailedLabel.textColor = UIColor.white
        detailedLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
        detailedLabel.font = detailedLabel.font.withSize((1.5 * x))
        detailedLabel.numberOfLines = 3
        hintsView.addSubview(detailedLabel)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                hintsImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                detailedLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                detailedLabel.text = "Please click and select the part to be customized."
                detailedLabel.textAlignment = .left
            }
            else if language == "ar"
            {
                hintsImage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                detailedLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                detailedLabel.text = "الرجاء الضغط وتحديد الجزء المراد تخصيصه."
                detailedLabel.textAlignment = .right
            }
        }
        else
        {
            hintsImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            detailedLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            detailedLabel.text = "Please click and select the part to be customized."
            detailedLabel.textAlignment = .left
        }
    }
    
    func secondHint()
    {
        hintsImage.frame = CGRect(x: x, y: customedImageView.frame.maxY + (19.5 * y), width: selfScreenContents.frame.width, height: (10 * y))
        hintsImage.layer.borderWidth = 2
        hintsImage.layer.borderColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0).cgColor
        hintsImage.image = UIImage(named: "customScrollHintImage")
        hintsView.addSubview(hintsImage)
        
        detailedLabel.frame = CGRect(x: (2 * x), y: hintsImage.frame.minY - (6 * y), width: hintsView.frame.width - (4 * x), height: (5 * y))
        detailedLabel.text = "Please Select any customization for selected part."
        detailedLabel.textAlignment = .justified
        detailedLabel.textColor = UIColor.white
        detailedLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
        detailedLabel.font = detailedLabel.font.withSize((1.5 * x))
        detailedLabel.numberOfLines = 3
        hintsView.addSubview(detailedLabel)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                hintsImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                detailedLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                detailedLabel.text = "Please Select any customization for selected part."
                detailedLabel.textAlignment = .left
            }
            else if language == "ar"
            {
                hintsImage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                detailedLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                detailedLabel.text = "يرجى تحديد أي تخصيص للجزء المحدد."
                detailedLabel.textAlignment = .right
            }
        }
        else
        {
            hintsImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            detailedLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            detailedLabel.text = "Please Select any customization for selected part."
            detailedLabel.textAlignment = .left
        }
    }
    
    func subcCustomization3Content(inputArray : NSArray)
    {
        customizationScrollView.frame = CGRect(x: 0, y: dropDownButton.frame.maxY + y, width: selfScreenContents.frame.width, height: (12 * y))
        selfScreenContents.addSubview(customizationScrollView)
        
        for views in customizationScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        var x3:CGFloat = 0
        
        for i in 0..<inputArray.count
        {
            let customizationButton = UIButton()
            customizationButton.frame = CGRect(x: x3, y: y, width: (12 * x), height: (10 * y))
            customizationButton.backgroundColor = UIColor.white
            customizationButton.tag = subCustomAttIdArray[i] as! Int
            customizationButton.addTarget(self, action: #selector(self.customizationButtonAction(sender:)), for: .touchUpInside)
            customizationScrollView.addSubview(customizationButton)
            
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
            buttonImage.frame = CGRect(x: 0, y: 0, width: customizationButton.frame.width, height: customizationButton.frame.height - (2 * y))
            buttonImage.backgroundColor = UIColor.white
            if let imageName = subCustomAttImageArray[i] as? String
            {
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/Customazation3/\(imageName)"
                let apiurl = URL(string: api)
                print("GET API", apiurl)
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
            
            
            if selectedCustomIntArray["\(selectedCustomInt)"]!.isEmpty == true
            {
                
            }
            else
            {
                if let id = selectedCustomIntArray["\(selectedCustomInt)"]
                {
                    print("SELECTED SUB CONTENT", selectedCustomIntArray, id, selectedCustomInt)
                    
                    if id == "\(customizationButton.tag)"
                    {
                        //                        self.customizationButtonAction(sender: customizationButton)
                        
                        selectionImage1.frame = CGRect(x: x, y: y, width: (2 * x), height: (2 * y))
                        selectionImage1.image = UIImage(named: "selectionImage")
                        selectionImage1.tag = customizationButton.tag
                        customizationButton.addSubview(selectionImage1)
                    }
                }
            }
        }
        
        customizationScrollView.contentSize.width = x3
        
        let customization3NextButton = UIButton()
        customization3NextButton.frame = CGRect(x: selfScreenContents.frame.width - (4 * x), y: customizationScrollView.frame.maxY, width: (3 * x), height: (3 * x))
        customization3NextButton.layer.cornerRadius = customization3NextButton.frame.height / 2
        customization3NextButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        customization3NextButton.layer.masksToBounds = true
        customization3NextButton.setImage(UIImage(named: "rightArrow"), for: .normal)
        customization3NextButton.addTarget(self, action: #selector(self.customization3NextButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(customization3NextButton)
        
        self.stopActivity()
        self.activeStop1()
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
        
        if customImagesArray.count > 1
        {
            if let imageName = customImagesArray[sender.tag] as? String
            {
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/Customazation3/\(imageName)"
                let apiurl = URL(string: api)
                if apiurl != nil
                {
                    customedImageView.dowloadFromServer(url: apiurl!)
                }
            }
        }
        else
        {
            if let imageName = customImagesArray[0] as? String
            {
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/Customazation3/\(imageName)"
                let apiurl = URL(string: api)
                if apiurl != nil
                {
                    customedImageView.dowloadFromServer(url: apiurl!)
                }
            }
        }
        
        
    }
    
    func customizationViewContents()
    {
        customBlurView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        customBlurView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.addSubview(customBlurView)
        
        customTitleLabel.frame = CGRect(x: x, y: customBlurView.frame.height - (35 * y), width: customBlurView.frame.width - (2 * x), height: (5 * y))
        customTitleLabel.backgroundColor = UIColor.white
        customTitleLabel.text = "Customize your material"
        customTitleLabel.textColor = UIColor.black
        customTitleLabel.textAlignment = .center
        customTitleLabel.font = UIFont(name: "Avenir-Regular", size: (2 * x))
        customTitleLabel.font = customTitleLabel.font.withSize(2 * x)
        customBlurView.addSubview(customTitleLabel)
        
        if customAttEnglishNameArray.count <= 5
        {
            customTitleLabel.frame = CGRect(x: x, y: customBlurView.frame.height - (35 * y), width: customBlurView.frame.width - (2 * x), height: (5 * y))
        }
        else
        {
            customTitleLabel.frame = CGRect(x: x, y: customBlurView.frame.height - ((35 * y) + (CGFloat(customAttEnglishNameArray.count) * y)), width: customBlurView.frame.width - (2 * x), height: (5 * y))
        }
        
        let underline = UILabel()
        underline.frame = CGRect(x: x, y: customTitleLabel.frame.maxY, width: customBlurView.frame.width  - (2 * x), height: 1)
        underline.backgroundColor = UIColor.lightGray
        customBlurView.addSubview(underline)
        
        customTableView.frame = CGRect(x: x, y: underline.frame.maxY, width: customBlurView.frame.width - (2 * x), height: (CGFloat(customAttEnglishNameArray.count) * 4 * y))
        customTableView.backgroundColor = UIColor.clear
        customTableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        customTableView.separatorStyle = .singleLineEtched
        customTableView.separatorColor = UIColor.lightGray
        customTableView.dataSource = self
        customTableView.delegate = self
        customBlurView.addSubview(customTableView)
    
        customTableView.reloadData()
        
        let customCancelButton = UIButton()
        customCancelButton.frame = CGRect(x: x, y: customTableView.frame.maxY, width: customBlurView.frame.width - (2 * x), height: (5 * y))
        customCancelButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        customCancelButton.setTitle("Cancel", for: .normal)
        customCancelButton.setTitleColor(UIColor.white, for: .normal)
        customCancelButton.addTarget(self, action: #selector(self.customCancelButtonAction(sender:)), for: .touchUpInside)
        customBlurView.addSubview(customCancelButton)
    }
    
    @objc func customCancelButtonAction(sender : UIButton)
    {
        customBlurView.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customAttEnglishNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath as IndexPath)
        
        cell.backgroundColor = UIColor.white
        
        let customLabel = UILabel()
        customLabel.frame = CGRect(x: x, y: 0, width: cell.frame.width - (5 * x), height: cell.frame.height)
        customLabel.text = customAttEnglishNameArray[indexPath.row] as! String
        customLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        customLabel.textAlignment = .left
        customLabel.font = UIFont(name: "Avenir-Regular", size: (2 * x))
        customLabel.font = customLabel.font.withSize(2 * x)
//        cell.addSubview(customLabel)
        
        cell.textLabel?.text = customAttEnglishNameArray[indexPath.row] as! String
        cell.textLabel?.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        
        let customSelectedImage = UIImageView()
        customSelectedImage.frame = CGRect(x: cell.frame.width - (3 * y), y: y, width: (2 * y), height: (2 * y))
        customSelectedImage.image = UIImage(named: "selectionImage")
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                if let custom = customAttEnglishNameArray[indexPath.row] as? String
                {
                    customLabel.text = custom
                    
                    if selectedCustomStringArray[custom] == ""
                    {
                        
                    }
                    else
                    {
                        cell.addSubview(customSelectedImage)
                    }
                }
            }
            else if language == "ar"
            {
                if let custom = customAttArabicNameArray[indexPath.row] as? String
                {
                    customLabel.text = custom
                    
                    if selectedCustomStringArray[custom] == ""
                    {
                        
                    }
                    else
                    {
                        cell.addSubview(customSelectedImage)
                    }
                }
            }
        }
        else
        {
            if let custom = customAttEnglishNameArray[indexPath.row] as? String
            {
                customLabel.text = custom
                
                if selectedCustomStringArray[custom] == ""
                {
                    
                }
                else
                {
                    cell.addSubview(customSelectedImage)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (4 * y)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dropDownButton.setTitle(customAttEnglishNameArray[indexPath.row] as! String, for: .normal)

        selectedCustomString = (customAttEnglishNameArray[indexPath.row] as! String)
        
        print("ACTION TITLE AFTER CLICK", selectedCustomStringArray)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                for i in 0..<customAttEnglishNameArray.count
                {
                    if let checkAtt = customAttEnglishNameArray[i] as? String
                    {
                        print("EQUAATING OR CHECKING THE CONDITION", selectedCustomString, checkAtt)
                        if selectedCustomString == checkAtt
                        {
                            if let attId = customAttIdArray[i] as? Int
                            {
                                self.activeStart1()
                                self.view.bringSubviewToFront(activeView)
                                
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
                        if selectedCustomString == checkAtt
                        {
                            if let attId = customAttIdArray[i] as? Int
                            {
                                self.activeStart1()
                                self.view.bringSubviewToFront(activeView)
                                
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
                    if selectedCustomString == checkAtt
                    {
                        if let attId = customAttIdArray[i] as? Int
                        {
                            self.activeStart1()
                            self.view.bringSubviewToFront(activeView)
                            
                            self.serviceCall.API_Customization3Attr(AttributeId: attId, delegate: self)
                            selectedCustomInt = attId
                        }
                    }
                }
            }
            
        }
        
        customBlurView.removeFromSuperview()
    }
    
    @objc func dropDownButtonAction(sender : UIButton)
    {
        customizationViewContents()
        
        /*if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                let customizationAlert = UIAlertController(title: "Customize", message: "Customize your material", preferredStyle: .alert)
                                
                for i in 0..<customAttEnglishNameArray.count
                {
                    if let alertString = customAttEnglishNameArray[i] as? String
                    {
                        print("CHECKING WITH THE VALUES", selectedCustomStringArray[alertString]!)
                        if selectedCustomStringArray[alertString]! == ""
                        {
                            customizationAlert.addAction(UIAlertAction(title: alertString, style: .destructive, handler: customizaionAlertAction(action:)))
                        }
                        else
                        {
                            customizationAlert.addAction(UIAlertAction(title: alertString, style: .default, handler: customizaionAlertAction(action:)))
                        }
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
                        if let alertString = customAttEnglishNameArray[i] as? String
                        {
                            print("CHECKING WITH THE VALUES", selectedCustomStringArray[alertString]!)
                            if selectedCustomStringArray[alertString]! == ""
                            {
                                customizationAlert.addAction(UIAlertAction(title: alertString, style: .destructive, handler: customizaionAlertAction(action:)))
                            }
                            else
                            {
                                customizationAlert.addAction(UIAlertAction(title: alertString, style: .default, handler: customizaionAlertAction(action:)))
                            }
                        }
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
                    if let alertString = customAttEnglishNameArray[i] as? String
                    {
                        print("CHECKING WITH THE VALUES", selectedCustomStringArray[alertString]!)
                        if selectedCustomStringArray[alertString]! == ""
                        {
                            customizationAlert.addAction(UIAlertAction(title: alertString, style: .destructive, handler: customizaionAlertAction(action:)))
                        }
                        else
                        {
                            customizationAlert.addAction(UIAlertAction(title: alertString, style: .default, handler: customizaionAlertAction(action:)))
                        }
                    }
                }
            }
            customizationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(customizationAlert, animated: true, completion: nil)
        }*/
    }
    
    func customizaionAlertAction(action : UIAlertAction)
    {
        dropDownButton.setTitle(action.title?.uppercased(), for: .normal)
        
        selectedCustomString = (action.title)!
        
        print("ACTION TITLE AFTER CLICK", selectedCustomStringArray)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                for i in 0..<customAttEnglishNameArray.count
                {
                    if let checkAtt = customAttEnglishNameArray[i] as? String
                    {
                        print("EQUAATING OR CHECKING THE CONDITION", selectedCustomString, checkAtt)
                        if selectedCustomString == checkAtt
                        {
                            if let attId = customAttIdArray[i] as? Int
                            {
                                self.activeStart1()
                                self.view.bringSubviewToFront(activeView)

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
                        if selectedCustomString == checkAtt
                        {
                            if let attId = customAttIdArray[i] as? Int
                            {
                                self.activeStart1()
                                self.view.bringSubviewToFront(activeView)

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
                    if selectedCustomString == checkAtt
                    {
                        if let attId = customAttIdArray[i] as? Int
                        {
                            self.activeStart1()
                            self.view.bringSubviewToFront(activeView)

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
        
        for i in 0..<subCustomAttIdArray.count
        {
            if let id = subCustomAttIdArray[i] as? Int
            {
                if sender.tag == id
                {
                    if let imageName = subCustomAttImageArray[i] as? String
                    {
                        let urlString = serviceCall.baseURL
                        let api = "\(urlString)/images/Customazation3/\(imageName)"
                        let apiurl = URL(string: api)
                        print("GET API", apiurl)
                        if apiurl != nil
                        {
                            customedImageView.dowloadFromServer(url: apiurl!)
                        }
                    }
                }
            }
        }
        
        selectedCustomIntArray["\(selectedCustomInt)"] = "\(sender.tag)"
        
        for i in 0..<subCustomAttEnglishNameArray.count
        {
            if let idInt = subCustomAttIdArray[i] as? Int
            {
                if selectedCustomIntArray["\(selectedCustomInt)"] == "\(idInt)"
                {
                    if let language = UserDefaults.standard.value(forKey: "language") as? String
                    {
                        if language == "en"
                        {
                            selectedCustomStringArray[selectedCustomString] = subCustomAttEnglishNameArray[i] as? String
                        }
                        else if language == "ar"
                        {
                            selectedCustomStringArray[selectedCustomString] = subCustomAttArabicNameArray[i] as? String
                        }
                    }
                    else
                    {
                        selectedCustomStringArray[selectedCustomString] = subCustomAttEnglishNameArray[i] as? String
                    }
                }
            }
        }
    }
    
    @objc func customization3NextButtonAction(sender : UIButton)
    {
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                for (keys, values) in selectedCustomStringArray
                {
                    if values.isEmpty == true || values == ""
                    {
                        let customEmptyAlert = UIAlertController(title: "Alert", message: "Please choose your customization for \(keys) and proceed to next", preferredStyle: .alert)
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
                    if values.isEmpty == true || values == ""
                    {
                        print("CHECK WITH EMPTY KEYS", keys, values)
                        print("OVER ALL ARRAY", selectedCustomStringArray)
                        let customEmptyAlert = UIAlertController(title: "محزر", message: "الرجاء اختيار التخصيص لـ \(keys) والمتابعة إلى التالي", preferredStyle: .alert)
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
                if values.isEmpty == true || values == ""
                {
                    let customEmptyAlert = UIAlertController(title: "Alert", message: "Please choose your customization for \(keys) and proceed to next", preferredStyle: .alert)
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
        
        print("CUSTOMIZATION NEXT BUTTON ACTION", selectedCustomStringArray)
        print("selectedCustomIntArrayselectedCustomIntArray", selectedCustomIntArray)
        
        if customAttEnglishNameArray.count == customDictValuesCount
        {
            UserDefaults.standard.set(selectedCustomStringArray, forKey: "custom3")
            UserDefaults.standard.set(selectedCustomIntArray, forKey: "custom3Id")
            UserDefaults.standard.set(0, forKey: "custom3Response")
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
