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
    
    let selfScreenContents = UIView()
    let manualTitleLabel = UILabel()
    let goTitleLabel = UILabel()
    let comeTitleLabel = UILabel()
    
    let manualButton = UIButton()
    let goButton = UIButton()
    let comeButton = UIButton()


    //EXISTING USER DEATILS PARAMETERS
    var existingUserName = [String]()
    var existingUserId = [String]()
    var existingUserDressType = [String]()
    
    //HINTS PARAMETERS
    var hintTag = 0
    let hintsImage = UIImageView()
    let detailedLabel = UILabel()
    
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
                self.navigationTitle.text = "Measurement Type"
                self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            else if language == "ar"
            {
                self.navigationTitle.text = "نوع القياس"
                self.navigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            }
        }
        else
        {
            self.navigationTitle.text = "Measurement Type"
            self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        self.serviceCall.API_Measurement1(delegate: self)
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameArray.removeAll()
        
        self.serviceCall.API_Measurement1(delegate: self)
        
        if let userId = UserDefaults.standard.value(forKey: "userId") as? String
        {
            self.serviceCall.API_ExistingUserMeasurement(DressTypeId: "\(Variables.sharedManager.dressSubTypeId)", UserId: userId, delegate: self)
        }
        else if let userId = UserDefaults.standard.value(forKey: "userId") as? Int
        {
            self.serviceCall.API_ExistingUserMeasurement(DressTypeId: "\(Variables.sharedManager.dressSubTypeId)", UserId: "\(userId)", delegate: self)
        }
        
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
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("MEASUREMENT 1", errorMessage)
        stopActivity()
        activity.stopActivity()
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
            stopActivity()
            activity.stopActivity()
            
            let Result = measure1.object(forKey: "Result") as! NSArray
            
            Measure1NameEngArray = Result.value(forKey: "MeasurementInEnglish") as! NSArray
            
            Measure1NameAraArray = Result.value(forKey: "MeasurementInArabic") as! NSArray
            
            Measure1IdArray = Result.value(forKey: "Id") as! NSArray
            
            Measure1BodyImage = Result.value(forKey: "BodyImage") as! NSArray
            
            for i in 0..<Measure1BodyImage.count
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
            }
            
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
        selfScreenContents.frame = CGRect(x: x, y: pageBar.frame.maxY, width: view.frame.width - (2 * x), height: view.frame.height - ((5 * y) + navigationBar.frame.maxY + pageBar.frame.height))
        selfScreenContents.backgroundColor = UIColor.clear
        view.addSubview(selfScreenContents)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                pageBar.image = UIImage(named: "MeasurementBar")
            }
            else if language == "ar"
            {
                pageBar.image = UIImage(named: "measurementArabicHintImage")
            }
        }
        else
        {
            pageBar.image = UIImage(named: "MeasurementBar")
        }

        self.view.bringSubviewToFront(slideMenuButton)
        
        let manualIcon = UIImageView()
        manualIcon.frame = CGRect(x: 0, y: (1.5 * y), width: (2 * x), height: (2 * y))
        manualIcon.image = UIImage(named: "Manually")
        selfScreenContents.addSubview(manualIcon)

        manualTitleLabel.frame = CGRect(x: manualIcon.frame.maxX + x, y: y, width: selfScreenContents.frame.width - (4 * x), height: (3 * y))
        manualTitleLabel.text = Measure1NameEngArray[0] as! String
        manualTitleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        manualTitleLabel.textAlignment = .left
        manualTitleLabel.font = UIFont(name: "Avenir-Regular", size: (1.25 * x))
        manualTitleLabel.font = manualTitleLabel.font.withSize(1.25 * x)
        selfScreenContents.addSubview(manualTitleLabel)
        
        let underLine1 = UILabel()
        underLine1.frame = CGRect(x: 0, y: manualTitleLabel.frame.maxY, width: selfScreenContents.frame.width, height: 0.5)
        underLine1.backgroundColor = UIColor.lightGray
        selfScreenContents.addSubview(underLine1)
        
        manualButton.frame = CGRect(x: 0, y: manualTitleLabel.frame.maxY, width: selfScreenContents.frame.width, height: (13 * y))
        //        manualButton.backgroundColor = UIColor.red
        manualButton.setImage(convertedMeasure1BodyImageArray[0], for: .normal)
        manualButton.tag = Measure1IdArray[0] as! Int
        manualButton.addTarget(self, action: #selector(self.forWhomButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(manualButton)
        
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
        
        let goToIcon = UIImageView()
        goToIcon.frame = CGRect(x: 0, y: manualButton.frame.maxY + (y / 2), width: (2 * x), height: (2 * y))
        goToIcon.image = UIImage(named: "Go_to_tailor_shop")
        selfScreenContents.addSubview(goToIcon)
        
        goTitleLabel.frame = CGRect(x: goToIcon.frame.maxX + x, y: manualButton.frame.maxY, width: selfScreenContents.frame.width - (4 * x), height: (3 * y))
        goTitleLabel.text = Measure1NameEngArray[1] as! String
        goTitleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        goTitleLabel.textAlignment = .left
        goTitleLabel.font = UIFont(name: "Avenir-Regular", size: (1.25 * x))
        goTitleLabel.font = goTitleLabel.font.withSize(1.25 * x)
        selfScreenContents.addSubview(goTitleLabel)
        
        let underLine2 = UILabel()
        underLine2.frame = CGRect(x: 0, y: goTitleLabel.frame.maxY, width: selfScreenContents.frame.width, height: 0.5)
        underLine2.backgroundColor = UIColor.lightGray
        selfScreenContents.addSubview(underLine2)
        
        goButton.frame = CGRect(x: 0, y: goTitleLabel.frame.maxY, width: selfScreenContents.frame.width, height: (13 * y))
        //        goButton.backgroundColor = UIColor.red
        goButton.setImage(convertedMeasure1BodyImageArray[1], for: .normal)
        goButton.tag = Measure1IdArray[1] as! Int
        goButton.addTarget(self, action: #selector(self.measurement1NextButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(goButton)
        
        let comeToIcon = UIImageView()
        comeToIcon.frame = CGRect(x: 0, y: goButton.frame.maxY + (y / 2), width: (2 * x), height: (2 * y))
        comeToIcon.image = UIImage(named: "Tailor_come_to_your_place")
        selfScreenContents.addSubview(comeToIcon)
        
        comeTitleLabel.frame = CGRect(x: comeToIcon.frame.maxX + x, y: goButton.frame.maxY, width: selfScreenContents.frame.width - (4 * x), height: (3 * y))
        comeTitleLabel.text = Measure1NameEngArray[2] as! String
        comeTitleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        comeTitleLabel.textAlignment = .left
        comeTitleLabel.font = UIFont(name: "Avenir-Regular", size: (1.25 * x))
        comeTitleLabel.font = comeTitleLabel.font.withSize(1.25 * x)
        selfScreenContents.addSubview(comeTitleLabel)
        
        let underLine3 = UILabel()
        underLine3.frame = CGRect(x: 0, y: comeTitleLabel.frame.maxY, width: selfScreenContents.frame.width, height: 0.5)
        underLine3.backgroundColor = UIColor.lightGray
        selfScreenContents.addSubview(underLine3)
        
        comeButton.frame = CGRect(x: 0, y: comeTitleLabel.frame.maxY, width: selfScreenContents.frame.width, height: (13 * y))
        //        comeButton.backgroundColor = UIColor.red
        comeButton.setImage(convertedMeasure1BodyImageArray[2], for: .normal)
        comeButton.tag = Measure1IdArray[2] as! Int
        comeButton.addTarget(self, action: #selector(self.measurement1NextButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(comeButton)
        
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
        headingLabel.text = "Measurement 1"
        headingLabel.textAlignment = .left
        headingLabel.textColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0)
        headingLabel.font = UIFont(name: "Avenir-Regular", size: (2 * x))
        hintsView.addSubview(headingLabel)
        
        hintsBackButton.isHidden = true
        hintsBackButton.frame = CGRect(x: x, y: hintsView.frame.height - (6 * y), width: (11.16 * x), height: (4 * y))
        hintsBackButton.backgroundColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0)
        hintsBackButton.setTitle("Back", for: .normal)
        hintsBackButton.setTitleColor(UIColor.white, for: .normal)
        hintsBackButton.tag = 0
        hintsBackButton.addTarget(self, action: #selector(self.threeButtonAction(sender:)), for: .touchUpInside)
        hintsView.addSubview(hintsBackButton)
        
        hintsSkipButton.frame = CGRect(x: hintsBackButton.frame.maxX + x, y: hintsView.frame.height - (6 * y), width: (11.16 * x), height: (4 * y))
        hintsSkipButton.backgroundColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0)
        hintsSkipButton.setTitle("Skip", for: .normal)
        hintsSkipButton.setTitleColor(UIColor.white, for: .normal)
        hintsSkipButton.tag = 1
        hintsSkipButton.addTarget(self, action: #selector(self.threeButtonAction(sender:)), for: .touchUpInside)
        hintsView.addSubview(hintsSkipButton)
        
        hintsNextButton.frame = CGRect(x: hintsSkipButton.frame.maxX + x, y: hintsView.frame.height - (6 * y), width: (11.16 * x), height: (4 * y))
        hintsNextButton.backgroundColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0)
        hintsNextButton.setTitle("Next", for: .normal)
        hintsNextButton.setTitleColor(UIColor.white, for: .normal)
        hintsNextButton.tag = 2
        hintsNextButton.addTarget(self, action: #selector(self.threeButtonAction(sender:)), for: .touchUpInside)
        hintsView.addSubview(hintsNextButton)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                hintsBackButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                hintsBackButton.setTitle("Back", for: .normal)
                
                hintsSkipButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                hintsSkipButton.setTitle("Skip", for: .normal)
                
                hintsNextButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                hintsNextButton.setTitle("Next", for: .normal)
            }
            else if language == "ar"
            {
                hintsBackButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                hintsBackButton.setTitle("الى الخلف", for: .normal)
                
                hintsSkipButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                hintsSkipButton.setTitle("تخطى", for: .normal)
                
                hintsNextButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                hintsNextButton.setTitle("التالى", for: .normal)
            }
        }
        else
        {
            hintsBackButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            hintsBackButton.setTitle("Back", for: .normal)
            
            hintsSkipButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            hintsSkipButton.setTitle("Skip", for: .normal)
            
            hintsNextButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            hintsNextButton.setTitle("Next", for: .normal)
        }
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                headingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                headingLabel.text = "Measurement 1"
                headingLabel.textAlignment = .left
            }
            else if language == "ar"
            {
                headingLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                headingLabel.text = "القياس 1"
                headingLabel.textAlignment = .right
            }
        }
        else
        {
            headingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            headingLabel.text = "Measurement 1"
            headingLabel.textAlignment = .left
        }
        
        firstHint()
    }
    
    @objc func threeButtonAction(sender : UIButton)
    {
         if sender.tag == 1
        {
            hintsView.removeFromSuperview()
        }
        else if sender.tag == 0
        {
            if hintTag != 0
            {
                hintTag = hintTag - 1
            }
            
            if hintTag == 0
            {
                firstHint()
                hintsBackButton.isHidden = true
            }
            else if hintTag == 1
            {
                secondHint()
                hintsBackButton.isHidden = false
            }
            else if hintTag == 2
            {
                thirdHint()
                hintsBackButton.isHidden = false
            }
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    hintsNextButton.setTitle("Next", for: .normal)
                }
                else if language == "ar"
                {
                    hintsNextButton.setTitle("التالى", for: .normal)
                }
            }
            else
            {
                hintsNextButton.setTitle("Next", for: .normal)
            }
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
                hintsBackButton.isHidden = false
            }
            else if hintTag == 2
            {
                thirdHint()
                hintsBackButton.isHidden = false
                
                if let language = UserDefaults.standard.value(forKey: "language") as? String
                {
                    if language == "en"
                    {
                        sender.setTitle("Got it", for: .normal)
                    }
                    else if language == "ar"
                    {
                        sender.setTitle("أنا أخذت", for: .normal)
                    }
                }
                else
                {
                    sender.setTitle("Got it", for: .normal)
                }
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
        hintsImage.frame = CGRect(x: x, y: manualTitleLabel.frame.maxY + (10.5 * y), width: manualButton.frame.width, height: manualButton.frame.height)
        hintsImage.layer.borderWidth = 2
        hintsImage.layer.borderColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0).cgColor
        hintsImage.image = convertedMeasure1BodyImageArray[0]
        hintsView.addSubview(hintsImage)
        
        detailedLabel.frame = CGRect(x: (2 * x), y: hintsImage.frame.maxY + y, width: hintsView.frame.width - (4 * x), height: (5 * y))
        detailedLabel.text = "Please click here to add your measurement value yourself."
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
                detailedLabel.text = "Please click here to add your measurement value yourself."
                detailedLabel.textAlignment = .left
            }
            else if language == "ar"
            {
                hintsImage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                detailedLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                detailedLabel.text = "يرجى النقر عليها لإضافة قيمة القياس الخاصة بك نفسك."
                detailedLabel.textAlignment = .right
            }
        }
        else
        {
            hintsImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            detailedLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            detailedLabel.text = "Please click here to add your measurement value yourself."
            detailedLabel.textAlignment = .left
        }
    }
    
    func secondHint()
    {
        hintsImage.frame = CGRect(x: x, y: goTitleLabel.frame.maxY + (10.5 * y), width: manualButton.frame.width, height: manualButton.frame.height)
        hintsImage.layer.borderWidth = 2
        hintsImage.layer.borderColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0).cgColor
        hintsImage.image = convertedMeasure1BodyImageArray[1]
        hintsView.addSubview(hintsImage)
        
        detailedLabel.frame = CGRect(x: (2 * x), y: hintsImage.frame.maxY + y, width: hintsView.frame.width - (4 * x), height: (5 * y))
        detailedLabel.text = "Please click here if wish to go directly to the tailor shop to for adding measurements."
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
                detailedLabel.text = "Please click here if wish to go directly to the tailor shop to for adding measurements."
                detailedLabel.textAlignment = .left
            }
            else if language == "ar"
            {
                hintsImage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                detailedLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                detailedLabel.text = "يرجى النقر هنا إذا كنت ترغب في الذهاب مباشرة إلى متجر الخياطة لإضافة المقاييس."
                detailedLabel.textAlignment = .right
            }
        }
        else
        {
            hintsImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            detailedLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            detailedLabel.text = "Please click here if wish to go directly to the tailor shop to for adding measurements."
            detailedLabel.textAlignment = .left
        }
    }
    
    func thirdHint()
    {
        hintsImage.frame = CGRect(x: x, y: comeTitleLabel.frame.maxY + (10.5 * y), width: manualButton.frame.width, height: manualButton.frame.height)
        hintsImage.layer.borderWidth = 2
        hintsImage.layer.borderColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0).cgColor
        hintsImage.image = convertedMeasure1BodyImageArray[2]
        hintsView.addSubview(hintsImage)
        
        detailedLabel.frame = CGRect(x: (2 * x), y: hintsImage.frame.minY - (8 * y), width: hintsView.frame.width - (4 * x), height: (5 * y))
        detailedLabel.text = "Please click here if you want the tailor to come to your place for adding measurements."
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
                detailedLabel.text = "Please click here if you want the tailor to come to your plave for adding measurements."
                detailedLabel.textAlignment = .left
            }
            else if language == "ar"
            {
                hintsImage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                detailedLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                detailedLabel.text = "يرجى النقر هنا إذا كنت تريد أن يأتي الخياط إلى مكانك لإضافة القياسات."
                detailedLabel.textAlignment = .right
            }
        }
        else
        {
            hintsImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            detailedLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            detailedLabel.text = "Please click here if you want the tailor to come to your plave for adding measurements."
            detailedLabel.textAlignment = .left
        }
    }
    
    func changeViewToArabicInSelf()
    {
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
        
        Variables.sharedManager.measurementType = Measure1NameEngArray[sender.tag - 1] as! String
        print("Measurement Type:",Variables.sharedManager.measurementType)
        
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
                let dressType = Variables.sharedManager.dressSubType

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
                
                var nameAlert = UIAlertController()
                
                if let language = UserDefaults.standard.value(forKey: "language") as? String
                {
                    if language == "en"
                    {
                        nameAlert = UIAlertController(title: "Alert", message: "Please enter a name and proceed", preferredStyle: .alert)
                        nameAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: emptyNameAlertAction(action:)))
                    }
                    else if language == "ar"
                    {
                        nameAlert = UIAlertController(title: "تنبيه", message: "الرجاء إدخال اسم ومتابعة", preferredStyle: .alert)
                        nameAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: emptyNameAlertAction(action:)))
                    }
                }
                else
                {
                    nameAlert = UIAlertController(title: "Alert", message: "Please enter a name and proceed", preferredStyle: .alert)
                    nameAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: emptyNameAlertAction(action:)))
                }
                
                self.present(nameAlert, animated: true, completion: nil)
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
        UserDefaults.standard.set("Customer", forKey: "measurementBy")
        UserDefaults.standard.set(sender.tag, forKey: "measurementType")
        UserDefaults.standard.set(0, forKey: "measurement2Response")
        
        Variables.sharedManager.measurementType = Measure1NameEngArray[sender.tag - 1] as! String
        print("Measurement Type:",Variables.sharedManager.measurementType)
        
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
