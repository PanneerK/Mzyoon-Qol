//
//  HomeViewController.swift
//  Mzyoon
//
//  Created by QOL on 29/10/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit
import SideMenu

class HomeViewController: CommonViewController, UIGestureRecognizerDelegate, ServerAPIDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    let newOrderView = UIView()
    let slideMenuButton = UIButton()
    var slideView = UIView()
    
    let dressTypeView = UIView()
    let filterButton = UIButton()
    let sortButton = UIButton()
    let searchTextField = UITextField()
    let searchTextTableView = UITableView()

    let serviceCall = ServerAPI()
    
    //GENDER API PARAMETERS
    var genderArray = NSArray()
    var genderIdArray = NSArray()
    var genderInArabicArray = NSArray()
    var genderImageArray = NSArray()
    var convertedGenderImageArray = [UIImage]()
    
    var tempArray = [String]()
    
    //ADD MATERIAL PAGE PARAMETERS
    var materialCount = 10
    var referenceMaterialCount = Int()
    var imagePicker = UIImagePickerController()
    let addMaterialScrolView = UIScrollView()
    let addMaterialImageCollection = UIButton()

    //DRESS TYPE PARAMETERS
    var dressTypeArray = NSArray()
    var dressIdArray = NSArray()
    var dressImageArray = NSArray()
    var convertedDressImageArray = [UIImage]()
    
    //FILTER CONTENTS PARAMETERS
    let filterView = UIView()
    let filterTableView = UITableView()
    let genderTableView = UITableView()
    let occasionTableView = UITableView()
    let occasionView = UIView()
    let priceView = UIView()
    let priceTableView = UITableView()
    let regionView = UIView()
    let regionTableView = UITableView()
    
    //ORDER TYPE PARAMETERS
    let orderTypeView = UIView()

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
    var brandIdArray = NSArray()
    var brandImageArray = NSArray()
    var convertedBrandImageArray = [UIImage]()
    
    //ADD MATERIAL PARAMETERS
    let addMaterialView = UIView()
    let addMaterialImage = UIImageView()

    
    //POSITION
    var xPos:CGFloat!
    var yPos:CGFloat!
    
    // Device Details:
    var UserType:String!
    var Manufacturer:String!
    var DeviceNum:String!
    var Os :String!
    var CountryCode:String!
    var PhoneNumber:String!
    var Model:String!
    var AppVersion:String!
    
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    override func viewDidLoad()
    {
        print("VIEWDIDLOAD")
        
        UserDefaults.standard.set(1, forKey: "screenAppearance")
        
        xPos = 10 / 375 * 100
        xPos = xPos * view.frame.width / 100
        
        yPos = 10 / 667 * 100
        yPos = yPos * view.frame.height / 100
        
        navigationTitle.text = "HOME"
        
        slideMenu()

//        screenContents()
//        basicAPICall()
//        allGestureRecogniser()
        self.tab1Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)

         deviceInformation()
        // DeviceError()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of seconds
            // Your code with delay
            self.checkContent()
            
            
        }
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func deviceInformation()
    {
        print("MODEL", UIDevice.current.model)
        print("SYSTEM NAME", UIDevice.current.systemName)
        print("VERSION", UIDevice.current.systemVersion)
        print("UUID", UIDevice.current.identifierForVendor?.uuidString as Any)
        
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        Os = UIDevice.current.systemName
        Manufacturer = "Apple"
        CountryCode = "12"
        PhoneNumber = "1234567890"
        Model = UIDevice.current.model
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        
        self.serviceCall.API_InsertDeviceDetails(DeviceId: self.DeviceNum, Os: self.Os, Manufacturer: self.Manufacturer, CountryCode: self.CountryCode, PhoneNumber: self.PhoneNumber, Model: self.Model, AppVersion: self.AppVersion, Type: self.UserType, delegate: self)
        
        
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
       // ErrorStr = "Default Error"
        PageNumStr = "HomeViewController"
      //  MethodName = "do"
        
        print("UUID", UIDevice.current.identifierForVendor?.uuidString as Any)
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
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
    }
    
    func slideMenu()
    {
        let slideScreen = SlideViewController()
        let leftSlideScreen = UISideMenuNavigationController(rootViewController: slideScreen)
        SideMenuManager.default.menuLeftNavigationController = leftSlideScreen
    }
    
    func allGestureRecogniser()
    {
        let closeSlideViewGesture = UITapGestureRecognizer(target: self, action: #selector(self.closeSlideView(gesture:)))
        closeSlideViewGesture.delegate = self
//        view.addGestureRecognizer(closeSlideViewGesture)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.slideViewOpenGesture))
        leftSwipe.direction = .right
        leftSwipe.delegate = self
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.slideViewCloseGesture(gesture:)))
        rightSwipe.direction = .left
        rightSwipe.delegate = self
        view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func closeSlideView(gesture : UITapGestureRecognizer)
    {
        slideView.removeFromSuperview()
        slideMenuButton.frame = CGRect(x: 0, y: ((view.frame.height - 65) / 2), width: 30, height: 65)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("VIEWWILLAPPEAR")
        super.viewWillAppear(true)
        newOrderView.removeFromSuperview()
        
        if let screen = UserDefaults.standard.value(forKey: "screenValue") as? Int{
            if screen == 1
            {
                addMaterialContent()
            }
            else
            {
                
            }
        }
    }
    
  //    override func viewWillDisappear(_ animated: Bool)
  //    {
  //        super.viewWillDisappear(true)
  //        // Hide the Navigation Bar
  //        self.navigationController?.isNavigationBarHidden = true
  //    }
    
    func basicAPICall()
    {
        serviceCall.API_Gender(delegate: self)
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("FAILED", errorNumber, errorMessage)
    }
    
    func API_CALLBACK_DeviceDetails(deviceDet: NSDictionary)
    {
        let ResponseMsg = deviceDet.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = deviceDet.object(forKey: "Result") as! String
            print("Result", Result)
        }
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
    
