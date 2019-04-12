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
    
    //SCREEN PARAMETERS
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()
    
    // Measurements2...
    var MeasurementsIdArray = NSArray()
    var GenderMeasurementIdArray = NSArray()
    var MeasurementsNameArray = NSArray()
    var MeasurementsImagesArray = NSArray()
    var MeasurementsReferenceNumberArray = NSArray()
    var convertedMeasurementsImageArray = [UIImage]()
    
    //GET PARAMETERS
    let getNeckLabel = UILabel()            //1
    let getHeadLabel = UILabel()            //2
    let getChestLabel = UILabel()           //3
    let getWaistLabel = UILabel()           //4
    let getThighLabel = UILabel()           //5
    let getKneeLabel = UILabel()            //6
    let getAnkleLabel = UILabel()           //7
    let gettotalheightLabel = UILabel()     //8
    let getHipheightLabel = UILabel()       //9
    let getBottomheightLabel = UILabel()    //10
    let getKneeheightLabel = UILabel()      //11
    let getShoulderLabel = UILabel()        //12
    let getSleeveLabel = UILabel()          //13
    let getBicepLabel = UILabel()           //14
    let getHipLabel = UILabel()             //15
    let getBackLabel = UILabel()            //16
    let getHeightLabel = UILabel()          //17
    let getFullSleeveLabel = UILabel()      //18
    let getHandKneeLabel = UILabel()        //19
    
    // Parts...
    var PartsIdArray = NSArray()
    var PartsGenderMeasurementIdArray = NSArray()
    var PartsNameArray = NSArray()
    var partsNameArabicArray = NSArray()
    var PartsImagesArray = NSArray()
    var PartsReferenceNumberArray = NSArray()
    var convertedPartsImageArray = [UIImage]()
    
    //GENDER IMAGES PARAMETERS
    var genderImageArray = NSArray()
    var genderImagesIdArray = NSArray()
    var converetedGenderImagesArray = [UIImage]()
    
    let partsTableView = UITableView()
    
    let partsNameLabel = UILabel()
    let partsMeasurementLabel = UILabel()
    let rulerScroll = UIScrollView()
    let imageBackView = UIView()
    let partsImageView = UIImageView()
    let partsBackView = UIView()
    let selectedPartsImageView = UIImageView()
    let partsInputTextField = UITextField()
    let cancelButton = UIButton()
    let saveButton = UIButton()

    
    
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
    var measurerPartsName = String()
    var measurePartsImage = String()
    var measurerTag = Int()
    
    var measurementValues = [Int : Double]()
    
    var type = "table"
    var unitTag = "cm"
    var pageNumber = 0
    
    var headingPartsArray = [Int]()
    var valuePartsArray = [Int]()
    var increamentHeadingTag = 0
    var increamentValueTag = 0
    
    //ACTIVITY INDICATOR PARAMETERS
    let activeViewSub = UIView()
    let activityIndicatorSub = UIActivityIndicatorView()
    
    
    //HINTS PARAMETERS
    var hintTag = 0
    let hintsImage = UIImageView()
    let detailedLabel = UILabel()

    
    var applicationDelegate = AppDelegate()

    
    override func viewDidLoad()
    {
        navigationBar.isHidden = true
        //        self.tab1Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        selectedButton(tag: 0)
        
//        self.serviceCall.API_DisplayMeasurement(Measurement2Value: 1, delegate: self)
        
        let dummyArray = NSArray()
        
        genderImageArray = dummyArray
        genderImagesIdArray = dummyArray
        PartsIdArray = dummyArray
        PartsNameArray = dummyArray
        partsNameArabicArray = dummyArray
        PartsReferenceNumberArray = dummyArray
        PartsGenderMeasurementIdArray = dummyArray
        PartsImagesArray = dummyArray
        converetedGenderImagesArray.removeAll()
        convertedPartsImageArray.removeAll()
        
        if let dressid = UserDefaults.standard.value(forKey: "dressSubTypeId") as? Int
        {
            self.serviceCall.API_GetMeasurement2(Measurement1Value: dressid, delegate: self)
            
        }
        else if let dressid = UserDefaults.standard.value(forKey: "dressSubTypeId") as? String
        {
            self.serviceCall.API_GetMeasurement2(Measurement1Value: Int(dressid)!, delegate: self)
        }
        
        addDoneButtonOnKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        /*let dummyArray = NSArray()
        
        genderImageArray = dummyArray
        genderImagesIdArray = dummyArray
        PartsIdArray = dummyArray
        PartsNameArray = dummyArray
        partsNameArabicArray = dummayArray
        PartsReferenceNumberArray = dummyArray
        PartsGenderMeasurementIdArray = dummyArray
        PartsImagesArray = dummyArray
        converetedGenderImagesArray.removeAll()
        convertedPartsImageArray.removeAll()
        
        if let dressid = UserDefaults.standard.value(forKey: "dressSubTypeId") as? Int
        {
            self.serviceCall.API_GetMeasurement2(Measurement1Value: dressid, delegate: self)
            
        }
        else if let dressid = UserDefaults.standard.value(forKey: "dressSubTypeId") as? String
        {
            self.serviceCall.API_GetMeasurement2(Measurement1Value: Int(dressid)!, delegate: self)
        }*/
    }
    
    func activitySubContents()
    {
        activeViewSub.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        activeViewSub.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        view.addSubview(activeViewSub)
        
        self.view.bringSubviewToFront(activeViewSub)
        
        activityIndicatorSub.frame = CGRect(x: ((activeViewSub.frame.width - 50) / 2), y: ((activeViewSub.frame.height - 50) / 2), width: 50, height: 50)
        activityIndicatorSub.style = .whiteLarge
        activityIndicatorSub.color = UIColor.white
        activityIndicatorSub.startAnimating()
        activeViewSub.addSubview(activityIndicatorSub)
    }
    
    func stopSubActivity()
    {
        activeViewSub.removeFromSuperview()
        activityIndicatorSub.stopAnimating()
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        stopActivity()
        applicationDelegate.exitContents()
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        //  ErrorStr = "Default Error"
        PageNumStr = "Measurement2ViewController"
        // MethodName = "do"
        
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
    }
    
    
    func API_CALLBACK_InsertErrorDevice(deviceError: NSDictionary)
    {
        let ResponseMsg = deviceError.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = deviceError.object(forKey: "Result") as! String
        }
    }
    
    func API_CALLBACK_GetMeasurement2(GetMeasurement1val: NSDictionary)
    {
        let ResponseMsg = GetMeasurement1val.object(forKey: "ResponseMsg") as! String
        print("GetMeasurement2Value", GetMeasurement1val)
        
        if ResponseMsg == "Success"
        {
            let Result = GetMeasurement1val.object(forKey: "Result") as! NSDictionary
            
            let Image = Result.object(forKey: "Image") as! NSArray
            
            genderImageArray = Image.value(forKey: "Image") as! NSArray
            
            genderImagesIdArray = Image.value(forKey: "id") as! NSArray
            
            /*for i in 0..<genderImageArray.count
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
            }*/
            
            // Body Parts :
            
            let Measurements = Result.object(forKey: "Measurements") as! NSArray
            
            if Measurements.count != 0
            {
                PartsIdArray = Measurements.value(forKey: "Id") as! NSArray
                PartsNameArray = Measurements.value(forKey: "TextInEnglish") as! NSArray
                partsNameArabicArray = Measurements.value(forKey: "TextInArabic") as! NSArray
                PartsReferenceNumberArray = Measurements.value(forKey: "ReferenceNumber") as! NSArray
                PartsGenderMeasurementIdArray = Measurements.value(forKey: "GenderMeasurementId") as! NSArray
                PartsImagesArray = Measurements.value(forKey: "Image") as! NSArray
                
                for i in 0..<PartsIdArray.count
                {
                    if let id1 = PartsIdArray[i] as? Int
                    {
                        let id2 = ((id1 * 1) + 200)
                        let id3 = ((id1 * 1) + 300)
                        
                        valuePartsArray.append(id2)
                        headingPartsArray.append(id3)
                    }
                }
                
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
                
                self.measurement2Contents()
                partsTableView.reloadData()
            }
            else
            {
                stopActivity()
                
                var measurementAlert = UIAlertController()
                
                if let language = UserDefaults.standard.value(forKey: "language") as? String
                {
                    if language == "en"
                    {
                        measurementAlert = UIAlertController(title: "Alert", message: "Measurements are not available for this dress type", preferredStyle: .alert)
                        measurementAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: responseEmptyAlertAction(action:)))
                    }
                    else if language == "ar"
                    {
                        measurementAlert = UIAlertController(title: "تنبيه", message: "القياسات غير متوفرة لهذا النوع من الفساتين", preferredStyle: .alert)
                        measurementAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: responseEmptyAlertAction(action:)))
                    }
                }
                else
                {
                    measurementAlert = UIAlertController(title: "Alert", message: "Measurements are not available for this dress type", preferredStyle: .alert)
                    measurementAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: responseEmptyAlertAction(action:)))
                }
                
                self.present(measurementAlert, animated: true, completion: nil)
            }
        }
        else if ResponseMsg == "Failure"
        {
            let Result = GetMeasurement1val.object(forKey: "Result") as! String
            
            MethodName = "DisplayMeasurementBySubTypeId"
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func responseEmptyAlertAction(action : UIAlertAction)
    {
        UserDefaults.standard.set(1, forKey: "measurement2Response")
        let referenceScreen = ReferenceImageViewController()
        self.navigationController?.pushViewController(referenceScreen, animated: true)
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
            partsNameArabicArray = Result.value(forKey: "TextInArabic") as! NSArray
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
    
    func changeViewToEnglishInSelf()
    {
        view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        tabBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.text = "MEASUREMENT-2"
        
        imageButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        imageButton.setTitle("IMAGE", for: .normal)
        partsButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        partsButton.setTitle("PARTS", for: .normal)
        
//        imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        partsImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        cmButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        cmButton.setTitle("CM", for: .normal)
        inButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        inButton.setTitle("IN", for: .normal)
        
        partsNameLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        partsMeasurementLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        saveButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        saveButton.setTitle("SAVE", for: .normal)
        cancelButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        cancelButton.setTitle("CANCEL", for: .normal)
        
        partsInputTextField.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    func changeViewToArabicInSelf()
    {
        view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        tabBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
//        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.text = "قياس-2"
        
        imageButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        imageButton.setTitle("صورة", for: .normal)
        partsButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        partsButton.setTitle("أجزاء", for: .normal)
        
//        imageView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        partsImageView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        cmButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        cmButton.setTitle("CM", for: .normal)
        inButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        inButton.setTitle("IN", for: .normal)
        
        partsNameLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        partsMeasurementLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        saveButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        saveButton.setTitle("حفظ", for: .normal)
        cancelButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        cancelButton.setTitle("إلغاء", for: .normal)
        
        partsInputTextField.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    func measurement2Contents()
    {
        imageBackView.removeFromSuperview()
        
        selfScreenNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        selfScreenNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(selfScreenNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        backButton.tag = 3
        selfScreenNavigationBar.addSubview(backButton)
        
        selfScreenNavigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: selfScreenNavigationBar.frame.width, height: (3 * y))
        selfScreenNavigationTitle.text = "MEASUREMENT-2"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationTitle.font = selfScreenNavigationTitle.font.withSize(2 * x)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        pageBar.image = UIImage(named: "Measurement_wizard")
        
        imageButton.frame = CGRect(x: 0, y: selfScreenNavigationBar.frame.maxY + (5 * y), width: ((view.frame.width / 2) - 1), height: (5 * y))
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
        
        partsButton.frame = CGRect(x: imageButton.frame.maxX + 1, y: selfScreenNavigationBar.frame.maxY + (5 * y), width: view.frame.width / 2, height: (5 * y))
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
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                changeViewToEnglishInSelf()
                dropDown.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                dropDown1.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            else if language == "ar"
            {
                changeViewToArabicInSelf()
                dropDown.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                dropDown1.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            }
        }
        else
        {
            changeViewToEnglishInSelf()
            dropDown.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            dropDown1.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
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
            increamentHeadingTag = 0
            increamentValueTag = 0
            
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
        
        for i in 0..<genderImageArray.count
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
            
            let checkCount = genderImageArray.count - 1
            if i != checkCount
            {
                numberView.addSubview(lineLabel)
            }
            
            x1 = lineLabel.frame.maxX
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    pageNumberlabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
                else if language == "ar"
                {
                    pageNumberlabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                }
            }
            else
            {
                pageNumberlabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
    }
    
    func imageViewContents(isHidden : Bool)
    {
        imageView.frame = CGRect(x: (3 * x), y: imageButton.frame.maxY, width: view.frame.width - (6 * x), height: view.frame.height - (navigationBar.frame.height + pageBar.frame.height + tabBar.frame.height + imageButton.frame.height))
        imageView.backgroundColor = UIColor.clear
        view.addSubview(imageView)
        
        imageView.isHidden = isHidden
        
        imageScrollView.frame = CGRect(x: 0, y: 0, width: imageView.frame.width, height: imageView.frame.height - 30)
        imageScrollView.isPagingEnabled = true
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.delegate = self
        imageView.addSubview(imageScrollView)
        
        imageScrollView.contentSize.width = (CGFloat(genderImageArray.count) * imageScrollView.frame.width)
        
        for views in imageScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        pageNumberContents()
        
        unitView.frame = CGRect(x: (2 * x), y: view.frame.height - (9 * y), width: (7 * x), height: (2.5 * y))
        unitView.layer.cornerRadius = unitView.frame.height / 2
        unitView.layer.borderWidth = 1
        view.addSubview(unitView)
        
        cmButton.isEnabled = false
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
        
        if let getGender = UserDefaults.standard.value(forKey: "gender") as? String
        {
            gender = getGender
        }
        
//        gender = "Girl"
        
        var measureImages = [String]()
        
        if gender == "Male"
        {
            measureImages = ["Man-front", "Man-front_2", "Man-Back", "Man-Back_2"]
        }
        else if gender == "Boy"
        {
            measureImages = ["boyFront_1", "boyFront_2", "boyBack_1", "boyBack_2"]
        }
        else if gender == "Female"
        {
            measureImages = ["womenFront_1", "womenFront_2", "womenFront_3", "womenback_1", "womenback_2"]
        }
        else if gender == "Girl"
        {
            measureImages = ["girlFront_1", "girlFront_2", "girlFront_3", "girlBack_1", "girlBack_2"]
        }
        
        var buttonTag = Int()
        
        for index in 0..<genderImageArray.count {
            
            frame.origin.x = imageScrollView.frame.size.width * CGFloat(index)
            frame.size = imageScrollView.frame.size
            
            let subView = UIView(frame: frame)
//            subView.backgroundColor = colors[index]
            subView.tag = ((index * 1) + 500)
            imageScrollView.addSubview(subView)
            
            let measurementImageView = UIImageView()
            measurementImageView.frame = CGRect(x: x, y: y, width: subView.frame.width / 2, height: subView.frame.height - (2 * y))
            measurementImageView.backgroundColor = UIColor.clear
//            measurementImageView.image = UIImage(named: measureImages[index])
//            measurementImageView.image = converetedGenderImagesArray[index]
            if let imageName =  genderImageArray[index] as? String
            {
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/Measurement2/\(imageName)"
                let apiurl = URL(string: api)
                if apiurl != nil
                {
                    measurementImageView.dowloadFromServer(url: apiurl!)
                }
            }
            subView.addSubview(measurementImageView)
            
            let verticalLine = UILabel()
            verticalLine.frame = CGRect(x: subView.frame.width - x, y: y, width: 1, height: subView.frame.height - (2 * y))
            //            verticalLine.backgroundColor = UIColor.red
            subView.addSubview(verticalLine)
            
            let verticalLine2 = UILabel()
            verticalLine2.frame = CGRect(x: subView.frame.width - (6 * x), y: y, width: 1, height: subView.frame.height - (2 * y))
            //            verticalLine2.backgroundColor = UIColor.red
            subView.addSubview(verticalLine2)
            
            if gender == "Male" || gender == "ذكر"
            {
                if index == 0
                {
                    let headLabel = UILabel()
                    headLabel.frame = CGRect(x: (10.6 * x), y: (y / 2), width: subView.frame.width - (19.6 * x), height: (2 * y))
                    headLabel.text = "Head"
                    headLabel.textColor = UIColor.black
                    headLabel.textAlignment = .right
                    headLabel.font = headLabel.font.withSize(15)
                    headLabel.tag = ((1 * 1) + 300)
                    subView.addSubview(headLabel)
                    
                    let headButton = UIButton()
                    headButton.frame = CGRect(x: (10.6 * x), y: (1.2 * y), width: subView.frame.width - (16.6 * x), height: (3 * y))
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
                    neckLabel.frame = CGRect(x: (11.4 * x), y: (5.5 * y), width: subView.frame.width - (20.4 * x), height: (2 * y))
                    neckLabel.text = "Neck"
                    neckLabel.textColor = UIColor.black
                    neckLabel.textAlignment = .right
                    neckLabel.font = headLabel.font.withSize(15)
                    neckLabel.tag = ((2 * 1) + 300)
                    subView.addSubview(neckLabel)
                    
                    let neckButton = UIButton()
                    neckButton.frame = CGRect(x: (11.4 * x), y: (6.2 * y), width: subView.frame.width - (17.4 * x), height: (3 * y))
                    neckButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    neckButton.tag = 2
                    neckButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(neckButton)
                    
                    getNeckLabel.frame = CGRect(x: neckButton.frame.maxX, y: (6.2 * y), width: (5 * x), height: (3 * y))
                    getNeckLabel.text = "0.0"
                    getNeckLabel.textColor = UIColor.blue
                    getNeckLabel.textAlignment = .center
                    getNeckLabel.font = headLabel.font.withSize(15)
                    getNeckLabel.tag = ((2 * 1) + 200)
                    subView.addSubview(getNeckLabel)
                    
                    let chestLabel = UILabel()
                    chestLabel.frame = CGRect(x: (12.8 * x), y: (9.9 * y), width: subView.frame.width - (21.8 * x), height: (2 * y))
                    chestLabel.text = "Chest"
                    chestLabel.textColor = UIColor.black
                    chestLabel.textAlignment = .right
                    chestLabel.font = headLabel.font.withSize(15)
                    chestLabel.tag = ((3 * 1) + 300)
                    subView.addSubview(chestLabel)
                    
                    let chestButton = UIButton()
                    chestButton.frame = CGRect(x: (12.8 * x), y: (10.4 * y), width: subView.frame.width - (18.8 * x), height: (3 * y))
                    chestButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    chestButton.tag = 3
                    chestButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(chestButton)
                    
                    getChestLabel.frame = CGRect(x: chestButton.frame.maxX, y: (10.4 * y), width: (5 * x), height: (3 * y))
                    getChestLabel.text = "0.0"
                    getChestLabel.textColor = UIColor.blue
                    getChestLabel.textAlignment = .center
                    getChestLabel.font = headLabel.font.withSize(15)
                    getChestLabel.tag = ((3 * 1) + 200)
                    subView.addSubview(getChestLabel)
                    
                    let waistLabel = UILabel()
                    waistLabel.frame = CGRect(x: (12.1 * x), y: (13.3 * y), width: subView.frame.width - (21.1 * x), height: (2 * y))
                    waistLabel.text = "Waist"
                    waistLabel.textColor = UIColor.black
                    waistLabel.textAlignment = .right
                    waistLabel.font = headLabel.font.withSize(15)
                    waistLabel.tag = ((4 * 1) + 300)
                    subView.addSubview(waistLabel)
                    
                    let waistButton = UIButton()
                    waistButton.frame = CGRect(x: (12.1 * x), y: (13.7 * y), width: subView.frame.width - (18.1 * x), height: (3 * y))
                    waistButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    waistButton.tag = 4
                    waistButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(waistButton)
                    
                    getWaistLabel.frame = CGRect(x: waistButton.frame.maxX, y: (13.7 * y), width: (5 * x), height: (3 * y))
                    getWaistLabel.text = "0.0"
                    getWaistLabel.textColor = UIColor.blue
                    getWaistLabel.textAlignment = .center
                    getWaistLabel.font = headLabel.font.withSize(15)
                    getWaistLabel.tag = ((4 * 1) + 200)
                    subView.addSubview(getWaistLabel)
                    
                    let thighLabel = UILabel()
                    thighLabel.frame = CGRect(x: (12.5 * x), y: (23.5 * y), width: subView.frame.width - (21.5 * x), height: (2 * y))
                    thighLabel.text = "Thigh"
                    thighLabel.textColor = UIColor.black
                    thighLabel.textAlignment = .right
                    thighLabel.font = headLabel.font.withSize(15)
                    thighLabel.tag = ((5 * 1) + 300)
                    subView.addSubview(thighLabel)
                    
                    let thighButton = UIButton()
                    thighButton.frame = CGRect(x: (12.5 * x), y: (24 * y), width: subView.frame.width - (18.5 * x), height: (3 * y))
                    thighButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    thighButton.tag = 5
                    thighButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(thighButton)
                    
                    getThighLabel.frame = CGRect(x: thighButton.frame.maxX, y: (24 * y), width: (5 * x), height: (3 * y))
                    getThighLabel.text = "0.0"
                    getThighLabel.textColor = UIColor.blue
                    getThighLabel.textAlignment = .center
                    getThighLabel.font = headLabel.font.withSize(15)
                    getThighLabel.tag = ((5 * 1) + 200)
                    subView.addSubview(getThighLabel)
                    
                    let kneeLabel = UILabel()
                    kneeLabel.frame = CGRect(x: (11.6 * x), y: (27.9 * y), width: subView.frame.width - (20.6 * x), height: (2 * y))
                    kneeLabel.text = "Knee"
                    kneeLabel.textColor = UIColor.black
                    kneeLabel.textAlignment = .right
                    kneeLabel.font = headLabel.font.withSize(15)
                    kneeLabel.tag = ((6 * 1) + 300)
                    subView.addSubview(kneeLabel)
                    
                    let kneeButton = UIButton()
                    kneeButton.frame = CGRect(x: (11.6 * x), y: (28.4 * y), width: subView.frame.width - (17.6 * x), height: (3 * y))
                    kneeButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    kneeButton.tag = 6
                    kneeButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(kneeButton)
                    
                    getKneeLabel.frame = CGRect(x: kneeButton.frame.maxX, y: (28.4 * y), width: (5 * x), height: (3 * y))
                    getKneeLabel.text = "0.0"
                    getKneeLabel.textColor = UIColor.blue
                    getKneeLabel.textAlignment = .center
                    getKneeLabel.font = headLabel.font.withSize(15)
                    getKneeLabel.tag = ((6 * 1) + 200)
                    subView.addSubview(getKneeLabel)
                    
                    let ankleLabel = UILabel()
                    ankleLabel.frame = CGRect(x: (11 * x), y: (39.9 * y), width: subView.frame.width - (20 * x), height: (2 * y))
                    ankleLabel.text = "Ankle"
                    ankleLabel.textColor = UIColor.black
                    ankleLabel.textAlignment = .right
                    ankleLabel.font = headLabel.font.withSize(15)
                    ankleLabel.tag = ((7 * 1) + 300)
                    subView.addSubview(ankleLabel)
                    
                    let ankleButton = UIButton()
                    ankleButton.frame = CGRect(x: (11 * x), y: (37 * y), width: subView.frame.width - (17 * x), height: (3 * y))
                    ankleButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    ankleButton.tag = 7
                    ankleButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(ankleButton)
                    
                    getAnkleLabel.frame = CGRect(x: ankleButton.frame.maxX, y: (37 * y), width: (5 * x), height: (3 * y))
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
                    totalheightLabel.frame = CGRect(x: (2 * x), y: (1 * y), width: subView.frame.width - (11 * x), height: (2 * y))
                    totalheightLabel.text = "Height"
                    totalheightLabel.textColor = UIColor.black
                    totalheightLabel.textAlignment = .right
                    totalheightLabel.font = totalheightLabel.font.withSize(15)
                    totalheightLabel.tag = ((8 * 1) + 300)
                    subView.addSubview(totalheightLabel)
                    
                    let overAllHeightButton = UIButton()
                    overAllHeightButton.frame = CGRect(x: (2 * x), y: (1.5 * y), width: subView.frame.width - (8 * x), height: (3 * y))
                    overAllHeightButton.setImage(UIImage(named: "arrowMark1"), for: .normal)
//                    overAllHeightButton.backgroundColor = UIColor.red
                    overAllHeightButton.tag = 8
                    overAllHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(overAllHeightButton)
                    
                    gettotalheightLabel.frame = CGRect(x: overAllHeightButton.frame.maxX, y: (1.5 * y), width: (5 * x), height: (3 * y))
                    gettotalheightLabel.text = "0.0"
                    gettotalheightLabel.textColor = UIColor.blue
                    gettotalheightLabel.textAlignment = .center
                    gettotalheightLabel.font = gettotalheightLabel.font.withSize(15)
                    gettotalheightLabel.tag = ((8 * 1) + 200)
                    subView.addSubview(gettotalheightLabel)
                    
                    let hipHeightLabel = UILabel()
                    hipHeightLabel.frame = CGRect(x: (6.55 * x), y: (36.5 * y), width: subView.frame.width - (15.55  * x), height: (2 * y))
                    hipHeightLabel.text = "OutSeam"
                    hipHeightLabel.textColor = UIColor.black
                    hipHeightLabel.textAlignment = .right
                    hipHeightLabel.font = hipHeightLabel.font.withSize(15)
                    hipHeightLabel.tag = ((10 * 1) + 300)
                    subView.addSubview(hipHeightLabel)
                    
                    let hipHeightButton = UIButton()
                    hipHeightButton.frame = CGRect(x: (6.55 * x), y: (37 * y), width: subView.frame.width - (12.55 * x), height: (3 * y))
//                    hipHeightButton.backgroundColor = UIColor.red
                    hipHeightButton.setImage(UIImage(named: "arrowMark1"), for: .normal)
                    hipHeightButton.tag = 10
                    hipHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(hipHeightButton)
                    
                    getHipheightLabel.frame = CGRect(x: hipHeightButton.frame.maxX, y: (37 * y), width: (5 * x), height: (3 * y))
                    getHipheightLabel.text = "0.0"
                    getHipheightLabel.textColor = UIColor.blue
                    getHipheightLabel.textAlignment = .center
                    getHipheightLabel.font = getHipheightLabel.font.withSize(15)
                    getHipheightLabel.tag = ((10 * 1) + 200)
                    subView.addSubview(getHipheightLabel)
                    
                    let bottomheightLabel = UILabel()
                    bottomheightLabel.frame = CGRect(x: (8.75 * x), y: (33.5 * y), width: subView.frame.width - (18.75 * x), height: (2 * y))
                    bottomheightLabel.text = "InSeam"
                    bottomheightLabel.textColor = UIColor.black
                    bottomheightLabel.textAlignment = .right
                    bottomheightLabel.font = totalheightLabel.font.withSize(15)
                    bottomheightLabel.tag = ((11 * 1) + 300)
                    subView.addSubview(bottomheightLabel)
                    
                    let bottomHeightButton = UIButton()
                    bottomHeightButton.frame = CGRect(x: (8.75 * x), y: (34 * y), width: subView.frame.width - (14.75 * x), height: (3 * y))
//                    bottomHeightButton.backgroundColor = UIColor.red
                    bottomHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    bottomHeightButton.tag = 11
                    bottomHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(bottomHeightButton)
                    
                    getBottomheightLabel.frame = CGRect(x: bottomHeightButton.frame.maxX, y: (34 * y), width: (5 * x), height: (3 * y))
                    getBottomheightLabel.text = "0.0"
                    getBottomheightLabel.textColor = UIColor.blue
                    getBottomheightLabel.textAlignment = .center
                    getBottomheightLabel.font = getBottomheightLabel.font.withSize(15)
                    getBottomheightLabel.tag = ((11 * 1) + 200)
                    subView.addSubview(getBottomheightLabel)
                    
                    let kneeheightLabel = UILabel()
                    kneeheightLabel.frame = CGRect(x: (11.3 * x), y: (25.3 * y), width: subView.frame.width - (20.3 * x), height: (2 * y))
                    kneeheightLabel.text = "Shorts"
                    kneeheightLabel.textColor = UIColor.black
                    kneeheightLabel.textAlignment = .right
                    kneeheightLabel.font = totalheightLabel.font.withSize(15)
                    kneeheightLabel.tag = ((9 * 1) + 300)
                    subView.addSubview(kneeheightLabel)
                    
                    let kneeHeightButton = UIButton()
                    kneeHeightButton.frame = CGRect(x: (11.3 * x), y: (25.8 * y), width: subView.frame.width - (17.3 * x), height: (3 * y))
//                    kneeHeightButton.backgroundColor = UIColor.red
                    kneeHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    kneeHeightButton.tag = 9
                    kneeHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(kneeHeightButton)
                    
                    getKneeheightLabel.frame = CGRect(x: kneeHeightButton.frame.maxX, y: (25.8 * y), width: (5 * x), height: (3 * y))
                    getKneeheightLabel.text = "0.0"
                    getKneeheightLabel.textColor = UIColor.blue
                    getKneeheightLabel.textAlignment = .center
                    getKneeheightLabel.font = getKneeheightLabel.font.withSize(15)
                    getKneeheightLabel.tag = ((9 * 1) + 200)
                    subView.addSubview(getKneeheightLabel)
                }
                else if index == 2
                {
                    let shoulderLabel = UILabel()
                    shoulderLabel.frame = CGRect(x: (13.2 * x), y: (6.35 * y), width: subView.frame.width - (22.2 * x), height: (2 * y))
                    shoulderLabel.text = "Shoulder"
                    shoulderLabel.textColor = UIColor.black
                    shoulderLabel.textAlignment = .right
                    shoulderLabel.font = shoulderLabel.font.withSize(15)
                    shoulderLabel.tag = ((12 * 1) + 300)
                    subView.addSubview(shoulderLabel)
                    
                    let shoulderButton = UIButton()
                    shoulderButton.frame = CGRect(x: (13.2 * x), y: (6.85 * y), width: subView.frame.width - (19.2 * x), height: (3 * y))
//                    shoulderButton.backgroundColor = UIColor.red
                    shoulderButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    shoulderButton.tag = 12
                    shoulderButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(shoulderButton)
                    
                    getShoulderLabel.frame = CGRect(x: shoulderButton.frame.maxX, y: (6.85 * y), width: (5 * x), height: (3 * y))
                    getShoulderLabel.text = "0.0"
                    getShoulderLabel.textColor = UIColor.blue
                    getShoulderLabel.textAlignment = .center
                    getShoulderLabel.font = getShoulderLabel.font.withSize(15)
                    getShoulderLabel.tag = ((12 * 1) + 200)
                    subView.addSubview(getShoulderLabel)
                    
                    let sleeveLabel = UILabel()
                    sleeveLabel.frame = CGRect(x: (13.8 * x), y: (10 * y), width: subView.frame.width - (22.8 * x), height: (2 * y))
                    sleeveLabel.text = "HalfSleeve"
                    sleeveLabel.textColor = UIColor.black
                    sleeveLabel.textAlignment = .right
                    sleeveLabel.font = sleeveLabel.font.withSize(15)
                    sleeveLabel.tag = ((13 * 1) + 300)
                    subView.addSubview(sleeveLabel)
                    
                    let sleeveButton = UIButton()
                    sleeveButton.frame = CGRect(x: (13.8 * x), y: (10.5 * y), width: subView.frame.width - (19.8 * x), height: (3 * y))
//                    sleeveButton.backgroundColor = UIColor.red
                    sleeveButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    sleeveButton.tag = 13
                    sleeveButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(sleeveButton)
                    
                    getSleeveLabel.frame = CGRect(x: sleeveButton.frame.maxX, y: (10.5 * y), width: (5 * x), height: (3 * y))
                    getSleeveLabel.text = "0.0"
                    getSleeveLabel.textColor = UIColor.blue
                    getSleeveLabel.textAlignment = .center
                    getSleeveLabel.font = getSleeveLabel.font.withSize(15)
                    getSleeveLabel.tag = ((13 * 1) + 200)
                    subView.addSubview(getSleeveLabel)
                    
                    let bicepLabel = UILabel()
                    bicepLabel.frame = CGRect(x: (15 * x), y: (12.9 * y), width: subView.frame.width - (24 * x), height: (2 * y))
                    bicepLabel.text = "Bicep"
                    bicepLabel.textColor = UIColor.black
                    bicepLabel.textAlignment = .right
                    bicepLabel.font = bicepLabel.font.withSize(15)
                    bicepLabel.tag = ((14 * 1) + 300)
                    subView.addSubview(bicepLabel)
                    
                    let bicepButton = UIButton()
                    bicepButton.frame = CGRect(x: (15 * x), y: (13.4 * y), width: subView.frame.width - (21 * x), height: (3 * y))
//                    bicepButton.backgroundColor = UIColor.red
                    bicepButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    bicepButton.tag = 14
                    bicepButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(bicepButton)
                    
                    getBicepLabel.frame = CGRect(x: bicepButton.frame.maxX, y: (13.4 * y), width: (5 * x), height: (3 * y))
                    getBicepLabel.text = "0.0"
                    getBicepLabel.textColor = UIColor.blue
                    getBicepLabel.textAlignment = .center
                    getBicepLabel.font = getBicepLabel.font.withSize(15)
                    getBicepLabel.tag = ((14 * 1) + 200)
                    subView.addSubview(getBicepLabel)
                    
                    let hipLabel = UILabel()
                    hipLabel.frame = CGRect(x: (12 * x), y: (15.3 * y), width: subView.frame.width - (21 * x), height: (2 * y))
                    hipLabel.text = "Hipbone"
                    hipLabel.textColor = UIColor.black
                    hipLabel.textAlignment = .right
                    hipLabel.font = hipLabel.font.withSize(15)
                    hipLabel.tag = ((15 * 1) + 300)
                    subView.addSubview(hipLabel)
                    
                    let hipButton = UIButton()
                    hipButton.frame = CGRect(x: (12 * x), y: (15.8 * y), width: subView.frame.width - (18 * x), height: (3 * y))
                    hipButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    hipButton.tag = 15
                    hipButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(hipButton)
                    
                    getHipLabel.frame = CGRect(x: hipButton.frame.maxX, y: (15.8 * y), width: (5 * x), height: (3 * y))
                    getHipLabel.text = "0.0"
                    getHipLabel.textColor = UIColor.blue
                    getHipLabel.textAlignment = .center
                    getHipLabel.font = getHipLabel.font.withSize(15)
                    getHipLabel.tag = ((15 * 1) + 200)
                    subView.addSubview(getHipLabel)
                    
                    let backLabel = UILabel()
                    backLabel.frame = CGRect(x: (12.5 * x), y: (18.7 * y), width: subView.frame.width - (21.5 * x), height: (2 * y))
                    backLabel.text = "Bottom"
                    backLabel.textColor = UIColor.black
                    backLabel.textAlignment = .right
                    backLabel.font = backLabel.font.withSize(15)
                    backLabel.tag = ((16 * 1) + 300)
                    subView.addSubview(backLabel)
                    
                    let backButton = UIButton()
                    backButton.frame = CGRect(x: (12.5 * x), y: (19.2 * y), width: subView.frame.width - (18.5 * x), height: (3 * y))
                    backButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    backButton.tag = 16
                    backButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(backButton)
                    
                    getBackLabel.frame = CGRect(x: backButton.frame.maxX, y: (19.2 * y), width: (5 * x), height: (3 * y))
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
                    heightLabel.frame = CGRect(x: (9.4 * x), y: (9 * y), width: subView.frame.width - (18.4 * x), height: (2 * y))
                    heightLabel.text = "Top Length"
                    heightLabel.textColor = UIColor.black
                    heightLabel.textAlignment = .right
                    heightLabel.font = heightLabel.font.withSize(15)
                    heightLabel.tag = ((17 * 1) + 300)
                    subView.addSubview(heightLabel)
                    
                    let heightButton = UIButton()
                    heightButton.frame = CGRect(x: (9.4 * x), y: (9.5 * y), width: subView.frame.width - (15.4 * x), height: (3 * y))
//                    heightButton.backgroundColor = UIColor.red
                    heightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    heightButton.tag = 17
                    heightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(heightButton)
                    
                    getHeightLabel.frame = CGRect(x: heightButton.frame.maxX, y: (9.5 * y), width: (5 * x), height: (3 * y))
                    getHeightLabel.text = "0.0"
                    getHeightLabel.textColor = UIColor.blue
                    getHeightLabel.textAlignment = .center
                    getHeightLabel.font = getHeightLabel.font.withSize(15)
                    getHeightLabel.tag = ((17 * 1) + 200)
                    subView.addSubview(getHeightLabel)
                    
                    let fullSleeveLabel = UILabel()
                    fullSleeveLabel.frame = CGRect(x: (14 * x), y: (13.5 * y), width: subView.frame.width - (23 * x), height: (2 * y))
                    fullSleeveLabel.text = "Sleeve"
                    fullSleeveLabel.textColor = UIColor.black
                    fullSleeveLabel.textAlignment = .right
                    fullSleeveLabel.font = heightLabel.font.withSize(15)
                    fullSleeveLabel.tag = ((18 * 1) + 300)
                    subView.addSubview(fullSleeveLabel)
                    
                    let fullSleeveButton = UIButton()
                    fullSleeveButton.frame = CGRect(x: (14 * x), y: (14 * y), width: subView.frame.width - (20 * x), height: (3 * y))
//                    fullSleeveButton.backgroundColor = UIColor.red
                    fullSleeveButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    fullSleeveButton.tag = 18
                    fullSleeveButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(fullSleeveButton)
                    
                    getFullSleeveLabel.frame = CGRect(x: fullSleeveButton.frame.maxX, y: (14 * y), width: (5 * x), height: (3 * y))
                    getFullSleeveLabel.text = "0.0"
                    getFullSleeveLabel.textColor = UIColor.blue
                    getFullSleeveLabel.textAlignment = .center
                    getFullSleeveLabel.font = getFullSleeveLabel.font.withSize(15)
                    getFullSleeveLabel.tag = ((18 * 1) + 200)
                    subView.addSubview(getFullSleeveLabel)
                    
                    let handKneeLabel = UILabel()
                    handKneeLabel.frame = CGRect(x: (14.5 * x), y: (17.9 * y), width: subView.frame.width - (23.5 * x), height: (2 * y))
                    handKneeLabel.text = "Wrist"
                    handKneeLabel.textColor = UIColor.black
                    handKneeLabel.textAlignment = .right
                    handKneeLabel.font = handKneeLabel.font.withSize(15)
                    handKneeLabel.tag = ((19 * 1) + 300)
                    subView.addSubview(handKneeLabel)
                    
                    let handKneeButton = UIButton()
                    handKneeButton.frame = CGRect(x: (14.5 * x), y: (18.6 * y), width: subView.frame.width - (20.5 * x), height: (3 * y))
                    handKneeButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    handKneeButton.tag = 19
                    handKneeButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(handKneeButton)
                    
                    getHandKneeLabel.frame = CGRect(x: handKneeButton.frame.maxX, y: (18.6 * y), width: (5 * x), height: (3 * y))
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
            else if gender == "Female" || gender == "انثى"
            {
                if index == 0
                {
                    let headLabel = UILabel()
                    headLabel.frame = CGRect(x: (10.5 * x), y: y, width: subView.frame.width - (19.5 * x), height: (2 * y))
                    headLabel.text = "Head"
                    headLabel.textColor = UIColor.black
                    headLabel.textAlignment = .right
                    headLabel.font = headLabel.font.withSize(15)
                    headLabel.tag = ((20 * 1) + 300)
                    subView.addSubview(headLabel)
                    
                    let headButton = UIButton()
                    headButton.frame = CGRect(x: (10.5 * x), y: (1.5 * y), width: subView.frame.width - (16.5 * x), height: (3 * y))
                    headButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    headButton.tag = 20
                    headButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(headButton)
                    
                    getHeadLabel.frame = CGRect(x: headButton.frame.maxX, y: (1.5 * y), width: (5 * x), height: (3 * y))
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
                    getHeadLabel.font = getHeadLabel.font.withSize(15)
                    getHeadLabel.tag = ((20 * 1) + 200)
                    subView.addSubview(getHeadLabel)
                    
                    let overBustLabel = UILabel()
                    overBustLabel.frame = CGRect(x: (11.8 * x), y: (9.1 * y), width: subView.frame.width - (20.8 * x), height: (2 * y))
                    overBustLabel.text = "OverBust"
                    overBustLabel.textColor = UIColor.black
                    overBustLabel.textAlignment = .right
                    overBustLabel.font = overBustLabel.font.withSize(15)
                    overBustLabel.tag = ((21 * 1) + 300)
                    subView.addSubview(overBustLabel)
                    
                    let overBustButton = UIButton()
                    overBustButton.frame = CGRect(x: (11.8 * x), y: (9.6 * y), width: subView.frame.width - (17.8 * x), height: (3 * y))
                    overBustButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    overBustButton.tag = 21
                    overBustButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(overBustButton)
                    
                    let getOverBustLabel = UILabel()
                    getOverBustLabel.frame = CGRect(x: overBustButton.frame.maxX, y: (9.6 * y), width: (5 * x), height: (3 * y))
                    getOverBustLabel.text = "0.0"
                    getOverBustLabel.textColor = UIColor.blue
                    getOverBustLabel.textAlignment = .center
                    getOverBustLabel.font = getOverBustLabel.font.withSize(15)
                    getOverBustLabel.tag = ((21 * 1) + 200)
                    subView.addSubview(getOverBustLabel)
                    
                    let underBustLabel = UILabel()
                    underBustLabel.frame = CGRect(x: (11.6 * x), y: (12 * y), width: subView.frame.width - (20.6 * x), height: (2 * y))
                    underBustLabel.text = "Underbust"
                    underBustLabel.textColor = UIColor.black
                    underBustLabel.textAlignment = .right
                    underBustLabel.font = underBustLabel.font.withSize(15)
                    underBustLabel.tag = ((22 * 1) + 300)
                    subView.addSubview(underBustLabel)
                    
                    let underBustButton = UIButton()
                    underBustButton.frame = CGRect(x: (11.6 * x), y: (12.5 * y), width: subView.frame.width - (17.6 * x), height: (3 * y))
                    underBustButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    underBustButton.tag = 22
                    underBustButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(underBustButton)
                    
                    let getUnderBustLabel = UILabel()
                    getUnderBustLabel.frame = CGRect(x: underBustButton.frame.maxX, y: (12.5 * y), width: (5 * x), height: (3 * y))
                    getUnderBustLabel.text = "0.0"
                    getUnderBustLabel.textColor = UIColor.blue
                    getUnderBustLabel.textAlignment = .center
                    getUnderBustLabel.font = getUnderBustLabel.font.withSize(15)
                    getUnderBustLabel.tag = ((22 * 1) + 200)
                    subView.addSubview(getUnderBustLabel)
                    
                    let hipBoneLabel = UILabel()
                    hipBoneLabel.frame = CGRect(x: (11.7 * x), y: (15 * y), width: subView.frame.width - (20.7 * x), height: (2 * y))
                    hipBoneLabel.text = "Hip Bone"
                    hipBoneLabel.textColor = UIColor.black
                    hipBoneLabel.textAlignment = .right
                    hipBoneLabel.font = hipBoneLabel.font.withSize(15)
                    hipBoneLabel.tag = ((23 * 1) + 300)
                    subView.addSubview(hipBoneLabel)
                    
                    let hipBoneButton = UIButton()
                    hipBoneButton.frame = CGRect(x: (11.7 * x), y: (15.5 * y), width: subView.frame.width - (17.7 * x), height: (3 * y))
                    hipBoneButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    hipBoneButton.tag = 23
                    hipBoneButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(hipBoneButton)
                    
                    let getHipBoneLabel = UILabel()
                    getHipBoneLabel.frame = CGRect(x: hipBoneButton.frame.maxX, y: (15.5 * y), width: (5 * x), height: (3 * y))
                    getHipBoneLabel.text = "0.0"
                    getHipBoneLabel.textColor = UIColor.blue
                    getHipBoneLabel.textAlignment = .center
                    getHipBoneLabel.font = getHipBoneLabel.font.withSize(15)
                    getHipBoneLabel.tag = ((23 * 1) + 200)
                    subView.addSubview(getHipBoneLabel)
                    
                    let thighLabel = UILabel()
                    thighLabel.frame = CGRect(x: (13 * x), y: (21.6 * y), width: subView.frame.width - (22 * x), height: (2 * y))
                    thighLabel.text = "Thigh"
                    thighLabel.textColor = UIColor.black
                    thighLabel.textAlignment = .right
                    thighLabel.font = headLabel.font.withSize(15)
                    thighLabel.tag = ((24 * 1) + 300)
                    subView.addSubview(thighLabel)
                    
                    let thighButton = UIButton()
                    thighButton.frame = CGRect(x: (13 * x), y: (22.1 * y), width: subView.frame.width - (19 * x), height: (3 * y))
                    thighButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    thighButton.tag = 24
                    thighButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(thighButton)
                    
                    getThighLabel.frame = CGRect(x: thighButton.frame.maxX, y: (22.1 * y), width: (5 * x), height: (3 * y))
                    getThighLabel.text = "0.0"
                    getThighLabel.textColor = UIColor.blue
                    getThighLabel.textAlignment = .center
                    getThighLabel.font = headLabel.font.withSize(15)
                    getThighLabel.tag = ((24 * 1) + 200)
                    subView.addSubview(getThighLabel)
                    
                    let kneeLabel = UILabel()
                    kneeLabel.frame = CGRect(x: (11.5 * x), y: (27.2 * y), width: subView.frame.width - (20.5 * x), height: (2 * y))
                    kneeLabel.text = "Knee"
                    kneeLabel.textColor = UIColor.black
                    kneeLabel.textAlignment = .right
                    kneeLabel.font = headLabel.font.withSize(15)
                    kneeLabel.tag = ((25 * 1) + 300)
                    subView.addSubview(kneeLabel)
                    
                    let kneeButton = UIButton()
                    kneeButton.frame = CGRect(x: (11.5 * x), y: (27.7 * y), width: subView.frame.width - (17.5 * x), height: (3 * y))
                    kneeButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    kneeButton.tag = 25
                    kneeButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(kneeButton)
                    
                    getKneeLabel.frame = CGRect(x: kneeButton.frame.maxX, y: (27.7 * y), width: (5 * x), height: (3 * y))
                    getKneeLabel.text = "0.0"
                    getKneeLabel.textColor = UIColor.blue
                    getKneeLabel.textAlignment = .center
                    getKneeLabel.font = headLabel.font.withSize(15)
                    getKneeLabel.tag = ((25 * 1) + 200)
                    subView.addSubview(getKneeLabel)
                    
                    let calfLabel = UILabel()
                    calfLabel.frame = CGRect(x: (11.7 * x), y: (30.8 * y), width: subView.frame.width - (20.7 * x), height: (2 * y))
                    calfLabel.text = "Calf"
                    calfLabel.textColor = UIColor.black
                    calfLabel.textAlignment = .right
                    calfLabel.font = headLabel.font.withSize(15)
                    calfLabel.tag = ((26 * 1) + 300)
                    subView.addSubview(calfLabel)
                    
                    let calfButton = UIButton()
                    calfButton.frame = CGRect(x: (11.7 * x), y: (31.3 * y), width: subView.frame.width - (17.7 * x), height: (3 * y))
                    calfButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    calfButton.tag = 26
                    calfButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(calfButton)
                    
                    let getCalfLabel = UILabel()
                    getCalfLabel.frame = CGRect(x: calfButton.frame.maxX, y: (31.3 * y), width: (5 * x), height: (3 * y))
                    getCalfLabel.text = "0.0"
                    getCalfLabel.textColor = UIColor.blue
                    getCalfLabel.textAlignment = .center
                    getCalfLabel.font = headLabel.font.withSize(15)
                    getCalfLabel.tag = ((26 * 1) + 200)
                    subView.addSubview(getCalfLabel)
                    
                    let ankleLabel = UILabel()
                    ankleLabel.frame = CGRect(x: (10.5 * x), y: (35.8 * y), width: subView.frame.width - (19.5 * x), height: (2 * y))
                    ankleLabel.text = "Ankle"
                    ankleLabel.textColor = UIColor.black
                    ankleLabel.textAlignment = .right
                    ankleLabel.font = headLabel.font.withSize(15)
                    ankleLabel.tag = ((27 * 1) + 300)
                    subView.addSubview(ankleLabel)
                    
                    let ankleButton = UIButton()
                    ankleButton.frame = CGRect(x: (10.5 * x), y: (36.3 * y), width: subView.frame.width - (16.5 * x), height: (3 * y))
                    ankleButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    ankleButton.tag = 27
                    ankleButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(ankleButton)
                    
                    getAnkleLabel.frame = CGRect(x: ankleButton.frame.maxX, y: (36.3 * y), width: (5 * x), height: (3 * y))
                    getAnkleLabel.text = "0.0"
                    getAnkleLabel.textColor = UIColor.blue
                    getAnkleLabel.textAlignment = .center
                    getAnkleLabel.font = headLabel.font.withSize(15)
                    getAnkleLabel.tag = ((27 * 1) + 200)
                    subView.addSubview(getAnkleLabel)
                }
                else if index == 1
                {
                    let neckLabel = UILabel()
                    neckLabel.frame = CGRect(x: (10 * x), y: (5.8 * y), width: subView.frame.width - (19 * x), height: (2 * y))
                    neckLabel.text = "Neck"
                    neckLabel.textColor = UIColor.black
                    neckLabel.textAlignment = .right
                    neckLabel.font = neckLabel.font.withSize(15)
                    neckLabel.tag = ((28 * 1) + 300)
                    subView.addSubview(neckLabel)
                    
                    let neckButton = UIButton()
                    neckButton.frame = CGRect(x: (10 * x), y: (6.3 * y), width: subView.frame.width - (16 * x), height: (3 * y))
//                    neckButton.backgroundColor = UIColor.red
                    neckButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    neckButton.tag = 28
                    neckButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(neckButton)
                    
                    getNeckLabel.frame = CGRect(x: neckButton.frame.maxX, y: (6.3 * y), width: (5 * x), height: (3 * y))
                    getNeckLabel.text = "0.0"
                    getNeckLabel.textColor = UIColor.blue
                    getNeckLabel.textAlignment = .center
                    getNeckLabel.font = getNeckLabel.font.withSize(15)
                    getNeckLabel.tag = ((28 * 1) + 200)
                    subView.addSubview(getNeckLabel)
                    
                    let bustLabel = UILabel()
                    bustLabel.frame = CGRect(x: (12 * x), y: (10.2 * y), width: subView.frame.width - (21 * x), height: (2 * y))
                    bustLabel.text = "Bust"
                    bustLabel.textColor = UIColor.black
                    bustLabel.textAlignment = .right
                    bustLabel.font = bustLabel.font.withSize(15)
                    bustLabel.tag = ((29 * 1) + 300)
                    subView.addSubview(bustLabel)
                    
                    let bustButton = UIButton()
                    bustButton.frame = CGRect(x: (12 * x), y: (10.7 * y), width: subView.frame.width - (18 * x), height: (3 * y))
//                    bustButton.backgroundColor = UIColor.red
                    bustButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    bustButton.tag = 29
                    bustButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(bustButton)
                    
                    let getBustLabel = UILabel()
                    getBustLabel.frame = CGRect(x: bustButton.frame.maxX, y: (10.7 * y), width: (5 * x), height: (3 * y))
                    getBustLabel.text = "0.0"
                    getBustLabel.textColor = UIColor.blue
                    getBustLabel.textAlignment = .center
                    getBustLabel.font = getBustLabel.font.withSize(15)
                    getBustLabel.tag = ((29 * 1) + 200)
                    subView.addSubview(getBustLabel)
                    
                    let waistLabel = UILabel()
                    waistLabel.frame = CGRect(x: (11.5 * x), y: (13 * y), width: subView.frame.width - (20.5 * x), height: (2 * y))
                    waistLabel.text = "Waist"
                    waistLabel.textColor = UIColor.black
                    waistLabel.textAlignment = .right
                    waistLabel.font = waistLabel.font.withSize(15)
                    waistLabel.tag = ((30 * 1) + 300)
                    subView.addSubview(waistLabel)
                    
                    let waistButton = UIButton()
                    waistButton.frame = CGRect(x: (11.5 * x), y: (13.5 * y), width: subView.frame.width - (17.5 * x), height: (3 * y))
                    waistButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    waistButton.tag = 30
                    waistButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(waistButton)
                    
                    getWaistLabel.frame = CGRect(x: waistButton.frame.maxX, y: (13.5 * y), width: (5 * x), height: (3 * y))
                    getWaistLabel.text = "0.0"
                    getWaistLabel.textColor = UIColor.blue
                    getWaistLabel.textAlignment = .center
                    getWaistLabel.font = getBicepLabel.font.withSize(15)
                    getWaistLabel.tag = ((30 * 1) + 200)
                    subView.addSubview(getWaistLabel)
                    
                    let fullHipLabel = UILabel()
                    fullHipLabel.frame = CGRect(x: (12.8 * x), y: (18.5 * y), width: subView.frame.width - (21.8 * x), height: (2 * y))
                    fullHipLabel.text = "Full Hip"
                    fullHipLabel.textColor = UIColor.black
                    fullHipLabel.textAlignment = .right
                    fullHipLabel.font = fullHipLabel.font.withSize(15)
                    fullHipLabel.tag = ((31 * 1) + 300)
                    subView.addSubview(fullHipLabel)
                    
                    let fullHipButton = UIButton()
                    fullHipButton.frame = CGRect(x: (12.8 * x), y: (19 * y), width: subView.frame.width - (18.8 * x), height: (3 * y))
                    fullHipButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    fullHipButton.tag = 31
                    fullHipButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(fullHipButton)
                    
                    let getFullHipLabel = UILabel()
                    getFullHipLabel.frame = CGRect(x: fullHipButton.frame.maxX, y: (19 * y), width: (5 * x), height: (3 * y))
                    getFullHipLabel.text = "0.0"
                    getFullHipLabel.textColor = UIColor.blue
                    getFullHipLabel.textAlignment = .center
                    getFullHipLabel.font = getBackLabel.font.withSize(15)
                    getFullHipLabel.tag = ((31 * 1) + 200)
                    subView.addSubview(getFullHipLabel)
                }
                else if index == 2
                {
                    let totalheightLabel = UILabel()
                    totalheightLabel.frame = CGRect(x: (2 * x), y: y, width: subView.frame.width - (11 * x), height: (2 * y))
                    totalheightLabel.text = "Over all height"
                    totalheightLabel.textColor = UIColor.black
                    totalheightLabel.textAlignment = .right
                    totalheightLabel.font = totalheightLabel.font.withSize(15)
                    totalheightLabel.tag = ((32 * 1) + 300)
                    subView.addSubview(totalheightLabel)
                    
                    let totalHeightButton = UIButton()
                    totalHeightButton.frame = CGRect(x: (2 * x), y: (1.5 * y), width: subView.frame.width - (8 * x), height: (3 * y))
//                    totalHeightButton.backgroundColor = UIColor.red
                    totalHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    totalHeightButton.tag = 32
                    totalHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(totalHeightButton)
                    
                    gettotalheightLabel.frame = CGRect(x: totalHeightButton.frame.maxX, y: (1.5 * y), width: (5 * x), height: (3 * y))
                    gettotalheightLabel.text = "0.0"
                    gettotalheightLabel.textColor = UIColor.blue
                    gettotalheightLabel.textAlignment = .center
                    gettotalheightLabel.font = gettotalheightLabel.font.withSize(15)
                    gettotalheightLabel.tag = ((32 * 1) + 200)
                    subView.addSubview(gettotalheightLabel)
                    
                    let stwHeightLabel = UILabel()
                    stwHeightLabel.frame = CGRect(x: (11.3 * x), y: (6.5 * y), width: subView.frame.width - (20.3 * x), height: (2 * y))
                    stwHeightLabel.text = "STW"
                    stwHeightLabel.textColor = UIColor.black
                    stwHeightLabel.textAlignment = .right
                    stwHeightLabel.font = stwHeightLabel.font.withSize(15)
                    stwHeightLabel.tag = ((33 * 1) + 300)
                    subView.addSubview(stwHeightLabel)
                    
                    let stwHeigtButton = UIButton()
                    stwHeigtButton.frame = CGRect(x: (11.3 * x), y: (7 * y), width: subView.frame.width - (17.3 * x), height: (3 * y))
//                    stwHeigtButton.backgroundColor = UIColor.red
                    stwHeigtButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    stwHeigtButton.tag = 33
                    stwHeigtButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(stwHeigtButton)
                    
                    let getstwHeightLabel = UILabel()
                    getstwHeightLabel.frame = CGRect(x: stwHeigtButton.frame.maxX, y: (7 * y), width: (5 * x), height: (3 * y))
                    getstwHeightLabel.text = "0.0"
                    getstwHeightLabel.textColor = UIColor.blue
                    getstwHeightLabel.textAlignment = .center
                    getstwHeightLabel.font = getstwHeightLabel.font.withSize(15)
                    getstwHeightLabel.tag = ((33 * 1) + 200)
                    subView.addSubview(getstwHeightLabel)
                    
                    let nltcHeightLabel = UILabel()
                    nltcHeightLabel.frame = CGRect(x: (7.7 * x), y: (8.5 * y), width: subView.frame.width - (16.7 * x), height: (2 * y))
                    nltcHeightLabel.text = "NLTC"
                    nltcHeightLabel.textColor = UIColor.black
                    nltcHeightLabel.textAlignment = .right
                    nltcHeightLabel.font = totalheightLabel.font.withSize(15)
                    nltcHeightLabel.tag = ((34 * 1) + 300)
                    subView.addSubview(nltcHeightLabel)
                    
                    let nltcHeigtButton = UIButton()
                    nltcHeigtButton.frame = CGRect(x: (7.7 * x), y: (9 * y), width: subView.frame.width - (13.7 * x), height: (3 * y))
                    nltcHeigtButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    nltcHeigtButton.tag = 34
                    nltcHeigtButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(nltcHeigtButton)
                    
                    let getnltcHeightLabel = UILabel()
                    getnltcHeightLabel.frame = CGRect(x: nltcHeigtButton.frame.maxX, y: (9 * y), width: (5 * x), height: (3 * y))
                    getnltcHeightLabel.text = "0.0"
                    getnltcHeightLabel.textColor = UIColor.blue
                    getnltcHeightLabel.textAlignment = .center
                    getnltcHeightLabel.font = getnltcHeightLabel.font.withSize(15)
                    getnltcHeightLabel.tag = ((34 * 1) + 200)
                    subView.addSubview(getnltcHeightLabel)
                    
                    let nltbHeightLabel = UILabel()
                    nltbHeightLabel.frame = CGRect(x: (8.5 * x), y: (11 * y), width: subView.frame.width - (17.5 * x), height: (2 * y))
                    nltbHeightLabel.text = "NLTB"
                    nltbHeightLabel.textColor = UIColor.black
                    nltbHeightLabel.textAlignment = .right
                    nltbHeightLabel.font = totalheightLabel.font.withSize(15)
                    nltbHeightLabel.tag = ((35 * 1) + 300)
                    subView.addSubview(nltbHeightLabel)
                    
                    let nltbHeigtButton = UIButton()
                    nltbHeigtButton.frame = CGRect(x: (8.5 * x), y: (11.5 * y), width: subView.frame.width - (14.5 * x), height: (3 * y))
                    nltbHeigtButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    nltbHeigtButton.tag = 35
                    nltbHeigtButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(nltbHeigtButton)
                    
                    let getnltbHeightLabel = UILabel()
                    getnltbHeightLabel.frame = CGRect(x: nltbHeigtButton.frame.maxX, y: (11.5 * y), width: (5 * x), height: (3 * y))
                    getnltbHeightLabel.text = "0.0"
                    getnltbHeightLabel.textColor = UIColor.blue
                    getnltbHeightLabel.textAlignment = .center
                    getnltbHeightLabel.font = getnltbHeightLabel.font.withSize(15)
                    getnltbHeightLabel.tag = ((35 * 1) + 200)
                    subView.addSubview(getnltbHeightLabel)
                    
                    let sthbHeightLabel = UILabel()
                    sthbHeightLabel.frame = CGRect(x: (10 * x), y: (13 * y), width: subView.frame.width - (19 * x), height: (2 * y))
                    sthbHeightLabel.text = "STHB"
                    sthbHeightLabel.textColor = UIColor.black
                    sthbHeightLabel.textAlignment = .right
                    sthbHeightLabel.font = totalheightLabel.font.withSize(15)
                    sthbHeightLabel.tag = ((36 * 1) + 300)
                    subView.addSubview(sthbHeightLabel)
                    
                    let sthbHeigtButton = UIButton()
                    sthbHeigtButton.frame = CGRect(x: (10 * x), y: (13.5 * y), width: subView.frame.width - (16 * x), height: (3 * y))
                    sthbHeigtButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    sthbHeigtButton.tag = 36
                    sthbHeigtButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(sthbHeigtButton)
                    
                    let getsthbHeightLabel = UILabel()
                    getsthbHeightLabel.frame = CGRect(x: sthbHeigtButton.frame.maxX, y: (13.5 * y), width: (5 * x), height: (3 * y))
                    getsthbHeightLabel.text = "0.0"
                    getsthbHeightLabel.textColor = UIColor.blue
                    getsthbHeightLabel.textAlignment = .center
                    getsthbHeightLabel.font = getsthbHeightLabel.font.withSize(15)
                    getsthbHeightLabel.tag = ((36 * 1) + 200)
                    subView.addSubview(getsthbHeightLabel)
                    
                    let wthbHeightLabel = UILabel()
                    wthbHeightLabel.frame = CGRect(x: (6.7 * x), y: (15.5 * y), width: subView.frame.width - (15.7 * x), height: (2 * y))
                    wthbHeightLabel.text = "WTHB"
                    wthbHeightLabel.textColor = UIColor.black
                    wthbHeightLabel.textAlignment = .right
                    wthbHeightLabel.font = wthbHeightLabel.font.withSize(15)
                    wthbHeightLabel.tag = ((37 * 1) + 300)
                    subView.addSubview(wthbHeightLabel)
                    
                    let wthbHeigtButton = UIButton()
                    wthbHeigtButton.frame = CGRect(x: (6.7 * x), y: (16 * y), width: subView.frame.width - (12.7 * x), height: (3 * y))
                    wthbHeigtButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    wthbHeigtButton.tag = 37
                    wthbHeigtButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(wthbHeigtButton)
                    
                    let getwthbHeightLabel = UILabel()
                    getwthbHeightLabel.frame = CGRect(x: wthbHeigtButton.frame.maxX, y: (16 * y), width: (5 * x), height: (3 * y))
                    getwthbHeightLabel.text = "0.0"
                    getwthbHeightLabel.textColor = UIColor.blue
                    getwthbHeightLabel.textAlignment = .center
                    getwthbHeightLabel.font = getwthbHeightLabel.font.withSize(15)
                    getwthbHeightLabel.tag = ((37 * 1) + 200)
                    subView.addSubview(getwthbHeightLabel)
                    
                    let hthheightLabel = UILabel()
                    hthheightLabel.frame = CGRect(x: (10.7 * x), y: (23.5 * y), width: subView.frame.width - (19.7 * x), height: (2 * y))
                    hthheightLabel.text = "HTH"
                    hthheightLabel.textColor = UIColor.black
                    hthheightLabel.textAlignment = .right
                    hthheightLabel.font = hthheightLabel.font.withSize(15)
                    hthheightLabel.tag = ((38 * 1) + 300)
                    subView.addSubview(hthheightLabel)
                    
                    let hthHeightButton = UIButton()
                    hthHeightButton.frame = CGRect(x: (10.7 * x), y: (24 * y), width: subView.frame.width - (16.7 * x), height: (3 * y))
                    hthHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    hthHeightButton.tag = 38
                    hthHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(hthHeightButton)
                    
                    let geththHeightLabel = UILabel()
                    geththHeightLabel.frame = CGRect(x: hthHeightButton.frame.maxX, y: (24 * y), width: (5 * x), height: (3 * y))
                    geththHeightLabel.text = "0.0"
                    geththHeightLabel.textColor = UIColor.blue
                    geththHeightLabel.textAlignment = .center
                    geththHeightLabel.font = geththHeightLabel.font.withSize(15)
                    geththHeightLabel.tag = ((38 * 1) + 200)
                    subView.addSubview(geththHeightLabel)
                    
                    let inseamheightLabel = UILabel()
                    inseamheightLabel.frame = CGRect(x: (8.1 * x), y: (30 * y), width: subView.frame.width - (17.1 * x), height: (2 * y))
                    inseamheightLabel.text = "INSEAM"
                    inseamheightLabel.textColor = UIColor.black
                    inseamheightLabel.textAlignment = .right
                    inseamheightLabel.font = inseamheightLabel.font.withSize(15)
                    inseamheightLabel.tag = ((39 * 1) + 300)
                    subView.addSubview(inseamheightLabel)
                    
                    let inseamHeightButton = UIButton()
                    inseamHeightButton.frame = CGRect(x: (8.1 * x), y: (30.5 * y), width: subView.frame.width - (14.1 * x), height: (3 * y))
                    inseamHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    inseamHeightButton.tag = 39
                    inseamHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(inseamHeightButton)
                    
                    let getinseamHeightLabel = UILabel()
                    getinseamHeightLabel.frame = CGRect(x: inseamHeightButton.frame.maxX, y: (30.5 * y), width: (5 * x), height: (3 * y))
                    getinseamHeightLabel.text = "0.0"
                    getinseamHeightLabel.textColor = UIColor.blue
                    getinseamHeightLabel.textAlignment = .center
                    getinseamHeightLabel.font = getinseamHeightLabel.font.withSize(15)
                    getinseamHeightLabel.tag = ((39 * 1) + 200)
                    subView.addSubview(getinseamHeightLabel)
                    
                    let outSteamHeightLabel = UILabel()
                    outSteamHeightLabel.frame = CGRect(x: (7.5 * x), y: (33 * y), width: subView.frame.width - (16.5 * x), height: (2 * y))
                    outSteamHeightLabel.text = "OUTSTEAM"
                    outSteamHeightLabel.textColor = UIColor.black
                    outSteamHeightLabel.textAlignment = .right
                    outSteamHeightLabel.font = outSteamHeightLabel.font.withSize(15)
                    outSteamHeightLabel.tag = ((40 * 1) + 300)
                    subView.addSubview(outSteamHeightLabel)
                    
                    let outSteamHeightButton = UIButton()
                    outSteamHeightButton.frame = CGRect(x: (7.5 * x), y: (33.5 * y), width: subView.frame.width - (13.5 * x), height: (3 * y))
                    outSteamHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    outSteamHeightButton.tag = 40
                    outSteamHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(outSteamHeightButton)
                    
                    let getoutSteamHeightLabel = UILabel()
                    getoutSteamHeightLabel.frame = CGRect(x: outSteamHeightButton.frame.maxX, y: (33.5 * y), width: (5 * x), height: (3 * y))
                    getoutSteamHeightLabel.text = "0.0"
                    getoutSteamHeightLabel.textColor = UIColor.blue
                    getoutSteamHeightLabel.textAlignment = .center
                    getoutSteamHeightLabel.font = getoutSteamHeightLabel.font.withSize(15)
                    getoutSteamHeightLabel.tag = ((40 * 1) + 200)
                    subView.addSubview(getoutSteamHeightLabel)
                }
                else if index == 3
                {
                    let shoulderLabel = UILabel()
                    shoulderLabel.frame = CGRect(x: (13.1 * x), y: (6.7 * y), width: subView.frame.width - (22.1 * x), height: (2 * y))
                    shoulderLabel.text = "Shoulder"
                    shoulderLabel.textColor = UIColor.black
                    shoulderLabel.textAlignment = .right
                    shoulderLabel.font = shoulderLabel.font.withSize(15)
                    shoulderLabel.tag = ((41 * 1) + 300)
                    subView.addSubview(shoulderLabel)
                    
                    let shoulderButton = UIButton()
                    shoulderButton.frame = CGRect(x: (13.1 * x), y: (7.2 * y), width: subView.frame.width - (19.1 * x), height: (3 * y))
                    shoulderButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    shoulderButton.tag = 41
                    shoulderButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(shoulderButton)
                    
                    getShoulderLabel.frame = CGRect(x: shoulderButton.frame.maxX, y: (7.2 * y), width: (5 * x), height: (3 * y))
                    getShoulderLabel.text = "0.0"
                    getShoulderLabel.textColor = UIColor.blue
                    getShoulderLabel.textAlignment = .center
                    getShoulderLabel.font = getHeightLabel.font.withSize(15)
                    getShoulderLabel.tag = ((41 * 1) + 200)
                    subView.addSubview(getShoulderLabel)
                    
                    let bicepLabel = UILabel()
                    bicepLabel.frame = CGRect(x: (13.7 * x), y: (10.8 * y), width: subView.frame.width - (22.7 * x), height: (2 * y))
                    bicepLabel.text = "Bicep"
                    bicepLabel.textColor = UIColor.black
                    bicepLabel.textAlignment = .right
                    bicepLabel.font = bicepLabel.font.withSize(15)
                    bicepLabel.tag = ((42 * 1) + 300)
                    subView.addSubview(bicepLabel)
                    
                    let bicepButton = UIButton()
                    bicepButton.frame = CGRect(x: (13.7 * x), y: (11.3 * y), width: subView.frame.width - (19.7 * x), height: (3 * y))
                    bicepButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    bicepButton.tag = 42
                    bicepButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(bicepButton)
                    
                    getBicepLabel.frame = CGRect(x: bicepButton.frame.maxX, y: (11.3 * y), width: (5 * x), height: (3 * y))
                    getBicepLabel.text = "0.0"
                    getBicepLabel.textColor = UIColor.blue
                    getBicepLabel.textAlignment = .center
                    getBicepLabel.font = getFullSleeveLabel.font.withSize(15)
                    getBicepLabel.tag = ((42 * 1) + 200)
                    subView.addSubview(getBicepLabel)
                    
                    let handKneeLabel = UILabel()
                    handKneeLabel.frame = CGRect(x: (15 * x), y: (18.3 * y), width: subView.frame.width - (24 * x), height: (2 * y))
                    handKneeLabel.text = "Hand Cuf"
                    handKneeLabel.textColor = UIColor.black
                    handKneeLabel.textAlignment = .right
                    handKneeLabel.font = handKneeLabel.font.withSize(15)
                    handKneeLabel.tag = ((43 * 1) + 300)
                    subView.addSubview(handKneeLabel)
                    
                    let handKneeButton = UIButton()
                    handKneeButton.frame = CGRect(x: (15 * x), y: (18.8 * y), width: subView.frame.width - (21 * x), height: (3 * y))
                    handKneeButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    handKneeButton.tag = 43
                    handKneeButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(handKneeButton)
                    
                    getHandKneeLabel.frame = CGRect(x: handKneeButton.frame.maxX, y: (18.8 * y), width: (5 * x), height: (3 * y))
                    getHandKneeLabel.text = "0.0"
                    getHandKneeLabel.textColor = UIColor.blue
                    getHandKneeLabel.textAlignment = .center
                    getHandKneeLabel.font = getHandKneeLabel.font.withSize(15)
                    getHandKneeLabel.tag = ((43 * 1) + 200)
                    subView.addSubview(getHandKneeLabel)
                }
                else if index == 4
                {
                    let sleeveHeightLabel = UILabel()
                    sleeveHeightLabel.frame = CGRect(x: (14 * x), y: (15 * y), width: subView.frame.width - (23 * x), height: (2 * y))
                    sleeveHeightLabel.text = "Sleeve"
                    sleeveHeightLabel.textColor = UIColor.black
                    sleeveHeightLabel.textAlignment = .right
                    sleeveHeightLabel.font = sleeveHeightLabel.font.withSize(15)
                    sleeveHeightLabel.tag = ((44 * 1) + 300)
                    subView.addSubview(sleeveHeightLabel)
                    
                    let sleeveHeightButton = UIButton()
                    sleeveHeightButton.frame = CGRect(x: (14 * x), y: (15.5 * y), width: subView.frame.width - (20 * x), height: (3 * y))
                    sleeveHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    sleeveHeightButton.tag = 44
                    sleeveHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(sleeveHeightButton)
                    
                    let getSleeveHeightLabel = UILabel()
                    getSleeveHeightLabel.frame = CGRect(x: sleeveHeightButton.frame.maxX, y: (15.5 * y), width: (5 * x), height: (3 * y))
                    getSleeveHeightLabel.text = "0.0"
                    getSleeveHeightLabel.textColor = UIColor.blue
                    getSleeveHeightLabel.textAlignment = .center
                    getSleeveHeightLabel.font = getSleeveHeightLabel.font.withSize(15)
                    getSleeveHeightLabel.tag = ((44 * 1) + 200)
                    subView.addSubview(getSleeveHeightLabel)
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
            else if gender == "Boy" || gender == "ولد"
            {
                if index == 0
                {
                    let headLabel = UILabel()
                    headLabel.frame = CGRect(x: (11 * x), y: 0, width: subView.frame.width - (20 * x), height: (2 * y))
                    headLabel.text = "Head"
                    headLabel.textColor = UIColor.black
                    headLabel.textAlignment = .right
                    headLabel.font = headLabel.font.withSize(15)
                    headLabel.tag = ((45 * 1) + 300)
                    subView.addSubview(headLabel)
                    
                    let headButton = UIButton()
                    headButton.frame = CGRect(x: (11 * x), y: (0.7 * y), width: subView.frame.width - (17 * x), height: (3 * y))
                    headButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    headButton.tag = 45
                    headButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(headButton)
                    
                    getHeadLabel.frame = CGRect(x: headButton.frame.maxX, y: (0.7 * y), width: (5 * x), height: (3 * y))
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
                    getHeadLabel.tag = ((45 * 1) + 200)
                    subView.addSubview(getHeadLabel)
                    
                    let neckLabel = UILabel()
                    neckLabel.frame = CGRect(x: (11 * x), y: (6.7 * y), width: subView.frame.width - (20 * x), height: (2 * y))
                    neckLabel.text = "Neck"
                    neckLabel.textColor = UIColor.black
                    neckLabel.textAlignment = .right
                    neckLabel.font = headLabel.font.withSize(15)
                    neckLabel.tag = ((46 * 1) + 300)
                    subView.addSubview(neckLabel)
                    
                    let neckButton = UIButton()
                    neckButton.frame = CGRect(x: (11 * x), y: (7.2 * y), width: subView.frame.width - (17 * x), height: (3 * y))
                    neckButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    neckButton.tag = 46
                    neckButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(neckButton)
                    
                    getNeckLabel.frame = CGRect(x: neckButton.frame.maxX, y: (7.2 * y), width: (5 * x), height: (3 * y))
                    getNeckLabel.text = "0.0"
                    getNeckLabel.textColor = UIColor.blue
                    getNeckLabel.textAlignment = .center
                    getNeckLabel.font = headLabel.font.withSize(15)
                    getNeckLabel.tag = ((46 * 1) + 200)
                    subView.addSubview(getNeckLabel)
                    
                    let chestLabel = UILabel()
                    chestLabel.frame = CGRect(x: (12.5 * x), y: (10.5 * y), width: subView.frame.width - (21.5 * x), height: (2 * y))
                    chestLabel.text = "Chest"
                    chestLabel.textColor = UIColor.black
                    chestLabel.textAlignment = .right
                    chestLabel.font = headLabel.font.withSize(15)
                    chestLabel.tag = ((47 * 1) + 300)
                    subView.addSubview(chestLabel)
                    
                    let chestButton = UIButton()
                    chestButton.frame = CGRect(x: (12.5 * x), y: (11 * y), width: subView.frame.width - (18.5 * x), height: (3 * y))
                    chestButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    chestButton.tag = 47
                    chestButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(chestButton)
                    
                    getChestLabel.frame = CGRect(x: chestButton.frame.maxX, y: (11 * y), width: (5 * x), height: (3 * y))
                    getChestLabel.text = "0.0"
                    getChestLabel.textColor = UIColor.blue
                    getChestLabel.textAlignment = .center
                    getChestLabel.font = headLabel.font.withSize(15)
                    getChestLabel.tag = ((47 * 1) + 200)
                    subView.addSubview(getChestLabel)
                    
                    let waistLabel = UILabel()
                    waistLabel.frame = CGRect(x: (12 * x), y: (13.6 * y), width: subView.frame.width - (21 * x), height: (2 * y))
                    waistLabel.text = "Waist"
                    waistLabel.textColor = UIColor.black
                    waistLabel.textAlignment = .right
                    waistLabel.font = headLabel.font.withSize(15)
                    waistLabel.tag = ((48 * 1) + 300)
                    subView.addSubview(waistLabel)
                    
                    let waistButton = UIButton()
                    waistButton.frame = CGRect(x: (12 * x), y: (14.1 * y), width: subView.frame.width - (18 * x), height: (3 * y))
                    waistButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    waistButton.tag = 48
                    waistButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(waistButton)
                    
                    getWaistLabel.frame = CGRect(x: waistButton.frame.maxX, y: (14.1 * y), width: (5 * x), height: (3 * y))
                    getWaistLabel.text = "0.0"
                    getWaistLabel.textColor = UIColor.blue
                    getWaistLabel.textAlignment = .center
                    getWaistLabel.font = headLabel.font.withSize(15)
                    getWaistLabel.tag = ((48 * 1) + 200)
                    subView.addSubview(getWaistLabel)
                    
                    let thighLabel = UILabel()
                    thighLabel.frame = CGRect(x: (12.5 * x), y: (24.7 * y), width: subView.frame.width - (21.5 * x), height: (2 * y))
                    thighLabel.text = "Thigh"
                    thighLabel.textColor = UIColor.black
                    thighLabel.textAlignment = .right
                    thighLabel.font = headLabel.font.withSize(15)
                    thighLabel.tag = ((49 * 1) + 300)
                    subView.addSubview(thighLabel)
                    
                    let thighButton = UIButton()
                    thighButton.frame = CGRect(x: (12.5 * x), y: (25.2 * y), width: subView.frame.width - (18.5 * x), height: (3 * y))
                    thighButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    thighButton.tag = 49
                    thighButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(thighButton)
                    
                    getThighLabel.frame = CGRect(x: thighButton.frame.maxX, y: (25.2 * y), width: (5 * x), height: (3 * y))
                    getThighLabel.text = "0.0"
                    getThighLabel.textColor = UIColor.blue
                    getThighLabel.textAlignment = .center
                    getThighLabel.font = headLabel.font.withSize(15)
                    getThighLabel.tag = ((49 * 1) + 200)
                    subView.addSubview(getThighLabel)
                    
                    let kneeLabel = UILabel()
                    kneeLabel.frame = CGRect(x: (12 * x), y: (28.3 * y), width: subView.frame.width - (21 * x), height: (2 * y))
                    kneeLabel.text = "Knee"
                    kneeLabel.textColor = UIColor.black
                    kneeLabel.textAlignment = .right
                    kneeLabel.font = headLabel.font.withSize(15)
                    kneeLabel.tag = ((50 * 1) + 300)
                    subView.addSubview(kneeLabel)
                    
                    let kneeButton = UIButton()
                    kneeButton.frame = CGRect(x: (12 * x), y: (28.8 * y), width: subView.frame.width - (18 * x), height: (3 * y))
                    kneeButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    kneeButton.tag = 50
                    kneeButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(kneeButton)
                    
                    getKneeLabel.frame = CGRect(x: kneeButton.frame.maxX, y: (28.8 * y), width: (5 * x), height: (3 * y))
                    getKneeLabel.text = "0.0"
                    getKneeLabel.textColor = UIColor.blue
                    getKneeLabel.textAlignment = .center
                    getKneeLabel.font = headLabel.font.withSize(15)
                    getKneeLabel.tag = ((50 * 1) + 200)
                    subView.addSubview(getKneeLabel)
                    
                    let ankleLabel = UILabel()
                    ankleLabel.frame = CGRect(x: (11.2 * x), y: (36.7 * y), width: subView.frame.width - (20.2 * x), height: (2 * y))
                    ankleLabel.text = "Ankle"
                    ankleLabel.textColor = UIColor.black
                    ankleLabel.textAlignment = .right
                    ankleLabel.font = headLabel.font.withSize(15)
                    ankleLabel.tag = ((51 * 1) + 300)
                    subView.addSubview(ankleLabel)
                    
                    let ankleButton = UIButton()
                    ankleButton.frame = CGRect(x: (11.2 * x), y: (37.2 * y), width: subView.frame.width - (17.2 * x), height: (3 * y))
                    ankleButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    ankleButton.tag = 51
                    ankleButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(ankleButton)
                    
                    getAnkleLabel.frame = CGRect(x: ankleButton.frame.maxX, y: (37.2 * y), width: (5 * x), height: (3 * y))
                    getAnkleLabel.text = "0.0"
                    getAnkleLabel.textColor = UIColor.blue
                    getAnkleLabel.textAlignment = .center
                    getAnkleLabel.font = headLabel.font.withSize(15)
                    getAnkleLabel.tag = ((51 * 1) + 200)
                    subView.addSubview(getAnkleLabel)
                }
                else if index == 1
                {
                    let totalheightLabel = UILabel()
                    totalheightLabel.frame = CGRect(x: (2.5 * x), y: (14.5 * y), width: subView.frame.width - (11.5 * x), height: (2 * y))
                    totalheightLabel.text = "Over all height"
                    totalheightLabel.textColor = UIColor.black
                    totalheightLabel.textAlignment = .right
                    totalheightLabel.font = totalheightLabel.font.withSize(15)
                    totalheightLabel.tag = ((52 * 1) + 300)
                    subView.addSubview(totalheightLabel)
                    
                    let overAllHeightButton = UIButton()
                    overAllHeightButton.frame = CGRect(x: (2.5 * x), y: (15 * y), width: subView.frame.width - (8.5 * x), height: (3 * y))
                    overAllHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    //                    overAllHeightButton.backgroundColor = UIColor.red
                    overAllHeightButton.tag = 52
                    overAllHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(overAllHeightButton)
                    
                    gettotalheightLabel.frame = CGRect(x: overAllHeightButton.frame.maxX, y: (15 * y), width: (5 * x), height: (3 * y))
                    gettotalheightLabel.text = "0.0"
                    gettotalheightLabel.textColor = UIColor.blue
                    gettotalheightLabel.textAlignment = .center
                    gettotalheightLabel.font = gettotalheightLabel.font.withSize(15)
                    gettotalheightLabel.tag = ((52 * 1) + 200)
                    subView.addSubview(gettotalheightLabel)
                    
                    let hipHeightLabel = UILabel()
                    hipHeightLabel.frame = CGRect(x: (6.4 * x), y: (36 * y), width: subView.frame.width - (15.4 * x), height: (2 * y))
                    hipHeightLabel.text = "Hip height"
                    hipHeightLabel.textColor = UIColor.black
                    hipHeightLabel.textAlignment = .right
                    hipHeightLabel.font = hipHeightLabel.font.withSize(15)
                    hipHeightLabel.tag = ((53 * 1) + 300)
                    subView.addSubview(hipHeightLabel)
                    
                    let hipHeightButton = UIButton()
                    hipHeightButton.frame = CGRect(x: (6.4 * x), y: (36.5 * y), width: subView.frame.width - (12.4 * x), height: (3 * y))
                    hipHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    hipHeightButton.tag = 53
                    hipHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(hipHeightButton)
                    
                    getHipheightLabel.frame = CGRect(x: hipHeightButton.frame.maxX, y: (36.5 * y), width: (5 * x), height: (3 * y))
                    getHipheightLabel.text = "0.0"
                    getHipheightLabel.textColor = UIColor.blue
                    getHipheightLabel.textAlignment = .center
                    getHipheightLabel.font = getHipheightLabel.font.withSize(15)
                    getHipheightLabel.tag = ((53 * 1) + 200)
                    subView.addSubview(getHipheightLabel)
                    
                    let bottomheightLabel = UILabel()
                    bottomheightLabel.frame = CGRect(x: (8 * x), y: (32 * y), width: subView.frame.width - (17 * x), height: (2 * y))
                    bottomheightLabel.text = "Bottom height"
                    bottomheightLabel.textColor = UIColor.black
                    bottomheightLabel.textAlignment = .right
                    bottomheightLabel.font = totalheightLabel.font.withSize(15)
                    bottomheightLabel.tag = ((54 * 1) + 300)
                    subView.addSubview(bottomheightLabel)
                    
                    let bottomHeightButton = UIButton()
                    bottomHeightButton.frame = CGRect(x: (8 * x), y: (32.5 * y), width: subView.frame.width - (14 * x), height: (3 * y))
                    bottomHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    bottomHeightButton.tag = 54
                    bottomHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(bottomHeightButton)
                    
                    getBottomheightLabel.frame = CGRect(x: bottomHeightButton.frame.maxX, y: (32.5 * y), width: (5 * x), height: (3 * y))
                    getBottomheightLabel.text = "0.0"
                    getBottomheightLabel.textColor = UIColor.blue
                    getBottomheightLabel.textAlignment = .center
                    getBottomheightLabel.font = getBottomheightLabel.font.withSize(15)
                    getBottomheightLabel.tag = ((54 * 1) + 200)
                    subView.addSubview(getBottomheightLabel)
                    
                    let kneeheightLabel = UILabel()
                    kneeheightLabel.frame = CGRect(x: (11.8 * x), y: (25 * y), width: subView.frame.width - (20.8 * x), height: (2 * y))
                    kneeheightLabel.text = "Knee height"
                    kneeheightLabel.textColor = UIColor.black
                    kneeheightLabel.textAlignment = .right
                    kneeheightLabel.font = totalheightLabel.font.withSize(15)
                    kneeheightLabel.tag = ((55 * 1) + 300)
                    subView.addSubview(kneeheightLabel)
                    
                    let kneeHeightButton = UIButton()
                    kneeHeightButton.frame = CGRect(x: (11.8 * x), y: (25.5 * y), width: subView.frame.width - (17.8 * x), height: (3 * y))
                    kneeHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    kneeHeightButton.tag = 55
                    kneeHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(kneeHeightButton)
                    
                    getKneeheightLabel.frame = CGRect(x: kneeHeightButton.frame.maxX, y: (25.5 * y), width: (5 * x), height: (3 * y))
                    getKneeheightLabel.text = "0.0"
                    getKneeheightLabel.textColor = UIColor.blue
                    getKneeheightLabel.textAlignment = .center
                    getKneeheightLabel.font = getKneeheightLabel.font.withSize(15)
                    getKneeheightLabel.tag = ((55 * 1) + 200)
                    subView.addSubview(getKneeheightLabel)
                }
                else if index == 2
                {
                    let shoulderLabel = UILabel()
                    shoulderLabel.frame = CGRect(x: (12.7 * x), y: (7.3 * y), width: subView.frame.width - (21.7 * x), height: (2 * y))
                    shoulderLabel.text = "Shoulder"
                    shoulderLabel.textColor = UIColor.black
                    shoulderLabel.textAlignment = .right
                    shoulderLabel.font = shoulderLabel.font.withSize(15)
                    shoulderLabel.tag = ((56 * 1) + 300)
                    subView.addSubview(shoulderLabel)
                    
                    let shoulderButton = UIButton()
                    shoulderButton.frame = CGRect(x: (12.7 * x), y: (7.8 * y), width: subView.frame.width - (18.7 * x), height: (3 * y))
                    shoulderButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    shoulderButton.tag = 56
                    shoulderButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(shoulderButton)
                    
                    getShoulderLabel.frame = CGRect(x: shoulderButton.frame.maxX, y: (7.8 * y), width: (5 * x), height: (3 * y))
                    getShoulderLabel.text = "0.0"
                    getShoulderLabel.textColor = UIColor.blue
                    getShoulderLabel.textAlignment = .center
                    getShoulderLabel.font = getShoulderLabel.font.withSize(15)
                    getShoulderLabel.tag = ((56 * 1) + 200)
                    subView.addSubview(getShoulderLabel)
                    
                    let sleeveLabel = UILabel()
                    sleeveLabel.frame = CGRect(x: (12.8 * x), y: (10.5 * y), width: subView.frame.width - (21.8 * x), height: (2 * y))
                    sleeveLabel.text = "Half Sleeve"
                    sleeveLabel.textColor = UIColor.black
                    sleeveLabel.textAlignment = .right
                    sleeveLabel.font = sleeveLabel.font.withSize(15)
                    sleeveLabel.tag = ((57 * 1) + 300)
                    subView.addSubview(sleeveLabel)
                    
                    let sleeveButton = UIButton()
                    sleeveButton.frame = CGRect(x: (12.8 * x), y: (11 * y), width: subView.frame.width - (18.8 * x), height: (3 * y))
                    sleeveButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    sleeveButton.tag = 57
                    sleeveButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(sleeveButton)
                    
                    getSleeveLabel.frame = CGRect(x: sleeveButton.frame.maxX, y: (11 * y), width: (5 * x), height: (3 * y))
                    getSleeveLabel.text = "0.0"
                    getSleeveLabel.textColor = UIColor.blue
                    getSleeveLabel.textAlignment = .center
                    getSleeveLabel.font = getSleeveLabel.font.withSize(15)
                    getSleeveLabel.tag = ((57 * 1) + 200)
                    subView.addSubview(getSleeveLabel)
                    
                    let bicepLabel = UILabel()
                    bicepLabel.frame = CGRect(x: (13.7 * x), y: (14.5 * y), width: subView.frame.width - (22.7 * x), height: (2 * y))
                    bicepLabel.text = "Bicep"
                    bicepLabel.textColor = UIColor.black
                    bicepLabel.textAlignment = .right
                    bicepLabel.font = bicepLabel.font.withSize(15)
                    bicepLabel.tag = ((58 * 1) + 300)
                    subView.addSubview(bicepLabel)
                    
                    let bicepButton = UIButton()
                    bicepButton.frame = CGRect(x: (13.7 * x), y: (15 * y), width: subView.frame.width - (19.7 * x), height: (3 * y))
                    bicepButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    bicepButton.tag = 58
                    bicepButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(bicepButton)
                    
                    getBicepLabel.frame = CGRect(x: bicepButton.frame.maxX, y: (15 * y), width: (5 * x), height: (3 * y))
                    getBicepLabel.text = "0.0"
                    getBicepLabel.textColor = UIColor.blue
                    getBicepLabel.textAlignment = .center
                    getBicepLabel.font = getBicepLabel.font.withSize(15)
                    getBicepLabel.tag = ((58 * 1) + 200)
                    subView.addSubview(getBicepLabel)
                    
                    let hipLabel = UILabel()
                    hipLabel.frame = CGRect(x: (12 * x), y: (17 * y), width: subView.frame.width - (21 * x), height: (2 * y))
                    hipLabel.text = "Hip"
                    hipLabel.textColor = UIColor.black
                    hipLabel.textAlignment = .right
                    hipLabel.font = hipLabel.font.withSize(15)
                    hipLabel.tag = ((59 * 1) + 300)
                    subView.addSubview(hipLabel)
                    
                    let hipButton = UIButton()
                    hipButton.frame = CGRect(x: (12 * x), y: (17.5 * y), width: subView.frame.width - (18 * x), height: (3 * y))
                    hipButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    hipButton.tag = 59
                    hipButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(hipButton)
                    
                    getHipLabel.frame = CGRect(x: hipButton.frame.maxX, y: (17.5 * y), width: (5 * x), height: (3 * y))
                    getHipLabel.text = "0.0"
                    getHipLabel.textColor = UIColor.blue
                    getHipLabel.textAlignment = .center
                    getHipLabel.font = getHipLabel.font.withSize(15)
                    getHipLabel.tag = ((59 * 1) + 200)
                    subView.addSubview(getHipLabel)
                    
                    let backLabel = UILabel()
                    backLabel.frame = CGRect(x: (12.6 * x), y: (19.8 * y), width: subView.frame.width - (21.6 * x), height: (2 * y))
                    backLabel.text = "Back"
                    backLabel.textColor = UIColor.black
                    backLabel.textAlignment = .right
                    backLabel.font = backLabel.font.withSize(15)
                    backLabel.tag = ((60 * 1) + 300)
                    subView.addSubview(backLabel)
                    
                    let backButton = UIButton()
                    backButton.frame = CGRect(x: (12.6 * x), y: (20.3 * y), width: subView.frame.width - (18.6 * x), height: (3 * y))
                    backButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    backButton.tag = 60
                    backButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(backButton)
                    
                    getBackLabel.frame = CGRect(x: backButton.frame.maxX, y: (20.3 * y), width: (5 * x), height: (3 * y))
                    getBackLabel.text = "0.0"
                    getBackLabel.textColor = UIColor.blue
                    getBackLabel.textAlignment = .center
                    getBackLabel.font = getBackLabel.font.withSize(15)
                    getBackLabel.tag = ((60 * 1) + 200)
                    subView.addSubview(getBackLabel)
                }
                else if index == 3
                {
                    let heightLabel = UILabel()
                    heightLabel.frame = CGRect(x: (7.9 * x), y: (10.6 * y), width: subView.frame.width - (16.9 * x), height: (2 * y))
                    heightLabel.text = "Height"
                    heightLabel.textColor = UIColor.black
                    heightLabel.textAlignment = .right
                    heightLabel.font = heightLabel.font.withSize(15)
                    heightLabel.tag = ((61 * 1) + 300)
                    subView.addSubview(heightLabel)
                    
                    let heightButton = UIButton()
                    heightButton.frame = CGRect(x: (7.9 * x), y: (11.1 * y), width: subView.frame.width - (13.9 * x), height: (3 * y))
                    heightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    heightButton.tag = 61
                    heightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(heightButton)
                    
                    getHeightLabel.frame = CGRect(x: heightButton.frame.maxX, y: (11.1 * y), width: (5 * x), height: (3 * y))
                    getHeightLabel.text = "0.0"
                    getHeightLabel.textColor = UIColor.blue
                    getHeightLabel.textAlignment = .center
                    getHeightLabel.font = getHeightLabel.font.withSize(15)
                    getHeightLabel.tag = ((61 * 1) + 200)
                    subView.addSubview(getHeightLabel)
                    
                    let fullSleeveLabel = UILabel()
                    fullSleeveLabel.frame = CGRect(x: (13.5 * x), y: (15.1 * y), width: subView.frame.width - (22.5 * x), height: (2 * y))
                    fullSleeveLabel.text = "Sleeve"
                    fullSleeveLabel.textColor = UIColor.black
                    fullSleeveLabel.textAlignment = .right
                    fullSleeveLabel.font = heightLabel.font.withSize(15)
                    fullSleeveLabel.tag = ((62 * 1) + 300)
                    subView.addSubview(fullSleeveLabel)
                    
                    let fullSleeveButton = UIButton()
                    fullSleeveButton.frame = CGRect(x: (13.5 * x), y: (15.6 * y), width: subView.frame.width - (19.5 * x), height: (3 * y))
                    fullSleeveButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    fullSleeveButton.tag = 62
                    fullSleeveButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(fullSleeveButton)
                    
                    getFullSleeveLabel.frame = CGRect(x: fullSleeveButton.frame.maxX, y: (15.6 * y), width: (5 * x), height: (3 * y))
                    getFullSleeveLabel.text = "0.0"
                    getFullSleeveLabel.textColor = UIColor.blue
                    getFullSleeveLabel.textAlignment = .center
                    getFullSleeveLabel.font = getFullSleeveLabel.font.withSize(15)
                    getFullSleeveLabel.tag = ((62 * 1) + 200)
                    subView.addSubview(getFullSleeveLabel)
                    
                    let handKneeLabel = UILabel()
                    handKneeLabel.frame = CGRect(x: (14.2 * x), y: (20.3 * y), width: subView.frame.width - (23.2 * x), height: (2 * y))
                    handKneeLabel.text = "Hand Cuf"
                    handKneeLabel.textColor = UIColor.black
                    handKneeLabel.textAlignment = .right
                    handKneeLabel.font = handKneeLabel.font.withSize(15)
                    handKneeLabel.tag = ((63 * 1) + 300)
                    subView.addSubview(handKneeLabel)
                    
                    let handKneeButton = UIButton()
                    handKneeButton.frame = CGRect(x: (14.2 * x), y: (20.8 * y), width: subView.frame.width - (20.2 * x), height: (3 * y))
                    handKneeButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    handKneeButton.tag = 63
                    handKneeButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(handKneeButton)
                    
                    getHandKneeLabel.frame = CGRect(x: handKneeButton.frame.maxX, y: (20.8 * y), width: (5 * x), height: (3 * y))
                    getHandKneeLabel.text = "0.0"
                    getHandKneeLabel.textColor = UIColor.blue
                    getHandKneeLabel.textAlignment = .center
                    getHandKneeLabel.font = getHandKneeLabel.font.withSize(15)
                    getHandKneeLabel.tag = ((63 * 1) + 200)
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
            else if gender == "Girl" || gender == "بنت"
            {
                if index == 0
                {
                    let headLabel = UILabel()
                    headLabel.frame = CGRect(x: (10.8 * x), y: 0, width: subView.frame.width - (19.8 * x), height: (2 * y))
                    headLabel.text = "Head"
                    headLabel.textColor = UIColor.black
                    headLabel.textAlignment = .right
                    headLabel.font = headLabel.font.withSize(15)
                    headLabel.tag = ((64 * 1) + 300)
                    subView.addSubview(headLabel)
                    
                    let headButton = UIButton()
                    headButton.frame = CGRect(x: (10.8 * x), y: (y / 2), width: subView.frame.width - (16.8 * x), height: (3 * y))
                    headButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    headButton.tag = 64
                    headButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(headButton)
                    
                    getHeadLabel.frame = CGRect(x: headButton.frame.maxX, y: (y / 2), width: (5 * x), height: (3 * y))
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
                    getHeadLabel.tag = ((64 * 1) + 200)
                    subView.addSubview(getHeadLabel)
                    
                    let neckLabel = UILabel()
                    neckLabel.frame = CGRect(x: (12.5 * x), y: (10 * y), width: subView.frame.width - (21.5 * x), height: (2 * y))
                    neckLabel.text = "Over Bust"
                    neckLabel.textColor = UIColor.black
                    neckLabel.textAlignment = .right
                    neckLabel.font = headLabel.font.withSize(15)
                    neckLabel.tag = ((65 * 1) + 300)
                    subView.addSubview(neckLabel)
                    
                    let neckButton = UIButton()
                    neckButton.frame = CGRect(x: (12.5 * x), y: (10.5 * y), width: subView.frame.width - (18.5 * x), height: (3 * y))
                    neckButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    neckButton.tag = 65
                    neckButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(neckButton)
                    
                    getNeckLabel.frame = CGRect(x: neckButton.frame.maxX, y: (10.5 * y), width: (5 * x), height: (3 * y))
                    getNeckLabel.text = "0.0"
                    getNeckLabel.textColor = UIColor.blue
                    getNeckLabel.textAlignment = .center
                    getNeckLabel.font = headLabel.font.withSize(15)
                    getNeckLabel.tag = ((65 * 1) + 200)
                    subView.addSubview(getNeckLabel)
                    
                    let chestLabel = UILabel()
                    chestLabel.frame = CGRect(x: (11.8 * x), y: (13 * y), width: subView.frame.width - (20.8 * x), height: (2 * y))
                    chestLabel.text = "Under Bust"
                    chestLabel.textColor = UIColor.black
                    chestLabel.textAlignment = .right
                    chestLabel.font = headLabel.font.withSize(15)
                    chestLabel.tag = ((66 * 1) + 300)
                    subView.addSubview(chestLabel)
                    
                    let chestButton = UIButton()
                    chestButton.frame = CGRect(x: (11.8 * x), y: (13.5 * y), width: subView.frame.width - (18.2 * x), height: (3 * y))
                    chestButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    chestButton.tag = 66
                    chestButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(chestButton)
                    
                    getChestLabel.frame = CGRect(x: chestButton.frame.maxX, y: (13.5 * y), width: (5 * x), height: (3 * y))
                    getChestLabel.text = "0.0"
                    getChestLabel.textColor = UIColor.blue
                    getChestLabel.textAlignment = .center
                    getChestLabel.font = headLabel.font.withSize(15)
                    getChestLabel.tag = ((66 * 1) + 200)
                    subView.addSubview(getChestLabel)
                    
                    let waistLabel = UILabel()
                    waistLabel.frame = CGRect(x: (12 * x), y: (15.8 * y), width: subView.frame.width - (21 * x), height: (2 * y))
                    waistLabel.text = "Hip Bone"
                    waistLabel.textColor = UIColor.black
                    waistLabel.textAlignment = .right
                    waistLabel.font = headLabel.font.withSize(15)
                    waistLabel.tag = ((67 * 1) + 300)
                    subView.addSubview(waistLabel)
                    
                    let waistButton = UIButton()
                    waistButton.frame = CGRect(x: (12 * x), y: (16.3 * y), width: subView.frame.width - (18 * x), height: (3 * y))
                    waistButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    waistButton.tag = 67
                    waistButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(waistButton)
                    
                    getWaistLabel.frame = CGRect(x: waistButton.frame.maxX, y: (16.3 * y), width: (5 * x), height: (3 * y))
                    getWaistLabel.text = "0.0"
                    getWaistLabel.textColor = UIColor.blue
                    getWaistLabel.textAlignment = .center
                    getWaistLabel.font = headLabel.font.withSize(15)
                    getWaistLabel.tag = ((67 * 1) + 200)
                    subView.addSubview(getWaistLabel)
                    
                    let thighLabel = UILabel()
                    thighLabel.frame = CGRect(x: (13 * x), y: (23.6 * y), width: subView.frame.width - (22 * x), height: (2 * y))
                    thighLabel.text = "Thigh"
                    thighLabel.textColor = UIColor.black
                    thighLabel.textAlignment = .right
                    thighLabel.font = headLabel.font.withSize(15)
                    thighLabel.tag = ((68 * 1) + 300)
                    subView.addSubview(thighLabel)
                    
                    let thighButton = UIButton()
                    thighButton.frame = CGRect(x: (13 * x), y: (24.1 * y), width: subView.frame.width - (19 * x), height: (3 * y))
                    thighButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    thighButton.tag = 68
                    thighButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(thighButton)
                    
                    getThighLabel.frame = CGRect(x: thighButton.frame.maxX, y: (24.1 * y), width: (5 * x), height: (3 * y))
                    getThighLabel.text = "0.0"
                    getThighLabel.textColor = UIColor.blue
                    getThighLabel.textAlignment = .center
                    getThighLabel.font = headLabel.font.withSize(15)
                    getThighLabel.tag = ((68 * 1) + 200)
                    subView.addSubview(getThighLabel)
                    
                    let kneeLabel = UILabel()
                    kneeLabel.frame = CGRect(x: (11.8 * x), y: (29.7 * y), width: subView.frame.width - (20.8 * x), height: (2 * y))
                    kneeLabel.text = "Knee"
                    kneeLabel.textColor = UIColor.black
                    kneeLabel.textAlignment = .right
                    kneeLabel.font = headLabel.font.withSize(15)
                    kneeLabel.tag = ((69 * 1) + 300)
                    subView.addSubview(kneeLabel)
                    
                    let kneeButton = UIButton()
                    kneeButton.frame = CGRect(x: (11.8 * x), y: (30.2 * y), width: subView.frame.width - (17.8 * x), height: (3 * y))
                    kneeButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    kneeButton.tag = 69
                    kneeButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(kneeButton)
                    
                    getKneeLabel.frame = CGRect(x: kneeButton.frame.maxX, y: (30.2 * y), width: (5 * x), height: (3 * y))
                    getKneeLabel.text = "0.0"
                    getKneeLabel.textColor = UIColor.blue
                    getKneeLabel.textAlignment = .center
                    getKneeLabel.font = headLabel.font.withSize(15)
                    getKneeLabel.tag = ((69 * 1) + 200)
                    subView.addSubview(getKneeLabel)
                    
                    let ankleLabel1 = UILabel()
                    ankleLabel1.frame = CGRect(x: (12.5 * x), y: (34.1 * y), width: subView.frame.width - (21.5 * x), height: (2 * y))
                    ankleLabel1.text = "Calf"
                    ankleLabel1.textColor = UIColor.black
                    ankleLabel1.textAlignment = .right
                    ankleLabel1.font = headLabel.font.withSize(15)
                    ankleLabel1.tag = ((70 * 1) + 300)
                    subView.addSubview(ankleLabel1)
                    
                    let ankleButton1 = UIButton()
                    ankleButton1.frame = CGRect(x: (12.5 * x), y: (34.6 * y), width: subView.frame.width - (18.5 * x), height: (3 * y))
                    ankleButton1.setImage(UIImage(named: "arrowMark"), for: .normal)
                    ankleButton1.tag = 70
                    ankleButton1.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(ankleButton1)
                    
                    let getAnkleLabel1 = UILabel()
                    getAnkleLabel1.frame = CGRect(x: ankleButton1.frame.maxX, y: (34.6 * y), width: (5 * x), height: (3 * y))
                    getAnkleLabel1.text = "0.0"
                    getAnkleLabel1.textColor = UIColor.blue
                    getAnkleLabel1.textAlignment = .center
                    getAnkleLabel1.font = headLabel.font.withSize(15)
                    getAnkleLabel1.tag = ((70 * 1) + 200)
                    subView.addSubview(getAnkleLabel1)
                    
                    let ankleLabel = UILabel()
                    ankleLabel.frame = CGRect(x: (11.4 * x), y: (40 * y), width: subView.frame.width - (20.4 * x), height: (2 * y))
                    ankleLabel.text = "Ankle"
                    ankleLabel.textColor = UIColor.black
                    ankleLabel.textAlignment = .right
                    ankleLabel.font = headLabel.font.withSize(15)
                    ankleLabel.tag = ((71 * 1) + 300)
                    subView.addSubview(ankleLabel)
                    
                    let ankleButton = UIButton()
                    ankleButton.frame = CGRect(x: (11.4 * x), y: (40.5 * y), width: subView.frame.width - (17.4 * x), height: (3 * y))
                    ankleButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    ankleButton.tag = 71
                    ankleButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(ankleButton)
                    
                    getAnkleLabel.frame = CGRect(x: ankleButton.frame.maxX, y: (40.5 * y), width: (5 * x), height: (3 * y))
                    getAnkleLabel.text = "0.0"
                    getAnkleLabel.textColor = UIColor.blue
                    getAnkleLabel.textAlignment = .center
                    getAnkleLabel.font = headLabel.font.withSize(15)
                    getAnkleLabel.tag = ((71 * 1) + 200)
                    subView.addSubview(getAnkleLabel)
                }
                else if index == 1
                {
                    let shoulderLabel = UILabel()
                    shoulderLabel.frame = CGRect(x: (10.3 * x), y: (6.3 * y), width: subView.frame.width - (19.3 * x), height: (2 * y))
                    shoulderLabel.text = "Neck"
                    shoulderLabel.textColor = UIColor.black
                    shoulderLabel.textAlignment = .right
                    shoulderLabel.font = shoulderLabel.font.withSize(15)
                    shoulderLabel.tag = ((72 * 1) + 300)
                    subView.addSubview(shoulderLabel)
                    
                    let shoulderButton = UIButton()
                    shoulderButton.frame = CGRect(x: (10.3 * x), y: (6.9 * y), width: subView.frame.width - (16.3 * x), height: (3 * y))
                    shoulderButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    shoulderButton.tag = 72
                    shoulderButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(shoulderButton)
                    
                    getShoulderLabel.frame = CGRect(x: shoulderButton.frame.maxX, y: (6.9 * y), width: (5 * x), height: (3 * y))
                    getShoulderLabel.text = "0.0"
                    getShoulderLabel.textColor = UIColor.blue
                    getShoulderLabel.textAlignment = .center
                    getShoulderLabel.font = getShoulderLabel.font.withSize(15)
                    getShoulderLabel.tag = ((72 * 1) + 200)
                    subView.addSubview(getShoulderLabel)
                    
                    let sleeveLabel = UILabel()
                    sleeveLabel.frame = CGRect(x: (12.4 * x), y: (11.8 * y), width: subView.frame.width - (21.4 * x), height: (2 * y))
                    sleeveLabel.text = "Bust"
                    sleeveLabel.textColor = UIColor.black
                    sleeveLabel.textAlignment = .right
                    sleeveLabel.font = sleeveLabel.font.withSize(15)
                    sleeveLabel.tag = ((73 * 1) + 300)
                    subView.addSubview(sleeveLabel)
                    
                    let sleeveButton = UIButton()
                    sleeveButton.frame = CGRect(x: (12.4 * x), y: (12.3 * y), width: subView.frame.width - (18.4 * x), height: (3 * y))
                    sleeveButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    sleeveButton.tag = 73
                    sleeveButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(sleeveButton)
                    
                    getSleeveLabel.frame = CGRect(x: sleeveButton.frame.maxX, y: (12.3 * y), width: (5 * x), height: (3 * y))
                    getSleeveLabel.text = "0.0"
                    getSleeveLabel.textColor = UIColor.blue
                    getSleeveLabel.textAlignment = .center
                    getSleeveLabel.font = getSleeveLabel.font.withSize(15)
                    getSleeveLabel.tag = ((73 * 1) + 200)
                    subView.addSubview(getSleeveLabel)
                    
                    let bicepLabel = UILabel()
                    bicepLabel.frame = CGRect(x: (12 * x), y: (14.8 * y), width: subView.frame.width - (21 * x), height: (2 * y))
                    bicepLabel.text = "Waist"
                    bicepLabel.textColor = UIColor.black
                    bicepLabel.textAlignment = .right
                    bicepLabel.font = bicepLabel.font.withSize(15)
                    bicepLabel.tag = ((74 * 1) + 300)
                    subView.addSubview(bicepLabel)
                    
                    let bicepButton = UIButton()
                    bicepButton.frame = CGRect(x: (12 * x), y: (15.3 * y), width: subView.frame.width - (18 * x), height: (3 * y))
                    bicepButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    bicepButton.tag = 74
                    bicepButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(bicepButton)
                    
                    getBicepLabel.frame = CGRect(x: bicepButton.frame.maxX, y: (15.3 * y), width: (5 * x), height: (3 * y))
                    getBicepLabel.text = "0.0"
                    getBicepLabel.textColor = UIColor.blue
                    getBicepLabel.textAlignment = .center
                    getBicepLabel.font = getBicepLabel.font.withSize(15)
                    getBicepLabel.tag = ((74 * 1) + 200)
                    subView.addSubview(getBicepLabel)
                    
                    let backLabel = UILabel()
                    backLabel.frame = CGRect(x: (13 * x), y: (20.5 * y), width: subView.frame.width - (22 * x), height: (2 * y))
                    backLabel.text = "Full Hip"
                    backLabel.textColor = UIColor.black
                    backLabel.textAlignment = .right
                    backLabel.font = backLabel.font.withSize(15)
                    backLabel.tag = ((75 * 1) + 300)
                    subView.addSubview(backLabel)
                    
                    let backButton = UIButton()
                    backButton.frame = CGRect(x: (13 * x), y: (21 * y), width: subView.frame.width - (19 * x), height: (3 * y))
                    backButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    backButton.tag = 75
                    backButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(backButton)
                    
                    getBackLabel.frame = CGRect(x: backButton.frame.maxX, y: (21 * y), width: (5 * x), height: (3 * y))
                    getBackLabel.text = "0.0"
                    getBackLabel.textColor = UIColor.blue
                    getBackLabel.textAlignment = .center
                    getBackLabel.font = getBackLabel.font.withSize(15)
                    getBackLabel.tag = ((75 * 1) + 200)
                    subView.addSubview(getBackLabel)
                }
                else if index == 2
                {
                    let totalheightLabel = UILabel()
                    totalheightLabel.frame = CGRect(x: 0, y: y, width: subView.frame.width - (9 * x), height: (2 * y))
                    totalheightLabel.text = "Over all height"
                    totalheightLabel.textColor = UIColor.black
                    totalheightLabel.textAlignment = .right
                    totalheightLabel.font = totalheightLabel.font.withSize(15)
                    totalheightLabel.tag = ((76 * 1) + 300)
                    subView.addSubview(totalheightLabel)
                    
                    let totalHeightButton = UIButton()
                    totalHeightButton.frame = CGRect(x: 0, y: (1.5 * y), width: subView.frame.width - (6 * x), height: (3 * y))
                    totalHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    totalHeightButton.tag = 76
                    totalHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(totalHeightButton)
                    
                    gettotalheightLabel.frame = CGRect(x: totalHeightButton.frame.maxX, y: (1.5 * y), width: (5 * x), height: (3 * y))
                    gettotalheightLabel.text = "0.0"
                    gettotalheightLabel.textColor = UIColor.blue
                    gettotalheightLabel.textAlignment = .center
                    gettotalheightLabel.font = gettotalheightLabel.font.withSize(15)
                    gettotalheightLabel.tag = ((76 * 1) + 200)
                    subView.addSubview(gettotalheightLabel)
                    
                    let stwHeightLabel = UILabel()
                    stwHeightLabel.frame = CGRect(x: (11.7 * x), y: (7.7 * y), width: subView.frame.width - (20.7 * x), height: (2 * y))
                    stwHeightLabel.text = "STW"
                    stwHeightLabel.textColor = UIColor.black
                    stwHeightLabel.textAlignment = .right
                    stwHeightLabel.font = stwHeightLabel.font.withSize(15)
                    stwHeightLabel.tag = ((77 * 1) + 300)
                    subView.addSubview(stwHeightLabel)
                    
                    let stwHeigtButton = UIButton()
                    stwHeigtButton.frame = CGRect(x: (11.7 * x), y: (8.2 * y), width: subView.frame.width - (17.7 * x), height: (3 * y))
                    stwHeigtButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    stwHeigtButton.tag = 77
                    stwHeigtButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(stwHeigtButton)
                    
                    let getstwHeightLabel = UILabel()
                    getstwHeightLabel.frame = CGRect(x: stwHeigtButton.frame.maxX, y: (8.2 * y), width: (5 * x), height: (3 * y))
                    getstwHeightLabel.text = "0.0"
                    getstwHeightLabel.textColor = UIColor.blue
                    getstwHeightLabel.textAlignment = .center
                    getstwHeightLabel.font = getstwHeightLabel.font.withSize(15)
                    getstwHeightLabel.tag = ((77 * 1) + 200)
                    subView.addSubview(getstwHeightLabel)
                    
                    let nltcHeightLabel = UILabel()
                    nltcHeightLabel.frame = CGRect(x: (7.5 * x), y: (9.6 * y), width: subView.frame.width - (16.5 * x), height: (2 * y))
                    nltcHeightLabel.text = "NLTC"
                    nltcHeightLabel.textColor = UIColor.black
                    nltcHeightLabel.textAlignment = .right
                    nltcHeightLabel.font = totalheightLabel.font.withSize(15)
                    nltcHeightLabel.tag = ((78 * 1) + 300)
                    subView.addSubview(nltcHeightLabel)
                    
                    let nltcHeigtButton = UIButton()
                    nltcHeigtButton.frame = CGRect(x: (7.5 * x), y: (10.1 * y), width: subView.frame.width - (13.5 * x), height: (3 * y))
                    nltcHeigtButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    nltcHeigtButton.tag = 78
                    nltcHeigtButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(nltcHeigtButton)
                    
                    let getnltcHeightLabel = UILabel()
                    getnltcHeightLabel.frame = CGRect(x: nltcHeigtButton.frame.maxX, y: (10.1 * y), width: (5 * x), height: (3 * y))
                    getnltcHeightLabel.text = "0.0"
                    getnltcHeightLabel.textColor = UIColor.blue
                    getnltcHeightLabel.textAlignment = .center
                    getnltcHeightLabel.font = getnltcHeightLabel.font.withSize(15)
                    getnltcHeightLabel.tag = ((78 * 1) + 200)
                    subView.addSubview(getnltcHeightLabel)
                    
                    let nltbHeightLabel = UILabel()
                    nltbHeightLabel.frame = CGRect(x: (10.2 * x), y: (12.2 * y), width: subView.frame.width - (19.2 * x), height: (2 * y))
                    nltbHeightLabel.text = "NLTB"
                    nltbHeightLabel.textColor = UIColor.black
                    nltbHeightLabel.textAlignment = .right
                    nltbHeightLabel.font = totalheightLabel.font.withSize(15)
                    nltbHeightLabel.tag = ((79 * 1) + 300)
                    subView.addSubview(nltbHeightLabel)
                    
                    let nltbHeigtButton = UIButton()
                    nltbHeigtButton.frame = CGRect(x: (10.2 * x), y: (12.7 * y), width: subView.frame.width - (16.2 * x), height: (3 * y))
                    nltbHeigtButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    nltbHeigtButton.tag = 79
                    nltbHeigtButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(nltbHeigtButton)
                    
                    let getnltbHeightLabel = UILabel()
                    getnltbHeightLabel.frame = CGRect(x: nltbHeigtButton.frame.maxX, y: (12.7 * y), width: (5 * x), height: (3 * y))
                    getnltbHeightLabel.text = "0.0"
                    getnltbHeightLabel.textColor = UIColor.blue
                    getnltbHeightLabel.textAlignment = .center
                    getnltbHeightLabel.font = getnltbHeightLabel.font.withSize(15)
                    getnltbHeightLabel.tag = ((79 * 1) + 200)
                    subView.addSubview(getnltbHeightLabel)
                    
                    let sthbHeightLabel = UILabel()
                    sthbHeightLabel.frame = CGRect(x: (11 * x), y: (14.5 * y), width: subView.frame.width - (20 * x), height: (2 * y))
                    sthbHeightLabel.text = "STHB"
                    sthbHeightLabel.textColor = UIColor.black
                    sthbHeightLabel.textAlignment = .right
                    sthbHeightLabel.font = totalheightLabel.font.withSize(15)
                    sthbHeightLabel.tag = ((80 * 1) + 300)
                    subView.addSubview(sthbHeightLabel)
                    
                    let sthbHeigtButton = UIButton()
                    sthbHeigtButton.frame = CGRect(x: (11 * x), y: (15 * y), width: subView.frame.width - (17 * x), height: (3 * y))
                    sthbHeigtButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    sthbHeigtButton.tag = 80
                    sthbHeigtButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(sthbHeigtButton)
                    
                    let getsthbHeightLabel = UILabel()
                    getsthbHeightLabel.frame = CGRect(x: sthbHeigtButton.frame.maxX, y: (15 * y), width: (5 * x), height: (3 * y))
                    getsthbHeightLabel.text = "0.0"
                    getsthbHeightLabel.textColor = UIColor.blue
                    getsthbHeightLabel.textAlignment = .center
                    getsthbHeightLabel.font = getsthbHeightLabel.font.withSize(15)
                    getsthbHeightLabel.tag = ((80 * 1) + 200)
                    subView.addSubview(getsthbHeightLabel)
                    
                    let wthbHeightLabel = UILabel()
                    wthbHeightLabel.frame = CGRect(x: (5 * x), y: (16.8 * y), width: subView.frame.width - (14 * x), height: (2 * y))
                    wthbHeightLabel.text = "WTHB"
                    wthbHeightLabel.textColor = UIColor.black
                    wthbHeightLabel.textAlignment = .right
                    wthbHeightLabel.font = wthbHeightLabel.font.withSize(15)
                    wthbHeightLabel.tag = ((81 * 1) + 300)
                    subView.addSubview(wthbHeightLabel)
                    
                    let wthbHeigtButton = UIButton()
                    wthbHeigtButton.frame = CGRect(x: (5 * x), y: (17.2 * y), width: subView.frame.width - (11 * x), height: (3 * y))
                    wthbHeigtButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    wthbHeigtButton.tag = 81
                    wthbHeigtButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(wthbHeigtButton)
                    
                    let getwthbHeightLabel = UILabel()
                    getwthbHeightLabel.frame = CGRect(x: wthbHeigtButton.frame.maxX, y: (17.2 * y), width: (5 * x), height: (3 * y))
                    getwthbHeightLabel.text = "0.0"
                    getwthbHeightLabel.textColor = UIColor.blue
                    getwthbHeightLabel.textAlignment = .center
                    getwthbHeightLabel.font = getwthbHeightLabel.font.withSize(15)
                    getwthbHeightLabel.tag = ((81 * 1) + 200)
                    subView.addSubview(getwthbHeightLabel)
                    
                    let hthheightLabel = UILabel()
                    hthheightLabel.frame = CGRect(x: (10.9 * x), y: (26.3 * y), width: subView.frame.width - (19.9 * x), height: (2 * y))
                    hthheightLabel.text = "HTH"
                    hthheightLabel.textColor = UIColor.black
                    hthheightLabel.textAlignment = .right
                    hthheightLabel.font = hthheightLabel.font.withSize(15)
                    hthheightLabel.tag = ((82 * 1) + 300)
                    subView.addSubview(hthheightLabel)
                    
                    let hthHeightButton = UIButton()
                    hthHeightButton.frame = CGRect(x: (10.9 * x), y: (26.8 * y), width: subView.frame.width - (16.9 * x), height: (3 * y))
                    hthHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    hthHeightButton.tag = 82
                    hthHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(hthHeightButton)
                    
                    let geththHeightLabel = UILabel()
                    geththHeightLabel.frame = CGRect(x: hthHeightButton.frame.maxX, y: (26.8 * y), width: (5 * x), height: (3 * y))
                    geththHeightLabel.text = "0.0"
                    geththHeightLabel.textColor = UIColor.blue
                    geththHeightLabel.textAlignment = .center
                    geththHeightLabel.font = geththHeightLabel.font.withSize(15)
                    geththHeightLabel.tag = ((82 * 1) + 200)
                    subView.addSubview(geththHeightLabel)
                    
                    let inseamheightLabel = UILabel()
                    inseamheightLabel.frame = CGRect(x: (7.6 * x), y: (32.5 * y), width: subView.frame.width - (16.6 * x), height: (2 * y))
                    inseamheightLabel.text = "INSEAM"
                    inseamheightLabel.textColor = UIColor.black
                    inseamheightLabel.textAlignment = .right
                    inseamheightLabel.font = inseamheightLabel.font.withSize(15)
                    inseamheightLabel.tag = ((83 * 1) + 300)
                    subView.addSubview(inseamheightLabel)
                    
                    let inseamHeightButton = UIButton()
                    inseamHeightButton.frame = CGRect(x: (7.6 * x), y: (33 * y), width: subView.frame.width - (13.6 * x), height: (3 * y))
                    inseamHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    inseamHeightButton.tag = 83
                    inseamHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(inseamHeightButton)
                    
                    let getinseamHeightLabel = UILabel()
                    getinseamHeightLabel.frame = CGRect(x: inseamHeightButton.frame.maxX, y: (33 * y), width: (5 * x), height: (3 * y))
                    getinseamHeightLabel.text = "0.0"
                    getinseamHeightLabel.textColor = UIColor.blue
                    getinseamHeightLabel.textAlignment = .center
                    getinseamHeightLabel.font = getinseamHeightLabel.font.withSize(15)
                    getinseamHeightLabel.tag = ((83 * 1) + 200)
                    subView.addSubview(getinseamHeightLabel)
                    
                    let outSteamHeightLabel = UILabel()
                    outSteamHeightLabel.frame = CGRect(x: (5.5 * x), y: (39.5 * y), width: subView.frame.width - (14.5 * x), height: (2 * y))
                    outSteamHeightLabel.text = "OUTSTEAM"
                    outSteamHeightLabel.textColor = UIColor.black
                    outSteamHeightLabel.textAlignment = .right
                    outSteamHeightLabel.font = outSteamHeightLabel.font.withSize(15)
                    outSteamHeightLabel.tag = ((84 * 1) + 300)
                    subView.addSubview(outSteamHeightLabel)
                    
                    let outSteamHeightButton = UIButton()
                    outSteamHeightButton.frame = CGRect(x: (5.5 * x), y: (40 * y), width: subView.frame.width - (11.5 * x), height: (3 * y))
                    outSteamHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    outSteamHeightButton.tag = 84
                    outSteamHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(outSteamHeightButton)
                    
                    let getoutSteamHeightLabel = UILabel()
                    getoutSteamHeightLabel.frame = CGRect(x: outSteamHeightButton.frame.maxX, y: (40 * y), width: (5 * x), height: (3 * y))
                    getoutSteamHeightLabel.text = "0.0"
                    getoutSteamHeightLabel.textColor = UIColor.blue
                    getoutSteamHeightLabel.textAlignment = .center
                    getoutSteamHeightLabel.font = getoutSteamHeightLabel.font.withSize(15)
                    getoutSteamHeightLabel.tag = ((84 * 1) + 200)
                    subView.addSubview(getoutSteamHeightLabel)
                }
                else if index == 3
                {
                    let shoulderLabel = UILabel()
                    shoulderLabel.frame = CGRect(x: (12 * x), y: (7.5 * y), width: subView.frame.width - (21 * x), height: (2 * y))
                    shoulderLabel.text = "Shoulder"
                    shoulderLabel.textColor = UIColor.black
                    shoulderLabel.textAlignment = .right
                    shoulderLabel.font = shoulderLabel.font.withSize(15)
                    shoulderLabel.tag = ((85 * 1) + 300)
                    subView.addSubview(shoulderLabel)
                    
                    let shoulderButton = UIButton()
                    shoulderButton.frame = CGRect(x: (12 * x), y: (8 * y), width: subView.frame.width - (18 * x), height: (3 * y))
                    shoulderButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    shoulderButton.tag = 85
                    shoulderButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(shoulderButton)
                    
                    getShoulderLabel.frame = CGRect(x: shoulderButton.frame.maxX, y: (8 * y), width: (5 * x), height: (3 * y))
                    getShoulderLabel.text = "0.0"
                    getShoulderLabel.textColor = UIColor.blue
                    getShoulderLabel.textAlignment = .center
                    getShoulderLabel.font = getHeightLabel.font.withSize(15)
                    getShoulderLabel.tag = ((85 * 1) + 200)
                    subView.addSubview(getShoulderLabel)
                    
                    let bicepLabel = UILabel()
                    bicepLabel.frame = CGRect(x: (14.7 * x), y: (13.2 * y), width: subView.frame.width - (23.7 * x), height: (2 * y))
                    bicepLabel.text = "Bicep"
                    bicepLabel.textColor = UIColor.black
                    bicepLabel.textAlignment = .right
                    bicepLabel.font = bicepLabel.font.withSize(15)
                    bicepLabel.tag = ((86 * 1) + 300)
                    subView.addSubview(bicepLabel)
                    
                    let bicepButton = UIButton()
                    bicepButton.frame = CGRect(x: (14.7 * x), y: (13.7 * y), width: subView.frame.width - (20.7 * x), height: (3 * y))
                    bicepButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    bicepButton.tag = 86
                    bicepButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(bicepButton)
                    
                    getBicepLabel.frame = CGRect(x: bicepButton.frame.maxX, y: (13.7 * y), width: (5 * x), height: (3 * y))
                    getBicepLabel.text = "0.0"
                    getBicepLabel.textColor = UIColor.blue
                    getBicepLabel.textAlignment = .center
                    getBicepLabel.font = getFullSleeveLabel.font.withSize(15)
                    getBicepLabel.tag = ((86 * 1) + 200)
                    subView.addSubview(getBicepLabel)
                    
                    let handKneeLabel = UILabel()
                    handKneeLabel.frame = CGRect(x: (15.5 * x), y: (21.2 * y), width: subView.frame.width - (24.5 * x), height: (2 * y))
                    handKneeLabel.text = "Hand Cuf"
                    handKneeLabel.textColor = UIColor.black
                    handKneeLabel.textAlignment = .right
                    handKneeLabel.font = handKneeLabel.font.withSize(15)
                    handKneeLabel.tag = ((87 * 1) + 300)
                    subView.addSubview(handKneeLabel)
                    
                    let handKneeButton = UIButton()
                    handKneeButton.frame = CGRect(x: (15.5 * x), y: (21.7 * y), width: subView.frame.width - (21.5 * x), height: (3 * y))
                    handKneeButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    handKneeButton.tag = 87
                    handKneeButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(handKneeButton)
                    
                    getHandKneeLabel.frame = CGRect(x: handKneeButton.frame.maxX, y: (21.7 * y), width: (5 * x), height: (3 * y))
                    getHandKneeLabel.text = "0.0"
                    getHandKneeLabel.textColor = UIColor.blue
                    getHandKneeLabel.textAlignment = .center
                    getHandKneeLabel.font = getHandKneeLabel.font.withSize(15)
                    getHandKneeLabel.tag = ((87 * 1) + 200)
                    subView.addSubview(getHandKneeLabel)
                }
                else if index == 4
                {
                    let sleeveHeightLabel = UILabel()
                    sleeveHeightLabel.frame = CGRect(x: (13.5 * x), y: (15 * y), width: subView.frame.width - (22.5 * x), height: (2 * y))
                    sleeveHeightLabel.text = "Sleeve"
                    sleeveHeightLabel.textColor = UIColor.black
                    sleeveHeightLabel.textAlignment = .right
                    sleeveHeightLabel.font = sleeveHeightLabel.font.withSize(15)
                    sleeveHeightLabel.tag = ((88 * 1) + 300)
                    subView.addSubview(sleeveHeightLabel)
                    
                    let sleeveHeightButton = UIButton()
                    sleeveHeightButton.frame = CGRect(x: (13.5 * x), y: (15.5 * y), width: subView.frame.width - (19.5 * x), height: (3 * y))
                    sleeveHeightButton.setImage(UIImage(named: "arrowMark"), for: .normal)
                    sleeveHeightButton.tag = 88
                    sleeveHeightButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
                    subView.addSubview(sleeveHeightButton)
                    
                    let getSleeveHeightLabel = UILabel()
                    getSleeveHeightLabel.frame = CGRect(x: sleeveHeightButton.frame.maxX, y: (15.5 * y), width: (5 * x), height: (3 * y))
                    getSleeveHeightLabel.text = "0.0"
                    getSleeveHeightLabel.textColor = UIColor.blue
                    getSleeveHeightLabel.textAlignment = .center
                    getSleeveHeightLabel.font = getSleeveHeightLabel.font.withSize(15)
                    getSleeveHeightLabel.tag = ((88 * 1) + 200)
                    subView.addSubview(getSleeveHeightLabel)
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
            
            /*for views in subView.subviews
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
                            
                            /*if let foundView = view.viewWithTag(label.tag + 100) {
                                
                                if let zzz = foundView as? UILabel
                                {
                                    zzz.text = PartsNameArray[buttonTag] as? String
                                }
                            }*/
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
                    if PartsIdArray.contains(buttonTag)
                    {
//                        if let foundView = view.viewWithTag(labels.tag + 100)
//                        {
//                            if labels.tag == foundView.tag
//                            {
//                                let value = PartsNameArray[buttonTag]
//                                labels.text = "\(value)"
//                            }
//                        }
                        
                        if let labelww = views.viewWithTag(((buttonTag * 1) + 300)) as? UILabel
                        {

                        }
                        
                        if labels.tag == ((buttonTag * 1) + 300)
                        {
                            let value = PartsNameArray[buttonTag]
                            labels.text = "\(value)"
                        }
                      
                    }
                    else
                    {
                        if labels.tag == ((buttonTag * 1) + 300)
                        {
                            labels.removeFromSuperview()
                        }
                        else
                        {
                 
                        }
                    }
                }*/
            }*/
            
            
            for views in subView.subviews
            {
                if let foundView = views as? UILabel
                {
                    if let language = UserDefaults.standard.value(forKey: "language") as? String
                    {
                        if language == "en"
                        {
                            foundView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                            foundView.textAlignment = .right
                        }
                        else if language == "ar"
                        {
                            foundView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                            foundView.textAlignment = .left
                        }
                    }
                    else
                    {
                        foundView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        foundView.textAlignment = .right
                    }
                }
            }
            
            for views in subView.subviews
            {
                if let label1 = views as? UILabel
                {
//                    label1.backgroundColor = UIColor.red
                }
                else if let button = views as? UIButton
                {
//                    button.backgroundColor = UIColor.red
                    
                    button.setImage(nil, for: .normal)

                    let arrow = UIBezierPath()
                    arrow.addArrow(start: CGPoint(x: 0, y: ((button.frame.height - 2) / 2)), end: CGPoint(x: button.frame.width, y: ((button.frame.height - 2) / 2)), pointerLineLength: 10, arrowAngle: CGFloat(Double.pi / 4))
                    
                    let arrowLayer = CAShapeLayer()
                    arrowLayer.strokeColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0).cgColor
                    arrowLayer.lineWidth = 2
                    arrowLayer.path = arrow.cgPath
                    arrowLayer.fillColor = UIColor.clear.cgColor
                    arrowLayer.lineJoin = CAShapeLayerLineJoin.round
                    arrowLayer.lineCap = CAShapeLayerLineCap.round
                    button.layer.addSublayer(arrowLayer)
                }
            }
        }
        
        var getTag = Int()
        
        for views in imageScrollView.subviews
        {
            if views.tag != 0
            {
                for views1 in views.subviews
                {
                    if let button = views1 as? UIButton
                    {
                        if PartsIdArray.contains(button.tag)
                        {
                            getTag = button.tag
                        }
                        else
                        {
                            button.removeFromSuperview()
                        }
                    }
                    else if let label1 = views1 as? UILabel
                    {
                        if headingPartsArray.contains(label1.tag)
                        {
                            if increamentHeadingTag < PartsNameArray.count
                            {
                                if let language = UserDefaults.standard.value(forKey: "language") as? String
                                {
                                    if language == "en"
                                    {
                                        label1.text = PartsNameArray[increamentHeadingTag] as? String
                                    }
                                    else if language == "ar"
                                    {
                                        label1.text = partsNameArabicArray[increamentHeadingTag] as? String
                                    }
                                }
                                else
                                {
                                    label1.text = PartsNameArray[increamentHeadingTag] as? String
                                }
                                
                                increamentHeadingTag = increamentHeadingTag + 1
                            }
                        }
                        else if valuePartsArray.contains(label1.tag)
                        {
                                if increamentValueTag < PartsNameArray.count
                            {
                                let value = measurementValues[getTag]
                                label1.text = "\(value!)"
                                increamentValueTag = increamentValueTag + 1
                            }
                        }
                        else
                        {
                            label1.removeFromSuperview()
                        }

                        /*if label1.tag == ((getTag * 1) + 300)
                        {
                            
                        }
                        else if label1.tag == ((getTag * 1) + 200)
                        {
                            
                        }
                        else
                        {
                            label1.removeFromSuperview()
                        }*/
                    }
                }
            }
        }
        
        let page = imageScrollView.contentOffset.x / imageScrollView.frame.size.width
        
        imageScrollView.contentSize = CGSize(width: imageScrollView.frame.size.width * CGFloat(genderImageArray.count),height: imageScrollView.frame.size.height)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
        
        stopActivity()
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                changeViewToEnglishInSelf()
            }
            else if language == "ar"
            {
                changeViewToArabicInSelf()
            }
        }
        else
        {
            changeViewToEnglishInSelf()
        }
        
        hintsViewContents()
        hintsContents()
    }
    
    func hintsContents()
    {
        self.gotItButton.removeFromSuperview()
        
        let headingLabel = UILabel()
        headingLabel.frame = CGRect(x: (2 * x), y: (5 * y), width: hintsView.frame.width - (4 * x), height: (3 * y))
        headingLabel.text = "Measurements"
        headingLabel.textAlignment = .left
        headingLabel.textColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0)
        headingLabel.font = UIFont(name: "Avenir-Regular", size: (2 * x))
        hintsView.addSubview(headingLabel)
        
        var x1:CGFloat = x
        
        let title = ["Back", "Skip", "Next"]
        
        for i in 0..<3
        {
            let threeButtons = UIButton()
            threeButtons.frame = CGRect(x: x1, y: hintsView.frame.height - (6 * y), width: (11.16 * x), height: (4 * y))
            threeButtons.backgroundColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0)
            threeButtons.setTitle(title[i], for: .normal)
            threeButtons.setTitleColor(UIColor.white, for: .normal)
            threeButtons.tag = i
            threeButtons.addTarget(self, action: #selector(self.threeButtonAction(sender:)), for: .touchUpInside)
            hintsView.addSubview(threeButtons)
            
            x1 = threeButtons.frame.maxX + x
        }
        
        firstHint()
    }
    
    @objc func threeButtonAction(sender : UIButton)
    {
        print("HINT TAG", hintTag)
        
        if sender.tag == 0
        {
            if hintTag != 0
            {
                hintTag = hintTag - 1
            }
            
            if hintTag == 0
            {
                firstHint()
            }
            else if hintTag == 1
            {
                secondHint()
            }
            else if hintTag == 2
            {
                thirdHint()
            }
            else if hintTag == 3
            {
                fourthHint()
            }
        }
        else if sender.tag == 1
        {
            hintsView.removeFromSuperview()
        }
        else if sender.tag == 2
        {
            if hintTag < 5
            {
                hintTag = hintTag + 1
            }

            if hintTag == 0
            {
                firstHint()
            }
            else if hintTag == 1
            {
                secondHint()
            }
            else if hintTag == 2
            {
                thirdHint()
            }
            else if hintTag == 3
            {
                fourthHint()
            }
            else
            {
                hintTag = 0
                hintsView.removeFromSuperview()
            }
        }
    }
    
    func firstHint()
    {
        hintsImage.frame = CGRect(x: imageButton.frame.minX, y: imageButton.frame.minY, width: imageButton.frame.width, height: imageButton.frame.height)
        hintsImage.layer.borderWidth = 2
        hintsImage.layer.borderColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0).cgColor
        hintsImage.image = UIImage(named: "imageHintImage")
        hintsView.addSubview(hintsImage)
        
        detailedLabel.frame = CGRect(x: (2 * x), y: hintsImage.frame.maxY + y, width: hintsView.frame.width - (4 * x), height: (5 * y))
        detailedLabel.text = "Click here to see measurements for choosen dress type"
        detailedLabel.textAlignment = .justified
        detailedLabel.textColor = UIColor.white
        detailedLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
        detailedLabel.numberOfLines = 2
        hintsView.addSubview(detailedLabel)
    }
    
    func secondHint()
    {
        hintsImage.frame = CGRect(x: (6 * x), y: ((hintsView.frame.height - (3 * y)) / 2), width: hintsView.frame.width - (12 * x), height: (3 * y))
        hintsImage.layer.borderWidth = 0
        hintsImage.layer.borderColor = UIColor.clear.cgColor
        hintsImage.image = UIImage(named: "arrowHint")
        hintsView.addSubview(hintsImage)
        
        detailedLabel.frame = CGRect(x: (2 * x), y: hintsImage.frame.maxY + y, width: hintsView.frame.width - (4 * x), height: (5 * y))
        detailedLabel.text = "Click the arrow to enter measurement value"
        detailedLabel.textAlignment = .justified
        detailedLabel.textColor = UIColor.white
        detailedLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
        detailedLabel.numberOfLines = 2
        hintsView.addSubview(detailedLabel)
    }
    
    func thirdHint()
    {
        hintsImage.frame = CGRect(x: unitView.frame.minX, y: unitView.frame.minY, width: unitView.frame.width, height: unitView.frame.height)
        hintsImage.layer.borderWidth = 2
        hintsImage.layer.borderColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0).cgColor
        hintsImage.image = UIImage(named: "custom3Image")
        hintsView.addSubview(hintsImage)
        
        detailedLabel.frame = CGRect(x: (2 * x), y: unitView.frame.minY - (6 * y), width: hintsView.frame.width - (4 * x), height: (5 * y))
        detailedLabel.text = "Click here to convert the measurement values into CM or IN"
        detailedLabel.textAlignment = .justified
        detailedLabel.textColor = UIColor.white
        detailedLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
        detailedLabel.numberOfLines = 2
        hintsView.addSubview(detailedLabel)
    }
    
    func fourthHint()
    {
        hintsImage.frame = CGRect(x: partsButton.frame.minX, y: partsButton.frame.minY, width: partsButton.frame.width, height: partsButton.frame.height)
        hintsImage.layer.borderWidth = 2
        hintsImage.layer.borderColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0).cgColor
        hintsImage.image = UIImage(named: "imageHintImage")
        hintsView.addSubview(hintsImage)
        
        detailedLabel.frame = CGRect(x: (2 * x), y: hintsImage.frame.maxY + y, width: hintsView.frame.width - (4 * x), height: (5 * y))
        detailedLabel.text = "Click here to see measurements list for choosen dress type"
        detailedLabel.textAlignment = .justified
        detailedLabel.textColor = UIColor.white
        detailedLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
        detailedLabel.numberOfLines = 2
        hintsView.addSubview(detailedLabel)
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

                measurementValues[keys] = inchValue
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
        
        /*for i in 0..<4
         {
         if let theLabel = self.view.viewWithTag((i + 1) * 20) as? UILabel {
         let pageNo = Int(pageNumbers)
         let no = Int(theLabel.text!)! + 1
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
        activitySubContents()
        
        if let label = view.viewWithTag(sender.tag + 300) as? UILabel
        {
            measurerPartsName = label.text!
        }
        
        measurerTag = sender.tag
        
        type = "button"
        
        for i in 0..<PartsIdArray.count
        {
            if let id = PartsIdArray[i] as? Int
            {
                if id == sender.tag
                {
                    measurePartsImage = PartsImagesArray[i] as! String
                    self.measureScrollContents()
                }
            }
        }
        
//        serviceCall.API_GetMeasurementParts(MeasurementParts: sender.tag, delegate: self)
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
                    
                    if apiurl != nil
                    {
                        if let data = try? Data(contentsOf: apiurl!)
                        {
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
            
            stopSubActivity()
            
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
            
            MethodName = "GetMeasurementParts"
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func measureScrollContents()
    {
        stopSubActivity()
        
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
//        partsImageView.image = selectedconvertedPartsImageArray[0]
        if let imageName =  measurePartsImage as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/Measurement2/\(imageName)"
            let apiurl = URL(string: api)
            if apiurl != nil
            {
                partsImageView.dowloadFromServer(url: apiurl!)
            }
        }
        imageBackView.addSubview(partsImageView)
        
        partsNameLabel.frame = CGRect(x: partsImageView.frame.minX + ((partsImageView.frame.width - (10 * x)) / 2), y: partsImageView.frame.maxY + y, width: (10 * x), height: (3 * y))
        partsNameLabel.text = measurerPartsName
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
        
        cancelButton.frame = CGRect(x: rulerScroll.frame.maxX + x, y: partsMeasurementLabel.frame.maxY + (8 * y), width: (10 * x), height: (3 * y))
        cancelButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.addTarget(self, action: #selector(self.measureScrollCancelButtonAction(sender:)), for: .touchUpInside)
        cancelButton.tag = 3
        imageBackView.addSubview(cancelButton)
        
        saveButton.frame = CGRect(x: cancelButton.frame.maxX + (2 * y), y: partsMeasurementLabel.frame.maxY + (8 * y), width: (10 * x), height: (3 * y))
        saveButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        saveButton.setTitle("SAVE", for: .normal)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.addTarget(self, action: #selector(self.saveButtonAction(sender:)), for: .touchUpInside)
        saveButton.tag = 3
        imageBackView.addSubview(saveButton)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                changeViewToEnglishInSelf()
            }
            else if language == "ar"
            {
                changeViewToArabicInSelf()
            }
        }
        else
        {
            changeViewToEnglishInSelf()
        }
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
                let convertToInt:Double? = Double(label.text!)
                measurementValues.updateValue(convertToInt!, forKey: measurerTag)
            }
        }
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
        
        for i in 0..<2030
        {
            let measureLabel = UILabel()
            
            if (i % 10) == 0
            {
                measureLabel.frame = CGRect(x: 0, y: y1, width: (5.5 * x), height: (0.2 * y))
            }
            else if (i % 5) == 0
            {
                measureLabel.frame = CGRect(x: 0, y: y1, width: (3.5 * x), height: (0.2 * y))
            }
            else
            {
                measureLabel.frame = CGRect(x: 0, y: y1, width: (1.5 * x), height: (0.2 * y))
            }
            measureLabel.backgroundColor = UIColor.white
            
            if i < 2001
            {
                rulerScroll.addSubview(measureLabel)
            }
            
            let measureSizeLabel = UILabel()
            if(i % 10) == 0
            {
                y2 = measureLabel.frame.minY - y
                
                measureSizeLabel.frame = CGRect(x: measureLabel.frame.maxX + (x / 2), y: y2, width: (3.5 * x), height: (2 * y))
                measureSizeLabel.text = "\(i / 10)"
            }
            else if (i % 5) == 0
            {
                y2 = measureLabel.frame.minY - y
                
                measureSizeLabel.frame = CGRect(x: measureLabel.frame.maxX + (x / 2), y: y2, width: (4.5 * x), height: (2 * y))
                
                let halfValue = (i / 10)
                measureSizeLabel.text = "\(halfValue).5"
            }
            
            measureSizeLabel.textColor = UIColor.white
            measureSizeLabel.textAlignment = .left
            
            if i < 2001
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
        
        for views in rulerScroll.subviews
        {
            if let foundView = views as? UILabel
            {
                if let language = UserDefaults.standard.value(forKey: "language") as? String
                {
                    if language == "en"
                    {
                        foundView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        foundView.textAlignment = .left
                    }
                    else if language == "ar"
                    {
                        foundView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                        foundView.textAlignment = .right
                    }
                }
                else
                {
                    foundView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    foundView.textAlignment = .left
                }
            }
        }
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
        var keys = [Int]()
        var values = [Double]()
        
        for (keyss, valuess) in measurementValues
        {
            keys.append(keyss)
            values.append(valuess)
        }
        
        if values.contains(0.0)
        {
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    let customEmptyAlert = UIAlertController(title: "Alert", message: "Please enter all values to proceed", preferredStyle: .alert)
                    customEmptyAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(customEmptyAlert, animated: true, completion: nil)
                }
                else if language == "ar"
                {
                    let customEmptyAlert = UIAlertController(title: "محزر", message: "الرجاء إدخال جميع القيم للمتابعة", preferredStyle: .alert)
                    customEmptyAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: nil))
                    self.present(customEmptyAlert, animated: true, completion: nil)
                }
            }
            else
            {
                let customEmptyAlert = UIAlertController(title: "Alert", message: "Please enter all values to proceed", preferredStyle: .alert)
                customEmptyAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(customEmptyAlert, animated: true, completion: nil)
            }
        }
        else
        {
            UserDefaults.standard.set(keys, forKey: "measurementId")
            UserDefaults.standard.set(values, forKey: "measurementValues")
            UserDefaults.standard.set(0, forKey: "measurement2Response")
            let referenceScreen = ReferenceImageViewController()
            self.navigationController?.pushViewController(referenceScreen, animated: true)
        }
        
    }
    
    func partsViewContents(isHidden : Bool)
    {
        partsView.frame = CGRect(x: (4 * x), y: imageButton.frame.maxY + y, width: view.frame.width - (8 * x), height: view.frame.height - (imageButton.frame.maxY + tabBar.frame.height + (6 * y)))
        partsView.backgroundColor = UIColor.clear
        view.addSubview(partsView)
        
        partsView.isHidden = isHidden
        
        partsTableView.frame = CGRect(x: 0, y: 0, width: partsView.frame.width, height: partsView.frame.height)
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
        
        cancelButton.frame = CGRect(x: x, y: partsInputTextField.frame.maxY + (3 * y), width: ((view.frame.width / 2) - (2 * x)), height: (4 * y))
        cancelButton.backgroundColor = UIColor(red: 0.2353, green: 0.4, blue: 0.4471, alpha: 1.0)
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.addTarget(self, action: #selector(self.partsCancelButtonAction(sender:)), for: .touchUpInside)
        partsBackView.addSubview(cancelButton)
        
        saveButton.frame = CGRect(x: cancelButton.frame.maxX + (2 * x), y: partsInputTextField.frame.maxY + (3 * y), width: ((view.frame.width / 2) - (2 * x)), height: (4 * y))
        saveButton.backgroundColor = UIColor(red: 0.2353, green: 0.4, blue: 0.4471, alpha: 1.0)
        saveButton.setTitle("SAVE", for: .normal)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.addTarget(self, action: #selector(self.partsSaveButtonAction(sender:)), for: .touchUpInside)
        partsBackView.addSubview(saveButton)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                changeViewToEnglishInSelf()
            }
            else if language == "ar"
            {
                changeViewToArabicInSelf()
            }
        }
        else
        {
            changeViewToEnglishInSelf()
        }
    }
    
    @objc func partsCancelButtonAction(sender : UIButton)
    {
        partsBackView.removeFromSuperview()
    }
    
    @objc func partsSaveButtonAction(sender : UIButton)
    {
        
        let convertToInt:Double? = Double(partsInputTextField.text!)
        measurementValues.updateValue(convertToInt!, forKey: measurerTag)
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
        
        let valueCount:Int = PartsIdArray[indexPath.row] as! Int
        let value = measurementValues[valueCount]
        
        if value != nil
        {
            cell.partsSizeLabel.text = "\(value!)"
        }
        
        cell.selectionStyle = .none
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                cell.partsImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                cell.partsName.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                cell.partsSizeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                cell.partsName.textAlignment = .left
                cell.partsSizeLabel.textAlignment = .left
                
                cell.partsName.text = PartsNameArray[indexPath.row] as? String

            }
            else if language == "ar"
            {
                cell.partsImage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                cell.partsName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                cell.partsSizeLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                
                cell.partsName.textAlignment = .right
                cell.partsSizeLabel.textAlignment = .right
                
                cell.partsName.text = partsNameArabicArray[indexPath.row] as? String
            }
        }
        else
        {
            cell.partsImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell.partsName.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell.partsSizeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            cell.partsName.textAlignment = .left
            cell.partsSizeLabel.textAlignment = .left
            
            cell.partsName.text = PartsNameArray[indexPath.row] as? String
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return (6 * y)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        activitySubContents()
        
        let selectedInt = PartsIdArray[indexPath.row] as! Int
        
        type = "table"
        
        measurerTag = selectedInt
        
        self.view.bringSubviewToFront(activeViewSub)
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


extension UIBezierPath {
    func addArrow(start: CGPoint, end: CGPoint, pointerLineLength: CGFloat, arrowAngle: CGFloat) {
        self.move(to: start)
        self.addLine(to: end)
        
        let startEndAngle = atan((end.y - start.y) / (end.x - start.x)) + ((end.x - start.x) < 0 ? CGFloat(Double.pi) : 0)
        let arrowLine1 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle + arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle + arrowAngle))
        let arrowLine2 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle - arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle - arrowAngle))
        
        self.addLine(to: arrowLine1)
        self.move(to: end)
        self.addLine(to: arrowLine2)
    }
}
