//
//  IntroProfileViewController.swift
//  Mzyoon
//
//  Created by QOL on 26/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class IntroProfileViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ServerAPIDelegate
{
    
    //POSITION
    var x:CGFloat!
    var y:CGFloat!
    
    var userImage = UIImageView()
    
    var imagePicker = UIImagePickerController()
    
    var userNameTextField = UITextField()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    let serviceCall = ServerAPI()
    
    let activeView = UIView()
    let activityIndicator = UIActivityIndicatorView()
    
    var applicationDelegate = AppDelegate()

    
    override func viewDidLoad()
    {
        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
        
        introScreenContents()
        
        let disableKeyboard = UITapGestureRecognizer(target: self, action: #selector(self.closeKeyboard(gesture:)))
        self.view.addGestureRecognizer(disableKeyboard)
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func closeKeyboard(gesture : UITapGestureRecognizer)
    {
        self.view.endEditing(true)
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("Intro Profile", errorMessage)
        applicationDelegate.exitContents()
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        //   ErrorStr = "Default Error"
        PageNumStr = "IntroProfileViewcontroller"
        //  MethodName = "do"
        
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
    
    func API_CALLBACK_IntroProfile(introProf: NSDictionary)
    {
        print("introProf", introProf)
        let ResponseMsg = introProf.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = introProf.object(forKey: "Result") as! String
            
            if Result == "1"
            {
                activeStop()
                let homeScreen = HomeViewController()
                self.navigationController?.pushViewController(homeScreen, animated: true)
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
                
                let imageName = splitted.last
                
                if let profId = UserDefaults.standard.value(forKey: "userId") as? String
                {
                    serviceCall.API_IntroProfile(Id: profId, Name: userNameTextField.text!, profilePic: String(imageName!), delegate: self)
                }
                else if let profId = UserDefaults.standard.value(forKey: "userId") as? Int
                {
                    serviceCall.API_IntroProfile(Id: "\(profId)", Name: userNameTextField.text!, profilePic: String(imageName!), delegate: self)
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
    
    func introScreenContents()
    {
        let backgroundImage = UIImageView()
        backgroundImage.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        backgroundImage.image = UIImage(named: "background")
        view.addSubview(backgroundImage)
        
        let introProfileNavigationBar = UIView()
        introProfileNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        introProfileNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(introProfileNavigationBar)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: introProfileNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "PROFILE"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        introProfileNavigationBar.addSubview(navigationTitle)
        
        userImage.frame = CGRect(x: ((view.frame.width - (20 * x)) / 2), y: introProfileNavigationBar.frame.maxY + (5 * y), width: (20 * x), height: (20 * x))
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.backgroundColor = UIColor.white
        userImage.image = UIImage(named: "emptyUser")
        userImage.layer.masksToBounds = true
        userImage.contentMode = .scaleAspectFill
        view.addSubview(userImage)
        
        let cameraButton = UIButton()
        cameraButton.frame = CGRect(x: userImage.frame.maxX - (5 * x), y: userImage.frame.maxY - (5 * y), width: (5 * x), height: (5 * x))
        cameraButton.backgroundColor = UIColor.white
        cameraButton.layer.cornerRadius = cameraButton.frame.height / 2
        cameraButton.setImage(UIImage(named: "camera"), for: .normal)
        cameraButton.addTarget(self, action: #selector(self.cameraButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(cameraButton)
        
        let userImageIcon = UIImageView()
        userImageIcon.frame = CGRect(x: (2 * x), y: userImage.frame.maxY + (5 * y), width: (3 * x), height: (3 * y))
        userImageIcon.layer.cornerRadius = userImageIcon.frame.height /  2
        userImageIcon.layer.masksToBounds = true
        userImageIcon.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        userImageIcon.image = UIImage(named: "profile")
        view.addSubview(userImageIcon)
        
        userNameTextField.frame = CGRect(x: userImageIcon.frame.maxX + x, y: userImage.frame.maxY + ( 5 * y), width: view.frame.width - (6 * x), height: (4 * y))
        userNameTextField.placeholder = "Enter your name"
        userNameTextField.textColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        userNameTextField.textAlignment = .left
        userNameTextField.font = UIFont(name: "Avenir-Heavy", size: 18)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: userNameTextField.frame.height))
        userNameTextField.leftView = paddingView
        userNameTextField.leftViewMode = UITextField.ViewMode.always
        userNameTextField.adjustsFontSizeToFitWidth = true
        userNameTextField.keyboardType = .default
        userNameTextField.clearsOnBeginEditing = false
        userNameTextField.returnKeyType = .done
        userNameTextField.delegate = self
        view.addSubview(userNameTextField)
        
        let underLine = UILabel()
        underLine.frame = CGRect(x: (2 * x), y: userNameTextField.frame.maxY, width: view.frame.width - (4 * x), height: 1)
        underLine.backgroundColor = UIColor.lightGray
        view.addSubview(underLine)
        
        let introProfileNextButton = UIButton()
        introProfileNextButton.frame = CGRect(x: view.frame.width - (5 * x), y: underLine.frame.maxY + (5 * y), width: (4 * x), height: (4 * y))
        introProfileNextButton.layer.cornerRadius = introProfileNextButton.frame.height / 2
        introProfileNextButton.setImage(UIImage(named: "rightArrow"), for: .normal)
        introProfileNextButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        //        introProfileNextButton.setTitle("NEXT", for: .normal)
        //        introProfileNextButton.setTitleColor(UIColor.white, for: .normal)
        introProfileNextButton.addTarget(self, action: #selector(self.introProfileNextButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(introProfileNextButton)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                navigationTitle.text = "PROFILE"
                userImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                userNameTextField.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                userNameTextField.placeholder = "Enter your name"
                userNameTextField.textAlignment = .left
            }
            else if language == "ar"
            {
                self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                navigationTitle.text = "ملفي الشخصي"
                userImage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                userNameTextField.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                userNameTextField.placeholder = "أدخل أسمك"
                userNameTextField.textAlignment = .right
            }
        }
        else
        {
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            navigationTitle.text = "PROFILE"
            userImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            userNameTextField.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            userNameTextField.placeholder = "Enter your name"
            userNameTextField.textAlignment = .left
        }
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
    
    @objc func cameraButtonAction(sender : UIButton)
    {
        view.endEditing(true)
        
        var galleryAlert = UIAlertController()
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                galleryAlert = UIAlertController(title: "Alert", message: "Choose image from", preferredStyle: .alert)
                galleryAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: cameraAlertAction(action:)))
                galleryAlert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: galleryAlertAction(action:)))
                galleryAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            }
            else if language == "ar"
            {
                galleryAlert = UIAlertController(title: "تنبيه", message: "اختيار صورة من", preferredStyle: .alert)
                galleryAlert.addAction(UIAlertAction(title: "الة تصوير", style: .default, handler: cameraAlertAction(action:)))
                galleryAlert.addAction(UIAlertAction(title: "صالة عرض", style: .default, handler: galleryAlertAction(action:)))
                galleryAlert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: nil))
            }
        }
        else
        {
            galleryAlert = UIAlertController(title: "Alert", message: "Choose image from", preferredStyle: .alert)
            galleryAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: cameraAlertAction(action:)))
            galleryAlert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: galleryAlertAction(action:)))
            galleryAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        }
        
        self.present(galleryAlert, animated: true, completion: nil)
    }
    
    func cameraAlertAction(action : UIAlertAction)
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func galleryAlertAction(action : UIAlertAction)
    {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
        {
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            self.userImage.image = pickedImage
            FileHandler().saveImageDocumentDirectory(image: userImage.image!)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func introProfileNextButtonAction(sender : UIButton)
    {
        if userNameTextField.text?.isEmpty == true
        {
            var nameAlert = UIAlertController()
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    nameAlert = UIAlertController(title: "Alert", message: "Please enter your name to proceed", preferredStyle: .alert)
                    nameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                }
                else if language == "ar"
                {
                    nameAlert = UIAlertController(title: "تنبيه", message: "الرجاء إدخال اسمك للمتابعة", preferredStyle: .alert)
                    nameAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: nil))
                }
            }
            else
            {
                nameAlert = UIAlertController(title: "Alert", message: "Please enter your name to proceed", preferredStyle: .alert)
                nameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            }
            
            self.present(nameAlert, animated: true, completion: nil)
        }
        else
        {
            active()
            
            var imageAlert = UIAlertController()
            
            if userImage.image != UIImage(named: "emptyUser")
            {
                if userImage.image != nil
                {
                    UserDefaults.standard.set(userNameTextField.text!, forKey: "userName")
                    
                    serviceCall.API_ProfileImageUpload(buyerImages: userImage.image!, delegate: self)
                    
                    /*if let profId = UserDefaults.standard.value(forKey: "userId") as? String
                    {
                        serviceCall.API_ProfileImageUpload(buyerImages: userImage.image!, delegate: self)
                    }
                    else if let profId = UserDefaults.standard.value(forKey: "userId") as? Int
                    {
                        serviceCall.API_ProfileImageUpload(buyerImages: userImage.image!, delegate: self)
                    }*/
                    
                    //                activeStop()
                    //                let homeScreen = HomeViewController()
                    //                self.navigationController?.pushViewController(homeScreen, animated: true)
                }
                else
                {
                    if let language = UserDefaults.standard.value(forKey: "language") as? String
                    {
                        if language == "en"
                        {
                            imageAlert = UIAlertController(title: "Alert", message: "Please choose profile image", preferredStyle: .alert)
                            imageAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: imageAlertOkAction(action:)))
                        }
                        else if language == "ar"
                        {
                            imageAlert = UIAlertController(title: "تنبيه", message: "يرجى اختيار صورة الملف الشخصي", preferredStyle: .alert)
                            imageAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: imageAlertOkAction(action:)))
                        }
                    }
                    else
                    {
                        imageAlert = UIAlertController(title: "Alert", message: "Please choose profile image", preferredStyle: .alert)
                        imageAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: imageAlertOkAction(action:)))
                    }
                    self.present(imageAlert, animated: true, completion: nil)
                }
            }
            else
            {
                if let language = UserDefaults.standard.value(forKey: "language") as? String
                {
                    if language == "en"
                    {
                        imageAlert = UIAlertController(title: "Alert", message: "Please choose profile image", preferredStyle: .alert)
                        imageAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: imageAlertOkAction(action:)))
                    }
                    else if language == "ar"
                    {
                        imageAlert = UIAlertController(title: "تنبيه", message: "يرجى اختيار صورة الملف الشخصي", preferredStyle: .alert)
                        imageAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: imageAlertOkAction(action:)))
                    }
                }
                else
                {
                    imageAlert = UIAlertController(title: "Alert", message: "Please choose profile image", preferredStyle: .alert)
                    imageAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: imageAlertOkAction(action:)))
                }
                self.present(imageAlert, animated: true, completion: nil)
            }
        }
    }
    
    func imageAlertOkAction(action : UIAlertAction)
    {
        self.activeStop()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
        var returnParameter = Bool()
        
        if textField == userNameTextField
        {
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            returnParameter = (string == filtered)
        }
        else
        {
            returnParameter = true
        }
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
