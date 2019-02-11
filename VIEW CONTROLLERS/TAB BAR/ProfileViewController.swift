//
//  ProfileViewController.swift
//  Mzyoon
//
//  Created by QOL on 29/10/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UIGestureRecognizerDelegate, UITextFieldDelegate, ServerAPIDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate
{
    var x = CGFloat()
    var y = CGFloat()
    
    let userImage = UIImageView()
    var imagePicker = UIImagePickerController()
    let cameraButton = UIButton()
    
    
    let userName = UITextField()
    let mobileNumber = UITextField()
    let email = UITextField()
    let dob = UITextField()
    let calendarButton = UIButton()
    let genderHeadingLabel = UILabel()
    let genderButton = UIButton()
    let maleButton = UIButton()
    let genderLabel = UILabel()
    let femaleButton = UIButton()
    let updateButton = UIButton()
    let genderTableView = UITableView()
    let genders = ["Male", "Female"]
    
    let cancelButton = UIButton()
    let saveButton = UIButton()
    var GenderStr = String()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    let serviceCall = ServerAPI()
    
    var datePick = UIDatePicker()
    
    var getEmail = String()
    var getDOB = String()
    var getGender = String()
    
    var imageName = NSArray()
    
    var profileImage = UIImage()
    
    override func viewDidLoad()
    {
        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
        
        view.backgroundColor = UIColor.white
        
        if let userId = UserDefaults.standard.value(forKey: "userId") as? String
        {
            serviceCall.API_ExistingUserProfile(Id: userId, delegate: self)
        }
        else if let userId = UserDefaults.standard.value(forKey: "userId") as? Int
        {
            serviceCall.API_ExistingUserProfile(Id: "\(userId)", delegate: self)
        }
        
        //        let closeKeyboard = UITapGestureRecognizer(target: self, action: #selector(self.closeKeyboard(gesture:)))
        //        closeKeyboard.delegate = self
        //        view.addGestureRecognizer(closeKeyboard)
        
        //        NotificationCenter.default.addObserver(self, selector: Selector(("keyboardWillShow:")), name: UIResponder.keyboardWillShowNotification, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: Selector(("keyboardWillHide:")), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
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
        
        dob.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
    @objc func closeKeyboard(gesture : UITapGestureRecognizer)
    {
        self.view.endEditing(true)
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("Profile update", errorMessage)
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        //  ErrorStr = "Default Error"
        PageNumStr = "ProfileViewController"
        //  MethodName = "do"
        
        print("UUID", UIDevice.current.identifierForVendor?.uuidString as Any)
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
    }
    
    func API_CALLBACK_ExistingUserProfile(userProfile: NSDictionary)
    {
        print("SELF OF EXISTING USER", userProfile)
        
        let responseMsg = userProfile.object(forKey: "ResponseMsg") as! String
        
        if responseMsg == "Success"
        {
            let result = userProfile.object(forKey: "Result") as! NSArray
            print("RESULT IN EXISTING", result)
            
            let name = result.value(forKey: "Name") as! NSArray
            print("NAME", name)
            
            if let getName = name[0] as? String
            {
                UserDefaults.standard.set(getName, forKey: "userName")
            }
            
            
            let dob = result.value(forKey: "Dob") as! NSArray
            print("DOB", dob)
            
            if dob.count != 0
            {
                if let date = dob[0] as? String
                {
                    getDOB = String(date.prefix(10))
                }
            }
            
            
            //            UserDefaults.standard.set(dob[0], forKey: "dob")
            
            let mobileNumber = result.value(forKey: "PhoneNumber") as! NSArray
            print("MOBILE NUMBER", mobileNumber)
            
            UserDefaults.standard.set(mobileNumber[0], forKey: "mobileNumber")
            
            let email = result.value(forKey: "Email") as! NSArray
            print("EMAIL", email)
            
            if email.count != 0
            {
                if let mail = email[0] as? String
                {
                    getEmail = mail
                }
            }
            
            let gender = result.value(forKey: "Gender") as! NSArray
            print("Gender", gender)
            
            if gender.count != 0
            {
                if let gen = gender[0] as? String
                {
                    getGender = gen
                    GenderStr = getGender
                }
            }
            
            imageName = result.value(forKey: "ProfilePicture") as! NSArray
            
            //            UserDefaults.standard.set(email[0], forKey: "email")
        }
        
        screenContents()
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
    
    func API_CALLBACK_ProfileUpdate(profUpdate: NSDictionary)
    {
        let ResponseMsg = profUpdate.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = profUpdate.object(forKey: "Result") as! String
            print("Result", Result)
            
            if Result == "1"
            {
                let alert = UIAlertController(title: "", message: "Updated Sucessfully", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: savedAlertAction(action:)))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = profUpdate.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "InsertBuyerDetails"
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func API_CALLBACK_ProfileImageUpload(ImageUpload: NSDictionary)
    {
        let ResponseMsg = ImageUpload.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = ImageUpload.object(forKey: "Result") as! NSArray
            print("Result", Result[0])
            
            if let file1 = Result[0] as? String
            {
                let splitted = file1.split(separator: "\\")
                print("SPLITTED", splitted)
                
                let imageName = splitted.last
                print("IMAGE NAME", imageName!)
                
                if let profId = UserDefaults.standard.value(forKey: "userId") as? String
                {
                    serviceCall.API_IntroProfile(Id: profId, Name: userName.text!, profilePic: String(imageName!), delegate: self)
                }
                else if let profId = UserDefaults.standard.value(forKey: "userId") as? Int
                {
                    serviceCall.API_IntroProfile(Id: "\(profId)", Name: userName.text!, profilePic: String(imageName!), delegate: self)
                }
            }
        }
        else if ResponseMsg == "Failure"
        {
            let Result = ImageUpload.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "ImageUpload"
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func API_CALLBACK_IntroProfile(introProf: NSDictionary)
    {
        print("introProf", introProf)
        let ResponseMsg = introProf.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = introProf.object(forKey: "Result") as! String
            print("Result", Result)
            
            if Result == "1"
            {
                var userId = String()
                
                
                if let ProfId = UserDefaults.standard.value(forKey: "userId") as? String
                {
                    userId = ProfId
                }
                else if let ProfId = UserDefaults.standard.value(forKey: "userId") as? Int
                {
                    userId = "\(ProfId)"
                }
            
                let EmailID = email.text
                let DobStr = dob.text
                let ModifyStr = "user"
                
                serviceCall.API_ProfileUpdate(Id: userId, Email: EmailID!, Dob: DobStr!, Gender: GenderStr, ModifiedBy: ModifyStr, delegate: self)
            }
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = introProf.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "InsertBuyerName"
            ErrorStr = Result
            DeviceError()
        }
        
    }
    
    func savedAlertAction(action : UIAlertAction)
    {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(true)
    //        // Show the Navigation Bar
    //        self.navigationController?.isNavigationBarHidden = false
    //        self.navigationController?.navigationBar.topItem?.title = "PROFILE"
    //    }
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(true)
    //        // Hide the Navigation Bar
    //        self.navigationController?.isNavigationBarHidden = true
    //    }
    
    
    func screenContents()
    {
        let backgroundImage = UIImageView()
        backgroundImage.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        backgroundImage.image = UIImage(named: "background")
        view.addSubview(backgroundImage)
        
        let navigationBar = UIView()
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        navigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        view.addSubview(navigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(self.backButtonAction(sender:)), for: .touchUpInside)
        backButton.tag = 3
        navigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2 * y), width: navigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "PROFILE"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        navigationBar.addSubview(navigationTitle)
        
        userImage.frame = CGRect(x: ((view.frame.width - (15 * x)) / 2), y: navigationBar.frame.maxY + y, width: (15 * x), height: (15 * x))
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.backgroundColor = UIColor.white
        userImage.layer.masksToBounds = true
        if let imageName = imageName[0] as? String
        {
            let api = "http://appsapi.mzyoon.com/Images/BuyerImages/\(imageName)"

            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            if apiurl != nil
            {
                userImage.dowloadFromServer(url: apiurl!)
            }
        }

        userImage.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleBottomMargin.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue | UIView.AutoresizingMask.flexibleRightMargin.rawValue | UIView.AutoresizingMask.flexibleLeftMargin.rawValue | UIView.AutoresizingMask.flexibleTopMargin.rawValue | UIView.AutoresizingMask.flexibleWidth.rawValue)
        userImage.contentMode = .scaleToFill
        backgroundImage.addSubview(userImage)
        
        cameraButton.isEnabled = false
        cameraButton.frame = CGRect(x: userImage.frame.maxX - (5 * x), y: userImage.frame.maxY - (5 * y), width: (5 * x), height: (5 * x))
        cameraButton.backgroundColor = UIColor.white
        cameraButton.layer.cornerRadius = cameraButton.frame.height / 2
        cameraButton.setImage(UIImage(named: "camera"), for: .normal)
        cameraButton.addTarget(self, action: #selector(self.cameraButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(cameraButton)
        
        let nameIcon = UIImageView()
        nameIcon.frame = CGRect(x: (3 * x), y: userImage.frame.maxY + (4 * y), width: (2.5 * x), height: (2 * y))
        nameIcon.image = UIImage(named: "account")
        view.addSubview(nameIcon)
        
        userName.isUserInteractionEnabled = false
        userName.frame = CGRect(x: nameIcon.frame.maxX + x, y: userImage.frame.maxY + (4 * y), width: view.frame.width - (7 * x), height: (2 * y))
        if let getUserName = UserDefaults.standard.value(forKey: "userName") as? String
        {
            userName.text = getUserName
        }
        else
        {
            userName.placeholder = "Please enter your name"
        }
        userName.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        userName.delegate = self
        view.addSubview(userName)
        
        let nameUnderline = UILabel()
        nameUnderline.frame = CGRect(x: (3 * x), y: nameIcon.frame.maxY + 2, width: view.frame.width - (6 * x), height: 1)
        nameUnderline.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        view.addSubview(nameUnderline)
        
        let mobileIcon = UIImageView()
        mobileIcon.frame = CGRect(x: (3 * x), y: nameIcon.frame.maxY + (4 * y), width: (2 * y), height: (2 * y))
        mobileIcon.image = UIImage(named: "mobile-number")
        view.addSubview(mobileIcon)
        
        mobileNumber.isUserInteractionEnabled = false
        mobileNumber.frame = CGRect(x: nameIcon.frame.maxX + x, y: nameIcon.frame.maxY + (4 * y), width: view.frame.width - (7 * x), height: (2 * y))
        if let getMobileNumber = UserDefaults.standard.value(forKey: "Phone") as? String
        {
            mobileNumber.text = getMobileNumber
        }
        else
        {
            mobileNumber.placeholder = "Please enter your mobile number"
        }
        mobileNumber.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        mobileNumber.delegate = self
        view.addSubview(mobileNumber)
        
        let mobileUnderline = UILabel()
        mobileUnderline.frame = CGRect(x: (3 * x), y: mobileIcon.frame.maxY + 2, width: view.frame.width - (6 * x), height: 1)
        mobileUnderline.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        view.addSubview(mobileUnderline)
        
        let emailIcon = UIImageView()
        emailIcon.frame = CGRect(x: (3 * x), y: mobileIcon.frame.maxY + (4 * y), width: (2 * y), height: (2 * y))
        emailIcon.image = UIImage(named: "email")
        view.addSubview(emailIcon)
        
        email.isUserInteractionEnabled = false
        email.frame = CGRect(x: nameIcon.frame.maxX + x, y: mobileIcon.frame.maxY + (4 * y), width: view.frame.width - (7 * x), height: (2 * y))
        if getEmail.isEmpty == true
        {
            email.placeholder = "Please enter your email"
        }
        else
        {
            email.text = getEmail
        }
        email.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        email.delegate = self
        view.addSubview(email)
        
        let emailUnderline = UILabel()
        emailUnderline.frame = CGRect(x: (3 * x), y: emailIcon.frame.maxY + 2, width: view.frame.width - (6 * x), height: 1)
        emailUnderline.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        view.addSubview(emailUnderline)
        
        let dobIcon = UIImageView()
        dobIcon.frame = CGRect(x: (3 * x), y: emailIcon.frame.maxY + (4 * y), width: (2.5 * x), height: (2 * y))
        dobIcon.image = UIImage(named: "dob")
        view.addSubview(dobIcon)
        
        dob.isUserInteractionEnabled = false
        dob.frame = CGRect(x: nameIcon.frame.maxX + x, y: emailIcon.frame.maxY + (4 * y), width: view.frame.width - (12 * x), height: (2 * y))
        if getDOB.isEmpty == true
        {
            dob.placeholder = "mm/dd/yyyy - Date of Birth"
        }
        else
        {
            dob.text = getDOB
        }
        dob.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        dob.addTarget(self, action: #selector(self.calendarButtonAction), for: .allEditingEvents)
        dob.delegate = self
        view.addSubview(dob)
        
        calendarButton.frame = CGRect(x: view.frame.width - (5 * x), y: emailIcon.frame.maxY + (4 * y), width: (2 * x), height: (2 * y))
        calendarButton.setImage(UIImage(named: "calender"), for: .normal)
        calendarButton.addTarget(self, action: #selector(self.calendarButtonAction), for: .touchUpInside)
        view.addSubview(calendarButton)
        
        let dobUnderline = UILabel()
        dobUnderline.frame = CGRect(x: (3 * x), y: dobIcon.frame.maxY + 2, width: view.frame.width - (6 * x), height: 1)
        dobUnderline.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        view.addSubview(dobUnderline)
        
        genderHeadingLabel.frame = CGRect(x: (3 * x), y: dobUnderline.frame.maxY + (2 * y), width: (7 * x), height: (2 * y))
        genderHeadingLabel.text = "Gender : "
        genderHeadingLabel.textColor = UIColor.black
        genderHeadingLabel.textAlignment = .left
        view.addSubview(genderHeadingLabel)
        
        if getGender.isEmpty == true || getGender == ""
        {
            genderHeadingLabel.isHidden = true
        }
        else
        {
            genderHeadingLabel.isHidden = false
        }
        
        genderButton.isEnabled = false
        genderButton.frame = CGRect(x: (3 * x), y: genderHeadingLabel.frame.maxY + y, width: view.frame.width - (6 * x), height: (4 * y))
        //        genderButton.text = "Gender"
        //        genderButton.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        //        genderButton.textAlignment = .left
        genderButton.layer.borderWidth = 1
        genderButton.layer.borderColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85).cgColor
        genderButton.backgroundColor = UIColor.white
        genderButton.tag = 1
        genderButton.addTarget(self, action: #selector(self.genderButtonActions(sender:)), for: .touchUpInside)
        view.addSubview(genderButton)
        
        let genderImageView = UIImageView()
        genderImageView.frame = CGRect(x: x, y: y, width: (3 * x), height: (2 * y))
        genderImageView.image = UIImage(named: "gender")
        genderButton.addSubview(genderImageView)
        
        genderLabel.frame = CGRect(x: genderImageView.frame.maxX + (2 * x), y: 0, width: genderButton.frame.width - (6 * x), height: (4 * y))
        if getGender.isEmpty == true
        {
            genderLabel.text = "Gender"
        }
        else
        {
            genderLabel.text = getGender
        }
        genderLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        genderLabel.textAlignment = .left
        genderButton.addSubview(genderLabel)
        
        let dropDownImageView = UIImageView()
        dropDownImageView.frame = CGRect(x: genderButton.frame.width - (3 * x), y: y, width: (2 * x), height: (2 * y))
        dropDownImageView.image = UIImage(named: "downArrow")
        genderButton.addSubview(dropDownImageView)
        
        /*maleButton.isEnabled = false
         maleButton.frame = CGRect(x: (3 * x), y: genderButton.frame.maxY + y, width: (2 * x), height: (2 * x))
         maleButton.layer.cornerRadius = maleButton.frame.height / 2
         maleButton.backgroundColor = UIColor.white
         maleButton.setImage(UIImage(named: "unCheckMark"), for: .normal)
         maleButton.tag = 1
         maleButton.addTarget(self, action: #selector(self.genderButtonAction(sender:)), for: .touchUpInside)
         view.addSubview(maleButton)
         
         let maleLabel = UILabel()
         maleLabel.frame = CGRect(x: maleButton.frame.maxX + x, y: genderButton.frame.maxY + y, width: (6 * x), height: (2 * y))
         maleLabel.text = "Male"
         maleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
         maleLabel.textAlignment = .left
         view.addSubview(maleLabel)
         
         femaleButton.isEnabled = false
         femaleButton.frame = CGRect(x: maleLabel.frame.maxX + (3 * x), y: genderButton.frame.maxY + y, width: (2 * x), height: (2 * x))
         femaleButton.layer.cornerRadius = femaleButton.frame.height / 2
         femaleButton.backgroundColor = UIColor.white
         femaleButton.setImage(UIImage(named: "unCheckMark"), for: .normal)
         femaleButton.tag = 2
         femaleButton.addTarget(self, action: #selector(self.genderButtonAction(sender:)), for: .touchUpInside)
         view.addSubview(femaleButton)
         
         let femaleLabel = UILabel()
         femaleLabel.frame = CGRect(x: femaleButton.frame.maxX + x, y: genderButton.frame.maxY + y, width: (6 * x), height: (2 * y))
         femaleLabel.text = "Female"
         femaleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
         femaleLabel.textAlignment = .left
         view.addSubview(femaleLabel)*/
        
        updateButton.isHidden = false
        updateButton.frame = CGRect(x: (3 * x), y: genderButton.frame.maxY + (3 * y), width: view.frame.width - (6 * x), height: (4 * y))
        updateButton.layer.cornerRadius = 10
        updateButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        updateButton.setTitle("Update Profile", for: .normal)
        updateButton.setTitleColor(UIColor.white, for: .normal)
        updateButton.addTarget(self, action: #selector(self.updateButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(updateButton)
    }
    
    @objc func genderButtonActions(sender : UIButton)
    {
        genderTableView.frame = CGRect(x: genderButton.frame.minX, y: genderButton.frame.maxY, width: genderButton.frame.width, height: (10 * y))
        genderTableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        genderTableView.dataSource = self
        genderTableView.delegate = self
        genderTableView.allowsSelection = true
        
        if sender.tag == 1
        {
            view.addSubview(genderTableView)
            sender.tag = 0
        }
        else
        {
            genderTableView.removeFromSuperview()
            sender.tag = 1
        }
        
    }
    
    @objc func cameraButtonAction(sender : UIButton)
    {
        let cameraAlert = UIAlertController(title: "Alert", message: "Choose image from", preferredStyle: .alert)
        cameraAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: cameraAlertAction(action:)))
        cameraAlert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: galleryAlertAction(action:)))
        cameraAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(cameraAlert, animated: true, completion: nil)
    }
    
    func cameraAlertAction(action : UIAlertAction)
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func galleryAlertAction(action : UIAlertAction)
    {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.userImage.image = pickedImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func pickUpDate(_ textField : UITextField){
        // DatePicker
        self.datePick = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePick.backgroundColor = UIColor.white
        self.datePick.datePickerMode = UIDatePicker.Mode.date
        self.datePick.maximumDate = Date()
        textField.inputView = self.datePick
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    @objc func doneClick()
    {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        dateFormatter1.dateFormat = "MM/dd/yyyy"
        dob.text = dateFormatter1.string(from: datePick.date)
        dob.resignFirstResponder()
    }
    
    @objc func cancelClick() {
        dob.resignFirstResponder()
    }
    
    @objc func backButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func genderButtonAction(sender : UIButton)
    {
        if sender.tag == 1
        {
            GenderStr = "male"
            femaleButton.setImage(UIImage(named: "unCheckMark"), for: .normal)
        }
        else
        {
            GenderStr = "female"
            maleButton.setImage(UIImage(named: "unCheckMark"), for: .normal)
        }
        
        sender.setImage(UIImage(named: "checkMark"), for: .normal)
    }
    
    @objc func calendarButtonAction()
    {
        pickUpDate(dob)
        
        //        datePick.frame = CGRect(x: 0, y: dob.frame.maxY + (5 * y), width: view.frame.width, height: (20 * y))
        //        datePick.backgroundColor = UIColor.white
        //        datePick.datePickerMode = .date
        //        datePick.locale = Locale.current
        //        datePick.maximumDate = Date()
        //        datePick.timeZone = TimeZone.current
        //        view.addSubview(datePick)
        //
        //        dob.inputView = datePick
    }
    
    @objc func updateButtonAction(sender : UIButton)
    {
        sender.isHidden = true
        
        userName.isUserInteractionEnabled = true
        mobileNumber.isUserInteractionEnabled = false
        email.isUserInteractionEnabled = true
        dob.isUserInteractionEnabled = true
        
        femaleButton.isEnabled = true
        maleButton.isEnabled = true
        
        cameraButton.isEnabled = true
        genderButton.isEnabled = true
        
        cancelButton.isHidden = false
        cancelButton.frame = CGRect(x: (2 * x), y: genderButton.frame.maxY + (3 * y), width: (15.75 * x), height: (4 * y))
        cancelButton.layer.cornerRadius = 10
        cancelButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.addTarget(self, action: #selector(self.cancelButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        saveButton.isHidden = false
        saveButton.frame = CGRect(x: cancelButton.frame.maxX + (2 * x), y: genderButton.frame.maxY + (3 * y), width: (15.75 * x), height: (4 * y))
        saveButton.layer.cornerRadius = 10
        saveButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.addTarget(self, action: #selector(self.saveButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(saveButton)
    }
    
    @objc func cancelButtonAction(sender : UIButton)
    {
        userName.isUserInteractionEnabled = false
        mobileNumber.isUserInteractionEnabled = false
        email.isUserInteractionEnabled = false
        dob.isUserInteractionEnabled = false
        
        femaleButton.isEnabled = false
        maleButton.isEnabled = false
        
        cameraButton.isEnabled = false
        genderButton.isEnabled = false
        
        //        userName.text = ""
        //        mobileNumber.text = ""
        //        email.text = ""
        //        dob.text = ""
        
        updateButton.isHidden = false
        
        sender.removeFromSuperview()
        saveButton.removeFromSuperview()
    }
    
    @objc func saveButtonAction(sender : UIButton)
    {
        var userId = String()
        
        
        if let ProfId = UserDefaults.standard.value(forKey: "userId") as? String
        {
            userId = ProfId
        }
        else
        {
            
        }
        let EmailID = email.text
        let DobStr = dob.text
        let ModifyStr = "user"
        
        let validateEMail = isValidEmail(testStr: EmailID!)
        
        print("VALIDATE EMAIL", validateEMail)
        
        if GenderStr.isEmpty != true || GenderStr != ""
        {
            if (EmailID?.contains("@"))! && (EmailID?.contains("."))!
            {
                if validateEMail == true
                {
                    if userImage.image != nil
                    {
                        userName.isUserInteractionEnabled = false
                        mobileNumber.isUserInteractionEnabled = false
                        email.isUserInteractionEnabled = false
                        dob.isUserInteractionEnabled = false
                        
                        femaleButton.isEnabled = false
                        maleButton.isEnabled = false
                        
                        cameraButton.isEnabled = false
                        genderButton.isEnabled = false
                        
                        updateButton.isHidden = false
                        
                        sender.removeFromSuperview()
                        cancelButton.removeFromSuperview()
                        
                        serviceCall.API_ProfileImageUpload(buyerImages: userImage.image!, delegate: self)
                    }
                    else
                    {
                        let alert = UIAlertController(title: "Alert", message: "Please choose image", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else
                {
                    let alert = UIAlertController(title: "Alert", message: "Invalid email id", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else
            {
                let alert = UIAlertController(title: "Alert", message: "Invalid email id", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "Please choose the gender", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath as IndexPath)
        cell.textLabel?.text = genders[indexPath.row]
        print("WELCOME")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (5 * y)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        genderLabel.text = genders[indexPath.row]
        print("WELCOME TO DID SELECT")
        GenderStr = genderLabel.text!
        genderTableView.removeFromSuperview()
        genderHeadingLabel.isHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userName
        {
            userName.resignFirstResponder()
            email.becomeFirstResponder()
        }
        else if textField == email
        {
            email.resignFirstResponder()
            dob.becomeFirstResponder()
        }
        else
        {
            dob.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        var returnParameter = Bool()
        
        if textField == userName
        {
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            returnParameter = (string == filtered)
        }
        else
        {
            returnParameter = true
        }
        print("return parameter", returnParameter)
        return returnParameter
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

