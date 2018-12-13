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
    
    //ORDER TYPE PARAMETERS
    let orderTypeView = UIView()
    var orderTypeIDArray = NSArray()
    var orderTypeNameArray = NSArray()
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
        
        self.tab1Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        
        self.serviceCall.API_OrderType(delegate: self)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
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
                    let api = "http://appsapi.mzyoon.com/images/OrderType/\(imageName)"
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
                    let api = "http://appsapi.mzyoon.com/images/OrderType/\(imageName)"
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
    
    
    func orderTypeContent()
    {
        self.stopActivity()
        orderTypeView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        orderTypeView.backgroundColor = UIColor.white
//        view.addSubview(orderTypeView)
        
        let orderTypeNavigationBar = UIView()
        orderTypeNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        orderTypeNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(orderTypeNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 3
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        orderTypeNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: orderTypeNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "ORDER TYPE"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        orderTypeNavigationBar.addSubview(navigationTitle)
        
        let directDeliveryIcon = UIImageView()
        directDeliveryIcon.frame = CGRect(x: (3 * x), y: orderTypeNavigationBar.frame.maxY + (2 * y), width: (2 * x), height: (2 * y))
//        directDeliveryIcon.image = convertedOrderHeaderImageArray[0]
        if let imageName = orderTypeHeaderImage[0] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/OrderType/\(imageName)"
            let apiurl = URL(string: api)
            directDeliveryIcon.dowloadFromServer(url: apiurl!)
        }
        view.addSubview(directDeliveryIcon)
        
        let directDeliveryLabel = UILabel()
        directDeliveryLabel.frame = CGRect(x: directDeliveryIcon.frame.maxX, y: orderTypeNavigationBar.frame.maxY + (2 * y), width: view.frame.width, height: (2 * y))
        directDeliveryLabel.text = (orderTypeNameArray[0] as! String)
        directDeliveryLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        directDeliveryLabel.textAlignment = .left
        directDeliveryLabel.font = UIFont(name: "AvenirNext-Regular", size: 12)
        view.addSubview(directDeliveryLabel)
        
        let directDeliveryUnderline = UILabel()
        directDeliveryUnderline.frame = CGRect(x: (3 * x), y: directDeliveryLabel.frame.maxY + (y / 2), width: view.frame.width - (6 * x), height: 0.5)
        directDeliveryUnderline.backgroundColor = UIColor.lightGray
        view.addSubview(directDeliveryUnderline)
        
        let directDeliveryButton = UIButton()
        directDeliveryButton.frame = CGRect(x: (3 * x), y: directDeliveryUnderline.frame.maxY + y, width: view.frame.width - (6 * x), height: (12 * y))
        if let imageName = orderTypeBodyImage[0] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/OrderType/\(imageName)"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: directDeliveryButton.frame.width, height: directDeliveryButton.frame.height)
            dummyImageView.dowloadFromServer(url: apiurl!)
            directDeliveryButton.addSubview(dummyImageView)
        }
