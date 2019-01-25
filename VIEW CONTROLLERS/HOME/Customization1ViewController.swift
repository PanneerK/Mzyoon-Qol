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
    
    //CUSTOMIZATION 1 PAREMETERS
    let customization1View = UIView()
    
    var seasonalNameArray = NSArray()
    var seasonalIdArray = NSArray()
    var seasonalImageArray = NSArray()
    var convertedSeasonalImageArray = [UIImage]()
    
    var industryNameArray = NSArray()
    var industryIdArray = NSArray()
    var industryImageArray = NSArray()
    var convertedIndustryImageArray = [UIImage]()
    
    var brandNameArray = NSArray()
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
    
    override func viewDidLoad()
    {
        navigationBar.isHidden = true
//        self.tab1Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        selectedButton(tag: 0)

        
        self.serviceCallFunction(originIdArray: [1], seasonIdArray: [1])
        updateId = 0
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func serviceCallFunction(originIdArray : [Int], seasonIdArray : [Int])
    {
        print("SERVICE CALL", originIdArray, seasonIdArray)
        self.serviceCall.API_Customization1(originId: originIdArray, seasonId: seasonIdArray , delegate: self)
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
       // ErrorStr = "Default Error"
        PageNumStr = "Customization1ViewController"
        MethodName = "GetCustomization1"
        
        print("UUID", UIDevice.current.identifierForVendor?.uuidString as Any)
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
    }
    
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("CUSTOMIZATION 1", errorMessage)
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
        let ResponseMsg = custom1.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            print("BRAND NAME ARRAY BEFORE", brandNameArray.count)
            brandNameArray = clearBrandNameArray
            print("BRAND NAME ARRAY AFTER", brandNameArray.count)
            
            brandIdArray = clearBrandIdArray
            brandImageArray = clearBrandImageArray
            
            let Result = custom1.object(forKey: "Result") as! NSDictionary
            
            let materialBrand = Result.object(forKey: "materialBrand") as! NSArray
            let BrandInArabic = materialBrand.value(forKey: "BrandInArabic") as! NSArray
            brandNameArray = materialBrand.value(forKey: "BrandInEnglish") as! NSArray
            brandIdArray = materialBrand.value(forKey: "Id") as! NSArray
            brandImageArray = materialBrand.value(forKey: "Image") as! NSArray
            
            /*for i in 0..<brandImageArray.count
            {
                if let imageName = brandImageArray[i] as? String
                {
                    let api = "http://appsapi.mzyoon.com/images/Brands/\(imageName)"
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
            let PlaceInArabic = placeofIndustrys.value(forKey: "PlaceInArabic") as! NSArray
            industryNameArray = placeofIndustrys.value(forKey: "PlaceInEnglish") as! NSArray
            industryIdArray = placeofIndustrys.value(forKey: "Id") as! NSArray
            industryImageArray = placeofIndustrys.value(forKey: "Image") as! NSArray
            
            /*for i in 0..<industryImageArray.count
            {
                if let imageName = industryImageArray[i] as? String
                {
                    let api = "http://appsapi.mzyoon.com/images/PlaceOfIndustry/\(imageName)"
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
            let SeasonInArabic = seasons.value(forKey: "SeasonInArabic") as! NSArray
            seasonalNameArray = seasons.value(forKey: "SeasonInEnglish") as! NSArray
            seasonalIdArray = seasons.value(forKey: "Id") as! NSArray
            seasonalImageArray = seasons.value(forKey: "Image") as! NSArray
            
            /*for i in 0..<seasonalImageArray.count
            {
                if let imageName = seasonalImageArray[i] as? String
                {
                    let api = "http://appsapi.mzyoon.com/images/Seasons/\(imageName)"
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
            
            print("FINAL BRAND NAME ARRAY", brandNameArray)
            
            if updateId == 0
            {
                customization1Content()
            }
            else if updateId == 1
            {
                industryContents()
            }
            else if updateId == 2
            {
                brandContents()
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
    
    func customization1Content()
    {
        customization1View.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        customization1View.backgroundColor = UIColor.white
//        view.addSubview(customization1View)
        
        let customization1NavigationBar = UIView()
        customization1NavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        customization1NavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(customization1NavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 5
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        customization1NavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: customization1NavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "CUSTOMIZATION-1"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        customization1NavigationBar.addSubview(navigationTitle)
        
        self.seasonalContents()
        self.industryContents()
        self.brandContents()
        
        let customization1NextButton = UIButton()
        customization1NextButton.frame = CGRect(x: view.frame.width - (5 * x), y: brandScrollView.frame.maxY, width: (4 * x), height: (4 * y))
        customization1NextButton.setImage(UIImage(named: "rightArrow"), for: .normal)
        customization1NextButton.addTarget(self, action: #selector(self.customization1NextButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(customization1NextButton)
    }
    
    func seasonalContents()
    {
        let seasonTitleLabel = UILabel()
        seasonTitleLabel.frame = CGRect(x: ((view.frame.width - (12 * x)) / 2), y: (8 * y), width: (12 * x), height: (3 * y))
        seasonTitleLabel.layer.borderWidth = 1
        seasonTitleLabel.layer.masksToBounds = true
        seasonTitleLabel.backgroundColor = UIColor.white
        seasonTitleLabel.text = "SEASONAL"
        seasonTitleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        seasonTitleLabel.textAlignment = .center
        view.addSubview(seasonTitleLabel)
        
        seasonalScrollView.frame = CGRect(x: (3 * x), y: seasonTitleLabel.frame.maxY, width: view.frame.width, height: (12 * y))
        view.addSubview(seasonalScrollView)
        
        var x1:CGFloat = (2 * x)
        
        for views in seasonalScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        for i in 0..<seasonalNameArray.count
        {
            let seasonalButton = UIButton()
            seasonalButton.frame = CGRect(x: x1, y: y, width: (12 * x), height: (10 * y))
            seasonalButton.tag = seasonalIdArray[i] as! Int
            seasonalButton.addTarget(self, action: #selector(self.seasonalButtonAction(sender:)), for: .touchUpInside)
            seasonalScrollView.addSubview(seasonalButton)
            
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: 0, y: 0, width: seasonalButton.frame.width, height: seasonalButton.frame.height - (2 * y))
            //            buttonImage.image = convertedSeasonalImageArray[i]
            if let imageName = seasonalImageArray[i] as? String
            {
                let api = "http://appsapi.mzyoon.com/images/Seasons/\(imageName)"
                let apiurl = URL(string: api)
                print("SEASONAL API", apiurl!)
                buttonImage.dowloadFromServer(url: apiurl!)
                
                self.stopActivity()
            }
            buttonImage.tag = -1
            seasonalButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 0, y: seasonalButton.frame.height - (2 * y), width: seasonalButton.frame.width, height: (2 * y))
            buttonTitle.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.text = seasonalNameArray[i] as? String
            buttonTitle.textColor = UIColor.white
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 10)
            buttonTitle.tag = -1
            seasonalButton.addSubview(buttonTitle)
            
            x1 = seasonalButton.frame.maxX + (2 * x)
        }
        
        seasonalScrollView.contentSize.width = x1 + (3 * x)
    }
    
    func industryContents()
    {
        let industryTitleLabel = UILabel()
        industryTitleLabel.frame = CGRect(x: ((view.frame.width - (20 * x)) / 2), y: seasonalScrollView.frame.maxY + (2 * y), width: (20 * x), height: (3 * y))
        industryTitleLabel.layer.borderWidth = 1
        industryTitleLabel.layer.masksToBounds = true
        industryTitleLabel.backgroundColor = UIColor.white
        industryTitleLabel.text = "PLACE OF INDUSTRY"
        industryTitleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        industryTitleLabel.textAlignment = .center
        view.addSubview(industryTitleLabel)
        
        industryScrollView.frame = CGRect(x: (3 * x), y: industryTitleLabel.frame.maxY, width: view.frame.width, height: (12 * y))
        view.addSubview(industryScrollView)
        
        for views in industryScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        var x3:CGFloat = (2 * x)
        for i in 0..<industryNameArray.count
        {
            let industryButton = UIButton()
            industryButton.frame = CGRect(x: x3, y: y, width: (12 * x), height: (10 * y))
            industryButton.tag = industryIdArray[i] as! Int
            industryButton.addTarget(self, action: #selector(self.industryButtonAction(sender:)), for: .touchUpInside)
            industryScrollView.addSubview(industryButton)
            
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: 0, y: 0, width: industryButton.frame.width, height: industryButton.frame.height - (2 * y))
            //            buttonImage.image = convertedIndustryImageArray[i]
            if let imageName = industryImageArray[i] as? String
            {
                let api = "http://appsapi.mzyoon.com/images/PlaceOfIndustry/\(imageName)"
                let apiurl = URL(string: api)
                if apiurl == nil
                {
                    
                }
                else
                {
                    buttonImage.dowloadFromServer(url: apiurl!)
                }
            }
            buttonImage.tag = -1
            industryButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 0, y: industryButton.frame.height - (2 * y), width: industryButton.frame.width, height: (2 * y))
            buttonTitle.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.text = industryNameArray[i] as! String
            buttonTitle.textColor = UIColor.white
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 10)
            buttonTitle.tag = -1
            industryButton.addSubview(buttonTitle)
            
            x3 = industryButton.frame.maxX + (2 * x)
        }
        
        industryScrollView.contentSize.width = x3 + (3 * x)
    }
    
    func brandContents()
    {
        let brandTitleLabel = UILabel()
        brandTitleLabel.frame = CGRect(x: ((view.frame.width - (10 * x)) / 2), y: industryScrollView.frame.maxY + (2 * y), width: (10 * x), height: (3 * y))
        brandTitleLabel.layer.borderWidth = 1
        brandTitleLabel.layer.masksToBounds = true
        brandTitleLabel.backgroundColor = UIColor.white
        brandTitleLabel.text = "BRANDS"
        brandTitleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        brandTitleLabel.textAlignment = .center
        view.addSubview(brandTitleLabel)
        
        brandScrollView.frame = CGRect(x: (3 * x), y: brandTitleLabel.frame.maxY, width: view.frame.width, height: (12 * y))
        view.addSubview(brandScrollView)
        
        for views in brandScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        var x2:CGFloat = (2 * x)
        for i in 0..<brandNameArray.count
        {
            let brandButton = UIButton()
            brandButton.frame = CGRect(x: x2, y: y, width: (12 * x), height: (10 * y))
            brandButton.tag = brandIdArray[i] as! Int
            brandButton.addTarget(self, action: #selector(self.brandButtonAction(sender:)), for: .touchUpInside)
            brandScrollView.addSubview(brandButton)
            
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: 0, y: 0, width: brandButton.frame.width, height: brandButton.frame.height - (2 * y))
            //            buttonImage.image = convertedBrandImageArray[i]
            if let imageName = brandImageArray[i] as? String
            {
                let api = "http://appsapi.mzyoon.com/images/Brands/\(imageName)"
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
            buttonTitle.text = brandNameArray[i] as! String
            buttonTitle.textColor = UIColor.white
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 10)
            buttonTitle.tag = -1
            brandButton.addSubview(buttonTitle)
            
            x2 = brandButton.frame.maxX + (2 * x)
        }
        
        brandScrollView.contentSize.width = x2 + (3 * x)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func seasonalButtonAction(sender : UIButton)
    {
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
                                print("FIND VIEW", findView.description)
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
            print("SEASONAL ARRAY", seasonalTagIntArray)
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
                            print("FIND VIEW", findView.description)
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
    }
    
    @objc func industryButtonAction(sender : UIButton)
    {
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
                                print("FIND VIEW", findView.description)
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
            print("INDUSTRY ARRAY", industryTagIntArray)
            
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
                            print("FIND VIEW", findView.description)
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
    }
    
    @objc func brandButtonAction(sender : UIButton)
    {
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
                                print("FIND VIEW", findView.description)
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
            print("BRAND ARRAY", brandTagIntArray)
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
                            print("FIND VIEW", findView.description)
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
    }
    
    @objc func customization1NextButtonAction(sender : UIButton)
    {
        print("SEASONAL", seasonalTagIntArray)
        print("INDUSTRY", industryTagIntArray)
        print("BRAND", brandTagIntArray)
        
        let custom2Screen = Customization2ViewController()
        if brandTagIntArray.count == 0
        {
            custom2Screen.brandArray = "1"
        }
        else
        {
            for i in 0..<brandTagIntArray.count
            {
                if i == 0
                {
                    custom2Screen.brandArray.append("\(brandTagIntArray[i])")
                }
                else
                {
                    custom2Screen.brandArray.append(",\(brandTagIntArray[i])")
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
