//
//  ProfileViewController.swift
//  Mzyoon
//
//  Created by QOL on 29/10/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UIGestureRecognizerDelegate, UITextFieldDelegate, ServerAPIDelegate
{
    
    var x = CGFloat()
    var y = CGFloat()
    
    
    let userName = UITextField()
    let mobileNumber = UITextField()
    let email = UITextField()
    let dob = UITextField()
    let calendarButton = UIButton()
    let maleButton = UIButton()
    let femaleButton = UIButton()
    let updateButton = UIButton()
    
    let cancelButton = UIButton()
    let saveButton = UIButton()
    var GenderStr : String!
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!

    let serviceCall = ServerAPI()
    
    override func viewDidLoad()
    {
        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
        
        view.backgroundColor = UIColor.red

        let closeKeyboard = UITapGestureRecognizer(target: self, action: #selector(self.closeKeyboard(gesture:)))
        closeKeyboard.delegate = self
        view.addGestureRecognizer(closeKeyboard)
        
        screenContents()
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
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
        
        let userImage = UIImageView()
        userImage.frame = CGRect(x: ((view.frame.width - 150) / 2), y: navigationBar.frame.maxY + y, width: 150, height: 150)
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.backgroundColor = UIColor.red
        userImage.image = UIImage(named: "imgpsh_fullsizebai")
        userImage.layer.masksToBounds = true
        backgroundImage.addSubview(userImage)
        
        let nameIcon = UIImageView()
        nameIcon.frame = CGRect(x: (3 * x), y: userImage.frame.maxY + (4 * y), width: (2.5 * x), height: (2 * y))
        nameIcon.image = UIImage(named: "account")
        view.addSubview(nameIcon)
        
        
        
        userName.isUserInteractionEnabled = false
        userName.frame = CGRect(x: nameIcon.frame.maxX + x, y: userImage.frame.maxY + (4 * y), width: view.frame.width - (7 * x), height: (2 * y))
        if let getUserName = UserDefaults.standard.value(forKey: "Name") as? String
        {
            userName.text = getUserName
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
        email.text = "panneer@qolsofts.com"
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
        dob.text = "26/Sep/1990"
        dob.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        dob.delegate = self
        view.addSubview(dob)
        
        calendarButton.frame = CGRect(x: view.frame.width - (5 * x), y: emailIcon.frame.maxY + (4 * y), width: (2 * x), height: (2 * y))
        calendarButton.setImage(UIImage(named: "calender"), for: .normal)
        view.addSubview(calendarButton)
        
        let dobUnderline = UILabel()
        dobUnderline.frame = CGRect(x: (3 * x), y: dobIcon.frame.maxY + 2, width: view.frame.width - (6 * x), height: 1)
        dobUnderline.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        view.addSubview(dobUnderline)
        
        let genderLabel = UILabel()
        genderLabel.frame = CGRect(x: (3 * x), y: dobUnderline.frame.maxY + (2 * y), width: view.frame.width - (6 * x), height: (2 * y))
        genderLabel.text = "Gender"
        genderLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        genderLabel.textAlignment = .left
        view.addSubview(genderLabel)
        
        maleButton.frame = CGRect(x: (3 * x), y: genderLabel.frame.maxY + y, width: (2 * x), height: (2 * x))
        maleButton.layer.cornerRadius = maleButton.frame.height / 2
        maleButton.backgroundColor = UIColor.green
        maleButton.tag = 1
        maleButton.addTarget(self, action: #selector(self.genderButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(maleButton)
        
        let maleLabel = UILabel()
        maleLabel.frame = CGRect(x: maleButton.frame.maxX + x, y: genderLabel.frame.maxY + y, width: (6 * x), height: (2 * y))
        maleLabel.text = "Male"
        maleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        maleLabel.textAlignment = .left
        view.addSubview(maleLabel)
        
        femaleButton.frame = CGRect(x: maleLabel.frame.maxX + (3 * x), y: genderLabel.frame.maxY + y, width: (2 * x), height: (2 * x))
        femaleButton.layer.cornerRadius = femaleButton.frame.height / 2
        femaleButton.backgroundColor = UIColor.green
        femaleButton.tag = 2
        femaleButton.addTarget(self, action: #selector(self.genderButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(femaleButton)
        
        let femaleLabel = UILabel()
        femaleLabel.frame = CGRect(x: femaleButton.frame.maxX + x, y: genderLabel.frame.maxY + y, width: (6 * x), height: (2 * y))
        femaleLabel.text = "Female"
        femaleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        femaleLabel.textAlignment = .left
        view.addSubview(femaleLabel)
        
        updateButton.isHidden = false
        updateButton.frame = CGRect(x: (3 * x), y: maleButton.frame.maxY + (3 * y), width: view.frame.width - (6 * x), height: (4 * y))
        updateButton.layer.cornerRadius = 10
        updateButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        updateButton.setTitle("Update Profile", for: .normal)
        updateButton.setTitleColor(UIColor.white, for: .normal)
        updateButton.addTarget(self, action: #selector(self.updateButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(updateButton)
    }
    
    @objc func backButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func genderButtonAction(sender : UIButton)
    {
        if sender.tag == 1
        {
            sender.backgroundColor = UIColor.blue
        }
        else
        {
            sender.backgroundColor = UIColor.blue
        }
    }
    
    @objc func updateButtonAction(sender : UIButton)
    {
        sender.isHidden = true
        
        userName.isUserInteractionEnabled = true
        mobileNumber.isUserInteractionEnabled = true
        email.isUserInteractionEnabled = true
        dob.isUserInteractionEnabled = true
        
        userName.becomeFirstResponder()
        
        cancelButton.isHidden = false
        cancelButton.frame = CGRect(x: (2 * x), y: maleButton.frame.maxY + (3 * y), width: (15.75 * x), height: (4 * y))
        cancelButton.layer.cornerRadius = 10
        cancelButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.addTarget(self, action: #selector(self.cancelButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        saveButton.isHidden = false
        saveButton.frame = CGRect(x: cancelButton.frame.maxX + (2 * x), y: maleButton.frame.maxY + (3 * y), width: (15.75 * x), height: (4 * y))
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
        
        updateButton.isHidden = false
        
        sender.removeFromSuperview()
        saveButton.removeFromSuperview()
    }
    
    @objc func saveButtonAction(sender : UIButton)
    {
        userName.isUserInteractionEnabled = false
        mobileNumber.isUserInteractionEnabled = false
        email.isUserInteractionEnabled = false
        dob.isUserInteractionEnabled = false
        
        updateButton.isHidden = false
        
        sender.removeFromSuperview()
        cancelButton.removeFromSuperview()
        
        let ProfId = 1
        let EmailID = email.text
        let DobStr = dob.text
        let ModifyStr = "user"
        
        serviceCall.API_ProfileUpdate(Id: ProfId, Email: EmailID!, Dob: DobStr!, Gender: GenderStr!, ModifiedBy: ModifyStr, delegate: self)
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
