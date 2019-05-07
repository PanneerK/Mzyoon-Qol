//
//  HomeViewController.swift
//  Mzyoon
//
//  Created by QOL on 29/10/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit
import SideMenu

class HomeViewController: CommonViewController, ServerAPIDelegate
{
    let serviceCall = ServerAPI()

    let slideMB = UIButton()
    var slideView = UIView()
    
    //POSITION
    var xPos:CGFloat!
    var yPos:CGFloat!
    
    var imageName = NSArray()
    
    let blurView = UIView()
        
    var applicationDelegate = AppDelegate()
    
    
    override func viewDidLoad()
    {
        Variables.sharedManager.screenNavigationBarTag = 1
        
        UserDefaults.standard.set(1, forKey: "screenAppearance")
        
        xPos = 10 / 375 * 100
        xPos = xPos * view.frame.width / 100
        
        yPos = 10 / 667 * 100
        yPos = yPos * view.frame.height / 100
                
        selectedButton(tag: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of seconds
            // Your code with delay
            
            self.pageBar.isHidden = true
            self.slideMenuButton.isHidden = false
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    self.navigationTitle.text = "HOME"
                    self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    self.checkContent()
                }
                else if language == "ar"
                {
                    self.navigationTitle.text = "الصفحة الرئيسية"
                    self.navigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    self.checkContentInArabic()
                }
            }
            else
            {
                self.navigationTitle.text = "HOME"
                self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.checkContent()
            }
        }
        
       
                
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let userId = UserDefaults.standard.value(forKey: "userId") as? String
        {
            serviceCall.API_ExistingUserProfile(Id: userId, delegate: self)
        }
        else if let userId = UserDefaults.standard.value(forKey: "userId") as? Int
        {
            serviceCall.API_ExistingUserProfile(Id: "\(userId)", delegate: self)
        }
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                self.navigationTitle.text = "HOME"
                self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.checkContent()
            }
            else if language == "ar"
            {
                self.navigationTitle.text = "الصفحة الرئيسية"
                self.navigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                self.checkContentInArabic()
            }
        }
        else
        {
            self.navigationTitle.text = "HOME"
            self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.checkContent()
        }
    }
    
    func sideMenuFunctions()
    {
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: self)
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                let menuRightNavigationController = UISideMenuNavigationController(rootViewController: self)
                SideMenuManager.default.menuLeftNavigationController = menuRightNavigationController
            }
            else if language == "ar"
            {
                let menuRightNavigationController = UISideMenuNavigationController(rootViewController: self)
                SideMenuManager.default.menuRightNavigationController = menuRightNavigationController
            }
        }
        else
        {
            let menuRightNavigationController = UISideMenuNavigationController(rootViewController: self)
            SideMenuManager.default.menuLeftNavigationController = menuRightNavigationController
        }
        
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuFadeStatusBar = false
    }
    
<<<<<<< HEAD
    func deviceDetails()
    {
        let systemVersion = UIDevice.current.systemVersion
        print("systemVersion", systemVersion)
        
        let modelName = UIDevice.modelName
        print("modelName", modelName)
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        print("appVersion", appVersion)
        
        var countryCode = String()
        var mobileNumber = String()
        if let code = UserDefaults.standard.value(forKey: "countryCode") as? String
        {
            countryCode = code
        }
        
        if let number = UserDefaults.standard.value(forKey: "mobileNumber") as? String
        {
            mobileNumber = number
        }
         print("FCM Token:",Variables.sharedManager.Fcm)
        
        serviceCall.API_InsertDeviceDetails(DeviceId: "", Os: systemVersion, Manufacturer: "Apple", CountryCode: countryCode, PhoneNumber: mobileNumber, Model: modelName, AppVersion: appVersion!, Type: "", Fcm: Variables.sharedManager.Fcm, delegate: self)
    }
    
    func API_CALLBACK_DeviceDetails(deviceDet: NSDictionary)
    {
        print("API_CALLBACK_DeviceDetails", deviceDet)
        
        let responseMsg = deviceDet.object(forKey: "ResponseMsg") as! String
        
        if responseMsg == "Success"
        {
            let result = deviceDet.object(forKey: "Result") as! NSArray
            print("Result:",result)
        }
        else
        {
            let result = deviceDet.object(forKey: "Result") as! String  
            print("Result:",result)
        }
    }
    
=======
   
