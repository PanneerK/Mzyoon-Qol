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
    
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()
    
    let dressSubTypeScrollView = UIScrollView()
    let searchTextField = UITextField()
    let sortButton = UIButton()
    
    //DRESS SUB TYPE PARAMETERS
    
    var dressIdArray = NSArray()
    var dressSubTypeArray = NSArray()
    var dressSubTypeArrayInArabic = NSArray()
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
        
        //        self.tab1Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        selectedButton(tag: 0)
        
        self.serviceCall.API_DressSubType(DressSubTypeId: screenTag, delegate: self)

        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        self.serviceCall.API_DressSubType(DressSubTypeId: screenTag, delegate: self)
    }*/
    
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
            
            if Result.count != 0
            {
                dressIdArray = Result.value(forKey: "Id") as! NSArray
                print("dressIdArray", dressIdArray)
                
                dressSubTypeIdArray = Result.value(forKey: "DressId") as! NSArray
                print("Result", Result)
                
                dressSubTypeArray = Result.value(forKey: "NameInEnglish") as! NSArray
                print("dressSubTypeArray", dressSubTypeArray)
                
                dressSubTypeArrayInArabic = Result.value(forKey: "NameInArabic") as! NSArray
                print("NameInArabic", dressSubTypeArrayInArabic)
                
                dressSubTypeImages = Result.value(forKey: "Image") as! NSArray
                print("dressSubTypeImages", dressSubTypeImages)
                
                screenContents()
            }
            else
            {
                stopActivity()
                let emptyAlert = UIAlertController(title: "Alert", message: "We don't have sub types in this", preferredStyle: .alert)
                emptyAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: emptyDressTypesAlertAction(action:)))
                self.present(emptyAlert, animated: true, completion: nil)
            }
        }
        else if ResponseMsg == "Failure"
        {
            let Result = dressSubType.object(forKey: "Result") as! String
            print("Result", Result)
            
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func emptyDressTypesAlertAction(action : UIAlertAction)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func screenContents()
    {
        selfScreenNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        selfScreenNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(selfScreenNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 3
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        selfScreenNavigationBar.addSubview(backButton)
        
        selfScreenNavigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: selfScreenNavigationBar.frame.width, height: (3 * y))
        selfScreenNavigationTitle.text = "\(headingTitle.uppercased())"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        searchTextField.frame = CGRect(x: 0, y: selfScreenNavigationBar.frame.maxY, width: view.frame.width, height: (4 * y))
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
        searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        view.addSubview(searchTextField)
        
        let searchButton = UIButton()
        searchButton.frame = CGRect(x: view.frame.width - (5 * x), y: 0, width: (5 * x), height: (4 * y))
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.orange.cgColor
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        searchTextField.addSubview(searchButton)
        
        sortButton.frame = CGRect(x: view.frame.width - (view.frame.width / 2.75), y: searchTextField.frame.maxY + y, width: (view.frame.width / 3), height: (4 * y))
        sortButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        sortButton.setTitle("SORT", for: .normal)
        sortButton.setTitleColor(UIColor.white, for: .normal)
        sortButton.tag = 2
        //        sortButton.addTarget(self, action: #selector(self.featuresButtonAction(sender:)), for: .touchUpInside)
//        view.addSubview(sortButton)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                changeViewToEnglishInSelf()
                self.subTypeContents(getNameArray: dressSubTypeArray, getIdArray: dressIdArray, getImageArray: dressSubTypeImages)
            }
            else if language == "ar"
            {
                changeViewToArabicInSelf()
                self.subTypeContents(getNameArray: dressSubTypeArrayInArabic, getIdArray: dressIdArray, getImageArray: dressSubTypeImages)
            }
        }
        else
        {
            changeViewToEnglishInSelf()
            self.subTypeContents(getNameArray: dressSubTypeArray, getIdArray: dressIdArray, getImageArray: dressSubTypeImages)
        }
    }
    
    func subTypeContents(getNameArray : NSArray, getIdArray : NSArray, getImageArray : NSArray)
    {
        dressSubTypeScrollView.frame = CGRect(x: (3 * x), y: searchTextField.frame.maxY + (2 * y), width: view.frame.width - (6 * x), height: (45 * y))
        //        dressSubTypeScrollView.backgroundColor = UIColor.black
        view.addSubview(dressSubTypeScrollView)
        
        var y1:CGFloat = 0
        var x1:CGFloat = 0
        
        for views in dressSubTypeScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        for i in 0..<getNameArray.count
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
            dressTypeButton.backgroundColor = UIColor.white
            dressTypeButton.tag = getIdArray[i] as! Int
            dressTypeButton.addTarget(self, action: #selector(self.dressTypeButtonAction(sender:)), for: .touchUpInside)
            dressSubTypeScrollView.addSubview(dressTypeButton)
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    dressTypeButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
                else if language == "ar"
                {
                    dressTypeButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                }
            }
            else
            {
                dressTypeButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            
            x1 = dressTypeButton.frame.maxX + x
            
            let dressTypeImageView = UIImageView()
            dressTypeImageView.frame = CGRect(x: 0, y: 0, width: dressTypeButton.frame.width, height: (13 * y))
            //            dressTypeImageView.image = convertedDressImageArray[i]
            if let imageName = getImageArray[i] as? String
            {
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/DressSubType/\(imageName)"
                print("SUB TYPE IMAGES", api)
                let apiurl = URL(string: api)
                if apiurl != nil
                {
                    dressTypeImageView.dowloadFromServer(url: apiurl!)
                }
                
                if i == getImageArray.count - 1
                {
                    self.stopActivity()
                }
                else
                {
                    
                }
            }
            dressTypeButton.addSubview(dressTypeImageView)
            
            let dressTypeNameLabel = UILabel()
            if let dressName = getNameArray[i] as? String
            {
                if dressName.characters.count > 15
                {
                    dressTypeNameLabel.frame = CGRect(x: 0, y: dressTypeButton.frame.height - (4 * y), width: dressTypeButton.frame.width, height: (4 * y))
                    dressTypeNameLabel.numberOfLines = 2
                }
                else
                {
                    dressTypeNameLabel.frame = CGRect(x: 0, y: dressTypeImageView.frame.maxY, width: dressTypeButton.frame.width, height: (3 * y))
                    dressTypeNameLabel.numberOfLines = 1
                }
            }
//            dressTypeNameLabel.frame = CGRect(x: 0, y: dressTypeImageView.frame.maxY, width: dressTypeButton.frame.width, height: (3 * y))
            dressTypeNameLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            dressTypeNameLabel.text = getNameArray[i] as? String
            dressTypeNameLabel.textColor = UIColor.white
            dressTypeNameLabel.textAlignment = .center
            dressTypeNameLabel.font = UIFont(name: "Avenir-Regular", size: 10)
            dressTypeButton.addSubview(dressTypeNameLabel)
        }
        dressSubTypeScrollView.contentSize.height = y1 + (2 * y)
    }
    
    func changeViewToArabicInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        dressSubTypeScrollView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        searchTextField.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        searchTextField.textAlignment = .left
        searchTextField.placeholder = "بحث"
    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        dressSubTypeScrollView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        searchTextField.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        searchTextField.textAlignment = .left
        searchTextField.placeholder = "Search"
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        
        var nameArrayString = [String]()
        var imageArrayString = [String]()
        var idArrayString = [Int]()
        var nameArray = NSArray()
        var imageArray = NSArray()
        var idArray = NSArray()
        
        let text = textField.text
        
        print("ENTERED TEXTFIELD")
        if (text?.utf16.count)! >= 1{
            for i in 0..<dressSubTypeArray.count
            {
                if let dress = dressSubTypeArray[i] as? String
                {
                    let count = textField.text?.count
                    print("WELCOME OF DRESS", dress.prefix(count!))
                    let subString = dress.prefix(count!)
                    let convertedSubString = String(subString)
                    if textField.text == convertedSubString
                    {
                        print("BOTH ARE EQUAL", dress)
                        
                        nameArrayString.append(dress)
                        imageArrayString.append(dressSubTypeImages[i] as! String)
                        idArrayString.append(dressSubTypeIdArray[i] as! Int)
                    }
                }
            }
            
            nameArray = nameArrayString as NSArray
            imageArray = imageArrayString as NSArray
            idArray = idArrayString as NSArray
            
            print("NAME ARRAY AFTER", nameArray)
            
            subTypeContents(getNameArray: nameArray, getIdArray: idArray, getImageArray: imageArray)
            
        }
        else
        {
            subTypeContents(getNameArray: dressSubTypeArray, getIdArray: dressSubTypeIdArray, getImageArray: dressSubTypeImages)
        }
        
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dressTypeButtonAction(sender : UIButton)
    {
        if sender.tag == 1
        {
            let dressSubScreen = OrderTypeViewController()
            
            for i in 0..<dressSubTypeArray.count
            {
                if let id = dressIdArray[i] as? Int
                {
                    if sender.tag == id
                    {
                        UserDefaults.standard.set(dressSubTypeArray[i], forKey: "dressSubType")
                        UserDefaults.standard.set(id, forKey: "dressSubTypeId")
                        print("DRESS SUB TYPE OF SELECTED - \(sender.tag)", dressSubTypeArray[i])
                    }
                }
            }
            self.navigationController?.pushViewController(dressSubScreen, animated: true)
            
        }
        else
        {
            let emptyAlert = UIAlertController(title: "Alert", message: "We don't have sub types", preferredStyle: .alert)
            emptyAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(emptyAlert, animated: true, completion: nil)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
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
