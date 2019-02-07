//
//  Customization2ViewController.swift
//  Mzyoon
//
//  Created by QOL on 16/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class Customization2ViewController: CommonViewController, ServerAPIDelegate
{
    var brandArray = [Int]()
    let serviceCall = ServerAPI()
    
    
    var colorsArray = NSArray()
    var colorsIdArray = NSArray()
    var colorsImageArray = NSArray()
    var convertedColorsImageArray = [UIImage]()
    
    var materialsArray = NSArray()
    var materialsIdArray = NSArray()
    var materialsImageArray = NSArray()
    var convertedMaterialsImageArray = [UIImage]()
    
    var patternsArray = NSArray()
    var patternsIdArray = NSArray()
    var patternsImageArray = NSArray()
    var convertedPatternsImageArray = [UIImage]()
    
    var materialTagIntArray = [Int]()
    var colorTagIntArray = [Int]()
    var patternTagIntArray = [Int]()
    
    let patternSelectionImage = UIImageView()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    //SCREEN CONTENTS
    let materialScrollView = UIScrollView()
    let colorScrollView = UIScrollView()
    let patternScrollView = UIScrollView()
    
    var updatingId = Int()
    var selectedPatternId = Int()
    
    override func viewDidLoad()
    {
        print("SELECTED BRANDS IN 2", brandArray)
        navigationBar.isHidden = true
        
        //        self.tab1Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        selectedButton(tag: 0)
        
        super.viewDidLoad()
        
        self.serviceCallFunction(getMaterialId: [1], getColorId: [1])
        
        // Do any additional setup after loading the view.
    }
    
    func serviceCallFunction(getMaterialId : [Int], getColorId : [Int])
    {
        let getConversion = ConversionToJson()
        
        let id1 = getConversion.MakeRequest(id: getMaterialId)
        let id2 = getConversion.MakeRequest(id: getColorId)
        let id3 = getConversion.MakeRequest(id: brandArray)
        
        self.serviceCall.API_Customization2(brandId: id3, materialId: id1, ColorId: id2, delegate: self)
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        // ErrorStr = "Default Error"
        PageNumStr = "Customization2ViewController"
        MethodName = "GetCustomization2"
        
        print("UUID", UIDevice.current.identifierForVendor?.uuidString as Any)
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String) {
        print("CUSTOM 2 ", errorMessage)
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
    
    func API_CALLBACK_Customization2(custom2: NSDictionary)
    {
        
        let nameArray = NSArray()
        let idArray = NSArray()
        let imageArray = NSArray()
        
        print("CUSTOM 2", custom2)
        
        let ResponseMsg = custom2.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = custom2.object(forKey: "Result") as! NSDictionary
            
            let Colors = Result.object(forKey: "Colors") as! NSArray
            
            colorsArray = nameArray
            colorsIdArray = idArray
            colorsImageArray = imageArray
            
            materialsArray = nameArray
            materialsIdArray = idArray
            materialsImageArray = imageArray
            
            patternsArray = nameArray
            patternsIdArray = idArray
            patternsImageArray = imageArray
            
            colorsArray = Colors.value(forKey: "ColorInEnglish") as! NSArray
            colorsIdArray = Colors.value(forKey: "Id") as! NSArray
            colorsImageArray = Colors.value(forKey: "Image") as! NSArray
            
            /*for i in 0..<colorsImageArray.count
             {
             if let imageName = colorsImageArray[i] as? String
             {
             let api = "http://appsapi.mzyoon.com/images/Color/\(imageName)"
             print("CUSTOM ALL", api)
             let apiurl = URL(string: api)
             
             if let data = try? Data(contentsOf: apiurl!) {
             print("DATA OF IMAGE", data)
             if let image = UIImage(data: data) {
             self.convertedColorsImageArray.append(image)
             }
             }
             else
             {
             let emptyImage = UIImage(named: "empty")
             self.convertedColorsImageArray.append(emptyImage!)
             }
             }
             else if let imgName = colorsImageArray[i] as? NSNull
             {
             let emptyImage = UIImage(named: "empty")
             self.convertedColorsImageArray.append(emptyImage!)
             }
             }*/
            
            let Materials = Result.object(forKey: "Materials") as! NSArray
            
            materialsArray = Materials.value(forKey: "MaterialInEnglish") as! NSArray
            materialsIdArray = Materials.value(forKey: "Id") as! NSArray
            materialsImageArray = Materials.value(forKey: "Image") as! NSArray
            
            /*for i in 0..<materialsImageArray.count
             {
             if let imageName = materialsImageArray[i] as? String
             {
             print("IMAGE NAME", imageName)
             let api = "http://appsapi.mzyoon.com/images/Material/\(imageName)"
             print("CUSTOM ALL", api)
             let apiurl = URL(string: api)
             print("IMAGE URL", apiurl)
             
             if apiurl != nil
             {
             if let data = try? Data(contentsOf: apiurl!) {
             print("DATA OF IMAGE", data)
             if let image = UIImage(data: data) {
             self.convertedMaterialsImageArray.append(image)
             }
             }
             else
             {
             let emptyImage = UIImage(named: "empty")
             self.convertedMaterialsImageArray.append(emptyImage!)
             }
             }
             
             }
             else if let imgName = materialsImageArray[i] as? NSNull
             {
             let emptyImage = UIImage(named: "empty")
             self.convertedMaterialsImageArray.append(emptyImage!)
             }
             }*/
            
            let Patterns = Result.object(forKey: "Patterns") as! NSArray
            
            patternsArray = Patterns.value(forKey: "PatternInEnglish") as! NSArray
            patternsIdArray = Patterns.value(forKey: "Id") as! NSArray
            patternsImageArray = Patterns.value(forKey: "Image") as! NSArray
            
            /*for i in 0..<patternsImageArray.count
             {
             if let imageName = patternsImageArray[i] as? String
             {
             let api = "http://appsapi.mzyoon.com/images/Pattern/\(imageName)"
             print("CUSTOM ALL", api)
             let apiurl = URL(string: api)
             
             if let data = try? Data(contentsOf: apiurl!) {
             print("DATA OF IMAGE", data)
             if let image = UIImage(data: data) {
             self.convertedPatternsImageArray.append(image)
             }
             }
             else
             {
             let emptyImage = UIImage(named: "empty")
             self.convertedPatternsImageArray.append(emptyImage!)
             }
             }
             else if let imgName = patternsImageArray[i] as? NSNull
             {
             let emptyImage = UIImage(named: "empty")
             self.convertedPatternsImageArray.append(emptyImage!)
             }
             }*/
            
            if updatingId == 0
            {
                self.customization2Content()
            }
            else if updatingId == 1
            {
                colorContent()
            }
            else if updatingId == 2
            {
                patternContent()
            }
        }
        else if ResponseMsg == "Failure"
        {
            let Result = custom2.object(forKey: "Result") as! String
            print("Result", Result)
            
            ErrorStr = Result
            DeviceError()
        }
        
    }
    
    
    func customization2Content()
    {
        let customization2View = UIView()
        customization2View.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        customization2View.backgroundColor = UIColor.white
        //        view.addSubview(customization2View)
        
        let customization2NavigationBar = UIView()
        customization2NavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        customization2NavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(customization2NavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        backButton.tag = 3
        customization2NavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: customization2NavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "CUSTOMIZATION-2"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        customization2NavigationBar.addSubview(navigationTitle)
        
        /*let custom1Title = ["MATERIAL TYPE", "COLOR", "PATTERN"]
         
         var y1 = customization2NavigationBar.frame.maxY + y
         
         for i in 0..<custom1Title.count
         {
         let custom1Image = UIImageView()
         custom1Image.frame = CGRect(x: (4 * x), y: y1, width: view.frame.width - (8 * x), height: (3 * y))
         custom1Image.image = UIImage(named: "dashboardButton")
         view.addSubview(custom1Image)
         
         let titleLabel = UILabel()
         titleLabel.frame = CGRect(x: 2, y: 2, width: custom1Image.frame.width - 4, height: custom1Image.frame.height - 4)
         titleLabel.text = custom1Title[i]
         titleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
         titleLabel.textAlignment = .center
         custom1Image.addSubview(titleLabel)
         
         y1 = custom1Image.frame.maxY + (14 * y)
         }*/
        
        materialContent()
        colorContent()
        patternContent()
        
        let customization2NextButton = UIButton()
        customization2NextButton.frame = CGRect(x: view.frame.width - (5 * x), y: patternScrollView.frame.maxY, width: (4 * x), height: (4 * y))
        customization2NextButton.layer.cornerRadius = customization2NextButton.frame.height / 2
        customization2NextButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        customization2NextButton.setImage(UIImage(named: "rightArrow"), for: .normal)
        customization2NextButton.addTarget(self, action: #selector(self.customization2NextButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(customization2NextButton)
        
        self.stopActivity()
    }
    
    func materialContent()
    {
        let materialTitleLabel = UILabel()
        materialTitleLabel.frame = CGRect(x: ((view.frame.width - (15 * x)) / 2), y: (8 * y), width: (15 * x), height: (3 * y))
        materialTitleLabel.layer.borderWidth = 1
        materialTitleLabel.layer.masksToBounds = true
        materialTitleLabel.text = "MATERIAL TYPE"
        materialTitleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        materialTitleLabel.textAlignment = .center
        materialTitleLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        view.addSubview(materialTitleLabel)
        
        materialScrollView.frame = CGRect(x: (3 * x), y: materialTitleLabel.frame.maxY, width: view.frame.width, height: (12 * y))
        view.addSubview(materialScrollView)
        
        let buttonTitleText = ["All Material Type", "Fabric", "Synthetic", "Coton"]
        let imageName = ["All Color", "Red", "Green", "Black"]
        
        var x1:CGFloat = (2 * x)
        
        for i in 0..<materialsArray.count
        {
            let materialButton = UIButton()
            materialButton.frame = CGRect(x: x1, y: y, width: (12 * x), height: (10 * y))
            //            materialButton.setImage(UIImage(named: "genderBackground"), for: .normal)
            materialButton.tag = materialsIdArray[i] as! Int
            materialButton.addTarget(self, action: #selector(self.materialButtonAction), for: .touchUpInside)
            materialScrollView.addSubview(materialButton)
            
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: 0, y: 0, width: materialButton.frame.width, height: materialButton.frame.height - (2 * y))
            //            buttonImage.image = convertedMaterialsImageArray[i]
            if let imageName = materialsImageArray[i] as? String
            {
                let api = "http://appsapi.mzyoon.com/images/Material/\(imageName)"
                let apiurl = URL(string: api)
                
                if apiurl != nil
                {
                    buttonImage.dowloadFromServer(url: apiurl!)
                }
            }
            buttonImage.tag = -1
            materialButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 0, y: materialButton.frame.height - (2 * y), width: materialButton.frame.width, height: (2 * y))
            buttonTitle.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.text = materialsArray[i] as! String
            buttonTitle.textColor = UIColor.white
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 10)
            buttonTitle.adjustsFontSizeToFitWidth = true
            buttonTitle.tag = -1
            materialButton.addSubview(buttonTitle)
            
            x1 = materialButton.frame.maxX + (2 * x)
        }
        
        materialScrollView.contentSize.width = x1 + (2 * x)
    }
    
    func colorContent()
    {
        let colorTitleLabel = UILabel()
        colorTitleLabel.frame = CGRect(x: ((view.frame.width - (8 * x)) / 2), y: materialScrollView.frame.maxY + (2 * y), width: (8 * x), height: (3 * y))
        colorTitleLabel.layer.borderWidth = 1
        colorTitleLabel.layer.masksToBounds = true
        colorTitleLabel.backgroundColor = UIColor.white
        colorTitleLabel.text = "COLOR"
        colorTitleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        colorTitleLabel.textAlignment = .center
        colorTitleLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        view.addSubview(colorTitleLabel)
        
        colorScrollView.frame = CGRect(x: (3 * x), y: colorTitleLabel.frame.maxY, width: view.frame.width - (3 * x), height: (12 * y))
        view.addSubview(colorScrollView)
        
        for views in colorScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        let buttonTitleText2 = ["All Color", "Red", "Green", "Black"]
        var x2:CGFloat = (2 * x)
        for i in 0..<colorsArray.count
        {
            let colorButton = UIButton()
            colorButton.frame = CGRect(x: x2, y: y, width: (12 * x), height: (10 * y))
            //            colorButton.setImage(UIImage(named: "genderBackground"), for: .normal)
            colorButton.tag = colorsIdArray[i] as! Int
            colorButton.addTarget(self, action: #selector(self.colorButtonAction), for: .touchUpInside)
            colorScrollView.addSubview(colorButton)
            
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: 0, y: 0, width: colorButton.frame.width, height: colorButton.frame.height - (2 * y))
            //            buttonImage.image = convertedColorsImageArray[i]
            if let imageName = colorsImageArray[i] as? String
            {
                let api = "http://appsapi.mzyoon.com/images/Color/\(imageName)"
                let apiurl = URL(string: api)
                print("COLOR IMAGE API", apiurl)
                
                if apiurl != nil{
                    buttonImage.dowloadFromServer(url: apiurl!)
                }
            }
            buttonImage.tag = -1
            colorButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 0, y: colorButton.frame.height - (2 * y), width: colorButton.frame.width, height: (2 * y))
            buttonTitle.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.text = colorsArray[i] as! String
            buttonTitle.textColor = UIColor.white
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 10)
            buttonTitle.tag = -1
            colorButton.addSubview(buttonTitle)
            
            x2 = colorButton.frame.maxX + (2 * x)
        }
        
        colorScrollView.contentSize.width = x2 + (2 * x)
    }
    
    func patternContent()
    {
        let patternTitleLabel = UILabel()
        patternTitleLabel.frame = CGRect(x: ((view.frame.width - (10 * x)) / 2), y: colorScrollView.frame.maxY + (2 * y), width: (10 * x), height: (3 * y))
        patternTitleLabel.layer.borderWidth = 1
        patternTitleLabel.layer.masksToBounds = true
        patternTitleLabel.backgroundColor = UIColor.white
        patternTitleLabel.text = "PATTERN"
        patternTitleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        patternTitleLabel.textAlignment = .center
        patternTitleLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        view.addSubview(patternTitleLabel)
        
        patternScrollView.frame = CGRect(x: (3 * x), y: patternTitleLabel.frame.maxY, width: view.frame.width, height: (12 * y))
        view.addSubview(patternScrollView)
        
        for views in patternScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        let buttonTitleText3 = ["All Pattern", "Checked", "Houndstooth", "Twill"]
        
        var x3:CGFloat = (2 * x)
        
        for i in 0..<patternsArray.count
        {
            let patternButton = UIButton()
            patternButton.frame = CGRect(x: x3, y: y, width: (12 * x), height: (10 * y))
            //            patternButton.setImage(UIImage(named: "genderBackground"), for: .normal)
            patternButton.tag = patternsIdArray[i] as! Int
            patternButton.addTarget(self, action: #selector(self.patternButtonAction), for: .touchUpInside)
            patternScrollView.addSubview(patternButton)
            
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: 0, y: 0, width: patternButton.frame.width, height: patternButton.frame.height - (2 * y))
            //            buttonImage.image = convertedPatternsImageArray[i]
            if let imageName = patternsImageArray[i] as? String
            {
                let api = "http://appsapi.mzyoon.com/images/Pattern/\(imageName)"
                let apiurl = URL(string: api)
                print("PATTERN IMAGE API", apiurl!)
                if apiurl != nil
                {
                    buttonImage.dowloadFromServer(url: apiurl!)
                }
            }
            buttonImage.tag = -1
            patternButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 0, y: patternButton.frame.height - (2 * y), width: patternButton.frame.width, height: (2 * y))
            buttonTitle.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.text = patternsArray[i] as! String
            buttonTitle.textColor = UIColor.white
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 10)
            buttonTitle.tag = -1
            patternButton.addSubview(buttonTitle)
            
            x3 = patternButton.frame.maxX + (2 * x)
        }
        
        patternScrollView.contentSize.width = x3 + (2 * x)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func materialButtonAction(sender : UIButton)
    {
        updatingId = 1
        
        let materialSelectionImage = UIImageView()
        materialSelectionImage.frame = CGRect(x: x, y: y, width: (2 * x), height: (2 * y))
        materialSelectionImage.image = UIImage(named: "selectionImage")
        materialSelectionImage.tag = sender.tag
        
        if sender.tag != 1
        {
            materialTagIntArray = materialTagIntArray.filter { $0 != 1 }
            
            for views in materialScrollView.subviews
            {
                if let buttonView = views.viewWithTag(1)
                {
                    for buttonSubView in buttonView.subviews
                    {
                        if buttonSubView.tag == 1
                        {
                            buttonSubView.removeFromSuperview()
                        }
                    }
                }
            }
            
            if materialTagIntArray.isEmpty == true
            {
                materialTagIntArray.append(sender.tag)
                sender.addSubview(materialSelectionImage)
            }
            else
            {
                if materialTagIntArray.contains(sender.tag)
                {
                    if let index = materialTagIntArray.index(where: {$0 == sender.tag}) {
                        materialTagIntArray.remove(at: index)
                    }
                    
                    for views in sender.subviews
                    {
                        if let findView = views.viewWithTag(sender.tag)
                        {
                            if findView.tag == sender.tag
                            {
                                print("FIND VIEW", findView.description)
                                findView.removeFromSuperview()
                            }
                            else
                            {
                                print("NOT SAME VIEW")
                            }
                        }
                    }
                }
                else
                {
                    materialTagIntArray.append(sender.tag)
                    sender.addSubview(materialSelectionImage)
                }
            }
            print("SEASONAL ARRAY", materialTagIntArray)
            
            if materialTagIntArray.count != 0
            {
                if colorTagIntArray.count != 0
                {
                    self.serviceCallFunction(getMaterialId: materialTagIntArray, getColorId: colorTagIntArray)
                }
                else
                {
                    self.serviceCallFunction(getMaterialId: materialTagIntArray, getColorId: [1])
                }
            }
            else
            {
                if colorTagIntArray.count != 0
                {
                    self.serviceCallFunction(getMaterialId: [1], getColorId: colorTagIntArray)
                }
                else
                {
                    self.serviceCallFunction(getMaterialId: [1], getColorId: [1])
                }
            }
        }
        else
        {
            for views in materialScrollView.subviews
            {
                if let buttonView = views.viewWithTag(views.tag)
                {
                    for buttonSubView in buttonView.subviews
                    {
                        if buttonSubView.tag == views.tag
                        {
                            buttonSubView.removeFromSuperview()
                        }
                    }
                }
            }
            
            if materialTagIntArray.contains(sender.tag)
            {
                if let index = materialTagIntArray.index(where: {$0 == sender.tag}) {
                    materialTagIntArray.remove(at: index)
                }
                
                for views in sender.subviews
                {
                    if let findView = views.viewWithTag(sender.tag)
                    {
                        if findView.tag == sender.tag
                        {
                            print("FIND VIEW", findView.description)
                            findView.removeFromSuperview()
                        }
                        else
                        {
                            print("NOT SAME VIEW")
                        }
                    }
                }
            }
            else
            {
                materialTagIntArray.removeAll()
                
                materialTagIntArray.append(sender.tag)
                sender.addSubview(materialSelectionImage)
            }
            
            if colorTagIntArray.count != 0
            {
                self.serviceCallFunction(getMaterialId: [1], getColorId: colorTagIntArray)
            }
            else
            {
                self.serviceCallFunction(getMaterialId: [1], getColorId: [1])
            }
        }
    }
    
    @objc func colorButtonAction(sender : UIButton)
    {
        updatingId = 2
        
        let colorSelectionImage = UIImageView()
        colorSelectionImage.frame = CGRect(x: x, y: y, width: (2 * x), height: (2 * y))
        colorSelectionImage.image = UIImage(named: "selectionImage")
        colorSelectionImage.tag = sender.tag
        
        if sender.tag != 1
        {
            colorTagIntArray = colorTagIntArray.filter { $0 != 1 }
            
            for views in colorScrollView.subviews
            {
                if let buttonView = views.viewWithTag(1)
                {
                    for buttonSubView in buttonView.subviews
                    {
                        if buttonSubView.tag == 1
                        {
                            buttonSubView.removeFromSuperview()
                        }
                    }
                }
            }
            
            if colorTagIntArray.isEmpty == true
            {
                colorTagIntArray.append(sender.tag)
                sender.addSubview(colorSelectionImage)
            }
            else
            {
                if colorTagIntArray.contains(sender.tag)
                {
                    if let index = colorTagIntArray.index(where: {$0 == sender.tag}) {
                        colorTagIntArray.remove(at: index)
                    }
                    
                    for views in sender.subviews
                    {
                        if let findView = views.viewWithTag(sender.tag)
                        {
                            if findView.tag == sender.tag
                            {
                                print("FIND VIEW", findView.description)
                                findView.removeFromSuperview()
                            }
                            else
                            {
                                print("NOT SAME VIEW")
                            }
                        }
                    }
                }
                else
                {
                    colorTagIntArray.append(sender.tag)
                    sender.addSubview(colorSelectionImage)
                }
            }
            print("SEASONAL ARRAY", colorTagIntArray)
            
            if materialTagIntArray.count == 0
            {
                if colorTagIntArray.count == 0
                {
                    self.serviceCallFunction(getMaterialId: [1], getColorId: [1])
                }
                else
                {
                    self.serviceCallFunction(getMaterialId: [1], getColorId: colorTagIntArray)
                }
            }
            else
            {
                if colorTagIntArray.count == 0
                {
                    self.serviceCallFunction(getMaterialId: materialTagIntArray, getColorId: [1])
                }
                else
                {
                    self.serviceCallFunction(getMaterialId: materialTagIntArray, getColorId: colorTagIntArray)
                }
            }
            
        }
        else
        {
            for views in colorScrollView.subviews
            {
                if let buttonView = views.viewWithTag(views.tag)
                {
                    for buttonSubView in buttonView.subviews
                    {
                        if buttonSubView.tag == views.tag
                        {
                            buttonSubView.removeFromSuperview()
                        }
                    }
                }
            }
            
            if colorTagIntArray.contains(sender.tag)
            {
                if let index = colorTagIntArray.index(where: {$0 == sender.tag}) {
                    colorTagIntArray.remove(at: index)
                }
                
                for views in sender.subviews
                {
                    if let findView = views.viewWithTag(sender.tag)
                    {
                        if findView.tag == sender.tag
                        {
                            print("FIND VIEW", findView.description)
                            findView.removeFromSuperview()
                        }
                        else
                        {
                            print("NOT SAME VIEW")
                        }
                    }
                }
            }
            else
            {
                colorTagIntArray.removeAll()
                
                colorTagIntArray.append(sender.tag)
                sender.addSubview(colorSelectionImage)
            }
            
            if materialTagIntArray.count == 0
            {
                self.serviceCallFunction(getMaterialId: [1], getColorId: [1])
            }
            else
            {
                self.serviceCallFunction(getMaterialId: materialTagIntArray, getColorId: [1])
            }
        }
    }
    
    @objc func patternButtonAction(sender : UIButton)
    {
        patternSelectionImage.frame = CGRect(x: x, y: y, width: (2 * x), height: (2 * y))
        patternSelectionImage.image = UIImage(named: "selectionImage")
        patternSelectionImage.tag = sender.tag
        sender.addSubview(patternSelectionImage)
        
        selectedPatternId = sender.tag
        
        /*if patternTagIntArray.isEmpty == true
         {
         patternTagIntArray.append(sender.tag)
         sender.addSubview(patternSelectionImage)
         }
         else
         {
         if patternTagIntArray.contains(sender.tag)
         {
         if let index = patternTagIntArray.index(where: {$0 == sender.tag}) {
         patternTagIntArray.remove(at: index)
         }
         
         for views in sender.subviews
         {
         if let findView = views.viewWithTag(sender.tag)
         {
         if findView.tag == sender.tag
         {
         print("FIND VIEW", findView.description)
         findView.removeFromSuperview()
         }
         else
         {
         print("NOT SAME VIEW")
         }
         }
         }
         }
         else
         {
         patternTagIntArray.append(sender.tag)
         sender.addSubview(patternSelectionImage)
         }
         }*/
    }
    
    @objc func customization2NextButtonAction(sender : UIButton)
    {
        print("SELECTED PATTERN ID", selectedPatternId)
        
        var selectedMaterialNameArray = [String]()
        var selectedColorNameArray = [String]()
        var selectedPatternNameArray = String()
        
        if materialTagIntArray.count != 0
        {
            for i in 0..<materialsIdArray.count
            {
                for j in 0..<materialTagIntArray.count
                {
                    if let id = materialsIdArray[i] as? Int
                    {
                        if id == materialTagIntArray[j]
                        {
                            print("SELECTED OF MATERIAL", materialsIdArray[i], materialsArray[i])
                            selectedMaterialNameArray.append(materialsArray[i] as! String)
                        }
                    }
                }
            }
            
            UserDefaults.standard.set(selectedMaterialNameArray, forKey: "material")
        }
        else
        {
            UserDefaults.standard.set("All Material", forKey: "material")
        }
        
        if colorTagIntArray.count != 0
        {
            for i in 0..<colorsIdArray.count
            {
                for j in 0..<colorTagIntArray.count
                {
                    if let id = colorsIdArray[i] as? Int
                    {
                        if id == colorTagIntArray[j]
                        {
                            print("SELECTED OF COLOR", colorsIdArray[i], colorsArray[i])
                            selectedColorNameArray.append(colorsArray[i] as! String)
                        }
                    }
                }
            }
            
            UserDefaults.standard.set(selectedColorNameArray, forKey: "color")
        }
        else
        {
            UserDefaults.standard.set("All Colors", forKey: "color")
        }
        
        if selectedPatternId != 0
        {
            for i in 0..<patternsIdArray.count
            {
                if let id = patternsIdArray[i] as? Int
                {
                    if id == selectedPatternId
                    {
                        print("SELECTED OF PATTERN", patternsIdArray[i], patternsArray[i])
                        selectedPatternNameArray.append(patternsArray[i] as! String)
                    }
                }
            }
            
            UserDefaults.standard.set(selectedPatternNameArray, forKey: "pattern")
        }
        else
        {
            UserDefaults.standard.set(patternsArray[0], forKey: "pattern")
        }
        
        if selectedPatternId != nil
        {
            UserDefaults.standard.set(selectedPatternId, forKey: "patternId")
            
            let custom3Screen = Customization3ViewController()
            self.navigationController?.pushViewController(custom3Screen, animated: true)
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "Please select atleast one pattern to proceed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
