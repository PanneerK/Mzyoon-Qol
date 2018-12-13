//
//  Measurement2ViewController.swift
//  Mzyoon
//
//  Created by QOL on 27/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class Measurement2ViewController: CommonViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, ServerAPIDelegate
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
    let getBounceLabel = UILabel()
    let getKneeLabel = UILabel()
    
    // Parts...
    var PartsIdArray = NSArray()
    var PartsGenderMeasurementIdArray = NSArray()
    var PartsNameArray = NSArray()
    var PartsImagesArray = NSArray()
    var PartsReferenceNumberArray = NSArray()
    var convertedPartsImageArray = [UIImage]()
    
    let partsTableView = UITableView()
    
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
        self.tab1Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        
        self.serviceCall.API_GetMeasurement2(Measurement2Value: 1, delegate: self)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of seconds
//            // Your code with delay
//            self.measurement2Contents()
//        }        
        
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
    
    func API_CALLBACK_GetMeasurement1Value(GetMeasurement1val: NSDictionary)
    {
        let ResponseMsg = GetMeasurement1val.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = GetMeasurement1val.object(forKey: "Result") as! NSDictionary
            print("Result OF MEASUREMENT-2", Result)
            
            // Gender :
            let GenderImages = Result.object(forKey: "Image") as! NSArray
            Measurement2ImgIdArray = GenderImages.value(forKey: "id") as! NSArray
            Measurement2ImagesArray = GenderImages.value(forKey: "Image") as! NSArray
            
            for i in 0..<Measurement2ImagesArray.count
            {
                if let imageName = Measurement2ImagesArray[i] as? String
                {
                    
                    //  let api = "http://192.168.0.21/TailorAPI/images/Measurement2/\(imageName)"
                    
                    let api = "http://appsapi.mzyoon.com/images/Measurement2/\(imageName)"
                    let apiurl = URL(string: api)
                    print("CUSTOM ALL OF", api)
                    
                    if apiurl != nil
                    {
                        if let data = try? Data(contentsOf: apiurl!)
                        {
                            print("DATA OF IMAGE", data)
                            if let image = UIImage(data: data)
                            {
                                self.convertedMeasurement2ImageArray.append(image)
                            }
                        }
                        else
                        {
                            let emptyImage = UIImage(named: "empty")
                            self.convertedMeasurement2ImageArray.append(emptyImage!)
                        }
                    }
                }
                else if Measurement2ImagesArray[i] is NSNull
                {
                    let emptyImage = UIImage(named: "empty")
                    self.convertedMeasurement2ImageArray.append(emptyImage!)
                }
            }
            
            
            // Body Parts :
            
            let MeasurementImages = Result.object(forKey: "Measurements") as! NSArray
            MeasurementsIdArray = MeasurementImages.value(forKey: "Id") as! NSArray
            MeasurementsNameArray = MeasurementImages.value(forKey: "TextInEnglish") as! NSArray
            MeasurementsReferenceNumberArray = MeasurementImages.value(forKey: "ReferenceNumber") as! NSArray
            GenderMeasurementIdArray = MeasurementImages.value(forKey: "GenderMeasurementId") as! NSArray
            MeasurementsImagesArray = MeasurementImages.value(forKey: "Image") as! NSArray
            
            for i in 0..<MeasurementsImagesArray.count
            {
                if let imageName = MeasurementsImagesArray[i] as? String
                {
                    
                    //  let api = "http://192.168.0.21/TailorAPI/images/Measurement2/\(imageName)"
                    let api = "http://appsapi.mzyoon.com/images/Measurement2/\(imageName)"
                    
                    let apiurl = URL(string: api)
                    print("CUSTOM ALL OF", api)
                    
                    if apiurl != nil
                    {
                        if let data = try? Data(contentsOf: apiurl!)
                        {
                            print("DATA OF IMAGE", data)
                            if let image = UIImage(data: data)
                            {
                                self.convertedMeasurementsImageArray.append(image)
                            }
                        }
                        else
                        {
                            let emptyImage = UIImage(named: "empty")
                            self.convertedMeasurementsImageArray.append(emptyImage!)
                        }
                    }
                }
                else if MeasurementsImagesArray[i] is NSNull
                {
                    let emptyImage = UIImage(named: "empty")
                    self.convertedMeasurementsImageArray.append(emptyImage!)
                }
            }
        }
        else if ResponseMsg == "Failure"
        {
            let Result = GetMeasurement1val.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetMeasurement2"
            ErrorStr = Result
            DeviceError()
        }
        
       
    }
    
    func API_CALLBACK_GetMeasurement2Value(GetMeasurement2val: NSDictionary)
    {
        let ResponseMsg = GetMeasurement2val.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = GetMeasurement2val.object(forKey: "Result") as! NSArray
            print("Result OF MEASUREMENT-2", Result)
            
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
                    let api = "http://appsapi.mzyoon.com/images/Measurement2/\(imageName)"
                    // let api = "http://192.168.0.21/TailorAPI/images/Measurement2/\(imageName)"
                    
                    let apiurl = URL(string: api)
                    print("CUSTOM ALL OF", api)
                    
                    if apiurl != nil
                    {
                        if let data = try? Data(contentsOf: apiurl!)
                        {
                            print("DATA OF IMAGE", data)
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
            self.measurement2Contents()
            partsTableView.reloadData()
        }
        else if ResponseMsg == "Failure"
        {
            let Result = GetMeasurement2val.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "DisplayMeasurementBySubTypeId"
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func API_CALLBACK_InsertUserMeasurement(insUsrMeasurementVal: NSDictionary)
    {
        let ResponseMsg = insUsrMeasurementVal.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = insUsrMeasurementVal.object(forKey: "Result") as! Int
            print("Result Value :", Result)
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = insUsrMeasurementVal.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "InsertUserMeasurementValues"
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func measurement2Contents()
    {
        self.stopActivity()
        
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
            partsViewContents(isHidden: true)
        }
        else if sender.tag == 1
        {
            imageButton.backgroundColor = UIColor.lightGray
            imageButton.setTitleColor(UIColor.black, for: .normal)
            imageViewContents(isHidden: true)
            partsViewContents(isHidden: false)
        }
        
        sender.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        sender.setTitleColor(UIColor.white, for: .normal)
    }
    
    func imageViewContents(isHidden : Bool)
    {
        imageView.frame = CGRect(x: (3 * x), y: imageButton.frame.maxY + y, width: view.frame.width - (6 * x), height: view.frame.height - (18 * y))
        imageView.backgroundColor = UIColor.clear
        view.addSubview(imageView)
        
        imageScrollView.frame = CGRect(x: 0, y: 0, width: imageView.frame.width, height: imageView.frame.height - 30)
        imageScrollView.isPagingEnabled = true
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.delegate = self
        imageView.addSubview(imageScrollView)
        
        imageScrollView.contentSize.width = (4 * imageScrollView.frame.width)
        
        imageView.isHidden = isHidden
        
        var x1:CGFloat = ((imageView.frame.width - (14 * x)) / 2)
        
        for i in 0..<4
        {
            let pageNumberlabel = UILabel()
            pageNumberlabel.frame = CGRect(x: x1, y: imageView.frame.height - (3 * y), width: (2 * x), height: (2 * y))
            pageNumberlabel.layer.cornerRadius = pageNumberlabel.frame.height / 2
            pageNumberlabel.layer.borderWidth = 1
            pageNumberlabel.layer.borderColor = UIColor.black.cgColor
            pageNumberlabel.layer.masksToBounds = true
            if i == 0
            {
                pageNumberlabel.backgroundColor = UIColor.orange
            }
            pageNumberlabel.text = "\(i)"
            pageNumberlabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            pageNumberlabel.textAlignment = .center
            pageNumberlabel.tag = (i + 1) * 20
            imageView.addSubview(pageNumberlabel)
            
            let lineLabel = UILabel()
            lineLabel.frame = CGRect(x: pageNumberlabel.frame.maxX, y: imageView.frame.height - (3 * y) + ((pageNumberlabel.frame.height - 1) / 2), width: (2 * x), height: 1)
            lineLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            
            if i != 3
            {
                imageView.addSubview(lineLabel)
            }
            
            x1 = lineLabel.frame.maxX
        }
        
        let nextButton = UIButton()
        nextButton.frame = CGRect(x: view.frame.width - (5 * x), y: view.frame.height - (9 * y), width: (3 * x), height: (3 * y))
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
        
        for index in 0..<4 {
            
            frame.origin.x = imageScrollView.frame.size.width * CGFloat(index)
            frame.size = imageScrollView.frame.size
            
            let subView = UIView(frame: frame)
//            let subView = UIView()
//            subView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height - 30)
//            subView.backgroundColor = colors[index]
            imageScrollView.addSubview(subView)
            
            print("X-\(subView.frame.minX), Y-\(subView.frame.minY), WIDTH-\(subView.frame.width), HEIGHT-\(subView.frame.height)")
            
            let measurementImageView = UIImageView()
            measurementImageView.frame = CGRect(x: x, y: y, width: subView.frame.width / 2, height: subView.frame.height - (2 * y))
//            measurementImageView.backgroundColor = UIColor.cyan
            measurementImageView.image = UIImage(named: measureImages[index])
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
                    subView.addSubview(headLabel)
                    
                    let headButton = UIButton()
                    headButton.frame = CGRect(x: (10.8 * x), y: (1.2 * y), width: subView.frame.width - (16.8 * x), height: (3 * y))
                    headButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    headButton.tag = 0
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
                    getHeadLabel.font = headLabel.font.withSize(20)
                    subView.addSubview(getHeadLabel)
                    
                    let neckLabel = UILabel()
                    neckLabel.frame = CGRect(x: (11.8 * x), y: (6 * y), width: subView.frame.width - (17.8 * x), height: (2 * y))
                    neckLabel.text = "Neck"
                    neckLabel.textColor = UIColor.black
                    neckLabel.textAlignment = .center
                    neckLabel.font = headLabel.font.withSize(15)
                    subView.addSubview(neckLabel)
                    
                    let neckButton = UIButton()
                    neckButton.frame = CGRect(x: (11.8 * x), y: (6.7 * y), width: subView.frame.width - (17.8 * x), height: (3 * y))
                    neckButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    neckButton.tag = 1
                    neckButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(neckButton)
                    
                    getNeckLabel.frame = CGRect(x: neckButton.frame.maxX, y: (6.7 * y), width: (5 * x), height: (3 * y))
                    getNeckLabel.text = "0.0"
                    getNeckLabel.textColor = UIColor.blue
                    getNeckLabel.textAlignment = .center
                    getNeckLabel.font = headLabel.font.withSize(20)
                    subView.addSubview(getNeckLabel)
                    
                    let chestLabel = UILabel()
                    chestLabel.frame = CGRect(x: (13.2 * x), y: (10.9 * y), width: subView.frame.width - (19.2 * x), height: (2 * y))
                    chestLabel.text = "Chest"
                    chestLabel.textColor = UIColor.black
                    chestLabel.textAlignment = .center
                    chestLabel.font = headLabel.font.withSize(15)
                    subView.addSubview(chestLabel)
                    
                    let chestButton = UIButton()
                    chestButton.frame = CGRect(x: (13.2 * x), y: (11.4 * y), width: subView.frame.width - (19.2 * x), height: (3 * y))
                    chestButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    chestButton.tag = 2
                    chestButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(chestButton)
                    
                    getChestLabel.frame = CGRect(x: chestButton.frame.maxX, y: (11.4 * y), width: (5 * x), height: (3 * y))
                    getChestLabel.text = "0.0"
                    getChestLabel.textColor = UIColor.blue
                    getChestLabel.textAlignment = .center
                    getChestLabel.font = headLabel.font.withSize(20)
                    subView.addSubview(getChestLabel)
                    
                    let waistLabel = UILabel()
                    waistLabel.frame = CGRect(x: (12.5 * x), y: (14.5 * y), width: subView.frame.width - (18.5 * x), height: (2 * y))
                    waistLabel.text = "Waist"
                    waistLabel.textColor = UIColor.black
                    waistLabel.textAlignment = .center
                    waistLabel.font = headLabel.font.withSize(15)
                    subView.addSubview(waistLabel)
                    
                    let waistButton = UIButton()
                    waistButton.frame = CGRect(x: (12.5 * x), y: (15 * y), width: subView.frame.width - (18.5 * x), height: (3 * y))
                    waistButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    waistButton.tag = 3
                    waistButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(waistButton)
                    
                    getWaistLabel.frame = CGRect(x: waistButton.frame.maxX, y: (15 * y), width: (5 * x), height: (3 * y))
                    getWaistLabel.text = "0.0"
                    getWaistLabel.textColor = UIColor.blue
                    getWaistLabel.textAlignment = .center
                    getWaistLabel.font = headLabel.font.withSize(20)
                    subView.addSubview(getWaistLabel)
                    
                    let thighLabel = UILabel()
                    thighLabel.frame = CGRect(x: (13 * x), y: (25.6 * y), width: subView.frame.width - (19 * x), height: (2 * y))
                    thighLabel.text = "Thigh"
                    thighLabel.textColor = UIColor.black
                    thighLabel.textAlignment = .center
                    thighLabel.font = headLabel.font.withSize(15)
                    subView.addSubview(thighLabel)
                    
                    let thighButton = UIButton()
                    thighButton.frame = CGRect(x: (13 * x), y: (26.1 * y), width: subView.frame.width - (19 * x), height: (3 * y))
                    thighButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    thighButton.tag = 4
                    thighButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(thighButton)
                    
                    getThighLabel.frame = CGRect(x: thighButton.frame.maxX, y: (26.1 * y), width: (5 * x), height: (3 * y))
                    getThighLabel.text = "0.0"
                    getThighLabel.textColor = UIColor.blue
                    getThighLabel.textAlignment = .center
                    getThighLabel.font = headLabel.font.withSize(20)
                    subView.addSubview(getThighLabel)
                    
                    let bounceLabel = UILabel()
                    bounceLabel.frame = CGRect(x: (11.8 * x), y: (30.6 * y), width: subView.frame.width - (17.8 * x), height: (2 * y))
                    bounceLabel.text = "Bounce"
                    bounceLabel.textColor = UIColor.black
                    bounceLabel.textAlignment = .center
                    bounceLabel.font = headLabel.font.withSize(15)
                    subView.addSubview(bounceLabel)
                    
                    let bounceButton = UIButton()
                    bounceButton.frame = CGRect(x: (11.8 * x), y: (31.1 * y), width: subView.frame.width - (17.8 * x), height: (3 * y))
                    bounceButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    bounceButton.tag = 5
                    bounceButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(bounceButton)

                    getBounceLabel.frame = CGRect(x: bounceButton.frame.maxX, y: (31.1 * y), width: (5 * x), height: (3 * y))
                    getBounceLabel.text = "0.0"
                    getBounceLabel.textColor = UIColor.blue
                    getBounceLabel.textAlignment = .center
                    getBounceLabel.font = headLabel.font.withSize(20)
                    subView.addSubview(getBounceLabel)
                    
                    let kneeLabel = UILabel()
                    kneeLabel.frame = CGRect(x: (11.2 * x), y: (39.9 * y), width: subView.frame.width - (17.2 * x), height: (2 * y))
                    kneeLabel.text = "Knee"
                    kneeLabel.textColor = UIColor.black
                    kneeLabel.textAlignment = .center
                    kneeLabel.font = headLabel.font.withSize(15)
                    subView.addSubview(kneeLabel)
                    
                    let kneeButton = UIButton()
                    kneeButton.frame = CGRect(x: (11.2 * x), y: (40.4 * y), width: subView.frame.width - (17.2 * x), height: (3 * y))
                    kneeButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    kneeButton.tag = 6
                    kneeButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(kneeButton)
                    
                    getKneeLabel.frame = CGRect(x: kneeButton.frame.maxX, y: (40.4 * y), width: (5 * x), height: (3 * y))
                    getKneeLabel.text = "0.0"
                    getKneeLabel.textColor = UIColor.blue
                    getKneeLabel.textAlignment = .center
                    getKneeLabel.font = headLabel.font.withSize(20)
                    subView.addSubview(getKneeLabel)
                }
                else if index == 1
                {
                    let totalheightLabel = UILabel()
                    totalheightLabel.frame = CGRect(x: 0, y: (14.5 * y), width: subView.frame.width - (6 * x), height: (2 * y))
                    totalheightLabel.text = "Over all height"
                    totalheightLabel.textColor = UIColor.black
                    totalheightLabel.textAlignment = .center
                    totalheightLabel.font = totalheightLabel.font.withSize(15)
                    subView.addSubview(totalheightLabel)
                    
                    let overAllHeightButton = UIButton()
                    overAllHeightButton.frame = CGRect(x: 0, y: (15 * y), width: subView.frame.width - (6 * x), height: (3 * y))
                    overAllHeightButton.setImage(UIImage(named: "lengthArrowMark"), for: .normal)
//                    overAllHeightButton.backgroundColor = UIColor.red
                    overAllHeightButton.tag = 7
                    overAllHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(overAllHeightButton)
                    
                    let gettotalheightLabel = UILabel()
                    gettotalheightLabel.frame = CGRect(x: overAllHeightButton.frame.maxX, y: (15 * y), width: (5 * x), height: (3 * y))
                    gettotalheightLabel.text = "0.0"
                    gettotalheightLabel.textColor = UIColor.blue
                    gettotalheightLabel.textAlignment = .center
                    gettotalheightLabel.font = gettotalheightLabel.font.withSize(20)
                    subView.addSubview(gettotalheightLabel)

                    let hipHeightLabel = UILabel()
                    hipHeightLabel.frame = CGRect(x: (4.3 * x), y: (39.5 * y), width: subView.frame.width - (10.3 * x), height: (2 * y))
                    hipHeightLabel.text = "Hip height"
                    hipHeightLabel.textColor = UIColor.black
                    hipHeightLabel.textAlignment = .center
                    hipHeightLabel.font = hipHeightLabel.font.withSize(15)
                    subView.addSubview(hipHeightLabel)
                    
                    let hipHeightButton = UIButton()
                    hipHeightButton.frame = CGRect(x: (4.3 * x), y: (40 * y), width: subView.frame.width - (10.3 * x), height: (3 * y))
                    hipHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    hipHeightButton.tag = 8
                    hipHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(hipHeightButton)
                    
                    let getHipheightLabel = UILabel()
                    getHipheightLabel.frame = CGRect(x: hipHeightButton.frame.maxX, y: (40 * y), width: (5 * x), height: (3 * y))
                    getHipheightLabel.text = "0.0"
                    getHipheightLabel.textColor = UIColor.blue
                    getHipheightLabel.textAlignment = .center
                    getHipheightLabel.font = getHipheightLabel.font.withSize(20)
                    subView.addSubview(getHipheightLabel)
                    
                    let bottomheightLabel = UILabel()
                    bottomheightLabel.frame = CGRect(x: (8.2 * x), y: (34.5 * y), width: subView.frame.width - (14.2 * x), height: (2 * y))
                    bottomheightLabel.text = "Bottom height"
                    bottomheightLabel.textColor = UIColor.black
                    bottomheightLabel.textAlignment = .center
                    bottomheightLabel.font = totalheightLabel.font.withSize(15)
                    subView.addSubview(bottomheightLabel)
                    
                    let bottomHeightButton = UIButton()
                    bottomHeightButton.frame = CGRect(x: (8.2 * x), y: (35 * y), width: subView.frame.width - (14.2 * x), height: (3 * y))
                    bottomHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    bottomHeightButton.tag = 9
                    bottomHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(bottomHeightButton)
                    
                    let getBottomheightLabel = UILabel()
                    getBottomheightLabel.frame = CGRect(x: bottomHeightButton.frame.maxX, y: (35 * y), width: (5 * x), height: (3 * y))
                    getBottomheightLabel.text = "0.0"
                    getBottomheightLabel.textColor = UIColor.blue
                    getBottomheightLabel.textAlignment = .center
                    getBottomheightLabel.font = getBottomheightLabel.font.withSize(20)
                    subView.addSubview(getBottomheightLabel)
                    
                    let kneeheightLabel = UILabel()
                    kneeheightLabel.frame = CGRect(x: (11.6 * x), y: (27.3 * y), width: subView.frame.width - (17.6 * x), height: (2 * y))
                    kneeheightLabel.text = "Knee height"
                    kneeheightLabel.textColor = UIColor.black
                    kneeheightLabel.textAlignment = .center
                    kneeheightLabel.font = totalheightLabel.font.withSize(15)
                    subView.addSubview(kneeheightLabel)
                    
                    let kneeHeightButton = UIButton()
                    kneeHeightButton.frame = CGRect(x: (11.6 * x), y: (27.8 * y), width: subView.frame.width - (17.6 * x), height: (3 * y))
                    kneeHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    kneeHeightButton.tag = 10
                    kneeHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(kneeHeightButton)
                    
                    let getKneeheightLabel = UILabel()
                    getKneeheightLabel.frame = CGRect(x: kneeHeightButton.frame.maxX, y: (27.8 * y), width: (5 * x), height: (3 * y))
                    getKneeheightLabel.text = "0.0"
                    getKneeheightLabel.textColor = UIColor.blue
                    getKneeheightLabel.textAlignment = .center
                    getKneeheightLabel.font = getKneeheightLabel.font.withSize(20)
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
                    subView.addSubview(shoulderLabel)
                    
                    let shoulderButton = UIButton()
                    shoulderButton.frame = CGRect(x: (13.6 * x), y: (7.5 * y), width: subView.frame.width - (19.6 * x), height: (3 * y))
                    shoulderButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    shoulderButton.tag = 11
                    shoulderButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(shoulderButton)
                    
                    let getShoulderLabel = UILabel()
                    getShoulderLabel.frame = CGRect(x: shoulderButton.frame.maxX, y: (7.5 * y), width: (5 * x), height: (3 * y))
                    getShoulderLabel.text = "0.0"
                    getShoulderLabel.textColor = UIColor.blue
                    getShoulderLabel.textAlignment = .center
                    getShoulderLabel.font = getShoulderLabel.font.withSize(20)
                    subView.addSubview(getShoulderLabel)
                    
                    let sleeveLabel = UILabel()
                    sleeveLabel.frame = CGRect(x: (14.5 * x), y: (11 * y), width: subView.frame.width - (20.5 * x), height: (2 * y))
                    sleeveLabel.text = "Half Sleeve"
                    sleeveLabel.textColor = UIColor.black
                    sleeveLabel.textAlignment = .center
                    sleeveLabel.font = sleeveLabel.font.withSize(15)
                    subView.addSubview(sleeveLabel)
                    
                    let sleeveButton = UIButton()
                    sleeveButton.frame = CGRect(x: (14.5 * x), y: (11.5 * y), width: subView.frame.width - (20.5 * x), height: (3 * y))
                    sleeveButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    sleeveButton.tag = 12
                    sleeveButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(sleeveButton)
                    
                    let getSleeveLabel = UILabel()
                    getSleeveLabel.frame = CGRect(x: sleeveButton.frame.maxX, y: (11.5 * y), width: (5 * x), height: (3 * y))
                    getSleeveLabel.text = "0.0"
                    getSleeveLabel.textColor = UIColor.blue
                    getSleeveLabel.textAlignment = .center
                    getSleeveLabel.font = getSleeveLabel.font.withSize(20)
                    subView.addSubview(getSleeveLabel)
                    
                    let bicepLabel = UILabel()
                    bicepLabel.frame = CGRect(x: (15.7 * x), y: (14.1 * y), width: subView.frame.width - (21.7 * x), height: (2 * y))
                    bicepLabel.text = "Bicep"
                    bicepLabel.textColor = UIColor.black
                    bicepLabel.textAlignment = .center
                    bicepLabel.font = bicepLabel.font.withSize(15)
                    subView.addSubview(bicepLabel)
                    
                    let bicepButton = UIButton()
                    bicepButton.frame = CGRect(x: (15.7 * x), y: (14.6 * y), width: subView.frame.width - (21.7 * x), height: (3 * y))
                    bicepButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    bicepButton.tag = 13
                    bicepButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(bicepButton)
                    
                    let getBicepLabel = UILabel()
                    getBicepLabel.frame = CGRect(x: bicepButton.frame.maxX, y: (14.6 * y), width: (5 * x), height: (3 * y))
                    getBicepLabel.text = "0.0"
                    getBicepLabel.textColor = UIColor.blue
                    getBicepLabel.textAlignment = .center
                    getBicepLabel.font = getBicepLabel.font.withSize(20)
                    subView.addSubview(getBicepLabel)
                    
                    let hipLabel = UILabel()
                    hipLabel.frame = CGRect(x: (12.4 * x), y: (16.8 * y), width: subView.frame.width - (18.4 * x), height: (2 * y))
                    hipLabel.text = "Hip"
                    hipLabel.textColor = UIColor.black
                    hipLabel.textAlignment = .center
                    hipLabel.font = hipLabel.font.withSize(15)
                    subView.addSubview(hipLabel)
                    
                    let hipButton = UIButton()
                    hipButton.frame = CGRect(x: (12.4 * x), y: (17.3 * y), width: subView.frame.width - (18.4 * x), height: (3 * y))
                    hipButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    hipButton.tag = 14
                    hipButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(hipButton)
                    
                    let getHipLabel = UILabel()
                    getHipLabel.frame = CGRect(x: hipButton.frame.maxX, y: (17.3 * y), width: (5 * x), height: (3 * y))
                    getHipLabel.text = "0.0"
                    getHipLabel.textColor = UIColor.blue
                    getHipLabel.textAlignment = .center
                    getHipLabel.font = getHipLabel.font.withSize(20)
                    subView.addSubview(getHipLabel)
                    
                    let backLabel = UILabel()
                    backLabel.frame = CGRect(x: (12.9 * x), y: (20.5 * y), width: subView.frame.width - (18.9 * x), height: (2 * y))
                    backLabel.text = "Back"
                    backLabel.textColor = UIColor.black
                    backLabel.textAlignment = .center
                    backLabel.font = backLabel.font.withSize(15)
                    subView.addSubview(backLabel)
                    
                    let backButton = UIButton()
                    backButton.frame = CGRect(x: (12.9 * x), y: (21 * y), width: subView.frame.width - (18.9 * x), height: (3 * y))
                    backButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    backButton.tag = 15
                    backButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(backButton)
                    
                    let getBackLabel = UILabel()
                    getBackLabel.frame = CGRect(x: backButton.frame.maxX, y: (21 * y), width: (5 * x), height: (3 * y))
                    getBackLabel.text = "0.0"
                    getBackLabel.textColor = UIColor.blue
                    getBackLabel.textAlignment = .center
                    getBackLabel.font = getBackLabel.font.withSize(20)
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
                    subView.addSubview(heightLabel)
                    
                    let heightButton = UIButton()
                    heightButton.frame = CGRect(x: (9.6 * x), y: (11.1 * y), width: subView.frame.width - (15.6 * x), height: (3 * y))
                    heightButton.setImage(UIImage(named: "lengthArrowMark"), for: .normal)
                    heightButton.tag = 16
                    heightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(heightButton)
                    
                    let getHeightLabel = UILabel()
                    getHeightLabel.frame = CGRect(x: heightButton.frame.maxX, y: (11.1 * y), width: (5 * x), height: (3 * y))
                    getHeightLabel.text = "0.0"
                    getHeightLabel.textColor = UIColor.blue
                    getHeightLabel.textAlignment = .center
                    getHeightLabel.font = getHeightLabel.font.withSize(20)
                    subView.addSubview(getHeightLabel)
                    
                    let fullSleeveLabel = UILabel()
                    fullSleeveLabel.frame = CGRect(x: (14.6 * x), y: (15.1 * y), width: subView.frame.width - (20.6 * x), height: (2 * y))
                    fullSleeveLabel.text = "Sleeve Height"
                    fullSleeveLabel.textColor = UIColor.black
                    fullSleeveLabel.textAlignment = .center
                    fullSleeveLabel.font = heightLabel.font.withSize(15)
                    subView.addSubview(fullSleeveLabel)
                    
                    let fullSleeveButton = UIButton()
                    fullSleeveButton.frame = CGRect(x: (14.6 * x), y: (15.6 * y), width: subView.frame.width - (20.6 * x), height: (3 * y))
                    fullSleeveButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    fullSleeveButton.tag = 17
                    fullSleeveButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(fullSleeveButton)
                    
                    let getFullSleeveLabel = UILabel()
                    getFullSleeveLabel.frame = CGRect(x: fullSleeveButton.frame.maxX, y: (15.6 * y), width: (5 * x), height: (3 * y))
                    getFullSleeveLabel.text = "0.0"
                    getFullSleeveLabel.textColor = UIColor.blue
                    getFullSleeveLabel.textAlignment = .center
                    getFullSleeveLabel.font = getFullSleeveLabel.font.withSize(20)
                    subView.addSubview(getFullSleeveLabel)
                    
                    let handKneeLabel = UILabel()
                    handKneeLabel.frame = CGRect(x: (15.5 * x), y: (19.9 * y), width: subView.frame.width - (21.5 * x), height: (2 * y))
                    handKneeLabel.text = "Hand Cuf"
                    handKneeLabel.textColor = UIColor.black
                    handKneeLabel.textAlignment = .center
                    handKneeLabel.font = handKneeLabel.font.withSize(15)
                    subView.addSubview(handKneeLabel)
                    
                    let handKneeButton = UIButton()
                    handKneeButton.frame = CGRect(x: (15.5 * x), y: (20.3 * y), width: subView.frame.width - (21.5 * x), height: (3 * y))
                    handKneeButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    handKneeButton.tag = 18
                    handKneeButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(handKneeButton)
                    
                    let getHandKneeLabel = UILabel()
                    getHandKneeLabel.frame = CGRect(x: handKneeButton.frame.maxX, y: (20.3 * y), width: (5 * x), height: (3 * y))
                    getHandKneeLabel.text = "0.0"
                    getHandKneeLabel.textColor = UIColor.blue
                    getHandKneeLabel.textAlignment = .center
                    getHandKneeLabel.font = getHandKneeLabel.font.withSize(20)
                    subView.addSubview(getHandKneeLabel)
                }
                
                for view in subView.subviews
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
                }
            }
            else
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
            }
        }
        
        let page = imageScrollView.contentOffset.x / imageScrollView.frame.size.width;
        print("PAGE NUMBER", page)
        
        
        imageScrollView.contentSize = CGSize(width: imageScrollView.frame.size.width * 4,height: imageScrollView.frame.size.height)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
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
        
        let pageNumber = round(imageScrollView .contentOffset.x / imageScrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        
        print("PAGE NUMBER", pageNumber)
        
        for i in 0..<4
        {
            print("I VALUE", i, self.view.viewWithTag((i + 1) * 20))
            if let theLabel = self.view.viewWithTag((i + 1) * 20) as? UILabel {
                let pageNo = Int(pageNumber)
                let no = Int(theLabel.text!)
                
                if pageNo == no
                {
                    theLabel.backgroundColor = UIColor.orange
                }
                else
                {
                    theLabel.backgroundColor = UIColor.clear
                }
                
                print("THE LABEL TEXT", theLabel.text!)
            }
        }
    }
    
    @objc func measurementButtonAction(sender : UIButton)
    {
        let measureScreen = MeasureScrollViewController()

        if sender.tag == 0
        {
            measureScreen.headingTitle = "Head"
            measureScreen.viewTag = 1
        }
        else if sender.tag == 1
        {
            measureScreen.headingTitle = "Neck"
            measureScreen.viewTag = 2
        }
        else if sender.tag == 2
        {
            measureScreen.headingTitle = "Chest"
            measureScreen.viewTag = 3
        }
        else if sender.tag == 3
        {
            measureScreen.headingTitle = "Waist"
            measureScreen.viewTag = 4
        }
        else if sender.tag == 4
        {
            measureScreen.headingTitle = "Thigh"
            measureScreen.viewTag = 5
        }
        else if sender.tag == 5
        {
            measureScreen.headingTitle = "Bounce"
            measureScreen.viewTag = 6
        }
        else if sender.tag == 6
        {
            measureScreen.headingTitle = "Knee"
            measureScreen.viewTag = 7
        }
        else if sender.tag == 7
        {
            measureScreen.headingTitle = "Height"
            measureScreen.viewTag = 8
        }
        else if sender.tag == 8
        {
            measureScreen.headingTitle = "Leg Height"
            measureScreen.viewTag = 9
        }
        else if sender.tag == 9
        {
            measureScreen.headingTitle = "3 / 4 Height"
            measureScreen.viewTag = 10
        }
        else if sender.tag == 10
        {
            measureScreen.headingTitle = "Short Height"
            measureScreen.viewTag = 11
        }
        else if sender.tag == 11
        {
            measureScreen.headingTitle = "Shoulder"
            measureScreen.viewTag = 12
        }
        else if sender.tag == 12
        {
            measureScreen.headingTitle = "Half Sleeve"
            measureScreen.viewTag = 13
        }
        else if sender.tag == 13
        {
            measureScreen.headingTitle = "Bicep"
            measureScreen.viewTag = 14
        }
        else if sender.tag == 14
        {
            measureScreen.headingTitle = "Hip"
            measureScreen.viewTag = 15
        }
        else if sender.tag == 15
        {
            measureScreen.headingTitle = "Back"
            measureScreen.viewTag = 16
        }
        else if sender.tag == 16
        {
            measureScreen.headingTitle = "Shirt Height"
            measureScreen.viewTag = 17
        }
        else if sender.tag == 17
        {
            measureScreen.headingTitle = "Sleeve Height"
            measureScreen.viewTag = 18
        }
        else if sender.tag == 18
        {
            measureScreen.headingTitle = "Hand Cuf"
            measureScreen.viewTag = 19
        }
        
        self.navigationController?.pushViewController(measureScreen, animated: true)
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
            getBounceLabel.text = value
        }
        else if viewTag == 7
        {
            getKneeLabel.text = value
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
        let referenceScreen = ReferenceImageViewController()
        self.navigationController?.pushViewController(referenceScreen, animated: true)
    }
    
    
    func partsViewContents(isHidden : Bool)
    {
        partsView.frame = CGRect(x: (4 * x), y: imageButton.frame.maxY + y, width: view.frame.width - (8 * x), height: view.frame.height - (24 * y))
        partsView.backgroundColor = UIColor.clear
        view.addSubview(partsView)
        
        partsView.isHidden = isHidden
        
        partsTableView.frame = CGRect(x: 0, y: 0, width: partsView.frame.width, height: partsView.frame.height)
        partsTableView.register(PartsTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(PartsTableViewCell.self))
        partsTableView.dataSource = self
        partsTableView.delegate = self
        partsView.addSubview(partsTableView)
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
        
        cell.backgroundColor = UIColor.lightGray
        
        cell.partsImage.frame = CGRect(x: x, y: y, width: (3 * x), height: (3 * y))

        cell.partsName.frame = CGRect(x: cell.partsImage.frame.maxX + x, y: y, width: cell.frame.width - (5.5 * x), height: (3 * y))
        
        cell.partsImage.image = convertedPartsImageArray[indexPath.row]
        cell.partsName.text = PartsNameArray[indexPath.row] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return (5 * y)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let partsScreen = PartsViewController()
        self.navigationController?.pushViewController(partsScreen, animated: true)
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