//        directDeliveryButton.setImage(convertedOrderBodyImageArray[0], for: .normal)
        directDeliveryButton.addTarget(self, action: #selector(self.ownMaterialButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(directDeliveryButton)
        
        let courierDeliveryIcon = UIImageView()
        courierDeliveryIcon.frame = CGRect(x: (3 * x), y: directDeliveryButton.frame.maxY + (2 * y), width: (2 * x), height: (2 * y))
//        courierDeliveryIcon.image = convertedOrderHeaderImageArray[1]
        if let imageName = orderTypeHeaderImage[1] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/OrderType/\(imageName)"
            let apiurl = URL(string: api)
            courierDeliveryIcon.dowloadFromServer(url: apiurl!)
        }
        view.addSubview(courierDeliveryIcon)
        
        let couriertDeliveryLabel = UILabel()
        couriertDeliveryLabel.frame = CGRect(x: courierDeliveryIcon.frame.maxX, y: directDeliveryButton.frame.maxY + (2 * y), width: view.frame.width - (5 * x), height: (2 * y))
        couriertDeliveryLabel.text = (orderTypeNameArray[1] as! String)
        couriertDeliveryLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        couriertDeliveryLabel.textAlignment = .left
        couriertDeliveryLabel.font = UIFont(name: "AvenirNext-Regular", size: 12)
        couriertDeliveryLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(couriertDeliveryLabel)
        
        let courierDeliveryUnderline = UILabel()
        courierDeliveryUnderline.frame = CGRect(x: (3 * x), y: couriertDeliveryLabel.frame.maxY + (y / 2), width: view.frame.width - (6 * x), height: 0.5)
        courierDeliveryUnderline.backgroundColor = UIColor.lightGray
        view.addSubview(courierDeliveryUnderline)
        
        let courierDeliveryButton = UIButton()
        courierDeliveryButton.frame = CGRect(x: (3 * x), y: courierDeliveryUnderline.frame.maxY + y, width: view.frame.width - (6 * x), height: (12 * y))
        if let imageName = orderTypeBodyImage[1] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/OrderType/\(imageName)"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: courierDeliveryButton.frame.width, height: courierDeliveryButton.frame.height)
            dummyImageView.dowloadFromServer(url: apiurl!)
            courierDeliveryButton.addSubview(dummyImageView)
        }
//        courierDeliveryButton.setImage(convertedOrderBodyImageArray[1], for: .normal)
        courierDeliveryButton.addTarget(self, action: #selector(self.ownMaterialButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(courierDeliveryButton)
        
        let companyIcon = UIImageView()
        companyIcon.frame = CGRect(x: (3 * x), y: courierDeliveryButton.frame.maxY + (2 * y), width: (2 * x), height: (2 * y))
//        companyIcon.image = convertedOrderHeaderImageArray[2]
        if let imageName = orderTypeHeaderImage[2] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/OrderType/\(imageName)"
            let apiurl = URL(string: api)
            companyIcon.dowloadFromServer(url: apiurl!)
        }
        view.addSubview(companyIcon)
        
        let companyLabel = UILabel()
        companyLabel.frame = CGRect(x: companyIcon.frame.maxX, y: courierDeliveryButton.frame.maxY + (2 * y), width: view.frame.width, height: (2 * y))
        companyLabel.text = (orderTypeNameArray[2] as! String)
        companyLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        companyLabel.textAlignment = .left
        companyLabel.font = UIFont(name: "AvenirNext-Regular", size: 12)
        view.addSubview(companyLabel)
        
        let companyUnderline = UILabel()
        companyUnderline.frame = CGRect(x: (3 * x), y: companyLabel.frame.maxY + (y / 2), width: view.frame.width - (6 * x), height: 0.5)
        companyUnderline.backgroundColor = UIColor.lightGray
        view.addSubview(companyUnderline)
        
        let companyButton = UIButton()
        companyButton.frame = CGRect(x: (3 * x), y: companyUnderline.frame.maxY + y, width: view.frame.width - (6 * x), height: (12 * y))
//        companyButton.backgroundColor = UIColor.magenta
        if let imageName = orderTypeBodyImage[2] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/OrderType/\(imageName)"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: companyButton.frame.width, height: companyButton.frame.height)
            dummyImageView.dowloadFromServer(url: apiurl!)
            companyButton.addSubview(dummyImageView)
        }
//        companyButton.setImage(convertedOrderBodyImageArray[2], for: .normal)
        companyButton.addTarget(self, action: #selector(self.companyButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(companyButton)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func ownMaterialButtonAction(sender : UIButton)
    {
        UserDefaults.standard.set("OwnMaterial", forKey: "OrderType")
        let ownMaterialScreen = OwnMateialViewController()
        self.navigationController?.pushViewController(ownMaterialScreen, animated: true)
    }
    
    
    @objc func companyButtonAction(sender : UIButton)
    {
        UserDefaults.standard.set("CompanyMaterial", forKey: "OrderType")
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
