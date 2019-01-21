//
//  MeasureScrollViewController.swift
//  Mzyoon
//
//  Created by QOL on 30/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class MeasureScrollViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, ServerAPIDelegate, UIScrollViewDelegate
{
    let serviceCall = ServerAPI()
    
    var x = CGFloat()
    var y = CGFloat()
    
    var headingTitle = String()
    var viewTag = Int()
    
    var pickerMeasure = 0
    let partsMeasurementLabel = UILabel()
    let rulerScroll = UIScrollView()


    // Parts...
    var PartsIdArray = NSArray()
    var PartsImagesArray = NSArray()
    var convertedPartsImageArray = [UIImage]()
    
    let measureScreen = Measurement2ViewController()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    override func viewDidLoad()
    {
        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
        
        self.title = headingTitle
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let backgroundImageView = UIImageView()
        backgroundImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        backgroundImageView.image = UIImage(named: "background")
        view.addSubview(backgroundImageView)
        
        serviceCall.API_GetMeasurementParts(MeasurementParts: viewTag, delegate: self)
                
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String) {
        print("ERROR MESSAGE", errorMessage)
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
       // ErrorStr = "Default Error"
        PageNumStr = "MeasureScrollViewController"
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
    
    func API_CALLBACK_GetMeasurementParts(getParts: NSDictionary)
    {
        let ResponseMsg = getParts.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = getParts.object(forKey: "Result") as! NSArray
            print("Result OF MEASUREMENT-2", Result)
            
            // Body Parts :
            PartsIdArray = Result.value(forKey: "Id") as! NSArray
            PartsImagesArray = Result.value(forKey: "Image") as! NSArray
            
            for i in 0..<PartsImagesArray.count
            {
                if let imageName = PartsImagesArray[i] as? String
                {
                    
                    //  let api = "http://192.168.0.21/TailorAPI/images/Measurement2/\(imageName)"
                    let api = "http://appsapi.mzyoon.com/images/Measurement2/\(imageName)"
                    let apiurl = URL(string: api)
                    print("PArts : ", api)
                    
                    if apiurl != nil
                    {
                        if let data = try? Data(contentsOf: apiurl!)
                        {
                            print("DATA OF IMAGE", data)
                            if let image = UIImage(data: data)
                            {
                                self.convertedPartsImageArray.append(image)
                                measureScrollContents()
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
        let measurement1NavigationBar = UIView()
        measurement1NavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        measurement1NavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
//        view.addSubview(measurement1NavigationBar)
        
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
        
        let rulerLabel = UILabel()
        rulerLabel.frame = CGRect(x: x, y: (8 * y), width: (15 * x), height: (2 * y))
        rulerLabel.text = "Measurement Ruler"
        rulerLabel.textColor = UIColor.black
        rulerLabel.textAlignment = .center
//        view.addSubview(rulerLabel)
        
        let measurePicker = UIPickerView()
        measurePicker.frame = CGRect(x: (2 * x), y: (10 * y), width: (10 * x), height: view.frame.height - (12 * y))
        measurePicker.backgroundColor = UIColor.lightGray
        measurePicker.showsSelectionIndicator = true
        measurePicker.dataSource = self
        measurePicker.delegate = self
//        view.addSubview(measurePicker)
        
        rulerContents()
        
        let partsImageView = UIImageView()
        partsImageView.frame = CGRect(x: measurePicker.frame.maxX + (3 * x), y: (10 * y), width: (20 * x), height: (20 * y))
        partsImageView.image = convertedPartsImageArray[0]
        view.addSubview(partsImageView)
        
        let partsNameLabel = UILabel()
        partsNameLabel.frame = CGRect(x: partsImageView.frame.minX + ((partsImageView.frame.width - (10 * x)) / 2), y: partsImageView.frame.maxY + y, width: (10 * x), height: (3 * y))
        partsNameLabel.text = headingTitle
        partsNameLabel.textColor = UIColor.black
        partsNameLabel.textAlignment = .center
        view.addSubview(partsNameLabel)
        
        partsMeasurementLabel.frame = CGRect(x: partsImageView.frame.minX + ((partsImageView.frame.width - (10 * x)) / 2), y: partsNameLabel.frame.maxY + y, width: (10 * x), height: (3 * y))
        partsMeasurementLabel.layer.cornerRadius = 10
        partsMeasurementLabel.backgroundColor = UIColor.orange
        partsMeasurementLabel.text = "0.0"
        partsMeasurementLabel.textColor = UIColor.white
        partsMeasurementLabel.textAlignment = .center
        view.addSubview(partsMeasurementLabel)
        
        let saveButton = UIButton()
        saveButton.frame = CGRect(x: partsImageView.frame.minX + ((partsImageView.frame.width - (15 * x)) / 2), y: partsMeasurementLabel.frame.maxY + (3 * y), width: (15 * x), height: (3 * y))
        saveButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        saveButton.setTitle("SAVE", for: .normal)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.addTarget(self, action: #selector(self.saveButtonAction(sender:)), for: .touchUpInside)
        saveButton.tag = 3
        view.addSubview(saveButton)
    }
    
    func rulerContents()
    {
        rulerScroll.frame = CGRect(x: (2 * x), y: (3 * y), width: (11 * x), height: view.frame.height - (6 * y))
        rulerScroll.delegate = self
        rulerScroll.scrollsToTop = true
        view.addSubview(rulerScroll)
        
        var y1:CGFloat = (30.4 * y)
        var y2:CGFloat = (29.4 * y)
        
        for i in 0..<1039
        {
            let measureLabel = UILabel()
            
            if (i % 10) == 0
            {
                measureLabel.frame = CGRect(x: 0, y: y1, width: (7.5 * x), height: (0.2 * y))
            }
            else if (i % 5) == 0
            {
                measureLabel.frame = CGRect(x: 0, y: y1, width: (5 * x), height: (0.2 * y))
            }
            else
            {
                measureLabel.frame = CGRect(x: 0, y: y1, width: (2.5 * x), height: (0.2 * y))
            }
            measureLabel.backgroundColor = UIColor.black
            
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
            
            measureSizeLabel.textColor = UIColor.black
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
        view.addSubview(selectedMeasureImage)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let value = Double(scrollView.contentOffset.y / (12 * y))
        let convertedString = "\(value)"
        
        let splitted = convertedString.split(separator: ".")
        
        let wholeNumber = splitted[0]
        let decimalNumber = splitted[1].prefix(1)
        
        if wholeNumber == "100"
        {
            scrollView.contentOffset.y = scrollView.contentOffset.y
        }
        
        if decimalNumber == "0"
        {
            partsMeasurementLabel.text = "\(wholeNumber)"
        }
        else
        {
            partsMeasurementLabel.text = "\(wholeNumber).\(decimalNumber)"
        }
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
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
        UserDefaults.standard.set(row + 1, forKey: "Measure-\(headingTitle)")
    }
    
    @objc func saveButtonAction(sender : UIButton)
    {
        print("SAVE BUTTON", sender.tag)
        measureScreen.popBackValue(value: partsMeasurementLabel.text!, viewTag: viewTag)
        self.navigationController?.popViewController(animated: true)
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
