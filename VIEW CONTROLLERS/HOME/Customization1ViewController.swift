//
//  Customization1ViewController.swift
//  Mzyoon
//
//  Created by QOL on 16/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class Customization1ViewController: CommonViewController, ServerAPIDelegate
{
    let serviceCall = ServerAPI()
    
    
    
    //NAVIGATION BAR CONTENTS
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()
    
    //SCREEN CONTENTS
    let selfScreenContents = UIView()
    let customization1NextButton = UIButton()
    let seasonTitleLabel = UILabel()
    let industryTitleLabel = UILabel()
    let brandTitleLabel = UILabel()
    
    //CUSTOMIZATION 1 PAREMETERS
    let customization1View = UIView()
    
    var seasonalNameEnglishArray = NSArray()
    var seasonalNameArabicArray = NSArray()
    var seasonalIdArray = NSArray()
    var seasonalImageArray = NSArray()
    var convertedSeasonalImageArray = [UIImage]()
    
    var industryNameEnglishArray = NSArray()
    var industryNameArabicArray = NSArray()
    var industryIdArray = NSArray()
    var industryImageArray = NSArray()
    var convertedIndustryImageArray = [UIImage]()
    
    var brandNameEnglishArray = NSArray()
    var brandNameArabicArray = NSArray()
    var clearBrandNameArray = NSArray()
    var brandIdArray = NSArray()
    var clearBrandIdArray = NSArray()
    var brandImageArray = NSArray()
    var clearBrandImageArray = NSArray()
    var convertedBrandImageArray = [UIImage]()
    
    var seasonalTag = true
    var industryTag = true
    var brandTag = true
    
    var seasonalTagArray = [Int]()
    let industrySelectionImage = UIImageView()
    let brandSelectionImage = UIImageView()
    
    var seasonalTagInt = Int()
    var seasonalTagIntArray = [Int]()
    
    var industryTagInt = Int()
    var industryTagIntArray = [Int]()
    
    var brandTagInt = Int()
    var brandTagIntArray = [Int]()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    let seasonalScrollView = UIScrollView()
    let industryScrollView = UIScrollView()
    let brandScrollView = UIScrollView()
    
    var updateId = Int()
    
    var applicationDelegate = AppDelegate()

    
    override func viewDidLoad()
    {
        navigationBar.isHidden = true
        //        self.tab1Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        selectedButton(tag: 0)
        
        updateId = 0
        
        self.serviceCallFunction(originIdArray: [1], seasonIdArray: [1])
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        customization1Content()
    }
    
    func serviceCallFunction(originIdArray : [Int], seasonIdArray : [Int])
    {
        let getConversion = ConversionToJson()
        
        let id1 = getConversion.MakeRequest(id: originIdArray)
        
        let id2 = getConversion.MakeRequest(id: seasonIdArray)
        
        self.serviceCall.API_Customization1(originId: id1, seasonId: id2 , delegate: self)
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        // ErrorStr = "Default Error"
        PageNumStr = "Customization1ViewController"
        MethodName = "GetCustomization1"
        
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
    }
    
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("CUSTOMIZATION 1", errorMessage)
        stopActivity()
        applicationDelegate.exitContents()
    }
    
    
    func API_CALLBACK_InsertErrorDevice(deviceError: NSDictionary)
    {
        let ResponseMsg = deviceError.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = deviceError.object(forKey: "Result") as! String
            print("Result", Result)
        }
    }
    
    func API_CALLBACK_Customization1(custom1: NSDictionary)
    {
        print("Customization 1", custom1)
        let ResponseMsg = custom1.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            brandNameEnglishArray = clearBrandNameArray
            
            brandIdArray = clearBrandIdArray
            brandImageArray = clearBrandImageArray
            
            let Result = custom1.object(forKey: "Result") as! NSDictionary
            
            let materialBrand = Result.object(forKey: "materialBrand") as! NSArray
            brandNameArabicArray = materialBrand.value(forKey: "BrandInArabic") as! NSArray
            brandNameEnglishArray = materialBrand.value(forKey: "BrandInEnglish") as! NSArray
            brandIdArray = materialBrand.value(forKey: "Id") as! NSArray
            brandImageArray = materialBrand.value(forKey: "Image") as! NSArray
            
            /*for i in 0..<brandImageArray.count
             {
             if let imageName = brandImageArray[i] as? String
             {
             let urlString = serviceCall.baseURL
             let api = "\(urlString)/images/Brands/\(imageName)"
             let apiurl = URL(string: api)
             
             if let data = try? Data(contentsOf: apiurl!) {
             if let image = UIImage(data: data) {
             self.convertedBrandImageArray.append(image)
             }
             }
             else
             {
             let emptyImage = UIImage(named: "empty")
             self.convertedBrandImageArray.append(emptyImage!)
             }
             }
             else if let imgName = brandImageArray[i] as? NSNull
             {
             let emptyImage = UIImage(named: "empty")
             self.convertedBrandImageArray.append(emptyImage!)
             }
             }*/
            
            let placeofIndustrys = Result.object(forKey: "placeofIndustrys") as! NSArray
            industryNameArabicArray = placeofIndustrys.value(forKey: "PlaceInArabic") as! NSArray
            industryNameEnglishArray = placeofIndustrys.value(forKey: "PlaceInEnglish") as! NSArray
            industryIdArray = placeofIndustrys.value(forKey: "Id") as! NSArray
            industryImageArray = placeofIndustrys.value(forKey: "Image") as! NSArray
            
            /*for i in 0..<industryImageArray.count
             {
             if let imageName = industryImageArray[i] as? String
             {
             let urlString = serviceCall.baseURL
             let api = "\(urlString)/images/PlaceOfIndustry/\(imageName)"
             let apiurl = URL(string: api)
             
             if let data = try? Data(contentsOf: apiurl!) {
             if let image = UIImage(data: data) {
             self.convertedIndustryImageArray.append(image)
             }
             }
             else
             {
             let emptyImage = UIImage(named: "empty")
             self.convertedIndustryImageArray.append(emptyImage!)
             }
             }
             else if let imgName = industryImageArray[i] as? NSNull
             {
             let emptyImage = UIImage(named: "empty")
             self.convertedIndustryImageArray.append(emptyImage!)
             }
             }*/
            
            
            let seasons = Result.object(forKey: "seasons") as! NSArray
            seasonalNameArabicArray = seasons.value(forKey: "SeasonInArabic") as! NSArray
            seasonalNameEnglishArray = seasons.value(forKey: "SeasonInEnglish") as! NSArray
            seasonalIdArray = seasons.value(forKey: "Id") as! NSArray
            seasonalImageArray = seasons.value(forKey: "Image") as! NSArray
            
            /*for i in 0..<seasonalImageArray.count
             {
             if let imageName = seasonalImageArray[i] as? String
             {
             let urlString = serviceCall.baseURL
             let api = "\(urlString)/images/Seasons/\(imageName)"
             let apiurl = URL(string: api)
             
             if let data = try? Data(contentsOf: apiurl!) {
             if let image = UIImage(data: data) {
             self.convertedSeasonalImageArray.append(image)
             }
             }
             else
             {
             let emptyImage = UIImage(named: "empty")
             self.convertedSeasonalImageArray.append(emptyImage!)
             }
             }
             else if let imgName = seasonalImageArray[i] as? NSNull
             {
             let emptyImage = UIImage(named: "empty")
             self.convertedSeasonalImageArray.append(emptyImage!)
             }
             }*/
            
            if updateId == 0
            {
                customization1Content()
            }
            else if updateId == 1
            {
                if let language = UserDefaults.standard.value(forKey: "language") as? String
                {
                    if language == "en"
                    {
                        industryContents(getInputArray: industryNameEnglishArray)
                    }
                    else if language == "ar"
                    {
                        industryContents(getInputArray: industryNameArabicArray)
                    }
                }
                else
                {
                    industryContents(getInputArray: industryNameEnglishArray)
                }
            }
            else if updateId == 2
            {
                if let language = UserDefaults.standard.value(forKey: "language") as? String
                {
                    if language == "en"
                    {
                        brandContents(getInputArray: brandNameEnglishArray)
                    }
                    else if language == "ar"
                    {
                        brandContents(getInputArray: brandNameArabicArray)
                    }
                }
                else
                {
                    brandContents(getInputArray: brandNameEnglishArray)
                }
            }
        }
        else if ResponseMsg == "Failure"
        {
            let Result = custom1.object(forKey: "Result") as! String
            print("Result", Result)
            
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func changeViewToArabicInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.text = "التخصيص-1"
        
        selfScreenContents.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        seasonTitleLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        industryTitleLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        brandTitleLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        seasonTitleLabel.text = "موسمي"
        industryTitleLabel.text = "مكان الصناعة"
        brandTitleLabel.text = "العلامات التجارية"
    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.text = "CUSTOMIZATION-1"
        
        selfScreenContents.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        seasonTitleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        industryTitleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        brandTitleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        seasonTitleLabel.text = "SEASONAL"
        industryTitleLabel.text = "PLACE OF INDUSTRY"
        brandTitleLabel.text = "BRANDS"
    }
    
    func customization1Content()
    {
        selfScreenNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        selfScreenNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(selfScreenNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 5
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        selfScreenNavigationBar.addSubview(backButton)
        
        selfScreenNavigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: selfScreenNavigationBar.frame.width, height: (3 * y))
        selfScreenNavigationTitle.text = "CUSTOMIZATION-1"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationTitle.font = selfScreenNavigationTitle.font.withSize(2 * x)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        selfScreenContents.frame = CGRect(x: (3 * x), y: selfScreenNavigationBar.frame.maxY, width: view.frame.width - (6 * x), height: view.frame.height - ((5 * y) + selfScreenNavigationBar.frame.maxY))
        selfScreenContents.backgroundColor = UIColor.clear
        view.addSubview(selfScreenContents)
        
        self.view.bringSubviewToFront(slideMenuButton)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                self.seasonalContents(getInputArray: seasonalNameEnglishArray)
                self.industryContents(getInputArray: industryNameEnglishArray)
                self.brandContents(getInputArray: brandNameEnglishArray)
            }
            else if language == "ar"
            {
                self.seasonalContents(getInputArray: seasonalNameArabicArray)
                self.industryContents(getInputArray: industryNameArabicArray)
                self.brandContents(getInputArray: brandNameArabicArray)
            }
        }
        else
        {
            self.seasonalContents(getInputArray: seasonalNameEnglishArray)
            self.industryContents(getInputArray: industryNameEnglishArray)
            self.brandContents(getInputArray: brandNameEnglishArray)
        }
        
        customization1NextButton.frame = CGRect(x: selfScreenContents.frame.width - (4 * x), y: brandScrollView.frame.maxY, width: (4 * x), height: (4 * y))
        customization1NextButton.layer.cornerRadius = customization1NextButton.frame.height / 2
        customization1NextButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        customization1NextButton.setImage(UIImage(named: "rightArrow"), for: .normal)
        customization1NextButton.addTarget(self, action: #selector(self.customization1NextButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(customization1NextButton)
        
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
    
    func seasonalContents(getInputArray : NSArray)
    {
        seasonTitleLabel.frame = CGRect(x: ((view.frame.width - (12 * x)) / 2), y: y, width: (12 * x), height: (3 * y))
        seasonTitleLabel.layer.borderWidth = 1
        seasonTitleLabel.layer.masksToBounds = true
        seasonTitleLabel.backgroundColor = UIColor.white
        seasonTitleLabel.text = "SEASONAL"
        seasonTitleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        seasonTitleLabel.textAlignment = .center
        selfScreenContents.addSubview(seasonTitleLabel)
        
        seasonalScrollView.frame = CGRect(x: 0, y: seasonTitleLabel.frame.maxY, width: selfScreenContents.frame.width, height: (12 * y))
        selfScreenContents.addSubview(seasonalScrollView)
        
        var x1:CGFloat = x
        
        for views in seasonalScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        for i in 0..<getInputArray.count
        {
            let seasonalButton = UIButton()
            seasonalButton.frame = CGRect(x: x1, y: y, width: (12 * x), height: (10 * y))
            seasonalButton.tag = seasonalIdArray[i] as! Int
            seasonalButton.addTarget(self, action: #selector(self.seasonalButtonAction(sender:)), for: .touchUpInside)
            seasonalScrollView.addSubview(seasonalButton)
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                   seasonalButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
                else if language == "ar"
                {
                    seasonalButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                }
            }
            else
            {
                seasonalButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: 0, y: 0, width: seasonalButton.frame.width, height: seasonalButton.frame.height - (2 * y))
            //            buttonImage.image = convertedSeasonalImageArray[i]
            if let imageName = seasonalImageArray[i] as? String
            {
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/Seasons/\(imageName)"
                let apiurl = URL(string: api)
                if apiurl != nil
                {
                    buttonImage.dowloadFromServer(url: apiurl!)
                }
            }
            buttonImage.tag = -1
            seasonalButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 0, y: seasonalButton.frame.height - (2 * y), width: seasonalButton.frame.width, height: (2 * y))
            buttonTitle.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.text = getInputArray[i] as? String
            buttonTitle.textColor = UIColor.white
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 10)
            buttonTitle.tag = -1
            seasonalButton.addSubview(buttonTitle)
            
            x1 = seasonalButton.frame.maxX + (2 * x)
        }
        
        seasonalScrollView.contentSize.width = x1 + (3 * x)
        
    }
    
    func industryContents(getInputArray : NSArray)
    {
        industryTitleLabel.frame = CGRect(x: ((view.frame.width - (20 * x)) / 2), y: seasonalScrollView.frame.maxY + (2 * y), width: (20 * x), height: (3 * y))
        industryTitleLabel.layer.borderWidth = 1
        industryTitleLabel.layer.masksToBounds = true
        industryTitleLabel.backgroundColor = UIColor.white
        industryTitleLabel.text = "PLACE OF INDUSTRY"
        industryTitleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        industryTitleLabel.textAlignment = .center
        selfScreenContents.addSubview(industryTitleLabel)
        
        industryScrollView.frame = CGRect(x: 0, y: industryTitleLabel.frame.maxY, width: selfScreenContents.frame.width, height: (12 * y))
        selfScreenContents.addSubview(industryScrollView)
        
        for views in industryScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        var x3:CGFloat = x
        for i in 0..<getInputArray.count
        {
            let industryButton = UIButton()
            industryButton.frame = CGRect(x: x3, y: y, width: (12 * x), height: (10 * y))
            industryButton.tag = industryIdArray[i] as! Int
            industryButton.addTarget(self, action: #selector(self.industryButtonAction(sender:)), for: .touchUpInside)
            industryScrollView.addSubview(industryButton)
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    industryButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
                else if language == "ar"
                {
                    industryButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                }
            }
            else
            {
                industryButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: 0, y: 0, width: industryButton.frame.width, height: industryButton.frame.height - (2 * y))
            //            buttonImage.image = convertedIndustryImageArray[i]
            if let imageName = industryImageArray[i] as? String
            {
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/PlaceOfIndustry/\(imageName)"
                let apiurl = URL(string: api)
                if apiurl != nil
                {
                    buttonImage.dowloadFromServer(url: apiurl!)
                }
            }
            buttonImage.tag = -1
            industryButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 0, y: industryButton.frame.height - (2 * y), width: industryButton.frame.width, height: (2 * y))
            buttonTitle.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.text = getInputArray[i] as? String
            buttonTitle.textColor = UIColor.white
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 10)
            buttonTitle.tag = -1
            industryButton.addSubview(buttonTitle)
            
            x3 = industryButton.frame.maxX + (2 * x)
        }
        
        industryScrollView.contentSize.width = x3 + (3 * x)
    }
    
    func brandContents(getInputArray : NSArray)
    {
        brandTitleLabel.frame = CGRect(x: ((view.frame.width - (13 * x)) / 2), y: industryScrollView.frame.maxY + (2 * y), width: (13 * x), height: (3 * y))
        brandTitleLabel.layer.borderWidth = 1
        brandTitleLabel.layer.masksToBounds = true
        brandTitleLabel.backgroundColor = UIColor.white
        brandTitleLabel.text = "BRANDS"
        brandTitleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        brandTitleLabel.textAlignment = .center
        selfScreenContents.addSubview(brandTitleLabel)
        
        brandScrollView.frame = CGRect(x: 0, y: brandTitleLabel.frame.maxY, width: selfScreenContents.frame.width, height: (12 * y))
        selfScreenContents.addSubview(brandScrollView)
        
        for views in brandScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        var x2:CGFloat = x
        for i in 0..<getInputArray.count
        {
            let brandButton = UIButton()
            brandButton.frame = CGRect(x: x2, y: y, width: (12 * x), height: (10 * y))
            brandButton.tag = brandIdArray[i] as! Int
            brandButton.addTarget(self, action: #selector(self.brandButtonAction(sender:)), for: .touchUpInside)
            brandScrollView.addSubview(brandButton)
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    brandButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
                else if language == "ar"
                {
                    brandButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                }
            }
            else
            {
                brandButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: 0, y: 0, width: brandButton.frame.width, height: brandButton.frame.height - (2 * y))
            //            buttonImage.image = convertedBrandImageArray[i]
            if let imageName = brandImageArray[i] as? String
            {
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/Brands/\(imageName)"
                let apiurl = URL(string: api)
                
                if apiurl != nil{
                    buttonImage.dowloadFromServer(url: apiurl!)
                }
            }
            buttonImage.tag = -1
            brandButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 0, y: brandButton.frame.height - (2 * y), width: brandButton.frame.width, height: (2 * y))
            buttonTitle.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.text = getInputArray[i] as? String
            buttonTitle.textColor = UIColor.white
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 10)
            buttonTitle.tag = -1
            brandButton.addSubview(buttonTitle)
            
            x2 = brandButton.frame.maxX + (2 * x)
        }
        
        brandScrollView.contentSize.width = x2 + (3 * x)
        
        self.stopActivity()
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func seasonalButtonAction(sender : UIButton)
    {
        updateId = 1
        if sender.tag == 1
        {
            if seasonalTagIntArray.contains(sender.tag)
            {
                seasonalTagIntArray.removeAll()
            }
            else
            {
                for i in 0..<seasonalIdArray.count
                {
                    seasonalTagIntArray.append(seasonalIdArray[i] as! Int)
                }
            }
        }
        else
        {
            if seasonalTagIntArray.contains(1)
            {
                if seasonalTagIntArray.contains(sender.tag)
                {
                    seasonalTagIntArray = seasonalTagIntArray.filter { $0 != sender.tag }
                }
                else
                {
                    seasonalTagIntArray.append(sender.tag)
                }
                
                seasonalTagIntArray = seasonalTagIntArray.filter { $0 != 1 }
            }
            else
            {
                if seasonalTagIntArray.contains(sender.tag)
                {
                    seasonalTagIntArray = seasonalTagIntArray.filter { $0 != sender.tag }
                }
                else
                {
                    seasonalTagIntArray.append(sender.tag)
                }
            }
        }
        
        print("SEASOSNAL TAG INT ARRAY", seasonalTagIntArray)
        
        for views in seasonalScrollView.subviews
        {
            for foundView in views.subviews
            {
                print("FOUND VIEW NAMES", foundView)
                if let imageView = foundView as? UIImageView
                {
                    if imageView.tag > 0
                    {
                        imageView.removeFromSuperview()
                    }
                }
            }
        }
        
        for views in seasonalScrollView.subviews
        {
            for i in 0..<seasonalTagIntArray.count
            {
                if views.tag == seasonalTagIntArray[i]
                {
                    print("VIEWS TAG", views.tag)
                    let seasonalSelectionImage = UIImageView()
                    seasonalSelectionImage.frame = CGRect(x: x, y: y, width: (2 * x), height: (2 * y))
                    seasonalSelectionImage.image = UIImage(named: "selectionImage")
                    seasonalSelectionImage.tag = sender.tag
                    views.addSubview(seasonalSelectionImage)
                }
                else
                {
                    
                }
            }
        }
    }
    /*{
        let seasonalSelectionImage = UIImageView()
        seasonalSelectionImage.frame = CGRect(x: x, y: y, width: (2 * x), height: (2 * y))
        seasonalSelectionImage.image = UIImage(named: "selectionImage")
        seasonalSelectionImage.tag = sender.tag
        
        if sender.tag != 1
        {
            seasonalTagIntArray = seasonalTagIntArray.filter { $0 != 1 }
            
            for views in seasonalScrollView.subviews
            {
                if let buttonView = views.viewWithTag(1)
                {
                    for buttonSubView in buttonView.subviews
                    {
                        if buttonSubView.tag == 1
                        {
                            buttonSubView.removeFromSuperview()
                        }
                    }
                }
            }
            
            if seasonalTagIntArray.isEmpty == true
            {
                seasonalTagIntArray.append(sender.tag)
                sender.addSubview(seasonalSelectionImage)
            }
            else
            {
                if seasonalTagIntArray.contains(sender.tag)
                {
                    if let index = seasonalTagIntArray.index(where: {$0 == sender.tag}) {
                        seasonalTagIntArray.remove(at: index)
                    }
                    
                    for views in sender.subviews
                    {
                        if let findView = views.viewWithTag(sender.tag)
                        {
                            if findView.tag == sender.tag
                            {
                                findView.removeFromSuperview()
                            }
                            else
                            {
                                print("NOT SAME VIEW")
                            }
                        }
                    }
                }
                else
                {
                    seasonalTagIntArray.append(sender.tag)
                    sender.addSubview(seasonalSelectionImage)
                }
            }
            //            self.serviceCall(originIdArray: [0], seasonIdArray: seasonalTagIntArray)
        }
        else
        {
            for views in seasonalScrollView.subviews
            {
                if let buttonView = views.viewWithTag(views.tag)
                {
                    for buttonSubView in buttonView.subviews
                    {
                        if buttonSubView.tag == views.tag
                        {
                            buttonSubView.removeFromSuperview()
                        }
                    }
                }
            }
            
            if seasonalTagIntArray.contains(sender.tag)
            {
                if let index = seasonalTagIntArray.index(where: {$0 == sender.tag}) {
                    seasonalTagIntArray.remove(at: index)
                }
                
                for views in sender.subviews
                {
                    if let findView = views.viewWithTag(sender.tag)
                    {
                        if findView.tag == sender.tag
                        {
                            findView.removeFromSuperview()
                        }
                        else
                        {
                            print("NOT SAME VIEW")
                        }
                    }
                }
            }
            else
            {
                seasonalTagIntArray.removeAll()
                
                seasonalTagIntArray.append(sender.tag)
                sender.addSubview(seasonalSelectionImage)
            }
            
            //            self.serviceCall(originIdArray: [0], seasonIdArray: [0])
        }
        
        updateId = 1
    }*/
    
    @objc func industryButtonAction(sender : UIButton)
    {
        updateId = 2

        if sender.tag == 1
        {
            if industryTagIntArray.contains(sender.tag)
            {
                industryTagIntArray.removeAll()
            }
            else
            {
                for i in 0..<industryIdArray.count
                {
                    industryTagIntArray.append(industryIdArray[i] as! Int)
                }
            }
        }
        else
        {
            if industryTagIntArray.contains(1)
            {
                if industryTagIntArray.contains(sender.tag)
                {
                    industryTagIntArray = industryTagIntArray.filter { $0 != sender.tag }
                }
                else
                {
                    industryTagIntArray.append(sender.tag)
                }
                
                industryTagIntArray = industryTagIntArray.filter { $0 != 1 }
            }
            else
            {
                if industryTagIntArray.contains(sender.tag)
                {
                    industryTagIntArray = industryTagIntArray.filter { $0 != sender.tag }
                }
                else
                {
                    industryTagIntArray.append(sender.tag)
                }
            }
        }
        
        print("INDUSTRY TAG INT ARRAY", industryTagIntArray)
        
        for views in industryScrollView.subviews
        {
            for foundView in views.subviews
            {
                print("FOUND VIEW NAMES", foundView)
                if let imageView = foundView as? UIImageView
                {
                    if imageView.tag > 0
                    {
                        imageView.removeFromSuperview()
                    }
                }
            }
        }
        
        for views in industryScrollView.subviews
        {
            for i in 0..<industryTagIntArray.count
            {
                if views.tag == industryTagIntArray[i]
                {
                    print("VIEWS TAG", views.tag)
                    let industrySelectionImage = UIImageView()
                    industrySelectionImage.frame = CGRect(x: x, y: y, width: (2 * x), height: (2 * y))
                    industrySelectionImage.image = UIImage(named: "selectionImage")
                    industrySelectionImage.tag = sender.tag
                    views.addSubview(industrySelectionImage)
                }
                else
                {
                    
                }
            }
        }
        
        if industryTagIntArray.count != 0
        {
            self.serviceCallFunction(originIdArray: industryTagIntArray, seasonIdArray: [1])
        }
        else
        {
            self.serviceCallFunction(originIdArray: [1], seasonIdArray: [1])
        }
    }
    /*{
        let industrySelectionImage = UIImageView()
        industrySelectionImage.frame = CGRect(x: x, y: y, width: (2 * x), height: (2 * y))
        industrySelectionImage.image = UIImage(named: "selectionImage")
        industrySelectionImage.tag = sender.tag
        
        if sender.tag != 1
        {
            industryTagIntArray = industryTagIntArray.filter { $0 != 1 }
            
            for views in industryScrollView.subviews
            {
                if let buttonView = views.viewWithTag(1)
                {
                    for buttonSubView in buttonView.subviews
                    {
                        if buttonSubView.tag == 1
                        {
                            buttonSubView.removeFromSuperview()
                        }
                    }
                }
            }
            
            if industryTagIntArray.isEmpty == true
            {
                industryTagIntArray.append(sender.tag)
                sender.addSubview(industrySelectionImage)
            }
            else
            {
                if industryTagIntArray.contains(sender.tag)
                {
                    if let index = industryTagIntArray.index(where: {$0 == sender.tag}) {
                        industryTagIntArray.remove(at: index)
                    }
                    
                    for views in sender.subviews
                    {
                        if let findView = views.viewWithTag(sender.tag)
                        {
                            if findView.tag == sender.tag
                            {
                                findView.removeFromSuperview()
                            }
                            else
                            {
                                print("NOT SAME VIEW")
                            }
                        }
                    }
                }
                else
                {
                    industryTagIntArray.append(sender.tag)
                    sender.addSubview(industrySelectionImage)
                }
            }
            
            if industryTagIntArray.count != 0
            {
                self.serviceCallFunction(originIdArray: industryTagIntArray, seasonIdArray: [1])
            }
            else
            {
                self.serviceCallFunction(originIdArray: [1], seasonIdArray: [1])
            }
        }
        else
        {
            for views in industryScrollView.subviews
            {
                if let buttonView = views.viewWithTag(views.tag)
                {
                    for buttonSubView in buttonView.subviews
                    {
                        if buttonSubView.tag == views.tag
                        {
                            buttonSubView.removeFromSuperview()
                        }
                    }
                }
            }
            
            if industryTagIntArray.contains(sender.tag)
            {
                if let index = industryTagIntArray.index(where: {$0 == sender.tag}) {
                    industryTagIntArray.remove(at: index)
                }
                
                for views in sender.subviews
                {
                    if let findView = views.viewWithTag(sender.tag)
                    {
                        if findView.tag == sender.tag
                        {
                            findView.removeFromSuperview()
                        }
                        else
                        {
                            print("NOT SAME VIEW")
                        }
                    }
                }
            }
            else
            {
                industryTagIntArray.removeAll()
                
                industryTagIntArray.append(sender.tag)
                sender.addSubview(industrySelectionImage)
            }
            
            self.serviceCallFunction(originIdArray: [1], seasonIdArray: [1])
        }
        
        updateId = 2
    }*/
    
    @objc func brandButtonAction(sender : UIButton)
    {
        if sender.tag == 1
        {
            if brandTagIntArray.contains(sender.tag)
            {
                brandTagIntArray.removeAll()
            }
            else
            {
                for i in 0..<brandIdArray.count
                {
                    brandTagIntArray.append(brandIdArray[i] as! Int)
                }
            }
        }
        else
        {
            if brandTagIntArray.contains(1)
            {
                if brandTagIntArray.contains(sender.tag)
                {
                    brandTagIntArray = brandTagIntArray.filter { $0 != sender.tag }
                }
                else
                {
                    brandTagIntArray.append(sender.tag)
                }
                
                brandTagIntArray = brandTagIntArray.filter { $0 != 1 }
            }
            else
            {
                if brandTagIntArray.contains(sender.tag)
                {
                    brandTagIntArray = brandTagIntArray.filter { $0 != sender.tag }
                }
                else
                {
                    brandTagIntArray.append(sender.tag)
                }
            }
        }
        
        print("BRAND TAG INT ARRAY", brandTagIntArray)
        
        for views in brandScrollView.subviews
        {
            for foundView in views.subviews
            {
                print("FOUND VIEW NAMES", foundView)
                if let imageView = foundView as? UIImageView
                {
                    if imageView.tag > 0
                    {
                        imageView.removeFromSuperview()
                    }
                }
            }
        }
        
        for views in brandScrollView.subviews
        {
            for i in 0..<brandTagIntArray.count
            {
                if views.tag == brandTagIntArray[i]
                {
                    print("VIEWS TAG", views.tag)
                    let brandSelectionImage = UIImageView()
                    brandSelectionImage.frame = CGRect(x: x, y: y, width: (2 * x), height: (2 * y))
                    brandSelectionImage.image = UIImage(named: "selectionImage")
                    brandSelectionImage.tag = sender.tag
                    views.addSubview(brandSelectionImage)
                }
                else
                {
                    
                }
            }
        }
    }
    /*{
        let brandSelectionImage = UIImageView()
        brandSelectionImage.frame = CGRect(x: x, y: y, width: (2 * x), height: (2 * y))
        brandSelectionImage.image = UIImage(named: "selectionImage")
        brandSelectionImage.tag = sender.tag
        
        if sender.tag != 1
        {
            brandTagIntArray = brandTagIntArray.filter { $0 != 1 }
            
            for views in brandScrollView.subviews
            {
                if let buttonView = views.viewWithTag(1)
                {
                    for buttonSubView in buttonView.subviews
                    {
                        if buttonSubView.tag == 1
                        {
                            buttonSubView.removeFromSuperview()
                        }
                    }
                }
            }
            
            if brandTagIntArray.isEmpty == true
            {
                brandTagIntArray.append(sender.tag)
                sender.addSubview(brandSelectionImage)
            }
            else
            {
                if brandTagIntArray.contains(sender.tag)
                {
                    if let index = brandTagIntArray.index(where: {$0 == sender.tag}) {
                        brandTagIntArray.remove(at: index)
                    }
                    
                    for views in sender.subviews
                    {
                        if let findView = views.viewWithTag(sender.tag)
                        {
                            if findView.tag == sender.tag
                            {
                                findView.removeFromSuperview()
                            }
                            else
                            {
                                print("NOT SAME VIEW")
                            }
                        }
                    }
                }
                else
                {
                    brandTagIntArray.append(sender.tag)
                    sender.addSubview(brandSelectionImage)
                }
            }
        }
        else
        {
            for views in brandScrollView.subviews
            {
                if let buttonView = views.viewWithTag(views.tag)
                {
                    for buttonSubView in buttonView.subviews
                    {
                        if buttonSubView.tag == views.tag
                        {
                            buttonSubView.removeFromSuperview()
                        }
                    }
                }
            }
            
            if brandTagIntArray.contains(sender.tag)
            {
                if let index = brandTagIntArray.index(where: {$0 == sender.tag}) {
                    brandTagIntArray.remove(at: index)
                }
                
                for views in sender.subviews
                {
                    if let findView = views.viewWithTag(sender.tag)
                    {
                        if findView.tag == sender.tag
                        {
                            findView.removeFromSuperview()
                        }
                        else
                        {
                            print("NOT SAME VIEW")
                        }
                    }
                }
            }
            else
            {
                brandTagIntArray.removeAll()
                
                brandTagIntArray.append(sender.tag)
                sender.addSubview(brandSelectionImage)
            }
        }
    }*/
    
    @objc func customization1NextButtonAction(sender : UIButton)
    {
        var selectedSeasonNameArray = [String]()
        var selectedIndustryNameArray = [String]()
        var selectedBrandNameArray = [String]()
        
        print("selectedSeasonNameArray", seasonalTagIntArray)
        
        let custom2Screen = Customization2ViewController()
        
        if seasonalTagIntArray.count != 0
        {
            if seasonalTagIntArray.contains(1)
            {
                selectedSeasonNameArray.append("All Season")
            }
            else
            {
                for i in 0..<seasonalIdArray.count
                {
                    for j in 0..<seasonalTagIntArray.count
                    {
                        if let id = seasonalIdArray[i] as? Int
                        {
                            if id == seasonalTagIntArray[j]
                            {
                                if let language = UserDefaults.standard.value(forKey: "language") as? String
                                {
                                    if language == "en"
                                    {
                                        selectedSeasonNameArray.append(seasonalNameEnglishArray[i] as! String)
                                    }
                                    else if language == "ar"
                                    {
                                        selectedSeasonNameArray.append(seasonalNameArabicArray[i] as! String)
                                    }
                                }
                                else
                                {
                                    selectedSeasonNameArray.append(seasonalNameEnglishArray[i] as! String)
                                }
                            }
                        }
                    }
                }
            }
            
            UserDefaults.standard.set(selectedSeasonNameArray, forKey: "season")
        }
        else
        {
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    UserDefaults.standard.set("All Season", forKey: "season")
                }
                else if language == "ar"
                {
                    UserDefaults.standard.set("كل فصل", forKey: "season")
                }
            }
            else
            {
                UserDefaults.standard.set("All Season", forKey: "season")
            }
        }
        
        if industryTagIntArray.count != 0
        {
            if industryTagIntArray.contains(1)
            {
                selectedIndustryNameArray.append("All Industry")
            }
            else
            {
                for i in 0..<industryIdArray.count
                {
                    for j in 0..<industryTagIntArray.count
                    {
                        if let id = industryIdArray[i] as? Int
                        {
                            if id == industryTagIntArray[j]
                            {
                                if let language = UserDefaults.standard.value(forKey: "language") as? String
                                {
                                    if language == "en"
                                    {
                                        selectedIndustryNameArray.append(industryNameEnglishArray[i] as! String)
                                    }
                                    else if language == "ar"
                                    {
                                        selectedIndustryNameArray.append(industryNameArabicArray[i] as! String)
                                    }
                                }
                                else
                                {
                                    selectedIndustryNameArray.append(industryNameEnglishArray[i] as! String)
                                }
                            }
                        }
                    }
                }
            }
            
            UserDefaults.standard.set(selectedIndustryNameArray, forKey: "industry")
        }
        else
        {
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    UserDefaults.standard.set("All Industry", forKey: "industry")
                }
                else if language == "ar"
                {
                    UserDefaults.standard.set("كل الصناعة", forKey: "industry")
                }
            }
            else
            {
                UserDefaults.standard.set("All Industry", forKey: "industry")
            }
        }
        
        if brandTagIntArray.count != 0
        {
            if brandTagIntArray.contains(1)
            {
                selectedBrandNameArray.append("All Brand")
            }
            else
            {
                for i in 0..<brandIdArray.count
                {
                    for j in 0..<brandTagIntArray.count
                    {
                        if let id = brandIdArray[i] as? Int
                        {
                            if id == brandTagIntArray[j]
                            {
                                if let language = UserDefaults.standard.value(forKey: "language") as? String
                                {
                                    if language == "en"
                                    {
                                        selectedBrandNameArray.append(brandNameEnglishArray[i] as! String)
                                    }
                                    else if language == "ar"
                                    {
                                        selectedBrandNameArray.append(brandNameArabicArray[i] as! String)
                                    }
                                }
                                else
                                {
                                    selectedBrandNameArray.append(brandNameEnglishArray[i] as! String)
                                }
                            }
                        }
                    }
                }
            }
            
            UserDefaults.standard.set(selectedBrandNameArray, forKey: "brand")
        }
        else
        {
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    UserDefaults.standard.set("All Brand", forKey: "brand")
                }
                else if language == "ar"
                {
                    UserDefaults.standard.set("جميع العلامات التجارية", forKey: "brand")
                }
            }
            else
            {
                UserDefaults.standard.set("All Brand", forKey: "brand")
            }
        }
        
        if brandTagIntArray.count == 0
        {
            custom2Screen.brandArray.append(1)
        }
        else
        {
            for i in 0..<brandTagIntArray.count
            {
                if i == 0
                {
                    custom2Screen.brandArray.append((brandTagIntArray[i]))
                }
                else
                {
                    custom2Screen.brandArray.append((brandTagIntArray[i]))
                }
            }
            
        }
        self.navigationController?.pushViewController(custom2Screen, animated: true)
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
