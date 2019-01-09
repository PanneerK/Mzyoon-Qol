//
//  Customization3ViewController.swift
//  Mzyoon
//
//  Created by QOL on 16/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class Customization3ViewController: CommonViewController, ServerAPIDelegate
{
    
    let serviceCall = ServerAPI()

    var CustomizationImgIdArray = NSArray()
    var CustomizationImagesArray = NSArray()
    var convertedCustomizationImageArray = [UIImage]()
    
    var CustomizationAttIdArray = NSArray()
    var CustomizationAttNameArray = NSArray()
    
    var AttributeImagesIdArray = NSArray()
    var attributeNameEnglishArray = NSArray()
    var AttributeImagesArray = NSArray()
    var convertedAttributeImageArray = [UIImage]()
    
    let dropDownButton = UIButton()
    let customizationScrollView = UIScrollView()

    let customedImageView = UIImageView()
    let customedFrontButton = UIButton()
    let customedBackButton = UIButton()
    let selectionImage = UIImageView()

    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    var customizationArray = Int()
    let selectionImage1 = UIImageView()
    
    var customLapels = [String : String]()
    var customButtons = [String : String]()
    var customPockets = [String : String]()
    var selectedCustom = String()
    var subSelectedCustom = Int()
    var customDict = [String : String]()
    var customDictValuesCount = 0

    override func viewDidLoad()
    {
        navigationBar.isHidden = true
        
//        self.tab1Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        selectedButton(tag: 0)
        
        self.serviceCall.API_Customization3(DressTypeId: 5, delegate: self)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
       // ErrorStr = "Default Error"
        PageNumStr = "Customization3ViewController"
       // MethodName = "do"
        
        print("UUID", UIDevice.current.identifierForVendor?.uuidString as Any)
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String) {
        print("CUSTOM 3", errorMessage)
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
    
    func API_CALLBACK_Customization3(custom3: NSDictionary)
    {
        print("CUSTOM 3", custom3)
        
        let ResponseMsg = custom3.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = custom3.object(forKey: "Result") as! NSDictionary
            
            // CustomizationImages:
            let CustomizationImages = Result.object(forKey: "CustomizationImages") as! NSArray
            CustomizationImgIdArray = CustomizationImages.value(forKey: "Id") as! NSArray
            CustomizationImagesArray = CustomizationImages.value(forKey: "Image") as! NSArray
            
            /*for i in 0..<CustomizationImagesArray.count
            {
                if let imageName = CustomizationImagesArray[i] as? String
                {
                    let api = "http://appsapi.mzyoon.com/images/Customazation3/\(imageName)"
                    let apiurl = URL(string: api)
                    print("CUSTOM ALL OF", api)

                    if apiurl != nil
                    {
                        if let data = try? Data(contentsOf: apiurl!)
                        {
                            print("DATA OF IMAGE", data)
                            if let image = UIImage(data: data)
                            {
                                self.convertedCustomizationImageArray.append(image)
                            }
                        }
                        else
                        {
                            let emptyImage = UIImage(named: "empty")
                            self.convertedCustomizationImageArray.append(emptyImage!)
                        }
                    }
                }
                else if let imgName = CustomizationImagesArray[i] as? NSNull
                {
                    let emptyImage = UIImage(named: "empty")
                    self.convertedCustomizationImageArray.append(emptyImage!)
                }
            }*/
            
            // CustomizationAttributes:
            let CustomizationAttributes = Result.object(forKey: "CustomizationAttributes") as! NSArray
            
            CustomizationAttIdArray = CustomizationAttributes.value(forKey: "Id") as! NSArray
            CustomizationAttNameArray = CustomizationAttributes.value(forKey: "AttributeNameInEnglish") as! NSArray
            
            for i in 0..<CustomizationAttNameArray.count
            {
                if let customString = CustomizationAttNameArray[i] as? String
                {
                    customDict[customString] = ""
                }
            }
            
            
            /*// AttributeImages:
            let AttributeImages = Result.object(forKey: "AttributeImages") as! NSArray
            AttributeImagesIdArray = AttributeImages.value(forKey: "Id") as! NSArray
            attributeNameEnglishArray = AttributeImages.value(forKey: "AttributeNameInEnglish") as! NSArray
            AttributeImagesArray = AttributeImages.value(forKey: "Images") as! NSArray
            
            print("IMAGE NAME IN CALL BACK", AttributeImagesArray)*/
            
            /*for i in 0..<AttributeImagesArray.count
            {
                if let imageName = AttributeImagesArray[i] as? String
                {
                    let api = "http://appsapi.mzyoon.com/images/Customazation3/\(imageName)"
                    print("CUSTOM ALL", api)
                    let apiurl = URL(string: api)
                    
                    if apiurl != nil
                    {
                        if let data = try? Data(contentsOf: apiurl!)
                        {
                            print("DATA OF IMAGE", data)
                            if let image = UIImage(data: data) {
                                self.convertedAttributeImageArray.append(image)
                            }
                        }
                        else
                        {
                            let emptyImage = UIImage(named: "empty")
                            self.convertedAttributeImageArray.append(emptyImage!)
                        }
                    }
                }
                else if let imgName = AttributeImagesArray[i] as? NSNull
                {
                    let emptyImage = UIImage(named: "empty")
                    self.convertedAttributeImageArray.append(emptyImage!)
                }
            }*/
             self.customization3Content()
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = custom3.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetCustomization3"
            ErrorStr = Result
            DeviceError()
        }
        
    }
    
    func API_CALLBACK_Customization3Attr(custom3Attr: NSDictionary)
    {
        print("Custom-3 Attributes:", custom3Attr)
        
        let ResponseMsg = custom3Attr.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = custom3Attr.object(forKey: "Result") as! NSArray
            
            // AttributeImages:
            AttributeImagesIdArray = Result.value(forKey: "Id") as! NSArray
            attributeNameEnglishArray = Result.value(forKey: "AttributeNameInEnglish") as! NSArray
            AttributeImagesArray = Result.value(forKey: "Images") as! NSArray
            
            print("AttributeImagesNameArray", AttributeImagesArray)
            /*for i in 0..<AttributeImagesArray.count
            {
                if let imageName = AttributeImagesArray[i] as? String
                {
                    let api = "http://appsapi.mzyoon.com/images/Customazation3/\(imageName)"
                    print("CUSTOM ALL", api)
                    let apiurl = URL(string: api)
                    
                    if apiurl != nil
                    {
                        if let data = try? Data(contentsOf: apiurl!)
                        {
                            print("DATA OF IMAGE", data)
                            if let image = UIImage(data: data) {
                                self.convertedAttributeImageArray.append(image)
                            }
                        }
                        else
                        {
                            let emptyImage = UIImage(named: "empty")
                            self.convertedAttributeImageArray.append(emptyImage!)
                        }
                    }
                }
                else if let imgName = AttributeImagesArray[i] as? NSNull
                {
                    let emptyImage = UIImage(named: "empty")
                    self.convertedAttributeImageArray.append(emptyImage!)
                }
            }*/
            subcCustomization3Content()
        }
        else if ResponseMsg == "Failure"
        {
            let Result = custom3Attr.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetAttributesByAttributeId"
            ErrorStr = Result
            DeviceError()
        }
        
        
    }
    
    func customization3Content()
    {
        self.stopActivity()
        let customization3View = UIView()
        customization3View.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        customization3View.backgroundColor = UIColor.white
//        view.addSubview(customization3View)
        
        let customization3NavigationBar = UIView()
        customization3NavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        customization3NavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(customization3NavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        backButton.tag = 3
        customization3NavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: customization3NavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "CUSTOMIZATION-3"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        customization3NavigationBar.addSubview(navigationTitle)
        
        let viewDesignLabel = UILabel()
        viewDesignLabel.frame = CGRect(x: (3 * x), y: customization3NavigationBar.frame.maxY + y, width: (25 * x), height: (4 * y))
        viewDesignLabel.layer.cornerRadius = 10
        viewDesignLabel.layer.masksToBounds = true
        viewDesignLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        viewDesignLabel.text = "VIEW YOUR DESIGN HERE"
        viewDesignLabel.textColor = UIColor.white
        viewDesignLabel.textAlignment = .center
        viewDesignLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        view.addSubview(viewDesignLabel)
        
        customedImageView.frame = CGRect(x: (3 * x), y: viewDesignLabel.frame.maxY + y, width: (25 * x), height: (25 * y))
        customedImageView.layer.borderWidth = 1
        customedImageView.layer.borderColor = UIColor.lightGray.cgColor
        customedImageView.backgroundColor = UIColor.white
        if let imageName = CustomizationImagesArray[1] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/Customazation3/\(imageName)"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            customedImageView.dowloadFromServer(url: apiurl!)
        }
        view.addSubview(customedImageView)

        customedFrontButton.frame = CGRect(x: customedImageView.frame.maxX + x, y: customedImageView.frame.minY + (9 * y), width: (7.5 * x), height: (7.5 * y))
        customedFrontButton.layer.borderWidth = 1
        customedFrontButton.layer.borderColor = UIColor.lightGray.cgColor
        customedFrontButton.backgroundColor = UIColor.white
//        customedFrontButton.setImage(convertedCustomizationImageArray[1], for: .normal)
        if let imageName = CustomizationImagesArray[1] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/Customazation3/\(imageName)"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: customedFrontButton.frame.width, height: customedFrontButton.frame.height)
            dummyImageView.dowloadFromServer(url: apiurl!)
            customedFrontButton.addSubview(dummyImageView)
        }
        customedFrontButton.tag = 1
        customedFrontButton.addTarget(self, action: #selector(self.dressSelectionButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(customedFrontButton)
        
        selectionImage.frame = CGRect(x: x, y: y, width: (2 * x), height: (2 * y))
        selectionImage.image = UIImage(named: "selectionImage")
        customedFrontButton.addSubview(selectionImage)
        
        customedBackButton.frame = CGRect(x: customedImageView.frame.maxX + x, y: customedFrontButton.frame.maxY + y, width: (7.5 * x), height: (7.5 * y))
        customedBackButton.layer.borderWidth = 1
        customedBackButton.layer.borderColor = UIColor.lightGray.cgColor
        customedBackButton.backgroundColor = UIColor.white
//        customedBackButton.setImage(convertedCustomizationImageArray[0], for: .normal)
        if let imageName = CustomizationImagesArray[0] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/Customazation3/\(imageName)"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: customedBackButton.frame.width, height: customedBackButton.frame.height)
            dummyImageView.dowloadFromServer(url: apiurl!)
            customedBackButton.addSubview(dummyImageView)
        }
        customedBackButton.tag = 0
        customedBackButton.addTarget(self, action: #selector(self.dressSelectionButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(customedBackButton)
        
        
        dropDownButton.frame = CGRect(x: (3 * x), y: customedImageView.frame.maxY + (2 * y), width: view.frame.width - (6 * x), height: (4 * y))
        dropDownButton.layer.cornerRadius = 5
        dropDownButton.layer.masksToBounds = true
        dropDownButton.backgroundColor = UIColor.lightGray
        if let alertString = CustomizationAttNameArray[0] as? String
        {
            dropDownButton.setTitle(alertString.uppercased(), for: .normal)
        }
        dropDownButton.setTitleColor(UIColor.black, for: .normal)
        dropDownButton.addTarget(self, action: #selector(self.dropDownButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(dropDownButton)
        
        selectedCustom = CustomizationAttNameArray[0] as! String
        
        let dropDownImageView = UIImageView()
        dropDownImageView.frame = CGRect(x: dropDownButton.frame.width - (4 * x), y: 0, width: (4 * x), height: (4 * y))
        dropDownImageView.layer.cornerRadius = 5
        dropDownImageView.backgroundColor = UIColor.orange
        dropDownImageView.image = UIImage(named: "downArrow")
        dropDownButton.addSubview(dropDownImageView)
        
        let templateImage4 = dropDownImageView.image?.withRenderingMode(.alwaysTemplate)
        dropDownImageView.image = templateImage4
        dropDownImageView.tintColor = UIColor.white
        
        serviceCall.API_Customization3Attr(AttributeId: 1, delegate: self)
    }
    
    @objc func dressSelectionButtonAction(sender : UIButton)
    {
        selectionImage.frame = CGRect(x: x, y: y, width: (2 * x), height: (2 * y))
        selectionImage.image = UIImage(named: "selectionImage")
        sender.addSubview(selectionImage)
        
        if let imageName = CustomizationImagesArray[sender.tag] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/Customazation3/\(imageName)"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            customedImageView.dowloadFromServer(url: apiurl!)
        }
    }

    
    func subcCustomization3Content()
    {
        customizationScrollView.frame = CGRect(x: 0, y: dropDownButton.frame.maxY + y, width: view.frame.width, height: (12 * y))
        view.addSubview(customizationScrollView)
        
        print("CUSTOM DICT", customDict)
        
        for views in customizationScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        for (keys, values) in customDict
        {
            if selectedCustom == keys
            {
                print("VALUES FOR KEYS", values)
                if values.isEmpty == true
                {
                    
                }
                else
                {
                    subSelectedCustom = Int(values)!
                }
            }
        }
        
        var x3:CGFloat = (2 * x)
        for i in 0..<AttributeImagesArray.count
        {
            let customizationButton = UIButton()
            customizationButton.frame = CGRect(x: x3, y: y, width: (12 * x), height: (10 * y))
            customizationButton.backgroundColor = UIColor.white
            customizationButton.tag = i
            customizationButton.addTarget(self, action: #selector(self.customizationButtonAction), for: .touchUpInside)
            customizationScrollView.addSubview(customizationButton)
            
            print("SUB SELECTED ITEM", subSelectedCustom)
            
            if customDict[selectedCustom]?.isEmpty == true
            {
                
            }
            else
            {
                if i == subSelectedCustom
                {
                    self.customizationButtonAction(sender: customizationButton)
                }
            }
            
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: (3 * x), y: 0, width: customizationButton.frame.width - (6 * x), height: customizationButton.frame.height - (2 * y))
            buttonImage.backgroundColor = UIColor.white
//            buttonImage.image = convertedAttributeImageArray[i]
            
            print("IMAGES NAME", AttributeImagesArray[i])
            if let imageName = AttributeImagesArray[i] as? String
            {
                let api = "http://appsapi.mzyoon.com/images/Customazation3/\(imageName)"
                let apiurl = URL(string: api)
                print("IMAGE OF DOWN", apiurl!)
                buttonImage.dowloadFromServer(url: apiurl!)
            }
            buttonImage.tag = -1
            customizationButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 0, y: customizationButton.frame.height - (2 * y), width: customizationButton.frame.width, height: (2 * y))
            buttonTitle.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.text = attributeNameEnglishArray[i] as! String
            buttonTitle.adjustsFontSizeToFitWidth = true
            buttonTitle.textColor = UIColor.white
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 10)
            buttonTitle.tag = -2
            customizationButton.addSubview(buttonTitle)
            
            x3 = customizationButton.frame.maxX + (2 * x)
        }                                                                                                                                                                                                                                                                                                                                                                                                                                                              
        
        customizationScrollView.contentSize.width = x3 
        
        let customization3NextButton = UIButton()
        customization3NextButton.frame = CGRect(x: view.frame.width - (5 * x), y: customizationScrollView.frame.maxY + y, width: (4 * x), height: (4 * y))
        customization3NextButton.layer.masksToBounds = true
        customization3NextButton.setImage(UIImage(named: "rightArrow"), for: .normal)
