//
//  Measurement1ViewController.swift
//  Mzyoon
//
//  Created by QOL on 16/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class Measurement1ViewController: CommonViewController, ServerAPIDelegate
{
    var nameArray = [String]()
    var addNameAlert = UIAlertController()
    
    let serviceCall = ServerAPI()
    
    
    var Measure1IdArray = NSArray()
    var Measure1NameEngArray = NSArray()
    var Measure1NameAraArray = NSArray()
    var Measure1BodyImage = NSArray()
    var convertedMeasure1BodyImageArray = [UIImage]()
    
    var existNameArray = NSArray()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()
    let selfScreenContents = UIView()
    let manualTitleLabel = UILabel()
    let goTitleLabel = UILabel()
    let comeTitleLabel = UILabel()

    //EXISTING USER DEATILS PARAMETERS
    var existingUserName = [String]()
    var existingUserId = [String]()
    var existingUserDressType = [String]()
    
    var applicationDelegate = AppDelegate()

    
    override func viewDidLoad()
    {
        navigationBar.isHidden = true
        //        self.tab1Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        selectedButton(tag: 0)
        
        self.serviceCall.API_Measurement1(delegate: self)
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameArray.removeAll()
        
        self.serviceCall.API_Measurement1(delegate: self)
        
        if let userId = UserDefaults.standard.value(forKey: "userId") as? String
        {
            if let dressId = UserDefaults.standard.value(forKey: "dressSubTypeId") as? String
            {
                self.serviceCall.API_ExistingUserMeasurement(DressTypeId: dressId, UserId: userId, delegate: self)
            }
            else if let dressId = UserDefaults.standard.value(forKey: "dressSubTypeId") as? Int
            {
                self.serviceCall.API_ExistingUserMeasurement(DressTypeId: "\(dressId)", UserId: userId, delegate: self)
            }
        }
        else if let userId = UserDefaults.standard.value(forKey: "userId") as? Int
        {
            if let dressId = UserDefaults.standard.value(forKey: "dressSubTypeId") as? String
            {
                self.serviceCall.API_ExistingUserMeasurement(DressTypeId: dressId, UserId: "\(userId)", delegate: self)
            }
            else if let dressId = UserDefaults.standard.value(forKey: "dressSubTypeId") as? Int
            {
                self.serviceCall.API_ExistingUserMeasurement(DressTypeId: "\(dressId)", UserId: "\(userId)", delegate: self)
            }
        }
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("MEASUREMENT 1", errorMessage)
        stopActivity()
        applicationDelegate.exitContents()
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        // ErrorStr = "Default Error"
        PageNumStr = "Measurement1ViewController"
        // MethodName = "do"
        
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
    
    func API_CALLBACK_Measurement1(measure1: NSDictionary)
    {
        print("MERASUREMENT 1", measure1)
        let ResponseMsg = measure1.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = measure1.object(forKey: "Result") as! NSArray
            
            Measure1NameEngArray = Result.value(forKey: "MeasurementInEnglish") as! NSArray
            
            Measure1NameAraArray = Result.value(forKey: "MeasurementInArabic") as! NSArray
            
            Measure1IdArray = Result.value(forKey: "Id") as! NSArray
            
            Measure1BodyImage = Result.value(forKey: "BodyImage") as! NSArray
            
            /*for i in 0..<Measure1BodyImage.count
             {
             if let imageName = Measure1BodyImage[i] as? String
             {
             let urlString = serviceCall.baseURL
             let api = "\(urlString)/images/Measurement1/\(imageName)"
             let apiurl = URL(string: api)
             
             if let data = try? Data(contentsOf: apiurl!) {
             if let image = UIImage(data: data) {
             self.convertedMeasure1BodyImageArray.append(image)
             }
             }
             else
             {
             let emptyImage = UIImage(named: "empty")
             self.convertedMeasure1BodyImageArray.append(emptyImage!)
             }
             }
             else if Measure1BodyImage[i] is NSNull
             {
             let emptyImage = UIImage(named: "empty")
             self.convertedMeasure1BodyImageArray.append(emptyImage!)
             }
             }*/
            self.measurement1Content()
        }
        else if ResponseMsg == "Failure"
        {
            let Result = measure1.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "DisplayMeasurement1"
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func API_CALLBACK_ExistingUserMeasurement(getExistUserMeasurement: NSDictionary)
    {
        print("EXISTING USER MEASUREMENT", getExistUserMeasurement)
        let ResponseMsg = getExistUserMeasurement.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = getExistUserMeasurement.object(forKey: "Result") as! NSArray
            
            existNameArray = Result.value(forKey: "Name") as! NSArray
        }
        else if ResponseMsg == "Failure"
        {
            let Result = getExistUserMeasurement.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetExistingUserMeasurement"
            ErrorStr = Result
            
            DeviceError()
        }
        
        
        for i in 0..<existNameArray.count
        {
            nameArray.append(existNameArray[i] as! String)
        }
    }
    
    func measurement1Content()
    {
        selfScreenNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        selfScreenNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(selfScreenNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        backButton.tag = 3
        selfScreenNavigationBar.addSubview(backButton)
        
        selfScreenNavigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: selfScreenNavigationBar.frame.width, height: (3 * y))
        selfScreenNavigationTitle.text = "MEASUREMENT-1"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationTitle.font = selfScreenNavigationTitle.font.withSize(2 * x)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        selfScreenContents.frame = CGRect(x: (3 * x), y: selfScreenNavigationBar.frame.maxY, width: view.frame.width - (6 * x), height: view.frame.height - ((5 * y) + selfScreenNavigationBar.frame.maxY))
        selfScreenContents.backgroundColor = UIColor.clear
        view.addSubview(selfScreenContents)
        
        self.view.bringSubviewToFront(slideMenuButton)

        manualTitleLabel.frame = CGRect(x: 0, y: y, width: selfScreenContents.frame.width, height: (3 * y))
        manualTitleLabel.text = Measure1NameEngArray[0] as! String
        manualTitleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        manualTitleLabel.textAlignment = .left
        selfScreenContents.addSubview(manualTitleLabel)
        
        let manualButton = UIButton()
        manualButton.frame = CGRect(x: 0, y: manualTitleLabel.frame.maxY, width: selfScreenContents.frame.width, height: (13 * y))
        //        manualButton.backgroundColor = UIColor.red
        //        manualButton.setImage(convertedMeasure1BodyImageArray[0], for: .normal)
        manualButton.tag = Measure1IdArray[0] as! Int
        manualButton.addTarget(self, action: #selector(self.forWhomButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(manualButton)
        
        if let imageName = Measure1BodyImage[0] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/Measurement1/\(imageName)"
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: manualButton.frame.width, height: manualButton.frame.height)
            if apiurl != nil
            {
                dummyImageView.dowloadFromServer(url: apiurl!)
            }
            manualButton.addSubview(dummyImageView)
        }
        
        let forWhomButton = UIButton()
        forWhomButton.frame = CGRect(x: (4 * x), y: manualButton.frame.maxY + (2 * y), width: view.frame.width - (8 * x), height: (3 * y))
        forWhomButton.backgroundColor = UIColor.white
        forWhomButton.setTitle("FOR WHOM", for: .normal)
        forWhomButton.setTitleColor(UIColor.black, for: .normal)
        forWhomButton.contentHorizontalAlignment = .left
//        forWhomButton.addTarget(self, action: #selector(self.forWhomButtonAction(sender:)), for: .touchUpInside)
        //        view.addSubview(forWhomButton)
        
        let downArrowImageView = UIImageView()
        downArrowImageView.frame = CGRect(x: forWhomButton.frame.width - (3 * x), y: (y / 2), width: (2 * x), height: (2 * y))
        downArrowImageView.image = UIImage(named: "downArrow")
        forWhomButton.addSubview(downArrowImageView)
        
        goTitleLabel.frame = CGRect(x: 0, y: manualButton.frame.maxY + (2 * y), width: selfScreenContents.frame.width, height: (3 * y))
        goTitleLabel.text = Measure1NameEngArray[1] as! String
        goTitleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        goTitleLabel.textAlignment = .left
        selfScreenContents.addSubview(goTitleLabel)
        
        let goButton = UIButton()
        goButton.frame = CGRect(x: 0, y: goTitleLabel.frame.maxY, width: selfScreenContents.frame.width, height: (13 * y))
        //        goButton.backgroundColor = UIColor.red
        //        goButton.setImage(convertedMeasure1BodyImageArray[1], for: .normal)
        goButton.tag = Measure1IdArray[1] as! Int
        goButton.addTarget(self, action: #selector(self.measurement1NextButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(goButton)
        
        if let imageName = Measure1BodyImage[1] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/Measurement1/\(imageName)"
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: goButton.frame.width, height: goButton.frame.height)
            if apiurl != nil
            {
                dummyImageView.dowloadFromServer(url: apiurl!)
            }
            goButton.addSubview(dummyImageView)
        }
        
        comeTitleLabel.frame = CGRect(x: 0, y: goButton.frame.maxY + (2 * y), width: selfScreenContents.frame.width, height: (3 * y))
        comeTitleLabel.text = Measure1NameEngArray[2] as! String
        comeTitleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        comeTitleLabel.textAlignment = .left
        selfScreenContents.addSubview(comeTitleLabel)
        
        let comeButton = UIButton()
        comeButton.frame = CGRect(x: 0, y: comeTitleLabel.frame.maxY, width: selfScreenContents.frame.width, height: (13 * y))
        //        comeButton.backgroundColor = UIColor.red
        //        comeButton.setImage(convertedMeasure1BodyImageArray[2], for: .normal)
        comeButton.tag = Measure1IdArray[2] as! Int
        comeButton.addTarget(self, action: #selector(self.measurement1NextButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(comeButton)
        
        if let imageName = Measure1BodyImage[2] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/Measurement1/\(imageName)"
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: comeButton.frame.width, height: comeButton.frame.height)
            if apiurl != nil
            {
                dummyImageView.dowloadFromServer(url: apiurl!)
            }
            comeButton.addSubview(dummyImageView)
            
            self.stopActivity()
        }
        
        let measurement1NextButton = UIButton()
        measurement1NextButton.frame = CGRect(x: view.frame.width - (5 * x), y: comeButton.frame.maxY + y, width: (4 * x), height: (4 * y))
        measurement1NextButton.layer.masksToBounds = true
        //        measurement1NextButton.backgroundColor = UIColor.orange
        //        measurement1NextButton.setTitle("NEXT", for: .normal)
        //        measurement1NextButton.setTitleColor(UIColor.white, for: .normal)
        measurement1NextButton.setImage(UIImage(named: "rightArrow"), for: .normal)
