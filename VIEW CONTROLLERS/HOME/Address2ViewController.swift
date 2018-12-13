//
//  Address2ViewController.swift
//  Mzyoon
//
//  Created by QOL on 29/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class Address2ViewController: UIViewController, UITextFieldDelegate, ServerAPIDelegate
{
    
    var x = CGFloat()
    var y = CGFloat()
    
    let serviceCall = ServerAPI()
    
    let firstNameEnglishTextField = UITextField()
    let secondNameEnglishTextField = UITextField()
    let areaNameTextField = UITextField()
    let floorTextField = UITextField()
    let landMarkTextField = UITextField()
    let locationTypeTextField = UITextField()
    let mobileTextField = UITextField()
    let shippingNotesTextField = UITextField()
    
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
        
        view.backgroundColor = UIColor.white
        
        self.addressContents()
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("Insert Address", errorMessage)
        
        let alert = UIAlertController(title: "Alert", message: "Please try after some time", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
       // ErrorStr = "Default Error"
        PageNumStr = "Address2ViewController"
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
    
    func API_CALLBACK_InsertAddress(insertAddr: NSDictionary)
    {
        
        let ResponseMsg = insertAddr.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = insertAddr.object(forKey: "Result") as! String
            print("Result", Result)
            
            if Result == "1"
            {
                let alert = UIAlertController(title: "Alert", message: "Saved Sucessfully", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                let alert = UIAlertController(title: "Alert", message: "Please try after some time", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = insertAddr.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "InsertBuyerAddress"
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func addressContents()
    {
        let addressNavigationBar = UIView()
        addressNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        addressNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(addressNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 1
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        addressNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: addressNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "ADDRESS"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        addressNavigationBar.addSubview(navigationTitle)
        
        let locationIcon = UIImageView()
        locationIcon.frame = CGRect(x: x, y: addressNavigationBar.frame.maxY + y, width: (3 * x), height: (3 * y))
        locationIcon.backgroundColor = UIColor.cyan
        view.addSubview(locationIcon)
        
        let locationAddressLabel = UILabel()
        locationAddressLabel.frame = CGRect(x: locationIcon.frame.maxX + x, y: addressNavigationBar.frame.maxY + y, width: view.frame.width / 2, height: (3 * y))
        locationAddressLabel.text = "Location Address"
        locationAddressLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        locationAddressLabel.textAlignment = .left
        locationAddressLabel.font = UIFont(name: "Avenir-Regular", size: 20)
        locationAddressLabel.font = locationAddressLabel.font.withSize(20)
        view.addSubview(locationAddressLabel)
        
        let locationView = UIView()
        locationView.frame = CGRect(x: x, y: locationIcon.frame.maxY + y, width: view.frame.width - (2 * x), height: (8 * y))
        locationView.layer.cornerRadius = 5
        locationView.layer.borderWidth = 1
        locationView.layer.borderColor = UIColor.black.cgColor
        view.addSubview(locationView)
        
        let address1Label = UILabel()
        address1Label.frame = CGRect(x: x, y: y / 2, width: locationView.frame.width - (8 * x), height: (2 * y))
        address1Label.text = "Qol Tower, Sheik Kha;ifa Bin Saeed Street"
        address1Label.textColor = UIColor.black
        address1Label.textAlignment = .left
        address1Label.font = UIFont(name: "Avenir-Regular", size: 15)
        address1Label.font = address1Label.font.withSize(15)
        locationView.addSubview(address1Label)
        
        let address2Label = UILabel()
        address2Label.frame = CGRect(x: x, y: address1Label.frame.maxY, width: locationView.frame.width - (8 * x), height: (2 * y))
        address2Label.text = "P.O. Box 901"
        address2Label.textColor = UIColor.black
        address2Label.textAlignment = .left
        address2Label.font = UIFont(name: "Avenir-Regular", size: 15)
        address2Label.font = address2Label.font.withSize(15)
        locationView.addSubview(address2Label)
        
        let address3Label = UILabel()
        address3Label.frame = CGRect(x: x, y: address2Label.frame.maxY, width: locationView.frame.width - (8 * x), height: (2 * y))
        address3Label.text = "Abu Dhabi"
        address3Label.textColor = UIColor.black
        address3Label.textAlignment = .left
        address3Label.font = UIFont(name: "Avenir-Regular", size: 15)
        address3Label.font = address3Label.font.withSize(15)
        locationView.addSubview(address3Label)
        
        let editLocationButton = UIButton()
        editLocationButton.frame = CGRect(x: locationView.frame.width - (8.1 * x), y: 0.1 * y, width: (7.8 * x), height: (7.8 * y))
        editLocationButton.layer.cornerRadius = 5
        editLocationButton.layer.borderWidth = 1
        editLocationButton.layer.borderColor = UIColor.orange.cgColor
        editLocationButton.setImage(UIImage(named: "men"), for: .normal)
        editLocationButton.tag = 1
        editLocationButton.addTarget(self, action: #selector(self.locationEditButtonAction(sender:)), for: .touchUpInside)
        locationView.addSubview(editLocationButton)
        
        let editLabel = UILabel()
        editLabel.frame = CGRect(x: 4, y: editLocationButton.frame.height - (2 * y), width: editLocationButton.frame.width - 8, height: (2 * y))
        editLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        editLabel.text = "EDIT"
        editLabel.textColor = UIColor.white
        editLabel.textAlignment = .center
        editLabel.font = UIFont(name: "Avenir-Regular", size: 15)
        editLabel.font = editLabel.font.withSize(15)
        editLocationButton.addSubview(editLabel)
        
        let addressDefaultLabel = UILabel()
        addressDefaultLabel.frame = CGRect(x: (18 * x), y: locationView.frame.maxY + y + (y / 4), width: (12 * x), height: (2 * y))
        addressDefaultLabel.text = "Make as Default"
        addressDefaultLabel.textColor = UIColor.black
        addressDefaultLabel.textAlignment = .center
        addressDefaultLabel.font = UIFont(name: "Avenir-Regular", size: 15)
        addressDefaultLabel.font = editLabel.font.withSize(15)
        view.addSubview(addressDefaultLabel)
        
        let addressSwitchButton = UISwitch()
        addressSwitchButton.frame = CGRect(x: addressDefaultLabel.frame.maxX + (2 * x), y: locationView.frame.maxY + y, width: (5 * x), height: (2 * y))
        view.addSubview(addressSwitchButton)
        
        let addressInfoHeadingLabel = UILabel()
        addressInfoHeadingLabel.frame = CGRect(x: (3 * x), y: addressDefaultLabel.frame.maxY + (2 * y), width: view.frame.width - (6 * x), height: (3 * y))
        addressInfoHeadingLabel.backgroundColor = UIColor.lightGray
        addressInfoHeadingLabel.text = "Address Info"
        addressInfoHeadingLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        addressInfoHeadingLabel.textAlignment = .center
        addressInfoHeadingLabel.font = UIFont(name: "Avenir-Regular", size: 20)
        addressInfoHeadingLabel.font = editLabel.font.withSize(20)
        view.addSubview(addressInfoHeadingLabel)
        
        let addressScrollView = UIScrollView()
        addressScrollView.frame = CGRect(x: 0, y: addressInfoHeadingLabel.frame.maxY + y, width: view.frame.width, height: (33 * y))
//        addressScrollView.backgroundColor = UIColor.black
        view.addSubview(addressScrollView)
        
        addressScrollView.contentSize.height = (50 * y)
        
        let firstNameIcon = UIImageView()
        firstNameIcon.frame = CGRect(x: x, y: y, width: (2 * x), height: (2 * y))
        firstNameIcon.image = UIImage(named: "men")
        addressScrollView.addSubview(firstNameIcon)
        
        firstNameEnglishTextField.frame = CGRect(x: firstNameIcon.frame.maxX + x, y: y, width: addressScrollView.frame.width - (4 * x), height: (2 * y))
        firstNameEnglishTextField.placeholder = "First Name"
        firstNameEnglishTextField.textColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        firstNameEnglishTextField.textAlignment = .left
        firstNameEnglishTextField.font = UIFont(name: "Avenir-Heavy", size: 18)
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: firstNameEnglishTextField.frame.height))
//        firstNameEnglishTextField.leftView = paddingView
        firstNameEnglishTextField.leftViewMode = UITextField.ViewMode.always
        firstNameEnglishTextField.adjustsFontSizeToFitWidth = true
        firstNameEnglishTextField.keyboardType = .default
        firstNameEnglishTextField.clearsOnBeginEditing = true
        firstNameEnglishTextField.returnKeyType = .done
        firstNameEnglishTextField.delegate = self
        addressScrollView.addSubview(firstNameEnglishTextField)
        
        let firstNameEditButton = UIButton()
        firstNameEditButton.frame = CGRect(x: addressScrollView.frame.width - (3 * x), y: y, width: (2 * x), height: (2 * y))
        firstNameEditButton.backgroundColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        addressScrollView.addSubview(firstNameEditButton)
        
        let underline1 = UILabel()
        underline1.frame = CGRect(x: x, y: firstNameIcon.frame.maxY, width: view.frame.width - (2 * x), height: 1)
        underline1.backgroundColor = UIColor.lightGray
        addressScrollView.addSubview(underline1)
        
        let secondNameIcon = UIImageView()
        secondNameIcon.frame = CGRect(x: x, y: underline1.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        secondNameIcon.image = UIImage(named: "men")
        addressScrollView.addSubview(secondNameIcon)
        
        secondNameEnglishTextField.frame = CGRect(x: secondNameIcon.frame.maxX + x, y: underline1.frame.maxY + (3 * y), width: addressScrollView.frame.width - (4 * x), height: (2 * y))
        secondNameEnglishTextField.placeholder = "Second Name"
        secondNameEnglishTextField.textColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        secondNameEnglishTextField.textAlignment = .left
        secondNameEnglishTextField.font = UIFont(name: "Avenir-Heavy", size: 18)
//        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: secondNameEnglishTextField.frame.height))
//        secondNameEnglishTextField.leftView = paddingView1
        secondNameEnglishTextField.leftViewMode = UITextField.ViewMode.always
        secondNameEnglishTextField.adjustsFontSizeToFitWidth = true
        secondNameEnglishTextField.keyboardType = .default
        secondNameEnglishTextField.clearsOnBeginEditing = true
        secondNameEnglishTextField.returnKeyType = .done
        secondNameEnglishTextField.delegate = self
        addressScrollView.addSubview(secondNameEnglishTextField)
        
        let secondNameEditButton = UIButton()
        secondNameEditButton.frame = CGRect(x: addressScrollView.frame.width - (3 * x), y: underline1.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        secondNameEditButton.backgroundColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        addressScrollView.addSubview(secondNameEditButton)
        
        let underline2 = UILabel()
        underline2.frame = CGRect(x: x, y: secondNameIcon.frame.maxY, width: view.frame.width - (2 * x), height: 1)
        underline2.backgroundColor = UIColor.lightGray
        addressScrollView.addSubview(underline2)
        
        let countryIcon = UIImageView()
        countryIcon.frame = CGRect(x: x, y: underline2.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        countryIcon.image = UIImage(named: "men")
        addressScrollView.addSubview(countryIcon)
        
        let countryButton = UIButton()
        countryButton.frame = CGRect(x: countryIcon.frame.maxX + x, y: underline2.frame.maxY + (3 * y), width: addressScrollView.frame.width - (4 * x), height: (2 * y))
        countryButton.setTitle("Country", for: .normal)
        countryButton.setTitleColor(UIColor.lightGray, for: .normal)
        countryButton.contentHorizontalAlignment = .left
        addressScrollView.addSubview(countryButton)
        
        let countryDropDownIcon = UIImageView()
        countryDropDownIcon.frame = CGRect(x: addressScrollView.frame.width - (3 * x), y: underline2.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        countryDropDownIcon.backgroundColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        addressScrollView.addSubview(countryDropDownIcon)
        
        let underline3 = UILabel()
        underline3.frame = CGRect(x: x, y: countryIcon.frame.maxY, width: view.frame.width - (2 * x), height: 1)
        underline3.backgroundColor = UIColor.lightGray
        addressScrollView.addSubview(underline3)
        
        let stateIcon = UIImageView()
        stateIcon.frame = CGRect(x: x, y: underline3.frame.maxY + (3 * y), width: (2 * y), height: (2 * y))
        stateIcon.image = UIImage(named: "men")
        addressScrollView.addSubview(stateIcon)
        
        let stateButton = UIButton()
        stateButton.frame = CGRect(x: stateIcon.frame.maxX + x, y: underline3.frame.maxY + (3 * y), width: addressScrollView.frame.width - (4 * x), height: (2 * y))
        stateButton.setTitle("State", for: .normal)
        stateButton.setTitleColor(UIColor.lightGray, for: .normal)
        stateButton.contentHorizontalAlignment = .left
        addressScrollView.addSubview(stateButton)
        
        let stateDropDownIcon = UIImageView()
        stateDropDownIcon.frame = CGRect(x: addressScrollView.frame.width - (3 * x), y: underline3.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        stateDropDownIcon.backgroundColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        addressScrollView.addSubview(stateDropDownIcon)
        
        let underline4 = UILabel()
        underline4.frame = CGRect(x: x, y: stateIcon.frame.maxY, width: view.frame.width - (2 * x), height: 1)
        underline4.backgroundColor = UIColor.lightGray
        addressScrollView.addSubview(underline4)

        let areaIcon = UIImageView()
        areaIcon.frame = CGRect(x: x, y: underline4.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        areaIcon.image = UIImage(named: "men")
        addressScrollView.addSubview(areaIcon)
        
        areaNameTextField.frame = CGRect(x: areaIcon.frame.maxX + x, y: underline4.frame.maxY + (3 * y), width: addressScrollView.frame.width - (4 * x), height: (2 * y))
        areaNameTextField.placeholder = "Area"
        areaNameTextField.textColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        areaNameTextField.textAlignment = .left
        areaNameTextField.font = UIFont(name: "Avenir-Heavy", size: 18)
//        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: secondNameEnglishTextField.frame.height))
//        areaNameTextField.leftView = paddingView2
        areaNameTextField.leftViewMode = UITextField.ViewMode.always
        areaNameTextField.adjustsFontSizeToFitWidth = true
        areaNameTextField.keyboardType = .default
        areaNameTextField.clearsOnBeginEditing = true
        areaNameTextField.returnKeyType = .done
        areaNameTextField.delegate = self
        addressScrollView.addSubview(areaNameTextField)
        
        let areaEditButton = UIButton()
        areaEditButton.frame = CGRect(x: addressScrollView.frame.width - (3 * x), y: underline4.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        areaEditButton.backgroundColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        addressScrollView.addSubview(areaEditButton)
        
        let underline5 = UILabel()
        underline5.frame = CGRect(x: x, y: areaIcon.frame.maxY, width: view.frame.width - (2 * x), height: 1)
        underline5.backgroundColor = UIColor.lightGray
        addressScrollView.addSubview(underline5)
        
        let floorIcon = UIImageView()
        floorIcon.frame = CGRect(x: x, y: underline5.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        floorIcon.image = UIImage(named: "men")
        addressScrollView.addSubview(floorIcon)
        
        floorTextField.frame = CGRect(x: floorIcon.frame.maxX + x, y: underline5.frame.maxY + (3 * y), width: addressScrollView.frame.width - (4 * x), height: (2 * y))
        floorTextField.placeholder = "Floor"
        floorTextField.textColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        floorTextField.textAlignment = .left
        floorTextField.font = UIFont(name: "Avenir-Heavy", size: 18)
        //        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: secondNameEnglishTextField.frame.height))
        //        areaNameTextField.leftView = paddingView2
        floorTextField.leftViewMode = UITextField.ViewMode.always
        floorTextField.adjustsFontSizeToFitWidth = true
        floorTextField.keyboardType = .default
        floorTextField.clearsOnBeginEditing = true
        floorTextField.returnKeyType = .done
        floorTextField.delegate = self
        addressScrollView.addSubview(floorTextField)
        
        let floorEditButton = UIButton()
        floorEditButton.frame = CGRect(x: addressScrollView.frame.width - (3 * x), y: underline5.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        floorEditButton.backgroundColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        addressScrollView.addSubview(floorEditButton)
        
        let underline6 = UILabel()
        underline6.frame = CGRect(x: x, y: floorIcon.frame.maxY, width: view.frame.width - (2 * x), height: 1)
        underline6.backgroundColor = UIColor.lightGray
        addressScrollView.addSubview(underline6)
        
        let landMarkIcon = UIImageView()
        landMarkIcon.frame = CGRect(x: x, y: underline6.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        landMarkIcon.image = UIImage(named: "men")
        addressScrollView.addSubview(landMarkIcon)
        
        landMarkTextField.frame = CGRect(x: landMarkIcon.frame.maxX + x, y: underline6.frame.maxY + (3 * y), width: addressScrollView.frame.width - (4 * x), height: (2 * y))
        landMarkTextField.placeholder = "Land Mark"
        landMarkTextField.textColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        landMarkTextField.textAlignment = .left
        landMarkTextField.font = UIFont(name: "Avenir-Heavy", size: 18)
        //        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: secondNameEnglishTextField.frame.height))
        //        areaNameTextField.leftView = paddingView2
        landMarkTextField.leftViewMode = UITextField.ViewMode.always
        landMarkTextField.adjustsFontSizeToFitWidth = true
        landMarkTextField.keyboardType = .default
        landMarkTextField.clearsOnBeginEditing = true
        landMarkTextField.returnKeyType = .done
        landMarkTextField.delegate = self
        addressScrollView.addSubview(landMarkTextField)
        
        let landMarkEditButton = UIButton()
        landMarkEditButton.frame = CGRect(x: addressScrollView.frame.width - (3 * x), y: underline6.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        landMarkEditButton.backgroundColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        addressScrollView.addSubview(landMarkEditButton)
        
        let underline7 = UILabel()
        underline7.frame = CGRect(x: x, y: landMarkIcon.frame.maxY, width: view.frame.width - (2 * x), height: 1)
        underline7.backgroundColor = UIColor.lightGray
        addressScrollView.addSubview(underline7)
        
        let locationTypeIcon = UIImageView()
        locationTypeIcon.frame = CGRect(x: x, y: underline7.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        locationTypeIcon.image = UIImage(named: "men")
        addressScrollView.addSubview(locationTypeIcon)
        
        locationTypeTextField.frame = CGRect(x: locationTypeIcon.frame.maxX + x, y: underline7.frame.maxY + (3 * y), width: addressScrollView.frame.width - (4 * x), height: (2 * y))
        locationTypeTextField.placeholder = "Location Type"
        locationTypeTextField.textColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        locationTypeTextField.textAlignment = .left
        locationTypeTextField.font = UIFont(name: "Avenir-Heavy", size: 18)
        //        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: secondNameEnglishTextField.frame.height))
        //        areaNameTextField.leftView = paddingView2
        locationTypeTextField.leftViewMode = UITextField.ViewMode.always
        locationTypeTextField.adjustsFontSizeToFitWidth = true
        locationTypeTextField.keyboardType = .default
        locationTypeTextField.clearsOnBeginEditing = true
        locationTypeTextField.returnKeyType = .done
        locationTypeTextField.delegate = self
        addressScrollView.addSubview(locationTypeTextField)
        
        let locationTypeEditButton = UIButton()
        locationTypeEditButton.frame = CGRect(x: addressScrollView.frame.width - (3 * x), y: underline7.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        locationTypeEditButton.backgroundColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        addressScrollView.addSubview(locationTypeEditButton)
        
        let underline8 = UILabel()
        underline8.frame = CGRect(x: x, y: locationTypeIcon.frame.maxY, width: view.frame.width - (2 * x), height: 1)
        underline8.backgroundColor = UIColor.lightGray
        addressScrollView.addSubview(underline8)
        
        let mobileCountryCodeButton = UIButton()
        mobileCountryCodeButton.frame = CGRect(x: x, y: underline8.frame.maxY + (3 * y), width: (10 * x), height: (2 * y))
        mobileCountryCodeButton.backgroundColor = UIColor(red: 0.7647, green: 0.7882, blue: 0.7765, alpha: 1.0)
//        mobileCountryCodeButton.addTarget(self, action: #selector(self.countryCodeButtonAction(sender:)), for: .touchUpInside)
        addressScrollView.addSubview(mobileCountryCodeButton)
        
        let flagImageView = UIImageView()
        flagImageView.frame = CGRect(x: (x / 2), y: (y / 2), width: (2.5 * x), height: (mobileCountryCodeButton.frame.height - y))
        flagImageView.image = UIImage(named: "empty")
        mobileCountryCodeButton.addSubview(flagImageView)
        
        let mobileCountryCodeLabel = UILabel()
        mobileCountryCodeLabel.frame = CGRect(x: flagImageView.frame.maxX + (x / 2), y: 0, width: (4 * x), height: mobileCountryCodeButton.frame.height)
        mobileCountryCodeLabel.text = ""
        mobileCountryCodeLabel.textColor = UIColor.black
        mobileCountryCodeLabel.textAlignment = .left
        mobileCountryCodeLabel.font = UIFont(name: "Avenir-Heavy", size: 18)
        mobileCountryCodeButton.addSubview(mobileCountryCodeLabel)
        
        let downArrowImageView = UIImageView()
        downArrowImageView.frame = CGRect(x: mobileCountryCodeButton.frame.width - 20, y: ((mobileCountryCodeButton.frame.height - 15) / 2), width: 15, height: 15)
        downArrowImageView.image = UIImage(named: "downArrow")
        mobileCountryCodeButton.addSubview(downArrowImageView)
        
        let mobileImageView = UIImageView()
        mobileImageView.frame = CGRect(x: mobileCountryCodeButton.frame.maxX  + x, y: underline8.frame.maxY + (3 * y), width: (1.5 * x), height: (2 * y))
        mobileImageView.image = UIImage(named: "mobile")
        addressScrollView.addSubview(mobileImageView)
        
        mobileTextField.frame = CGRect(x: mobileImageView.frame.maxX + 2, y: underline8.frame.maxY + (3 * y), width: addressScrollView.frame.width - (13 * x), height: (2 * y))
        mobileTextField.placeholder = "Mobile Number"
        mobileTextField.textColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        mobileTextField.textAlignment = .left
        mobileTextField.font = UIFont(name: "Avenir-Heavy", size: 18)
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.mobileTextField.frame.height))
//        mobileTextField.leftView = paddingView
        mobileTextField.leftViewMode = UITextField.ViewMode.always
        mobileTextField.adjustsFontSizeToFitWidth = true
        mobileTextField.keyboardType = .default
        mobileTextField.clearsOnBeginEditing = true
        mobileTextField.returnKeyType = .done
        mobileTextField.delegate = self
        addressScrollView.addSubview(mobileTextField)
        
        let underline9 = UILabel()
        underline9.frame = CGRect(x: mobileImageView.frame.minX, y: mobileTextField.frame.maxY, width: mobileTextField.frame.width, height: 1)
        underline9.backgroundColor = UIColor.gray
        addressScrollView.addSubview(underline9)
        
        let shippingNotesIcon = UIImageView()
        shippingNotesIcon.frame = CGRect(x: x, y: underline9.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        shippingNotesIcon.image = UIImage(named: "men")
        addressScrollView.addSubview(shippingNotesIcon)
        
        shippingNotesTextField.frame = CGRect(x: shippingNotesIcon.frame.maxX + x, y: underline9.frame.maxY + (3 * y), width: addressScrollView.frame.width - (4 * x), height: (2 * y))
        shippingNotesTextField.placeholder = "Shipping Notes"
        shippingNotesTextField.textColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        shippingNotesTextField.textAlignment = .left
        shippingNotesTextField.font = UIFont(name: "Avenir-Heavy", size: 18)
        //        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: secondNameEnglishTextField.frame.height))
        //        areaNameTextField.leftView = paddingView2
        shippingNotesTextField.leftViewMode = UITextField.ViewMode.always
        shippingNotesTextField.adjustsFontSizeToFitWidth = true
        shippingNotesTextField.keyboardType = .default
        shippingNotesTextField.clearsOnBeginEditing = true
        shippingNotesTextField.returnKeyType = .done
        shippingNotesTextField.delegate = self
        addressScrollView.addSubview(shippingNotesTextField)
        
        let shippingNotesEditButton = UIButton()
        shippingNotesEditButton.frame = CGRect(x: addressScrollView.frame.width - (3 * x), y: underline9.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        shippingNotesEditButton.backgroundColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        addressScrollView.addSubview(shippingNotesEditButton)
        
        let underline10 = UILabel()
        underline10.frame = CGRect(x: x, y: shippingNotesIcon.frame.maxY, width: view.frame.width - (2 * x), height: 1)
        underline10.backgroundColor = UIColor.lightGray
        addressScrollView.addSubview(underline10)
        
        let saveButton = UIButton()
        saveButton.frame = CGRect(x: view.frame.width - (18 * x), y: addressScrollView.frame.maxY + y, width: (15 * x), height: (3 * y))
        saveButton.backgroundColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        saveButton.setTitle("Save and Next", for: .normal)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.addTarget(self, action: #selector(self.saveAndNextButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(saveButton)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func locationEditButtonAction(sender : UIButton)
    {
        let mapScreen = LocationViewController()
        self.navigationController?.pushViewController(mapScreen, animated: true)
    }
    
    @objc func saveAndNextButtonAction(sender : UIButton)
    {
        let FirstNameStr = firstNameEnglishTextField.text
        let lastNameStr = secondNameEnglishTextField.text
        let CountryId = 1
        let stateId = 4
        let AreaStr = areaNameTextField.text
        let floorStr = floorTextField.text
        let LandmarkStr = landMarkTextField.text
        let locationTypeStr = locationTypeTextField.text
        let shippingStr = shippingNotesTextField.text
        let SetDefaultStr = "True"
        let CountryCode = 91
        let PhoneNum = mobileTextField.text
        let latitude = 1.2345
        let longitude = 2.2345
        
        serviceCall.API_InsertAddress(FirstName: FirstNameStr!, LastName: lastNameStr!, CountryId: CountryId, StateId: stateId, Area: AreaStr!, Floor: floorStr!, LandMark: LandmarkStr!, LocationType: locationTypeStr!, ShippingNotes: shippingStr!, IsDefault: SetDefaultStr, CountryCode: CountryCode, PhoneNo: PhoneNum!, Longitude: Float(longitude), Latitude: Float(latitude), delegate: self)
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