//        customization3NextButton.backgroundColor = UIColor.orange
//        customization3NextButton.setTitle("NEXT", for: .normal)
//        customization3NextButton.setTitleColor(UIColor.white, for: .normal)
        customization3NextButton.addTarget(self, action: #selector(self.customization3NextButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(customization3NextButton)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func customizationButtonAction(sender : UIButton)
    {
        selectionImage1.frame = CGRect(x: x, y: y, width: (2 * x), height: (2 * y))
        selectionImage1.image = UIImage(named: "selectionImage")
        selectionImage1.tag = sender.tag
        sender.addSubview(selectionImage1)
        
        for i in 0..<CustomizationAttNameArray.count
        {
            if let selectionCustom = CustomizationAttNameArray[i] as? String
            {
                print("EQUATING", selectionCustom, selectedCustom)

                if selectionCustom == selectedCustom
                {
                    customDict[selectedCustom] = "\(sender.tag)"
                }
            }
        }
        
        print("CUSTOM DICT", customDict)
        
        customizationArray = sender.tag
    }
    
    @objc func dropDownButtonAction(sender : UIButton)
    {
        let customizationAlert = UIAlertController(title: "Customize", message: "Customize your material", preferredStyle: .alert)
        
        for i in 0..<CustomizationAttNameArray.count
        {
            if let alertString = CustomizationAttNameArray[i] as? String
            {
                customizationAlert.addAction(UIAlertAction(title: alertString.uppercased(), style: .default, handler: customizaionAlertAction(action:)))
            }
        }
        customizationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(customizationAlert, animated: true, completion: nil)
    }
    
    func customizaionAlertAction(action : UIAlertAction)
    {
        print("ALERT ADD ACTION", action.title!.uppercased())
        
        selectedCustom = action.title!.lowercased()
        
        dropDownButton.setTitle(action.title!.uppercased(), for: .normal)
        
        for i in 0..<CustomizationAttNameArray.count
        {
            if let checkName = CustomizationAttNameArray[i] as? String
            {
                if checkName.uppercased() == action.title!
                {
                    print("WELCOME TO SAME", action.title!)
                    serviceCall.API_Customization3Attr(AttributeId: i + 1, delegate: self)
                }
            }
        }
    }
    
    @objc func customization3NextButtonAction(sender : UIButton)
    {
        print("NEXT ACTION", CustomizationAttNameArray.count, customDict.count)
        
        print("SELECTED CUSTOM", customDict, selectedCustom, customDictValuesCount)
        
        for (keys, values) in customDict
        {
            print("KEYS - \(keys), VALUES - \(values)")
            
            if values.isEmpty == true || values == ""
            {
                let customEmptyAlert = UIAlertController(title: "Alert", message: "Please choose your customization for \(keys) and procced to next", preferredStyle: .alert)
                customEmptyAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(customEmptyAlert, animated: true, completion: nil)
            }
            else
            {
                if CustomizationAttNameArray.count != customDictValuesCount
                {
                    customDictValuesCount = customDictValuesCount + 1
                }
            }
        }
        
        print("EQUAL COUNT", CustomizationAttNameArray.count, customDictValuesCount)
        if CustomizationAttNameArray.count == customDictValuesCount
        {
            let measurement1Screen = Measurement1ViewController()
            self.navigationController?.pushViewController(measurement1Screen, animated: true)
        }
        else
        {
            
        }
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
