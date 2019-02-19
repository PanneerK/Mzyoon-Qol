//
//  GenderViewController.swift
//  Mzyoon
//
//  Created by QOL on 16/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class GenderViewController: CommonViewController, ServerAPIDelegate
{
    
    //POSITION
    var xPos:CGFloat!
    var yPos:CGFloat!
    
    let serviceCall = ServerAPI()
    
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()

    let selfScreenContents = UIView()

    //GENDER API PARAMETERS
    var genderArray = NSArray()
    var genderIdArray = NSArray()
    var genderInArabicArray = NSArray()
    var genderImageArray = NSArray()
    var convertedGenderImageArray = [UIImage]()
    
   // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    override func viewDidLoad()
    {
        xPos = 10 / 375 * 100
        xPos = xPos * view.frame.width / 100
        
        yPos = 10 / 667 * 100
        yPos = yPos * view.frame.height / 100
        
        navigationBar.isHidden = true
        
//        self.tab1Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        selectedButton(tag: 0)
        
//        serviceCall.API_Gender(delegate: self)

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        serviceCall.API_Gender(delegate: self)
    }
    
    func showActivityIndicator()
    {
        let activeView1 = UIView()
        activeView1.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        activeView1.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        view.addSubview(activeView1)
        
        self.view.bringSubviewToFront(activeView1)
        
        let activityView1 = UIActivityIndicatorView()
        activityView1.frame = CGRect(x: ((activeView1.frame.width - 50) / 2), y: ((activeView1.frame.height - 50) / 2), width: 50, height: 50)
        activityView1.style = .whiteLarge
        activityView1.color = UIColor.white
        activityView1.startAnimating()
        activeView1.addSubview(activityView1)
    }
    
    func hideActivityIndicator()
    {
        activeView.removeFromSuperview()
        activityView.stopAnimating()
    }
    
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "Customer"
        // ErrorStr = "Default Error"
        PageNumStr = "GenderViewController"
        MethodName = "GetGenders"
        
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("ERROR IN GENDER PAGE", errorMessage)
    }
 
    
    func API_CALLBACK_Gender(gender: NSDictionary)
    {
        let ResponseMsg = gender.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            print("RESPONSE GENDER PAGE")

            let result = gender.object(forKey: "Result") as! NSArray
            
            genderArray = result.value(forKey: "gender") as! NSArray
            
            genderImageArray = result.value(forKey: "ImageURL") as! NSArray
            
            genderIdArray = result.value(forKey: "Id") as! NSArray
            
            genderInArabicArray = result.value(forKey: "GenderInArabic") as! NSArray
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    self.newOrderContents(getInputArray: genderArray)
                }
                else if language == "ar"
                {
                    self.newOrderContents(getInputArray: genderInArabicArray)
                }
            }
            else
            {
                self.newOrderContents(getInputArray: genderArray)
            }
        }
        else if ResponseMsg == "Failure"
        {
            let Result = gender.object(forKey: "Result") as! String
            
            ErrorStr = Result
            DeviceError()
        }
        
        
        /*for i in 0..<genderImageArray.count
        {
            if let imageName = genderImageArray[i] as? String
            {
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/\(imageName)"
                let apiurl = URL(string: api)
                
                if let data = try? Data(contentsOf: apiurl!) {
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
            else if genderImageArray[i] is NSNull
            {
                let emptyImage = UIImage(named: "empty")
                self.convertedGenderImageArray.append(emptyImage!)
            }
        }*/
        
       
    }
    
    func API_CALLBACK_InsertErrorDevice(deviceError: NSDictionary)
    {
        let ResponseMsg = deviceError.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = deviceError.object(forKey: "Result") as! String
        }
    }
    
    func selfScreenNavigationContents()
    {
        selfScreenNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        selfScreenNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(selfScreenNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 1
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        selfScreenNavigationBar.addSubview(backButton)
        
        selfScreenNavigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: selfScreenNavigationBar.frame.width, height: (3 * y))
        selfScreenNavigationTitle.text = "GENDER"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
    }
    
    func newOrderContents(getInputArray : NSArray)
    {
        selfScreenNavigationContents()
        
        selfScreenContents.frame = CGRect(x: 0, y: selfScreenNavigationBar.frame.maxY, width: view.frame.width, height: view.frame.height - ((5 * y) + selfScreenNavigationBar.frame.maxY))
        selfScreenContents.backgroundColor = UIColor.clear
        view.addSubview(selfScreenContents)
        
        self.view.bringSubviewToFront(slideMenuButton)
        
        var x1:CGFloat = (3 * x)
        var y1:CGFloat =  (10.65 * y)
        
        for i in 0..<getInputArray.count
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
            genderButton.layer.borderWidth = 1
            genderButton.backgroundColor = UIColor.lightGray
//            genderButton.setImage(UIImage(named: "genderBackground"), for: .normal)
            genderButton.tag = genderIdArray[i] as! Int
            genderButton.addTarget(self, action: #selector(self.genderButtonAction(sender:)), for: .touchUpInside)
            selfScreenContents.addSubview(genderButton)
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    genderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
                else if language == "ar"
                {
                    genderButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                }
            }
            else
            {
                genderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            
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
            
//            buttonImage.image = convertedGenderImageArray[i]
            if let imageName = genderImageArray[i] as? String
            {
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/\(imageName)"
                let apiurl = URL(string: api)
                if apiurl != nil
                {
                    buttonImage.dowloadFromServer(url: apiurl!)
                }
                
                if i == genderImageArray.count - 1
                {
                    self.stopActivity()
                }
                else
                {
                    
                }
            }
            genderButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 0, y: genderButton.frame.height - (3 * y), width: genderButton.frame.width, height: (3 * y))
            buttonTitle.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.text = getInputArray[i] as? String
            buttonTitle.textColor = UIColor.white
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 10)
            genderButton.addSubview(buttonTitle)
        }
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                changeViewToEnglishInSelf()
            }
            else if language == "ar"
            {
                changeViewToArabicISelf()
            }
        }
        else
        {
            changeViewToEnglishInSelf()
        }
    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.text = "GENDER"
        
        selfScreenContents.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    func changeViewToArabicISelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.text = "جنس"
        
        selfScreenContents.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func genderButtonAction(sender : UIButton)
    {
        if sender.tag == 1
        {
            UserDefaults.standard.set("Male", forKey: "gender")
            let dressTypeScreen = DressTypeViewController()
            dressTypeScreen.tag = sender.tag
            self.navigationController?.pushViewController(dressTypeScreen, animated: true)
        }
        else if sender.tag == 2
        {
            UserDefaults.standard.set("Female", forKey: "gender")
            let dressTypeScreen = DressTypeViewController()
            dressTypeScreen.tag = sender.tag
            self.navigationController?.pushViewController(dressTypeScreen, animated: true)
        }
        else
        {
            let emptyAlert = UIAlertController(title: "Alert", message: "As of now we are providing services for men alone", preferredStyle: .alert)
            emptyAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(emptyAlert, animated: true, completion: nil)
        }
//        else if sender.tag == 2
//        {
//            UserDefaults.standard.set("women", forKey: "Gender")
//        }
//        else if sender.tag == 3
//        {
//            UserDefaults.standard.set("boy", forKey: "Gender")
//        }
//        else if sender.tag == 4
//        {
//            UserDefaults.standard.set("girl", forKey: "Gender")
//        }
//
        
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
