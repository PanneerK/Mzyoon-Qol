//
//  OrderTypeViewController.swift
//  Mzyoon
//
//  Created by QOL on 16/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class OrderTypeViewController: CommonViewController, ServerAPIDelegate
{
    let serviceCall = ServerAPI()
    
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()

    let selfScreenContents = UIView()

    let directDeliveryIcon = UIImageView()
    let directDeliveryLabel = UILabel()
    let directDeliveryButton = UIButton()

    let courierDeliveryIcon = UIImageView()
    let couriertDeliveryLabel = UILabel()
    let extraLabel = UILabel()
    let courierDeliveryButton = UIButton()
    
    let companyIcon = UIImageView()
    let companyLabel = UILabel()
    let companyButton = UIButton()

    //ORDER TYPE PARAMETERS
    var orderTypeIDArray = NSArray()
    var orderTypeNameArray = NSArray()
    var orderTypeNameArrayInArabic = NSArray()
    var orderTypeHeaderImage = NSArray()
    var orderTypeBodyImage = NSArray()
    var convertedOrderHeaderImageArray = [UIImage]()
    var convertedOrderBodyImageArray = [UIImage]()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    //HINTS PARAMETERS
    var hintTag = 0
    let hintsImage = UIImageView()
    let detailedLabel = UILabel()
    
    var applicationDelegate = AppDelegate()

    
    override func viewDidLoad()
    {
        navigationBar.isHidden = true
        
//        self.tab1Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        selectedButton(tag: 0)
        
        self.serviceCall.API_OrderType(delegate: self)

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
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
       // ErrorStr = "Default Error"
        PageNumStr = "OrderTypeViewController"
        MethodName = "DisplayOrderType"
        
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("ORDER TYPE", errorMessage)
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
    
    func API_CALLBACK_OrderType(orderType: NSDictionary)
    {
        print("ORDER TYPE OF VIEW", orderType)
        
        let ResponseMsg = orderType.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = orderType.object(forKey: "Result") as! NSArray
            
            orderTypeNameArray = Result.value(forKey: "HeaderInEnglish") as! NSArray
            
            orderTypeNameArrayInArabic = Result.value(forKey: "HeaderInArabic") as! NSArray
            
            orderTypeIDArray = Result.value(forKey: "id") as! NSArray
            
            orderTypeHeaderImage = Result.value(forKey: "HeaderImage") as! NSArray
            
            orderTypeBodyImage = Result.value(forKey: "BodyImage") as! NSArray
            
            /*for i in 0..<orderTypeHeaderImage.count
            {
                
                if let imageName = orderTypeHeaderImage[i] as? String
                {
                    let urlString = serviceCall.baseURL
                    let api = "\(urlString)/images/OrderType/\(imageName)"

                    let apiurl = URL(string: api)
                    
                    if let data = try? Data(contentsOf: apiurl!) {
                        if let image = UIImage(data: data) {
                            self.convertedOrderHeaderImageArray.append(image)
                        }
                    }
                    else
                    {
                        let emptyImage = UIImage(named: "empty")
                        self.convertedOrderHeaderImageArray.append(emptyImage!)
                    }
                }
                else if orderTypeHeaderImage[i] is NSNull
                {
                    let emptyImage = UIImage(named: "empty")
                    self.convertedOrderHeaderImageArray.append(emptyImage!)
                }
            }
            
            for i in 0..<orderTypeBodyImage.count
            {
                
                if let imageName = orderTypeBodyImage[i] as? String
                {
                    let urlString = serviceCall.baseURL
                    let api = "\(urlString)/images/OrderType/\(imageName)"
                    let apiurl = URL(string: api)
                    
                    if let data = try? Data(contentsOf: apiurl!) {
                        if let image = UIImage(data: data) {
                            self.convertedOrderBodyImageArray.append(image)
                        }
                    }
                    else
                    {
                        let emptyImage = UIImage(named: "empty")
                        self.convertedOrderBodyImageArray.append(emptyImage!)
                    }
                }
                else if orderTypeBodyImage[i] is NSNull
                {
                    let emptyImage = UIImage(named: "empty")
                    self.convertedOrderBodyImageArray.append(emptyImage!)
                }
            }*/
            
            self.orderTypeContent()
        }
        else if ResponseMsg == "Failure"
        {
            let Result = orderType.object(forKey: "Result") as! String
            print("Result", Result)
            
            ErrorStr = Result
            
            DeviceError()
        }
        
    }
    
    func changeViewToArabicInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.text = "نوع الطلب"
        
        selfScreenContents.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        directDeliveryIcon.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        directDeliveryLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        directDeliveryButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        directDeliveryLabel.text = (orderTypeNameArrayInArabic[0] as! String)
        directDeliveryLabel.textAlignment = .right
        
        courierDeliveryIcon.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        couriertDeliveryLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        courierDeliveryButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        extraLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        couriertDeliveryLabel.text = (orderTypeNameArrayInArabic[1] as! String)
        couriertDeliveryLabel.textAlignment = .right
        
        extraLabel.text = "(الرسوم الإضافية المطبقة)"
        extraLabel.textAlignment = .right
        
        companyIcon.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        companyButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        companyLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        companyLabel.text = (orderTypeNameArrayInArabic[2] as! String)
        companyLabel.textAlignment = .right
    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.text = "ORDER TYPE"
        
        selfScreenContents.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

        directDeliveryIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        directDeliveryLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        directDeliveryButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        directDeliveryLabel.text = (orderTypeNameArray[0] as! String)
        directDeliveryLabel.textAlignment = .left
        
        courierDeliveryIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        couriertDeliveryLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        courierDeliveryButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        extraLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        couriertDeliveryLabel.text = (orderTypeNameArray[1] as! String)
        couriertDeliveryLabel.textAlignment = .left
        
        extraLabel.text = "(Extra charges applicable)"
        extraLabel.textAlignment = .left
        
        companyIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        companyLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        companyButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        companyLabel.text = (orderTypeNameArray[2] as! String)
        companyLabel.textAlignment = .left
    }
    
    func orderTypeContent()
    {
        selfScreenNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        selfScreenNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(selfScreenNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 3
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        selfScreenNavigationBar.addSubview(backButton)
        
        selfScreenNavigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: selfScreenNavigationBar.frame.width, height: (3 * y))
        selfScreenNavigationTitle.text = "ORDER TYPE"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationTitle.font = selfScreenNavigationTitle.font.withSize(2 * x)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        selfScreenContents.frame = CGRect(x: x, y: pageBar.frame.maxY, width: view.frame.width - (2 * x), height: view.frame.height - ((5 * y) + selfScreenNavigationBar.frame.maxY + pageBar.frame.height))
        selfScreenContents.backgroundColor = UIColor.clear
        view.addSubview(selfScreenContents)
        
        pageBar.image = UIImage(named: "MaterialBar")

        directDeliveryIcon.frame = CGRect(x: 0, y: y, width: (2 * x), height: (2 * y))
//        directDeliveryIcon.image = convertedOrderHeaderImageArray[0]
        if let imageName = orderTypeHeaderImage[0] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/OrderType/\(imageName)"
            let apiurl = URL(string: api)
            if apiurl != nil
            {
                directDeliveryIcon.dowloadFromServer(url: apiurl!)
            }
        }
        selfScreenContents.addSubview(directDeliveryIcon)
        
        directDeliveryLabel.frame = CGRect(x: directDeliveryIcon.frame.maxX + x, y: y, width: view.frame.width, height: (2 * y))
        directDeliveryLabel.text = (orderTypeNameArray[0] as! String)
        directDeliveryLabel.textColor = UIColor.black
        directDeliveryLabel.textAlignment = .left
        directDeliveryLabel.font = UIFont(name: "AvenirNext-Regular", size: (1.2 * x))
        selfScreenContents.addSubview(directDeliveryLabel)
        
        let directDeliveryUnderline = UILabel()
        directDeliveryUnderline.frame = CGRect(x: 0, y: directDeliveryLabel.frame.maxY + (y / 2), width: selfScreenContents.frame.width, height: 0.5)
        directDeliveryUnderline.backgroundColor = UIColor.lightGray
        selfScreenContents.addSubview(directDeliveryUnderline)
        
        directDeliveryButton.frame = CGRect(x: 0, y: directDeliveryUnderline.frame.maxY + y, width: selfScreenContents.frame.width, height: (12 * y))
        if let imageName = orderTypeBodyImage[0] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/OrderType/\(imageName)"
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: directDeliveryButton.frame.width, height: directDeliveryButton.frame.height)
            dummyImageView.dowloadFromServer(url: apiurl!)
            if apiurl != nil
            {
                directDeliveryButton.addSubview(dummyImageView)
            }
        }
