//
//  Measurement2ViewController.swift
//  Mzyoon
//
//  Created by QOL on 27/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class Measurement2ViewController: CommonViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, ServerAPIDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate
{
    let serviceCall = ServerAPI()
    
    let imageButton = UIButton()
    let partsButton = UIButton()
    
    let alphabets = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    var pageControl : UIPageControl = UIPageControl(frame: CGRect(x:50,y: 300, width:200, height:50))
    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    let imageScrollView = UIScrollView()
    
    let imageView = UIView()
    let partsView = UIView()
    var gender = String()
    let numberView = UIView()
    let unitView = UIView()
    let cmButton = UIButton()
    let inButton = UIButton()
    
    // Measurements2Image...
    var Measurement2ImgIdArray = NSArray()
    var Measurement2ImagesArray = NSArray()
    var convertedMeasurement2ImageArray = [UIImage]()
    
    
    // Measurements2...
    var MeasurementsIdArray = NSArray()
    var GenderMeasurementIdArray = NSArray()
    var MeasurementsNameArray = NSArray()
    var MeasurementsImagesArray = NSArray()
    var MeasurementsReferenceNumberArray = NSArray()
    var convertedMeasurementsImageArray = [UIImage]()
    
    //GET PARAMETERS
    let getNeckLabel = UILabel()
    let getHeadLabel = UILabel()
    let getChestLabel = UILabel()
    let getWaistLabel = UILabel()
    let getThighLabel = UILabel()
    let getKneeLabel = UILabel()
    let getAnkleLabel = UILabel()
    let gettotalheightLabel = UILabel()
    let getHipheightLabel = UILabel()
    let getBottomheightLabel = UILabel()
    let getKneeheightLabel = UILabel()
    let getShoulderLabel = UILabel()
    let getSleeveLabel = UILabel()
    let getBicepLabel = UILabel()
    let getHipLabel = UILabel()
    let getBackLabel = UILabel()
    let getHeightLabel = UILabel()
    let getFullSleeveLabel = UILabel()
    let getHandKneeLabel = UILabel()
    
    // Parts...
    var PartsIdArray = NSArray()
    var PartsGenderMeasurementIdArray = NSArray()
    var PartsNameArray = NSArray()
    var PartsImagesArray = NSArray()
    var PartsReferenceNumberArray = NSArray()
    var convertedPartsImageArray = [UIImage]()
    
    //GENDER IMAGES PARAMETERS
    var genderImageArray = NSArray()
    var genderImagesIdArray = NSArray()
    var converetedGenderImagesArray = [UIImage]()
    
    let partsTableView = UITableView()
    
    let partsMeasurementLabel = UILabel()
    let rulerScroll = UIScrollView()
    let imageBackView = UIView()
    let partsImageView = UIImageView()
    let partsBackView = UIView()
    let selectedPartsImageView = UIImageView()
    let partsInputTextField = UITextField()
    
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    // Parts...
    var selectedPartsIdArray = NSArray()
    var selectedPartsImagesArray = NSArray()
    var selectedconvertedPartsImageArray = [UIImage]()
    
    //SELETCTED
    var measurerImage = String()
    var measurerTag = Int()
    
    var measurementValues = [Int : Float]()
    
    var type = "table"
    var unitTag = "cm"
    var pageNumber = 0
    
    override func viewDidLoad()
    {
        navigationBar.isHidden = true
        //        self.tab1Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        selectedButton(tag: 0)
        
        if let dressid = UserDefaults.standard.value(forKey: "dressSubTypeId") as? Int
        {
            self.serviceCall.API_GetMeasurement2(Measurement1Value: dressid, delegate: self)

        }
        else if let dressid = UserDefaults.standard.value(forKey: "dressSubTypeId") as? String
        {
            self.serviceCall.API_GetMeasurement2(Measurement1Value: Int(dressid)!, delegate: self)
        }
        
        
//        self.serviceCall.API_DisplayMeasurement(Measurement2Value: 1, delegate: self)
        
        
        addDoneButtonOnKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String) {
        print("ERROR MESSAGE", errorMessage)
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        //  ErrorStr = "Default Error"
        PageNumStr = "Measurement2ViewController"
        // MethodName = "do"
        
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
    
    func API_CALLBACK_GetMeasurement2(GetMeasurement1val: NSDictionary)
    {
        let ResponseMsg = GetMeasurement1val.object(forKey: "ResponseMsg") as! String
        print("GetMeasurement1Value", GetMeasurement1val)
        if ResponseMsg == "Success"
        {
            let Result = GetMeasurement1val.object(forKey: "Result") as! NSDictionary
            
            let Image = Result.object(forKey: "Image") as! NSArray
            
            genderImageArray = Image.value(forKey: "Image") as! NSArray
            
            genderImagesIdArray = Image.value(forKey: "id") as! NSArray
            
            for i in 0..<genderImageArray.count
            {
                if let imageName = genderImageArray[i] as? String
                {
                    let urlString = serviceCall.baseURL
                    let api = "\(urlString)/images/Measurement2/\(imageName)"
                    
                    let apiurl = URL(string: api)
                    
                    if apiurl != nil
                    {
                        if let data = try? Data(contentsOf: apiurl!)
                        {
                            if let image = UIImage(data: data)
                            {
                                self.converetedGenderImagesArray.append(image)
                            }
                        }
                        else
                        {
                            let emptyImage = UIImage(named: "empty")
                            self.converetedGenderImagesArray.append(emptyImage!)
                        }
                    }
                }
                else if genderImageArray[i] is NSNull
                {
                    let emptyImage = UIImage(named: "empty")
                    self.converetedGenderImagesArray.append(emptyImage!)
                }
            }
            
            // Body Parts :
            
            let Measurements = Result.object(forKey: "Measurements") as! NSArray
            PartsIdArray = Measurements.value(forKey: "Id") as! NSArray
            PartsNameArray = Measurements.value(forKey: "TextInEnglish") as! NSArray
            PartsReferenceNumberArray = Measurements.value(forKey: "ReferenceNumber") as! NSArray
            PartsGenderMeasurementIdArray = Measurements.value(forKey: "GenderMeasurementId") as! NSArray
            PartsImagesArray = Measurements.value(forKey: "Image") as! NSArray
            
            for i in 0..<PartsImagesArray.count
            {
                if let imageName = PartsImagesArray[i] as? String
                {
                    let urlString = serviceCall.baseURL
                    let api = "\(urlString)/images/Measurement2/\(imageName)"
                    
                    let apiurl = URL(string: api)
                    
                    if apiurl != nil
                    {
                        if let data = try? Data(contentsOf: apiurl!)
                        {
                            if let image = UIImage(data: data)
                            {
                                self.convertedPartsImageArray.append(image)
                            }
                        }
                        else
                        {
                            let emptyImage = UIImage(named: "empty")
                            self.convertedPartsImageArray.append(emptyImage!)
                        }
                    }
                }
                else if PartsImagesArray[i] is NSNull
                {
                    let emptyImage = UIImage(named: "empty")
                    self.convertedPartsImageArray.append(emptyImage!)
                }
            }
            
            for i in 0..<PartsIdArray.count
            {
                if let customString = PartsIdArray[i] as? Int
                {
                    measurementValues[customString] = 0
                }
            }
            
            print("measurementValues 111111", measurementValues)
            
            self.measurement2Contents()
            partsTableView.reloadData()
        }
        else if ResponseMsg == "Failure"
        {
            let Result = GetMeasurement1val.object(forKey: "Result") as! String
            
            MethodName = "DisplayMeasurementBySubTypeId"
            ErrorStr = Result
            DeviceError()
        }
        
        
    }
    
    func API_CALLBACK_DisplayMeasurement(GetMeasurement2val: NSDictionary) 
    {
        let ResponseMsg = GetMeasurement2val.object(forKey: "ResponseMsg") as! String
        print("GetMeasurement2Value", GetMeasurement2val)
        if ResponseMsg == "Success"
        {
            let Result = GetMeasurement2val.object(forKey: "Result") as! NSArray
            
            // Body Parts :
            PartsIdArray = Result.value(forKey: "Id") as! NSArray
            PartsNameArray = Result.value(forKey: "TextInEnglish") as! NSArray
            PartsReferenceNumberArray = Result.value(forKey: "ReferenceNumber") as! NSArray
            PartsGenderMeasurementIdArray = Result.value(forKey: "GenderMeasurementId") as! NSArray
            PartsImagesArray = Result.value(forKey: "Image") as! NSArray
            
            for i in 0..<PartsImagesArray.count
            {
                if let imageName = PartsImagesArray[i] as? String
                {
                    let urlString = serviceCall.baseURL
                    let api = "\(urlString)/images/Measurement2/\(imageName)"
                    
                    let apiurl = URL(string: api)
                    
                    if apiurl != nil
                    {
                        if let data = try? Data(contentsOf: apiurl!)
                        {
                            if let image = UIImage(data: data)
                            {
                                self.convertedPartsImageArray.append(image)
                            }
                        }
                        else
                        {
                            let emptyImage = UIImage(named: "empty")
                            self.convertedPartsImageArray.append(emptyImage!)
                        }
                    }
                }
                else if PartsImagesArray[i] is NSNull
                {
                    let emptyImage = UIImage(named: "empty")
                    self.convertedPartsImageArray.append(emptyImage!)
                }
            }
            
            for i in 0..<PartsIdArray.count
            {
                if let customString = PartsIdArray[i] as? Int
                {
                    measurementValues[customString] = 0
                }
            }
            
            print("measurementValues", measurementValues)
            
            self.measurement2Contents()
            partsTableView.reloadData()
        }
        else if ResponseMsg == "Failure"
        {
            let Result = GetMeasurement2val.object(forKey: "Result") as! String
            
            MethodName = "DisplayMeasurementBySubTypeId"
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func measurement2Contents()
    {
        imageBackView.removeFromSuperview()
        
        let measurement1NavigationBar = UIView()
        measurement1NavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        measurement1NavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(measurement1NavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        backButton.tag = 3
        measurement1NavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: measurement1NavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "MEASUREMENT-2"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        measurement1NavigationBar.addSubview(navigationTitle)
        
        imageButton.frame = CGRect(x: 0, y: measurement1NavigationBar.frame.maxY, width: ((view.frame.width / 2) - 1), height: (5 * y))
        imageButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        imageButton.setTitle("IMAGE", for: .normal)
        imageButton.setTitleColor(UIColor.white, for: .normal)
        imageButton.tag = 0
        imageButton.addTarget(self, action: #selector(self.selectionViewButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(imageButton)
        
        let dropDown = UIImageView()
        dropDown.frame = CGRect(x: imageButton.frame.width - (5 * x), y: y, width: (3 * x), height: (3 * y))
        dropDown.image = UIImage(named: "downArrow")
        imageButton.addSubview(dropDown)
        
        partsButton.frame = CGRect(x: imageButton.frame.maxX + 1, y: measurement1NavigationBar.frame.maxY, width: view.frame.width / 2, height: (5 * y))
        partsButton.backgroundColor = UIColor.lightGray
        partsButton.setTitle("PARTS", for: .normal)
        partsButton.setTitleColor(UIColor.black, for: .normal)
        partsButton.tag = 1
        partsButton.addTarget(self, action: #selector(self.selectionViewButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(partsButton)
        
        let dropDown1 = UIImageView()
        dropDown1.frame = CGRect(x: partsButton.frame.width - (5 * x), y: y, width: (3 * x), height: (3 * y))
        dropDown1.image = UIImage(named: "downArrow")
        partsButton.addSubview(dropDown1)
        
        imageViewContents(isHidden : false)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func selectionViewButtonAction(sender : UIButton)
    {
        if sender.tag == 0
        {
            partsButton.backgroundColor = UIColor.lightGray
            partsButton.setTitleColor(UIColor.black, for: .normal)
            imageViewContents(isHidden: false)
            //            partsViewContents(isHidden: true)
            partsView.removeFromSuperview()
        }
        else if sender.tag == 1
        {
            imageButton.backgroundColor = UIColor.lightGray
            imageButton.setTitleColor(UIColor.black, for: .normal)
            //            imageViewContents(isHidden: true)
            partsViewContents(isHidden: false)
            imageView.removeFromSuperview()
        }
        
        sender.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        sender.setTitleColor(UIColor.white, for: .normal)
    }
    
    func pageNumberContents()
    {
        numberView.frame = CGRect(x: ((imageView.frame.width - (14 * x)) / 2), y: imageView.frame.height - (3 * y), width: (14 * x), height: (2 * y))
        numberView.backgroundColor = UIColor.clear
        imageView.addSubview(numberView)
        
        for views in numberView.subviews
        {
            views.removeFromSuperview()
        }
        
        var x1:CGFloat = 0
        
        for i in 0..<4
        {
            let pageNumberlabel = UILabel()
            pageNumberlabel.frame = CGRect(x: x1, y: 0, width: (2 * x), height: (2 * x))
            pageNumberlabel.layer.cornerRadius = pageNumberlabel.frame.width / 2
            pageNumberlabel.layer.borderWidth = 1
            pageNumberlabel.layer.borderColor = UIColor.black.cgColor
            pageNumberlabel.layer.masksToBounds = true
            if i == pageNumber
            {
                pageNumberlabel.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
            }
            else
            {
                pageNumberlabel.backgroundColor = UIColor.clear
            }
            pageNumberlabel.text = "\(i + 1)"
            pageNumberlabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            pageNumberlabel.textAlignment = .center
            pageNumberlabel.tag = (i + 1) * 20
            numberView.addSubview(pageNumberlabel)
            
            let lineLabel = UILabel()
            lineLabel.frame = CGRect(x: pageNumberlabel.frame.maxX, y: ((pageNumberlabel.frame.height - 1) / 2), width: (2 * x), height: 1)
            lineLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            
            if i != 3
            {
                numberView.addSubview(lineLabel)
            }
            
            x1 = lineLabel.frame.maxX
        }
    }
    
    func imageViewContents(isHidden : Bool)
    {
        imageView.frame = CGRect(x: (3 * x), y: imageButton.frame.maxY + y, width: view.frame.width - (6 * x), height: view.frame.height - (18 * y))
        imageView.backgroundColor = UIColor.clear
        view.addSubview(imageView)
        
        imageView.isHidden = isHidden
        
        imageScrollView.frame = CGRect(x: 0, y: 0, width: imageView.frame.width, height: imageView.frame.height - 30)
        imageScrollView.isPagingEnabled = true
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.delegate = self
        imageView.addSubview(imageScrollView)
        
        imageScrollView.contentSize.width = (4 * imageScrollView.frame.width)
        
        pageNumberContents()
        
        unitView.frame = CGRect(x: (2 * x), y: view.frame.height - (9 * y), width: (7 * x), height: (2.5 * y))
        unitView.layer.cornerRadius = unitView.frame.height / 2
        unitView.layer.borderWidth = 1
        view.addSubview(unitView)
        
        cmButton.frame = CGRect(x: 0, y: 0, width: unitView.frame.width / 2, height: unitView.frame.height)
        cmButton.setTitle("CM", for: .normal)
        cmButton.tag = 1
        cmButton.addTarget(self, action: #selector(self.unitButtonAction(sender:)), for: .touchUpInside)
        unitView.addSubview(cmButton)
        
        inButton.frame = CGRect(x: cmButton.frame.maxX, y: 0, width:  unitView.frame.width / 2, height: unitView.frame.height)
        inButton.setTitle("IN", for: .normal)
        inButton.tag = 2
        inButton.addTarget(self, action: #selector(self.unitButtonAction(sender:)), for: .touchUpInside)
        unitView.addSubview(inButton)
        
        if unitTag == "cm"
        {
            cmButton.layer.cornerRadius = cmButton.frame.height / 2
            cmButton.layer.borderWidth = 1
            cmButton.backgroundColor = UIColor.orange
        }
        else
        {
            inButton.layer.cornerRadius = inButton.frame.height / 2
            inButton.layer.borderWidth = 1
            inButton.backgroundColor = UIColor.orange
        }
        
        let nextButton = UIButton()
        nextButton.frame = CGRect(x: view.frame.width - (5 * x), y: view.frame.height - (9 * y), width: (3 * x), height: (3 * y))
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
        nextButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        nextButton.setImage(UIImage(named: "rightArrow"), for: .normal)
        nextButton.addTarget(self, action: #selector(self.nextButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(nextButton)
        
        gender = "men"
        
        var measureImages = [String]()
        if gender == "men"
        {
            measureImages = ["Man-front", "Man-front_2", "Man-Back", "Man-Back_2"]
        }
        else
        {
            measureImages = ["boyFront_1", "boyFront_2", "boyBack_1", "boyBack_2"]
        }
        
        var buttonTag = Int()
        
        
        for index in 0..<4 {
            
            frame.origin.x = imageScrollView.frame.size.width * CGFloat(index)
            frame.size = imageScrollView.frame.size
            
            let subView = UIView(frame: frame)
            //            let subView = UIView()
            //            subView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height - 30)
            //            subView.backgroundColor = colors[index]
            imageScrollView.addSubview(subView)
            
            let measurementImageView = UIImageView()
            measurementImageView.frame = CGRect(x: x, y: y, width: subView.frame.width / 2, height: subView.frame.height - (2 * y))
            //            measurementImageView.backgroundColor = UIColor.cyan
//            measurementImageView.image = UIImage(named: measureImages[index])
            measurementImageView.image = converetedGenderImagesArray[index]
            subView.addSubview(measurementImageView)
            
            let verticalLine = UILabel()
            verticalLine.frame = CGRect(x: subView.frame.width - x, y: y, width: 1, height: subView.frame.height - (2 * y))
            //            verticalLine.backgroundColor = UIColor.red
            subView.addSubview(verticalLine)
            
            let verticalLine2 = UILabel()
            verticalLine2.frame = CGRect(x: subView.frame.width - (6 * x), y: y, width: 1, height: subView.frame.height - (2 * y))
            //            verticalLine2.backgroundColor = UIColor.red
            subView.addSubview(verticalLine2)
            
            if gender == "men"
            {
                if index == 0
                {
                    let headLabel = UILabel()
                    headLabel.frame = CGRect(x: (10.8 * x), y: (y / 2), width: (10.8 * x), height: (2 * y))
                    headLabel.text = "Head"
                    headLabel.textColor = UIColor.black
                    headLabel.textAlignment = .center
                    headLabel.font = headLabel.font.withSize(15)
                    headLabel.tag = ((1 * 1) + 300)
                    subView.addSubview(headLabel)
                    
                    let headButton = UIButton()
                    headButton.frame = CGRect(x: (10.8 * x), y: (1.2 * y), width: subView.frame.width - (16.8 * x), height: (3 * y))
                    headButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    headButton.tag = 1
                    headButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(headButton)
                    
                    getHeadLabel.frame = CGRect(x: headButton.frame.maxX, y: (1.2 * y), width: (5 * x), height: (3 * y))
                    if let measurement = UserDefaults.standard.value(forKey: "Measure-Head") as? String
                    {
                        getHeadLabel.text = measurement
                    }
                    else
                    {
                        getHeadLabel.text = "0.0"
                    }
                    getHeadLabel.textColor = UIColor.blue
                    getHeadLabel.textAlignment = .center
                    getHeadLabel.font = headLabel.font.withSize(15)
                    getHeadLabel.tag = ((1 * 1) + 200)
                    subView.addSubview(getHeadLabel)
                    
                    let neckLabel = UILabel()
                    neckLabel.frame = CGRect(x: (11.8 * x), y: (6 * y), width: subView.frame.width - (17.8 * x), height: (2 * y))
                    neckLabel.text = "Neck"
                    neckLabel.textColor = UIColor.black
                    neckLabel.textAlignment = .center
                    neckLabel.font = headLabel.font.withSize(15)
                    neckLabel.tag = ((2 * 1) + 300)
                    subView.addSubview(neckLabel)
                    
                    let neckButton = UIButton()
                    neckButton.frame = CGRect(x: (11.8 * x), y: (6.7 * y), width: subView.frame.width - (17.8 * x), height: (3 * y))
                    neckButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    neckButton.tag = 2
                    neckButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(neckButton)
                    
                    getNeckLabel.frame = CGRect(x: neckButton.frame.maxX, y: (6.7 * y), width: (5 * x), height: (3 * y))
                    getNeckLabel.text = "0.0"
                    getNeckLabel.textColor = UIColor.blue
                    getNeckLabel.textAlignment = .center
                    getNeckLabel.font = headLabel.font.withSize(15)
                    getNeckLabel.tag = ((2 * 1) + 200)
                    subView.addSubview(getNeckLabel)
                    
                    let chestLabel = UILabel()
                    chestLabel.frame = CGRect(x: (13.2 * x), y: (10.9 * y), width: subView.frame.width - (19.2 * x), height: (2 * y))
                    chestLabel.text = "Chest"
                    chestLabel.textColor = UIColor.black
                    chestLabel.textAlignment = .center
                    chestLabel.font = headLabel.font.withSize(15)
                    chestLabel.tag = ((3 * 1) + 300)
                    subView.addSubview(chestLabel)
                    
                    let chestButton = UIButton()
                    chestButton.frame = CGRect(x: (13.2 * x), y: (11.4 * y), width: subView.frame.width - (19.2 * x), height: (3 * y))
                    chestButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    chestButton.tag = 3
                    chestButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(chestButton)
                    
                    getChestLabel.frame = CGRect(x: chestButton.frame.maxX, y: (11.4 * y), width: (5 * x), height: (3 * y))
                    getChestLabel.text = "0.0"
                    getChestLabel.textColor = UIColor.blue
                    getChestLabel.textAlignment = .center
                    getChestLabel.font = headLabel.font.withSize(15)
                    getChestLabel.tag = ((3 * 1) + 200)
                    subView.addSubview(getChestLabel)
                    
                    let waistLabel = UILabel()
                    waistLabel.frame = CGRect(x: (12.5 * x), y: (14.5 * y), width: subView.frame.width - (18.5 * x), height: (2 * y))
                    waistLabel.text = "Waist"
                    waistLabel.textColor = UIColor.black
                    waistLabel.textAlignment = .center
                    waistLabel.font = headLabel.font.withSize(15)
                    waistLabel.tag = ((4 * 1) + 300)
                    subView.addSubview(waistLabel)
                    
                    let waistButton = UIButton()
                    waistButton.frame = CGRect(x: (12.5 * x), y: (15 * y), width: subView.frame.width - (18.5 * x), height: (3 * y))
                    waistButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    waistButton.tag = 4
                    waistButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(waistButton)
                    
                    getWaistLabel.frame = CGRect(x: waistButton.frame.maxX, y: (15 * y), width: (5 * x), height: (3 * y))
                    getWaistLabel.text = "0.0"
                    getWaistLabel.textColor = UIColor.blue
                    getWaistLabel.textAlignment = .center
                    getWaistLabel.font = headLabel.font.withSize(15)
                    getWaistLabel.tag = ((4 * 1) + 200)
                    subView.addSubview(getWaistLabel)
                    
                    let thighLabel = UILabel()
                    thighLabel.frame = CGRect(x: (13 * x), y: (25.6 * y), width: subView.frame.width - (19 * x), height: (2 * y))
                    thighLabel.text = "Thigh"
                    thighLabel.textColor = UIColor.black
                    thighLabel.textAlignment = .center
                    thighLabel.font = headLabel.font.withSize(15)
                    thighLabel.tag = ((5 * 1) + 300)
                    subView.addSubview(thighLabel)
                    
                    let thighButton = UIButton()
                    thighButton.frame = CGRect(x: (13 * x), y: (26.1 * y), width: subView.frame.width - (19 * x), height: (3 * y))
                    thighButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    thighButton.tag = 5
                    thighButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(thighButton)
                    
                    getThighLabel.frame = CGRect(x: thighButton.frame.maxX, y: (26.1 * y), width: (5 * x), height: (3 * y))
                    getThighLabel.text = "0.0"
                    getThighLabel.textColor = UIColor.blue
                    getThighLabel.textAlignment = .center
                    getThighLabel.font = headLabel.font.withSize(15)
                    getThighLabel.tag = ((5 * 1) + 200)
                    subView.addSubview(getThighLabel)
                    
                    let kneeLabel = UILabel()
                    kneeLabel.frame = CGRect(x: (11.8 * x), y: (30.6 * y), width: subView.frame.width - (17.8 * x), height: (2 * y))
                    kneeLabel.text = "Knee"
                    kneeLabel.textColor = UIColor.black
                    kneeLabel.textAlignment = .center
                    kneeLabel.font = headLabel.font.withSize(15)
                    kneeLabel.tag = ((6 * 1) + 300)
                    subView.addSubview(kneeLabel)
                    
                    let kneeButton = UIButton()
                    kneeButton.frame = CGRect(x: (11.8 * x), y: (31.1 * y), width: subView.frame.width - (17.8 * x), height: (3 * y))
                    kneeButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    kneeButton.tag = 6
                    kneeButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(kneeButton)
                    
                    getKneeLabel.frame = CGRect(x: kneeButton.frame.maxX, y: (31.1 * y), width: (5 * x), height: (3 * y))
                    getKneeLabel.text = "0.0"
                    getKneeLabel.textColor = UIColor.blue
                    getKneeLabel.textAlignment = .center
                    getKneeLabel.font = headLabel.font.withSize(15)
                    getKneeLabel.tag = ((6 * 1) + 200)
                    subView.addSubview(getKneeLabel)
                    
                    let ankleLabel = UILabel()
                    ankleLabel.frame = CGRect(x: (11.2 * x), y: (39.9 * y), width: subView.frame.width - (17.2 * x), height: (2 * y))
                    ankleLabel.text = "Ankle"
                    ankleLabel.textColor = UIColor.black
                    ankleLabel.textAlignment = .center
                    ankleLabel.font = headLabel.font.withSize(15)
                    ankleLabel.tag = ((7 * 1) + 300)
                    subView.addSubview(ankleLabel)
                    
                    let ankleButton = UIButton()
                    ankleButton.frame = CGRect(x: (11.2 * x), y: (40.4 * y), width: subView.frame.width - (17.2 * x), height: (3 * y))
                    ankleButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    ankleButton.tag = 7
                    ankleButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(ankleButton)
                    
                    getAnkleLabel.frame = CGRect(x: ankleButton.frame.maxX, y: (40.4 * y), width: (5 * x), height: (3 * y))
                    getAnkleLabel.text = "0.0"
                    getAnkleLabel.textColor = UIColor.blue
                    getAnkleLabel.textAlignment = .center
                    getAnkleLabel.font = headLabel.font.withSize(15)
                    getAnkleLabel.tag = ((7 * 1) + 200)
                    subView.addSubview(getAnkleLabel)
                }
                else if index == 1
                {
                    let totalheightLabel = UILabel()
                    totalheightLabel.frame = CGRect(x: 0, y: (14.5 * y), width: subView.frame.width - (6 * x), height: (2 * y))
                    totalheightLabel.text = "Over all height"
                    totalheightLabel.textColor = UIColor.black
                    totalheightLabel.textAlignment = .center
                    totalheightLabel.font = totalheightLabel.font.withSize(15)
                    totalheightLabel.tag = ((8 * 1) + 300)
                    subView.addSubview(totalheightLabel)
                    
                    let overAllHeightButton = UIButton()
                    overAllHeightButton.frame = CGRect(x: 0, y: (15 * y), width: subView.frame.width - (6 * x), height: (3 * y))
                    overAllHeightButton.setImage(UIImage(named: "lengthArrowMark"), for: .normal)
                    //                    overAllHeightButton.backgroundColor = UIColor.red
                    overAllHeightButton.tag = 8
                    overAllHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(overAllHeightButton)
                    
                    gettotalheightLabel.frame = CGRect(x: overAllHeightButton.frame.maxX, y: (15 * y), width: (5 * x), height: (3 * y))
                    gettotalheightLabel.text = "0.0"
                    gettotalheightLabel.textColor = UIColor.blue
                    gettotalheightLabel.textAlignment = .center
                    gettotalheightLabel.font = gettotalheightLabel.font.withSize(15)
                    gettotalheightLabel.tag = ((8 * 1) + 200)
                    subView.addSubview(gettotalheightLabel)
                    
                    let hipHeightLabel = UILabel()
                    hipHeightLabel.frame = CGRect(x: (4.3 * x), y: (39.5 * y), width: subView.frame.width - (10.3 * x), height: (2 * y))
                    hipHeightLabel.text = "Hip height"
                    hipHeightLabel.textColor = UIColor.black
                    hipHeightLabel.textAlignment = .center
                    hipHeightLabel.font = hipHeightLabel.font.withSize(15)
                    hipHeightLabel.tag = ((9 * 1) + 300)
                    subView.addSubview(hipHeightLabel)
                    
                    let hipHeightButton = UIButton()
                    hipHeightButton.frame = CGRect(x: (4.3 * x), y: (40 * y), width: subView.frame.width - (10.3 * x), height: (3 * y))
                    hipHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    hipHeightButton.tag = 9
                    hipHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(hipHeightButton)
                    
                    getHipheightLabel.frame = CGRect(x: hipHeightButton.frame.maxX, y: (40 * y), width: (5 * x), height: (3 * y))
                    getHipheightLabel.text = "0.0"
                    getHipheightLabel.textColor = UIColor.blue
                    getHipheightLabel.textAlignment = .center
                    getHipheightLabel.font = getHipheightLabel.font.withSize(15)
                    getHipheightLabel.tag = ((9 * 1) + 200)
                    subView.addSubview(getHipheightLabel)
                    
                    let bottomheightLabel = UILabel()
                    bottomheightLabel.frame = CGRect(x: (8.2 * x), y: (34.5 * y), width: subView.frame.width - (14.2 * x), height: (2 * y))
                    bottomheightLabel.text = "Bottom height"
                    bottomheightLabel.textColor = UIColor.black
                    bottomheightLabel.textAlignment = .center
                    bottomheightLabel.font = totalheightLabel.font.withSize(15)
                    bottomheightLabel.tag = ((10 * 1) + 300)
                    subView.addSubview(bottomheightLabel)
                    
                    let bottomHeightButton = UIButton()
                    bottomHeightButton.frame = CGRect(x: (8.2 * x), y: (35 * y), width: subView.frame.width - (14.2 * x), height: (3 * y))
                    bottomHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    bottomHeightButton.tag = 10
                    bottomHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(bottomHeightButton)
                    
                    getBottomheightLabel.frame = CGRect(x: bottomHeightButton.frame.maxX, y: (35 * y), width: (5 * x), height: (3 * y))
                    getBottomheightLabel.text = "0.0"
                    getBottomheightLabel.textColor = UIColor.blue
                    getBottomheightLabel.textAlignment = .center
                    getBottomheightLabel.font = getBottomheightLabel.font.withSize(15)
                    getBottomheightLabel.tag = ((10 * 1) + 200)
                    subView.addSubview(getBottomheightLabel)
                    
                    let kneeheightLabel = UILabel()
                    kneeheightLabel.frame = CGRect(x: (11.6 * x), y: (27.3 * y), width: subView.frame.width - (17.6 * x), height: (2 * y))
                    kneeheightLabel.text = "Knee height"
                    kneeheightLabel.textColor = UIColor.black
                    kneeheightLabel.textAlignment = .center
                    kneeheightLabel.font = totalheightLabel.font.withSize(15)
                    kneeheightLabel.tag = ((11 * 1) + 300)
                    subView.addSubview(kneeheightLabel)
                    
                    let kneeHeightButton = UIButton()
                    kneeHeightButton.frame = CGRect(x: (11.6 * x), y: (27.8 * y), width: subView.frame.width - (17.6 * x), height: (3 * y))
                    kneeHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    kneeHeightButton.tag = 11
                    kneeHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(kneeHeightButton)
                    
                    getKneeheightLabel.frame = CGRect(x: kneeHeightButton.frame.maxX, y: (27.8 * y), width: (5 * x), height: (3 * y))
                    getKneeheightLabel.text = "0.0"
                    getKneeheightLabel.textColor = UIColor.blue
                    getKneeheightLabel.textAlignment = .center
                    getKneeheightLabel.font = getKneeheightLabel.font.withSize(15)
                    getKneeheightLabel.tag = ((11 * 1) + 200)
                    subView.addSubview(getKneeheightLabel)
                }
                else if index == 2
                {
                    let shoulderLabel = UILabel()
                    shoulderLabel.frame = CGRect(x: (13.6 * x), y: (7 * y), width: subView.frame.width - (19.6 * x), height: (2 * y))
                    shoulderLabel.text = "Shoulder"
                    shoulderLabel.textColor = UIColor.black
                    shoulderLabel.textAlignment = .center
                    shoulderLabel.font = shoulderLabel.font.withSize(15)
                    shoulderLabel.tag = ((12 * 1) + 300)
                    subView.addSubview(shoulderLabel)
                    
                    let shoulderButton = UIButton()
                    shoulderButton.frame = CGRect(x: (13.6 * x), y: (7.5 * y), width: subView.frame.width - (19.6 * x), height: (3 * y))
                    shoulderButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    shoulderButton.tag = 12
                    shoulderButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(shoulderButton)
                    
                    getShoulderLabel.frame = CGRect(x: shoulderButton.frame.maxX, y: (7.5 * y), width: (5 * x), height: (3 * y))
                    getShoulderLabel.text = "0.0"
                    getShoulderLabel.textColor = UIColor.blue
                    getShoulderLabel.textAlignment = .center
                    getShoulderLabel.font = getShoulderLabel.font.withSize(15)
                    getShoulderLabel.tag = ((12 * 1) + 200)
                    subView.addSubview(getShoulderLabel)
                    
                    let sleeveLabel = UILabel()
                    sleeveLabel.frame = CGRect(x: (14.5 * x), y: (11 * y), width: subView.frame.width - (20.5 * x), height: (2 * y))
                    sleeveLabel.text = "Half Sleeve"
                    sleeveLabel.textColor = UIColor.black
                    sleeveLabel.textAlignment = .center
                    sleeveLabel.font = sleeveLabel.font.withSize(15)
                    sleeveLabel.tag = ((13 * 1) + 300)
                    subView.addSubview(sleeveLabel)
                    
                    let sleeveButton = UIButton()
                    sleeveButton.frame = CGRect(x: (14.5 * x), y: (11.5 * y), width: subView.frame.width - (20.5 * x), height: (3 * y))
                    sleeveButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    sleeveButton.tag = 13
                    sleeveButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(sleeveButton)
                    
                    getSleeveLabel.frame = CGRect(x: sleeveButton.frame.maxX, y: (11.5 * y), width: (5 * x), height: (3 * y))
                    getSleeveLabel.text = "0.0"
                    getSleeveLabel.textColor = UIColor.blue
                    getSleeveLabel.textAlignment = .center
                    getSleeveLabel.font = getSleeveLabel.font.withSize(15)
                    getSleeveLabel.tag = ((13 * 1) + 200)
                    subView.addSubview(getSleeveLabel)
                    
                    let bicepLabel = UILabel()
                    bicepLabel.frame = CGRect(x: (15.7 * x), y: (14.1 * y), width: subView.frame.width - (21.7 * x), height: (2 * y))
                    bicepLabel.text = "Bicep"
                    bicepLabel.textColor = UIColor.black
                    bicepLabel.textAlignment = .center
                    bicepLabel.font = bicepLabel.font.withSize(15)
                    bicepLabel.tag = ((14 * 1) + 300)
                    subView.addSubview(bicepLabel)
                    
                    let bicepButton = UIButton()
                    bicepButton.frame = CGRect(x: (15.7 * x), y: (14.6 * y), width: subView.frame.width - (21.7 * x), height: (3 * y))
                    bicepButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    bicepButton.tag = 14
                    bicepButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(bicepButton)
                    
                    getBicepLabel.frame = CGRect(x: bicepButton.frame.maxX, y: (14.6 * y), width: (5 * x), height: (3 * y))
                    getBicepLabel.text = "0.0"
                    getBicepLabel.textColor = UIColor.blue
                    getBicepLabel.textAlignment = .center
                    getBicepLabel.font = getBicepLabel.font.withSize(15)
                    getBicepLabel.tag = ((14 * 1) + 200)
                    subView.addSubview(getBicepLabel)
                    
                    let hipLabel = UILabel()
                    hipLabel.frame = CGRect(x: (12.4 * x), y: (16.8 * y), width: subView.frame.width - (18.4 * x), height: (2 * y))
                    hipLabel.text = "Hip"
                    hipLabel.textColor = UIColor.black
                    hipLabel.textAlignment = .center
                    hipLabel.font = hipLabel.font.withSize(15)
                    hipLabel.tag = ((15 * 1) + 300)
                    subView.addSubview(hipLabel)
                    
                    let hipButton = UIButton()
                    hipButton.frame = CGRect(x: (12.4 * x), y: (17.3 * y), width: subView.frame.width - (18.4 * x), height: (3 * y))
                    hipButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    hipButton.tag = 15
                    hipButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(hipButton)
                    
                    getHipLabel.frame = CGRect(x: hipButton.frame.maxX, y: (17.3 * y), width: (5 * x), height: (3 * y))
                    getHipLabel.text = "0.0"
                    getHipLabel.textColor = UIColor.blue
                    getHipLabel.textAlignment = .center
                    getHipLabel.font = getHipLabel.font.withSize(15)
                    getHipLabel.tag = ((15 * 1) + 200)
                    subView.addSubview(getHipLabel)
                    
                    let backLabel = UILabel()
                    backLabel.frame = CGRect(x: (12.9 * x), y: (20.5 * y), width: subView.frame.width - (18.9 * x), height: (2 * y))
                    backLabel.text = "Back"
                    backLabel.textColor = UIColor.black
                    backLabel.textAlignment = .center
                    backLabel.font = backLabel.font.withSize(15)
                    backLabel.tag = ((16 * 1) + 300)
                    subView.addSubview(backLabel)
                    
                    let backButton = UIButton()
                    backButton.frame = CGRect(x: (12.9 * x), y: (21 * y), width: subView.frame.width - (18.9 * x), height: (3 * y))
                    backButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    backButton.tag = 16
                    backButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(backButton)
                    
                    getBackLabel.frame = CGRect(x: backButton.frame.maxX, y: (21 * y), width: (5 * x), height: (3 * y))
                    getBackLabel.text = "0.0"
                    getBackLabel.textColor = UIColor.blue
                    getBackLabel.textAlignment = .center
                    getBackLabel.font = getBackLabel.font.withSize(15)
                    getBackLabel.tag = ((16 * 1) + 200)
                    subView.addSubview(getBackLabel)
                }
                else if index == 3
                {
                    let heightLabel = UILabel()
                    heightLabel.frame = CGRect(x: (9.6 * x), y: (10.6 * y), width: subView.frame.width - (15.6 * x), height: (2 * y))
                    heightLabel.text = "Height"
                    heightLabel.textColor = UIColor.black
                    heightLabel.textAlignment = .center
                    heightLabel.font = heightLabel.font.withSize(15)
                    heightLabel.tag = ((17 * 1) + 300)
                    subView.addSubview(heightLabel)
                    
                    let heightButton = UIButton()
                    heightButton.frame = CGRect(x: (9.6 * x), y: (11.1 * y), width: subView.frame.width - (15.6 * x), height: (3 * y))
                    heightButton.setImage(UIImage(named: "lengthArrowMark"), for: .normal)
                    heightButton.tag = 17
                    heightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(heightButton)
                    
                    getHeightLabel.frame = CGRect(x: heightButton.frame.maxX, y: (11.1 * y), width: (5 * x), height: (3 * y))
                    getHeightLabel.text = "0.0"
                    getHeightLabel.textColor = UIColor.blue
                    getHeightLabel.textAlignment = .center
                    getHeightLabel.font = getHeightLabel.font.withSize(15)
                    getHeightLabel.tag = ((17 * 1) + 200)
                    subView.addSubview(getHeightLabel)
                    
                    let fullSleeveLabel = UILabel()
                    fullSleeveLabel.frame = CGRect(x: (14.6 * x), y: (15.1 * y), width: subView.frame.width - (20.6 * x), height: (2 * y))
                    fullSleeveLabel.text = "Sleeve Height"
                    fullSleeveLabel.textColor = UIColor.black
                    fullSleeveLabel.textAlignment = .center
                    fullSleeveLabel.font = heightLabel.font.withSize(15)
                    fullSleeveLabel.tag = ((18 * 1) + 300)
                    subView.addSubview(fullSleeveLabel)
                    
                    let fullSleeveButton = UIButton()
                    fullSleeveButton.frame = CGRect(x: (14.6 * x), y: (15.6 * y), width: subView.frame.width - (20.6 * x), height: (3 * y))
                    fullSleeveButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    fullSleeveButton.tag = 18
                    fullSleeveButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(fullSleeveButton)
                    
                    getFullSleeveLabel.frame = CGRect(x: fullSleeveButton.frame.maxX, y: (15.6 * y), width: (5 * x), height: (3 * y))
                    getFullSleeveLabel.text = "0.0"
                    getFullSleeveLabel.textColor = UIColor.blue
                    getFullSleeveLabel.textAlignment = .center
                    getFullSleeveLabel.font = getFullSleeveLabel.font.withSize(15)
                    getFullSleeveLabel.tag = ((18 * 1) + 200)
                    subView.addSubview(getFullSleeveLabel)
                    
                    let handKneeLabel = UILabel()
                    handKneeLabel.frame = CGRect(x: (15.5 * x), y: (19.9 * y), width: subView.frame.width - (21.5 * x), height: (2 * y))
                    handKneeLabel.text = "Hand Cuf"
                    handKneeLabel.textColor = UIColor.black
                    handKneeLabel.textAlignment = .center
                    handKneeLabel.font = handKneeLabel.font.withSize(15)
                    handKneeLabel.tag = ((19 * 1) + 300)
                    subView.addSubview(handKneeLabel)
                    
                    let handKneeButton = UIButton()
                    handKneeButton.frame = CGRect(x: (15.5 * x), y: (20.3 * y), width: subView.frame.width - (21.5 * x), height: (3 * y))
                    handKneeButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    handKneeButton.tag = 19
                    handKneeButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(handKneeButton)
                    
                    getHandKneeLabel.frame = CGRect(x: handKneeButton.frame.maxX, y: (20.3 * y), width: (5 * x), height: (3 * y))
                    getHandKneeLabel.text = "0.0"
                    getHandKneeLabel.textColor = UIColor.blue
                    getHandKneeLabel.textAlignment = .center
                    getHandKneeLabel.font = getHandKneeLabel.font.withSize(15)
                    getHandKneeLabel.tag = ((19 * 1) + 200)
                    subView.addSubview(getHandKneeLabel)
                }
                
                /*for view in subView.subviews
                 {
                 for i in 0..<PartsIdArray.count
                 {
                 if let button = view.viewWithTag(PartsIdArray[i] as! Int) as? UIButton
                 {
                 button.backgroundColor = UIColor.green
                 }
                 else
                 {
                 
                 }
                 }
                 }*/
            }
            /*else
             {
             if index == 0
             {
             let headButton = UIButton()
             headButton.frame = CGRect(x: (10.8 * x), y: (1.3 * y), width: (10 * x), height: (3 * y))
             headButton.setImage(UIImage(named: "arrowMark"), for: .normal)
             subView.addSubview(headButton)
             
             let neckButton = UIButton()
             neckButton.frame = CGRect(x: (11.9 * x), y: (7.1 * y), width: (10 * x), height: (3 * y))
             neckButton.setImage(UIImage(named: "arrowMark"), for: .normal)
             neckButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
             subView.addSubview(neckButton)
             
             let chestButton = UIButton()
             chestButton.frame = CGRect(x: (13.4 * x), y: (12.2 * y), width: (10 * x), height: (3 * y))
             chestButton.setImage(UIImage(named: "arrowMark"), for: .normal)
             subView.addSubview(chestButton)
             
             let waistButton = UIButton()
             waistButton.frame = CGRect(x: (12.5 * x), y: (15.6 * y), width: (10 * x), height: (3 * y))
             waistButton.setImage(UIImage(named: "arrowMark"), for: .normal)
             subView.addSubview(waistButton)
             
             let hipButton = UIButton()
             hipButton.frame = CGRect(x: (12.6 * x), y: (18.8 * y), width: (10 * x), height: (3 * y))
             hipButton.setImage(UIImage(named: "arrowMark"), for: .normal)
             subView.addSubview(hipButton)
             
             let handKneeButton = UIButton()
             handKneeButton.frame = CGRect(x: (15.7 * x), y: (21.5 * y), width: (8 * x), height: (3 * y))
             handKneeButton.setImage(UIImage(named: "arrowMark"), for: .normal)
             subView.addSubview(handKneeButton)
             
             let thighButton = UIButton()
             thighButton.frame = CGRect(x: (13 * x), y: (27.8 * y), width: (10 * x), height: (3 * y))
             thighButton.setImage(UIImage(named: "arrowMark"), for: .normal)
             subView.addSubview(thighButton)
             
             let bounceButton = UIButton()
             bounceButton.frame = CGRect(x: (11.8 * x), y: (33 * y), width: (10 * x), height: (3 * y))
             bounceButton.setImage(UIImage(named: "arrowMark"), for: .normal)
             subView.addSubview(bounceButton)
             
             let kneeButton = UIButton()
             kneeButton.frame = CGRect(x: (11.2 * x), y: (42.9 * y), width: (10 * x), height: (3 * y))
             kneeButton.setImage(UIImage(named: "arrowMark"), for: .normal)
             subView.addSubview(kneeButton)
             }
             else if index == 1
             {
             let overAllHeightButton = UIButton()
             overAllHeightButton.frame = CGRect(x: 0, y: (15 * y), width: (25 * x), height: (3 * y))
             overAllHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
             subView.addSubview(overAllHeightButton)
             
             print("33333", overAllHeightButton.frame.minX)
             
             let hipHeightButton = UIButton()
             hipHeightButton.frame = CGRect(x: (4.3 * x), y: (40 * y), width: (17 * x), height: (3 * y))
             hipHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
             subView.addSubview(hipHeightButton)
             
             let bottomHeightButton = UIButton()
             bottomHeightButton.frame = CGRect(x: (8.2 * x), y: (35 * y), width: (14 * x), height: (3 * y))
             bottomHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
             subView.addSubview(bottomHeightButton)
             
             let kneeHeightButton = UIButton()
             kneeHeightButton.frame = CGRect(x: (11.6 * x), y: (27.8 * y), width: (10 * x), height: (3 * y))
             kneeHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
             subView.addSubview(kneeHeightButton)
             }
             else if index == 2
             {
             let shoulderButton = UIButton()
             shoulderButton.frame = CGRect(x: (13.6 * x), y: (8 * y), width: (10 * x), height: (3 * y))
             shoulderButton.setImage(UIImage(named: "arrowMark"), for: .normal)
             subView.addSubview(shoulderButton)
             
             let bicepButton = UIButton()
             bicepButton.frame = CGRect(x: (15.2 * x), y: (13.3 * y), width: (10 * x), height: (3 * y))
             bicepButton.setImage(UIImage(named: "arrowMark"), for: .normal)
             subView.addSubview(bicepButton)
             
             let backButton = UIButton()
             backButton.frame = CGRect(x: (12.9 * x), y: (22.3 * y), width: (10 * x), height: (3 * y))
             backButton.setImage(UIImage(named: "arrowMark"), for: .normal)
             subView.addSubview(backButton)
             }
             else if index == 3
             {
             let heightButton = UIButton()
             heightButton.frame = CGRect(x: (9.6 * x), y: (12.1 * y), width: (10 * x), height: (3 * y))
             heightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
             subView.addSubview(heightButton)
             
             let fullSleeveButton = UIButton()
             fullSleeveButton.frame = CGRect(x: (14.6 * x), y: (15.6 * y), width: (10 * x), height: (3 * y))
             fullSleeveButton.setImage(UIImage(named: "arrowMark"), for: .normal)
             subView.addSubview(fullSleeveButton)
             }
             }*/
            
            for views in subView.subviews
            {
                if let button = views as? UIButton
                {
                    buttonTag = button.tag
                    if PartsIdArray.contains(button.tag)
                    {
                        button.isEnabled = true
                    }
                    else
                    {
                        button.isEnabled = false
                        button.isHidden = true
                        
                        //                        let origImage = UIImage(named: "arrowMark");
                        //                        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                        //                        button.setImage(tintedImage, for: .normal)
                        //                        button.tintColor = UIColor.white
                    }
                }
                
                if let label = views as? UILabel
                {
                    if PartsIdArray.contains(buttonTag)
                    {
                        if label.tag == ((buttonTag * 1) + 200)
                        {
                            let value = measurementValues[buttonTag]
                            label.text = "\(value!)"
                        }
                    }
                    else
                    {
                        if label.tag == ((buttonTag * 1) + 200)
                        {
                            label.removeFromSuperview()
                            
                            if let foundView = view.viewWithTag(label.tag + 100) {
                                foundView.removeFromSuperview()
                            }
                        }
                        else
                        {
                            
                        }
                    }
                }
                
                /*if let labels = views as? UILabel
                 {
                 print("WELCOME NAYASA", labels.text)
                 if PartsIdArray.contains(buttonTag)
                 {
                 
                 }
                 else
                 {
                 if labels.tag == ((buttonTag * 1) + 300)
                 {
                 labels.isHidden = true
                 }
                 else
                 {
                 
                 }
                 }
                 }*/
            }
            
        }
        
        let page = imageScrollView.contentOffset.x / imageScrollView.frame.size.width;
        print("PAGE NUMBER AND", page, PartsIdArray.count)
        
        
        imageScrollView.contentSize = CGSize(width: imageScrollView.frame.size.width * 4,height: imageScrollView.frame.size.height)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
        self.stopActivity()
    }
    
    @objc func unitButtonAction(sender : UIButton)
    {
        if sender.tag == 1
        {
            unitTag = "cm"
            inButton.backgroundColor = UIColor.clear
            inButton.layer.borderWidth = 0
            inButton.layer.cornerRadius = 0
            inButton.isEnabled = true
            
            for (keys, values) in measurementValues
            {
                let inchValue = values * 2.54
                print("ROUNDED VALUE OF IN", inchValue.rounded())
                measurementValues[keys] = inchValue.rounded()
            }
            
            UserDefaults.standard.set("CM", forKey: "units")
        }
        else
        {
            unitTag = "in"
            cmButton.backgroundColor = UIColor.clear
            cmButton.layer.borderWidth = 0
            cmButton.layer.cornerRadius = 0
            cmButton.isEnabled = true
            
            for (keys, values) in measurementValues
            {
                let cmValue = values / 2.54
                print("ROUNDED VALUE OF CM", cmValue)
                measurementValues[keys] = cmValue
            }
            
            UserDefaults.standard.set("IN", forKey: "units")
        }
        
        sender.layer.borderWidth = 1
        sender.layer.cornerRadius = sender.frame.height / 2
        sender.backgroundColor = UIColor.orange
        sender.isEnabled = false
        partsTableView.reloadData()
        
        for (keys, values) in measurementValues
        {
            if let foundView = view.viewWithTag((keys * 1) + 200) {
                if let label = foundView as? UILabel
                {
                    label.text = "\(values)"
                }
            }
        }
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = colors.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
        self.view.addSubview(pageControl)
        
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * imageScrollView.frame.size.width
        imageScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumbers = round(imageScrollView .contentOffset.x / imageScrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumbers)
        
        print("PAGE NUMBER OF CURRENT", pageNumbers)
        /*for i in 0..<4
         {
         if let theLabel = self.view.viewWithTag((i + 1) * 20) as? UILabel {
         let pageNo = Int(pageNumbers)
         let no = Int(theLabel.text!)! + 1
         print("THE LABEL TEXT", theLabel.text!, pageNo)
         if pageNo == no
         {
         pageNumber = pageNo
         theLabel.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
         }
         else
         {
         theLabel.backgroundColor = UIColor.clear
         }
         }
         }*/
        
        pageNumber = Int(pageNumbers)
        pageNumberContents()
    }
    
    @objc func measurementButtonAction(sender : UIButton)
    {
        let measureScreen = MeasureScrollViewController()
        
        if sender.tag == 1
        {
            measurerImage = "Head"
        }
        else if sender.tag == 2
        {
            measurerImage = "Neck"
        }
        else if sender.tag == 3
        {
            measurerImage = "Chest"
        }
        else if sender.tag == 4
        {
            measurerImage = "Waist"
        }
        else if sender.tag == 5
        {
            measurerImage = "Thigh"
        }
        else if sender.tag == 6
        {
            measurerImage = "Bounce"
        }
        else if sender.tag == 7
        {
            measurerImage = "Knee"
        }
        else if sender.tag == 8
        {
            measurerImage = "Height"
        }
        else if sender.tag == 9
        {
            measurerImage = "Leg Height"
        }
        else if sender.tag == 10
        {
            measurerImage = "3 / 4 Height"
        }
        else if sender.tag == 11
        {
            measurerImage = "Short Height"
        }
        else if sender.tag == 12
        {
            measurerImage = "Shoulder"
        }
        else if sender.tag == 13
        {
            measurerImage = "Half Sleeve"
        }
        else if sender.tag == 14
        {
            measurerImage = "Bicep"
        }
        else if sender.tag == 15
        {
            measurerImage = "Hip"
        }
        else if sender.tag == 16
        {
            measurerImage = "Back"
        }
        else if sender.tag == 17
        {
            measurerImage = "Shirt Height"
        }
        else if sender.tag == 18
        {
            measurerImage = "Sleeve Height"
        }
        else if sender.tag == 19
        {
            measurerImage = "Hand Cuf"
        }
        
        measurerTag = sender.tag
        
        type = "button"
        
        serviceCall.API_GetMeasurementParts(MeasurementParts: sender.tag, delegate: self)
    }
    
    func API_CALLBACK_GetMeasurementParts(getParts: NSDictionary)
    {
        let ResponseMsg = getParts.object(forKey: "ResponseMsg") as! String
        
        let emptyArray = NSArray()
        
        selectedPartsIdArray = emptyArray
        selectedPartsImagesArray = emptyArray
        selectedconvertedPartsImageArray.removeAll()
        
        if ResponseMsg == "Success"
        {
            let Result = getParts.object(forKey: "Result") as! NSArray
            print("Result OF MEASUREMENT-2", Result)
            
            // Body Parts :
            selectedPartsIdArray = Result.value(forKey: "Id") as! NSArray
            selectedPartsImagesArray = Result.value(forKey: "Image") as! NSArray
            
            for i in 0..<selectedPartsImagesArray.count
            {
                if let imageName = selectedPartsImagesArray[i] as? String
                {
                    let urlString = serviceCall.baseURL
                    let api = "\(urlString)/images/Measurement2/\(imageName)"
                    let apiurl = URL(string: api)
                    print("PArts : ", api)
                    
                    if apiurl != nil
                    {
                        if let data = try? Data(contentsOf: apiurl!)
                        {
                            print("DATA OF IMAGE", data)
                            if let image = UIImage(data: data)
                            {
                                self.selectedconvertedPartsImageArray.append(image)
                            }
                        }
                        else
                        {
                            let emptyImage = UIImage(named: "empty")
                            self.selectedconvertedPartsImageArray.append(emptyImage!)
                        }
                    }
                }
                else if selectedPartsImagesArray[i] is NSNull
                {
                    let emptyImage = UIImage(named: "empty")
                    self.selectedconvertedPartsImageArray.append(emptyImage!)
                }
            }
            
            if type == "table"
            {
                partsContent()
            }
            else
            {
                self.measureScrollContents()
            }
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = getParts.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetMeasurementParts"
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func measureScrollContents()
    {
        imageBackView.frame = CGRect(x: 0, y: (6.4 * y), width: view.frame.width, height: view.frame.height - (11.4 * y))
        imageBackView.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.addSubview(imageBackView)
        
        for views in imageBackView.subviews
        {
            views.removeFromSuperview()
        }
        
        rulerContents()
        
        partsImageView.frame = CGRect(x: rulerScroll.frame.maxX + (2 * y), y: (10 * y), width: (20 * x), height: (20 * y))
        partsImageView.backgroundColor = UIColor.white
        partsImageView.image = selectedconvertedPartsImageArray[0]
        imageBackView.addSubview(partsImageView)
        
        let partsNameLabel = UILabel()
        partsNameLabel.frame = CGRect(x: partsImageView.frame.minX + ((partsImageView.frame.width - (10 * x)) / 2), y: partsImageView.frame.maxY + y, width: (10 * x), height: (3 * y))
        partsNameLabel.text = measurerImage
        partsNameLabel.textColor = UIColor.white
        partsNameLabel.textAlignment = .center
        imageBackView.addSubview(partsNameLabel)
        
        partsMeasurementLabel.frame = CGRect(x: partsImageView.frame.minX + ((partsImageView.frame.width - (10 * x)) / 2), y: partsNameLabel.frame.maxY + y, width: (10 * x), height: (3 * y))
        partsMeasurementLabel.layer.cornerRadius = 10
        partsMeasurementLabel.layer.masksToBounds = true
        partsMeasurementLabel.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        partsMeasurementLabel.text = "0.0"
        partsMeasurementLabel.textColor = UIColor.white
        partsMeasurementLabel.textAlignment = .center
        imageBackView.addSubview(partsMeasurementLabel)
        
        let cancelButton = UIButton()
        cancelButton.frame = CGRect(x: rulerScroll.frame.maxX + x, y: partsMeasurementLabel.frame.maxY + (8 * y), width: (10 * x), height: (3 * y))
        cancelButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.addTarget(self, action: #selector(self.measureScrollCancelButtonAction(sender:)), for: .touchUpInside)
        cancelButton.tag = 3
        imageBackView.addSubview(cancelButton)
        
        let saveButton = UIButton()
        saveButton.frame = CGRect(x: cancelButton.frame.maxX + (2 * y), y: partsMeasurementLabel.frame.maxY + (8 * y), width: (10 * x), height: (3 * y))
        saveButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        saveButton.setTitle("SAVE", for: .normal)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.addTarget(self, action: #selector(self.saveButtonAction(sender:)), for: .touchUpInside)
        saveButton.tag = 3
        imageBackView.addSubview(saveButton)
    }
    
    @objc func measureScrollCancelButtonAction(sender : UIButton)
    {
        imageBackView.removeFromSuperview()
    }
    
    @objc func saveButtonAction(sender : UIButton)
    {
        imageBackView.removeFromSuperview()
        
        if let foundView = view.viewWithTag((measurerTag * 1) + 200) {
            if let label = foundView as? UILabel
            {
                label.text = partsMeasurementLabel.text
                //                measurementValues[measurerTag] = Int(partsMeasurementLabel.text!)
                let convertToInt:Float? = Float(label.text!)
                print("TEXT", convertToInt!)
                measurementValues.updateValue(convertToInt!, forKey: measurerTag)
            }
        }
        
        print("MEAUREMENT KEY AND VALUES", measurementValues)
    }
    
    func rulerContents()
    {
        rulerScroll.frame = CGRect(x: (2 * x), y: (3 * y), width: (9 * x), height: imageBackView.frame.height - (6 * y))
        rulerScroll.delegate = self
        rulerScroll.scrollsToTop = true
        rulerScroll.alwaysBounceVertical = true
        imageBackView.addSubview(rulerScroll)
        
        var y1:CGFloat = (30.4 * y)
        var y2:CGFloat = (29.4 * y)
        
        for views in rulerScroll.subviews
        {
            views.removeFromSuperview()
        }
        
        let scrollPoint = CGPoint(x: 0.0, y: 0.0)
        

        rulerScroll.scrollsToTop = true
        rulerScroll.setContentOffset(scrollPoint, animated: true)
        
        for i in 0..<1029
        {
            let measureLabel = UILabel()
            
            if (i % 10) == 0
            {
                measureLabel.frame = CGRect(x: 0, y: y1, width: (6 * x), height: (0.2 * y))
            }
            else if (i % 5) == 0
            {
                measureLabel.frame = CGRect(x: 0, y: y1, width: (4 * x), height: (0.2 * y))
            }
            else
            {
                measureLabel.frame = CGRect(x: 0, y: y1, width: (2 * x), height: (0.2 * y))
            }
            measureLabel.backgroundColor = UIColor.white
            
            if i < 1001
            {
                rulerScroll.addSubview(measureLabel)
            }
            
            let measureSizeLabel = UILabel()
            if(i % 10) == 0
            {
                y2 = measureLabel.frame.minY - y
                
                measureSizeLabel.frame = CGRect(x: measureLabel.frame.maxX + 5, y: y2, width: (3.5 * x), height: (2 * y))
                measureSizeLabel.text = "\(i / 10)"
            }
            else if (i % 5) == 0
            {
                y2 = measureLabel.frame.minY - y
                
                measureSizeLabel.frame = CGRect(x: measureLabel.frame.maxX + 5, y: y2, width: (4 * x), height: (2 * y))
                
                let halfValue = (i / 10)
                measureSizeLabel.text = "\(halfValue).5"
            }
            
            measureSizeLabel.textColor = UIColor.white
            measureSizeLabel.textAlignment = .left
            
            if i < 1001
            {
                rulerScroll.addSubview(measureSizeLabel)
            }
            
            y1 = measureLabel.frame.maxY + y
        }
        
        rulerScroll.contentSize.height = y1 - (16.5 * y)
        
        let selectedMeasureImage = UIImageView()
        selectedMeasureImage.frame = CGRect(x: 0, y: ((view.frame.height - (4 * y)) / 2), width: (4 * x), height: (4 * y))
        selectedMeasureImage.image = UIImage(named: "arrowPointer")
        imageBackView.addSubview(selectedMeasureImage)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let value = Double(scrollView.contentOffset.y / (12 * y))
        let doubleStr = String(format: "%.1f", value)
        
        partsMeasurementLabel.text = doubleStr
    }
    
    func popBackValue(value : String, viewTag : Int)
    {
        if viewTag == 1
        {
            getHeadLabel.text = value
        }
        else if viewTag == 2
        {
            getNeckLabel.text = value
        }
        else if viewTag == 3
        {
            getChestLabel.text = value
        }
        else if viewTag == 4
        {
            getWaistLabel.text = value
        }
        else if viewTag == 5
        {
            getThighLabel.text = value
        }
        else if viewTag == 6
        {
            getKneeLabel.text = value
        }
        else if viewTag == 7
        {
            getAnkleLabel.text = value
        }
        else if viewTag == 8
        {
            
        }
        else if viewTag == 9
        {
            
        }
        else if viewTag == 10
        {
            
        }
        else if viewTag == 11
        {
            
        }
        else if viewTag == 12
        {
            
        }
        else if viewTag == 13
        {
            
        }
        else if viewTag == 14
        {
            
        }
        else if viewTag == 15
        {
            
        }
        else if viewTag == 16
        {
            
        }
        else if viewTag == 17
        {
            
        }
        else if viewTag == 18
        {
            
        }
        else if viewTag == 19
        {
            
        }
    }
    
    @objc func nextButtonAction(sender : UIButton)
    {
        var values = [Float]()
        
        for (keys, valuess) in measurementValues
        {
            print("KEYS & VALUES", keys, valuess)
            values.append(valuess)
        }
        
        print("VALUES", values)
        
        if values.contains(0.0)
        {
            let customEmptyAlert = UIAlertController(title: "Alert", message: "Please enter all values to proceed", preferredStyle: .alert)
            customEmptyAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(customEmptyAlert, animated: true, completion: nil)
        }
        else
        {
            UserDefaults.standard.set(PartsIdArray, forKey: "measurementId")
            UserDefaults.standard.set(values, forKey: "measurementValues")
            
            let referenceScreen = ReferenceImageViewController()
            self.navigationController?.pushViewController(referenceScreen, animated: true)
        }
        
    }
    
    
    func partsViewContents(isHidden : Bool)
    {
        partsView.frame = CGRect(x: (4 * x), y: imageButton.frame.maxY + y, width: view.frame.width - (8 * x), height: (44 * y))
        partsView.backgroundColor = UIColor.clear
        view.addSubview(partsView)
        
        partsView.isHidden = isHidden
        
        partsTableView.frame = CGRect(x: 0, y: 0, width: partsView.frame.width, height: (6 * y * CGFloat(PartsNameArray.count)))
        partsTableView.backgroundColor = UIColor.clear
        partsTableView.register(PartsTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(PartsTableViewCell.self))
        partsTableView.dataSource = self
        partsTableView.delegate = self
        if PartsNameArray.count > 7
        {
            partsTableView.bounces = true
        }
        else
        {
            partsTableView.bounces = false
        }
        partsView.addSubview(partsTableView)
        
        partsTableView.reloadData()
    }
    
    func partsContent()
    {
        partsBackView.frame = CGRect(x: 0, y: (6.4 * y), width: view.frame.width, height: view.frame.height - (11.4 * y))
        partsBackView.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.addSubview(partsBackView)
        
        selectedPartsImageView.frame = CGRect(x: (2 * x), y: y, width: view.frame.width - (4 * x), height: (36.98 * y))
        selectedPartsImageView.image = selectedconvertedPartsImageArray[0]
        partsBackView.addSubview(selectedPartsImageView)
        
        print("WIDTH", selectedPartsImageView.frame.width)
        
        /*let cmLabel = UILabel()
         cmLabel.frame = CGRect(x: ((view.frame.width - (13 * x)) / 2), y: downArrowImageView.frame.maxY + y, width: (3 * x), height: (2 * y))
         cmLabel.text = "CM"
         cmLabel.textColor = UIColor.white
         cmLabel.textAlignment = .center
         partsBackView.addSubview(cmLabel)
         
         let addressSwitchButton = UISwitch()
         addressSwitchButton.frame = CGRect(x: cmLabel.frame.maxX + (x / 2), y: downArrowImageView.frame.maxY + y, width: (5 * x), height: (2 * y))
         partsBackView.addSubview(addressSwitchButton)
         
         let inchLabel = UILabel()
         inchLabel.frame = CGRect(x: addressSwitchButton.frame.maxX + (x / 2), y: downArrowImageView.frame.maxY + y, width: (5 * x), height: (2 * y))
         inchLabel.text = "Inches"
         inchLabel.textColor = UIColor.white
         inchLabel.textAlignment = .center
         partsBackView.addSubview(inchLabel)*/
        
        partsInputTextField.frame = CGRect(x: ((view.frame.width - (10 * x)) / 2), y: selectedPartsImageView.frame.maxY + (2 * y), width: (10 * x), height: (4 * y))
        partsInputTextField.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        partsInputTextField.placeholder = "0.0"
        partsInputTextField.text = "0.0"
        partsInputTextField.textColor = UIColor.white
        partsInputTextField.textAlignment = .center
        partsInputTextField.font = UIFont(name: "Avenir-Heavy", size: 18)
        partsInputTextField.leftViewMode = UITextField.ViewMode.always
        partsInputTextField.adjustsFontSizeToFitWidth = true
        partsInputTextField.keyboardType = .decimalPad
        partsInputTextField.clearsOnBeginEditing = true
        partsInputTextField.returnKeyType = .done
        partsInputTextField.delegate = self
        partsBackView.addSubview(partsInputTextField)
        
        let cancelButton = UIButton()
        cancelButton.frame = CGRect(x: x, y: partsInputTextField.frame.maxY + (3 * y), width: ((view.frame.width / 2) - (2 * x)), height: (4 * y))
        cancelButton.backgroundColor = UIColor(red: 0.2353, green: 0.4, blue: 0.4471, alpha: 1.0)
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.addTarget(self, action: #selector(self.partsCancelButtonAction(sender:)), for: .touchUpInside)
        partsBackView.addSubview(cancelButton)
        
        let saveButton = UIButton()
        saveButton.frame = CGRect(x: cancelButton.frame.maxX + (2 * x), y: partsInputTextField.frame.maxY + (3 * y), width: ((view.frame.width / 2) - (2 * x)), height: (4 * y))
        saveButton.backgroundColor = UIColor(red: 0.2353, green: 0.4, blue: 0.4471, alpha: 1.0)
        saveButton.setTitle("SAVE", for: .normal)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.addTarget(self, action: #selector(self.partsSaveButtonAction(sender:)), for: .touchUpInside)
        partsBackView.addSubview(saveButton)
    }
    
    @objc func partsCancelButtonAction(sender : UIButton)
    {
        partsBackView.removeFromSuperview()
    }
    
    @objc func partsSaveButtonAction(sender : UIButton)
    {
        
        let convertToInt:Float? = Float(partsInputTextField.text!)
        print("TEXT", convertToInt!, measurerTag)
        measurementValues.updateValue(convertToInt!, forKey: measurerTag)
        print("partsSaveButtonAction", measurementValues)
        partsBackView.removeFromSuperview()
        
        partsTableView.reloadData()
    }
    
    /*func numberOfSections(in tableView: UITableView) -> Int {
     return 26
     }
     
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     let headerView = UIView()
     headerView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
     
     let alphabetsLabel = UILabel()
     alphabetsLabel.frame = CGRect(x: x, y: 2, width: x, height: y)
     alphabetsLabel.text = alphabets[section]
     alphabetsLabel.textColor = UIColor.white
     alphabetsLabel.textAlignment = .center
     headerView.addSubview(alphabetsLabel)
     
     return headerView
     }
     
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 20
     }
     
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
     return 10
     }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PartsNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(PartsTableViewCell.self), for: indexPath as IndexPath) as! PartsTableViewCell
        
        cell.backgroundColor = UIColor.clear
        
        cell.contentSpace.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: (5 * y))
        
        cell.partsImage.frame = CGRect(x: x, y: y, width: (3 * x), height: (3 * y))
        
        cell.partsName.frame = CGRect(x: cell.partsImage.frame.maxX + x, y: y, width: cell.frame.width - (13.5 * x), height: (3 * y))
        
        cell.partsSizeLabel.frame = CGRect(x: cell.partsName.frame.maxX + x, y: y, width: (6 * x), height: (3 * y))
        
        cell.spaceView.frame = CGRect(x: 0, y: cell.frame.height - y, width: cell.frame.width, height: y)
        
        cell.partsImage.image = convertedPartsImageArray[indexPath.row]
        cell.partsName.text = PartsNameArray[indexPath.row] as? String
        
        let valueCount = indexPath.row + 1
        let value = measurementValues[valueCount]
        print("qwertyuiop", measurementValues[valueCount]!)
        
        cell.partsSizeLabel.text = "\(value!)"

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return (6 * y)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedInt = PartsIdArray[indexPath.row] as! Int
        
        print("SELECTED INT", selectedInt)
        
        type = "table"
        
        measurerTag = selectedInt
        
        self.serviceCall.API_GetMeasurementParts(MeasurementParts: selectedInt, delegate: self)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("SELECTED ROW", row + 1)
        partsMeasurementLabel.text = "\(row + 1)"
        //        UserDefaults.standard.set(row + 1, forKey: "Measure-\(headingTitle)")
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
        
        self.partsInputTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        var boolVar = Bool()
        
        if textField == partsInputTextField
        {
            if let textString = partsInputTextField.text
            {
                if textString.contains(".")
                {
                    let maxLength = 6
                    let currentString: NSString = partsInputTextField.text! as NSString
                    let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
                    boolVar = newString.length <= maxLength
                }
                else
                {
                    let maxLength = 4
                    let currentString: NSString = partsInputTextField.text! as NSString
                    let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
                    boolVar = newString.length <= maxLength
                }
            }
        }
        
        return boolVar
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
