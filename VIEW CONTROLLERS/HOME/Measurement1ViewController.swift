//
//  Measurement1ViewController.swift
//  Mzyoon
//
//  Created by QOL on 16/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class Measurement1ViewController: CommonViewController, ServerAPIDelegate
{
    var nameArray = [String]()
    var addNameAlert = UIAlertController()
    
    let serviceCall = ServerAPI()

    
    var Measure1IdArray = NSArray()
    var Measure1NameEngArray = NSArray()
    var Measure1BodyImage = NSArray()
    var convertedMeasure1BodyImageArray = [UIImage]()
    
    var existNameArray = NSArray()
    
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
        
        self.serviceCall.API_Measurement1(delegate: self)
        
        self.serviceCall.API_ExistingUserMeasurement(DressTypeId: 1, UserId: 1, delegate: self)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String) {
        print("MEASUREMENT 1", errorMessage)
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
       // ErrorStr = "Default Error"
        PageNumStr = "Measurement1ViewController"
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
    
    func API_CALLBACK_Measurement1(measure1: NSDictionary)
    {
        let ResponseMsg = measure1.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = measure1.object(forKey: "Result") as! NSArray
            print("Result OF MEASUREMENT", Result)
            
            Measure1NameEngArray = Result.value(forKey: "MeasurementInEnglish") as! NSArray
            print("Measure1EngArray", Measure1NameEngArray)
            
            Measure1IdArray = Result.value(forKey: "Id") as! NSArray
            print("Id", Measure1IdArray)
            
            Measure1BodyImage = Result.value(forKey: "BodyImage") as! NSArray
            print("Measure1BodyImageURL",Measure1BodyImage)
            
            /*for i in 0..<Measure1BodyImage.count
            {
                if let imageName = Measure1BodyImage[i] as? String
                {
                    let api = "http://appsapi.mzyoon.com/images/Measurement1/\(imageName)"
                    let apiurl = URL(string: api)
                    
                    print("IMAGE API", api)
                    
                    if let data = try? Data(contentsOf: apiurl!) {
                        print("DATA OF IMAGE", data)
                        if let image = UIImage(data: data) {
                            self.convertedMeasure1BodyImageArray.append(image)
                        }
                    }
                    else
                    {
                        let emptyImage = UIImage(named: "empty")
                        self.convertedMeasure1BodyImageArray.append(emptyImage!)
                    }
                }
                else if Measure1BodyImage[i] is NSNull
                {
                    let emptyImage = UIImage(named: "empty")
                    self.convertedMeasure1BodyImageArray.append(emptyImage!)
                }
            }*/
             self.measurement1Content()
        }
        else if ResponseMsg == "Failure"
        {
            let Result = measure1.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "DisplayMeasurement1"
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func API_CALLBACK_ExistingUserMeasurement(getExistUserMeasurement: NSDictionary)
    {
        let ResponseMsg = getExistUserMeasurement.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = getExistUserMeasurement.object(forKey: "Result") as! NSArray
            print("Existing User MEASUREMENT ", Result)
            
            existNameArray = Result.value(forKey: "Name") as! NSArray
            print("ExistNameArray", existNameArray)
        }
        else if ResponseMsg == "Failure"
        {
            let Result = getExistUserMeasurement.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetExistingUserMeasurement"
            ErrorStr = Result
            
            DeviceError()
        }
        
        
        for i in 0..<existNameArray.count
        {
            nameArray.append(existNameArray[i] as! String)
        }
    }
    
    func measurement1Content()
    {
        self.stopActivity()
        
        let measurement1View = UIView()
        measurement1View.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        measurement1View.backgroundColor = UIColor.white
//        view.addSubview(measurement1View)
        
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
        navigationTitle.text = "MEASUREMENT-1"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        measurement1NavigationBar.addSubview(navigationTitle)
        
        let manualTitleLabel = UILabel()
        manualTitleLabel.frame = CGRect(x: (4 * x), y: measurement1NavigationBar.frame.maxY + y, width: view.frame.width - (8 * x), height: (3 * y))
        manualTitleLabel.text = Measure1NameEngArray[0] as! String
        manualTitleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        manualTitleLabel.textAlignment = .left
        view.addSubview(manualTitleLabel)
        
        let manualButton = UIButton()
        manualButton.frame = CGRect(x: (4 * x), y: manualTitleLabel.frame.maxY, width: view.frame.width - (8 * x), height: (13 * y))
//        manualButton.backgroundColor = UIColor.red
//        manualButton.setImage(convertedMeasure1BodyImageArray[0], for: .normal)
        manualButton.tag = 0
        manualButton.addTarget(self, action: #selector(self.forWhomButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(manualButton)
        
        if let imageName = Measure1BodyImage[0] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/Measurement1/\(imageName)"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: manualButton.frame.width, height: manualButton.frame.height)
            dummyImageView.dowloadFromServer(url: apiurl!)
            manualButton.addSubview(dummyImageView)
        }
        
        let forWhomButton = UIButton()
        forWhomButton.frame = CGRect(x: (4 * x), y: manualButton.frame.maxY + (2 * y), width: view.frame.width - (8 * x), height: (3 * y))
        forWhomButton.backgroundColor = UIColor.white
        forWhomButton.setTitle("FOR WHOM", for: .normal)
        forWhomButton.setTitleColor(UIColor.black, for: .normal)
        forWhomButton.contentHorizontalAlignment = .left
        forWhomButton.addTarget(self, action: #selector(self.forWhomButtonAction(sender:)), for: .touchUpInside)
//        view.addSubview(forWhomButton)
        
        let downArrowImageView = UIImageView()
        downArrowImageView.frame = CGRect(x: forWhomButton.frame.width - (3 * x), y: (y / 2), width: (2 * x), height: (2 * y))
        downArrowImageView.image = UIImage(named: "downArrow")
        forWhomButton.addSubview(downArrowImageView)
        
        let goTitleLabel = UILabel()
        goTitleLabel.frame = CGRect(x: (4 * x), y: manualButton.frame.maxY + (2 * y), width: view.frame.width - (8 * x), height: (3 * y))
        goTitleLabel.text = Measure1NameEngArray[1] as! String
        goTitleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        goTitleLabel.textAlignment = .left
        view.addSubview(goTitleLabel)
        
        let goButton = UIButton()
        goButton.frame = CGRect(x: (4 * x), y: goTitleLabel.frame.maxY, width: view.frame.width - (8 * x), height: (13 * y))
//        goButton.backgroundColor = UIColor.red
//        goButton.setImage(convertedMeasure1BodyImageArray[1], for: .normal)
        goButton.tag = 1
        goButton.addTarget(self, action: #selector(self.measurement1NextButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(goButton)
        
        if let imageName = Measure1BodyImage[1] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/Measurement1/\(imageName)"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: goButton.frame.width, height: goButton.frame.height)
            dummyImageView.dowloadFromServer(url: apiurl!)
            goButton.addSubview(dummyImageView)
        }
        
        let comeTitleLabel = UILabel()
        comeTitleLabel.frame = CGRect(x: (4 * x), y: goButton.frame.maxY + (2 * y), width: view.frame.width - (8 * x), height: (3 * y))
        comeTitleLabel.text = Measure1NameEngArray[2] as! String
        comeTitleLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        comeTitleLabel.textAlignment = .left
        view.addSubview(comeTitleLabel)
        
        let comeButton = UIButton()
        comeButton.frame = CGRect(x: (4 * x), y: comeTitleLabel.frame.maxY, width: view.frame.width - (8 * x), height: (13 * y))
//        comeButton.backgroundColor = UIColor.red
//        comeButton.setImage(convertedMeasure1BodyImageArray[2], for: .normal)
        comeButton.tag = 2
        comeButton.addTarget(self, action: #selector(self.measurement1NextButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(comeButton)
        
        if let imageName = Measure1BodyImage[2] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/Measurement1/\(imageName)"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: comeButton.frame.width, height: comeButton.frame.height)
            dummyImageView.dowloadFromServer(url: apiurl!)
            comeButton.addSubview(dummyImageView)
        }
        
        let measurement1NextButton = UIButton()
        measurement1NextButton.frame = CGRect(x: view.frame.width - (10 * x), y: comeButton.frame.maxY + y, width: (8 * x), height: (3 * y))
        measurement1NextButton.layer.masksToBounds = true
        measurement1NextButton.backgroundColor = UIColor.orange
        measurement1NextButton.setTitle("NEXT", for: .normal)
        measurement1NextButton.setTitleColor(UIColor.white, for: .normal)
        measurement1NextButton.addTarget(self, action: #selector(self.measurement1NextButtonAction(sender:)), for: .touchUpInside)
//        view.addSubview(measurement1NextButton)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func forWhomButtonAction(sender : UIButton)
    {
        let userListAlert = UIAlertController(title: "For Whom ?", message: "Please select your option", preferredStyle: .alert)
        
        for i in 0..<nameArray.count
        {
            userListAlert.addAction(UIAlertAction(title: nameArray[i], style: .default, handler: nameSelection(action:)))
        }
        userListAlert.addAction(UIAlertAction(title: "Add New", style: .default, handler: addNewAlertAction(action:)))
        userListAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(userListAlert, animated: true, completion: nil)
    }
    
    func addNewAlertAction(action : UIAlertAction)
    {
        addNameAlert = UIAlertController(title: "Add Name", message: "for dress type - Coat", preferredStyle: .alert)
        addNameAlert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter the name"
        })
        addNameAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: addNewNameAlertAction(action:)))
        addNameAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(addNameAlert, animated: true, completion: nil)
    }
    
    func addNewNameAlertAction(action : UIAlertAction)
    {
        print("ACTION TEXT", addNameAlert.textFields![0].text!)
        
        nameArray.append(addNameAlert.textFields![0].text!)
        
        let measurement2Screen = Measurement2ViewController()
        self.navigationController?.pushViewController(measurement2Screen, animated: true)
    }
    
    func nameSelection(action : UIAlertAction)
    {
        let nameSelectionAlert = UIAlertController(title: "Continue", message: "Please select your option", preferredStyle: .alert)
        nameSelectionAlert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: proceedAlertAction(action:)))
        nameSelectionAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(nameSelectionAlert, animated: true, completion: nil)
    }
    
    func proceedAlertAction(action : UIAlertAction)
    {
        let referenceScreen = ReferenceImageViewController()
        self.navigationController?.pushViewController(referenceScreen, animated: true)
    }
    
    @objc func measurement1NextButtonAction(sender : UIButton)
    {
        let referencImageScreen = ReferenceImageViewController()
        self.navigationController?.pushViewController(referencImageScreen, animated: true)
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