//        directDeliveryButton.setImage(convertedOrderBodyImageArray[0], for: .normal)
        directDeliveryButton.tag = orderTypeIDArray[0] as! Int
        directDeliveryButton.addTarget(self, action: #selector(self.ownMaterialButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(directDeliveryButton)
        
        courierDeliveryIcon.frame = CGRect(x: 0, y: directDeliveryButton.frame.maxY + y, width: (2 * x), height: (2 * y))
//        courierDeliveryIcon.image = convertedOrderHeaderImageArray[1]
        if let imageName = orderTypeHeaderImage[1] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/OrderType/\(imageName)"
            let apiurl = URL(string: api)
            if apiurl != nil
            {
                courierDeliveryIcon.dowloadFromServer(url: apiurl!)
            }
        }
        selfScreenContents.addSubview(courierDeliveryIcon)
        
        couriertDeliveryLabel.frame = CGRect(x: courierDeliveryIcon.frame.maxX + x, y: directDeliveryButton.frame.maxY + y, width: view.frame.width - (21 * x), height: (2 * y))
//        couriertDeliveryLabel.backgroundColor = UIColor.red
        couriertDeliveryLabel.text = (orderTypeNameArray[1] as! String)
        couriertDeliveryLabel.textColor = UIColor.black
        couriertDeliveryLabel.textAlignment = .left
        couriertDeliveryLabel.font = UIFont(name: "AvenirNext-Regular", size: (1.2 * x))
        couriertDeliveryLabel.adjustsFontSizeToFitWidth = true
        selfScreenContents.addSubview(couriertDeliveryLabel)
        
        extraLabel.frame = CGRect(x: couriertDeliveryLabel.frame.maxX, y: directDeliveryButton.frame.maxY + y, width: (20 * x), height: (2 * y))
