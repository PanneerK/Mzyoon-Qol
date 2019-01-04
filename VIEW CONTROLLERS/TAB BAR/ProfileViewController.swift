//
//  ProfileViewController.swift
//  Mzyoon
//
//  Created by QOL on 29/10/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UIGestureRecognizerDelegate, UITextFieldDelegate, ServerAPIDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    var x = CGFloat()
    var y = CGFloat()
    
    let userImage = UIImageView()
    var imagePicker = UIImagePickerController()

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
    
    var datePick = UIDatePicker()
    
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
        
        userImage.frame = CGRect(x: ((view.frame.width - 150) / 2), y: navigationBar.frame.maxY + y, width: 150, height: 150)
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.backgroundColor = UIColor.red
        userImage.layer.masksToBounds = true
        userImage.image = FileHandler().getImageFromDocumentDirectory()
        backgroundImage.addSubview(userImage)
        
        let cameraButton = UIButton()
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
        if let getUserName = UserDefaults.standard.value(forKey: "Name") as? String
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
        email.placeholder = "Please enter your email"
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
        dob.placeholder = "yyyy/mm/dd"
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
        
        let genderLabel = UILabel()
        genderLabel.frame = CGRect(x: (3 * x), y: dobUnderline.frame.maxY + (2 * y), width: view.frame.width - (6 * x), height: (2 * y))
        genderLabel.text = "Gender"
        genderLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        genderLabel.textAlignment = .left
        view.addSubview(genderLabel)
        
        maleButton.isEnabled = false
        maleButton.frame = CGRect(x: (3 * x), y: genderLabel.frame.maxY + y, width: (2 * x), height: (2 * x))
        maleButton.layer.cornerRadius = maleButton.frame.height / 2
        maleButton.backgroundColor = UIColor.white
        maleButton.setImage(UIImage(named: "unCheckMark"), for: .normal)
        maleButton.tag = 1
        maleButton.addTarget(self, action: #selector(self.genderButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(maleButton)
        
        let maleLabel = UILabel()
        maleLabel.frame = CGRect(x: maleButton.frame.maxX + x, y: genderLabel.frame.maxY + y, width: (6 * x), height: (2 * y))
        maleLabel.text = "Male"
        maleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        maleLabel.textAlignment = .left
        view.addSubview(maleLabel)
        
        femaleButton.isEnabled = false
        femaleButton.frame = CGRect(x: maleLabel.frame.maxX + (3 * x), y: genderLabel.frame.maxY + y, width: (2 * x), height: (2 * x))
        femaleButton.layer.cornerRadius = femaleButton.frame.height / 2
        femaleButton.backgroundColor = UIColor.white
        femaleButton.setImage(UIImage(named: "unCheckMark"), for: .normal)
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
    
    @objc func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        dateFormatter1.dateFormat = "yyyy/MM/dd"
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
        mobileNumber.isUserInteractionEnabled = true
        email.isUserInteractionEnabled = true
        dob.isUserInteractionEnabled = true
        
        femaleButton.isEnabled = true
        maleButton.isEnabled = true
        
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
        
        femaleButton.isEnabled = false
        maleButton.isEnabled = false
        
        userName.text = ""
        mobileNumber.text = ""
        email.text = ""
        dob.text = ""
        
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
        
        femaleButton.isEnabled = false
        maleButton.isEnabled = false
        
        updateButton.isHidden = false
        
        sender.removeFromSuperview()
        cancelButton.removeFromSuperview()
        
        let ProfId = UserDefaults.standard.value(forKey: "userId") as! String
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