//        measurement1NextButton.addTarget(self, action: #selector(self.measurement1NextButtonAction(sender:)), for: .touchUpInside)
        //        view.addSubview(measurement1NextButton)
        
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
    
    func changeViewToArabicInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.text = "قياس-1"

        
        selfScreenContents.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        manualTitleLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        manualTitleLabel.text = (Measure1NameAraArray[0] as! String)
        manualTitleLabel.textAlignment = .right
        
        goTitleLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        goTitleLabel.text = (Measure1NameAraArray[1] as! String)
        goTitleLabel.textAlignment = .right

        comeTitleLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        comeTitleLabel.text = (Measure1NameAraArray[2] as! String)
        comeTitleLabel.textAlignment = .right
    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.text = "MEASUREMENT-1"
        
        selfScreenContents.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        manualTitleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        manualTitleLabel.text = (Measure1NameEngArray[0] as! String)
        manualTitleLabel.textAlignment = .left
        
        goTitleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        goTitleLabel.text = (Measure1NameEngArray[1] as! String)
        goTitleLabel.textAlignment = .left
        
        comeTitleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        comeTitleLabel.text = (Measure1NameEngArray[2] as! String)
        comeTitleLabel.textAlignment = .left
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        if let values = UserDefaults.standard.value(forKey: "custom3Response") as? Int
        {
            if values == 1
            {
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            }
            else
            {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func forWhomButtonAction(sender : UIButton)
    {
        UserDefaults.standard.set("Customer", forKey: "measurementBy")
        UserDefaults.standard.set(sender.tag, forKey: "measurementType")
        var userListAlert : UIAlertController!
        
        var trimmedName = String()
        var trimmedDress = String()
        var trimmedId = String()
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                if nameArray.count == 0
                {
                    userListAlert = UIAlertController(title: "Alert", message: "Please choose measurement name", preferredStyle: .alert)
                }
                else
                {
                    userListAlert = UIAlertController(title: "Alert", message: "Please choose measurement name", preferredStyle: .alert)
                }
                
                for i in 0..<nameArray.count
                {
                    let splitted = nameArray[i].split(separator: "-")
                    
                    if splitted.count == 3
                    {
                        trimmedName = splitted[2].trimmingCharacters(in: .whitespaces)
                        trimmedDress = splitted[1].trimmingCharacters(in: .whitespaces)
                        trimmedId = splitted[0].trimmingCharacters(in: .whitespaces)
                        
                        existingUserName.append(trimmedName)
                        existingUserDressType.append(trimmedDress)
                        existingUserId.append(trimmedId)
                        
                        userListAlert.addAction(UIAlertAction(title: "\(trimmedName)-\(trimmedDress)", style: .default, handler: nameSelection(action:)))
                    }
                    else
                    {
                        trimmedName = splitted[1].trimmingCharacters(in: .whitespaces)
                        trimmedId = splitted[0].trimmingCharacters(in: .whitespaces)
                        
                        existingUserName.append(trimmedName)
                        existingUserId.append(trimmedId)
                    }
                    
                    userListAlert.addAction(UIAlertAction(title: "\(trimmedName)-\(trimmedDress)", style: .default, handler: nameSelection(action:)))
                }
                userListAlert.addAction(UIAlertAction(title: "Add New", style: .default, handler: addNewAlertAction(action:)))
                userListAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(userListAlert, animated: true, completion: nil)
            }
            else if language == "ar"
            {
                if nameArray.count == 0
                {
                    userListAlert = UIAlertController(title: "محزر", message: "يرجى اختيار اسم القياس", preferredStyle: .alert)
                }
                else
                {
                    userListAlert = UIAlertController(title: "محزر", message: "يرجى اختيار اسم القياس", preferredStyle: .alert)
                }
                
                for i in 0..<nameArray.count
                {
                    let splitted = nameArray[i].split(separator: "-")
                    
                    if splitted.count == 3
                    {
                        trimmedName = splitted[2].trimmingCharacters(in: .whitespaces)
                        trimmedDress = splitted[1].trimmingCharacters(in: .whitespaces)
                        trimmedId = splitted[0].trimmingCharacters(in: .whitespaces)
                        
                        existingUserName.append(trimmedName)
                        existingUserDressType.append(trimmedDress)
                        existingUserId.append(trimmedId)
                        
                        userListAlert.addAction(UIAlertAction(title: "\(trimmedName)-\(trimmedDress)", style: .default, handler: nameSelection(action:)))
                    }
                    else
                    {
                        trimmedName = splitted[1].trimmingCharacters(in: .whitespaces)
                        trimmedId = splitted[0].trimmingCharacters(in: .whitespaces)
                        
                        existingUserName.append(trimmedName)
                        existingUserId.append(trimmedId)
                    }
                    
                    userListAlert.addAction(UIAlertAction(title: "\(trimmedName)-\(trimmedDress)", style: .default, handler: nameSelection(action:)))
                }
                userListAlert.addAction(UIAlertAction(title: "اضف جديد", style: .default, handler: addNewAlertAction(action:)))
                userListAlert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: nil))
                self.present(userListAlert, animated: true, completion: nil)
            }
        }
        else
        {
        
            if nameArray.count == 0
            {
                userListAlert = UIAlertController(title: "Alert", message: "Please choose measurement name", preferredStyle: .alert)
            }
            else
            {
                userListAlert = UIAlertController(title: "Alert", message: "Please choose measurement name", preferredStyle: .alert)
            }
            
            for i in 0..<nameArray.count
            {
                let splitted = nameArray[i].split(separator: "-")
                
                if splitted.count == 3
                {
                    trimmedName = splitted[2].trimmingCharacters(in: .whitespaces)
                    trimmedDress = splitted[1].trimmingCharacters(in: .whitespaces)
                    trimmedId = splitted[0].trimmingCharacters(in: .whitespaces)
                    
                    existingUserName.append(trimmedName)
                    existingUserDressType.append(trimmedDress)
                    existingUserId.append(trimmedId)
                    
                    userListAlert.addAction(UIAlertAction(title: "\(trimmedName)-\(trimmedDress)", style: .default, handler: nameSelection(action:)))
                }
                else
                {
                    trimmedName = splitted[1].trimmingCharacters(in: .whitespaces)
                    let trimmedId = splitted[0].trimmingCharacters(in: .whitespaces)
                    
                    existingUserName.append(trimmedName)
                    existingUserId.append(trimmedId)
                }
            }
            userListAlert.addAction(UIAlertAction(title: "Add New", style: .default, handler: addNewAlertAction(action:)))
            userListAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(userListAlert, animated: true, completion: nil)
        }
    }
    
    func addNewAlertAction(action : UIAlertAction)
    {
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                var dressType = String()
                if let dress = UserDefaults.standard.value(forKey: "dressSubType") as? String
                {
                    dressType = dress   
                }
                addNameAlert = UIAlertController(title: "Add Name", message: "for dress type - \(dressType)", preferredStyle: .alert)
                addNameAlert.addTextField(configurationHandler: { (textField) in
                    textField.placeholder = "Enter the name"
                    textField.textAlignment = .left
                })
                addNameAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: addNewNameAlertAction(action:)))
                addNameAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(addNameAlert, animated: true, completion: nil)
            }
            else if language == "ar"
            {
                addNameAlert = UIAlertController(title: "اضف اسما", message: "لنوع الفستان - معطف", preferredStyle: .alert)
                addNameAlert.addTextField(configurationHandler: { (textField) in
                    textField.placeholder = "أدخل الاسم"
                    textField.textAlignment = .right
                })
                addNameAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: addNewNameAlertAction(action:)))
                addNameAlert.addAction(UIAlertAction(title: "إلغاء", style: .default, handler: nil))
                self.present(addNameAlert, animated: true, completion: nil)
            }
        }
        else
        {
            addNameAlert = UIAlertController(title: "Add Name", message: "for dress type - Coat", preferredStyle: .alert)
            addNameAlert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Enter the name"
                textField.textAlignment = .left
            })
            addNameAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: addNewNameAlertAction(action:)))
            addNameAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(addNameAlert, animated: true, completion: nil)
        }
    }
    
    func emptyNameAlertAction(action : UIAlertAction)
    {
        addNewAlertAction(action: action)
    }
    
    func addNewNameAlertAction(action : UIAlertAction)
    {
        if let text = addNameAlert.textFields![0].text as? String
        {
            if text.isEmpty == true || text == ""
            {
                print("VALUES IS EMPTY")
                let alert = UIAlertController(title: "Alert", message: "Please enter a name and proceed", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: emptyNameAlertAction(action:)))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                print("VALUES ARE FULL")
                nameArray.append(addNameAlert.textFields![0].text!)
                
                UserDefaults.standard.set(addNameAlert.textFields![0].text!, forKey: "measurementName")
                UserDefaults.standard.set("-1", forKey: "measurementIdInt")
                
                let measurement2Screen = Measurement2ViewController()
                self.navigationController?.pushViewController(measurement2Screen, animated: true)
            }
        }
    }
    
    func nameSelection(action : UIAlertAction)
    {
        for i in 0..<existingUserName.count
        {
            if let name = existingUserName[i] as? String
            {
                if name == action.title
                {
                    UserDefaults.standard.set(existingUserId[i], forKey: "measurementId")
                    UserDefaults.standard.set(action.title, forKey: "measurementName")
                }
            }
        }
        
        let referenceScreen = ReferenceImageViewController()
        self.navigationController?.pushViewController(referenceScreen, animated: true)
        
        /*if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                let nameSelectionAlert = UIAlertController(title: "Continue", message: "Please select your option", preferredStyle: .alert)
                nameSelectionAlert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: proceedAlertAction(action:)))
                nameSelectionAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(nameSelectionAlert, animated: true, completion: nil)
            }
            else if language == "ar"
            {
                let nameSelectionAlert = UIAlertController(title: "استمر", message: "يرجى تحديد خيارك", preferredStyle: .alert)
                nameSelectionAlert.addAction(UIAlertAction(title: "تقدم", style: .default, handler: proceedAlertAction(action:)))
                nameSelectionAlert.addAction(UIAlertAction(title: "إلغاء", style: .default, handler: nil))
                self.present(nameSelectionAlert, animated: true, completion: nil)
            }
        }
        else
        {
            let nameSelectionAlert = UIAlertController(title: "Continue", message: "Please select your option", preferredStyle: .alert)
            nameSelectionAlert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: proceedAlertAction(action:)))
            nameSelectionAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(nameSelectionAlert, animated: true, completion: nil)
        }*/
    }
    
    func proceedAlertAction(action : UIAlertAction)
    {
        let referenceScreen = ReferenceImageViewController()
        self.navigationController?.pushViewController(referenceScreen, animated: true)
    }
    
    @objc func measurement1NextButtonAction(sender : UIButton)
    {
        UserDefaults.standard.set("Tailor", forKey: "measurementBy")
        UserDefaults.standard.set(sender.tag, forKey: "measurementType")
        UserDefaults.standard.set(0, forKey: "measurement2Response")
        let referencImageScreen = ReferenceImageViewController()
        self.navigationController?.pushViewController(referencImageScreen, animated: true)
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