//        extraLabel.backgroundColor = UIColor.red
        extraLabel.text = "(Extra charges applicable)"
        extraLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        extraLabel.textAlignment = .left
        extraLabel.font = UIFont(name: "AvenirNext-Regular", size: x)
        extraLabel.adjustsFontSizeToFitWidth = true
        selfScreenContents.addSubview(extraLabel)
        
        let courierDeliveryUnderline = UILabel()
        courierDeliveryUnderline.frame = CGRect(x: 0, y: couriertDeliveryLabel.frame.maxY + (y / 2), width: selfScreenContents.frame.width, height: 0.5)
        courierDeliveryUnderline.backgroundColor = UIColor.lightGray
        selfScreenContents.addSubview(courierDeliveryUnderline)
        
        courierDeliveryButton.frame = CGRect(x: 0, y: courierDeliveryUnderline.frame.maxY + y, width: selfScreenContents.frame.width, height: (12 * y))
        if let imageName = orderTypeBodyImage[1] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/OrderType/\(imageName)"
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: courierDeliveryButton.frame.width, height: courierDeliveryButton.frame.height)
            dummyImageView.dowloadFromServer(url: apiurl!)
            if apiurl != nil
            {
                courierDeliveryButton.addSubview(dummyImageView)
            }
        }
//        courierDeliveryButton.setImage(convertedOrderBodyImageArray[1], for: .normal)
        courierDeliveryButton.tag = orderTypeIDArray[1] as! Int
        courierDeliveryButton.addTarget(self, action: #selector(self.ownMaterialButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(courierDeliveryButton)
        
        companyIcon.frame = CGRect(x: 0, y: courierDeliveryButton.frame.maxY + y, width: (2 * x), height: (2 * y))
//        companyIcon.image = convertedOrderHeaderImageArray[2]
        if let imageName = orderTypeHeaderImage[2] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/OrderType/\(imageName)"
            let apiurl = URL(string: api)
            if apiurl != nil
            {
                companyIcon.dowloadFromServer(url: apiurl!)
            }
        }
        selfScreenContents.addSubview(companyIcon)
        
        companyLabel.frame = CGRect(x: companyIcon.frame.maxX + x, y: courierDeliveryButton.frame.maxY + y, width: view.frame.width, height: (2 * y))
        companyLabel.text = (orderTypeNameArray[2] as! String)
        companyLabel.textColor = UIColor.black
        companyLabel.textAlignment = .left
        companyLabel.font = UIFont(name: "AvenirNext-Regular", size: (1.2 * x))
        selfScreenContents.addSubview(companyLabel)
        
        let companyUnderline = UILabel()
        companyUnderline.frame = CGRect(x: 0, y: companyLabel.frame.maxY + (y / 2), width: selfScreenContents.frame.width, height: 0.5)
        companyUnderline.backgroundColor = UIColor.lightGray
        selfScreenContents.addSubview(companyUnderline)
        
        companyButton.frame = CGRect(x: 0, y: companyUnderline.frame.maxY + y, width: selfScreenContents.frame.width, height: (12 * y))
