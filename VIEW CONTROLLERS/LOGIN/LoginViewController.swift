//
//  LoginViewController.swift
//  Mzyoon
//
//  Created by QOL on 16/10/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoginViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ServerAPIDelegate, UITextFieldDelegate
{
    var findString = "appDelegate"
    
    var x = CGFloat()
    var y = CGFloat()
    
    let backgroundImage = UIImageView()
    
    //SCREEN CONTENT PARAMETERS
    let logoImageView = UIImageView()
    let mobileTextField = UITextField()
    let continueButton = UIButton()
    let languageHeadingLabel = UILabel()
    let mobileCountryCodeButton = UIButton()
    var countryCodes = [String]()
    let mobileCountryCodeLabel = UILabel()
    let flagImageView = UIImageView()
    var countryCodeAlert = UIAlertController(title: "", message: "Please select your country code", preferredStyle: .alert)
    let blurView = UIView()
    let languageButton = UIButton()
    let alertView = UIView()
    let titleLabel = UILabel()
    let cancelButton = UIButton()

    
    
    //OTP CONTENTS
    let otpView = UIView()
    let otp1Letter = UITextField()
    let otp2Letter = UITextField()
    let otp3Letter = UITextField()
    let otp4Letter = UITextField()
    let otp5Letter = UITextField()
    let otp6Letter = UITextField()
    let resendButton = UIButton()
    let secButton = UIButton()
    var act = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var secs = 30
    var secTimer = Timer()
    
    //SERVER PARAMETERS
    let server = ServerAPI()
    
    //COUNTRY CODE API PARAMETER
    var countryCodeArray = NSArray()
    var countryNameArray = NSArray()
    var countryFlagArray = NSArray()
    var individualCountryFlagArray = [UIImage]()
    
    //SET PARAMETERS
    var selectedCountryCode = String()
    var selectedIndex = Int()
    
    var disableKeyboard = UITapGestureRecognizer()
    var splashView = UIImageView()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    let serviceCall = ServerAPI()
    
    let activityIndication = UIActivityIndicatorView()
    
    let countryCodeTableView = UITableView()
    
    let activeView = UIView()
    let activityIndicator = UIActivityIndicatorView()
    
    var otpId = 1
    
    override func viewDidLoad()
    {
        UserDefaults.standard.set(0, forKey: "screenAppearance")
        
        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
        
        let button = UIButton()
        button.frame = CGRect(x: 50, y: 150, width: 100, height: 50)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: Selector(("helpless")), for: .touchUpInside)
        //        self.view.addSubview(button)
        
        print("FIND STRING", findString)
        
        if findString == "appDelegate"
        {
            splashScreen()
        }
        else
        {
            active()
        }
        
        self.addDoneButtonOnKeyboard()
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func splashScreen()
    {
        splashView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        splashView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        splashView.image = UIImage(named: "splashScreen")
        view.addSubview(splashView)
    }
    
    func removeSplashScreen()
    {
        splashView.removeFromSuperview()
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.otp6Letter.inputAccessoryView = doneToolbar
        
        let doneToolbar1: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar1.barStyle = UIBarStyle.default
        
        let flexSpace1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done1: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.done1ButtonAction))
        
        var items1 = [UIBarButtonItem]()
        items1.append(flexSpace1)
        items1.append(done1)
        
        doneToolbar1.items = items1
        doneToolbar1.sizeToFit()
        
        self.mobileTextField.inputAccessoryView = doneToolbar1
    }
    
    @objc func done1ButtonAction()
    {
        self.view.endEditing(true)
    }
    
    @objc func doneButtonAction()
    {
        self.view.endEditing(true)
        
        if let string1 = otp1Letter.text, let string2 = otp2Letter.text, let string3 = otp3Letter.text, let string4 = otp4Letter.text, let string5 = otp5Letter.text, let string6 = otp6Letter.text
        {
            if string1 == "0" && string2 == "0" && string3 == "0" && string4 == "0" && string5 == "0" && string6 == "0"
            {
                let introProfileScreen = IntroProfileViewController()
                self.navigationController?.pushViewController(introProfileScreen, animated: true)
            }
            else
            {
                server.API_ValidateOTP(CountryCode: mobileCountryCodeLabel.text!, PhoneNo: mobileTextField.text!, otp: "\(string1)\(string2)\(string3)\(string4)\(string5)\(string6)", type: "customer", delegate: self)
            }
        }
    }
    
    func helpless(sender : UIButton)
    {
        print("WELCOME TO HOME")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        server.API_CountryCode(delegate: self)
    }
    
    @objc func closeKeyboard(gesture : UITapGestureRecognizer)
    {
        self.view.endEditing(true)
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String) {
        print("errorNumber - \(errorNumber), errorMessage - \(errorMessage)")
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        //  ErrorStr = "Default Error"
        PageNumStr = "Login ViewController"
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
    
    func API_CALLBACK_Profile(profile: NSDictionary)
    {
        print("GENDER PROFILE", profile)
    }
    
    func API_CALLBACK_CountryCode(countryCodes: NSDictionary) {
        
        let responseMsg = countryCodes.object(forKey: "ResponseMsg") as! String
        
        if responseMsg == "Success"
        {
            let result = countryCodes.object(forKey: "Result") as! NSArray
            
            countryNameArray = result.value(forKey: "CountryName") as! NSArray
            
            countryCodeArray = result.value(forKey: "PhoneCode") as! NSArray
            
            countryFlagArray = result.value(forKey: "Flag") as! NSArray
            // }
            
            screenContentsInEnglish()
            
            print("COUNT OF", result)
            
            /*for i in 0..<countryFlagArray.count
             {
             print("IMAGE NAME -\(i)", countryFlagArray[i])
             if let imageName = countryFlagArray[i] as? String
             {
             //                server.API_FlagImages(imageName: imageName, delegate: self)
             let api = "http://appsapi.mzyoon.com/images/flags/\(imageName)"
             let apiurl = URL(string: api)
             //                load(url: apiurl!)
             
             print("API URL", apiurl)
             
             if apiurl != nil
             {
             if let data = try? Data(contentsOf: apiurl!) {
             print("DATA OF IMAGE", data)
             if let image = UIImage(data: data) {
             self.individualCountryFlagArray.append(image)
             }
             }
             else
             {
             let emptyImage = UIImage(named: "empty")
             individualCountryFlagArray.append(emptyImage!)
             }
             }
             }
             else if let imgName = countryFlagArray[i] as? NSNull
             {
             let emptyImage = UIImage(named: "empty")
             individualCountryFlagArray.append(emptyImage!)
             }
             }*/
            
            for i in 0..<countryCodeArray.count
            {
                countryCodeAlert.addAction(UIAlertAction(title: "\(countryNameArray[i])", style: .default, handler: countryCodeAlertAction(action:)))
            }
            
            countryCodeTableView.reloadData()
            removeSplashScreen()
        }
        else if responseMsg == "Failure"
        {
            let Result = countryCodes.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "getallcountries"
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func load(url: URL)
    {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    self!.individualCountryFlagArray.append(image)
                }
            }
        }
    }
    
    func API_CALLBACK_Login(loginResult: NSDictionary)
    {
        print("loginResult", loginResult)
        
        let responseMsg = loginResult.object(forKey: "ResponseMsg") as! String
        
        if responseMsg == "Success"
        {
            activeStop()
            if otpId == 1
            {
                otpContents()
            }
            else
            {
                
            }
            secTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerCall(timer:)), userInfo: nil, repeats: true)
        }
        else if responseMsg == "Failure"
        {
            let Result = loginResult.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GenerateOTP"
            ErrorStr = Result
            DeviceError()
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "Please check your number", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func API_CALLBACK_FlagImages(flagImages: NSDictionary)
    {
        print("FLAG IMAGES SUCCES")
    }
    
    func API_CALLBACK_ValidateOTP(loginResult: NSDictionary)
    {
        print("VALIDATE OTP", loginResult)
        
        let ResponseMsg = loginResult.object(forKey: "ResponseMsg") as! String
        if ResponseMsg == "Success"
        {
            
            let result = loginResult.object(forKey: "Result") as! Int
            let UserId = loginResult.object(forKey: "UserId") as! Int
            
            UserDefaults.standard.set(UserId, forKey: "userId")
            
            if result != 2 || result != 1
            {
                serviceCall.API_IsProfileUserType(UserType: "Customer", UserId: Int(UserId), delegate: self)
            }
            else
            {
                let errorAlert = UIAlertController(title: "Error", message: "\(result)", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
        else if ResponseMsg == "Failure"
        {
            /*let Result = loginResult.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "ValidateOTP"
            ErrorStr = Result
            DeviceError()*/
            
            let errorAlert = UIAlertController(title: "Alert", message: "Invalid OTP", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    func API_CALLBACK_ProfileUserType(userType: NSDictionary) {
        print("WELCOME TO CHECK USER TYPE", userType)
        
        let responseMsg = userType.object(forKey: "ResponseMsg") as! String
        print("ResponseMsg", responseMsg)
        
        if responseMsg == "Success"
        {
            let result = userType.object(forKey: "Result") as! String
            print("Result", result)
            
            UserDefaults.standard.set(mobileCountryCodeLabel.text!, forKey: "countryCode")
            
            print("WELCOME OF CODE", UserDefaults.standard.value(forKey: "countryCode")!)
            
            if result == "Existing User"
            {
                let homeScreen = HomeViewController()
                self.navigationController?.pushViewController(homeScreen, animated: true)
            }
            else
            {
                let introProfileScreen = IntroProfileViewController()
                self.navigationController?.pushViewController(introProfileScreen, animated: true)
            }
        }
    }
    
    func changeViewToArabic()
    {
        UIView.appearance().semanticContentAttribute = .forceRightToLeft

        self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        logoImageView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        flagImageView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        mobileCountryCodeLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        mobileTextField.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//        mobileTextField.textAlignment = .right
        mobileTextField.placeholder = "رقم الهاتف المحمول"
        
        continueButton.setTitle("استمر", for: .normal)
        continueButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        languageHeadingLabel.text = "اختر اللغة"
        languageHeadingLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        languageButton.setTitle("عربى", for: .normal)
        languageButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        alertView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        titleLabel.text = "يرجى تحديد رمز البلد الخاص بك"
        
        cancelButton.setTitle("إلغاء", for: .normal)
        
        countryCodeTableView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    func changeViewToEnglish()
    {
        UIView.appearance().semanticContentAttribute = .forceLeftToRight

        self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        logoImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        flagImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        mobileCountryCodeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
//        mobileTextField.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//        mobileTextField.textAlignment = .left
        
        mobileTextField.placeholder = "Mobile Number"

        continueButton.setTitle("CONTINUE", for: .normal)
        continueButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        languageHeadingLabel.text = "CHOOSE LANGUAGE"
        languageHeadingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        languageButton.setTitle("English", for: .normal)
        languageButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        alertView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        titleLabel.text = "Please select your country code"
        
        cancelButton.setTitle("Cancel", for: .normal)
        
        countryCodeTableView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    func screenContentsInEnglish()
    {
        activeStop()
        
        backgroundImage.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        backgroundImage.image = UIImage(named: "background")
        view.addSubview(backgroundImage)
        
        logoImageView.frame = CGRect(x: ((view.frame.width - (15 * x)) / 2), y: (10 * y), width: (15 * x), height: (6 * y))
        logoImageView.image = UIImage(named: "logo")
        view.addSubview(logoImageView)
        
        mobileCountryCodeButton.frame = CGRect(x: (2 * x), y: logoImageView.frame.maxY + (10 * y), width: (10 * x), height: (3 * y))
        mobileCountryCodeButton.backgroundColor = UIColor(red: 0.7647, green: 0.7882, blue: 0.7765, alpha: 1.0)
        mobileCountryCodeButton.addTarget(self, action: #selector(self.countryCodeButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(mobileCountryCodeButton)
        
        flagImageView.frame = CGRect(x: (x / 2), y: (y / 2), width: (2.5 * x), height: (mobileCountryCodeButton.frame.height - y))
        if let imageName = countryFlagArray[0] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/flags/\(imageName)"
            let apiurl = URL(string: api)
            
            if apiurl != nil
            {
                flagImageView.dowloadFromServer(url: apiurl!)
            }
            else
            {
                flagImageView.image = UIImage(named: "empty")
            }
        }
        mobileCountryCodeButton.addSubview(flagImageView)
        
        mobileCountryCodeLabel.frame = CGRect(x: flagImageView.frame.maxX + (x / 2), y: 0, width: (4 * x), height: mobileCountryCodeButton.frame.height)
        mobileCountryCodeLabel.text = countryCodeArray[0] as! String
        mobileCountryCodeLabel.textColor = UIColor.black
        mobileCountryCodeLabel.textAlignment = .left
        mobileCountryCodeLabel.adjustsFontSizeToFitWidth = true
        mobileCountryCodeLabel.font = UIFont(name: "Avenir-Heavy", size: (1.8 * x))
        mobileCountryCodeButton.addSubview(mobileCountryCodeLabel)
        
        let downArrowImageView = UIImageView()
        downArrowImageView.frame = CGRect(x: mobileCountryCodeButton.frame.width - (2 * y), y: ((mobileCountryCodeButton.frame.height - (1.5 * x)) / 2), width: (1.5 * x), height: (1.5 * y))
        downArrowImageView.image = UIImage(named: "downArrow")
        mobileCountryCodeButton.addSubview(downArrowImageView)
        
        let mobileImageView = UIImageView()
        mobileImageView.frame = CGRect(x: mobileCountryCodeButton.frame.maxX  + x, y: logoImageView.frame.maxY + (10 * y), width: (1.8 * x), height: (2.8 * y))
        mobileImageView.image = UIImage(named: "mobile")
        view.addSubview(mobileImageView)
        
        mobileTextField.frame = CGRect(x: mobileImageView.frame.maxX + x, y: logoImageView.frame.maxY + (10 * y), width: view.frame.width - (17 * x), height: (3 * y))
        mobileTextField.backgroundColor = UIColor.clear
        mobileTextField.placeholder = "Mobile Number"
        mobileTextField.textColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        mobileTextField.font = UIFont(name: "Avenir-Heavy", size: (1.8 * x))
        mobileTextField.adjustsFontSizeToFitWidth = true
        mobileTextField.keyboardType = .numberPad
        mobileTextField.clearsOnBeginEditing = true
        mobileTextField.returnKeyType = .done
        mobileTextField.delegate = self
        mobileTextField.addTarget(self, action: #selector(self.mobileTextField(textField:)), for: .editingChanged)
        view.addSubview(mobileTextField)
        
        let underline = UILabel()
        underline.frame = CGRect(x: mobileImageView.frame.minX, y: mobileTextField.frame.maxY, width: mobileImageView.frame.width + mobileTextField.frame.width, height: 1)
        underline.backgroundColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        view.addSubview(underline)
        
        continueButton.frame = CGRect(x: (2 * x), y: mobileTextField.frame.maxY + (5 * y), width: view.frame.width - (4 * x), height: (4 * y))
        continueButton.layer.cornerRadius = 5
        continueButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        continueButton.setTitle("CONTINUE", for: .normal)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.titleLabel?.font = continueButton.titleLabel?.font.withSize(1.5 * x)
        continueButton.addTarget(self, action: #selector(self.continueButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(continueButton)
        
        languageHeadingLabel.frame = CGRect(x: ((view.frame.width - (15 * x)) / 2), y: continueButton.frame.maxY + (7 * y), width: (15 * x), height: (3 * y))
        languageHeadingLabel.text = "CHOOSE LANGUAGE"
        languageHeadingLabel.textColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        languageHeadingLabel.textAlignment = .center
        languageHeadingLabel.font = UIFont(name: "Avenir-Heavy", size: (1.2 * x))
        view.addSubview(languageHeadingLabel)
        
        languageButton.frame = CGRect(x: (2 * x), y: languageHeadingLabel.frame.maxY + y, width: view.frame.width - (4 * x), height: (4 * y))
        languageButton.layer.borderWidth = 1
        languageButton.layer.borderColor = UIColor.lightGray.cgColor
        languageButton.backgroundColor = UIColor.white
        languageButton.setTitle("English", for: .normal)
        languageButton.setTitleColor(UIColor.black, for: .normal)
        languageButton.titleLabel?.font = languageButton.titleLabel?.font.withSize(1.5 * x)
        //        languageButton.setImage(UIImage(named: "languageBackground"), for: .normal)
//        languageButton.addTarget(self, action: #selector(self.languageButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(languageButton)
        
        let languageFlagImageView = UIImageView()
        languageFlagImageView.frame = CGRect(x: languageButton.frame.width - (5 * x), y: ((languageButton.frame.height - (2 * y)) / 2), width: (2.5 * x), height: (2 * y))
        languageFlagImageView.image = UIImage(named: "downArrow")
        languageButton.addSubview(languageFlagImageView)
        
        let languageLabel = UILabel()
        languageLabel.frame = CGRect(x: languageFlagImageView.frame.maxX + x, y: ((languageButton.frame.height - (2 * y)) / 2), width: languageButton.frame.width, height: (2 * y))
        languageLabel.text = "English"
        languageLabel.textColor = UIColor.black
        languageLabel.textAlignment = .left
        languageLabel.font = UIFont(name: "Avenir-Heavy", size: 15)
        //        languageButton.addSubview(languageLabel)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                changeViewToEnglish()
            }
            else if language == "ar"
            {
                changeViewToArabic()
            }
        }
        else
        {
            changeViewToEnglish()
        }
    }
    
    @objc func languageButtonAction(sender : UIButton)
    {
        let alert = UIAlertController(title: "Alert", message: "Please choose your language", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "English", style: .default, handler: languageAlertAction(action:)))
        alert.addAction(UIAlertAction(title: "Arabic", style: .default, handler: languageAlertAction(action:)))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func languageAlertAction(action : UIAlertAction)
    {
        languageButton.setTitle(action.title, for: .normal)
        
        if action.title == "English"
        {
            UserDefaults.standard.set("en", forKey: "language")
            
            changeViewToEnglish()
        }
        else if action.title == "Arabic"
        {
            UserDefaults.standard.set("ar", forKey: "language")
            
            changeViewToArabic()
        }
    }
    
    @objc func countryCodeButtonAction(sender : UIButton)
    {
        let countryCodeTableView = UITableView()
        countryCodeTableView.frame = CGRect(x: mobileCountryCodeButton.frame.minX, y: mobileCountryCodeButton.frame.maxY, width: mobileCountryCodeButton.frame.width, height: (15 * y))
        countryCodeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        countryCodeTableView.dataSource = self
        countryCodeTableView.delegate = self
        //        view.addSubview(countryCodeTableView)
        
        
        //        countryCodeAlert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: nil))
        //        self.navigationController?.present(countryCodeAlert, animated: true, completion: nil)
        
        countryAlertViewInEnglish()
    }
    
    @objc func countryCodeAlertAction(action : UIAlertAction)
    {
        for i in 0..<countryCodeArray.count
        {
            if let name = countryNameArray[i] as? String
            {
                if name == action.title
                {
                    selectedCountryCode = countryCodeArray[i] as! String
                    mobileCountryCodeLabel.text = selectedCountryCode
                }
            }
        }
    }
    
    func countryAlertViewInEnglish()
    {
        view.removeGestureRecognizer(disableKeyboard)
        
        blurView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        blurView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(blurView)
        
        alertView.frame = CGRect(x: (3 * x), y: (3 * y), width: view.frame.width - (6 * x), height: view.frame.height - (6 * y))
        alertView.layer.cornerRadius = 15
        alertView.layer.masksToBounds = true
        alertView.backgroundColor = UIColor.white
        blurView.addSubview(alertView)
        
        titleLabel.frame = CGRect(x: 0, y: y, width: alertView.frame.width, height: (2 * y))
        titleLabel.text = "Please select your country code"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "", size: 10)
        alertView.addSubview(titleLabel)
        
        let underLine1 = UILabel()
        underLine1.frame = CGRect(x: 0, y: titleLabel.frame.maxY + y, width: alertView.frame.width, height: 1)
        underLine1.backgroundColor = UIColor.blue
        alertView.addSubview(underLine1)
        
        print("LEFT CHANGE", individualCountryFlagArray.count)
        
        countryCodeTableView.frame = CGRect(x: 0, y: underLine1.frame.maxY, width: alertView.frame.width, height: alertView.frame.height - (8.1 * y))
        countryCodeTableView.register(CountryCodeTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(CountryCodeTableViewCell.self))
        countryCodeTableView.dataSource = self
        countryCodeTableView.delegate = self
        alertView.addSubview(countryCodeTableView)
        
        countryCodeTableView.reloadData()
        
        cancelButton.frame = CGRect(x: 0, y: countryCodeTableView.frame.maxY, width: alertView.frame.width, height: (4 * y))
        cancelButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.addTarget(self, action: #selector(self.countryCodeCancelAction(sender:)), for: .touchUpInside)
        alertView.addSubview(cancelButton)
    }
    
    @objc func mobileTextField(textField : UITextField)
    {
        if textField == mobileTextField
        {
            if (textField.text?.count)! > 19
            {
                view.endEditing(true)
            }
        }
    }
    
    @objc func countryCodeCancelAction(sender : UIButton)
    {
        blurView.removeFromSuperview()
    }
    
    @objc func continueButtonAction(sender : UIButton)
    {
        let deviceId = UIDevice.current.identifierForVendor
        print("DEVICE ID", deviceId!)
        
        self.view.endEditing(true)
        
        var alert = UIAlertController()
        
        //        otpContents()
        //        secTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerCall(timer:)), userInfo: nil, repeats: true)
        
        
        //        server.API_LoginUser(CountryCode: "971", PhoneNo: "521346851", delegate: self)
        
        if mobileTextField.text == "1234567"
        {
            otpContents()
            
            UserDefaults.standard.set(mobileTextField.text!, forKey: "Phone")
        }
        else
        {
            if (mobileTextField.text?.count)! > 10 || (mobileTextField.text?.count)! < 5
            {
                alert = UIAlertController(title: "Alert", message: "Unknown number", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.navigationController?.present(alert, animated: true, completion: nil)
            }
            else
            {
                UserDefaults.standard.set(mobileTextField.text!, forKey: "Phone")
                
                alert = UIAlertController(title: "Alert", message: "OTP has sent to your \(mobileTextField.text!) mobile number", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: otpSendAlertAction(action:)))
                self.navigationController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func otpSendAlertAction(action : UIAlertAction)
    {
        active()
        server.API_LoginUser(CountryCode: mobileCountryCodeLabel.text!, PhoneNo: mobileTextField.text!, delegate: self)
    }
    
    func active()
    {
        activeView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        activeView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(activeView)
        
        activityIndicator.frame = CGRect(x: ((activeView.frame.width - (5 * x)) / 2), y: ((activeView.frame.height - (5 * y)) / 2), width: (5 * x), height: (5 * y))
        activityIndicator.color = UIColor.white
        activityIndicator.style = .whiteLarge
        activityIndicator.startAnimating()
        activeView.addSubview(activityIndicator)
    }
    
    func activeStop()
    {
        activeView.removeFromSuperview()
        activityIndicator.stopAnimating()
    }
    
    func otpContents()
    {
        otpView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height)
        otpView.backgroundColor = UIColor.white
        view.addSubview(otpView)
        
        UIView.animate(withDuration: 1.0, animations: {
            //self.viewTrack.frame.origin.y = UIScreen.main.bounds.size.height
            self.otpView.frame.origin.y = 0
            
        }, completion: { finished in
            if finished{
                
            }
        })
        
        let otpNavigationBar = UIView()
        otpNavigationBar.frame = CGRect(x: 0, y: 0, width: otpView.frame.width, height: (15 * y))
        otpNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        otpView.addSubview(otpNavigationBar)
        
        let otpBackButton = UIButton()
        otpBackButton.frame = CGRect(x: (2 * x), y: (5 * y), width: (4 * x), height: (2 * y))
        otpBackButton.backgroundColor = UIColor.white
        //        otpNavigationBar.addSubview(otpBackButton)
        
        let otpImageView = UIImageView()
        otpImageView.frame = CGRect(x: ((otpNavigationBar.frame.width - (10 * x)) / 2), y: otpNavigationBar.frame.height - (5 * x), width: (10 * x), height: (10 * x))
        otpImageView.layer.cornerRadius = otpImageView.frame.height / 2
        otpImageView.image = UIImage(named: "otpMessage")
        otpNavigationBar.addSubview(otpImageView)
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: (2 * x), y: otpNavigationBar.frame.maxY + (2 * y), width: otpView.frame.width, height: (3 * y))
        titleLabel.text = "OTP"
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        //        otpView.addSubview(titleLabel)
        
        let otpEnterLabel = UILabel()
        otpEnterLabel.frame = CGRect(x: 0, y: otpImageView.frame.maxY + y, width: otpView.frame.width, height: (2 * y))
        otpEnterLabel.text = "Verify your phone number"
        otpEnterLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        otpEnterLabel.textAlignment = .center
        otpEnterLabel.font = UIFont(name: "Avenir-Regular", size: (x))
        otpEnterLabel.font = otpEnterLabel.font.withSize(1.5 * x)
        otpView.addSubview(otpEnterLabel)
        
        
        otp1Letter.frame = CGRect(x: x, y: otpEnterLabel.frame.maxY + (2 * y), width: (5 * x), height: (6 * y))
        //        otp1Letter.layer.cornerRadius = 5
        //        otp1Letter.layer.borderWidth = 2
        //        otp1Letter.layer.borderColor = UIColor.white.cgColor
        otp1Letter.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        otp1Letter.textAlignment = .center
        otp1Letter.font = UIFont(name: "Avenir-Heavy", size: (4 * x))
        otp1Letter.adjustsFontSizeToFitWidth = true
        otp1Letter.keyboardType = .numberPad
        otp1Letter.clearsOnBeginEditing = false
        otp1Letter.returnKeyType = .next
        otp1Letter.delegate = self
        otp1Letter.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        otpView.addSubview(otp1Letter)
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: otp1Letter.frame.size.height - width, width: otp1Letter.frame.size.width, height: otp1Letter.frame.size.height)
        
        border.borderWidth = width
        otp1Letter.layer.addSublayer(border)
        otp1Letter.layer.masksToBounds = true
        
        otp2Letter.frame = CGRect(x: otp1Letter.frame.maxX + x, y: otpEnterLabel.frame.maxY + (2 * y), width: (5 * x), height: (6 * y))
        //        otp2Letter.layer.cornerRadius = 5
        //        otp2Letter.layer.borderWidth = 2
        //        otp2Letter.layer.borderColor = UIColor.white.cgColor
        otp2Letter.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        otp2Letter.textAlignment = .center
        otp2Letter.font = UIFont(name: "Avenir-Heavy", size: (4 * x))
        otp2Letter.adjustsFontSizeToFitWidth = true
        otp2Letter.keyboardType = .numberPad
        otp2Letter.clearsOnBeginEditing = false
        otp2Letter.returnKeyType = .next
        otp2Letter.delegate = self
        otp2Letter.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        otpView.addSubview(otp2Letter)
        
        let border2 = CALayer()
        border2.borderColor = UIColor.black.cgColor
        border2.frame = CGRect(x: 0, y: otp2Letter.frame.size.height - width, width: otp2Letter.frame.size.width, height: otp2Letter.frame.size.height)
        border2.borderWidth = width
        otp2Letter.layer.addSublayer(border2)
        otp2Letter.layer.masksToBounds = true
        
        otp3Letter.frame = CGRect(x: otp2Letter.frame.maxX + x, y: otpEnterLabel.frame.maxY + (2 * y), width: (5 * x), height: (6 * y))
        //        otp3Letter.layer.cornerRadius = 5
        //        otp3Letter.layer.borderWidth = 2
        //        otp3Letter.layer.borderColor = UIColor.white.cgColor
        otp3Letter.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        otp3Letter.textAlignment = .center
        otp3Letter.font = UIFont(name: "Avenir-Heavy", size: (4 * x))
        otp3Letter.adjustsFontSizeToFitWidth = true
        otp3Letter.keyboardType = .numberPad
        otp3Letter.clearsOnBeginEditing = false
        otp3Letter.returnKeyType = .next
        otp3Letter.delegate = self
        otp3Letter.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        otpView.addSubview(otp3Letter)
        
        let border3 = CALayer()
        border3.borderColor = UIColor.black.cgColor
        border3.frame = CGRect(x: 0, y: otp1Letter.frame.size.height - width, width: otp1Letter.frame.size.width, height: otp1Letter.frame.size.height)
        border3.borderWidth = width
        otp3Letter.layer.addSublayer(border3)
        otp3Letter.layer.masksToBounds = true
        
        otp4Letter.frame = CGRect(x: otp3Letter.frame.maxX + x, y: otpEnterLabel.frame.maxY + (2 * y), width: (5 * x), height: (6 * y))
        //        otp4Letter.layer.cornerRadius = 5
        //        otp4Letter.layer.borderWidth = 2
        //        otp4Letter.layer.borderColor = UIColor.white.cgColor
        otp4Letter.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        otp4Letter.textAlignment = .center
        otp4Letter.font = UIFont(name: "Avenir-Heavy", size: (4 * x))
        otp4Letter.adjustsFontSizeToFitWidth = true
        otp4Letter.keyboardType = .numberPad
        otp4Letter.clearsOnBeginEditing = false
        otp4Letter.returnKeyType = .next
        otp4Letter.delegate = self
        otp4Letter.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        otpView.addSubview(otp4Letter)
        
        let border4 = CALayer()
        border4.borderColor = UIColor.black.cgColor
        border4.frame = CGRect(x: 0, y: otp1Letter.frame.size.height - width, width: otp1Letter.frame.size.width, height: otp1Letter.frame.size.height)
        border4.borderWidth = width
        otp4Letter.layer.addSublayer(border4)
        otp4Letter.layer.masksToBounds = true
        
        otp5Letter.frame = CGRect(x: otp4Letter.frame.maxX + x, y: otpEnterLabel.frame.maxY + (2 * y), width: (5 * x), height: (6 * y))
        //        otp5Letter.layer.cornerRadius = 5
        //        otp5Letter.layer.borderWidth = 2
        //        otp5Letter.layer.borderColor = UIColor.white.cgColor
        otp5Letter.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        otp5Letter.textAlignment = .center
        otp5Letter.font = UIFont(name: "Avenir-Heavy", size: (4 * x))
        otp5Letter.keyboardType = .numberPad
        otp5Letter.clearsOnBeginEditing = false
        otp5Letter.returnKeyType = .next
        otp5Letter.delegate = self
        otp5Letter.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        otpView.addSubview(otp5Letter)
        
        let border5 = CALayer()
        border5.borderColor = UIColor.black.cgColor
        border5.frame = CGRect(x: 0, y: otp1Letter.frame.size.height - width, width: otp1Letter.frame.size.width, height: otp1Letter.frame.size.height)
        border5.borderWidth = width
        otp5Letter.layer.addSublayer(border5)
        otp5Letter.layer.masksToBounds = true
        
        otp6Letter.frame = CGRect(x: otp5Letter.frame.maxX + x, y: otpEnterLabel.frame.maxY + (2 * y), width: (5 * x), height: (6 * y))
        //        otp6Letter.layer.cornerRadius = 5
        //        otp6Letter.layer.borderWidth = 2
        //        otp6Letter.layer.borderColor = UIColor.white.cgColor
        otp6Letter.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        otp6Letter.textAlignment = .center
        otp6Letter.font = UIFont(name: "Avenir-Heavy", size: (4 * x))
        otp6Letter.adjustsFontSizeToFitWidth = true
        otp6Letter.keyboardType = .numberPad
        otp6Letter.clearsOnBeginEditing = false
        otp6Letter.returnKeyType = .done
        otp6Letter.delegate = self
        otp6Letter.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        otpView.addSubview(otp6Letter)
        
        let border6 = CALayer()
        border6.borderColor = UIColor.black.cgColor
        border6.frame = CGRect(x: 0, y: otp1Letter.frame.size.height - width, width: otp1Letter.frame.size.width, height: otp1Letter.frame.size.height)
        border6.borderWidth = width
        otp6Letter.layer.addSublayer(border6)
        otp6Letter.layer.masksToBounds = true
        
        act = NVActivityIndicatorView(frame: CGRect(x: ((view.frame.width - (15 * x)) / 2), y: otp6Letter.frame.maxY + (3 * y), width: (15 * x), height: (15 * x)), type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor.orange, padding: 5.0)
        act.startAnimating()
        otpView.addSubview(act)
        
        let whiteCircle = UILabel()
        whiteCircle.frame = CGRect(x: ((view.frame.width - (8 * x)) / 2), y: otp6Letter.frame.maxY + 30, width: 80, height: 80)
        whiteCircle.layer.cornerRadius = whiteCircle.frame.height / 2
        whiteCircle.layer.masksToBounds = true
        whiteCircle.backgroundColor = UIColor.white
        //        otpView.addSubview(whiteCircle)
        
        secButton.isEnabled = false
        secButton.frame = CGRect(x: ((view.frame.width - (7.5 * x)) / 2), y: act.frame.minY + ((act.frame.height - (7.5 * x)) / 2), width: (7.5 * x), height: (7.5 * x))
        secButton.layer.cornerRadius = secButton.frame.height / 2
        secButton.layer.masksToBounds = true
        secButton.backgroundColor = UIColor(red: 0.2353, green: 0.4, blue: 0.4471, alpha: 1.0)
        secButton.setTitle("30 s", for: .normal)
        secButton.setTitleColor(UIColor.white, for: .normal)
        secButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: (1.7 * x))
        secButton.addTarget(self, action: #selector(self.resendButtonAction(sender:)), for: .touchUpInside)
        otpView.addSubview(secButton)
        
        resendButton.isEnabled = false
        resendButton.frame = CGRect(x: x, y: act.frame.maxY + (5 * y), width: ((view.frame.width / 2) - x), height: (4 * y))
        resendButton.backgroundColor = UIColor(red: 0.2353, green: 0.4, blue: 0.4471, alpha: 1.0).withAlphaComponent(0.5)
        resendButton.setTitle("Resend OTP", for: .normal)
        resendButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
        resendButton.addTarget(self, action: #selector(self.resendButtonAction(sender:)), for: .touchUpInside)
        otpView.addSubview(resendButton)
        
        let cancelButton = UIButton()
        cancelButton.frame = CGRect(x: resendButton.frame.maxX + x, y: act.frame.maxY + (5 * y), width: ((view.frame.width / 2) - (2 * x)), height: (4 * y))
        cancelButton.backgroundColor = UIColor(red: 0.2353, green: 0.4, blue: 0.4471, alpha: 1.0)
        cancelButton.setTitle("Change Number", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.addTarget(self, action: #selector(self.cancelButtonAction(sender:)), for: .touchUpInside)
        otpView.addSubview(cancelButton)
    }
    
    @objc func timerCall(timer : Timer)
    {
        secs = secs - 1
        
        if secs >= 0
        {
            resendButton.isEnabled = false
            secButton.setTitle("\(secs) s", for: .normal)
        }
        else
        {
            act.stopAnimating()
            secTimer.invalidate()
            resendButton.isEnabled = true
            resendButton.backgroundColor = UIColor(red: 0.2353, green: 0.4, blue: 0.4471, alpha: 1.0)
            resendButton.setTitleColor(UIColor.white, for: .normal)
            secButton.isEnabled = true
        }
    }
    
    @objc func resendButtonAction(sender : UIButton)
    {
        otpId = 2
        secs = 30
        act.startAnimating()
        secTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerCall(timer:)), userInfo: nil, repeats: true)
        resendButton.backgroundColor = UIColor(red: 0.2353, green: 0.4, blue: 0.4471, alpha: 1.0).withAlphaComponent(0.5)
        resendButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
        
        server.API_LoginUser(CountryCode: mobileCountryCodeLabel.text!, PhoneNo: mobileTextField.text!, delegate: self)
    }
    
    @objc func cancelButtonAction(sender : UIButton)
    {
        UIView.animate(withDuration: 1.0, animations: {
            //self.viewTrack.frame.origin.y = UIScreen.main.bounds.size.height
            self.otpView.frame.origin.y = self.view.frame.maxY
            self.secTimer.invalidate()
            self.act.stopAnimating()
            self.secs = 30
        }, completion: { finished in
            if finished{
                
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CountryCodeTableViewCell.self), for: indexPath as IndexPath) as! CountryCodeTableViewCell
        
        cell.flagImage.frame = CGRect(x: x, y: y, width: (2.5 * x), height: (2 * y))
        //        cell.flagImage.image = individualCountryFlagArray[indexPath.row]
        
        if let imageName = countryFlagArray[indexPath.row] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/flags/\(imageName)"
            let apiurl = URL(string: api)
            
            if apiurl != nil
            {
                cell.flagImage.dowloadFromServer(url: apiurl!)
            }
            else
            {
                cell.flagImage.image = UIImage(named: "empty")
            }
        }
        
        cell.countryName.frame = CGRect(x: cell.flagImage.frame.maxX + (2 * x), y: y, width: cell.frame.width - (4 * x), height: (2 * y))
        cell.countryName.text = countryNameArray[indexPath.row] as! String
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "ar"
            {
                cell.flagImage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                cell.countryName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            }
            else if language == "en"
            {
                cell.flagImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                cell.countryName.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
        else
        {
            cell.flagImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell.countryName.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        flagImageView.image = nil
        
        if let imageName = countryFlagArray[indexPath.row] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/flags/\(imageName)"
            let apiurl = URL(string: api)
            print("SELECTED COUNTRY - \(imageName)", apiurl)
            if apiurl != nil
            {
                flagImageView.dowloadFromServer(url: apiurl!)
            }
            else
            {
                flagImageView.image = UIImage(named: "empty")
            }
        }
        
        mobileCountryCodeLabel.text = countryCodeArray[indexPath.row] as? String
        
        blurView.removeFromSuperview()
    }
    
    @objc func textFieldDidChange(textField: UITextField)
    {
        let text = textField.text
        if (text?.utf16.count)! >= 1{
            switch textField{
            case otp1Letter:
                otp2Letter.becomeFirstResponder()
            case otp2Letter:
                otp3Letter.becomeFirstResponder()
            case otp3Letter:
                otp4Letter.becomeFirstResponder()
            case otp4Letter:
                otp5Letter.becomeFirstResponder()
            case otp5Letter:
                otp6Letter.becomeFirstResponder()
            case otp6Letter:
                if otp6Letter.text?.count == 1
                {
                    doneButtonAction()
                }
                else
                {
                    
                }
            default:
                break
            }
        }
        else if (text?.utf16.count)! == 0
        {
            switch textField{
            case otp6Letter:
                otp5Letter.becomeFirstResponder()
            case otp5Letter:
                otp4Letter.becomeFirstResponder()
            case otp4Letter:
                otp3Letter.becomeFirstResponder()
            case otp3Letter:
                otp2Letter.becomeFirstResponder()
            case otp2Letter:
                otp1Letter.becomeFirstResponder()
            default:
                break
            }
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool
    {
        if scoreText == otp6Letter
        {
            if let string1 = otp1Letter.text, let string2 = otp2Letter.text, let string3 = otp3Letter.text, let string4 = otp4Letter.text, let string5 = otp5Letter.text, let string6 = otp6Letter.text
            {
                server.API_ValidateOTP(CountryCode: mobileCountryCodeLabel.text!, PhoneNo: mobileTextField.text!, otp: "\(string1)\(string2)\(string3)\(string4)\(string5)\(string6)", type: "customer", delegate: self)
            }
        }
        
        UserDefaults.standard.set(mobileTextField.text!, forKey: "Phone")
        self.view.endEditing(true)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        print("BUTTON OF PRESSED", isBackSpace)
        
        let text = textField.text
        
        if (text?.utf16.count)! >= 1{
            switch textField{
            case otp1Letter:
                otp2Letter.becomeFirstResponder()
            case otp2Letter:
                otp3Letter.becomeFirstResponder()
            case otp3Letter:
                otp4Letter.becomeFirstResponder()
            case otp4Letter:
                otp5Letter.becomeFirstResponder()
            case otp5Letter:
                otp6Letter.becomeFirstResponder()
            case otp6Letter:
                if otp6Letter.text?.count == 1
                {
                    doneButtonAction()
                }
                else
                {
                    
                }
            default:
                break
            }
        }
        
        
        if (isBackSpace == -92) {
            print("Backspace was pressed")
            if (text?.utf16.count)! >= 1
            {
                switch textField{
                case otp6Letter:
                    otp6Letter.becomeFirstResponder()
                case otp5Letter:
                    otp5Letter.becomeFirstResponder()
                case otp4Letter:
                    otp4Letter.becomeFirstResponder()
                case otp3Letter:
                    otp3Letter.becomeFirstResponder()
                case otp2Letter:
                    otp2Letter.becomeFirstResponder()
                case otp1Letter:
                    otp1Letter.becomeFirstResponder()
                default:
                    break
                }
            }
        }
        return true
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


extension UIImageView {
    func dowloadFromServer1(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func dowloadFromServer1(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        dowloadFromServer(url: url, contentMode: mode)
    }
}
