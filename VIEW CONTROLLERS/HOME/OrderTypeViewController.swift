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
    
    override func viewDidLoad()
    {
        navigationBar.isHidden = true
        
//        self.tab1Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        selectedButton(tag: 0)
        self.serviceCall.API_OrderType(delegate: self)

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        self.serviceCall.API_OrderType(delegate: self)
    }*/
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
       // ErrorStr = "Default Error"
        PageNumStr = "OrderTypeViewController"
        MethodName = "DisplayOrderType"
        
        print("UUID", UIDevice.current.identifierForVendor?.uuidString as Any)
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String) {
        print("ORDER TYPE", errorMessage)
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
            print("Result", Result)
            
            orderTypeNameArray = Result.value(forKey: "HeaderInEnglish") as! NSArray
            print("OrderTypeInEnglish", orderTypeNameArray)
            
            orderTypeNameArrayInArabic = Result.value(forKey: "HeaderInArabic") as! NSArray
            print("HeaderInArabic", orderTypeNameArrayInArabic)
            
            orderTypeIDArray = Result.value(forKey: "id") as! NSArray
            print("Id", orderTypeIDArray)
            
            orderTypeHeaderImage = Result.value(forKey: "HeaderImage") as! NSArray
            print("HeaderImageURL", orderTypeHeaderImage)
            
            orderTypeBodyImage = Result.value(forKey: "BodyImage") as! NSArray
            print("BodyImageURL",orderTypeBodyImage)
            
            /*for i in 0..<orderTypeHeaderImage.count
            {
                
                if let imageName = orderTypeHeaderImage[i] as? String
                {
                    let urlString = serviceCall.baseURL
                    let api = "\(urlString)/images/OrderType/\(imageName)"
                    print("BIG ICON", api)

                    let apiurl = URL(string: api)
                    
                    if let data = try? Data(contentsOf: apiurl!) {
                        print("Header DATA OF IMAGE", data)
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
                    print("SMALL ICON", api)
                    let apiurl = URL(string: api)
                    
                    if let data = try? Data(contentsOf: apiurl!) {
                        print("Body DATA OF IMAGE", data)
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
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        selfScreenContents.frame = CGRect(x: 0, y: selfScreenNavigationBar.frame.maxY, width: view.frame.width, height: view.frame.height - ((5 * y) + selfScreenNavigationBar.frame.maxY))
        selfScreenContents.backgroundColor = UIColor.clear
        view.addSubview(selfScreenContents)

        directDeliveryIcon.frame = CGRect(x: (3 * x), y: (2 * y), width: (2 * x), height: (2 * y))
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
        
        directDeliveryLabel.frame = CGRect(x: directDeliveryIcon.frame.maxX + x, y: (2 * y), width: view.frame.width, height: (2 * y))
        directDeliveryLabel.text = (orderTypeNameArray[0] as! String)
        directDeliveryLabel.textColor = UIColor.black
        directDeliveryLabel.textAlignment = .left
        directDeliveryLabel.font = UIFont(name: "AvenirNext-Regular", size: 12)
        selfScreenContents.addSubview(directDeliveryLabel)
        
        let directDeliveryUnderline = UILabel()
        directDeliveryUnderline.frame = CGRect(x: (3 * x), y: directDeliveryLabel.frame.maxY + (y / 2), width: view.frame.width - (6 * x), height: 0.5)
        directDeliveryUnderline.backgroundColor = UIColor.lightGray
        selfScreenContents.addSubview(directDeliveryUnderline)
        
        directDeliveryButton.frame = CGRect(x: (3 * x), y: directDeliveryUnderline.frame.maxY + y, width: view.frame.width - (6 * x), height: (12 * y))
        if let imageName = orderTypeBodyImage[0] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/OrderType/\(imageName)"
            print("SMALL ICON", api)
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
        
        courierDeliveryIcon.frame = CGRect(x: (3 * x), y: directDeliveryButton.frame.maxY + (2 * y), width: (2 * x), height: (2 * y))
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
        
        couriertDeliveryLabel.frame = CGRect(x: courierDeliveryIcon.frame.maxX + x, y: directDeliveryButton.frame.maxY + (2 * y), width: view.frame.width - (21 * x), height: (2 * y))
//        couriertDeliveryLabel.backgroundColor = UIColor.red
        couriertDeliveryLabel.text = (orderTypeNameArray[1] as! String)
        couriertDeliveryLabel.textColor = UIColor.black
        couriertDeliveryLabel.textAlignment = .left
        couriertDeliveryLabel.font = UIFont(name: "AvenirNext-Regular", size: 12)
        couriertDeliveryLabel.adjustsFontSizeToFitWidth = true
        selfScreenContents.addSubview(couriertDeliveryLabel)
        
        extraLabel.frame = CGRect(x: couriertDeliveryLabel.frame.maxX, y: directDeliveryButton.frame.maxY + (2 * y), width: (20 * x), height: (2 * y))
//        extraLabel.backgroundColor = UIColor.red
        extraLabel.text = "(Extra charges applicable)"
        extraLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        extraLabel.textAlignment = .left
        extraLabel.font = UIFont(name: "AvenirNext-Regular", size: 10)
        extraLabel.adjustsFontSizeToFitWidth = true
        selfScreenContents.addSubview(extraLabel)
        
        let courierDeliveryUnderline = UILabel()
        courierDeliveryUnderline.frame = CGRect(x: (3 * x), y: couriertDeliveryLabel.frame.maxY + (y / 2), width: view.frame.width - (6 * x), height: 0.5)
        courierDeliveryUnderline.backgroundColor = UIColor.lightGray
        selfScreenContents.addSubview(courierDeliveryUnderline)
        
        courierDeliveryButton.frame = CGRect(x: (3 * x), y: courierDeliveryUnderline.frame.maxY + y, width: view.frame.width - (6 * x), height: (12 * y))
        if let imageName = orderTypeBodyImage[1] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/OrderType/\(imageName)"
            print("SMALL ICON", api)
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
        
        companyIcon.frame = CGRect(x: (3 * x), y: courierDeliveryButton.frame.maxY + (2 * y), width: (2 * x), height: (2 * y))
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
        
        companyLabel.frame = CGRect(x: companyIcon.frame.maxX + x, y: courierDeliveryButton.frame.maxY + (2 * y), width: view.frame.width, height: (2 * y))
        companyLabel.text = (orderTypeNameArray[2] as! String)
        companyLabel.textColor = UIColor.black
        companyLabel.textAlignment = .left
        companyLabel.font = UIFont(name: "AvenirNext-Regular", size: 12)
        selfScreenContents.addSubview(companyLabel)
        
        let companyUnderline = UILabel()
        companyUnderline.frame = CGRect(x: (3 * x), y: companyLabel.frame.maxY + (y / 2), width: view.frame.width - (6 * x), height: 0.5)
        companyUnderline.backgroundColor = UIColor.lightGray
        selfScreenContents.addSubview(companyUnderline)
        
        companyButton.frame = CGRect(x: (3 * x), y: companyUnderline.frame.maxY + y, width: view.frame.width - (6 * x), height: (12 * y))
//        companyButton.backgroundColor = UIColor.magenta
        if let imageName = orderTypeBodyImage[2] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/OrderType/\(imageName)"
            print("SMALL ICON", api)
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
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func ownMaterialButtonAction(sender : UIButton)
    {
        print("SENDER TAG IN ORDER TYPE", sender.tag)
        UserDefaults.standard.set(sender.tag, forKey: "orderType")
        let ownMaterialScreen = OwnMateialViewController()
        self.navigationController?.pushViewController(ownMaterialScreen, animated: true)
    }
    
    
    @objc func companyButtonAction(sender : UIButton)
    {
        print("SENDER TAG IN ORDER TYPE", sender.tag)
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