//        companyButton.backgroundColor = UIColor.magenta
        if let imageName = orderTypeBodyImage[2] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/OrderType/\(imageName)"
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: companyButton.frame.width, height: companyButton.frame.height)
            dummyImageView.dowloadFromServer(url: apiurl!)
            if apiurl != nil
            {
                companyButton.addSubview(dummyImageView)
            }
            
            self.stopActivity()
        }
//        companyButton.setImage(convertedOrderBodyImageArray[2], for: .normal)
        companyButton.tag = orderTypeIDArray[2] as! Int
        companyButton.addTarget(self, action: #selector(self.companyButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(companyButton)
        
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
        
        self.view.bringSubviewToFront(slideMenuButton)
        pageContent(tag: 3)
        
        
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
        self.gotItButton.removeFromSuperview()
        
        let headingLabel = UILabel()
        headingLabel.frame = CGRect(x: (2 * x), y: (5 * y), width: hintsView.frame.width - (4 * x), height: (3 * y))
        headingLabel.text = "Order Type"
        headingLabel.textAlignment = .left
        headingLabel.textColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0)
        headingLabel.font = UIFont(name: "Avenir-Regular", size: (2 * x))
        hintsView.addSubview(headingLabel)
        
        var x1:CGFloat = x
        
        let title = ["Back", "Skip", "Next"]
        let arabicTitle = ["الى الخلف", "تخطى", "التالي"]
        
        for i in 0..<3
        {
            let threeButtons = UIButton()
            threeButtons.frame = CGRect(x: x1, y: hintsView.frame.height - (6 * y), width: (11.16 * x), height: (4 * y))
            threeButtons.backgroundColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0)
            threeButtons.setTitle(title[i], for: .normal)
            threeButtons.setTitleColor(UIColor.white, for: .normal)
            threeButtons.tag = i
            threeButtons.addTarget(self, action: #selector(self.threeButtonAction(sender:)), for: .touchUpInside)
            hintsView.addSubview(threeButtons)
            
            x1 = threeButtons.frame.maxX + x
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    threeButtons.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    threeButtons.setTitle(title[i], for: .normal)
                }
                else if language == "ar"
                {
                    threeButtons.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    threeButtons.setTitle(arabicTitle[i], for: .normal)
                }
            }
            else
            {
                threeButtons.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                threeButtons.setTitle(title[i], for: .normal)
            }
        }
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                headingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                headingLabel.text = "Order Type"
                headingLabel.textAlignment = .left
            }
            else if language == "ar"
            {
                headingLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                headingLabel.text = "نوع الطلب"
                headingLabel.textAlignment = .right
            }
        }
        else
        {
            headingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            headingLabel.text = "Order Type"
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
            }
            else if hintTag == 1
            {
                secondHint()
            }
            else if hintTag == 2
            {
                thirdHint()
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
            }
            else if hintTag == 2
            {
                thirdHint()
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
        hintsImage.frame = CGRect(x: (3 * x), y: directDeliveryButton.frame.minY + (10.5 * y), width: directDeliveryButton.frame.width, height: directDeliveryButton.frame.height)
        hintsImage.layer.borderWidth = 2
        hintsImage.layer.borderColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0).cgColor
        hintsImage.image = UIImage(named: "ownMaterialHintImage")
        hintsView.addSubview(hintsImage)
        
        detailedLabel.frame = CGRect(x: (2 * x), y: hintsImage.frame.maxY + y, width: hintsView.frame.width - (4 * x), height: (6 * y))
        detailedLabel.text = "If you have your own material for stitching and want to deliver it directly to tailor. Please click this option"
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
                detailedLabel.text = "If you have your own material for stitching and want to deliver it directly to tailor. Please click this option"
                detailedLabel.textAlignment = .left
            }
            else if language == "ar"
            {
                hintsImage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                detailedLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                detailedLabel.text = "إذا كان لديك المواد الخاصة بك للخياطة وتريد تسليمها مباشرة إلى الخياطة. الرجاء الضغط على هذا الخيار"
                detailedLabel.textAlignment = .right
            }
        }
        else
        {
            hintsImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            detailedLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            detailedLabel.text = "If you have your own material for stitching and want to deliver it directly to tailor. Please click this option"
            detailedLabel.textAlignment = .left
        }
    }
    
    func secondHint()
    {
        hintsImage.frame = CGRect(x: (3 * x), y: courierDeliveryButton.frame.minY + (10.5 * y), width: courierDeliveryButton.frame.width, height: courierDeliveryButton.frame.height)
        hintsImage.layer.borderWidth = 2
        hintsImage.layer.borderColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0).cgColor
        hintsImage.image = UIImage(named: "courierMaterialHintImage")
        hintsView.addSubview(hintsImage)
        
        detailedLabel.frame = CGRect(x: (2 * x), y: hintsImage.frame.maxY + y, width: hintsView.frame.width - (4 * x), height: (6 * y))
        detailedLabel.text = "If you have your own material for stitching and want it to be picked from your place. Please click this option"
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
                detailedLabel.text = "If you have your own material for stitching and want it to be picked from your place. Please click this option"
                detailedLabel.textAlignment = .left
            }
            else if language == "ar"
            {
                hintsImage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                detailedLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                detailedLabel.text = "إذا كان لديك المواد الخاصة بك للخياطة وتريد أن يتم انتقاؤها من مكانك. الرجاء الضغط على هذا الخيار"
                detailedLabel.textAlignment = .right
            }
        }
        else
        {
            hintsImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            detailedLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            detailedLabel.text = "If you have your own material for stitching and want it to be picked from your place. Please click this option"
            detailedLabel.textAlignment = .left
        }
    }
    
    func thirdHint()
    {
        hintsImage.frame = CGRect(x: (3 * x), y: companyButton.frame.minY + (10.5 * y), width: companyButton.frame.width, height: companyButton.frame.height)
        hintsImage.layer.borderWidth = 2
        hintsImage.layer.borderColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0).cgColor
        hintsImage.image = UIImage(named: "companyMaterialHintImage")
        hintsView.addSubview(hintsImage)
        
        detailedLabel.frame = CGRect(x: (2 * x), y: hintsImage.frame.minY - (8 * y), width: hintsView.frame.width - (4 * x), height: (6 * y))
        detailedLabel.text = "Please click this option to explore our materials for stitching"
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
                detailedLabel.text = "Please click this option to explore our materials for stitching"
                detailedLabel.textAlignment = .left
            }
            else if language == "ar"
            {
                hintsImage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                detailedLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                detailedLabel.text = "يرجى النقر على هذا الخيار للإطلاع على مواد الخياطة الخاصة بنا"
                detailedLabel.textAlignment = .right
            }
        }
        else
        {
            hintsImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            detailedLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            detailedLabel.text = "Please click this option to explore our materials for stitching"
            detailedLabel.textAlignment = .left
        }
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func ownMaterialButtonAction(sender : UIButton)
    {
        UserDefaults.standard.set(sender.tag, forKey: "orderType")
        let ownMaterialScreen = OwnMateialViewController()
        self.navigationController?.pushViewController(ownMaterialScreen, animated: true)
    }
    
    
    @objc func companyButtonAction(sender : UIButton)
    {
        UserDefaults.standard.set(sender.tag, forKey: "orderType")
        let customizationScreen = Customization1ViewController()
        self.navigationController?.pushViewController(customizationScreen, animated: true)
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
