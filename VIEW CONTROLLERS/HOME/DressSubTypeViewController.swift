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
    
    var addNameAlert = UIAlertController()

    
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
                self.navigationTitle.text = "\(headingTitle.uppercased())"
                self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            else if language == "ar"
            {
                self.navigationTitle.text = "\(headingTitle)"
                self.navigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            }
        }
        else
        {
            self.navigationTitle.text = "\(headingTitle.uppercased())"
            self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        self.serviceCall.API_DressSubType(DressSubTypeId: screenTag, delegate: self)

        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    /*override func viewWillAppear(_ animated: Bool)
    {
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
    }*/
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        //ErrorStr = "Default Error"
        PageNumStr = "DressSuBtypeViewController"
        MethodName = "DisplayDressSubType"
        
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("DRESS SUB-TYPE", errorMessage)
        stopActivity()
        activity.stopActivity()
        applicationDelegate.exitContents()
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
                
                dressSubTypeIdArray = Result.value(forKey: "DressId") as! NSArray
                
                dressSubTypeArray = Result.value(forKey: "NameInEnglish") as! NSArray
                
                dressSubTypeArrayInArabic = Result.value(forKey: "NameInArabic") as! NSArray
                
                dressSubTypeImages = Result.value(forKey: "Image") as! NSArray
                
                screenContents()
            }
            else
            {
                stopActivity()
                activity.stopActivity()
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
        let tag = Variables.sharedManager.measurementTag
        
        if tag == 1
        {
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    pageBar.image = UIImage(named: "DressInMeasurementEnglish")
                }
                else if language == "ar"
                {
                    pageBar.image = UIImage(named: "DressTypeInMeasurementArabic")
                }
            }
            else
            {
                pageBar.image = UIImage(named: "DressInMeasurementEnglish")
            }
        }
        else
        {
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    pageBar.image = UIImage(named: "Dress typeBar")
                }
                else if language == "ar"
                {
                    pageBar.image = UIImage(named: "dressTypeArabicHintImage")
                }
            }
            else
            {
                pageBar.image = UIImage(named: "Dress typeBar")
            }
        }
        
        searchTextField.frame = CGRect(x: 0, y: pageBar.frame.maxY, width: view.frame.width, height: (4 * y))
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
        searchButton.addTarget(self, action: #selector(self.searchButtonAction(sender:)), for: .touchUpInside)
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
    
    @objc func searchButtonAction(sender : UIButton)
    {
        searchTextField.becomeFirstResponder()
    }
    
    func subTypeContents(getNameArray : NSArray, getIdArray : NSArray, getImageArray : NSArray)
    {
        dressSubTypeScrollView.frame = CGRect(x: x, y: searchTextField.frame.maxY + y, width: view.frame.width - (2 * x), height: (view.frame.height - (searchTextField.frame.maxY + tabBar.frame.height + (2 * y))))
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
                dressTypeButton.frame = CGRect(x: 0, y: y1, width: (17.25 * x), height: (17 * y))
            }
            else
            {
                dressTypeButton.frame = CGRect(x: x1, y: y1, width: (17.25 * x), height: (17 * y))
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
            dressTypeImageView.frame = CGRect(x: 0, y: 0, width: dressTypeButton.frame.width, height: dressTypeButton.frame.height - (3 * y))
            //            dressTypeImageView.image = convertedDressImageArray[i]
            if let imageName = getImageArray[i] as? String
            {
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/DressSubType/\(imageName)"
                let apiurl = URL(string: api)
                if apiurl != nil
                {
                    dressTypeImageView.dowloadFromServer(url: apiurl!)
                }
                
                if i == getImageArray.count - 1
                {
                    self.stopActivity()
                    activity.stopActivity()
                }
                else
                {
                    
                }
            }
            dressTypeButton.addSubview(dressTypeImageView)
            
            let dressTypeNameLabel = UILabel()
            dressTypeNameLabel.frame = CGRect(x: 0, y: dressTypeImageView.frame.maxY, width: dressTypeButton.frame.width, height: (3 * y))

            if let dressName = getNameArray[i] as? String
            {
                if dressName.characters.count > 15
                {
                    dressTypeNameLabel.numberOfLines = 2
                }
                else
                {
                    dressTypeNameLabel.numberOfLines = 1
                }
            }
//            dressTypeNameLabel.frame = CGRect(x: 0, y: dressTypeImageView.frame.maxY, width: dressTypeButton.frame.width, height: (3 * y))
            dressTypeNameLabel.backgroundColor = ColorCode.buttonColor
            dressTypeNameLabel.text = getNameArray[i] as? String
            dressTypeNameLabel.textColor = UIColor.white
            dressTypeNameLabel.textAlignment = .center
            dressTypeNameLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
            dressTypeNameLabel.font = dressTypeNameLabel.font.withSize(1.5 * x)
            dressTypeNameLabel.tag = ((dressTypeButton.tag * 1) + 300)
            dressTypeButton.addSubview(dressTypeNameLabel)
        }
        
        if getNameArray.count % 2 == 0
        {
            dressSubTypeScrollView.contentSize.height = y1 + (2 * y)
        }
        else
        {
            dressSubTypeScrollView.contentSize.height = y1 + (18 * y)
        }
    }
    
    func changeViewToArabicInSelf()
    {
        dressSubTypeScrollView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        searchTextField.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        searchTextField.textAlignment = .left
        searchTextField.placeholder = "بحث"
    }
    
    func changeViewToEnglishInSelf()
    {
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
        
        if (text?.utf16.count)! >= 1{
            for i in 0..<dressSubTypeArray.count
            {
                if let dress = dressSubTypeArray[i] as? String
                {
                    let count = textField.text?.count
                    let subString = dress.prefix(count!)
                    let convertedSubString = String(subString)
                    if textField.text == convertedSubString
                    {
                        nameArrayString.append(dress)
                        imageArrayString.append(dressSubTypeImages[i] as! String)
                        idArrayString.append(dressSubTypeIdArray[i] as! Int)
                    }
                }
            }
            
            nameArray = nameArrayString as NSArray
            imageArray = imageArrayString as NSArray
            idArray = idArrayString as NSArray
            
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
        if sender.tag != 0
        {
            /*let dressSubScreen = OrderTypeViewController()
            Variables.sharedManager.dressSubTypeId = sender.tag
            
            if let label = view.viewWithTag((sender.tag * 1) + 300) as? UILabel
            {
                Variables.sharedManager.dressSubType = label.text!
            }

            let tag = Variables.sharedManager.measurementTag
            
            if tag == 1
            {
                addNewAlertAction()
            }
            else
            {
                self.navigationController?.pushViewController(dressSubScreen, animated: true)
            }*/
            
            let dressSubScreen = FlowTypeViewController()
            Variables.sharedManager.dressSubTypeId = sender.tag
            
            if let label = view.viewWithTag((sender.tag * 1) + 300) as? UILabel
            {
                Variables.sharedManager.dressSubType = label.text!
            }
            
            let tag = Variables.sharedManager.measurementTag
            
            if tag == 1
            {
                addNewAlertAction()
            }
            else
            {
                self.navigationController?.pushViewController(dressSubScreen, animated: true)
            }
        }
        else
        {
            let emptyAlert = UIAlertController(title: "Alert", message: "We don't have sub types", preferredStyle: .alert)
            emptyAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(emptyAlert, animated: true, completion: nil)
        }
    }
    
    func addNewAlertAction()
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
        addNewAlertAction()
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
                
                UserDefaults.standard.set(addNameAlert.textFields![0].text!, forKey: "measurementName")
                UserDefaults.standard.set("-1", forKey: "measurementIdInt")
                
                let measurement2Screen = Measurement2ViewController()
                self.navigationController?.pushViewController(measurement2Screen, animated: true)
            }
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