func API_CALLBACK_Gender(gender: NSDictionary)
{
        print("GENDER", gender)
    let ResponseMsg = gender.object(forKey: "ResponseMsg") as! String
        
    if ResponseMsg == "Success"
    {
        
        let result = gender.object(forKey: "Result") as! NSArray
        print("result", result)
        
        genderArray = result.value(forKey: "gender") as! NSArray
        print("genderResult", genderArray)
        
        genderImageArray = result.value(forKey: "ImageURL") as! NSArray
        print("ImageURL", genderImageArray)
        
        genderIdArray = result.value(forKey: "Id") as! NSArray
        print("Id", genderIdArray)
        
        genderInArabicArray = result.value(forKey: "GenderInArabic") as! NSArray
        print("GenderInArabic", genderInArabicArray)
        
        
        for i in 0..<genderImageArray.count
        {
            if let imageName = genderImageArray[i] as? String
            {
                let api = "http://appsapi.mzyoon.com/images/\(imageName)"
                let apiurl = URL(string: api)
                
                if let data = try? Data(contentsOf: apiurl!) {
                    print("DATA OF IMAGE", data)
                    if let image = UIImage(data: data) {
                        self.convertedGenderImageArray.append(image)
                    }
                }
                else
                {
                    let emptyImage = UIImage(named: "empty")
                    self.convertedGenderImageArray.append(emptyImage!)
                }
            }
            else if let imgName = genderImageArray[i] as? NSNull
            {
                let emptyImage = UIImage(named: "empty")
                self.convertedGenderImageArray.append(emptyImage!)
            }
         }
   }
  else if ResponseMsg == "Failure"
  {
        let Result = gender.object(forKey: "Result") as! String
        print("Result", Result)
        
        MethodName = "GetGenders"
        ErrorStr = Result
        DeviceError()
  }
 }
 
 func API_CALLBACK_DressType(dressType: NSDictionary)
 {
        
        let ResponseMsg = dressType.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = dressType.object(forKey: "Result") as! NSArray
            print("Result", Result)
            
            dressTypeArray = Result.value(forKey: "DressTypeInEnglish") as! NSArray
            print("DressTypeInEnglish", dressTypeArray)
            
            dressIdArray = Result.value(forKey: "Id") as! NSArray
            print("Id", dressIdArray)
            
            dressImageArray = Result.value(forKey: "ImageURL") as! NSArray
            print("ImageURL", dressImageArray)
            
            for i in 0..<dressImageArray.count
            {
                if let imageName = dressImageArray[i] as? String
                {
                    let api = "http://192.168.0.21/TailorAPI/images/DressTypes/\(imageName)"
                    let apiurl = URL(string: api)
                    
                    if let data = try? Data(contentsOf: apiurl!) {
                        print("DATA OF IMAGE", data)
                        if let image = UIImage(data: data) {
                            self.convertedDressImageArray.append(image)
                        }
                    }
                    else
                    {
                        let emptyImage = UIImage(named: "empty")
                        self.convertedDressImageArray.append(emptyImage!)
                    }
                }
                else if let imgName = dressImageArray[i] as? NSNull
                {
                    let emptyImage = UIImage(named: "empty")
                    self.convertedDressImageArray.append(emptyImage!)
                }
            }
             dressTypeContent()
        }
        else if ResponseMsg == "Failure"
        {
            let Result = dressType.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetDressTypeByGender"
            ErrorStr = Result
            DeviceError()
    }
    
}
    
    func API_CALLBACK_Customization1(custom1: NSDictionary)
    {
        print("CUSTOMIZATION 1", custom1)
        
        let ResponseMsg = custom1.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            print("VERY GOOD")
            let Result = custom1.object(forKey: "Result") as! NSDictionary
            
            let materialBrand = Result.object(forKey: "materialBrand") as! NSArray
            let BrandInArabic = materialBrand.value(forKey: "BrandInArabic") as! NSArray
            brandNameArray = materialBrand.value(forKey: "BrandInEnglish") as! NSArray
            brandIdArray = materialBrand.value(forKey: "Id") as! NSArray
            brandImageArray = materialBrand.value(forKey: "Image") as! NSArray
            
            for i in 0..<brandImageArray.count
            {
                if let imageName = brandImageArray[i] as? String
                {
                    let api = "http://192.168.0.21/TailorAPI/images/Brands/\(imageName)"
                    print("CUSTOM ALL", api)
                    let apiurl = URL(string: api)
                    
                    if let data = try? Data(contentsOf: apiurl!) {
                        print("DATA OF IMAGE", data)
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
            }
            
            let placeofIndustrys = Result.object(forKey: "placeofIndustrys") as! NSArray
            let PlaceInArabic = placeofIndustrys.value(forKey: "PlaceInArabic") as! NSArray
            industryNameArray = placeofIndustrys.value(forKey: "PlaceInEnglish") as! NSArray
            industryIdArray = placeofIndustrys.value(forKey: "Id") as! NSArray
            industryImageArray = placeofIndustrys.value(forKey: "Image") as! NSArray
            
            for i in 0..<industryImageArray.count
            {
                if let imageName = industryImageArray[i] as? String
                {
                    let api = "http://192.168.0.21/TailorAPI/images/PlaceOfIndustry/\(imageName)"
                    print("CUSTOM ALL", api)
                    let apiurl = URL(string: api)
                    
                    if let data = try? Data(contentsOf: apiurl!) {
                        print("DATA OF IMAGE", data)
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
            }
            
            
            let seasons = Result.object(forKey: "seasons") as! NSArray
            let SeasonInArabic = seasons.value(forKey: "SeasonInArabic") as! NSArray
            seasonalNameArray = seasons.value(forKey: "SeasonInEnglish") as! NSArray
            seasonalIdArray = seasons.value(forKey: "Id") as! NSArray
            seasonalImageArray = seasons.value(forKey: "Image") as! NSArray
            
            for i in 0..<seasonalImageArray.count
            {
                if let imageName = seasonalImageArray[i] as? String
                {
                    let api = "http://192.168.0.21/TailorAPI/images/Seasons/\(imageName)"
                    print("CUSTOM ALL", api)
                    let apiurl = URL(string: api)
                    
                    if let data = try? Data(contentsOf: apiurl!) {
                        print("DATA OF IMAGE", data)
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
            }
            
            customization1Content()
        }
        else if ResponseMsg == "Failure"
        {
            let Result = custom1.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetCustomization1"
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func toGetImage(sendArray : NSArray, pathExtension : String) -> [UIImage]
    {
        var imageArray = [UIImage]()
    
        for i in 0..<sendArray.count
        {
            if let imageName = sendArray[i] as? String
            {
                let api = "http://192.168.0.21/TailorAPI/images/Customization1/\(imageName)"
                print("CUSTOM ALL", api)
                let apiurl = URL(string: api)
                
                if let data = try? Data(contentsOf: apiurl!) {
                    print("DATA OF IMAGE", data)
                    if let image = UIImage(data: data) {
                        imageArray.append(image)
                    }
                }
                else
                {
                    let emptyImage = UIImage(named: "empty")
                    imageArray.append(emptyImage!)
                }
            }
            else if let imgName = sendArray[i] as? NSNull
            {
                let emptyImage = UIImage(named: "empty")
                imageArray.append(emptyImage!)
            }
        }
    
        return imageArray
    }
    
    func screenContents()
    {
        /*let backgroundImage = UIImageView()
        backgroundImage.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        backgroundImage.image = UIImage(named: "background")
        view.addSubview(backgroundImage)
        
        let navigationBar = UIView()
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        navigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        view.addSubview(navigationBar)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2 * y), width: navigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "HOME"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        navigationBar.addSubview(navigationTitle)
        
        let userImage = UIImageView()
        userImage.frame = CGRect(x: (2 * x), y: (2 * y), width: 40, height: 40)
        userImage.image = UIImage(named: "women")
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.layer.masksToBounds = true
        navigationBar.addSubview(userImage)
        
        let userName = UILabel()
        userName.frame = CGRect(x: userImage.frame.maxX + x, y: navigationTitle.frame.maxY + y, width: navigationBar.frame.width - 200, height: (2 * y))
        userName.text = "Hi, Noorul"
        userName.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        userName.textAlignment = .left
        userName.textColor = UIColor.white
//        navigationBar.addSubview(userName)
        
        let notificationButton = UIButton()
        notificationButton.frame = CGRect(x: navigationBar.frame.width - 50, y: navigationTitle.frame.minY, width: 30, height: 30)
        notificationButton.setImage(UIImage(named: "notification"), for: .normal)
//        notificationButton.addTarget(self, action: #selector(self.selectionButtonAction(sender:)), for: .touchUpInside)
        navigationBar.addSubview(notificationButton)
        
        slideMenuButton.frame = CGRect(x: 0, y: ((view.frame.height - 65) / 2), width: 30, height: 65)
        slideMenuButton.setImage(UIImage(named: "sidemenu"), for: .normal)
        slideMenuButton.addTarget(self, action: #selector(self.slideMenuButtonAction(sender:)), for: .touchUpInside)
//        view.addSubview(slideMenuButton)*/
        
        let buttonTitleText = ["NEW ORDER", "BOOK AN APPOINTMENT", "STORE", "REFER AND EARN"]
        let imageName = ["new_order", "appointment", "store", "refer-&-earn"]
        var y1:CGFloat = navigationBar.frame.maxY + (4 * y)
        
        for i in 0..<4
        {
            let selectionButton = UIButton()
            selectionButton.frame = CGRect(x: (3 * x), y: y1, width: view.frame.width - (6 * x), height: (11.175 * y))
            selectionButton.layer.cornerRadius = 15
            selectionButton.setImage(UIImage(named: "dashboardButton"), for: .normal)
            selectionButton.tag = i
            selectionButton.addTarget(self, action: #selector(self.selectionButtonAction(sender:)), for: .touchUpInside)
            backgroundImage.addSubview(selectionButton)
            
            y1 = selectionButton.frame.maxY + y
            
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: ((selectionButton.frame.width - (8 * x)) / 2), y: y, width: (8 * x), height: (7 * y))
            buttonImage.image = UIImage(named: imageName[i])
            selectionButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 0, y: buttonImage.frame.maxY, width: selectionButton.frame.width, height: (2 * y))
            buttonTitle.text = buttonTitleText[i]
            buttonTitle.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 5)
            selectionButton.addSubview(buttonTitle)
        }
    }
    
    /*@objc func slideMenuButtonAction(sender : UIButton)
    {
        slideView = SlideMenuView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
//        self.view.addSubview(slideView)
        
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }*/
    
    @objc func slideViewOpenGesture(gesture : UISwipeGestureRecognizer)
    {
        slideView = SlideMenuView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        self.view.addSubview(slideView)
    }
    
    @objc func slideViewCloseGesture(gesture : UISwipeGestureRecognizer)
    {
        slideView.removeFromSuperview()
    }
    
    @objc func selectionButtonAction(sender : UIButton)
    {
        if sender.tag == 0
        {
            print("NEW ORDER")
//            newOrderContents()
            let newOrderScreen = GenderViewController()
            self.navigationController?.pushViewController(newOrderScreen, animated: true)
        }
        else if sender.tag == 1
        {
            print("BOOK AN APPOINTMENT")
        }
        else if sender.tag == 2
        {
            print("STORE")
        }
        else if sender.tag == 3
        {
            print("REFER AND EARN")
        }
    }
    
    func newOrderContents()
    {
        newOrderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        newOrderView.backgroundColor = UIColor.white
        view.addSubview(newOrderView)
        
        self.view.bringSubviewToFront(slideMenuButton)
        
        let newOrderNavigationBar = UIView()
        newOrderNavigationBar.frame = CGRect(x: 0, y: 0, width: newOrderView.frame.width, height: (6.4 * y))
        newOrderNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        newOrderView.addSubview(newOrderNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 1
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        newOrderNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: newOrderNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "GENDER"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        newOrderNavigationBar.addSubview(navigationTitle)
        
        
        var x1:CGFloat = (3 * x)
        var y1:CGFloat = newOrderNavigationBar.frame.maxY + (10.65 * y)
        
        for i in 0..<genderArray.count
        {
            let genderButton = UIButton()
            if i % 2 == 0
            {
                genderButton.frame = CGRect(x: x1, y: y1, width: (14.75 * x), height: (16 * y))
                x1 = genderButton.frame.maxX + (2 * x)
            }
            else
            {
                genderButton.frame = CGRect(x: x1, y: y1, width: (14.75 * x), height: (16 * y))
                y1 = genderButton.frame.maxY + (2 * y)
                x1 = (3 * x)
            }
//            genderButton.backgroundColor = UIColor.lightGray
            genderButton.setImage(UIImage(named: "genderBackground"), for: .normal)
            genderButton.tag = i + 1
            genderButton.addTarget(self, action: #selector(self.genderButtonAction(sender:)), for: .touchUpInside)
            newOrderView.addSubview(genderButton)
            
            let buttonImage = UIImageView()
            if i == 0
            {
                buttonImage.frame = CGRect(x: (2 * x), y: (2 * y), width: genderButton.frame.width - (4 * x), height: genderButton.frame.height - (4 * y))
            }
            else if i == 1
            {
                buttonImage.frame = CGRect(x: (3 * x), y: (2 * y), width: genderButton.frame.width - (6 * x), height: genderButton.frame.height - (4 * y))
            }
            else
            {
                buttonImage.frame = CGRect(x: (4 * x), y: (2 * y), width: genderButton.frame.width - (8 * x), height: genderButton.frame.height - (4 * y))
            }
            
            buttonImage.image = convertedGenderImageArray[i]
            genderButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 2, y: genderButton.frame.height - (3 * y), width: genderButton.frame.width - 4, height: (3 * y))
            buttonTitle.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.text = genderArray[i] as! String
            buttonTitle.textColor = UIColor.white
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 10)
            genderButton.addSubview(buttonTitle)
        }
    }
    
    @objc func genderButtonAction(sender : UIButton)
    {
        serviceCall.API_DressType(genderId: sender.tag, delegate: self)
        
        if sender.tag == 1
        {
            print("MEN")
//            dressTypeContent()
        }
        else if sender.tag == 2
        {
            print("WOMEN")
        }
        else if sender.tag == 3
        {
            print("BOY")
        }
        else if sender.tag == 4
        {
            print("GIRL")
        }
    }
    
    func dressTypeContent()
    {
        for view in dressTypeView.subviews {
            view.removeFromSuperview()
        }
        
        dressTypeView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        dressTypeView.backgroundColor = UIColor.white
        view.addSubview(dressTypeView)
        
        self.view.bringSubviewToFront(slideMenuButton)
        
        let dressTypeNavigationBar = UIView()
        dressTypeNavigationBar.frame = CGRect(x: 0, y: 0, width: newOrderView.frame.width, height: (6.4 * y))
        dressTypeNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        dressTypeView.addSubview(dressTypeNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        backButton.tag = 2
        dressTypeNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: dressTypeNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "DRESS TYPE"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        dressTypeNavigationBar.addSubview(navigationTitle)
        
        searchTextField.frame = CGRect(x: 0, y: dressTypeNavigationBar.frame.maxY, width: view.frame.width - 50, height: 40)
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.orange.cgColor
        searchTextField.placeholder = "Search"
        searchTextField.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        searchTextField.textAlignment = .left
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: searchTextField.frame.height))
        searchTextField.leftView = paddingView
        searchTextField.leftViewMode = UITextField.ViewMode.always
        searchTextField.adjustsFontSizeToFitWidth = true
        searchTextField.keyboardType = .default
        searchTextField.clearsOnBeginEditing = true
        searchTextField.returnKeyType = .done
        searchTextField.delegate = self
        dressTypeView.addSubview(searchTextField)
        
        let searchButton = UIButton()
        searchButton.frame = CGRect(x: view.frame.width - 51, y: 0, width: 50, height: 40)
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.orange.cgColor
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        searchTextField.addSubview(searchButton)

        filterButton.frame = CGRect(x: 0, y: searchTextField.frame.maxY, width: (view.frame.width / 2) - 1, height: 40)
        filterButton.backgroundColor = UIColor.lightGray
        filterButton.setTitle("FILTER", for: .normal)
        filterButton.setTitleColor(UIColor.black, for: .normal)
        filterButton.tag = 1
        filterButton.addTarget(self, action: #selector(self.featuresButtonAction(sender:)), for: .touchUpInside)
        dressTypeView.addSubview(filterButton)
        
        let downArrow1 = UIImageView()
        downArrow1.frame = CGRect(x: filterButton.frame.maxX - (5 * x), y: y, width: (2 * x), height: (2 * y))
        downArrow1.image = UIImage(named: "downArrow")
        filterButton.addSubview(downArrow1)
        
        sortButton.frame = CGRect(x: filterButton.frame.maxX + 1, y: searchTextField.frame.maxY, width: (view.frame.width / 2), height: 40)
        sortButton.backgroundColor = UIColor.lightGray
        sortButton.setTitle("SORT", for: .normal)
        sortButton.setTitleColor(UIColor.black, for: .normal)
        sortButton.tag = 2
        sortButton.addTarget(self, action: #selector(self.featuresButtonAction(sender:)), for: .touchUpInside)
        dressTypeView.addSubview(sortButton)
        
        let downArrow2 = UIImageView()
        downArrow2.frame = CGRect(x: filterButton.frame.maxX - (5 * x), y: y, width: (2 * x), height: (2 * y))
        downArrow2.image = UIImage(named: "downArrow")
        sortButton.addSubview(downArrow2)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: view.frame.width / 2.70, height: view.frame.width / 2.25)
        
        let dressTypeCollectionView = UICollectionView(frame: CGRect(x: (3 * x), y: filterButton.frame.maxY + (2 * y), width: view.frame.width - (6 * x), height: view.frame.height - (18 * y)), collectionViewLayout: layout)
//        dressTypeCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        dressTypeCollectionView.register(DressTypeCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(DressTypeCollectionViewCell.self))
        dressTypeCollectionView.dataSource = self
        dressTypeCollectionView.delegate = self
        dressTypeCollectionView.backgroundColor = UIColor.clear
        dressTypeCollectionView.isUserInteractionEnabled = true
        dressTypeCollectionView.allowsMultipleSelection = false
        dressTypeCollectionView.allowsSelection = true
        dressTypeCollectionView.selectItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.top)
//        dressTypeView.addSubview(dressTypeCollectionView)
        
        let dressTypeScrollView = UIScrollView()
        dressTypeScrollView.frame = CGRect(x: 0, y: sortButton.frame.maxY + (2 * y), width: view.frame.width, height: (45 * y))
        dressTypeView.addSubview(dressTypeScrollView)
        
        var y1:CGFloat = 0
        var x1 = (2 * x)
        for i in 0..<dressTypeArray.count
        {
            let dressTypeButton = UIButton()
            if i % 2 == 0
            {
                dressTypeButton.frame = CGRect(x: (2.5 * x), y: y1, width: (15.75 * x), height: (17 * y))
            }
            else
            {
                dressTypeButton.frame = CGRect(x: x1, y: y1, width: (15.75 * x), height: (17 * y))
                y1 = dressTypeButton.frame.maxY + y
            }
            dressTypeButton.backgroundColor = UIColor.clear
            dressTypeButton.addTarget(self, action: #selector(self.dressTypeButtonAction(sender:)), for: .touchUpInside)
            dressTypeScrollView.addSubview(dressTypeButton)
            
            x1 = dressTypeButton.frame.maxX + x
            
            let dressTypeImageView = UIImageView()
            dressTypeImageView.frame = CGRect(x: 0, y: 0, width: dressTypeButton.frame.width, height: (14 * y))
            dressTypeImageView.image = convertedDressImageArray[i]
            dressTypeButton.addSubview(dressTypeImageView)
            
            let dressTypeNameLabel = UILabel()
            dressTypeNameLabel.frame = CGRect(x: 0, y: dressTypeImageView.frame.maxY, width: dressTypeButton.frame.width, height: (3 * y))
            dressTypeNameLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            dressTypeNameLabel.text = dressTypeArray[i] as? String
            dressTypeNameLabel.textColor = UIColor.white
            dressTypeNameLabel.textAlignment = .center
            dressTypeButton.addSubview(dressTypeNameLabel)
        }
        dressTypeScrollView.contentSize.height = y1 + (20 * y)
    }
    
    @objc func dressTypeButtonAction(sender : UIButton)
    {
        dressTypeView.removeFromSuperview() 
        orderTypeContent()
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        if sender.tag == 1
        {
            newOrderView.removeFromSuperview()
        }
        else if sender.tag == 2
        {
            dressTypeView.removeFromSuperview()
            filterTableView.removeFromSuperview()
            occasionTableView.removeFromSuperview()
        }
        else if sender.tag == 3
        {
            orderTypeView.removeFromSuperview()
            dressTypeContent()
        }
        else if sender.tag == 4
        {
            addMaterialView.removeFromSuperview()
            orderTypeContent()
        }
        else if sender.tag == 5
        {
            orderTypeContent()
            customization1View.removeFromSuperview()
        }
    }
    
    @objc func featuresButtonAction(sender : UIButton)
    {
        if sender.tag == 1
        {
            sortButton.backgroundColor = UIColor.lightGray
            sortButton.setTitleColor(UIColor.black, for: .normal)
            
            if sender.backgroundColor == UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            {
                filterTableView.removeFromSuperview()
                genderTableView.removeFromSuperview()
                occasionView.removeFromSuperview()
                priceView.removeFromSuperview()
                regionView.removeFromSuperview()
                sender.backgroundColor = UIColor.lightGray
                sender.setTitleColor(UIColor.black, for: .normal)
            }
            else
            {
                sender.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
                sender.setTitleColor(UIColor.white, for: .normal)
                filterContents()
                
//                let filterScreen = FilterViewController()
//                self.navigationController?.pushViewController(filterScreen, animated: true)
            }
        }
        else
        {
            filterButton.backgroundColor = UIColor.lightGray
            filterButton.setTitleColor(UIColor.black, for: .normal)
            filterTableView.removeFromSuperview()
            genderTableView.removeFromSuperview()
            occasionView.removeFromSuperview()
            priceView.removeFromSuperview()
            regionView.removeFromSuperview()
            
            sortFunc()
        }
        
    }
    
    func filterContents()
    {
        filterView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        filterView.backgroundColor = UIColor.white
        view.addSubview(filterView)
        view.bringSubviewToFront(filterView)
        
        let filterNavigationBar = UIView()
        filterNavigationBar.frame = CGRect(x: 0, y: 0, width: newOrderView.frame.width, height: (6.4 * y))
        filterNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        filterView.addSubview(filterNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(self.filterBackButtonAction(sender:)), for: .touchUpInside)
        backButton.tag = 2
        filterNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: filterNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "FILTERS"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        filterNavigationBar.addSubview(navigationTitle)

        filterTableView.frame = CGRect(x: 0, y: filterNavigationBar.frame.maxY, width: filterView.frame.width, height: (20 * y))
        filterTableView.register(FilterTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(FilterTableViewCell.self))
        filterTableView.dataSource = self
        filterTableView.delegate = self
        filterView.addSubview(filterTableView)
    }
    
    @objc func filterBackButtonAction(sender : UIButton)
    {
        filterView.removeFromSuperview()
        filterButton.backgroundColor = UIColor.lightGray
        filterButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    func genderContent()
    {
        filterTableView.removeFromSuperview()
        
        genderTableView.frame = CGRect(x: 0, y: (6.4 * y), width: filterView.frame.width, height: (19 * y))
        genderTableView.register(GenderTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(GenderTableViewCell.self))
        genderTableView.dataSource = self
        genderTableView.delegate = self
        view.addSubview(genderTableView)
    }
    
    func occasionContent()
    {
        filterTableView.removeFromSuperview()
        
        occasionView.frame = CGRect(x: 0, y: filterButton.frame.maxY, width: view.frame.width, height: view.frame.height - (19 * y))
        occasionView.backgroundColor = UIColor.white
        view.addSubview(occasionView)
        
        occasionTableView.frame = CGRect(x: 0, y: 0, width: occasionView.frame.width, height: (37 * y))
        occasionTableView.register(GenderTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(GenderTableViewCell.self))
        occasionTableView.dataSource = self
        occasionTableView.delegate = self
        occasionView.addSubview(occasionTableView)
        
        let occasionResetButton = UIButton()
        occasionResetButton.frame = CGRect(x: x, y: occasionView.frame.height - (5 * y), width: (10 * x), height: (3 * y))
        occasionResetButton.backgroundColor = UIColor.lightGray
        occasionResetButton.setTitle("RESET", for: .normal)
        occasionResetButton.setTitleColor(UIColor.black, for: .normal)
        occasionView.addSubview(occasionResetButton)
        
        let occasionApplyButton = UIButton()
        occasionApplyButton.frame = CGRect(x: occasionView.frame.width - (11 * x), y: occasionView.frame.height - (5 * y), width: (10 * x), height: (3 * y))
        occasionApplyButton.backgroundColor = UIColor.lightGray
        occasionApplyButton.setTitle("APPLY", for: .normal)
        occasionApplyButton.setTitleColor(UIColor.black, for: .normal)
        occasionView.addSubview(occasionApplyButton)
    }
    
    func priceContent()
    {
        filterTableView.removeFromSuperview()
        
        priceView.frame = CGRect(x: 0, y: filterButton.frame.maxY, width: view.frame.width, height: view.frame.height - (19 * y))
        priceView.backgroundColor = UIColor.white
        view.addSubview(priceView)
        
        priceTableView.frame = CGRect(x: 0, y: 0, width: priceView.frame.width, height: (37 * y))
        priceTableView.register(GenderTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(GenderTableViewCell.self))
        priceTableView.dataSource = self
        priceTableView.delegate = self
        priceView.addSubview(priceTableView)
        
        let priceResetButton = UIButton()
        priceResetButton.frame = CGRect(x: x, y: priceView.frame.height - (5 * y), width: (10 * x), height: (3 * y))
        priceResetButton.backgroundColor = UIColor.lightGray
        priceResetButton.setTitle("RESET", for: .normal)
        priceResetButton.setTitleColor(UIColor.black, for: .normal)
        priceView.addSubview(priceResetButton)
        
        let priceApplyButton = UIButton()
        priceApplyButton.frame = CGRect(x: priceView.frame.width - (11 * x), y: priceView.frame.height - (5 * y), width: (10 * x), height: (3 * y))
        priceApplyButton.backgroundColor = UIColor.lightGray
        priceApplyButton.setTitle("APPLY", for: .normal)
        priceApplyButton.setTitleColor(UIColor.black, for: .normal)
        priceView.addSubview(priceApplyButton)
    }
    
    func regionContent()
    {
        filterTableView.removeFromSuperview()
        
        regionView.frame = CGRect(x: 0, y: filterButton.frame.maxY, width: view.frame.width, height: view.frame.height - (19 * y))
        regionView.backgroundColor = UIColor.white
        view.addSubview(regionView)
        
        regionTableView.frame = CGRect(x: 0, y: 0, width: regionView.frame.width, height: (37 * y))
        regionTableView.register(GenderTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(GenderTableViewCell.self))
        regionTableView.dataSource = self
        regionTableView.delegate = self
        regionView.addSubview(regionTableView)
        
        let priceResetButton = UIButton()
        priceResetButton.frame = CGRect(x: x, y: regionView.frame.height - (5 * y), width: (10 * x), height: (3 * y))
        priceResetButton.backgroundColor = UIColor.lightGray
        priceResetButton.setTitle("RESET", for: .normal)
        priceResetButton.setTitleColor(UIColor.black, for: .normal)
        regionView.addSubview(priceResetButton)
        
        let priceApplyButton = UIButton()
        priceApplyButton.frame = CGRect(x: regionView.frame.width - (11 * x), y: regionView.frame.height - (5 * y), width: (10 * x), height: (3 * y))
        priceApplyButton.backgroundColor = UIColor.lightGray
        priceApplyButton.setTitle("APPLY", for: .normal)
        priceApplyButton.setTitleColor(UIColor.black, for: .normal)
        regionView.addSubview(priceApplyButton)
    }
    
    @objc func sortFunc()
    {
        let alert = UIAlertController(title: "SORT BY", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Popularity", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Price -- Low to High", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Price -- High to Low", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Newest First", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: sortCancelAction(action:)))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func sortCancelAction(action : UIAlertAction)
    {
        sortButton.backgroundColor = UIColor.lightGray
        sortButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    
    func customization1Content()
    {
        customization1View.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        customization1View.backgroundColor = UIColor.white
        view.addSubview(customization1View)
        
        let customization1NavigationBar = UIView()
        customization1NavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        customization1NavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        customization1View.addSubview(customization1NavigationBar)
        
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
        
        let custom1Title = ["SEASONAL", "PLACE OF INDUSTRY", "BRAND"]
        
        var y1 = customization1NavigationBar.frame.maxY + y
        
        for i in 0..<custom1Title.count
        {
            let custom1Image = UIImageView()
            custom1Image.frame = CGRect(x: (4 * x), y: y1, width: view.frame.width - (8 * x), height: (3 * y))
            custom1Image.image = UIImage(named: "dashboardButton")
            customization1View.addSubview(custom1Image)
            
            let titleLabel = UILabel()
            titleLabel.frame = CGRect(x: 2, y: 2, width: custom1Image.frame.width - 4, height: custom1Image.frame.height - 4)
            titleLabel.text = custom1Title[i]
            titleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            titleLabel.textAlignment = .center
            custom1Image.addSubview(titleLabel)
            
            y1 = custom1Image.frame.maxY + (14 * y)
        }
        
        let seasonalScrollView = UIScrollView()
        seasonalScrollView.frame = CGRect(x: 0, y: (10.5 * y), width: view.frame.width, height: (12 * y))
        seasonalScrollView.contentSize.width = view.frame.width * 1.55
        customization1View.addSubview(seasonalScrollView)
        
        let buttonTitleText = ["Summer", "Autumn", "Winter", "Spring"]
        let imageName = ["men", "women", "boy", "girl"]
        var x1:CGFloat = (2 * x)
        
        for i in 0..<seasonalNameArray.count
        {
            let seasonalButton = UIButton()
            seasonalButton.frame = CGRect(x: x1, y: y, width: (12 * x), height: (10 * y))
            seasonalButton.tag = i
            seasonalScrollView.addSubview(seasonalButton)
            
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: 0, y: 0, width: seasonalButton.frame.width, height: seasonalButton.frame.height - (2 * y))
            buttonImage.image = convertedSeasonalImageArray[i]
            seasonalButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 0, y: seasonalButton.frame.height - (2 * y), width: seasonalButton.frame.width, height: (2 * y))
            buttonTitle.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.text = seasonalNameArray[i] as? String
            buttonTitle.textColor = UIColor.white
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 10)
            seasonalButton.addSubview(buttonTitle)
            
            x1 = seasonalButton.frame.maxX + (2 * x)
        }
        
        let industryScrollView = UIScrollView()
        industryScrollView.frame = CGRect(x: 0, y: seasonalScrollView.frame.maxY + (5 * y), width: view.frame.width, height: (12 * y))
        industryScrollView.contentSize.width = view.frame.width * 1.55
        customization1View.addSubview(industryScrollView)
        
        var x3:CGFloat = (2 * x)
        for i in 0..<industryNameArray.count
        {
            let industryButton = UIButton()
            industryButton.frame = CGRect(x: x3, y: y, width: (12 * x), height: (10 * y))
            industryButton.tag = i
            industryScrollView.addSubview(industryButton)
            
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: 0, y: 0, width: industryButton.frame.width, height: industryButton.frame.height - (2 * y))
            buttonImage.image = convertedIndustryImageArray[i]
            industryButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 0, y: industryButton.frame.height - (2 * y), width: industryButton.frame.width, height: (2 * y))
            buttonTitle.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.text = industryNameArray[i] as! String
            buttonTitle.textColor = UIColor.white
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 10)
            industryButton.addSubview(buttonTitle)
            
            x3 = industryButton.frame.maxX + (2 * x)
        }
        
        let brandScrollView = UIScrollView()
        brandScrollView.frame = CGRect(x: 0, y: industryScrollView.frame.maxY + (5 * y), width: view.frame.width, height: (12 * y))
        brandScrollView.contentSize.width = view.frame.width * 1.55
        customization1View.addSubview(brandScrollView)
        
        var x2:CGFloat = (2 * x)
        for i in 0..<brandNameArray.count
        {
            let brandButton = UIButton()
            brandButton.frame = CGRect(x: x2, y: y, width: (12 * x), height: (10 * y))
            brandButton.tag = i
            brandScrollView.addSubview(brandButton)
            
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: 0, y: 0, width: brandButton.frame.width, height: brandButton.frame.height - (2 * y))
            buttonImage.image = convertedBrandImageArray[i]
            brandButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 0, y: brandButton.frame.height - (2 * y), width: brandButton.frame.width, height: (2 * y))
            buttonTitle.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.text = brandNameArray[i] as! String
            buttonTitle.textColor = UIColor.white
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 10)
            brandButton.addSubview(buttonTitle)
            
            x2 = brandButton.frame.maxX + (2 * x)
        }
        
        let customization1NextButton = UIButton()
        customization1NextButton.frame = CGRect(x: view.frame.width - (5 * x), y: brandScrollView.frame.maxY, width: (4 * x), height: (4 * y))
        customization1NextButton.backgroundColor = UIColor.red
        customization1View.addSubview(customization1NextButton)
    }
    
    func customization2Content()
    {
        let customization2View = UIView()
        customization2View.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        customization2View.backgroundColor = UIColor.white
        view.addSubview(customization2View)
        
        let customization2NavigationBar = UIView()
        customization2NavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        customization2NavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        customization2View.addSubview(customization2NavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        backButton.tag = 3
        customization2NavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: customization2NavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "CUSTOMIZATION-2"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        customization2NavigationBar.addSubview(navigationTitle)
        
        let custom1Title = ["MATERIAL TYPE", "COLOR", "PATTERN"]
        
        var y1 = customization2NavigationBar.frame.maxY + (2 * y)
        
        for i in 0..<custom1Title.count
        {
            let custom1Image = UIImageView()
            custom1Image.frame = CGRect(x: (4 * x), y: y1, width: view.frame.width - (8 * x), height: (3 * y))
            custom1Image.image = UIImage(named: "dashboardButton")
            customization2View.addSubview(custom1Image)
            
            let titleLabel = UILabel()
            titleLabel.frame = CGRect(x: 2, y: 2, width: custom1Image.frame.width - 4, height: custom1Image.frame.height - 4)
            titleLabel.text = custom1Title[i]
            titleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            titleLabel.textAlignment = .center
            custom1Image.addSubview(titleLabel)
            
            y1 = custom1Image.frame.maxY + (14 * y)
        }
        
        let seasonalScrollView = UIScrollView()
        seasonalScrollView.frame = CGRect(x: 0, y: (12.4 * y), width: view.frame.width, height: (12 * y))
        seasonalScrollView.contentSize.width = view.frame.width * 1.55
        customization2View.addSubview(seasonalScrollView)
        
        let buttonTitleText = ["All Material Type", "Fabric", "Synthetic", "Coton"]
        let imageName = ["All Color", "Red", "Green", "Black"]
        var x1:CGFloat = (2 * x)
        
        for i in 0..<4
        {
            let seasonalButton = UIButton()
            seasonalButton.frame = CGRect(x: x1, y: y, width: (12 * x), height: (10 * y))
            seasonalButton.setImage(UIImage(named: "genderBackground"), for: .normal)
            seasonalButton.tag = i
            seasonalScrollView.addSubview(seasonalButton)
            
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: (2 * x), y: (2 * y), width: seasonalButton.frame.width - (4 * x), height: seasonalButton.frame.height - (4 * y))
            buttonImage.image = UIImage(named: imageName[i])
            seasonalButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 2, y: seasonalButton.frame.height - (2 * y), width: seasonalButton.frame.width - 4, height: (2 * y))
            buttonTitle.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.text = buttonTitleText[i]
            buttonTitle.textColor = UIColor.white
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 10)
            seasonalButton.addSubview(buttonTitle)
            
            x1 = seasonalButton.frame.maxX + (2 * x)
        }
        
        let brandScrollView = UIScrollView()
        brandScrollView.frame = CGRect(x: 0, y: seasonalScrollView.frame.maxY + (5 * y), width: view.frame.width, height: (12 * y))
        brandScrollView.contentSize.width = view.frame.width * 1.55
        customization2View.addSubview(brandScrollView)
        
        let buttonTitleText2 = ["All Color", "Red", "Green", "Black"]
        var x2:CGFloat = (2 * x)
        for i in 0..<4
        {
            let brandButton = UIButton()
            brandButton.frame = CGRect(x: x2, y: y, width: (12 * x), height: (10 * y))
            brandButton.setImage(UIImage(named: "genderBackground"), for: .normal)
            brandButton.tag = i
            brandScrollView.addSubview(brandButton)
            
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: (2 * x), y: (2 * y), width: brandButton.frame.width - (4 * x), height: brandButton.frame.height - (4 * y))
            buttonImage.image = UIImage(named: imageName[i])
            brandButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 2, y: brandButton.frame.height - (2 * y), width: brandButton.frame.width - 4, height: (2 * y))
            buttonTitle.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.text = buttonTitleText2[i]
            buttonTitle.textColor = UIColor.white
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 10)
            brandButton.addSubview(buttonTitle)
            
            x2 = brandButton.frame.maxX + (2 * x)
        }
        
        let industryScrollView = UIScrollView()
        industryScrollView.frame = CGRect(x: 0, y: brandScrollView.frame.maxY + (5 * y), width: view.frame.width, height: (12 * y))
        industryScrollView.contentSize.width = view.frame.width * 1.55
        customization2View.addSubview(industryScrollView)
        
        let buttonTitleText3 = ["All Pattern", "Checked", "Houndstooth", "Twill"]
        var x3:CGFloat = (2 * x)
        for i in 0..<4
        {
            let industryButton = UIButton()
            industryButton.frame = CGRect(x: x3, y: y, width: (12 * x), height: (10 * y))
            industryButton.setImage(UIImage(named: "genderBackground"), for: .normal)
            industryButton.tag = i
            industryScrollView.addSubview(industryButton)
            
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: (2 * x), y: (2 * y), width: industryButton.frame.width - (4 * x), height: industryButton.frame.height - (4 * y))
            buttonImage.image = UIImage(named: imageName[i])
            industryButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 2, y: industryButton.frame.height - (2 * y), width: industryButton.frame.width - 4, height: (2 * y))
            buttonTitle.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.text = buttonTitleText3[i]
            buttonTitle.textColor = UIColor.white
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 10)
            industryButton.addSubview(buttonTitle)
            
            x3 = industryButton.frame.maxX + (2 * x)
        }
    }
    
    func customization3Content()
    {
        let customization3View = UIView()
        customization3View.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        customization3View.backgroundColor = UIColor.white
        view.addSubview(customization3View)
        
        let customization3NavigationBar = UIView()
        customization3NavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        customization3NavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        customization3View.addSubview(customization3NavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        backButton.tag = 3
        customization3NavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: customization3NavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "CUSTOMIZATION-3"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        customization3NavigationBar.addSubview(navigationTitle)
        
        let viewDesignLabel = UILabel()
        viewDesignLabel.frame = CGRect(x: (2 * x), y: customization3NavigationBar.frame.maxY + y, width: (25 * x), height: (4 * y))
        viewDesignLabel.layer.cornerRadius = 10
        viewDesignLabel.layer.masksToBounds = true
        viewDesignLabel.backgroundColor = UIColor.blue
        viewDesignLabel.text = "VIEW YOUR DESIGN HERE"
        viewDesignLabel.textColor = UIColor.white
        viewDesignLabel.textAlignment = .center
        viewDesignLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        customization3View.addSubview(viewDesignLabel)
        
        let customedImageView = UIImageView()
        customedImageView.frame = CGRect(x: (2 * x), y: viewDesignLabel.frame.maxY + y, width: (25 * x), height: (25 * y))
        customedImageView.backgroundColor = UIColor.red
        customization3View.addSubview(customedImageView)
        
        let customedFrontButton = UIButton()
        customedFrontButton.frame = CGRect(x: customedImageView.frame.maxX + (2 * x), y: customedImageView.frame.minY + (9 * y), width: (7.5 * x), height: (7.5 * y))
        customedFrontButton.backgroundColor = UIColor.blue
        customization3View.addSubview(customedFrontButton)
        
        let customedBackButton = UIButton()
        customedBackButton.frame = CGRect(x: customedImageView.frame.maxX + (2 * x), y: customedFrontButton.frame.maxY + y, width: (7.5 * x), height: (7.5 * y))
        customedBackButton.backgroundColor = UIColor.lightGray
        customization3View.addSubview(customedBackButton)
        
        let dropDownButton = UIButton()
        dropDownButton.frame = CGRect(x: (2 * x), y: customedImageView.frame.maxY + (2 * y), width: view.frame.width - (4 * x), height: (5 * y))
        dropDownButton.layer.cornerRadius = 15
        dropDownButton.layer.masksToBounds = true
        dropDownButton.backgroundColor = UIColor.lightGray
        dropDownButton.setTitle("LAPELS", for: .normal)
        dropDownButton.setTitleColor(UIColor.white, for: .normal)
        customization3View.addSubview(dropDownButton)
        
        let customizationScrollView = UIScrollView()
        customizationScrollView.frame = CGRect(x: 0, y: dropDownButton.frame.maxY + y, width: view.frame.width, height: (12 * y))
        customizationScrollView.contentSize.width = view.frame.width * 1.55
        customization3View.addSubview(customizationScrollView)
        
        let buttonTitleText = ["NOTCH", "PEAK", "SLIM NOTCH", "Twill"]
        var x3:CGFloat = (2 * x)
        for i in 0..<4
        {
            let industryButton = UIButton()
            industryButton.frame = CGRect(x: x3, y: y, width: (12 * x), height: (10 * y))
            industryButton.setImage(UIImage(named: "genderBackground"), for: .normal)
            industryButton.tag = i
            customizationScrollView.addSubview(industryButton)
            
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: (2 * x), y: (2 * y), width: industryButton.frame.width - (4 * x), height: industryButton.frame.height - (4 * y))
            buttonImage.image = UIImage(named: "imageName[i]")
            industryButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 2, y: industryButton.frame.height - (2 * y), width: industryButton.frame.width - 4, height: (2 * y))
            buttonTitle.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.text = buttonTitleText[i]
            buttonTitle.textColor = UIColor.white
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 10)
            industryButton.addSubview(buttonTitle)
            
            x3 = industryButton.frame.maxX + (2 * x)
        }
        
        let customization3NextButton = UIButton()
        customization3NextButton.frame = CGRect(x: view.frame.width - (10 * x), y: customizationScrollView.frame.maxY + y, width: (8 * x), height: (3 * y))
        customization3NextButton.layer.masksToBounds = true
        customization3NextButton.backgroundColor = UIColor.orange
        customization3NextButton.setTitle("NEXT", for: .normal)
        customization3NextButton.setTitleColor(UIColor.white, for: .normal)
        customization3View.addSubview(customization3NextButton)
    }
    
    @objc func customedFrontAndBackButtonAction(sender : UIButton)
    {
        if sender.tag == 0
        {
            
        }
        else
        {
            
        }
    }
    
    func measurement1Content()
    {
        let measurement1View = UIView()
        measurement1View.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        measurement1View.backgroundColor = UIColor.white
        view.addSubview(measurement1View)
        
        let measurement1NavigationBar = UIView()
        measurement1NavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        measurement1NavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        measurement1View.addSubview(measurement1NavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        backButton.tag = 3
        measurement1NavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: measurement1NavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "MEASUREMENT-1"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        measurement1NavigationBar.addSubview(navigationTitle)
        
        let manualTitleLabel = UILabel()
        manualTitleLabel.frame = CGRect(x: (4 * x), y: measurement1NavigationBar.frame.maxY + (2 * y), width: measurement1View.frame.width - (8 * x), height: (3 * y))
        manualTitleLabel.text = "Manually"
        manualTitleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        manualTitleLabel.textAlignment = .left
        measurement1View.addSubview(manualTitleLabel)
        
        let manualButton = UIButton()
        manualButton.frame = CGRect(x: (4 * x), y: manualTitleLabel.frame.maxY + y, width: measurement1View.frame.width - (8 * x), height: (10 * y))
        manualButton.backgroundColor = UIColor.red
        measurement1View.addSubview(manualButton)
        
        let forWhomButton = UIButton()
        forWhomButton.frame = CGRect(x: (4 * x), y: manualButton.frame.maxY + (2 * y), width: measurement1View.frame.width - (8 * x), height: (3 * y))
        forWhomButton.backgroundColor = UIColor.green
        forWhomButton.setTitle("FOR WHOM", for: .normal)
        measurement1View.addSubview(forWhomButton)
        
        let goTitleLabel = UILabel()
        goTitleLabel.frame = CGRect(x: (4 * x), y: forWhomButton.frame.maxY + (2 * y), width: measurement1View.frame.width - (8 * x), height: (3 * y))
        goTitleLabel.text = "Go to Tailor shop"
        goTitleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        goTitleLabel.textAlignment = .left
        measurement1View.addSubview(goTitleLabel)
        
        let goButton = UIButton()
        goButton.frame = CGRect(x: (4 * x), y: goTitleLabel.frame.maxY + y, width: measurement1View.frame.width - (8 * x), height: (10 * y))
        goButton.backgroundColor = UIColor.red
        measurement1View.addSubview(goButton)
        
        let comeTitleLabel = UILabel()
        comeTitleLabel.frame = CGRect(x: (4 * x), y: goButton.frame.maxY + (2 * y), width: measurement1View.frame.width - (8 * x), height: (3 * y))
        comeTitleLabel.text = "Ask Tailor to come"
        comeTitleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        comeTitleLabel.textAlignment = .left
        measurement1View.addSubview(comeTitleLabel)
        
        let comeButton = UIButton()
        comeButton.frame = CGRect(x: (4 * x), y: comeTitleLabel.frame.maxY + y, width: measurement1View.frame.width - (8 * x), height: (10 * y))
        comeButton.backgroundColor = UIColor.red
        measurement1View.addSubview(comeButton)
    }
    
    func orderTypeContent()
    {
        orderTypeView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        orderTypeView.backgroundColor = UIColor.white
        view.addSubview(orderTypeView)
        
        let orderTypeNavigationBar = UIView()
        orderTypeNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        orderTypeNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        orderTypeView.addSubview(orderTypeNavigationBar)
        
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
        directDeliveryIcon.frame = CGRect(x: (2 * x), y: orderTypeNavigationBar.frame.maxY + (2 * y), width: (2 * x), height: (2 * y))
        directDeliveryIcon.image = UIImage(named: "direct-delivery")
        orderTypeView.addSubview(directDeliveryIcon)
        
        let directDeliveryLabel = UILabel()
        directDeliveryLabel.frame = CGRect(x: directDeliveryIcon.frame.maxX, y: orderTypeNavigationBar.frame.maxY + (2 * y), width: view.frame.width, height: (2 * y))
        directDeliveryLabel.text = "Own Material - Direct Delivery"
        directDeliveryLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        directDeliveryLabel.textAlignment = .left
        directDeliveryLabel.font = UIFont(name: "AvenirNext-Regular", size: 12)
        orderTypeView.addSubview(directDeliveryLabel)
        
        let directDeliveryUnderline = UILabel()
        directDeliveryUnderline.frame = CGRect(x: (2 * x), y: directDeliveryLabel.frame.maxY + (y / 2), width: view.frame.width - (4 * x), height: 0.5)
        directDeliveryUnderline.backgroundColor = UIColor.lightGray
        orderTypeView.addSubview(directDeliveryUnderline)
        
        let directDeliveryButton = UIButton()
        directDeliveryButton.frame = CGRect(x: (2 * x), y: directDeliveryUnderline.frame.maxY + y, width: view.frame.width - (4 * x), height: (12 * y))
        directDeliveryButton.backgroundColor = UIColor.red
        directDeliveryButton.addTarget(self, action: #selector(self.ownMaterialButtonAction(sender:)), for: .touchUpInside)
        orderTypeView.addSubview(directDeliveryButton)
        
        let courierDeliveryIcon = UIImageView()
        courierDeliveryIcon.frame = CGRect(x: (2 * x), y: directDeliveryButton.frame.maxY + (2 * y), width: (2 * x), height: (2 * y))
        courierDeliveryIcon.image = UIImage(named: "direct-delivery")
        orderTypeView.addSubview(courierDeliveryIcon)
        
        let couriertDeliveryLabel = UILabel()
        couriertDeliveryLabel.frame = CGRect(x: courierDeliveryIcon.frame.maxX, y: directDeliveryButton.frame.maxY + (2 * y), width: view.frame.width - (5 * x), height: (2 * y))
        couriertDeliveryLabel.text = "Own Material - Courier the Material(Extra charges applicable)"
        couriertDeliveryLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        couriertDeliveryLabel.textAlignment = .left
        couriertDeliveryLabel.font = UIFont(name: "AvenirNext-Regular", size: 12)
        couriertDeliveryLabel.adjustsFontSizeToFitWidth = true
        orderTypeView.addSubview(couriertDeliveryLabel)
        
        let courierDeliveryUnderline = UILabel()
        courierDeliveryUnderline.frame = CGRect(x: (2 * x), y: couriertDeliveryLabel.frame.maxY + (y / 2), width: view.frame.width - (4 * x), height: 0.5)
        courierDeliveryUnderline.backgroundColor = UIColor.lightGray
        orderTypeView.addSubview(courierDeliveryUnderline)
        
        let courierDeliveryButton = UIButton()
        courierDeliveryButton.frame = CGRect(x: (2 * x), y: courierDeliveryUnderline.frame.maxY + y, width: view.frame.width - (4 * x), height: (12 * y))
        courierDeliveryButton.backgroundColor = UIColor.green
        courierDeliveryButton.addTarget(self, action: #selector(self.ownMaterialButtonAction(sender:)), for: .touchUpInside)
        orderTypeView.addSubview(courierDeliveryButton)
        
        let companyIcon = UIImageView()
        companyIcon.frame = CGRect(x: (2 * x), y: courierDeliveryButton                                                                                                                           .frame.maxY + (2 * y), width: (2 * x), height: (2 * y))
        companyIcon.image = UIImage(named: "direct-delivery")
        orderTypeView.addSubview(companyIcon)
        
        let companyLabel = UILabel()
        companyLabel.frame = CGRect(x: companyIcon.frame.maxX, y: courierDeliveryButton.frame.maxY + (2 * y), width: view.frame.width, height: (2 * y))
        companyLabel.text = "Companies - Material"
        companyLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        companyLabel.textAlignment = .left
        companyLabel.font = UIFont(name: "AvenirNext-Regular", size: 12)
        orderTypeView.addSubview(companyLabel)
        
        let companyUnderline = UILabel()
        companyUnderline.frame = CGRect(x: (2 * x), y: companyLabel.frame.maxY + (y / 2), width: view.frame.width - (4 * x), height: 0.5)
        companyUnderline.backgroundColor = UIColor.lightGray
        orderTypeView.addSubview(companyUnderline)
        
        let companyButton = UIButton()
        companyButton.frame = CGRect(x: (2 * x), y: companyUnderline.frame.maxY + y, width: view.frame.width - (4 * x), height: (12 * y))
        companyButton.backgroundColor = UIColor.magenta
        companyButton.addTarget(self, action: #selector(self.companyButtonAction(sender:)), for: .touchUpInside)
        orderTypeView.addSubview(companyButton)
    }
    
    @objc func ownMaterialButtonAction(sender : UIButton)
    {
        addMaterialContent()
    }
    
    @objc func companyButtonAction(sender : UIButton)
    {
        serviceCall.API_Customization1(originId: [0], seasonId: [0], delegate: self)
    }
    
    func addMaterialContent()
    {
        addMaterialView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        addMaterialView.backgroundColor = UIColor.white
        view.addSubview(addMaterialView)
        
        let addMaterialNavigationBar = UIView()
        addMaterialNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        addMaterialNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        addMaterialView.addSubview(addMaterialNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 4
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        addMaterialNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: addMaterialNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "ADD MATERIAL"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        addMaterialNavigationBar.addSubview(navigationTitle)
        
        addMaterialImage.frame = CGRect(x: (2 * x), y: addMaterialNavigationBar.frame.maxY + (2 * y), width: view.frame.width - (4 * x), height: view.frame.width - (4 * x))
        addMaterialImage.backgroundColor = UIColor.cyan
        addMaterialView.addSubview(addMaterialImage)
        
        let addMaterialLabel = UILabel()
        addMaterialLabel.frame = CGRect(x: (2 * x), y: addMaterialImage.frame.maxY + (2 * x), width: view.frame.width, height: (2 * y))
        addMaterialLabel.text = "Add material image for tailor refrence"
        addMaterialLabel.textColor = UIColor.black
        addMaterialLabel.textAlignment = .left
        addMaterialView.addSubview(addMaterialLabel)
        
        addMaterialScrolView.frame = CGRect(x: 0, y: addMaterialLabel.frame.maxY, width: view.frame.width, height: (8.25 * y))
        addMaterialView.addSubview(addMaterialScrolView)
        
        addMaterialImageCollection.frame = CGRect(x: x, y: y, width: (6.25 * x), height: (6.25 * y))
        addMaterialImageCollection.backgroundColor = UIColor.blue
        addMaterialImageCollection.setTitle("+", for: .normal)
        addMaterialImageCollection.setTitleColor(UIColor.white, for: .normal)
        addMaterialImageCollection.addTarget(self, action: #selector(self.addMaterialButtonAction(sender:)), for: .touchUpInside)
        addMaterialScrolView.addSubview(addMaterialImageCollection)
        
        
        let addMaterialNextButton = UIButton()
        addMaterialNextButton.frame = CGRect(x: view.frame.width - (15 * x), y: addMaterialScrolView.frame.maxY + y, width: (13 * x), height: (4 * y))
        addMaterialNextButton.layer.cornerRadius = 10
        addMaterialNextButton.backgroundColor = UIColor.blue
        addMaterialNextButton.setTitle("Next", for: .normal)
        addMaterialNextButton.setTitleColor(UIColor.white, for: .normal)
        addMaterialView.addSubview(addMaterialNextButton)
    }
    
    func addReferenceImage()
    {
        print("materialCount", self.materialCount)

        materialCount += 1
        
        referenceMaterialCount = materialCount
        var x1:CGFloat = x
        
        print("REFERAL COUNT", materialCount)
        
        for i in 0..<materialCount
        {
            let addMaterialImageCollection = UIButton()
            addMaterialImageCollection.frame = CGRect(x: x1, y: y, width: (6.25 * x), height: (6.25 * y))
            addMaterialImageCollection.backgroundColor = UIColor.blue
            addMaterialImageCollection.setTitle("\(i)", for: .normal)
            addMaterialImageCollection.setTitleColor(UIColor.white, for: .normal)
            addMaterialImageCollection.addTarget(self, action: #selector(self.addMaterialButtonAction(sender:)), for: .touchUpInside)
            addMaterialScrolView.addSubview(addMaterialImageCollection)
            
            x1 = addMaterialImageCollection.frame.maxX + x
            
            let cancelMaterialImageCollection = UIButton()
            cancelMaterialImageCollection.frame = CGRect(x: addMaterialImageCollection.frame.maxX - (3 * x), y: 0, width: (2 * x), height: (2 * y))
            cancelMaterialImageCollection.backgroundColor = UIColor.white
            cancelMaterialImageCollection.setTitle("\(i)", for: .normal)
            cancelMaterialImageCollection.setTitleColor(UIColor.black, for: .normal)
//            cancelMaterialImageCollection.addTarget(self, action: #selector(self.addMaterialButtonAction(sender:)), for: .touchUpInside)
            addMaterialImageCollection.addSubview(cancelMaterialImageCollection)
        }
        
        addMaterialImageCollection.frame = CGRect(x: x1, y: y, width: (6.25 * x), height: (6.25 * y))
    }
    
    @objc func addMaterialButtonAction(sender : UIButton)
    {
        print("1111111", materialCount, referenceMaterialCount)
        
        UserDefaults.standard.set(1, forKey: "screenValue")
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
            
            materialCount = referenceMaterialCount
            
            imagePicker.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "CANCEL", style: .done, target: self, action: #selector(self.imagePickerCancelButtonAction(sender:)))
        }
    }
    
    @objc func imagePickerCancelButtonAction(sender : UIBarButtonItem)
    {
        self.dismiss(animated: true, completion: nil)
        
        addMaterialContent()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.addMaterialImage.image = pickedImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dressTypeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(DressTypeCollectionViewCell.self), for: indexPath) as! DressTypeCollectionViewCell
//        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        
        myCell.dressTypeImage.frame = CGRect(x: 0, y: 0, width: (13.88 * x), height: (10 * y))
        myCell.dressTypeImage.image = convertedDressImageArray[indexPath.row]
        myCell.dressTypeImage.contentMode = .scaleAspectFit

        
        myCell.dressTypeName.frame = CGRect(x: 0, y: myCell.dressTypeImage.frame.maxY, width: myCell.frame.width, height: (4 * y))
        myCell.dressTypeName.text = dressTypeArray[indexPath.row] as? String

        myCell.backgroundColor = UIColor.clear
        
        print("MY CELL WIDTH - \(myCell.frame.width), MY CELL HEIGHT - \(myCell.frame.height)")
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("WELCOME TO COLLECTION VIEW")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnVariable = Int()
        if tableView == filterTableView
        {
            returnVariable = 4
        }
        else if tableView == genderTableView
        {
            returnVariable = 4
        }
        else if tableView == occasionTableView
        {
            returnVariable = 8
        }
        else if tableView == priceTableView
        {
            returnVariable = 10
        }
        else if tableView == regionTableView
        {
            returnVariable = 10
        }
        else
        {
            returnVariable = tempArray.count
        }
        return returnVariable
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = UITableViewCell()
        let filterNames = ["Gender", "Occasion", "Price", "Region"]
        let occasionName = ["Ceremonial Dress", "WaistCoat", "Weddings", "Religious Clothing", "Office Parties", "Business lunch meeting", "Engagement Parties", "Social Events"]
        let priceList = ["Below AED 199", "AED 200 - 499", "AED 500 - 799", "AED 800 - 1199", "AED 1200 - 1499", "AED 1500 - 1799", "AED 1800 - 2099", "AED 2100 - 2399", "AED 2400 - 2799", "AED 2800 - 2999"]
        
        let regionsName = ["India", "Singpore", "Canada", "USA", "Dubai", "Alabama", "Australia", "Pakistan", "China", "Germany"]
        
        if tableView == filterTableView
        {
            cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FilterTableViewCell.self), for: indexPath as IndexPath) as! FilterTableViewCell
            cell.textLabel?.text = filterNames[indexPath.row]
        }
        else if tableView == genderTableView
        {
            cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(GenderTableViewCell.self), for: indexPath as IndexPath) as! GenderTableViewCell
            cell.textLabel?.text = genderArray[indexPath.row] as? String
        }
        else if tableView == occasionTableView
        {
            cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(GenderTableViewCell.self), for: indexPath as IndexPath) as! GenderTableViewCell
            cell.textLabel?.text = occasionName[indexPath.row]
        }
        else if tableView == priceTableView
        {
            cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(GenderTableViewCell.self), for: indexPath as IndexPath) as! GenderTableViewCell
            cell.textLabel?.text = priceList[indexPath.row]
        }
        else if tableView == regionTableView
        {
            cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(GenderTableViewCell.self), for: indexPath as IndexPath) as! GenderTableViewCell
            cell.textLabel?.text = regionsName[indexPath.row]
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = tempArray[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SELECTED")
        
        if tableView == filterTableView
        {
            if indexPath.row == 0
            {
                genderContent()
            }
            else if indexPath.row == 1
            {
                occasionContent()
            }
            else if indexPath.row == 2
            {
                priceContent()
            }
            else
            {
                regionContent()
            }
            
        }
        else if tableView == genderTableView
        {
            
        }
        else if tableView == occasionTableView
        {
            
        }
        else if tableView == priceTableView
        {
            if indexPath.row == 0
            {
                
            }
        }
        
    }
    
    func searchFuncValues()
    {
        searchTextTableView.frame = CGRect(x: 0, y: searchTextField.frame.maxY, width: view.frame.width, height: (20 * x))
        searchTextTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        searchTextTableView.dataSource = self
        searchTextTableView.delegate = self
        dressTypeView.addSubview(searchTextTableView)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print("ENTERING TEXT", textField.text!, textField.text?.count)
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("Backspace was pressed", char.count)
        }
        
        
        
        if textField.text?.count != 0
        {
            for i in 0..<dressTypeArray.count
            {
                if let stringName = dressTypeArray[i] as? String
                {
                    if textField.text! == stringName.prefix((textField.text?.count)!)
                    {
                        print("NAME", dressTypeArray[i])
                        tempArray.append(dressTypeArray[i] as! String)
                        searchFuncValues()
                    }
                }
            }
        }
        else
        {
            searchTextTableView.removeFromSuperview()
        }
        if textField.text?.count == 1
        {
            searchTextTableView.removeFromSuperview()
        }
      
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        searchTextTableView.removeFromSuperview()
        tempArray.removeAll()
        return false
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
