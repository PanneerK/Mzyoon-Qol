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
    
    //SCREEN PARAMETERS
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()
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
    var measurementValues = [Float]()
    var units = "CM"
    var orderCustomization = [[String: Int]]()
    var tailorId = [[String: Any]]()
    
    var applicationDelegate = AppDelegate()

    
    override func viewDidLoad()
    {
        navigationBar.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of seconds
            // Your code with delay
            self.orderSummaryContent()
        }
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.text = "ORDER SUMMARY"

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
        tailorListHeadingLabel.text = "TOTAL NUMBER OF TAILORS"
        tailorListHeadingLabel.textAlignment = .left
        
        submitButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        submitButton.setTitle("SUBMIT", for: .normal)
        
        noteLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        noteLabel.text = "NOTE : The price, services and courier will add to order total amount"

    }
    
    func changeViewToArabicInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.text = "ملخص الطلب"
        
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
        tailorListHeadingLabel.text = "مجموع عدد الخياطين"
        tailorListHeadingLabel.textAlignment = .right
        
        submitButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        submitButton.setTitle("خضع", for: .normal)
        
        noteLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        noteLabel.text = "ملاحظة: سيضيف السعر والخدمات والبريد السريع المبلغ الإجمالي للطلب"
    }
    
    func orderSummaryContent()
    {
        self.stopActivity()
        
        selfScreenNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        selfScreenNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(selfScreenNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 4
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        selfScreenNavigationBar.addSubview(backButton)
        
        selfScreenNavigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: selfScreenNavigationBar.frame.width, height: (3 * y))
        selfScreenNavigationTitle.text = "ORDER SUMMARY"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        orderSummaryScrollView.frame = CGRect(x: 0, y: selfScreenNavigationBar.frame.maxY + y, width: view.frame.width, height: view.frame.height - (13 * y))
        orderSummaryScrollView.backgroundColor = UIColor.clear
        view.addSubview(orderSummaryScrollView)
        
        self.view.bringSubviewToFront(slideMenuButton)
        
        dressTypeHeadingLabel.frame = CGRect(x: (3 * x), y: y, width: view.frame.width, height: (3 * y))
        dressTypeHeadingLabel.text = "DRESS TYPE"
        dressTypeHeadingLabel.textColor = UIColor.black
        dressTypeHeadingLabel.textAlignment = .left
        dressTypeHeadingLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        orderSummaryScrollView.addSubview(dressTypeHeadingLabel)
        
        let dressTypeView = UIView()
        dressTypeView.frame = CGRect(x: (3 * x), y: dressTypeHeadingLabel.frame.maxY, width: orderSummaryScrollView.frame.width - (6 * x), height: (15 * x))
        dressTypeView.backgroundColor = UIColor.white
        orderSummaryScrollView.addSubview(dressTypeView)
        
        let dressTypeArray = ["Gender", "Dress Type", "Dress Sub Type"]
        let dressTypeImageArray = ["Gender-3", "Dress_types", "Dress_subtypes"]
        var getDressTypeArray = ["Men"]
        let dressTypeArabicArray = ["جنس", "نوع الفستان", "اللباس النوع الفرعي"]
        
        if let dressType = UserDefaults.standard.value(forKey: "dressType") as? String
        {
            getDressTypeArray.append(dressType)
        }
        
        if let dressSubType = UserDefaults.standard.value(forKey: "dressSubType") as? String
        {
            getDressTypeArray.append(dressSubType)
        }
        
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
            
            let getDressTypeLabels = UILabel()
            getDressTypeLabels.frame = CGRect(x: dressTypeLabels.frame.maxX + (x / 2), y: (y / 2), width: (11 * x), height: (3 * y))
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
                    dressTypeLabels.text = dressTypeArray[i] + "-"
                    dressTypeLabels.textAlignment = .left
                    
                    getDressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    getDressTypeLabels.text = getDressTypeArray[i]
                    getDressTypeLabels.textAlignment = .left
                }
                else if language == "ar"
                {
                    dressTypeLabels.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    dressTypeLabels.text = dressTypeArabicArray[i] + "-"
                    dressTypeLabels.textAlignment = .right
                    
                    getDressTypeLabels.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    getDressTypeLabels.text = getDressTypeArray[i]
                    getDressTypeLabels.textAlignment = .right
                }
            }
            else
            {
                dressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                dressTypeLabels.text = dressTypeArray[i] + "-"
                dressTypeLabels.textAlignment = .left
                
                getDressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                getDressTypeLabels.text = getDressTypeArray[i]
                getDressTypeLabels.textAlignment = .left
            }
        }
        
        yPos = dressTypeView.frame.maxY + y
        
        if let orderType = UserDefaults.standard.value(forKey: "orderType") as? Int
        {
            if orderType != 3
            {
                
            }
            else
            {
                custom1AndCustom2Content()
            }
        }
        else if let orderType = UserDefaults.standard.value(forKey: "orderType") as? String
        {
            if orderType == "3"
            {
                custom1AndCustom2Content()
            }
            else
            {
                
            }
        }
        
        customizationHeadingLabel.frame = CGRect(x: (3 * x), y: yPos, width: view.frame.width, height: (3 * y))
        customizationHeadingLabel.text = "CUSTOMIZATION 3"
        customizationHeadingLabel.textColor = UIColor.black
        customizationHeadingLabel.textAlignment = .left
        customizationHeadingLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        orderSummaryScrollView.addSubview(customizationHeadingLabel)
        
        if let custom3 = UserDefaults.standard.value(forKey: "custom3") as? NSDictionary
        {
            customization3 = custom3
        }
        
        
        let customizationView = UIView()
        customizationView.frame = CGRect(x: (3 * x), y: customizationHeadingLabel.frame.maxY, width: orderSummaryScrollView.frame.width - (6 * x), height: (5 * x * CGFloat(customization3.count)))
        customizationView.backgroundColor = UIColor.white
        orderSummaryScrollView.addSubview(customizationView)
        
        print("CUSTOM 3 SELECTED", customization3)
        
        var customKeys = [String]()
        var customvalues = [String]()
        
        for (keys, values) in customization3
        {
            customKeys.append(keys as! String)
            customvalues.append(values as! String)
        }
        
        let customizationArray = ["Lapels - ", "Buttons - ", "Pockets - ", "Vents - "]
        let customizationImageArray = ["Lapels", "Buttons", "Pockets", "Vents"]
        var y2:CGFloat = y
        
        for i in 0..<customization3.count
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
            dressTypeImages.image = UIImage(named: customizationImageArray[i])
            dressSubViews.addSubview(dressTypeImages)
            
            let dressTypeLabels = UILabel()
            dressTypeLabels.frame = CGRect(x: dressTypeImages.frame.maxX + (x / 2), y: y / 2, width: (13 * x), height: (3 * y))
            dressTypeLabels.backgroundColor = UIColor.clear
            dressTypeLabels.text = "\(customKeys[i])" + "-"
            dressTypeLabels.textColor = UIColor.white
            dressTypeLabels.textAlignment = .left
            dressTypeLabels.font = UIFont(name: "Avenir-Regular", size: x)
            dressTypeLabels.font = dressTypeLabels.font.withSize(1.5 * x)
            dressSubViews.addSubview(dressTypeLabels)
            
            let getDressTypeLabels = UILabel()
            getDressTypeLabels.frame = CGRect(x: dressTypeLabels.frame.maxX + (x / 2), y: (y / 2), width: (11 * x), height: (3 * y))
            getDressTypeLabels.backgroundColor = UIColor.clear
            getDressTypeLabels.text = customvalues[i]
            getDressTypeLabels.textColor = UIColor.white
            getDressTypeLabels.textAlignment = .left
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
            getDressTypeLabels.adjustsFontSizeToFitWidth = true
            dressSubViews.addSubview(getDressTypeLabels)
            
            y2 = dressSubViews.frame.maxY + (y / 2)
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    dressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    dressTypeLabels.text = "\(customKeys[i])" + "-"
                    dressTypeLabels.textAlignment = .left
                    
                    getDressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    getDressTypeLabels.text = customvalues[i]
                    getDressTypeLabels.textAlignment = .left
                }
                else if language == "ar"
                {
                    dressTypeLabels.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    dressTypeLabels.text = "\(customKeys[i])" + "-"
                    dressTypeLabels.textAlignment = .right
                    
                    getDressTypeLabels.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    getDressTypeLabels.text = customvalues[i]
                    getDressTypeLabels.textAlignment = .right
                }
            }
            else
            {
                dressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                dressTypeLabels.text = "\(customKeys[i])" + "-"
                dressTypeLabels.textAlignment = .left
                
                getDressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                getDressTypeLabels.text = customvalues[i]
                getDressTypeLabels.textAlignment = .left
            }
        }
        
        premiumServicesHeadingLabel.frame = CGRect(x: (3 * x), y: customizationView.frame.maxY + y, width: view.frame.width, height: (3 * y))
        premiumServicesHeadingLabel.text = "PREMIUM SERVICES"
        premiumServicesHeadingLabel.textColor = UIColor.black
        premiumServicesHeadingLabel.textAlignment = .left
        premiumServicesHeadingLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        orderSummaryScrollView.addSubview(premiumServicesHeadingLabel)
        
        let premiumServicesView = UIView()
        premiumServicesView.frame = CGRect(x: (3 * x), y: premiumServicesHeadingLabel.frame.maxY, width: orderSummaryScrollView.frame.width - (6 * x), height: (11 * x))
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
            dressTypeLabels.frame = CGRect(x: dressTypeImages.frame.maxX + (x / 2), y: y / 2, width: (18 * x), height: (3 * y))
            dressTypeLabels.backgroundColor = UIColor.clear
            dressTypeLabels.text = premiumArray[i]
            dressTypeLabels.textColor = UIColor.white
            dressTypeLabels.textAlignment = .left
            dressTypeLabels.font = UIFont(name: "Avenir-Regular", size: x)
            dressTypeLabels.font = dressTypeLabels.font.withSize(1.5 * x)
            dressSubViews.addSubview(dressTypeLabels)
            
            let getDressTypeLabels = UILabel()
            getDressTypeLabels.frame = CGRect(x: dressTypeLabels.frame.maxX, y: (y / 2), width: (7.5 * x), height: (3 * y))
            getDressTypeLabels.backgroundColor = UIColor.clear
            
            if let type = UserDefaults.standard.value(forKey: "serviceType") as? Int
            {
                if type == 1
                {
                    if i != 0
                    {
                        getDressTypeLabels.text = "Appointment"
                    }
                }
                else if type == 2
                {
                    if i != 0
                    {
                        getDressTypeLabels.text = "Urgent"
                    }
                }
                else if type == 3
                {
                    if i != 0
                    {
                        getDressTypeLabels.text = "Normal"
                    }
                }
            }
            else
            {
                
            }
           
            getDressTypeLabels.textColor = UIColor.white
            getDressTypeLabels.textAlignment = .left
            getDressTypeLabels.font = UIFont(name: "Avenir-Regular", size: x)
            getDressTypeLabels.font = getDressTypeLabels.font.withSize(1.5 * x)
            getDressTypeLabels.adjustsFontSizeToFitWidth = true
            dressSubViews.addSubview(getDressTypeLabels)
            
            y3 = dressSubViews.frame.maxY + (y / 2)
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    dressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    dressTypeLabels.text = premiumArray[i] + "-"
                    dressTypeLabels.textAlignment = .left
                    
                    getDressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    getDressTypeLabels.textAlignment = .left
                }
                else if language == "ar"
                {
                    dressTypeLabels.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    dressTypeLabels.text = premiumArabicArray[i] + "-"
                    dressTypeLabels.textAlignment = .right
                    
                    getDressTypeLabels.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    getDressTypeLabels.textAlignment = .right
                }
            }
            else
            {
                dressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                dressTypeLabels.text = premiumArray[i] + "-"
                dressTypeLabels.textAlignment = .left
                
                getDressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                getDressTypeLabels.textAlignment = .left
            }
        }
        
        let noteView = UIView()
        noteView.frame = CGRect(x: (3 * x), y: premiumServicesView.frame.maxY, width: orderSummaryScrollView.frame.width - (6 * x), height: (5 * x))
        noteView.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        orderSummaryScrollView.addSubview(noteView)
        
        noteLabel.frame = CGRect(x: x, y: 0, width: noteView.frame.width - (2 * x), height: (4 * y))
        noteLabel.text = "NOTE : The price, services and courier will add to order total amount"
        noteLabel.textAlignment = .center
        noteLabel.textColor = UIColor.white
        noteLabel.font = noteLabel.font.withSize(15)
        noteLabel.numberOfLines = 2
        noteView.addSubview(noteLabel)
        
        tailorListHeadingLabel.frame = CGRect(x: (3 * x), y: noteView.frame.maxY + y, width: view.frame.width, height: (3 * y))
        tailorListHeadingLabel.text = "TOTAL NUMBER OF TAILORS"
        tailorListHeadingLabel.textColor = UIColor.black
        tailorListHeadingLabel.textAlignment = .left
        tailorListHeadingLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        orderSummaryScrollView.addSubview(tailorListHeadingLabel)
        
        
        if let tailorList = UserDefaults.standard.value(forKey: "selectedTailors")
        {
            selectedTailors = tailorList as! [String]
        }
        
        let tailorView = UIView()
        tailorView.frame = CGRect(x: (3 * x), y: tailorListHeadingLabel.frame.maxY, width: orderSummaryScrollView.frame.width - (6 * x), height: (5 * x * CGFloat(selectedTailors.count)) + y)
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
            
            let getDressTypeLabels = UILabel()
            getDressTypeLabels.frame = CGRect(x: dressTypeLabels.frame.maxX + (x / 2), y: (y / 2), width: (14 * x), height: (3 * y))
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
                    dressTypeLabels.text = "Tailor_\(i)" + "-"
                    dressTypeLabels.textAlignment = .left
                    
                    getDressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    getDressTypeLabels.text = selectedTailors[i]
                    getDressTypeLabels.textAlignment = .left
                }
                else if language == "ar"
                {
                    dressTypeLabels.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    dressTypeLabels.text = "خياط_\(i)" + "-"
                    dressTypeLabels.textAlignment = .right
                    
                    getDressTypeLabels.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    getDressTypeLabels.text = selectedTailors[i]
                    getDressTypeLabels.textAlignment = .right
                }
            }
            else
            {
                dressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                dressTypeLabels.text = "Tailor_\(i)" + "-"
                dressTypeLabels.textAlignment = .left
                
                getDressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                getDressTypeLabels.text = selectedTailors[i]
                getDressTypeLabels.textAlignment = .left
            }
        }
        
        
        submitButton.frame = CGRect(x: orderSummaryScrollView.frame.width - (13 * x), y: tailorView.frame.maxY + (2 * y), width: (10 * x), height: (4 * y))
        submitButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        submitButton.setTitle("SUBMIT", for: .normal)
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
        customization1HeadingLabel.frame = CGRect(x: (3 * x), y: yPos, width: view.frame.width, height: (3 * y))
        customization1HeadingLabel.text = "CUSTOMIZATION 1 AND CUSTOMIZATION 2"
        customization1HeadingLabel.textColor = UIColor.black
        customization1HeadingLabel.textAlignment = .left
        customization1HeadingLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        orderSummaryScrollView.addSubview(customization1HeadingLabel)
        
        let customization1View = UIView()
        customization1View.frame = CGRect(x: (3 * x), y: customization1HeadingLabel.frame.maxY, width: orderSummaryScrollView.frame.width - (6 * x), height: (28.5 * y))
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
            for i in 0..<season.count
            {
                getSeason.append(contentsOf: season[i])
            }
            
            getCustomizationOfAll.append(getSeason)
        }
        else
        {
            getCustomizationOfAll.append("")
        }
        
        if let industry = UserDefaults.standard.value(forKey: "industry") as? [String]
        {
            for i in 0..<industry.count
            {
                getIndustry.append(contentsOf: industry[i])
            }
            
            getCustomizationOfAll.append(getIndustry)
        }
        else
        {
            getCustomizationOfAll.append("")
        }
        
        if let brand = UserDefaults.standard.value(forKey: "brand") as? [String]
        {
            for i in 0..<brand.count
            {
                getBrand.append(contentsOf: brand[i])
            }
            
            getCustomizationOfAll.append(getBrand)
        }
        else
        {
            getCustomizationOfAll.append("")
        }
        
        if let material = UserDefaults.standard.value(forKey: "material") as? [String]
        {
            for i in 0..<material.count
            {
                getMaterial.append(contentsOf: material[i])
            }
            
            getCustomizationOfAll.append(getMaterial)
        }
        else
        {
            getCustomizationOfAll.append("")
        }
        
        if let color = UserDefaults.standard.value(forKey: "color") as? [String]
        {
            for i in 0..<color.count
            {
                getColor.append(contentsOf: color[i])
            }
            
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
            
            let getDressTypeLabels = UILabel()
            getDressTypeLabels.frame = CGRect(x: dressTypeLabels.frame.maxX + (x / 2), y: (y / 2), width: (11 * x), height: (3 * y))
            getDressTypeLabels.backgroundColor = UIColor.clear
            if let custom = getCustomizationOfAll[i] as? String
            {
                getDressTypeLabels.text = custom
            }
            else
            {
                getDressTypeLabels.text = ""
            }
            getDressTypeLabels.textColor = UIColor.white
            getDressTypeLabels.textAlignment = .left
            getDressTypeLabels.font = UIFont(name: "Avenir-Regular", size: x)
            getDressTypeLabels.font = getDressTypeLabels.font.withSize(1.5 * x)
            getDressTypeLabels.adjustsFontSizeToFitWidth = true
            dressSubViews.addSubview(getDressTypeLabels)
            
            y6 = dressSubViews.frame.maxY + (y / 2)
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    dressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    dressTypeLabels.text = customization1Array[i] + "-"
                    dressTypeLabels.textAlignment = .left
                    
                    getDressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//                    getDressTypeLabels.text = getDressTypeArray[i]
                    getDressTypeLabels.textAlignment = .left
                }
                else if language == "ar"
                {
                    dressTypeLabels.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    dressTypeLabels.text = customizationArabicArray[i] + "-"
                    dressTypeLabels.textAlignment = .right
                    
                    getDressTypeLabels.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
//                    getDressTypeLabels.text = getDressTypeArray[i]
                    getDressTypeLabels.textAlignment = .right
                }
            }
            else
            {
                dressTypeLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                dressTypeLabels.text = customization1Array[i] + "-"
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
        
        if let dressid = UserDefaults.standard.value(forKey: "dressSubTypeId") as? Int
        {
            dressId = dressid
        }
        else if let dressid = UserDefaults.standard.value(forKey: "dressSubTypeId") as? String
        {
            let converted = Int(dressid)
            print("CONVERTED", converted, dressid)
            dressId = converted!
        }
        
        if let orderid = UserDefaults.standard.value(forKey: "orderType") as? Int
        {
            orderId = orderid
        }
        
        if let id = UserDefaults.standard.value(forKey: "addressId") as? Int
        {
            addressId = id
        }
        
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
        
        if let dictValues = UserDefaults.standard.value(forKey: "measurementValues") as? [Float]
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
        
       
        
        print("GET IMAGE ARRAY COUNT", getImageArray.count)
        
        if let orderType = UserDefaults.standard.value(forKey: "orderType") as? Int
        {
            if orderType == 1 || orderType == 2
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

                self.serviceCall.API_MaterialImageUpload(materialImages: getImageArray, delegate: self)
            }
            else if orderType == 3
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
                            
                            self.serviceCall.API_InsertOrderSummary(dressType: dressId, CustomerId: userId, AddressId: addressId, PatternId: patternId, Ordertype: orderId, MeasurementId: measurementIdInt, MaterialImage: getMaterialImageNameArray, ReferenceImage: getReferenceImageNameArray, OrderCustomization : orderCustomization, TailorId: tailorId, MeasurementBy: measurementBy, CreatedBy: userId, MeasurementName: measurementName, UserMeasurement : userMeasurement, DeliveryTypeId: deliveryTypeId, units: units, measurementType: measurementType, delegate: self)
                        }
                        else
                        {
                            let userMeasurement = orderCustom.userMeasurementRequest(id : measurementId as! [Int], values : measurementValues)
                            print("FINALIZED USER MEASUREMENT", userMeasurement)
                            
                            //                        self.serviceCall.API_InsertUserMeasurementValues(UserId: userId, DressTypeId: dressId, MeasurementValue: userMeasurement, MeasurementBy: measurementBy, CreatedBy: "\(userId)", Units: units, Name: measurementName, delegate: self)
                            
                            activityContents()
                            
                             self.serviceCall.API_InsertOrderSummary(dressType: dressId, CustomerId: userId, AddressId: addressId, PatternId: patternId, Ordertype: orderId, MeasurementId: measurementIdInt, MaterialImage: getMaterialImageNameArray, ReferenceImage: getReferenceImageNameArray, OrderCustomization : orderCustomization, TailorId: tailorId, MeasurementBy: measurementBy, CreatedBy: userId, MeasurementName: measurementName, UserMeasurement : userMeasurement, DeliveryTypeId: deliveryTypeId, units: units, measurementType: measurementType, delegate: self)
                        }
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
        window = UIWindow(frame: UIScreen.main.bounds)
        let loginScreen = HomeViewController()
        let navigationScreen = UINavigationController(rootViewController: loginScreen)
        navigationScreen.isNavigationBarHidden = true
        window?.rootViewController = navigationScreen
        window?.makeKeyAndVisible()
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
        
        if ResponseMsg == "Success"
        {
            let Result = insertOrder.object(forKey: "Result") as! String
            print("Result in SUCCESS in ORDER SUMMARY", Result)
            
            UserDefaults.standard.set(Result, forKey: "requestId")
            
            let alert = UIAlertController(title: "Ordered Placed Successfully", message: "Order Id = \(Result)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: navigateToHomeScreen(action:)))
            self.present(alert, animated: true, completion: nil)
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
