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
    
    let newOrderView = UIView()
    
    let serviceCall = ServerAPI()

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
        
        self.tab1Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        
        serviceCall.API_Gender(delegate: self)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "Customer"
        // ErrorStr = "Default Error"
        PageNumStr = "GenderViewController"
        MethodName = "GetGenders"
        
        print("UUID", UIDevice.current.identifierForVendor?.uuidString as Any)
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("ERROR IN GENDER PAGE", errorMessage)
      //  ErrorStr = errorMessage
        
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
            
             self.newOrderContents()
        }
        else if ResponseMsg == "Failure"
        {
            let Result = gender.object(forKey: "Result") as! String
            print("Result", Result)
            
            ErrorStr = Result
            DeviceError()
        }
        
        
        /*for i in 0..<genderImageArray.count
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
            print("Result", Result)
        }
    }
    
    func newOrderContents()
    {
        self.stopActivity()
        
        newOrderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        newOrderView.backgroundColor = UIColor.white
        //        view.addSubview(newOrderView)
        
        let newOrderNavigationBar = UIView()
        newOrderNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        newOrderNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(newOrderNavigationBar)
        
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
            genderButton.layer.borderWidth = 1
            genderButton.backgroundColor = UIColor.lightGray
//            genderButton.setImage(UIImage(named: "genderBackground"), for: .normal)
            genderButton.tag = i + 1
            genderButton.addTarget(self, action: #selector(self.genderButtonAction(sender:)), for: .touchUpInside)
            view.addSubview(genderButton)
            
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
                let api = "http://appsapi.mzyoon.com/images/\(imageName)"
                let apiurl = URL(string: api)
                buttonImage.dowloadFromServer(url: apiurl!)
            }
            genderButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 2, y: genderButton.frame.height - (3 * y), width: genderButton.frame.width - 4, height: (3 * y))
            buttonTitle.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.text = genderArray[i] as? String
            buttonTitle.textColor = UIColor.white
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 10)
            genderButton.addSubview(buttonTitle)
        }
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func genderButtonAction(sender : UIButton)
    {
        if sender.tag == 1
        {
            UserDefaults.standard.set("men", forKey: "Gender")
        }
        else if sender.tag == 2
        {
            UserDefaults.standard.set("women", forKey: "Gender")
        }
        else if sender.tag == 3
        {
            UserDefaults.standard.set("boy", forKey: "Gender")
        }
        else if sender.tag == 4
        {
            UserDefaults.standard.set("girl", forKey: "Gender")
        }
        
        let dressTypeScreen = DressTypeViewController()
        dressTypeScreen.tag = sender.tag
        self.navigationController?.pushViewController(dressTypeScreen, animated: true)
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
