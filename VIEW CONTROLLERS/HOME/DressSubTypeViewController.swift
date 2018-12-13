//
//  DressSubTypeViewController.swift
//  Mzyoon
//
//  Created by QOL on 03/12/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class DressSubTypeViewController: CommonViewController, UITextFieldDelegate, ServerAPIDelegate
{
    var screenTag = Int()
    var headingTitle = String()
    let serviceCall = ServerAPI()
    
    //DRESS SUB TYPE PARAMETERS
    
    var dressIdArray = NSArray()
    var dressSubTypeArray = NSArray()
    var dressSubTypeIdArray = NSArray()
    var dressSubTypeImages = NSArray()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    override func viewDidLoad()
    {
        navigationBar.isHidden = true
        
        self.serviceCall.API_DressSubType(DressSubTypeId: screenTag, delegate: self)
        
        self.tab1Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        //ErrorStr = "Default Error"
        PageNumStr = "DressSuBtypeViewController"
        MethodName = "DisplayDressSubType"
        
        print("UUID", UIDevice.current.identifierForVendor?.uuidString as Any)
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("DRESS SUB-TYPE", errorMessage)
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
    
    func API_CALLBACK_DressSubType(dressSubType: NSDictionary)
    {
        let ResponseMsg = dressSubType.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = dressSubType.object(forKey: "Result") as! NSArray
            print("Result", Result)
            
            dressIdArray = Result.value(forKey: "Id") as! NSArray
            print("dressIdArray", dressIdArray)
            
            dressSubTypeIdArray = Result.value(forKey: "DressId") as! NSArray
            print("Result", Result)
            
            dressSubTypeArray = Result.value(forKey: "NameInEnglish") as! NSArray
            print("dressSubTypeArray", dressSubTypeArray)
            
            dressSubTypeImages = Result.value(forKey: "Image") as! NSArray
            print("dressSubTypeImages", dressSubTypeImages)
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = dressSubType.object(forKey: "Result") as! String
            print("Result", Result)
            
            ErrorStr = Result
            DeviceError()
        }
        
         self.subTypeContents()
    }
    
    func subTypeContents()
    {
        self.stopActivity()
        
        let orderSubTypeNavigationBar = UIView()
        orderSubTypeNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        orderSubTypeNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(orderSubTypeNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 3
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        orderSubTypeNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: orderSubTypeNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = headingTitle
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        orderSubTypeNavigationBar.addSubview(navigationTitle)
        
        let searchTextField = UITextField()
        searchTextField.frame = CGRect(x: 0, y: orderSubTypeNavigationBar.frame.maxY, width: view.frame.width - 50, height: 40)
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
        view.addSubview(searchTextField)
        
        let searchButton = UIButton()
        searchButton.frame = CGRect(x: view.frame.width - 51, y: 0, width: 50, height: 40)
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.orange.cgColor
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        searchTextField.addSubview(searchButton)
        
        let sortButton = UIButton()
        sortButton.frame = CGRect(x: view.frame.width - (view.frame.width / 2.75), y: searchTextField.frame.maxY + y, width: (view.frame.width / 3), height: (4 * y))
        sortButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        sortButton.setTitle("SORT", for: .normal)
        sortButton.setTitleColor(UIColor.white, for: .normal)
        sortButton.tag = 2
        //        sortButton.addTarget(self, action: #selector(self.featuresButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(sortButton)
        
        let dressSubTypeScrollView = UIScrollView()
        dressSubTypeScrollView.frame = CGRect(x: (3 * x), y: sortButton.frame.maxY + y, width: view.frame.width - (6 * x), height: (45 * y))
        //        dressSubTypeScrollView.backgroundColor = UIColor.black
        view.addSubview(dressSubTypeScrollView)
        
        var y1:CGFloat = 0
        var x1:CGFloat = 0
        
        for i in 0..<dressSubTypeArray.count
        {
            let dressTypeButton = UIButton()
            if i % 2 == 0
            {
                dressTypeButton.frame = CGRect(x: 0, y: y1, width: (15.25 * x), height: (16 * y))
            }
            else
            {
                dressTypeButton.frame = CGRect(x: x1, y: y1, width: (15.25 * x), height: (16 * y))
                y1 = dressTypeButton.frame.maxY + y
            }
            dressTypeButton.layer.borderWidth =  1
            dressTypeButton.backgroundColor = UIColor.lightGray
            dressTypeButton.tag = i + 1
            dressTypeButton.addTarget(self, action: #selector(self.dressTypeButtonAction(sender:)), for: .touchUpInside)
            dressSubTypeScrollView.addSubview(dressTypeButton)
            
            x1 = dressTypeButton.frame.maxX + x
            
            let dressTypeImageView = UIImageView()
            dressTypeImageView.frame = CGRect(x: 0, y: 0, width: dressTypeButton.frame.width, height: (13 * y))
            //            dressTypeImageView.image = convertedDressImageArray[i]
            if let imageName = dressSubTypeImages[i] as? String
            {
                let api = "http://appsapi.mzyoon.com/images/DressSubType/\(imageName)"
                print("SUB TYPE IMAGES", api)
                let apiurl = URL(string: api)
                dressTypeImageView.dowloadFromServer(url: apiurl!)
            }
            dressTypeButton.addSubview(dressTypeImageView)
            
            let dressTypeNameLabel = UILabel()
            dressTypeNameLabel.frame = CGRect(x: 0, y: dressTypeImageView.frame.maxY, width: dressTypeButton.frame.width, height: (3 * y))
            dressTypeNameLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            dressTypeNameLabel.text = dressSubTypeArray[i] as? String
            dressTypeNameLabel.textColor = UIColor.white
            dressTypeNameLabel.textAlignment = .center
            dressTypeButton.addSubview(dressTypeNameLabel)
        }
        
        dressSubTypeScrollView.contentSize.height = y1 + (20 * y)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dressTypeButtonAction(sender : UIButton)
    {
        UserDefaults.standard.set(dressSubTypeArray[sender.tag], forKey: "DressSubType")
        let orderTypeScreen = OrderTypeViewController()
        self.navigationController?.pushViewController(orderTypeScreen, animated: true)
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
