//
//  PartsViewController.swift
//  Mzyoon
//
//  Created by QOL on 30/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class PartsViewController: UIViewController, UITextFieldDelegate, ServerAPIDelegate
{
    let serviceCall = ServerAPI()

    var viewTag = Int()
    
    var x = CGFloat()
    var y = CGFloat()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    // Parts...
    var PartsIdArray = NSArray()
    var PartsImagesArray = NSArray()
    var convertedPartsImageArray = [UIImage]()
    
    let commonScreen = CommonViewController()
    
    override func viewDidLoad()
    {
        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
        
        view.backgroundColor = UIColor.white
        
        print("VIEW TAG", viewTag)
        serviceCall.API_GetMeasurementParts(MeasurementParts: viewTag, delegate: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
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
                                partsContent()
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
    
    func partsContent()
    {
        self.title = "HEAD"
        
        let downArrowImageView = UIImageView()
        downArrowImageView.frame = CGRect(x: (2 * x), y: (7 * y), width: view.frame.width - (4 * x), height: (36.98 * y))
        downArrowImageView.image = convertedPartsImageArray[0]
        view.addSubview(downArrowImageView)
        
        print("WIDTH", downArrowImageView.frame.width)
        
        let cmLabel = UILabel()
        cmLabel.frame = CGRect(x: ((view.frame.width - (13 * x)) / 2), y: downArrowImageView.frame.maxY + y, width: (3 * x), height: (2 * y))
        cmLabel.text = "CM"
        cmLabel.textColor = UIColor.black
        cmLabel.textAlignment = .center
        view.addSubview(cmLabel)
        
        let addressSwitchButton = UISwitch()
        addressSwitchButton.frame = CGRect(x: cmLabel.frame.maxX + (x / 2), y: downArrowImageView.frame.maxY + y, width: (5 * x), height: (2 * y))
        view.addSubview(addressSwitchButton)
        
        let inchLabel = UILabel()
        inchLabel.frame = CGRect(x: addressSwitchButton.frame.maxX + (x / 2), y: downArrowImageView.frame.maxY + y, width: (5 * x), height: (2 * y))
        inchLabel.text = "Inches"
        inchLabel.textColor = UIColor.black
        inchLabel.textAlignment = .center
        view.addSubview(inchLabel)
        
        let mobileTextField = UITextField()
        mobileTextField.frame = CGRect(x: ((view.frame.width - (10 * x)) / 2), y: addressSwitchButton.frame.maxY + (2 * y), width: (10 * x), height: (4 * y))
        mobileTextField.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        mobileTextField.placeholder = "0.0"
        mobileTextField.textColor = UIColor.white
        mobileTextField.textAlignment = .center
        mobileTextField.font = UIFont(name: "Avenir-Heavy", size: 18)
        mobileTextField.leftViewMode = UITextField.ViewMode.always
        mobileTextField.adjustsFontSizeToFitWidth = true
        mobileTextField.keyboardType = .decimalPad
        mobileTextField.clearsOnBeginEditing = true
        mobileTextField.returnKeyType = .done
        mobileTextField.delegate = self
        view.addSubview(mobileTextField)
        
        let cancelButton = UIButton()
        cancelButton.frame = CGRect(x: x, y: mobileTextField.frame.maxY + (3 * y), width: ((view.frame.width / 2) - (2 * x)), height: (4 * y))
        cancelButton.backgroundColor = UIColor(red: 0.2353, green: 0.4, blue: 0.4471, alpha: 1.0)
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.addTarget(self, action: #selector(self.partsCancelButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        let saveButton = UIButton()
        saveButton.frame = CGRect(x: cancelButton.frame.maxX + (2 * x), y: mobileTextField.frame.maxY + (3 * y), width: ((view.frame.width / 2) - (2 * x)), height: (4 * y))
        saveButton.backgroundColor = UIColor(red: 0.2353, green: 0.4, blue: 0.4471, alpha: 1.0)
        saveButton.setTitle("SAVE", for: .normal)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.addTarget(self, action: #selector(self.partsSaveButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(saveButton)
    }
    
    @objc func partsCancelButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func partsSaveButtonAction(sender : UIButton)
    {
        
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