>>>>>>> 8a4ebb97f5cd647db9c1f66be351c02fc9af0c66
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("ERROR MESSAGE IN HOME PAGE", errorMessage)
        stopActivity()
        applicationDelegate.exitContents()
    }
    
    func API_CALLBACK_ExistingUserProfile(userProfile: NSDictionary)
    {
        print("SELF OF EXISTING USER", userProfile)
        
        let responseMsg = userProfile.object(forKey: "ResponseMsg") as! String
        
        if responseMsg == "Success"
        {
            let result = userProfile.object(forKey: "Result") as! NSArray
            
            if result.count != 0
            {
                imageName = result.value(forKey: "ProfilePicture") as! NSArray
                
                if let imageName = imageName[0] as? String
                {
                    let urlString = serviceCall.baseURL
                    let api = "\(urlString)/Images/BuyerImages/\(imageName)"
                    
                    let apiurl = URL(string: api)
                    
                    if apiurl != nil
                    {
                        //                    userImage.dowloadFromServer(url: apiurl!)
                        
                        downloadImage(from: apiurl!)
                    }
                }
                
                let userName = result.value(forKey: "Name") as! NSArray
                
                if let name = userName[0] as? String
                {
                    UserDefaults.standard.set(name, forKey: "userName")
                }
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                self.userImage.image = UIImage(data: data)
                FileHandler().saveImageDocumentDirectory(image: UIImage(data: data)!)
            }
        }
    }
    
    func checkContent()
    {
        let buttonTitleText = ["NEW ORDER", "BOOK AN APPOINTMENT", "STORE", "REFER AND EARN"]
        let imageName = ["new_order", "appointment", "store", "refer-&-earn"]
        var y1:CGFloat = (10 * yPos)
        
        self.stopActivity()
        for i in 0..<4
        {
            let selectionButton = UIButton()
            selectionButton.frame = CGRect(x: (3 * xPos), y: y1, width: view.frame.width - (6 * xPos), height: (11.175 * yPos))
            selectionButton.layer.cornerRadius = 15
            //            selectionButton.setImage(UIImage(named: "dashboardButton"), for: .normal)
            selectionButton.layer.borderWidth = 1
            selectionButton.layer.borderColor = UIColor.lightGray.cgColor
            selectionButton.backgroundColor = UIColor.white
            selectionButton.tag = i
            selectionButton.addTarget(self, action: #selector(self.selectionButtonAction(sender:)), for: .touchUpInside)
            selectionButton.isUserInteractionEnabled = true
            view.addSubview(selectionButton)
            
            y1 = selectionButton.frame.maxY + yPos
            
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: ((selectionButton.frame.width - (8 * xPos)) / 2), y: yPos, width: (8 * xPos), height: (7 * yPos))
            buttonImage.image = UIImage(named: imageName[i])
            selectionButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 0, y: buttonImage.frame.maxY, width: selectionButton.frame.width, height: (2 * yPos))
            buttonTitle.text = buttonTitleText[i]
            buttonTitle.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 5)
            selectionButton.addSubview(buttonTitle)
        }
        
        blurView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        blurView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
//        view.addSubview(blurView)
        
        var x2:CGFloat = 30
        
        let title = ["Back", "Skip", "Next"]
        
        for i in 0..<3
        {
            let button = UIButton()
            button.frame = CGRect(x: x2, y: view.frame.height - 50, width: 100, height: 40)
            button.backgroundColor = UIColor.blue
            button.setTitle(title[i], for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(self.hintsButtonAction(sender:)), for: .touchUpInside)
            blurView.addSubview(button)
            
            x2 = button.frame.maxX + 10
        }
    }
    
    func checkContentInArabic()
    {
        let buttonTitleText = ["طلب جديد", "حجز موعد", "متجر", "اشير واكسب"]
        let imageName = ["new_order", "appointment", "store", "refer-&-earn"]
        var y1:CGFloat = (10 * yPos)
        
        self.stopActivity()
        
        for i in 0..<4
        {
            let selectionButton = UIButton()
            selectionButton.frame = CGRect(x: (3 * xPos), y: y1, width: view.frame.width - (6 * xPos), height: (11.175 * yPos))
            selectionButton.layer.cornerRadius = 15
            //            selectionButton.setImage(UIImage(named: "dashboardButton"), for: .normal)
            selectionButton.layer.borderWidth = 1
            selectionButton.layer.borderColor = UIColor.lightGray.cgColor
            selectionButton.backgroundColor = UIColor.white
            selectionButton.tag = i
            selectionButton.addTarget(self, action: #selector(self.selectionButtonAction(sender:)), for: .touchUpInside)
            selectionButton.isUserInteractionEnabled = true
            view.addSubview(selectionButton)
            
            y1 = selectionButton.frame.maxY + yPos
            
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: ((selectionButton.frame.width - (8 * xPos)) / 2), y: yPos, width: (8 * xPos), height: (7 * yPos))
            buttonImage.image = UIImage(named: imageName[i])
            selectionButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 0, y: buttonImage.frame.maxY, width: selectionButton.frame.width, height: (2 * yPos))
            buttonTitle.text = buttonTitleText[i]
            buttonTitle.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: x)
            buttonTitle.font = buttonTitle.font.withSize(x)
            selectionButton.addSubview(buttonTitle)
        }
    }
    
    @objc func closeSlideView(gesture : UITapGestureRecognizer)
    {
        slideView.removeFromSuperview()
        slideMB.frame = CGRect(x: 0, y: ((view.frame.height - 65) / 2), width: 30, height: 65)
    }
    
    @objc func selectionButtonAction(sender : UIButton)
    {
        if sender.tag == 0
        {
            Variables.sharedManager.measurementTag = 0
            let newOrderScreen = GenderViewController()
            self.navigationController?.pushViewController(newOrderScreen, animated: true)
        }
        else if sender.tag == 1
        {
            let AppointmentScreen = AppointmentListViewController()
            self.navigationController?.pushViewController(AppointmentScreen, animated: true)
        }
        else if sender.tag == 2
        {
            
        }
        else if sender.tag == 3
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

public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}
