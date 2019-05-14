//
//  OrderSummaryViewController.swift
//  Mzyoon
//
//  Created by QOL on 19/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class OrderSummaryViewController: CommonViewController,ServerAPIDelegate
{
    
    let randomInt = Int.random(in: 10265..<10365)
    
    let dressTypeHeadingLabel = UILabel()

    let customization1HeadingLabel = UILabel()
    let customizationHeadingLabel = UILabel()
    let premiumServicesHeadingLabel = UILabel()
    let tailorListHeadingLabel = UILabel()
    let noteLabel = UILabel()


    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    let serviceCall = ServerAPI()
    
    var customization3 = NSDictionary()
    var selectedTailors = [String]()
    
    let orderSummaryScrollView = UIScrollView()
    let submitButton = UIButton()
    
    var yPos = CGFloat()
    
    let fileAccessing = FileAccess()
    let orderCustom = OrderCustomizationToJson()

    var getMaterialImageNameArray = [String]()
    var getReferenceImageNameArray = [String]()
    
    //INSERT ORDER SUMMARY INPUT PARAMETERS
    var userId = Int()
    var dressId = Int()
    var addressId = Int()
    var patternId = Int()
    var orderId = Int()
    var measurementType = Int()
    var deliveryTypeId = Int()
    var measurementIdInt = Int()

    var measurementBy = String()
    var measurementName = String()
    var measurementId = NSArray()
    var measurementValues = [Double]()
    var units = "CM"
    var orderCustomization = [[String: Int]]()
    var tailorId = [[String: Any]]()
    
    //ACTIVITY CONTROLLER
    let spinnerBackView = UIView()
    let spinner = UIActivityIndicatorView()
    
    var customKeys = [String]()
    var customvalues = [String]()
    var customAttImage = NSArray()
    
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
                self.navigationTitle.text = "ORDER SUMMARY"
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
            self.navigationTitle.text = "ORDER SUMMARY"
            self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        self.serviceCall.API_Customization3(DressTypeId: "\(Variables.sharedManager.dressSubTypeId)", delegate: self)
                
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of seconds
//            // Your code with delay
//            self.orderSummaryContent()
//        }
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    func API_CALLBACK_Customization3(custom3: NSDictionary)
    {
        let ResponseMsg = custom3.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = custom3.object(forKey: "Result") as! NSDictionary
            
            let CustomizationImages = Result.object(forKey: "CustomizationImages") as! NSArray
            
            if CustomizationImages.count != 0
            {
                let CustomizationAttributes = Result.object(forKey: "CustomizationAttributes") as! NSArray
                
                customAttImage = CustomizationAttributes.value(forKey: "AttributeImage") as! NSArray
                print("ATTRIBTE IMAGES", customAttImage)
                
                let AttributeNameInEnglish = CustomizationAttributes.value(forKey: "AttributeNameInEnglish") as! NSArray
                print("AttributeNameInEnglish", AttributeNameInEnglish)
                
                let AttributeNameinArabic = CustomizationAttributes.value(forKey: "AttributeNameinArabic") as! NSArray
                print("AttributeNameinArabic", AttributeNameinArabic)
                
//                print("WELCOME HAND", UserDefaults.standard.value(forKey: "custom3"))
                
                var selectedCustomStringArray = [String : String]()
                
                selectedCustomStringArray = UserDefaults.standard.value(forKey: "custom3") as! [String : String]
                print("selectedCustomStringArray", selectedCustomStringArray)
                
                if let language = UserDefaults.standard.value(forKey: "language") as? String
                {
                    if language == "en"
                    {
                        for i in 0..<AttributeNameInEnglish.count
                        {
                            if let attName = AttributeNameInEnglish[i] as? String
                            {
                                for (keys, values) in selectedCustomStringArray
                                {
                                    if keys == attName
                                    {
                                        print("KEYS - \(keys), VALUES - \(values)")
                                        customKeys.append(keys)
                                        customvalues.append(values)
                                    }
                                }
                            }
                        }
                    }
                    else if language == "ar"
                    {
                        for i in 0..<AttributeNameinArabic.count
                        {
                            if let attName = AttributeNameinArabic[i] as? String
                            {
                                for (keys, values) in selectedCustomStringArray
                                {
                                    if keys == attName
                                    {
                                        print("KEYS - \(keys), VALUES - \(values)")
                                        customKeys.append(keys)
                                        customvalues.append(values)
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    for i in 0..<AttributeNameInEnglish.count
                    {
                        if let attName = AttributeNameInEnglish[i] as? String
                        {
                            for (keys, values) in selectedCustomStringArray
                            {
                                if keys == attName
                                {
                                    print("KEYS - \(keys), VALUES - \(values)")
                                    customKeys.append(keys)
                                    customvalues.append(values)
                                }
                            }
                        }
                    }
                }
            }
            
            self.orderSummaryContent()
        }
    }
    
    func spinnerOn()
    {
        spinnerBackView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        spinnerBackView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(spinnerBackView)
        
        self.view.bringSubviewToFront(spinnerBackView)
        
        spinner.frame = CGRect(x: ((activeView.frame.width - (5 * x)) / 2), y: ((activeView.frame.height - (5 * y)) / 2), width: (5 * x), height: (5 * y))
        spinner.color = UIColor.white
        spinner.style = .whiteLarge
        spinner.startAnimating()
        spinnerBackView.addSubview(spinner)
    }
    
    func spinnerOff()
    {
        spinnerBackView.removeFromSuperview()
        spinner.stopAnimating()
    }
    
    func changeViewToEnglishInSelf()
    {
        orderSummaryScrollView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        dressTypeHeadingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        dressTypeHeadingLabel.text = "DRESS TYPE"
        dressTypeHeadingLabel.textAlignment = .left
        
        customization1HeadingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        customization1HeadingLabel.text = "CUSTOMIZATION 1 AND CUSTOMIZATION 2"
        customization1HeadingLabel.textAlignment = .left
        
        customizationHeadingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        customizationHeadingLabel.text = "CUSTOMIZATION 3"
        customizationHeadingLabel.textAlignment = .left
        
        premiumServicesHeadingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        premiumServicesHeadingLabel.text = "PREMIUM SERVICES"
        premiumServicesHeadingLabel.textAlignment = .left
        
        tailorListHeadingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        tailorListHeadingLabel.text = "TOTAL NUMBER OF TAILORS - \(selectedTailors.count)"
        tailorListHeadingLabel.textAlignment = .left
        
        submitButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        noteLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        noteLabel.text = "NOTE : The price, services and courier will add to order total amount"

    }
    
    func changeViewToArabicInSelf()
    {
        orderSummaryScrollView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        dressTypeHeadingLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        dressTypeHeadingLabel.text = "نوع اللباس"
        dressTypeHeadingLabel.textAlignment = .right
        
        customization1HeadingLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        customization1HeadingLabel.text = "التخصيص 1 والتخصيص 2"
        customization1HeadingLabel.textAlignment = .right
        
        customizationHeadingLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        customizationHeadingLabel.text = "التخصيص 3"
        customizationHeadingLabel.textAlignment = .right
        
        premiumServicesHeadingLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        premiumServicesHeadingLabel.text = "خدمات مميزة"
        premiumServicesHeadingLabel.textAlignment = .right
        
        tailorListHeadingLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        tailorListHeadingLabel.text = "مجموع عدد الخياطين - \(selectedTailors.count)"
        tailorListHeadingLabel.textAlignment = .right
        
        submitButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        noteLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        noteLabel.text = "ملاحظة: سيضيف السعر والخدمات والبريد السريع المبلغ الإجمالي للطلب"
    }
    
    func orderSummaryContent()
    {
        self.stopActivity()
    
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                pageBar.image = UIImage(named: "SummaryBar")
            }
            else if language == "ar"
            {
                pageBar.image = UIImage(named: "summaryArabicHintImage")
            }
        }
        else
        {
            pageBar.image = UIImage(named: "SummaryBar")
        }

        orderSummaryScrollView.frame = CGRect(x: x, y: pageBar.frame.maxY + y, width: view.frame.width - (2 * x), height: view.frame.height - (navigationBar.frame.height + pageBar.frame.height + tabBar.frame.height + (2 * y)))
        orderSummaryScrollView.backgroundColor = UIColor.clear
        view.addSubview(orderSummaryScrollView)
        
        self.view.bringSubviewToFront(slideMenuButton)
        
        dressTypeHeadingLabel.frame = CGRect(x: 0, y: y, width: orderSummaryScrollView.frame.width, height: (3 * y))
        dressTypeHeadingLabel.text = "DRESS TYPE"
        dressTypeHeadingLabel.textColor = UIColor.black
        dressTypeHeadingLabel.textAlignment = .left
        dressTypeHeadingLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        orderSummaryScrollView.addSubview(dressTypeHeadingLabel)
        
        let dressTypeView = UIView()
        dressTypeView.frame = CGRect(x: 0, y: dressTypeHeadingLabel.frame.maxY, width: orderSummaryScrollView.frame.width, height: (15 * x))
        dressTypeView.backgroundColor = UIColor.white
        orderSummaryScrollView.addSubview(dressTypeView)
        
        let dressTypeArray = ["Gender", "Dress Type", "Dress Sub Type"]
        let dressTypeImageArray = ["Gender-3", "Dress_types", "Dress_subtypes"]
        var getDressTypeArray = [String]()
        let dressTypeArabicArray = ["جنس", "نوع الفستان", "اللباس النوع الفرعي"]
                
        getDressTypeArray.append(Variables.sharedManager.genderType)
        
        getDressTypeArray.append(Variables.sharedManager.dressType)
        
        getDressTypeArray.append(Variables.sharedManager.dressSubType)
        
        print("getDressTypeArray", getDressTypeArray)
        
        var y1:CGFloat = y
        
        for i in 0..<dressTypeArray.count
        {
            let dressSubViews = UIView()
            dressSubViews.frame = CGRect(x: x, y: y1, width: dressTypeView.frame.width - (2 * x), height: (4 * y))
            dressSubViews.layer.cornerRadius = 10
            dressSubViews.backgroundColor = UIColor(red: 0.0471, green: 0.1725, blue: 0.4588, alpha: 1.0)
            dressSubViews.layer.masksToBounds = true
            dressTypeView.addSubview(dressSubViews)
            
            let dressTypeImages = UIImageView()
            dressTypeImages.frame = CGRect(x: (x / 2), y: y / 2, width: (3 * x), height: (3 * y))
            dressTypeImages.layer.cornerRadius = dressTypeImages.frame.height / 2
            dressTypeImages.image = UIImage(named: dressTypeImageArray[i])
            dressSubViews.addSubview(dressTypeImages)
            
            let dressTypeLabels = UILabel()
            dressTypeLabels.frame = CGRect(x: dressTypeImages.frame.maxX + (x / 2), y: y / 2, width: (13 * x), height: (3 * y))
            dressTypeLabels.backgroundColor = UIColor.clear
            dressTypeLabels.text = dressTypeArray[i]
            dressTypeLabels.textAlignment = .left
            dressTypeLabels.textColor = UIColor.white
            dressTypeLabels.font = UIFont(name: "Avenir-Regular", size: x)
            dressTypeLabels.font = dressTypeLabels.font.withSize(1.5 * x)
            dressSubViews.addSubview(dressTypeLabels)
            
            let lineLabel = UILabel()
            lineLabel.frame = CGRect(x: dressTypeLabels.frame.maxX, y: ((dressSubViews.frame.height - 1) / 2), width: (x / 3), height: 1)
            lineLabel.backgroundColor = UIColor.white
            dressSubViews.addSubview(lineLabel)
            
            let getDressTypeLabels = UILabel()
            getDressTypeLabels.frame = CGRect(x: lineLabel.frame.maxX + (x / 2), y: (y / 2), width: (11 * x), height: (3 * y))
            getDressTypeLabels.backgroundColor = UIColor.clear
            getDressTypeLabels.text = getDressTypeArray[i]
            getDressTypeLabels.textAlignment = .left
            getDressTypeLabels.textColor = UIColor.white
            getDressTypeLabels.font = UIFont(name: "Avenir-Regular", size: x)
            getDressTypeLabels.font = getDressTypeLabels.font.withSize(1.5 * x)
            getDressTypeLabels.adjustsFontSizeToFitWidth = true
            dressSubViews.addSubview(getDressTypeLabels)
            
            y1 = dressSubViews.frame.maxY + (y / 2)
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    dressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    dressTypeLabels.text = dressTypeArray[i]
                    dressTypeLabels.textAlignment = .left
                    
                    getDressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    getDressTypeLabels.text = getDressTypeArray[i]
                    getDressTypeLabels.textAlignment = .left
                }
                else if language == "ar"
                {
                    dressTypeLabels.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    dressTypeLabels.text = dressTypeArabicArray[i]
                    dressTypeLabels.textAlignment = .right
                    
                    getDressTypeLabels.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    getDressTypeLabels.text = getDressTypeArray[i]
                    getDressTypeLabels.textAlignment = .right
                }
            }
            else
            {
                dressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                dressTypeLabels.text = dressTypeArray[i]
                dressTypeLabels.textAlignment = .left
                
                getDressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                getDressTypeLabels.text = getDressTypeArray[i]
                getDressTypeLabels.textAlignment = .left
            }
        }
        
        yPos = dressTypeView.frame.maxY + y
        
        if Variables.sharedManager.orderTypeId == 3
        {
            custom1AndCustom2Content()
        }
        else
        {
            
        }
        
        var yaxis:CGFloat = yPos
        
        if let customValue = UserDefaults.standard.value(forKey: "custom3Response") as? Int
        {
            if customValue == 0
            {
                customizationHeadingLabel.frame = CGRect(x: 0, y: yPos, width: orderSummaryScrollView.frame.width, height: (3 * y))
                customizationHeadingLabel.text = "CUSTOMIZATION 3"
                customizationHeadingLabel.textColor = UIColor.black
                customizationHeadingLabel.textAlignment = .left
                customizationHeadingLabel.font = UIFont(name: "Avenir-Regular", size: 10)
                orderSummaryScrollView.addSubview(customizationHeadingLabel)
                
                if let custom3 = UserDefaults.standard.value(forKey: "custom3") as? NSDictionary
                {
                    customization3 = custom3
                }
                
                
                let customizationView = UIScrollView()
                customizationView.frame = CGRect(x: 0, y: customizationHeadingLabel.frame.maxY, width: orderSummaryScrollView.frame.width, height: (20 * y))
                customizationView.backgroundColor = UIColor.white
                orderSummaryScrollView.addSubview(customizationView)
                
                print("CUSTOM 3 SELECTED", customization3.count)
                
                for (keys, values) in customization3
                {
                    customKeys.append(keys as! String)
                    customvalues.append(values as! String)
                }
                
                let customizationArray = ["Lapels - ", "Buttons - ", "Pockets - ", "Vents - "]
                let customizationImageArray = ["Lapels", "Buttons", "Pockets", "Vents"]
                var y2:CGFloat = y
                
                print("CUSTOM KEYS AND CUSTOM VALUES", customKeys, customvalues, customization3)
                
                var x1:CGFloat = x
                
                for i in 0..<customization3.count
                {
                    let dressTypeImages = UIImageView()
                    dressTypeImages.frame = CGRect(x: x1, y: y, width: customizationView.frame.height - (6 * y), height: customizationView.frame.height - (6 * y))
                    dressTypeImages.layer.cornerRadius = dressTypeImages.frame.height / 2
                    if let imageName = customAttImage[i] as? String
                    {
                        let urlString = serviceCall.baseURL
                        let api = "\(urlString)/images/Customazation3/\(imageName)"
                        let apiurl = URL(string: api)
                        print("GET API", apiurl)
                        if apiurl != nil
                        {
                            dressTypeImages.dowloadFromServer(url: apiurl!)
                        }
                    }
                    customizationView.addSubview(dressTypeImages)
                    
                    let textView = UIView()
                    textView.frame = CGRect(x: dressTypeImages.frame.minX, y: dressTypeImages.frame.maxY, width: dressTypeImages.frame.width, height: (5 * y))
                    textView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
                    customizationView.addSubview(textView)
                    
                    let dressTypeLabels = UILabel()
                    dressTypeLabels.frame = CGRect(x: 0, y: 0, width: textView.frame.width, height: (2 * y))
                    dressTypeLabels.backgroundColor = UIColor.clear
                    if customKeys.count != 0
                    {
                        dressTypeLabels.text = "\(customKeys[i])"
                    }
                    dressTypeLabels.textColor = UIColor.white
                    dressTypeLabels.textAlignment = .center
                    dressTypeLabels.font = UIFont(name: "Avenir-Regular", size: x)
                    dressTypeLabels.font = dressTypeLabels.font.withSize(1.5 * x)
                    textView.addSubview(dressTypeLabels)
                    
                    let lineLabel = UILabel()
                    lineLabel.frame = CGRect(x: 0, y: dressTypeLabels.frame.maxY, width: textView.frame.width, height: y)
                    lineLabel.backgroundColor = UIColor.clear
                    lineLabel.text = "-"
                    lineLabel.textColor = UIColor.white
                    lineLabel.textAlignment = .center
                    textView.addSubview(lineLabel)
                    
                    let getDressTypeLabels = UILabel()
                    getDressTypeLabels.frame = CGRect(x: 0, y: lineLabel.frame.maxY, width: textView.frame.width, height: (2 * y))
                    getDressTypeLabels.backgroundColor = UIColor.clear
                    getDressTypeLabels.textColor = UIColor.white
                    getDressTypeLabels.textAlignment = .center
                    
                    if customvalues.count != 0
                    {
                        getDressTypeLabels.text = customvalues[i]
                        if let strings = customvalues[i] as? String
                        {
                            if strings.count > 15
                            {
                                getDressTypeLabels.font = UIFont(name: "Avenir-Regular", size: x)
                                getDressTypeLabels.font = getDressTypeLabels.font.withSize(x)
                                getDressTypeLabels.numberOfLines = 2
                            }
                            else
                            {
                                getDressTypeLabels.font = UIFont(name: "Avenir-Regular", size: x)
                                getDressTypeLabels.font = getDressTypeLabels.font.withSize(1.5 * x)
                            }
                        }
                    }
                    
                    getDressTypeLabels.adjustsFontSizeToFitWidth = true
                    textView.addSubview(getDressTypeLabels)
                    
                    x1 = dressTypeImages.frame.maxX + (2 * x)
                }
                
                customizationView.contentSize.width = x1 + (2 * x)
                
                /*for i in 0..<customization3.count
                {
                    let dressSubViews = UIView()
                    dressSubViews.frame = CGRect(x: x, y: y2, width: customizationView.frame.width - (2 * x), height: (4 * y))
                    dressSubViews.layer.cornerRadius = 10
                    dressSubViews.backgroundColor = UIColor(red: 0.0471, green: 0.1725, blue: 0.4588, alpha: 1.0)
                    dressSubViews.layer.masksToBounds = true
                    customizationView.addSubview(dressSubViews)
                    
                    let dressTypeImages = UIImageView()
                    dressTypeImages.frame = CGRect(x: (x / 2), y: y / 2, width: (3 * x), height: (3 * y))
                    dressTypeImages.layer.cornerRadius = dressTypeImages.frame.height / 2
                    //            dressTypeImages.image = UIImage(named: customizationImageArray[i])
                    if let imageName = customAttImage[i] as? String
                    {
                        let urlString = serviceCall.baseURL
                        let api = "\(urlString)/images/Customazation3/\(imageName)"
                        let apiurl = URL(string: api)
                        print("GET API", apiurl)
                        if apiurl != nil
                        {
                            dressTypeImages.dowloadFromServer(url: apiurl!)
                        }
                    }
                    dressSubViews.addSubview(dressTypeImages)
                    
                    let dressTypeLabels = UILabel()
                    dressTypeLabels.frame = CGRect(x: dressTypeImages.frame.maxX + (x / 2), y: y / 2, width: (13 * x), height: (3 * y))
                    dressTypeLabels.backgroundColor = UIColor.clear
                    if customKeys.count != 0
                    {
                        dressTypeLabels.text = "\(customKeys[i])" + "-"
                    }
                    dressTypeLabels.textColor = UIColor.white
                    dressTypeLabels.textAlignment = .left
                    dressTypeLabels.font = UIFont(name: "Avenir-Regular", size: x)
                    dressTypeLabels.font = dressTypeLabels.font.withSize(1.5 * x)
                    dressSubViews.addSubview(dressTypeLabels)
                    
                    let lineLabel = UILabel()
                    lineLabel.frame = CGRect(x: dressTypeLabels.frame.maxX, y: ((dressSubViews.frame.height - 1) / 2), width: (x / 3), height: 1)
                    lineLabel.backgroundColor = UIColor.white
                    dressSubViews.addSubview(lineLabel)
                    
                    let getDressTypeLabels = UILabel()
                    getDressTypeLabels.frame = CGRect(x: lineLabel.frame.maxX + (x / 2), y: (y / 2), width: (11 * x), height: (3 * y))
                    getDressTypeLabels.backgroundColor = UIColor.clear
                    getDressTypeLabels.textColor = UIColor.white
                    getDressTypeLabels.textAlignment = .left
                    
                    if customvalues.count != 0
                    {
                        getDressTypeLabels.text = customvalues[i]
                        if let strings = customvalues[i] as? String
                        {
                            if strings.count > 15
                            {
                                getDressTypeLabels.font = UIFont(name: "Avenir-Regular", size: x)
                                getDressTypeLabels.font = getDressTypeLabels.font.withSize(x)
                                getDressTypeLabels.numberOfLines = 2
                            }
                            else
                            {
                                getDressTypeLabels.font = UIFont(name: "Avenir-Regular", size: x)
                                getDressTypeLabels.font = getDressTypeLabels.font.withSize(1.5 * x)
                            }
                        }
                    }
                    
                    getDressTypeLabels.adjustsFontSizeToFitWidth = true
                    dressSubViews.addSubview(getDressTypeLabels)
                    
                    y2 = dressSubViews.frame.maxY + (y / 2)
                    
                    if let language = UserDefaults.standard.value(forKey: "language") as? String
                    {
                        if language == "en"
                        {
                            dressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                            if customKeys.count != 0
                            {
                                dressTypeLabels.text = "\(customKeys[i])" + "-"
                            }
                            dressTypeLabels.textAlignment = .left
                            
                            getDressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                            if customvalues.count != 0
                            {
                                getDressTypeLabels.text = customvalues[i]
                            }
                            getDressTypeLabels.textAlignment = .left
                        }
                        else if language == "ar"
                        {
                            dressTypeLabels.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                            if customKeys.count != 0
                            {
                                dressTypeLabels.text = "\(customKeys[i])" + "-"
                            }
                            dressTypeLabels.textAlignment = .right
                            
                            getDressTypeLabels.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                            if customvalues.count != 0
                            {
                                getDressTypeLabels.text = customvalues[i]
                            }
                            getDressTypeLabels.textAlignment = .right
                        }
                    }
                    else
                    {
                        dressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        if customKeys.count != 0
                        {
                            dressTypeLabels.text = "\(customKeys[i])" + "-"
                        }
                        dressTypeLabels.textAlignment = .left
                        
                        getDressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        if customvalues.count != 0
                        {
                            getDressTypeLabels.text = customvalues[i]
                        }
                        getDressTypeLabels.textAlignment = .left
                    }
                }*/
                
                yaxis = customizationView.frame.maxY + y
            }
        }
        
        premiumServicesHeadingLabel.frame = CGRect(x: 0, y: yaxis, width: orderSummaryScrollView.frame.width, height: (3 * y))
        premiumServicesHeadingLabel.text = "PREMIUM SERVICES"
        premiumServicesHeadingLabel.textColor = UIColor.black
        premiumServicesHeadingLabel.textAlignment = .left
        premiumServicesHeadingLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        orderSummaryScrollView.addSubview(premiumServicesHeadingLabel)
        
        let premiumServicesView = UIView()
        premiumServicesView.frame = CGRect(x: 0, y: premiumServicesHeadingLabel.frame.maxY, width: orderSummaryScrollView.frame.width, height: (11 * x))
        premiumServicesView.backgroundColor = UIColor.white
        orderSummaryScrollView.addSubview(premiumServicesView)
        
        /*let premiumArray = ["Measurement + Service - ", "Material Delivery - ", "Urgent Stitches - ", "Additional Design - ", "Special Delivery - "]
        let premiumImagesArray = ["Measurement+Service", "material_delivery", "urgent_stitches", "Additional_design", "Special_delivery"]
        let getPremiumArray = ["50.00 AED", "70.00 AED", "150.00 AED", "20.00 AED", "30.00 AED"]*/
        
        let premiumArray = ["Measurement", "Service Type"]
        let premiumArabicArray = ["قياس", "نوع الخدمة"]
        let premiumImagesArray = ["Measurement+Service", "Special_delivery"]
        
        var y3:CGFloat = y
        
        for i in 0..<premiumArray.count
        {
            let dressSubViews = UIView()
            dressSubViews.frame = CGRect(x: x, y: y3, width: dressTypeView.frame.width - (2 * x), height: (4 * y))
            dressSubViews.layer.cornerRadius = 10
            dressSubViews.backgroundColor = UIColor(red: 0.0471, green: 0.1725, blue: 0.4588, alpha: 1.0)
            dressSubViews.layer.masksToBounds = true
            premiumServicesView.addSubview(dressSubViews)
            
            let dressTypeImages = UIImageView()
            dressTypeImages.frame = CGRect(x: (x / 2), y: y / 2, width: (3 * x), height: (3 * y))
            dressTypeImages.layer.cornerRadius = dressTypeImages.frame.height / 2
            dressTypeImages.image = UIImage(named: premiumImagesArray[i])
            dressSubViews.addSubview(dressTypeImages)
            
            let dressTypeLabels = UILabel()
            dressTypeLabels.frame = CGRect(x: dressTypeImages.frame.maxX + (x / 2), y: y / 2, width: (13 * x), height: (3 * y))
            dressTypeLabels.backgroundColor = UIColor.clear
            dressTypeLabels.text = premiumArray[i]
            dressTypeLabels.textColor = UIColor.white
            dressTypeLabels.textAlignment = .left
            dressTypeLabels.font = UIFont(name: "Avenir-Regular", size: x)
            dressTypeLabels.font = dressTypeLabels.font.withSize(1.5 * x)
            dressSubViews.addSubview(dressTypeLabels)
            
            let lineLabel = UILabel()
            lineLabel.frame = CGRect(x: dressTypeLabels.frame.maxX, y: ((dressSubViews.frame.height - 1) / 2), width: (x / 3), height: 1)
            lineLabel.backgroundColor = UIColor.white
            dressSubViews.addSubview(lineLabel)
            
            let getDressTypeLabels = UILabel()
            getDressTypeLabels.frame = CGRect(x: lineLabel.frame.maxX + (x / 2), y: (y / 2), width: (12 * x), height: (3 * y))
            getDressTypeLabels.backgroundColor = UIColor.clear
            
            print("MEASUEMENT TYPE", UserDefaults.standard.value(forKey: "measurementType"))
            
            if i == 0
            {
                if let id = UserDefaults.standard.value(forKey: "measurementType") as? Int
                {
                    if id == 1
                    {
                        if let language = UserDefaults.standard.value(forKey: "language") as? String
                        {
                            if language == "en"
                            {
                                getDressTypeLabels.text = "Manually"
                            }
                            else if language == "ar"
                            {
                                getDressTypeLabels.text = "يدويا"
                            }
                        }
                        else
                        {
                            getDressTypeLabels.text = "Manually"
                        }
                    }
                    else if id == 2
                    {
                        if let language = UserDefaults.standard.value(forKey: "language") as? String
                        {
                            if language == "en"
                            {
                                getDressTypeLabels.text = "Go to the tailor shop"
                            }
                            else if language == "ar"
                            {
                                getDressTypeLabels.text = "الذهاب إلى متجر خياط"
                            }
                        }
                        else
                        {
                            getDressTypeLabels.text = "Go to the tailor shop"
                        }
                    }
                    else if id == 3
                    {
                        if let language = UserDefaults.standard.value(forKey: "language") as? String
                        {
                            if language == "en"
                            {
                                getDressTypeLabels.text = "Tailor comes to your place"
                            }
                            else if language == "ar"
                            {
                                getDressTypeLabels.text = "خياط يأتي إلى مكانك"
                            }
                        }
                        else
                        {
                            getDressTypeLabels.text = "Tailor comes to your place"
                        }
                    }
                }
            }
            else
            {
                if let type = UserDefaults.standard.value(forKey: "serviceType") as? Int
                {
                    if type == 1
                    {
                        if let language = UserDefaults.standard.value(forKey: "language") as? String
                        {
                            if language == "en"
                            {
                                getDressTypeLabels.text = "Appointment"
                            }
                            else if language == "ar"
                            {
                                getDressTypeLabels.text = "موعد"
                            }
                        }
                        else
                        {
                            getDressTypeLabels.text = "Appointment"
                        }
                    }
                    else if type == 2
                    {
                        if let language = UserDefaults.standard.value(forKey: "language") as? String
                        {
                            if language == "en"
                            {
                                getDressTypeLabels.text = "Urgent"
                            }
                            else if language == "ar"
                            {
                                getDressTypeLabels.text = "العاجلة"
                            }
                        }
                        else
                        {
                            getDressTypeLabels.text = "Urgent"
                        }
                    }
                    else if type == 3
                    {
                        if let language = UserDefaults.standard.value(forKey: "language") as? String
                        {
                            if language == "en"
                            {
                                getDressTypeLabels.text = "Normal"
                            }
                            else if language == "ar"
                            {
                                getDressTypeLabels.text = "عادي"
                            }
                        }
                        else
                        {
                            getDressTypeLabels.text = "Normal"
                        }
                    }
                }
                else
                {
                    
                }
            }
            
            
           
            getDressTypeLabels.textColor = UIColor.white
            getDressTypeLabels.textAlignment = .left
            getDressTypeLabels.font = UIFont(name: "Avenir-Regular", size: x)
            getDressTypeLabels.font = getDressTypeLabels.font.withSize(1.5 * x)
            getDressTypeLabels.adjustsFontSizeToFitWidth = true
            getDressTypeLabels.numberOfLines = 2
            dressSubViews.addSubview(getDressTypeLabels)
            
            y3 = dressSubViews.frame.maxY + (y / 2)
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    dressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    dressTypeLabels.text = premiumArray[i]
                    dressTypeLabels.textAlignment = .left
                    
                    getDressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    getDressTypeLabels.textAlignment = .left
                }
                else if language == "ar"
                {
                    dressTypeLabels.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    dressTypeLabels.text = premiumArabicArray[i]
                    dressTypeLabels.textAlignment = .right
                    
                    getDressTypeLabels.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    getDressTypeLabels.textAlignment = .right
                }
            }
            else
            {
                dressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                dressTypeLabels.text = premiumArray[i]
                dressTypeLabels.textAlignment = .left
                
                getDressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                getDressTypeLabels.textAlignment = .left
            }
        }
        
        let noteView = UIView()
        noteView.frame = CGRect(x: 0, y: premiumServicesView.frame.maxY, width: orderSummaryScrollView.frame.width, height: (5 * x))
        noteView.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        orderSummaryScrollView.addSubview(noteView)
        
        noteLabel.frame = CGRect(x: x, y: 0, width: noteView.frame.width - (2 * x), height: (4 * y))
        noteLabel.text = "NOTE : The price, services and courier will add to order total amount"
        noteLabel.textAlignment = .center
        noteLabel.textColor = UIColor.white
        noteLabel.font = noteLabel.font.withSize(15)
        noteLabel.numberOfLines = 2
        noteView.addSubview(noteLabel)
        
        tailorListHeadingLabel.frame = CGRect(x: 0, y: noteView.frame.maxY + y, width: orderSummaryScrollView.frame.width, height: (3 * y))
        tailorListHeadingLabel.text = "TOTAL NUMBER OF TAILORS - \(selectedTailors.count)"
        tailorListHeadingLabel.textColor = UIColor.black
        tailorListHeadingLabel.textAlignment = .left
        tailorListHeadingLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        orderSummaryScrollView.addSubview(tailorListHeadingLabel)
        
        if let tailorList = UserDefaults.standard.value(forKey: "selectedTailors")
        {
            selectedTailors = tailorList as! [String]
        }
        
        let tailorView = UIView()
        tailorView.frame = CGRect(x: 0, y: tailorListHeadingLabel.frame.maxY, width: orderSummaryScrollView.frame.width, height: (5 * x * CGFloat(selectedTailors.count)) + y)
        tailorView.backgroundColor = UIColor.white
        orderSummaryScrollView.addSubview(tailorView)
        
        var y4:CGFloat = y
        
        let tailorArray = ["Noorul", "Ameen"]
        
        for i in 0..<selectedTailors.count
        {
            let dressSubViews = UIView()
            dressSubViews.frame = CGRect(x: x, y: y4, width: dressTypeView.frame.width - (2 * x), height: (4 * y))
            dressSubViews.layer.cornerRadius = 10
            dressSubViews.backgroundColor = UIColor(red: 0.0471, green: 0.1725, blue: 0.4588, alpha: 1.0)
            dressSubViews.layer.masksToBounds = true
            tailorView.addSubview(dressSubViews)
            
            let dressTypeImages = UIImageView()
            dressTypeImages.frame = CGRect(x: (x / 2), y: y / 2, width: (3 * x), height: (3 * y))
            dressTypeImages.layer.cornerRadius = dressTypeImages.frame.height / 2
            dressTypeImages.image = UIImage(named: "Tailor")
            dressSubViews.addSubview(dressTypeImages)
            
            let dressTypeLabels = UILabel()
            dressTypeLabels.frame = CGRect(x: dressTypeImages.frame.maxX + (x / 2), y: y / 2, width: (10 * x), height: (3 * y))
            dressTypeLabels.backgroundColor = UIColor.clear
            dressTypeLabels.text = "Tailor_\(i) - "
            dressTypeLabels.textColor = UIColor.white
            dressTypeLabels.textAlignment = .left
            dressTypeLabels.font = UIFont(name: "Avenir-Regular", size: x)
            dressTypeLabels.font = dressTypeLabels.font.withSize(1.5 * x)
            dressSubViews.addSubview(dressTypeLabels)
            
            let lineLabel = UILabel()
            lineLabel.frame = CGRect(x: dressTypeLabels.frame.maxX, y: ((dressSubViews.frame.height - 1) / 2), width: (x / 3), height: 1)
            lineLabel.backgroundColor = UIColor.white
            dressSubViews.addSubview(lineLabel)
            
            let getDressTypeLabels = UILabel()
            getDressTypeLabels.frame = CGRect(x: lineLabel.frame.maxX + (x / 2), y: (y / 2), width: (14 * x), height: (3 * y))
            getDressTypeLabels.backgroundColor = UIColor.clear
            getDressTypeLabels.text = selectedTailors[i]
            getDressTypeLabels.textColor = UIColor.white
            getDressTypeLabels.textAlignment = .left
            getDressTypeLabels.font = UIFont(name: "Avenir-Regular", size: x)
            getDressTypeLabels.font = getDressTypeLabels.font.withSize(1.5 * x)
            getDressTypeLabels.adjustsFontSizeToFitWidth = true
            dressSubViews.addSubview(getDressTypeLabels)
            
            y4 = dressSubViews.frame.maxY + (y / 2)
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    dressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    dressTypeLabels.text = "Tailor_\(i)"
                    dressTypeLabels.textAlignment = .left
                    
                    getDressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    getDressTypeLabels.text = selectedTailors[i]
                    getDressTypeLabels.textAlignment = .left
                }
                else if language == "ar"
                {
                    dressTypeLabels.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    dressTypeLabels.text = "خياط_\(i)"
                    dressTypeLabels.textAlignment = .right
                    
                    getDressTypeLabels.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    getDressTypeLabels.text = selectedTailors[i]
                    getDressTypeLabels.textAlignment = .right
                }
            }
            else
            {
                dressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                dressTypeLabels.text = "Tailor_\(i)"
                dressTypeLabels.textAlignment = .left
                
                getDressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                getDressTypeLabels.text = selectedTailors[i]
                getDressTypeLabels.textAlignment = .left
            }
        }
        
        
        submitButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        let idType = Variables.sharedManager.tailorType
        
        if idType == 0
        {
            submitButton.frame = CGRect(x: orderSummaryScrollView.frame.width - (13 * x), y: tailorView.frame.maxY + (2 * y), width: (10 * x), height: (4 * y))
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    submitButton.setTitle("SUBMIT", for: .normal)
                }
                else if language == "ar"
                {
                    submitButton.setTitle("خضع", for: .normal)
                }
            }
            else
            {
                submitButton.setTitle("SUBMIT", for: .normal)
            }
        }
        else
        {
            submitButton.frame = CGRect(x: orderSummaryScrollView.frame.width - (23 * x), y: tailorView.frame.maxY + (2 * y), width: (20 * x), height: (4 * y))
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    submitButton.setTitle("PROCEED TO PAY", for: .normal)
                }
                else if language == "ar"
                {
                    submitButton.setTitle("المضي قدما للدفع", for: .normal)
                }
            }
            else
            {
                submitButton.setTitle("PROCEED TO PAY", for: .normal)
            }
        }
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.addTarget(self, action: #selector(self.submitButtonAction(sender:)), for: .touchUpInside)
        orderSummaryScrollView.addSubview(submitButton)
        
        orderSummaryScrollView.contentSize.height = submitButton.frame.maxY + (2 * y)
        
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
    
    func custom1AndCustom2Content()
    {
        customization1HeadingLabel.frame = CGRect(x: 0, y: yPos, width: orderSummaryScrollView.frame.width, height: (3 * y))
        customization1HeadingLabel.text = "CUSTOMIZATION 1 AND CUSTOMIZATION 2"
        customization1HeadingLabel.textColor = UIColor.black
        customization1HeadingLabel.textAlignment = .left
        customization1HeadingLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        orderSummaryScrollView.addSubview(customization1HeadingLabel)
        
        let customization1View = UIView()
        customization1View.frame = CGRect(x: 0, y: customization1HeadingLabel.frame.maxY, width: orderSummaryScrollView.frame.width, height: (28.5 * y))
        customization1View.backgroundColor = UIColor.white
        orderSummaryScrollView.addSubview(customization1View)
        
        let customization1Array = ["Seasonal", "Place of Industry", "Brands", "Material Type", "Color", "Pattern"]
        let customizationArabicArray = ["موسمي", "مكان الصناعة", "العلامات التجارية", "نوع المادة", "اللون", "نمط"]
        let customizationImage1Array = ["Seasonal", "Place_of_industry", "Brand", "Material_type", "Color", "pattern"]
        var getSeason = String()
        var getIndustry = String()
        var getBrand = String()
        var getMaterial = String()
        var getColor = String()
        var getPattern = String()
        
        var getCustomizationOfAll = [String]()
        
        if let season = UserDefaults.standard.value(forKey: "season") as? [String]
        {
            let joined = season.joined(separator: ",")
            getSeason = joined
            
            getCustomizationOfAll.append(getSeason)
        }
        else
        {
            getCustomizationOfAll.append("")
        }
        
        print("GET ALL SEASON", getSeason)
        
        if let industry = UserDefaults.standard.value(forKey: "industry") as? [String]
        {
            let joined = industry.joined(separator: ",")
            getIndustry = joined
            
            getCustomizationOfAll.append(getIndustry)
        }
        else
        {
            getCustomizationOfAll.append("")
        }
        
        if let brand = UserDefaults.standard.value(forKey: "brand") as? [String]
        {
            let joined = brand.joined(separator: ",")
            getBrand = joined
            
            getCustomizationOfAll.append(getBrand)
        }
        else
        {
            getCustomizationOfAll.append("")
        }
        
        if let material = UserDefaults.standard.value(forKey: "material") as? [String]
        {
            let joined = material.joined(separator: ",")
            getMaterial = joined
            
            getCustomizationOfAll.append(getMaterial)
        }
        else
        {
            getCustomizationOfAll.append("")
        }
        
        if let color = UserDefaults.standard.value(forKey: "color") as? [String]
        {
            let joined = color.joined(separator: ",")
            getColor = joined

            getCustomizationOfAll.append(getColor)
        }
        else
        {
            getCustomizationOfAll.append("")
        }
        
        print("WELCOME TO WORLD", UserDefaults.standard.value(forKey: "pattern"))
        
        if let pattern = UserDefaults.standard.value(forKey: "pattern") as? String
        {
            getCustomizationOfAll.append("\(pattern)")
        }
        else if let pattern = UserDefaults.standard.value(forKey: "pattern") as? Int
        {
            getCustomizationOfAll.append("\(pattern)")
        }
        
        print("SUPER OF ALL", getCustomizationOfAll)
        
        var y6:CGFloat = y
        
        for i in 0..<customization1Array.count
        {
            let dressSubViews = UIView()
            dressSubViews.frame = CGRect(x: x, y: y6, width: customization1View.frame.width - (2 * x), height: (4 * y))
            dressSubViews.layer.cornerRadius = 10
            dressSubViews.backgroundColor = UIColor(red: 0.0471, green: 0.1725, blue: 0.4588, alpha: 1.0)
            dressSubViews.layer.masksToBounds = true
            customization1View.addSubview(dressSubViews)
            
            let dressTypeImages = UIImageView()
            dressTypeImages.frame = CGRect(x: (x / 2), y: y / 2, width: (3 * x), height: (3 * y))
            dressTypeImages.layer.cornerRadius = dressTypeImages.frame.height / 2
            dressTypeImages.image = UIImage(named: customizationImage1Array[i])
            dressSubViews.addSubview(dressTypeImages)
            
            let dressTypeLabels = UILabel()
            dressTypeLabels.frame = CGRect(x: dressTypeImages.frame.maxX + (x / 2), y: y / 2, width: (13 * x), height: (3 * y))
            dressTypeLabels.backgroundColor = UIColor.clear
            dressTypeLabels.text = customization1Array[i]
            dressTypeLabels.textColor = UIColor.white
            dressTypeLabels.textAlignment = .left
            dressTypeLabels.font = UIFont(name: "Avenir-Regular", size: x)
            dressTypeLabels.font = dressTypeLabels.font.withSize(1.5 * x)
            dressSubViews.addSubview(dressTypeLabels)
            
            let lineLabel = UILabel()
            lineLabel.frame = CGRect(x: dressTypeLabels.frame.maxX, y: ((dressSubViews.frame.height - 1) / 2), width: (x / 3), height: 1)
            lineLabel.backgroundColor = UIColor.white
            dressSubViews.addSubview(lineLabel)
            
            let getDressTypeLabels = UILabel()
            getDressTypeLabels.frame = CGRect(x: lineLabel.frame.maxX + (x / 2), y: (y / 2), width: (11 * x), height: (3 * y))
            getDressTypeLabels.backgroundColor = UIColor.clear
            if let custom = getCustomizationOfAll[i] as? String
            {
                if custom.count > 20
                {
                    getDressTypeLabels.font = getDressTypeLabels.font.withSize(1 * x)
                    getDressTypeLabels.adjustsFontSizeToFitWidth = true
                    getDressTypeLabels.numberOfLines = 2
                }
                else
                {
                    getDressTypeLabels.font = getDressTypeLabels.font.withSize(1.5 * x)
                    getDressTypeLabels.adjustsFontSizeToFitWidth = true
                    getDressTypeLabels.numberOfLines = 1
                }
                getDressTypeLabels.text = custom
            }
            else
            {
                getDressTypeLabels.text = ""
            }
            getDressTypeLabels.textColor = UIColor.white
            getDressTypeLabels.textAlignment = .left
            getDressTypeLabels.font = UIFont(name: "Avenir-Regular", size: x)
            dressSubViews.addSubview(getDressTypeLabels)
            
            y6 = dressSubViews.frame.maxY + (y / 2)
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    dressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    dressTypeLabels.text = customization1Array[i]
                    dressTypeLabels.textAlignment = .left
                    
                    getDressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//                    getDressTypeLabels.text = getDressTypeArray[i]
                    getDressTypeLabels.textAlignment = .left
                }
                else if language == "ar"
                {
                    dressTypeLabels.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    dressTypeLabels.text = customizationArabicArray[i]
                    dressTypeLabels.textAlignment = .right
                    
                    getDressTypeLabels.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
//                    getDressTypeLabels.text = getDressTypeArray[i]
                    getDressTypeLabels.textAlignment = .right
                }
            }
            else
            {
                dressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                dressTypeLabels.text = customization1Array[i]
                dressTypeLabels.textAlignment = .left
                
                getDressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//                getDressTypeLabels.text = getDressTypeArray[i]
                getDressTypeLabels.textAlignment = .left
            }
        }
        
        yPos = customization1View.frame.maxY + y
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func submitButtonAction(sender : UIButton)
    {
        sender.isEnabled = false
        var custom3KeyInt = [Int]()
        var custom3ValuesInt = [Int]()
        
         print("Tailor ID:",Variables.sharedManager.TailorID)
        
        if let delId = UserDefaults.standard.value(forKey: "serviceType") as? Int
        {
            deliveryTypeId = delId
        }
        
        if let id = UserDefaults.standard.value(forKey: "userId") as? String
        {
            userId = Int(id)!
        }
        else if let id = UserDefaults.standard.value(forKey: "userId") as? Int
        {
            userId = id
        }
        
        dressId = Variables.sharedManager.dressSubTypeId
        
        orderId = Variables.sharedManager.orderTypeId
        
        let addId = Variables.sharedManager.selectedAddressId
        
        if addId != 0
        {
            addressId = addId
        }
        
//        if let id = UserDefaults.standard.value(forKey: "addressId") as? Int
//        {
//            addressId = id
//        }
        
        if let measurementby = UserDefaults.standard.value(forKey: "measurementBy") as? String
        {
            measurementBy = measurementby
        }
        
        if measurementBy == "Customer"
        {
            if let name = UserDefaults.standard.value(forKey: "measurementName") as? String
            {
                measurementName = name
            }
        }
        else
        {
            measurementName = ""
        }
        
        if let id = UserDefaults.standard.value(forKey: "measurementIdInt") as? String
        {
            measurementIdInt = Int(id)!
        }
        else if let id = UserDefaults.standard.value(forKey: "measurementIdInt") as? Int
        {
            measurementIdInt = id
        }
        else
        {
            measurementIdInt = -1
        }
        
        if let patId = UserDefaults.standard.value(forKey: "patternId") as? Int
        {
            patternId = patId
        }
        else
        {
            patternId = 0
        }
        
        if let unit = UserDefaults.standard.value(forKey: "units") as? String
        {
            units = unit
        }
        
        if let partsId = UserDefaults.standard.value(forKey: "measurementId") as? NSArray
        {
            measurementId = partsId
        }
        
        if let dictValues = UserDefaults.standard.value(forKey: "measurementValues") as? [Double]
        {
            measurementValues = dictValues
        }
        
        if let taiId = UserDefaults.standard.value(forKey: "selectedTailorsId") as? [Int]
        {
            tailorId = orderCustom.tailorId(id: taiId)
        }
        
        if let custom3 = UserDefaults.standard.value(forKey: "custom3Id") as? [String : String]
        {
            for (keys, values) in custom3
            {
                custom3KeyInt.append(Int(keys)!)
                custom3ValuesInt.append(Int(values)!)
            }
        }
        
        if let type = UserDefaults.standard.value(forKey: "measurementType") as? Int
        {
            measurementType = type
        }
        else if let type = UserDefaults.standard.value(forKey: "measurementType") as? String
        {
            measurementType = Int(type)!
        }
        
        print("MEAUREMENT VALUES", custom3KeyInt, custom3ValuesInt)
        print("USER ID", userId)
        print("DRESS TYPE ID", dressId)
        print("PATTERN ID", patternId)
        print("ADDRESS ID", addressId)
        print("MEASUREMENT NAME", measurementName)
        print("MEASUREMENT TYPE", measurementType)
        print("MEASUREMENT ID", measurementIdInt)
        print("DRESS TYPE", dressId)
        
        orderCustomization = orderCustom.makeRequest(attId: custom3KeyInt, imgId: custom3ValuesInt)
        print("FINALIZED ORDER", orderCustomization)
        
        let fileAccessing = FileAccess()
        
        let getImage = fileAccessing.getImageFromDocumentDirectory(imageName: "Material")
        
        print("GET IMAGE IN ORDER SUMMARY", fileAccessing.getDirectoryPath())
        
        let convertImage = orderCustom.referenceImage(image: [getImage])
        
        var getImageArray = [UIImage]()
        
        if Variables.sharedManager.orderTypeId == 1 || Variables.sharedManager.orderTypeId == 2
        {
            if let materialImages = UserDefaults.standard.value(forKey: "materialImageArray") as? Int
            {
                print("MATERIAL IMAGES COUNT", materialImages)
                
                for i in 0..<materialImages
                {
                    let getImage = fileAccessing.getImageFromDocumentDirectory(imageName: "Material\(i)")
                    getImageArray.append(getImage)
                }
            }
            activityContents()
            spinnerOn()
            
            self.serviceCall.API_MaterialImageUpload(materialImages: getImageArray, delegate: self)
        }
        else if Variables.sharedManager.orderTypeId == 3
        {
            if let materialImages = UserDefaults.standard.value(forKey: "referenceImageArray") as? Int
            {
                print("MATERIAL IMAGES COUNT", materialImages)
                
                if materialImages != 0
                {
                    for i in 0..<materialImages
                    {
                        let getImage = fileAccessing.getImageFromDocumentDirectory(imageName: "Reference\(i)")
                        getImageArray.append(getImage)
                    }
                    
                    activityContents()
                    spinnerOn()
                    
                    serviceCall.API_ReferenceImageUpload(referenceImages: getImageArray, delegate: self)
                }
                else
                {
                    print("MEASUREMENT ID", measurementId)
                    print("MEASUREMENT VALUES", measurementValues)
                    print("MEASUREMENT ID INT", measurementIdInt)
                    
                    if measurementIdInt != -1
                    {
                        let userMeasurement = [[String : Any]]()
                        
                        //                        self.serviceCall.API_InsertUserMeasurementValues(UserId: userId, DressTypeId: dressId, MeasurementValue: userMeasurement, MeasurementBy: measurementBy, CreatedBy: "\(userId)", Units: units, Name: measurementName, delegate: self)
                        
                        activityContents()
                        spinnerOn()
                        
                        self.serviceCall.API_InsertOrderSummary(dressType: dressId, CustomerId: userId, AddressId: addressId, PatternId: patternId, Ordertype: orderId, MeasurementId: measurementIdInt, MaterialImage: getMaterialImageNameArray, ReferenceImage: getReferenceImageNameArray, OrderCustomization : orderCustomization, TailorId: tailorId, MeasurementBy: measurementBy, CreatedBy: userId, MeasurementName: measurementName, UserMeasurement : userMeasurement, DeliveryTypeId: deliveryTypeId, units: units, measurementType: measurementType, delegate: self)
                    }
                    else
                    {
                        let userMeasurement = orderCustom.userMeasurementRequest(id : measurementId as! [Int], values : measurementValues)
                        print("FINALIZED USER MEASUREMENT", userMeasurement)
                        
                        //                        self.serviceCall.API_InsertUserMeasurementValues(UserId: userId, DressTypeId: dressId, MeasurementValue: userMeasurement, MeasurementBy: measurementBy, CreatedBy: "\(userId)", Units: units, Name: measurementName, delegate: self)
                        
                        activityContents()
                        spinnerOn()
                        
                        self.serviceCall.API_InsertOrderSummary(dressType: dressId, CustomerId: userId, AddressId: addressId, PatternId: patternId, Ordertype: orderId, MeasurementId: measurementIdInt, MaterialImage: getMaterialImageNameArray, ReferenceImage: getReferenceImageNameArray, OrderCustomization : orderCustomization, TailorId: tailorId, MeasurementBy: measurementBy, CreatedBy: userId, MeasurementName: measurementName, UserMeasurement : userMeasurement, DeliveryTypeId: deliveryTypeId, units: units, measurementType: measurementType, delegate: self)
                    }
                }
            }
        }
    }
    
    func API_CALLBACK_MaterialImageUpload(material: NSDictionary) {
        print("MATERIAL IMAGE UPLOAD", material)
        
        let ResponseMsg = material.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = material.object(forKey: "Result") as! NSArray
            
            if Result.count != 0
            {
                for i in 0..<Result.count
                {
                    if let file1 = Result[i] as? String
                    {
                        let splitted = file1.split(separator: "\\")
                        print("SPLITTED", splitted)
                        
                        let imageName = splitted.last
                        print("IMAGE NAME", imageName!)
                        
                        getMaterialImageNameArray.append((imageName?.description)!)
                    }
                }
                
                var getImageArray = [UIImage]()
                
                if let materialImages = UserDefaults.standard.value(forKey: "referenceImageArray") as? Int
                {
                    print("MATERIAL IMAGES COUNT", materialImages)
                    
                    if materialImages != 0
                    {
                        for i in 0..<materialImages
                        {
                            let getImage = fileAccessing.getImageFromDocumentDirectory(imageName: "Reference\(i)")
                            getImageArray.append(getImage)
                        }
                        
                        serviceCall.API_ReferenceImageUpload(referenceImages: getImageArray, delegate: self)
                    }
                    else
                    {
                        print("CALL OF CHECK", measurementId, measurementValues)
                        let userMeasurement = orderCustom.userMeasurementRequest(id : measurementId as! [Int], values : measurementValues)
                        print("FINALIZED USER MEASUREMENT", userMeasurement)
                        
//                        self.serviceCall.API_InsertUserMeasurementValues(UserId: userId, DressTypeId: dressId, MeasurementValue: userMeasurement, MeasurementBy: measurementBy, CreatedBy: "\(userId)", Units: units, Name: measurementName, delegate: self)
                        
                        activityContents()
                        
                        self.serviceCall.API_InsertOrderSummary(dressType: dressId, CustomerId: userId, AddressId: addressId, PatternId: patternId, Ordertype: orderId, MeasurementId: measurementIdInt, MaterialImage: getMaterialImageNameArray, ReferenceImage: getReferenceImageNameArray, OrderCustomization : orderCustomization, TailorId: tailorId, MeasurementBy: measurementBy, CreatedBy: userId, MeasurementName: measurementName, UserMeasurement : userMeasurement, DeliveryTypeId: deliveryTypeId, units: units, measurementType: measurementType, delegate: self)
                    }
                }
            }
        }
        else
        {
            submitButton.isEnabled = true
            applicationDelegate.exitContents()
            
            let Result = material.object(forKey: "Result") as! String
            print("Result IN FAILURE", Result)
            
            MethodName = "Material Image Upload"
            ErrorStr = Result
            DeviceError()
        }
        
        print("CALL BACK IMAGE NAME FOR MATERIAL", getMaterialImageNameArray)
    }
    
    func API_CALLBACK_ReferenceImageUpload(reference: NSDictionary) {
        print("REFERENCE IMAGE UPLOAD", reference)
        
        let ResponseMsg = reference.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = reference.object(forKey: "Result") as! NSArray
            
            if Result.count != 0
            {
                for i in 0..<Result.count
                {
                    if let file1 = Result[i] as? String
                    {
                        let splitted = file1.split(separator: "\\")
                        print("SPLITTED", splitted)
                        
                        let imageName = splitted.last
                        print("IMAGE NAME", imageName!)
                        
                        getReferenceImageNameArray.append((imageName?.description)!)
                    }
                }
                
                let userMeasurement = orderCustom.userMeasurementRequest(id : measurementId as! [Int], values : measurementValues)
                print("FINALIZED USER MEASUREMENT", userMeasurement)
                
                activityContents()
                
                self.serviceCall.API_InsertOrderSummary(dressType: dressId, CustomerId: userId, AddressId: addressId, PatternId: patternId, Ordertype: orderId, MeasurementId: measurementIdInt, MaterialImage: getMaterialImageNameArray, ReferenceImage: getReferenceImageNameArray, OrderCustomization : orderCustomization, TailorId: tailorId, MeasurementBy: measurementBy, CreatedBy: userId, MeasurementName: measurementName, UserMeasurement : userMeasurement, DeliveryTypeId: deliveryTypeId, units: units, measurementType: measurementType, delegate: self)

                
//                self.serviceCall.API_InsertUserMeasurementValues(UserId: userId, DressTypeId: dressId, MeasurementValue: userMeasurement, MeasurementBy: measurementBy, CreatedBy: "\(userId)", Units: units, Name: measurementName, delegate: self)
            }
        }
        else
        {
            submitButton.isEnabled = true
            applicationDelegate.exitContents()
            
            let Result = reference.object(forKey: "Result") as! String
            print("Result IN FAILURE", Result)
            
            MethodName = "Reference Image Upload"
            ErrorStr = Result
            DeviceError()
        }
        
        print("CALL BACK IMAGE NAME FOR REFERENCE", getReferenceImageNameArray)
    }
    
    func API_CALLBACK_InsertUserMeasurement(insUsrMeasurementVal: NSDictionary)
    {
        let ResponseMsg = insUsrMeasurementVal.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = insUsrMeasurementVal.object(forKey: "Result") as! Int
            print("Result Value :", Result)
            
            let userMeasurement = orderCustom.userMeasurementRequest(id : measurementId as! [Int], values : measurementValues)
            print("FINALIZED USER MEASUREMENT", userMeasurement)
            
            activityContents()
            
            self.serviceCall.API_InsertOrderSummary(dressType: dressId, CustomerId: userId, AddressId: addressId, PatternId: patternId, Ordertype: orderId, MeasurementId: measurementIdInt, MaterialImage: getMaterialImageNameArray, ReferenceImage: getReferenceImageNameArray, OrderCustomization : orderCustomization, TailorId: tailorId, MeasurementBy: measurementBy, CreatedBy: userId, MeasurementName: measurementName, UserMeasurement : userMeasurement, DeliveryTypeId: deliveryTypeId, units: units, measurementType: measurementType, delegate: self)
        }
        else if ResponseMsg == "Failure"
        {
            let Result = insUsrMeasurementVal.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "InsertUserMeasurementValues"
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func navigateToHomeScreen(action : UIAlertAction)
    {
        let tailorTypeId = Variables.sharedManager.tailorType
        
        if tailorTypeId == 0
        {
            window = UIWindow(frame: UIScreen.main.bounds)
            let loginScreen = HomeViewController()
            let navigationScreen = UINavigationController(rootViewController: loginScreen)
            navigationScreen.isNavigationBarHidden = true
            window?.rootViewController = navigationScreen
            window?.makeKeyAndVisible()
        }
        if tailorTypeId == 1
        {
            if (Variables.sharedManager.orderType.contains("Companies-Material") && Variables.sharedManager.measurementType.contains("Manually"))
            {
                let paymentScreen = PaymentViewController()
                self.navigationController?.pushViewController(paymentScreen, animated: true)
            }
            else if (Variables.sharedManager.orderType.contains("Own Material-Courier the Material"))
            {
                let AppointmentScreen = AppointmentViewController()
                self.navigationController?.pushViewController(AppointmentScreen, animated: true)
            }
            else if (Variables.sharedManager.measurementType.contains("Tailor Come To Your Place"))
            {
                let AppointmentScreen = AppointmentViewController()
                self.navigationController?.pushViewController(AppointmentScreen, animated: true)
            }
            else
            {
                let paymentScreen = PaymentViewController()
                self.navigationController?.pushViewController(paymentScreen, animated: true)
            }
            
           
        }
        
        
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("Order Summary", errorMessage)
        stopActivity()
        applicationDelegate.exitContents()
    }
    
    func API_CALLBACK_InsertOrderSummary(insertOrder: NSDictionary)
    {
        let ResponseMsg = insertOrder.object(forKey: "ResponseMsg") as! String
     
        stopActivity()
        spinnerOff()
        
        if ResponseMsg == "Success"
        {
            let Result = insertOrder.object(forKey: "Result") as! String
            print("Result in SUCCESS in ORDER SUMMARY", Result)
            
            UserDefaults.standard.set(Result, forKey: "requestId")
            
            let idType = Variables.sharedManager.tailorType
            
            if idType == 1
            {
                if let RequestID = UserDefaults.standard.value(forKey: "requestId") as? Int
                {
                    Variables.sharedManager.OrderID = RequestID
                }
                else if let RequestID = UserDefaults.standard.value(forKey: "requestId") as? String
                {
                    Variables.sharedManager.OrderID = Int(RequestID)!
                }
                
                let qtyNum = 1
                 print("Order_ID:",Variables.sharedManager.OrderID)
                 print("Tailor_ID:",Variables.sharedManager.TailorID)
                
                self.serviceCall.API_UpdateQtyOrderApproval(OrderId: Variables.sharedManager.OrderID, Qty: qtyNum, delegate: self)
                self.serviceCall.API_IsApproveTailorOrder(OrderId: Variables.sharedManager.OrderID, TailorId: Variables.sharedManager.TailorID, IsApproved: 1, delegate: self)
            }
            
            var successAlert = UIAlertController()
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    successAlert = UIAlertController(title: "Ordered Placed Successfully", message: "Order Id = \(Result)", preferredStyle: .alert)
                    successAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: navigateToHomeScreen(action:)))
                }
                else if language == "ar"
                {
                    successAlert = UIAlertController(title: "رتبت بنجاح", message: "معرف الطلب = \(Result)", preferredStyle: .alert)
                    successAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: navigateToHomeScreen(action:)))
                }
            }
            else
            {
                successAlert = UIAlertController(title: "Ordered Placed Successfully", message: "Order Id = \(Result)", preferredStyle: .alert)
                successAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: navigateToHomeScreen(action:)))
            }
            self.present(successAlert, animated: true, completion: nil)
        }
        else if ResponseMsg == "Failure"
        {
            submitButton.isEnabled = true
            applicationDelegate.exitContents()
            
            let Result = insertOrder.object(forKey: "Result") as! String
            print("Result IN FAILURE", Result)
            
            MethodName = "InsertOrder"
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        //  ErrorStr = "Default Error"
        PageNumStr = "OrderSummary ViewController"
        // MethodName = "do"
        
        print("UUID", UIDevice.current.identifierForVendor?.uuidString as Any)
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
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
    func API_CALLBACK_UpdateQtyOrderApproval(updateQtyOA: NSDictionary)
    {
       
        let ResponseMsg = updateQtyOA.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = updateQtyOA.object(forKey: "Result") as! String
            print("Result", Result)
            
       }
        else if ResponseMsg == "Failure"
        {
            let Result = updateQtyOA.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "UPdateQtyInOrderApproval"
            ErrorStr = Result
            
            DeviceError()
            
        }
    }
    
    func API_CALLBACK_TailorOrderApprove(TailorApprove: NSDictionary)
    {
        let ResponseMsg = TailorApprove.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = TailorApprove.object(forKey: "Result") as! String
            print("Result", Result)
            
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
