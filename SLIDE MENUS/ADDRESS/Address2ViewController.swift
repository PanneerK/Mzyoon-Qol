//
//  Address2ViewController.swift
//  Mzyoon
//
//  Created by QOL on 29/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import GoogleMaps
import GooglePlaces

class Address2ViewController: UIViewController, UITextFieldDelegate, ServerAPIDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, GMSMapViewDelegate
{
    
    var x = CGFloat()
    var y = CGFloat()
    
    var getAddressId = Int()
    
    var addressString = [String]()
    var splittedAddress = [String]()
    var getLocation = CLLocationCoordinate2D()
    var editStateId = Int()
    var editCountryId = Int()
    var checkScreen = Int()
    var editAreaId = Int()
    
    var getEditId = Int()
    var checkDefault = Int()
    
    let serviceCall = ServerAPI()
    
    //SCREEN PARAMETERS
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()
    let locationAddressLabel = UILabel()
    let address1Label = UILabel()
    let editLocationButton = UIButton()
    let editLabel = UILabel()
    let addressDefaultLabel = UILabel()
    let addressInfoHeadingLabel = UILabel()
    let saveButton = UIButton()
    let countryCodeTitleLabel = UILabel()


    let addressScrollView = UIScrollView()
    let firstNameEnglishTextField = UITextField()
    let secondNameEnglishTextField = UITextField()
    let areaButton = UIButton()
    let floorTextField = UITextField()
    let landMarkTextField = UITextField()
    let locationTypeTextField = UITextField()
    let mobileCountryCodeButton = UIButton()
    let mobileTextField = UITextField()
    let shippingNotesTextField = UITextField()
    
    var latitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    
    let flagImageView = UIImageView()
    let mobileCountryCodeLabel = UILabel()
    
    let blurView = UIView()
    let countryCodeTableView = UITableView()
    let countryTableView = UITableView()
    
    let countryButton = UIButton()
    let stateButton = UIButton()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    //COUNTRY CODE API PARAMETER
    var countryCodeArray = NSArray()
    var countryNameArray = NSArray()
    var countryIdArray = NSArray()
    var countryFlagArray = NSArray()
    var individualCountryFlagArray = [UIImage]()
    
    //State CODE API PARAMETER
    var stateCodeArray = NSArray()
    var stateNameArray = NSArray()
    var checkStateName = 1
    var checkAreaName = 1
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var setDefault = "FALSE"
    
    var getStateId = Int()
    var getCountryId = Int()
    var getAreaId = Int()
    var getCountryCode = String()

    var insertOrUpdate = 1
    
    var addressStringArray = NSArray()
    
    var screenTag = 1
    var checkTag = 0
    var setOrHide = 0
    
    var countryAlert = UIAlertController()
    
    //COUNTRY BUTTON ACTION PARAMETERS
    let languageButton = UIButton()
    let alertView = UIView()
    let titleLabel = UILabel()
    let cancelButton = UIButton()
    
    //ACTIVITY PARAMETERS
    var activeView = UIView()
    var activityView = UIActivityIndicatorView()
    
    //AREA LIST API PARAMETERS
    let areaBlurView = UIView()
    let areaTableView = UITableView()

    var areaCodeArray = NSArray()
    var areaNameArray = NSArray()
    
    //SCREEN CONTENTS
    let addressSwitchButton = UISwitch()
    
    var applicationDelegate = AppDelegate()

    
    override func viewDidLoad()
    {
        activityContents()
        
        print("ADDRESS STRING ADDRESS 2 VIEW CONTROLLER 1", addressString)

        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
        
        fetchingCurrentLocation()
        
        let coords = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        reverseGeocodeCoordinate(coords)
        
        if screenTag == 1
        {
            setOrHide = 1
            if checkTag == 1
            {
                getAddressId = Variables.sharedManager.individualAddressId
            }
            else
            {
                
            }
            serviceCall.API_GetBuyerIndividualAddressByAddressId(addressId : "\(getAddressId)", delegate : self)
        }
        else
        {
            serviceCall.API_CountryCode(delegate: self)
        }
        
        view.backgroundColor = UIColor.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.addDoneButtonOnKeyboard()
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func activityContents()
    {
        activeView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        activeView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        view.addSubview(activeView)
        
        activityView.frame = CGRect(x: ((activeView.frame.width - 50) / 2), y: ((activeView.frame.height - 50) / 2), width: 50, height: 50)
        activityView.style = .whiteLarge
        activityView.color = UIColor.white
        activityView.startAnimating()
        activeView.addSubview(activityView)
    }
    
    func stopActivity()
    {
        activeView.removeFromSuperview()
        activityView.stopAnimating()
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
        
        self.mobileTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        if (mobileTextField.text?.count)! > 20 || (mobileTextField.text?.count)! < 6
        {
            var mobileAlert = UIAlertController()
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    mobileAlert = UIAlertController(title: "Alert", message: "Please enter a valid mobile number", preferredStyle: .alert)
                    mobileAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                }
                else if language == "ar"
                {
                    mobileAlert = UIAlertController(title: "تنبيه", message: "الرجاء إدخال رقم جوال صحيح", preferredStyle: .alert)
                    mobileAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: nil))
                }
            }
            else
            {
                mobileAlert = UIAlertController(title: "Alert", message: "Please enter a valid mobile number", preferredStyle: .alert)
                mobileAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            }
            
            self.present(mobileAlert, animated: true, completion: nil)

        }
        else
        {
            self.view.endEditing(true)
        }
    }
    
    func fetchingCurrentLocation()
    {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        currentLocation = locationManager.location
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.requestAlwaysAuthorization()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        else
        {
            // initialise a pop up for using later
            let alertController = UIAlertController(title: "TITLE", message: "Please go to Settings and turn on the permissions", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl)
                {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
        }
        
        #if targetEnvironment(simulator)
        // your simulator code
        print("APP IS RUNNING ON SIMULATOR")
        #else
        // your real device code
        print("APP IS RUNNING ON DEVICE")
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways)
        {
            
            currentLocation = locationManager.location
            print("Current Loc:",currentLocation.coordinate)
        }
        
        #endif
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D)
    {
        
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
            // 3
            print("GET CURRENT ADDRESS", lines.joined(separator: "\n"))
            
//            self.addressString = [lines.joined(separator: "\n")]
            
            //  self.addressLabel.text = lines.joined(separator: "\n")
            
            // 4
            UIView.animate(withDuration: 0.25)
            {
                self.view.layoutIfNeeded()
            }
        }
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
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("Insert Address", errorMessage)
        
        stopActivity()
        applicationDelegate.exitContents()
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
    
    func API_CALLBACK_GetBuyerIndividualAddressByAddressId(getAddress : NSDictionary)
    {
        print("zzzzzzzzzzzz", getAddress)
        
        let ResponseMsg = getAddress.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = getAddress.object(forKey: "Result") as! NSArray
            
            if Result.count != 0
            {
                let FirstName = Result.value(forKey: "FirstName") as! NSArray
                print("FirstName", FirstName)
                
                let LastName = Result.value(forKey: "LastName") as! NSArray
                print("LastName", LastName)
                
                let PhoneNo = Result.value(forKey: "PhoneNo") as! NSArray
                print("PhoneNo", PhoneNo)
                
                let Lattitude = Result.value(forKey: "Lattitude") as! NSArray
                print("Lattitude", Lattitude)
                
                let Longitude = Result.value(forKey: "Longitude") as! NSArray
                print("Longitude", Longitude)
                
                let isDefault = Result.value(forKey: "IsDefault") as! NSArray
                print("IsDefault", isDefault)
                
                let Id = Result.value(forKey: "Id") as! NSArray
                print("ADDRESS ID ARRAY", Id)
                
                let LocationType = Result.value(forKey: "LocationType") as! NSArray
                print("LocationType", LocationType)
                
                let Floor = Result.value(forKey: "Floor") as! NSArray
                print("Floor", Floor)
                
                let LandMark = Result.value(forKey: "LandMark") as! NSArray
                print("LandMark", LandMark)
                
                let CountryCode = Result.value(forKey: "CountryCode") as! NSArray
                print("CountryCode", CountryCode)
                
                let ShippingNotes = Result.value(forKey: "ShippingNotes") as! NSArray
                print("ShippingNotes", ShippingNotes)
                
                let StateId = Result.value(forKey: "StateId") as! NSArray
                print("StateId", StateId)

                let CountryId = Result.value(forKey: "CountryId") as! NSArray
                print("CountryId", CountryId)

                let areaId = Result.value(forKey: "AreaId") as! NSArray
                print("areaId", areaId)
                
                firstNameEnglishTextField.text = FirstName[0] as? String
                secondNameEnglishTextField.text = LastName[0] as? String
                floorTextField.text = Floor[0] as? String
                landMarkTextField.text = LandMark[0] as? String
                locationTypeTextField.text = LocationType[0] as? String
                mobileCountryCodeLabel.text = CountryCode[0] as? String
                mobileTextField.text = PhoneNo[0] as? String
                shippingNotesTextField.text = ShippingNotes[0] as? String
                
                getCountryId = CountryId[0] as! Int
                getStateId = StateId[0] as! Int
                getAreaId = areaId[0] as! Int
                getCountryCode = CountryCode[0] as! String
                
                getEditId = Id[0] as! Int
                
                if let defaultValue = isDefault[0] as? Int
                {
                    checkDefault = defaultValue
                    
                    if defaultValue == 0
                    {
                        setDefault = "FALSE"
                    }
                    else
                    {
                        setDefault = "TRUE"
                    }
                }
                else if let defaultValue = isDefault[0] as? Bool
                {
                    if defaultValue == true
                    {
                        checkDefault = 1
                        setDefault = "TRUE"
                    }
                    else
                    {
                        checkDefault = 0
                        setDefault = "FALSE"
                    }
                }
                
                if checkScreen == 1
                {

                }
                else
                {
                    getLocation = CLLocationCoordinate2D(latitude: Lattitude[0] as! CLLocationDegrees, longitude: Longitude[0] as! CLLocationDegrees)
                }
                
                
                print("GET LOCATION CHECK", getLocation)
                
                if getLocation.latitude == 0.0 || getLocation.longitude == 0.0
                {
                    
                }
                else
                {
                    let geoCoder = GMSGeocoder()
                    geoCoder.reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: getLocation.latitude, longitude: getLocation.longitude)) { response, error in
                        
                        guard let address = response?.firstResult(), let lines = address.lines else {
                            print("FAILED TO RTURN ADDRESS")
                            return
                        }
                        
                        print("INBUILD FUNCTION", address)
                        print("SUCCESS OF ADDRESS FOR LATITUDE", lines)
                        
                        self.addressString = lines
                        
                        self.addressContents()
                    }
                }
                
                serviceCall.API_CountryCode(delegate: self)
                serviceCall.API_GetStateListByCountry(countryId: "\(getCountryId)", delegate: self)
                serviceCall.API_GetAreaByState(stateId: "\(getStateId)", delegate: self)
            }
        }
        else
        {
            
        }
    }
    
    func API_CALLBACK_InsertAddress(insertAddr: NSDictionary)
    {
        let ResponseMsg = insertAddr.object(forKey: "ResponseMsg") as! String
        
        stopActivity()
        
        if ResponseMsg == "Success"
        {
            let Result = insertAddr.object(forKey: "Result") as! String
            print("Result", Result)
            
            if Result == "1"
            {
                Variables.sharedManager.firstName = ""
                Variables.sharedManager.secondName = ""
                Variables.sharedManager.countryName = ""
                Variables.sharedManager.stateName = ""
                Variables.sharedManager.areaName = ""
                Variables.sharedManager.floor = ""
                Variables.sharedManager.landmark = ""
                Variables.sharedManager.locationType = ""
                Variables.sharedManager.mobileNumber = ""
                Variables.sharedManager.countryCode = ""
                Variables.sharedManager.shippingNotes = ""
                
                Variables.sharedManager.countryCodeId = 0
                Variables.sharedManager.stateId = 0
                Variables.sharedManager.areaId = 0
                Variables.sharedManager.checkDefaultId = 0
                
                var saveAlert = UIAlertController()
                
                if let language = UserDefaults.standard.value(forKey: "language") as? String
                {
                    if language == "en"
                    {
                        saveAlert = UIAlertController(title: "Alert", message: "Saved Sucessfully", preferredStyle: UIAlertController.Style.alert)
                        saveAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: apiSuccessResponseAlertOkAction(action:)))
                    }
                    else if language == "ar"
                    {
                        saveAlert = UIAlertController(title: "تنبيه", message: "حفظ بنجاح", preferredStyle: UIAlertController.Style.alert)
                        saveAlert.addAction(UIAlertAction(title: "حسنا", style: UIAlertAction.Style.default, handler: apiSuccessResponseAlertOkAction(action:)))
                    }
                }
                else
                {
                    saveAlert = UIAlertController(title: "Alert", message: "Saved Sucessfully", preferredStyle: UIAlertController.Style.alert)
                    saveAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: apiSuccessResponseAlertOkAction(action:)))
                }
                
                self.present(saveAlert, animated: true, completion: nil)

            }
            else
            {
                var saveAlert = UIAlertController()
                
                if let language = UserDefaults.standard.value(forKey: "language") as? String
                {
                    if language == "en"
                    {
                        saveAlert = UIAlertController(title: "Alert", message: "Please try after some time", preferredStyle: UIAlertController.Style.alert)
                        saveAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: apiSuccessResponseAlertOkAction(action:)))
                    }
                    else if language == "ar"
                    {
                        saveAlert = UIAlertController(title: "تنبيه", message: "يرجى المحاولة مرة أخرى بعد فترة من الوقت", preferredStyle: UIAlertController.Style.alert)
                        saveAlert.addAction(UIAlertAction(title: "حسنا", style: UIAlertAction.Style.default, handler: apiSuccessResponseAlertOkAction(action:)))
                    }
                }
                else
                {
                    saveAlert = UIAlertController(title: "Alert", message: "Please try after some time", preferredStyle: UIAlertController.Style.alert)
                    saveAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: apiSuccessResponseAlertOkAction(action:)))
                }
                
                self.present(saveAlert, animated: true, completion: nil)
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
    
    func apiSuccessResponseAlertOkAction(action : UIAlertAction)
    {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        
        if screenTag == 1
        {
            if checkScreen == 1
            {
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
            }
            else
            {
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
            }
        }
        else
        {
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        }
    }
    
    func API_CALLBACK_CountryCode(countryCodes: NSDictionary) {
        
        let responseMsg = countryCodes.object(forKey: "ResponseMsg") as! String
        
        if responseMsg == "Success"
        {
            let result = countryCodes.object(forKey: "Result") as! NSArray
            
            print("COUNTRY LIST IN ADDRESS", result)
            
            countryNameArray = result.value(forKey: "CountryName") as! NSArray
            
            countryIdArray = result.value(forKey: "Id") as! NSArray
            
            countryCodeArray = result.value(forKey: "PhoneCode") as! NSArray
            
            countryFlagArray = result.value(forKey: "Flag") as! NSArray
            
            print("COUNT OF", countryFlagArray.count)
            
            if screenTag == 1
            {
                getAddressId = Variables.sharedManager.individualAddressId
//
//                if getAddressId != 0
//                {
//                    serviceCall.API_GetBuyerIndividualAddressByAddressId(addressId : "\(getAddressId)", delegate : self)
//                }
            }
            else
            {
                self.addressContents()
            }
            
            if screenTag == 1 && setOrHide == 1
            {
                for i in 0..<countryIdArray.count
                {
                    if let matchId = countryIdArray[i] as? Int
                    {
                        if getCountryId == matchId
                        {
                            if let country = countryNameArray[i] as? String
                            {
                                print("COUNTRY NAME MATCHED", country, editCountryId, matchId)
                                let convertedString = country.split(separator: "(")
                                countryButton.setTitle("\(convertedString[0])", for: .normal)
                                
                                //                            serviceCall.API_GetStateListByCountry(countryId: "\(countryIdArray[i])", delegate: self)
//                                stateButton.setTitle("State", for: .normal)
                            }
                        }
                    }
                }
            }
            
            if screenTag == 1
            {
                for i in 0..<countryCodeArray.count
                {
                    if let id = countryCodeArray[i] as? String
                    {
                        if id == getCountryCode
                        {
                            print("ID OF DE 1", id, getCountryCode)
                            
                            if let imageName = countryFlagArray[i] as? String
                            {
                                let urlString = serviceCall.baseURL
                                let api = "\(urlString)/images/flags/\(imageName)"
                                let apiurl = URL(string: api)
                                
                                if apiurl != nil
                                {
                                    flagImageView.dowloadFromServer(url: apiurl!)
                                }
                                else
                                {
                                    flagImageView.image = UIImage(named: "empty")
                                }
                            }
                            
                            mobileCountryCodeLabel.text = (countryCodeArray[i] as! String)
                        }
                    }
                }
            }
            else
            {
                if let countryCode = UserDefaults.standard.value(forKey: "countryCode") as? String
                {
                    print("COUNTRY CODE IN ADDRESS FIELD", countryCode)
                    
                    for i in 0..<countryCodeArray.count
                    {
                        if let id = countryCodeArray[i] as? String
                        {
                            if id == countryCode
                            {
                                print("ID OF DE 2", id, countryCode)
                                
                                if let imageName = countryFlagArray[i] as? String
                                {
                                    let urlString = serviceCall.baseURL
                                    let api = "\(urlString)/images/flags/\(imageName)"
                                    let apiurl = URL(string: api)
                                    
                                    if apiurl != nil
                                    {
                                        flagImageView.dowloadFromServer(url: apiurl!)
                                    }
                                    else
                                    {
                                        flagImageView.image = UIImage(named: "empty")
                                    }
                                }
                                
                                mobileCountryCodeLabel.text = (countryCodeArray[i] as! String)
                            }
                        }
                    }
                }
            }
            
        }
        else if responseMsg == "Failure"
        {
            let Result = countryCodes.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "getallcountries"
            ErrorStr = Result
            DeviceError()
        }
        
    }
    
    func API_CALLBACK_GetStateListByCountry(stateList: NSDictionary)
    {
        print("STATE LIST", stateList)
        
        checkAreaName = 1
        
        let responseMsg = stateList.object(forKey: "ResponseMsg") as! String
        
        if responseMsg == "Success"
        {
            let result = stateList.object(forKey: "Result") as! NSArray
            
            stateNameArray = result.value(forKey: "StateName") as! NSArray
            
            stateCodeArray = result.value(forKey: "Id") as! NSArray
            
            if stateNameArray.count == 0
            {
                checkStateName = 0
            }
            
            if screenTag == 1 && setOrHide == 1
            {
                for i in 0..<stateCodeArray.count{
                    
                    if let matchId = stateCodeArray[i] as? Int
                    {
                        print("ID OF BOTH IN STATE", matchId, editStateId)
                        if getStateId == matchId
                        {
                            if let country = stateNameArray[i] as? String
                            {
                                print("STATE NAME MATCHED", country, editCountryId, matchId)
                                let convertedString = country.split(separator: "(")
                                stateButton.setTitle("\(convertedString[0])", for: .normal)
                            }
                        }
                    }
                }
            }
            
//            if getAddressId != 0
//            {
//                serviceCall.API_GetAreaByState(stateId: "\(getStateId)", delegate: self)
//            }
        }
        else if responseMsg == "Failure"
        {
            let Result = stateList.object(forKey: "Result") as! String
            print("Result", Result)
            
            checkStateName = 0
            
            MethodName = "getState"
            ErrorStr = Result
            DeviceError()
        }
    }
    
    
    func API_CALLBACK_GetAreaByState(area: NSDictionary)
    {
        print("AREA LIST BY STATE", area)
        
        let ResponseMsg = area.object(forKey: "ResponseMsg") as! String
        
        stopActivity()
        
        if ResponseMsg == "Success"
        {
            let Result = area.object(forKey: "Result") as! NSArray
            
            if Result.count == 0
            {
                checkAreaName = 0
            }
            
            if Result.count != 0
            {
                areaNameArray = Result.value(forKey: "Area") as! NSArray
                print("areaNameArray", areaNameArray)
                
                areaCodeArray = Result.value(forKey: "Id") as! NSArray
                print("areaCodeArray", areaCodeArray)
                
                if screenTag == 1 && setOrHide == 1
                {
                    for i in 0..<areaCodeArray.count{
                        
                        if let matchId = areaCodeArray[i] as? Int
                        {
                            print("ID OF BOTH IN AREA", matchId, getAreaId)
                            if getAreaId == matchId
                            {
                                if let country = areaNameArray[i] as? String
                                {
                                    let convertedString = country.split(separator: "(")
                                    areaButton.setTitle("\(convertedString[0])", for: .normal)
                                }
                            }
                        }
                    }
                }
                
                if screenTag == 1
                {
//                    addressContents()
                }
            }
            else
            {
                
            }
        }
    }
    
    func API_CALLBACK_UpdateAddress(updateAddr: NSDictionary)
    {
        let ResponseMsg = updateAddr.object(forKey: "ResponseMsg") as! String
        
        stopActivity()
        
        if ResponseMsg == "Success"
        {
            let Result = updateAddr.object(forKey: "Result") as! String
            print("Result", Result)
            
            if Result == "1"
            {
                Variables.sharedManager.firstName = ""
                Variables.sharedManager.secondName = ""
                Variables.sharedManager.countryName = ""
                Variables.sharedManager.stateName = ""
                Variables.sharedManager.areaName = ""
                Variables.sharedManager.floor = ""
                Variables.sharedManager.landmark = ""
                Variables.sharedManager.locationType = ""
                Variables.sharedManager.mobileNumber = ""
                Variables.sharedManager.countryCode = ""
                Variables.sharedManager.shippingNotes = ""
                
                Variables.sharedManager.countryCodeId = 0
                Variables.sharedManager.stateId = 0
                Variables.sharedManager.areaId = 0
                Variables.sharedManager.checkDefaultId = 0
                
                var updateAlert = UIAlertController()
                
                if let language = UserDefaults.standard.value(forKey: "language") as? String
                {
                    if language == "en"
                    {
                        updateAlert = UIAlertController(title: "Alert", message: "Updated Sucessfully", preferredStyle: UIAlertController.Style.alert)
                        updateAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: apiSuccessResponseAlertOkAction(action:)))
                    }
                    else if language == "ar"
                    {
                        updateAlert = UIAlertController(title: "تنبيه", message: "تحديث بنجاح", preferredStyle: UIAlertController.Style.alert)
                        updateAlert.addAction(UIAlertAction(title: "حسنا", style: UIAlertAction.Style.default, handler: apiSuccessResponseAlertOkAction(action:)))
                    }
                }
                else
                {
                    updateAlert = UIAlertController(title: "Alert", message: "Updated Sucessfully", preferredStyle: UIAlertController.Style.alert)
                    updateAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: apiSuccessResponseAlertOkAction(action:)))
                }
                
                self.present(updateAlert, animated: true, completion: nil)

            }
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = updateAddr.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "UpdateBuyerAddress"
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func changeViewToArabicInSelf()
    {
        view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
//        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.text = "عنوان"
        
        saveButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        saveButton.setTitle("حفظ", for: .normal)
        
        locationAddressLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        locationAddressLabel.text = "عنوان الموقع"
        locationAddressLabel.textAlignment = .right
        
        address1Label.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        address1Label.textAlignment = .right
        
        editLocationButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        editLabel.text = "تعديل"
        
        addressDefaultLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        addressDefaultLabel.text = "اجعله افتراضيًا"
        
        addressInfoHeadingLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        addressInfoHeadingLabel.text = "معلومات العنوان"
        
        firstNameEnglishTextField.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        firstNameEnglishTextField.placeholder = "الاسم الاول"
        secondNameEnglishTextField.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        secondNameEnglishTextField.placeholder = "الاسم الثاني"
        floorTextField.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        floorTextField.placeholder = "الطابق"
        landMarkTextField.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        landMarkTextField.placeholder = "نقطة استدلال"
        locationTypeTextField.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        locationTypeTextField.placeholder = "نوع الموقع"
        mobileTextField.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        mobileTextField.placeholder = "رقم الموبايل"
        shippingNotesTextField.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        shippingNotesTextField.placeholder = "ملاحظات الشحن"
        
        firstNameEnglishTextField.textAlignment = .right
        secondNameEnglishTextField.textAlignment = .right
        floorTextField.textAlignment = .right
        landMarkTextField.textAlignment = .right
        locationTypeTextField.textAlignment = .right
        mobileTextField.textAlignment = .right
        shippingNotesTextField.textAlignment = .right
        
        countryButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        countryButton.contentHorizontalAlignment = .right
        stateButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        stateButton.contentHorizontalAlignment = .right
        areaButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        areaButton.contentHorizontalAlignment = .right
        
        titleLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        titleLabel.text = "يرجى تحديد بلدك"
        
        countryCodeTitleLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        countryCodeTitleLabel.text = "يرجى تحديد رمز البلد الخاص بك"
        
        cancelButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        cancelButton.setTitle("إلغاء", for: .normal)
        
        mobileCountryCodeButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    func changeViewToEnglishInSelf()
    {
        view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

//        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.text = "ADDRESS"
        
        saveButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        saveButton.setTitle("SAVE", for: .normal)
        
        locationAddressLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        locationAddressLabel.text = "Location Address"
        locationAddressLabel.textAlignment = .left
        
        address1Label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        address1Label.textAlignment = .left
        
        editLocationButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        editLabel.text = "EDIT"
        
        addressDefaultLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        addressDefaultLabel.text = "Make as Default"
        
        addressInfoHeadingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        addressInfoHeadingLabel.text = "Address Info"
        
        firstNameEnglishTextField.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        firstNameEnglishTextField.placeholder = "First Name"
        secondNameEnglishTextField.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        secondNameEnglishTextField.placeholder = "Second Name"
        floorTextField.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        floorTextField.placeholder = "Floor"
        landMarkTextField.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        landMarkTextField.placeholder = "Land Mark"
        locationTypeTextField.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        locationTypeTextField.placeholder = "Location Type"
        mobileTextField.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        mobileTextField.placeholder = "Mobile Number"
        shippingNotesTextField.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        shippingNotesTextField.placeholder = "Shipping Notes"
        
        firstNameEnglishTextField.textAlignment = .left
        secondNameEnglishTextField.textAlignment = .left
        floorTextField.textAlignment = .left
        landMarkTextField.textAlignment = .left
        locationTypeTextField.textAlignment = .left
        mobileTextField.textAlignment = .left
        shippingNotesTextField.textAlignment = .left
        
        countryButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        countryButton.contentHorizontalAlignment = .left
        stateButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        stateButton.contentHorizontalAlignment = .left
        areaButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        areaButton.contentHorizontalAlignment = .left
        
        titleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        titleLabel.text = "Please select your country"
        
        countryCodeTitleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        countryCodeTitleLabel.text = "Please select your country code"
        
        cancelButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        cancelButton.setTitle("Cancel", for: .normal)
        
        mobileCountryCodeButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    func addressContents()
    {
        stopActivity()
        
//        if getEditId != 0
//        {
//            insertOrUpdate = 2
//        }
//        else
//        {
//            insertOrUpdate = 1
//        }
        
        if screenTag == 1
        {
            insertOrUpdate = 2
        }
        else
        {
            insertOrUpdate = 1
        }
        
        selfScreenNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        selfScreenNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(selfScreenNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 1
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        selfScreenNavigationBar.addSubview(backButton)
        
        selfScreenNavigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: selfScreenNavigationBar.frame.width, height: (3 * y))
        selfScreenNavigationTitle.text = "ADDRESS"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationTitle.font = selfScreenNavigationTitle.font.withSize(2 * x)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        let locationIcon = UIImageView()
        locationIcon.frame = CGRect(x: x, y: selfScreenNavigationBar.frame.maxY + y + (y / 2), width: (1.5 * x), height: (2 * y))
        locationIcon.image = UIImage(named: "Location_address")
        view.addSubview(locationIcon)
        
        locationAddressLabel.frame = CGRect(x: locationIcon.frame.maxX + x, y: selfScreenNavigationBar.frame.maxY + y, width: view.frame.width / 2, height: (3 * y))
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
        
        print("ADDRESS STRING ADDRESS 2 VIEW CONTROLLER 2", addressString)
        
        address1Label.frame = CGRect(x: x, y: y / 2, width: locationView.frame.width - (9 * x), height: (6 * y))
        
        if addressString.isEmpty == true
        {
            address1Label.text = "Address is not available"
        }
        else
        {
            address1Label.text = "\(addressString[0])"
        }
        
        address1Label.textColor = UIColor.black
        address1Label.textAlignment = .left
        address1Label.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
        address1Label.font = address1Label.font.withSize(1.5 * x)
        address1Label.numberOfLines = 3
        locationView.addSubview(address1Label)
        
        let splitted = addressString.split(separator: ",")
        
        addressStringArray = splitted as NSArray
        print("SPLITTED ADDRESS", addressStringArray)
        
        editLocationButton.frame = CGRect(x: locationView.frame.width - (8 * x), y: 0, width: (8 * x), height: (8 * y))
        //        editLocationButton.layer.cornerRadius = 5
        //        editLocationButton.layer.borderWidth = 1
        //        editLocationButton.layer.borderColor = UIColor.orange.cgColor
        editLocationButton.setImage(UIImage(named: "locationEdit"), for: .normal)
        editLocationButton.tag = 1
        editLocationButton.addTarget(self, action: #selector(self.locationEditButtonAction(sender:)), for: .touchUpInside)
        locationView.addSubview(editLocationButton)
        
        editLabel.frame = CGRect(x: 4, y: editLocationButton.frame.height - (2 * y), width: editLocationButton.frame.width - 8, height: (2 * y))
        editLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        editLabel.text = "EDIT"
        editLabel.textColor = UIColor.white
        editLabel.textAlignment = .center
        editLabel.font = UIFont(name: "Avenir-Regular", size: 15)
        editLabel.font = editLabel.font.withSize(15)
        editLocationButton.addSubview(editLabel)
        
        addressDefaultLabel.frame = CGRect(x: (18 * x), y: locationView.frame.maxY + y + (y / 4), width: (12 * x), height: (2 * y))
        addressDefaultLabel.text = "Make as Default"
        addressDefaultLabel.textColor = UIColor.black
        addressDefaultLabel.textAlignment = .center
        addressDefaultLabel.font = UIFont(name: "Avenir-Regular", size: 15)
        addressDefaultLabel.font = editLabel.font.withSize(15)
        view.addSubview(addressDefaultLabel)
        
        addressSwitchButton.frame = CGRect(x: addressDefaultLabel.frame.maxX + (2 * x), y: locationView.frame.maxY + y, width: (5 * x), height: (2 * y))
        if checkDefault == 1
        {
            addressSwitchButton.isOn = true
        }
        else
        {
            addressSwitchButton.isOn = false
        }
        addressSwitchButton.addTarget(self, action: #selector(self.addressSwitchButtonAction(action:)), for: .valueChanged)
        view.addSubview(addressSwitchButton)
        
        addressInfoHeadingLabel.frame = CGRect(x: (3 * x), y: addressDefaultLabel.frame.maxY + (2 * y), width: view.frame.width - (6 * x), height: (3 * y))
        addressInfoHeadingLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        addressInfoHeadingLabel.text = "Address Info"
        addressInfoHeadingLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        addressInfoHeadingLabel.textAlignment = .center
        addressInfoHeadingLabel.font = UIFont(name: "Avenir-Regular", size: 20)
        addressInfoHeadingLabel.font = editLabel.font.withSize(20)
        view.addSubview(addressInfoHeadingLabel)
        
        addressScrollView.frame = CGRect(x: 0, y: addressInfoHeadingLabel.frame.maxY + y, width: view.frame.width, height: (33 * y))
        //        addressScrollView.backgroundColor = UIColor.black
        view.addSubview(addressScrollView)
        
        addressScrollView.contentSize.height = (50 * y)
        
        let firstNameIcon = UIImageView()
        firstNameIcon.frame = CGRect(x: x, y: y, width: (2 * x), height: (2 * y))
        firstNameIcon.image = UIImage(named: "first_last_name")
        addressScrollView.addSubview(firstNameIcon)
        
        firstNameEnglishTextField.frame = CGRect(x: firstNameIcon.frame.maxX + x, y: y, width: addressScrollView.frame.width - (4 * x), height: (2 * y))
        
        let id = Variables.sharedManager.editAddress
        
        if id == 1
        {
            
        }
        else
        {
            if let getUserName = UserDefaults.standard.value(forKey: "userName") as? String
            {
                firstNameEnglishTextField.text = getUserName
            }
            else
            {
                firstNameEnglishTextField.placeholder = "First Name"
            }
        }
        
        firstNameEnglishTextField.textColor = UIColor.black
        firstNameEnglishTextField.textAlignment = .left
        firstNameEnglishTextField.font = UIFont(name: "Avenir-Regular", size: 18)
        //        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: firstNameEnglishTextField.frame.height))
        //        firstNameEnglishTextField.leftView = paddingView
        firstNameEnglishTextField.leftViewMode = UITextField.ViewMode.always
        firstNameEnglishTextField.adjustsFontSizeToFitWidth = true
        firstNameEnglishTextField.keyboardType = .default
        //        firstNameEnglishTextField.clearsOnBeginEditing = true
        firstNameEnglishTextField.returnKeyType = .done
        firstNameEnglishTextField.delegate = self
        //        firstNameEnglishTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        addressScrollView.addSubview(firstNameEnglishTextField)
        
        let firstNameEditButton = UIButton()
        firstNameEditButton.frame = CGRect(x: addressScrollView.frame.width - (3 * x), y: y, width: (2 * x), height: (2 * y))
        firstNameEditButton.setImage(UIImage(named: "edit"), for: .normal)
        addressScrollView.addSubview(firstNameEditButton)
        
        let underline1 = UILabel()
        underline1.frame = CGRect(x: x, y: firstNameIcon.frame.maxY, width: view.frame.width - (2 * x), height: 1)
        underline1.backgroundColor = UIColor.lightGray
        addressScrollView.addSubview(underline1)
        
        let secondNameIcon = UIImageView()
        secondNameIcon.frame = CGRect(x: x, y: underline1.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        secondNameIcon.image = UIImage(named: "first_last_name")
        addressScrollView.addSubview(secondNameIcon)
        
        secondNameEnglishTextField.frame = CGRect(x: secondNameIcon.frame.maxX + x, y: underline1.frame.maxY + (3 * y), width: addressScrollView.frame.width - (4 * x), height: (2 * y))
        secondNameEnglishTextField.placeholder = "Second Name"
        secondNameEnglishTextField.textColor = UIColor.black
        secondNameEnglishTextField.textAlignment = .left
        secondNameEnglishTextField.font = UIFont(name: "Avenir-Regular", size: 18)
        //        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: secondNameEnglishTextField.frame.height))
        //        secondNameEnglishTextField.leftView = paddingView1
        secondNameEnglishTextField.leftViewMode = UITextField.ViewMode.always
        secondNameEnglishTextField.adjustsFontSizeToFitWidth = true
        secondNameEnglishTextField.keyboardType = .default
        //        secondNameEnglishTextField.clearsOnBeginEditing = true
        secondNameEnglishTextField.returnKeyType = .done
        secondNameEnglishTextField.delegate = self
        //        secondNameEnglishTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        addressScrollView.addSubview(secondNameEnglishTextField)
        
        let secondNameEditButton = UIButton()
        secondNameEditButton.frame = CGRect(x: addressScrollView.frame.width - (3 * x), y: underline1.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        secondNameEditButton.setImage(UIImage(named: "edit"), for: .normal)
        addressScrollView.addSubview(secondNameEditButton)
        
        let underline2 = UILabel()
        underline2.frame = CGRect(x: x, y: secondNameIcon.frame.maxY, width: view.frame.width - (2 * x), height: 1)
        underline2.backgroundColor = UIColor.lightGray
        addressScrollView.addSubview(underline2)
        
        let countryIcon = UIImageView()
        countryIcon.frame = CGRect(x: x, y: underline2.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        countryIcon.image = UIImage(named: "Country")
        addressScrollView.addSubview(countryIcon)
        
        countryButton.frame = CGRect(x: countryIcon.frame.maxX + x, y: underline2.frame.maxY + (3 * y), width: addressScrollView.frame.width - (4 * x), height: (2 * y))
        if getAddressId != 0
        {
            
        }
        else
        {
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    countryButton.setTitle("Country", for: .normal)
                }
                else if language == "ar"
                {
                    countryButton.setTitle("الدولة", for: .normal)
                }
            }
            else
            {
                countryButton.setTitle("Country", for: .normal)
            }
        }
        countryButton.setTitleColor(UIColor.black, for: .normal)
        countryButton.contentHorizontalAlignment = .left
        countryButton.addTarget(self, action: #selector(self.countryButtonAction(sender:)), for: .touchUpInside)
        addressScrollView.addSubview(countryButton)
        
        
        /*if editCountryId != 0
        {
            for i in 0..<countryIdArray.count{
                
                if let matchId = countryIdArray[i] as? Int
                {
                    if editCountryId == matchId
                    {
                        if let country = countryNameArray[i] as? String
                        {
                            print("COUNTRY NAME MATCHED", country, editCountryId, matchId)
                            let convertedString = country.split(separator: "(")
                            countryButton.setTitle("\(convertedString[0])", for: .normal)
                            
                            serviceCall.API_GetStateListByCountry(countryId: "\(countryIdArray[i])", delegate: self)
                            stateButton.setTitle("State", for: .normal)
                        }
                    }
                }
            }
        }
        else
        {
            /*for i in 0..<countryNameArray.count
            {
                if let country = countryNameArray[i] as? String
                {
                    let convertedString = country.split(separator: "(")
                    
                    if let countryMatch = addressStringArray.lastObject as? String
                    {                        
                        if countryMatch == convertedString[0]
                        {
                            print("MATCHED COUNTRY", country, countryMatch, countryIdArray[i])
                            serviceCall.API_GetStateListByCountry(countryId: "\(countryIdArray[i])", delegate: self)
                            stateButton.setTitle("State", for: .normal)
                        }
                    }
                }
            }
            
            if let country = countryNameArray[0] as? String
            {
                let convertedString = country.split(separator: "(")
                countryButton.setTitle("\(convertedString[0])", for: .normal)
                
                serviceCall.API_GetStateListByCountry(countryId: "\(countryIdArray[0])", delegate: self)
                stateButton.setTitle("State", for: .normal)
            }*/
        }
        
        if getAddressId != 0
        {
            for i in 0..<countryIdArray.count
            {
                if let matchId = countryIdArray[i] as? Int
                {
                    if getCountryId == matchId
                    {
                        if let country = countryNameArray[i] as? String
                        {
                            print("COUNTRY NAME MATCHED", country, editCountryId, matchId)
                            let convertedString = country.split(separator: "(")
                            countryButton.setTitle("\(convertedString[0])", for: .normal)
                            
//                            serviceCall.API_GetStateListByCountry(countryId: "\(countryIdArray[i])", delegate: self)
                            stateButton.setTitle("State", for: .normal)
                        }
                    }
                }
            }
        }*/
        
        let countryDropDownIcon = UIImageView()
        countryDropDownIcon.frame = CGRect(x: addressScrollView.frame.width - (3 * x), y: underline2.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        countryDropDownIcon.image = UIImage(named: "downArrow")
        addressScrollView.addSubview(countryDropDownIcon)
        
        let underline3 = UILabel()
        underline3.frame = CGRect(x: x, y: countryIcon.frame.maxY, width: view.frame.width - (2 * x), height: 1)
        underline3.backgroundColor = UIColor.lightGray
        addressScrollView.addSubview(underline3)
        
        let stateIcon = UIImageView()
        stateIcon.frame = CGRect(x: x, y: underline3.frame.maxY + (3 * y), width: (2 * y), height: (2 * y))
        stateIcon.image = UIImage(named: "state")
        addressScrollView.addSubview(stateIcon)
        
        stateButton.frame = CGRect(x: stateIcon.frame.maxX + x, y: underline3.frame.maxY + (3 * y), width: addressScrollView.frame.width - (4 * x), height: (2 * y))
        if getAddressId != 0
        {
            
        }
        else
        {
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    stateButton.setTitle("State", for: .normal)
                }
                else if language == "ar"
                {
                    stateButton.setTitle("الامارة", for: .normal)
                }
            }
            else
            {
                stateButton.setTitle("State", for: .normal)
            }
        }
        stateButton.setTitleColor(UIColor.black, for: .normal)
        stateButton.contentHorizontalAlignment = .left
        stateButton.addTarget(self, action: #selector(self.stateButtonAction(sender:)), for: .touchUpInside)
        addressScrollView.addSubview(stateButton)
        
        /*if editStateId != 0
        {
            for i in 0..<stateCodeArray.count{
                
                if let matchId = stateCodeArray[i] as? Int
                {
                    print("EDIT STATE ID AND MATCH ID", editStateId, matchId, stateNameArray)

                    if editStateId == matchId
                    {
                        if let country = stateNameArray[i] as? String
                        {
                            print("STATE NAME MATCHED", country, editCountryId, matchId)
                            let convertedString = country.split(separator: "(")
                            stateButton.setTitle("\(convertedString[0])", for: .normal)
                            
                            serviceCall.API_GetAreaByState(stateId: "\(stateCodeArray[i])", delegate: self)
                            areaButton.setTitle("Area", for: .normal)
                        }
                    }
                }
            }
        }
        else
        {
            /*for i in 0..<stateNameArray.count
            {
                if let country = stateNameArray[i] as? String
                {
                    let convertedString = country.split(separator: "(")
                    
                    if let countryMatch = addressStringArray.lastObject as? String
                    {
                        if countryMatch == convertedString[0]
                        {
                            print("MATCHED COUNTRY", country, countryMatch, countryIdArray[i])
                            serviceCall.API_GetAreaByState(stateId: "\(stateCodeArray[i])", delegate: self)
                            areaButton.setTitle("Area", for: .normal)
                        }
                    }
                }
            }
            
            if let country = stateNameArray[0] as? String
            {
                let convertedString = country.split(separator: "(")
                stateButton.setTitle("\(convertedString[0])", for: .normal)
                
                serviceCall.API_GetAreaByState(stateId: "\(stateCodeArray[0])", delegate: self)
                areaButton.setTitle("Area", for: .normal)
            }*/
        }
        
        if getAddressId != 0
        {
            for i in 0..<stateCodeArray.count
            {
                if let matchId = stateCodeArray[i] as? Int
                {
                    print("EDIT STATE ID AND MATCH ID", editStateId, matchId, stateNameArray)
                    
                    if getStateId == matchId
                    {
                        if let country = stateNameArray[i] as? String
                        {
                            print("STATE NAME MATCHED", country, editCountryId, matchId)
                            let convertedString = country.split(separator: "(")
                            stateButton.setTitle("\(convertedString[0])", for: .normal)
                            
//                            serviceCall.API_GetAreaByState(stateId: "\(stateCodeArray[i])", delegate: self)
                            areaButton.setTitle("Area", for: .normal)
                        }
                    }
                }
            }
        }*/
        
        let stateDropDownIcon = UIImageView()
        stateDropDownIcon.frame = CGRect(x: addressScrollView.frame.width - (3 * x), y: underline3.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        stateDropDownIcon.image = UIImage(named: "downArrow")
        addressScrollView.addSubview(stateDropDownIcon)
        
        let underline4 = UILabel()
        underline4.frame = CGRect(x: x, y: stateIcon.frame.maxY, width: view.frame.width - (2 * x), height: 1)
        underline4.backgroundColor = UIColor.lightGray
        addressScrollView.addSubview(underline4)
        
        let areaIcon = UIImageView()
        areaIcon.frame = CGRect(x: x, y: underline4.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        areaIcon.image = UIImage(named: "Area")
        addressScrollView.addSubview(areaIcon)
        
        /*areaButton.frame = CGRect(x: areaIcon.frame.maxX + x, y: underline4.frame.maxY + (3 * y), width: addressScrollView.frame.width - (4 * x), height: (2 * y))
        areaButton.placeholder = "Area"
        areaButton.textColor = UIColor.black
        areaButton.textAlignment = .left
        areaButton.font = UIFont(name: "Avenir-Regular", size: 18)
        //        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: secondNameEnglishTextField.frame.height))
        //        areaNameTextField.leftView = paddingView2
        areaButton.leftViewMode = UITextField.ViewMode.always
        areaButton.adjustsFontSizeToFitWidth = true
        areaButton.keyboardType = .default
        //        areaNameTextField.clearsOnBeginEditing = true
        areaButton.returnKeyType = .done
        areaButton.delegate = self
        areaButton.addTarget(self, action: #selector(self.areaFunction(textField:)), for: .editingChanged)
        addressScrollView.addSubview(areaButton)*/
        
        areaButton.frame = CGRect(x: areaIcon.frame.maxX + x, y: underline4.frame.maxY + (3 * y), width: addressScrollView.frame.width - (4 * x), height: (2 * y))
        
        if getAddressId != 0
        {
            
        }
        else
        {
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    areaButton.setTitle("Area", for: .normal)
                }
                else if language == "ar"
                {
                    areaButton.setTitle("المنطقة", for: .normal)
                }
            }
            else
            {
                areaButton.setTitle("Area", for: .normal)
            }
        }
        
        areaButton.setTitleColor(UIColor.black, for: .normal)
        areaButton.contentHorizontalAlignment = .left
        areaButton.addTarget(self, action: #selector(self.areaButtonAction(sender:)), for: .touchUpInside)
        addressScrollView.addSubview(areaButton)
        
        /*if editAreaId != 0
        {
            for i in 0..<areaCodeArray.count
            {
                if let matchId = areaCodeArray[i] as? Int
                {
                    print("EDIT AREA ID AND MATCH ID", editAreaId, matchId, areaNameArray)
                    
                    if editAreaId == matchId
                    {
                        if let country = areaNameArray[i] as? String
                        {
                            print("AREA NAME MATCHED", country, editAreaId, matchId)
                            let convertedString = country.split(separator: "(")
                            areaButton.setTitle("\(convertedString[0])", for: .normal)
                        }
                    }
                }
            }
        }
        else
        {
            /*for i in 0..<areaNameArray.count
            {
                if let country = areaNameArray[i] as? String
                {
                    let convertedString = country.split(separator: "(")
                    
                    if let countryMatch = addressStringArray.lastObject as? String
                    {
                        if countryMatch == convertedString[0]
                        {
                            print("MATCHED COUNTRY", country, countryMatch, countryIdArray[i])
                            serviceCall.API_GetAreaByState(stateId: "\(stateCodeArray[i])", delegate: self)
                            areaButton.setTitle("Area", for: .normal)
                        }
                    }
                }
            }*/
        }
        
        if getAddressId != 0
        {
            for i in 0..<areaCodeArray.count
            {
                if let matchId = areaCodeArray[i] as? Int
                {
                    print("EDIT AREA ID AND MATCH ID", editAreaId, matchId, areaNameArray)
                    
                    if getAreaId == matchId
                    {
                        if let country = areaNameArray[i] as? String
                        {
                            print("AREA NAME MATCHED", country, editAreaId, matchId)
                            let convertedString = country.split(separator: "(")
                            areaButton.setTitle("\(convertedString[0])", for: .normal)
                        }
                    }
                }
            }
        }*/
        
        let areaEditButton = UIButton()
        areaEditButton.frame = CGRect(x: addressScrollView.frame.width - (3 * x), y: underline4.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        areaEditButton.setImage(UIImage(named: "downArrow"), for: .normal)
        addressScrollView.addSubview(areaEditButton)
        
        let underline5 = UILabel()
        underline5.frame = CGRect(x: x, y: areaIcon.frame.maxY, width: view.frame.width - (2 * x), height: 1)
        underline5.backgroundColor = UIColor.lightGray
        addressScrollView.addSubview(underline5)
        
        let landMarkIcon = UIImageView()
        landMarkIcon.frame = CGRect(x: x, y: underline5.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        landMarkIcon.image = UIImage(named: "landmark")
        addressScrollView.addSubview(landMarkIcon)
        
        landMarkTextField.frame = CGRect(x: landMarkIcon.frame.maxX + x, y: underline5.frame.maxY + (3 * y), width: addressScrollView.frame.width - (4 * x), height: (2 * y))
        landMarkTextField.placeholder = "Land Mark"
        landMarkTextField.textColor = UIColor.black
        landMarkTextField.textAlignment = .left
        landMarkTextField.font = UIFont(name: "Avenir-Regular", size: 18)
        //        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: secondNameEnglishTextField.frame.height))
        //        areaNameTextField.leftView = paddingView2
        landMarkTextField.leftViewMode = UITextField.ViewMode.always
        landMarkTextField.adjustsFontSizeToFitWidth = true
        landMarkTextField.keyboardType = .default
        //        landMarkTextField.clearsOnBeginEditing = true
        landMarkTextField.returnKeyType = .done
        landMarkTextField.delegate = self
        //        landMarkTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        addressScrollView.addSubview(landMarkTextField)
        
        let landMarkEditButton = UIButton()
        landMarkEditButton.frame = CGRect(x: addressScrollView.frame.width - (3 * x), y: underline5.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        landMarkEditButton.setImage(UIImage(named: "edit"), for: .normal)
        addressScrollView.addSubview(landMarkEditButton)
        
        let underline7 = UILabel()
        underline7.frame = CGRect(x: x, y: landMarkIcon.frame.maxY, width: view.frame.width - (2 * x), height: 1)
        underline7.backgroundColor = UIColor.lightGray
        addressScrollView.addSubview(underline7)
        
        let locationTypeIcon = UIImageView()
        locationTypeIcon.frame = CGRect(x: x, y: underline7.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        locationTypeIcon.image = UIImage(named: "location_type")
        addressScrollView.addSubview(locationTypeIcon)
        
        locationTypeTextField.frame = CGRect(x: locationTypeIcon.frame.maxX + x, y: underline7.frame.maxY + (3 * y), width: addressScrollView.frame.width - (4 * x), height: (2 * y))
        locationTypeTextField.placeholder = "Location Type"
        locationTypeTextField.textColor = UIColor.black
        locationTypeTextField.textAlignment = .left
        locationTypeTextField.font = UIFont(name: "Avenir-Regular", size: 18)
        //        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: secondNameEnglishTextField.frame.height))
        //        areaNameTextField.leftView = paddingView2
        locationTypeTextField.leftViewMode = UITextField.ViewMode.always
        locationTypeTextField.adjustsFontSizeToFitWidth = true
        locationTypeTextField.keyboardType = .default
        //        locationTypeTextField.clearsOnBeginEditing = true
        locationTypeTextField.returnKeyType = .done
        locationTypeTextField.delegate = self
        //        locationTypeTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        addressScrollView.addSubview(locationTypeTextField)
        
        let locationTypeEditButton = UIButton()
        locationTypeEditButton.frame = CGRect(x: addressScrollView.frame.width - (3 * x), y: underline7.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        locationTypeEditButton.setImage(UIImage(named: "downArrow"), for: .normal)
        addressScrollView.addSubview(locationTypeEditButton)
        
        let underline8 = UILabel()
        underline8.frame = CGRect(x: x, y: locationTypeIcon.frame.maxY, width: view.frame.width - (2 * x), height: 1)
        underline8.backgroundColor = UIColor.lightGray
        addressScrollView.addSubview(underline8)
        
        let floorIcon = UIImageView()
        floorIcon.frame = CGRect(x: x, y: underline8.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        floorIcon.image = UIImage(named: "Floor")
        addressScrollView.addSubview(floorIcon)
        
        floorTextField.frame = CGRect(x: floorIcon.frame.maxX + x, y: underline8.frame.maxY + (3 * y), width: addressScrollView.frame.width - (4 * x), height: (2 * y))
        floorTextField.placeholder = "Floor"
        floorTextField.textColor = UIColor.black
        floorTextField.textAlignment = .left
        floorTextField.font = UIFont(name: "Avenir-Regular", size: 18)
        //        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: secondNameEnglishTextField.frame.height))
        //        areaNameTextField.leftView = paddingView2
        floorTextField.leftViewMode = UITextField.ViewMode.always
        floorTextField.adjustsFontSizeToFitWidth = true
        floorTextField.keyboardType = .default
        //        floorTextField.clearsOnBeginEditing = true
        floorTextField.returnKeyType = .done
        floorTextField.delegate = self
        //        floorTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        addressScrollView.addSubview(floorTextField)
        
        let floorEditButton = UIButton()
        floorEditButton.frame = CGRect(x: addressScrollView.frame.width - (3 * x), y: underline8.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        floorEditButton.setImage(UIImage(named: "edit"), for: .normal)
        addressScrollView.addSubview(floorEditButton)
        
        let underline6 = UILabel()
        underline6.frame = CGRect(x: x, y: floorIcon.frame.maxY, width: view.frame.width - (2 * x), height: 1)
        underline6.backgroundColor = UIColor.lightGray
        addressScrollView.addSubview(underline6)
        
        mobileCountryCodeButton.frame = CGRect(x: x, y: underline6.frame.maxY + (3 * y), width: (10 * x), height: (3 * y))
        mobileCountryCodeButton.backgroundColor = UIColor(red: 0.7647, green: 0.7882, blue: 0.7765, alpha: 1.0)
        mobileCountryCodeButton.addTarget(self, action: #selector(self.mobileCountryCodeButtonAction(sender:)), for: .touchUpInside)
        addressScrollView.addSubview(mobileCountryCodeButton)
        
        flagImageView.frame = CGRect(x: (x / 2), y: (y / 2), width: (2.5 * x), height: (mobileCountryCodeButton.frame.height - y))
        
        /*if let imageName = countryFlagArray[0] as? String
         {
         let urlString = serviceCall.baseURL
         let api = "\(urlString)/images/flags/\(imageName)"
         let apiurl = URL(string: api)
         
         if apiurl != nil
         {
         flagImageView.dowloadFromServer(url: apiurl!)
         }
         else
         {
         flagImageView.image = UIImage(named: "empty")
         }
         }*/
        
        mobileCountryCodeButton.addSubview(flagImageView)
        
        mobileCountryCodeLabel.frame = CGRect(x: flagImageView.frame.maxX + (x / 2), y: 0, width: (4 * x), height: mobileCountryCodeButton.frame.height)
        mobileCountryCodeLabel.textColor = UIColor.black
        mobileCountryCodeLabel.textAlignment = .left
        mobileCountryCodeLabel.font = UIFont(name: "Avenir-Regular", size: 18)
        mobileCountryCodeButton.addSubview(mobileCountryCodeLabel)
        
        if screenTag == 1
        {
            for i in 0..<countryCodeArray.count
            {
                if let id = countryCodeArray[i] as? String
                {
                    if id == getCountryCode
                    {
                        print("ID OF DE 1", id, getCountryCode)
                        
                        if let imageName = countryFlagArray[i] as? String
                        {
                            let urlString = serviceCall.baseURL
                            let api = "\(urlString)/images/flags/\(imageName)"
                            let apiurl = URL(string: api)
                            
                            if apiurl != nil
                            {
                                flagImageView.dowloadFromServer(url: apiurl!)
                            }
                            else
                            {
                                flagImageView.image = UIImage(named: "empty")
                            }
                        }
                        
                        mobileCountryCodeLabel.text = (countryCodeArray[i] as! String)
                    }
                }
            }
        }
        else
        {
            if id == 1
            {
                
            }
            else
            {
                if let countryCode = UserDefaults.standard.value(forKey: "countryCode") as? String
                {
                    print("COUNTRY CODE IN ADDRESS FIELD", countryCode)
                    
                    for i in 0..<countryCodeArray.count
                    {
                        if let id = countryCodeArray[i] as? String
                        {
                            if id == countryCode
                            {
                                print("ID OF DE 2", id, countryCode)
                                
                                if let imageName = countryFlagArray[i] as? String
                                {
                                    let urlString = serviceCall.baseURL
                                    let api = "\(urlString)/images/flags/\(imageName)"
                                    let apiurl = URL(string: api)
                                    
                                    if apiurl != nil
                                    {
                                        flagImageView.dowloadFromServer(url: apiurl!)
                                    }
                                    else
                                    {
                                        flagImageView.image = UIImage(named: "empty")
                                    }
                                }
                                
                                mobileCountryCodeLabel.text = (countryCodeArray[i] as! String)
                            }
                        }
                    }
                }
            }
        }
        
        let downArrowImageView = UIImageView()
        downArrowImageView.frame = CGRect(x: mobileCountryCodeButton.frame.width - 20, y: ((mobileCountryCodeButton.frame.height - 15) / 2), width: 15, height: 15)
        downArrowImageView.image = UIImage(named: "downArrow")
        mobileCountryCodeButton.addSubview(downArrowImageView)
        
        let mobileImageView = UIImageView()
        mobileImageView.frame = CGRect(x: mobileCountryCodeButton.frame.maxX  + x, y: underline6.frame.maxY + (3 * y) + (y / 2), width: (1.5 * x), height: (2 * y))
        mobileImageView.image = UIImage(named: "mobile")
        addressScrollView.addSubview(mobileImageView)
        
        mobileTextField.frame = CGRect(x: mobileImageView.frame.maxX + 2, y: underline6.frame.maxY + (3 * y), width: addressScrollView.frame.width - (13 * x), height: (3 * y))
        
        if id == 1
        {
            
        }
        else
        {
            if let mobile = UserDefaults.standard.value(forKey: "Phone") as? String
            {
                mobileTextField.text = mobile
            }
            else
            {
                mobileTextField.placeholder = "Mobile Number"
            }
        }
      
        mobileTextField.textColor = UIColor.black
        mobileTextField.textAlignment = .left
        mobileTextField.font = UIFont(name: "Avenir-Regular", size: 18)
        //        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.mobileTextField.frame.height))
        //        mobileTextField.leftView = paddingView
        mobileTextField.leftViewMode = UITextField.ViewMode.always
        mobileTextField.adjustsFontSizeToFitWidth = true
        mobileTextField.keyboardType = .numberPad
        //        mobileTextField.clearsOnBeginEditing = true
        mobileTextField.returnKeyType = .done
        mobileTextField.delegate = self
        //        mobileTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        addressScrollView.addSubview(mobileTextField)
        
        let underline9 = UILabel()
        underline9.frame = CGRect(x: mobileImageView.frame.minX, y: mobileTextField.frame.maxY, width: mobileTextField.frame.width, height: 1)
        underline9.backgroundColor = UIColor.gray
        addressScrollView.addSubview(underline9)
        
        let shippingNotesIcon = UIImageView()
        shippingNotesIcon.frame = CGRect(x: x, y: underline9.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        shippingNotesIcon.image = UIImage(named: "Shipping_notes")
        addressScrollView.addSubview(shippingNotesIcon)
        
        shippingNotesTextField.frame = CGRect(x: shippingNotesIcon.frame.maxX + x, y: underline9.frame.maxY + (3 * y), width: addressScrollView.frame.width - (4 * x), height: (2 * y))
        shippingNotesTextField.placeholder = "Shipping Notes"
        shippingNotesTextField.textColor = UIColor.black
        shippingNotesTextField.textAlignment = .left
        shippingNotesTextField.font = UIFont(name: "Avenir-Regular", size: 18)
        //        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: secondNameEnglishTextField.frame.height))
        //        areaNameTextField.leftView = paddingView2
        shippingNotesTextField.leftViewMode = UITextField.ViewMode.always
        shippingNotesTextField.adjustsFontSizeToFitWidth = true
        shippingNotesTextField.keyboardType = .default
        //        shippingNotesTextField.clearsOnBeginEditing = true
        shippingNotesTextField.returnKeyType = .done
        shippingNotesTextField.delegate = self
        //        shippingNotesTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        addressScrollView.addSubview(shippingNotesTextField)
        
        let shippingNotesEditButton = UIButton()
        shippingNotesEditButton.frame = CGRect(x: addressScrollView.frame.width - (3 * x), y: underline9.frame.maxY + (3 * y), width: (2 * x), height: (2 * y))
        //        shippingNotesEditButton.backgroundColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        shippingNotesEditButton.setImage(UIImage(named: "edit"), for: .normal)
        addressScrollView.addSubview(shippingNotesEditButton)
        
        let underline10 = UILabel()
        underline10.frame = CGRect(x: x, y: shippingNotesIcon.frame.maxY, width: view.frame.width - (2 * x), height: 1)
        underline10.backgroundColor = UIColor.lightGray
        addressScrollView.addSubview(underline10)
        
        saveButton.frame = CGRect(x: view.frame.width - (18 * x), y: addressScrollView.frame.maxY + y, width: (15 * x), height: (3 * y))
        saveButton.backgroundColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        saveButton.setTitle("SAVE", for: .normal)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Avenir-Regular", size: 10)
        saveButton.addTarget(self, action: #selector(self.saveAndNextButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(saveButton)
        
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
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]

        if screenTag == 1
        {
            if checkTag == 1
            {
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
            }
            else
            {
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
            }
        }
        else
        {
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        }
    }
    
    @objc func addressSwitchButtonAction(action : UISwitch)
    {
        if action.isOn == true
        {
            setDefault = "TRUE"
        }
        else
        {
            setDefault = "FALSE"
        }
    }
    
    @objc func areaButtonAction(sender : UIButton)
    {
        print("AREA COUNT IN BUTTON ACTION", areaNameArray.count, checkAreaName)
        if areaNameArray.count == 0
        {
            if checkAreaName == 0
            {
                var emptyAlert = UIAlertController()
                
                if let language = UserDefaults.standard.value(forKey: "language") as? String
                {
                    if language == "en"
                    {
                        emptyAlert = UIAlertController(title: "Alert", message: "Area not available in this State", preferredStyle: .alert)
                        emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    }
                    else if language == "ar"
                    {
                        emptyAlert = UIAlertController(title: "تنبيه", message: "المنطقة غير متوفرة في هذه الحالة", preferredStyle: .alert)
                        emptyAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: nil))
                    }
                }
                else
                {
                    emptyAlert = UIAlertController(title: "Alert", message: "Area not available in this State", preferredStyle: .alert)
                    emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                }
                
                self.navigationController?.present(emptyAlert, animated: true, completion: nil)

            }
            else
            {
                var emptyAlert = UIAlertController()
                
                if let language = UserDefaults.standard.value(forKey: "language") as? String
                {
                    if language == "en"
                    {
                        emptyAlert = UIAlertController(title: "Alert", message: "Please select your state first", preferredStyle: .alert)
                        emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    }
                    else if language == "ar"
                    {
                        emptyAlert = UIAlertController(title: "تنبيه", message: "الرجاء اختيار ولايتك أولاً", preferredStyle: .alert)
                        emptyAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: nil))
                    }
                }
                else
                {
                    emptyAlert = UIAlertController(title: "Alert", message: "Please select your state first", preferredStyle: .alert)
                    emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                }
                
                self.navigationController?.present(emptyAlert, animated: true, completion: nil)
            }
        }
        else
        {
            areaFunctions()
        }
        
        /*if areaNameArray.count == 0
        {
            if checkAreaName == 0
            {
                let alert = UIAlertController(title: "Alert", message: "Area not available in this State", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.navigationController?.present(alert, animated: true, completion: nil)
            }
            else
            {
                let alert = UIAlertController(title: "Alert", message: "Please select your state first", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.navigationController?.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            let areaAlert = UIAlertController(title: "Area", message: "Please select your area", preferredStyle: .alert)
            
            activityContents()

            for i in 0..<areaNameArray.count
            {
                if let areaString = areaNameArray[i] as? String
                {
                    areaAlert.addAction(UIAlertAction(title: areaString, style: .default, handler: areaAlertAction(action:)))
                }
            }
            
            areaAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            stopActivity()
            self.present(areaAlert, animated: true, completion: nil)
        }*/
    }
    
    func areaAlertAction(action : UIAlertAction)
    {
        areaButton.setTitle(action.title, for: .normal)
        
        for i in 0..<areaNameArray.count
        {
            if let name = areaNameArray[i] as? String
            {
                if name == action.title
                {
                    print("GET AREA CODE", areaCodeArray[i])
                    getAreaId = areaCodeArray[i] as! Int
                }
            }
        }
    }
    
    func areaFunctions()
    {
        areaBlurView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        areaBlurView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(areaBlurView)
        
        let headingLabel = UILabel()
        headingLabel.frame = CGRect(x: (3 * x), y: (4 * y), width: areaBlurView.frame.width - (6 * x), height: (2.5 * y))
        headingLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        headingLabel.text = "Alert"
        headingLabel.textColor = UIColor.white
        headingLabel.textAlignment = .center
        headingLabel.font = headingLabel.font.withSize(20)
        areaBlurView.addSubview(headingLabel)
        
        let path = UIBezierPath(roundedRect:headingLabel.bounds, byRoundingCorners:[.topRight, .topLeft], cornerRadii: CGSize(width: 15, height:  15))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        headingLabel.layer.mask = maskLayer

        
        let detailedLabel = UILabel()
        detailedLabel.frame = CGRect(x: (3 * x), y: headingLabel.frame.maxY, width: areaBlurView.frame.width - (6 * x), height: (2 * y))
        detailedLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        detailedLabel.text = "Please choose your area"
        detailedLabel.textColor = UIColor.white
        detailedLabel.textAlignment = .center
        detailedLabel.font = detailedLabel.font.withSize(15)
        areaBlurView.addSubview(detailedLabel)
        
        areaTableView.frame = CGRect(x: (3 * x), y: detailedLabel.frame.maxY, width: areaBlurView.frame.width - (6 * x), height: areaBlurView.frame.height - (15 * y))
        areaTableView.backgroundColor = UIColor.white
        areaTableView.register(CountryCodeTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(CountryCodeTableViewCell.self))
        areaTableView.dataSource = self
        areaTableView.delegate = self
        areaBlurView.addSubview(areaTableView)
        
        areaTableView.reloadData()
        
        let areaCancelButton = UIButton()
        areaCancelButton.frame = CGRect(x: (3 * x), y: areaTableView.frame.maxY, width: areaBlurView.frame.width - (6 * x), height: (5 * y))
        areaCancelButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        areaCancelButton.setTitle("Cancel", for: .normal)
        areaCancelButton.setTitleColor(UIColor.white, for: .normal)
        areaCancelButton.addTarget(self, action: #selector(self.areaCancelButtonAction(sender:)), for: .touchUpInside)
        areaBlurView.addSubview(areaCancelButton)
        
        let path1 = UIBezierPath(roundedRect:areaCancelButton.bounds, byRoundingCorners:[.bottomRight, .bottomLeft], cornerRadii: CGSize(width: 15, height:  15))
        
        let maskLayer1 = CAShapeLayer()
        
        maskLayer1.path = path1.cgPath
        
        areaCancelButton.layer.mask = maskLayer1
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                headingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                headingLabel.text = "Alert"
                detailedLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                detailedLabel.text = "Please choose your area"
                areaCancelButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                areaCancelButton.setTitle("Cancel", for: .normal)
            }
            else if language == "ar"
            {
                headingLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                headingLabel.text = "تنبيه"
                detailedLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                detailedLabel.text = "يرجى اختيار منطقتك"
                areaCancelButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                areaCancelButton.setTitle("الغاء", for: .normal)
            }
        }
        else
        {
            headingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            headingLabel.text = "Alert"
            detailedLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            detailedLabel.text = "Please choose your area"
            areaCancelButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            areaCancelButton.setTitle("Cancel", for: .normal)
        }
    }
    
    @objc func areaCancelButtonAction(sender : UIButton)
    {
        areaBlurView.removeFromSuperview()
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        
        print("ENTERED TEXTFIELD")
        switch textField{
        case firstNameEnglishTextField:
            secondNameEnglishTextField.becomeFirstResponder()
        case secondNameEnglishTextField:
            areaButton.becomeFirstResponder()
        case areaButton:
            floorTextField.becomeFirstResponder()
        case floorTextField:
            landMarkTextField.becomeFirstResponder()
        case landMarkTextField:
            locationTypeTextField.becomeFirstResponder()
        case locationTypeTextField:
            mobileTextField.becomeFirstResponder()
        case mobileTextField:
            shippingNotesTextField.becomeFirstResponder()
        case shippingNotesTextField:
            shippingNotesTextField.resignFirstResponder()
        default:
            break
        }
        
    }
    
    @objc func mobileCountryCodeButtonAction(sender : UIButton)
    {
        countryAlertView()
    }
    
    func countryAlertView()
    {
        blurView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        blurView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(blurView)
        
        let countryCodeAlertView = UIView()
        countryCodeAlertView.frame = CGRect(x: (3 * x), y: (3 * y), width: view.frame.width - (6 * x), height: view.frame.height - (6 * y))
        countryCodeAlertView.layer.cornerRadius = 15
        countryCodeAlertView.layer.masksToBounds = true
        countryCodeAlertView.backgroundColor = UIColor.white
        blurView.addSubview(countryCodeAlertView)
        
        countryCodeTitleLabel.frame = CGRect(x: 0, y: y, width: countryCodeAlertView.frame.width, height: (2 * y))
        countryCodeTitleLabel.text = "Please select your country code"
        countryCodeTitleLabel.textAlignment = .center
        countryCodeTitleLabel.textColor = UIColor.black
        countryCodeTitleLabel.font = UIFont(name: "", size: 10)
        countryCodeAlertView.addSubview(countryCodeTitleLabel)
        
        let underLine1 = UILabel()
        underLine1.frame = CGRect(x: 0, y: countryCodeTitleLabel.frame.maxY + y, width: countryCodeAlertView.frame.width, height: 1)
        underLine1.backgroundColor = UIColor.blue
        countryCodeAlertView.addSubview(underLine1)
        
        print("LEFT CHANGE", individualCountryFlagArray.count)
        
        countryCodeTableView.frame = CGRect(x: 0, y: underLine1.frame.maxY, width: countryCodeAlertView.frame.width, height: countryCodeAlertView.frame.height - (8.1 * y))
        countryCodeTableView.register(CountryCodeTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(CountryCodeTableViewCell.self))
        countryCodeTableView.dataSource = self
        countryCodeTableView.delegate = self
        countryCodeAlertView.addSubview(countryCodeTableView)
        
        countryCodeTableView.reloadData()
        
//        let cancelButton = UIButton()
        cancelButton.frame = CGRect(x: 0, y: countryCodeTableView.frame.maxY, width: countryCodeAlertView.frame.width, height: (4 * y))
        cancelButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.addTarget(self, action: #selector(self.countryCodeCancelAction(sender:)), for: .touchUpInside)
        countryCodeAlertView.addSubview(cancelButton)
        
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
    
    @objc func countryCodeCancelAction(sender : UIButton)
    {
        blurView.removeFromSuperview()
    }
    
    @objc func locationEditButtonAction(sender : UIButton)
    {
        Variables.sharedManager.firstName = firstNameEnglishTextField.text!
        Variables.sharedManager.secondName = secondNameEnglishTextField.text!
        Variables.sharedManager.countryName = (countryButton.titleLabel?.text)!
        Variables.sharedManager.stateName = (stateButton.titleLabel?.text)!
        Variables.sharedManager.areaName = (areaButton.titleLabel?.text)!
        Variables.sharedManager.floor = floorTextField.text!
        Variables.sharedManager.landmark = landMarkTextField.text!
        Variables.sharedManager.locationType = locationTypeTextField.text!
        Variables.sharedManager.mobileNumber = mobileTextField.text!
        Variables.sharedManager.countryCode = mobileCountryCodeLabel.text!
        Variables.sharedManager.shippingNotes = shippingNotesTextField.text!
        
        Variables.sharedManager.countryId = getCountryId
        Variables.sharedManager.stateId = getStateId
        Variables.sharedManager.areaId = getAreaId
        
        if addressSwitchButton.isOn == true
        {
            Variables.sharedManager.checkDefaultId = 1
        }
        else
        {
            Variables.sharedManager.checkDefaultId = 0
        }
        
        let locationScreen = LocationViewController()
        locationScreen.screenTag = 2
        locationScreen.selectedCoordinate = getLocation
        self.navigationController?.pushViewController(locationScreen, animated: true)
        
        /*if screenTag == 1
        {
            Variables.sharedManager.firstName = firstNameEnglishTextField.text!
            let locationScreen = LocationViewController()
            locationScreen.screenTag = 1
            locationScreen.selectedCoordinate = getLocation
            self.navigationController?.pushViewController(locationScreen, animated: true)
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }*/
    }
    
    @objc func countryButtonAction(sender : UIButton)
    {
        view.endEditing(true)
        countryAlert = UIAlertController(title: "Country", message: "Please choose your country", preferredStyle: .alert)
        
        for i in 0..<countryNameArray.count
        {
            if let country = countryNameArray[i] as? String
            {
                let convertedString = country.split(separator: "(")
                countryAlert.addAction(UIAlertAction(title: "\(convertedString[0])", style: .default, handler: countryCodeAlertAction(action:)))
            }
        }
        countryAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        self.present(countryAlert, animated: true, completion: nil)
        
        countryAlertViewInEnglish()
    }
    
    func countryAlertViewInEnglish()
    {
        blurView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        blurView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(blurView)
        
        alertView.frame = CGRect(x: (3 * x), y: (3 * y), width: view.frame.width - (6 * x), height: view.frame.height - (6 * y))
        alertView.layer.cornerRadius = 15
        alertView.layer.masksToBounds = true
        alertView.backgroundColor = UIColor.white
        blurView.addSubview(alertView)
        
        titleLabel.frame = CGRect(x: 0, y: y, width: alertView.frame.width, height: (2 * y))
        titleLabel.text = "Please select your country"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "", size: 10)
        alertView.addSubview(titleLabel)
        
        let underLine1 = UILabel()
        underLine1.frame = CGRect(x: 0, y: titleLabel.frame.maxY + y, width: alertView.frame.width, height: 1)
        underLine1.backgroundColor = UIColor.blue
        alertView.addSubview(underLine1)
        
        print("LEFT CHANGE", individualCountryFlagArray.count)
        
        countryTableView.frame = CGRect(x: 0, y: underLine1.frame.maxY, width: alertView.frame.width, height: alertView.frame.height - (8.1 * y))
        countryTableView.register(CountryCodeTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(CountryCodeTableViewCell.self))
        countryTableView.dataSource = self
        countryTableView.delegate = self
        alertView.addSubview(countryTableView)
        
        countryTableView.reloadData()
        
        cancelButton.frame = CGRect(x: 0, y: countryTableView.frame.maxY, width: alertView.frame.width, height: (4 * y))
        cancelButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.addTarget(self, action: #selector(self.countryCodeCancelAction(sender:)), for: .touchUpInside)
        alertView.addSubview(cancelButton)
        
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
    
    func countryCodeAlertAction(action : UIAlertAction)
    {
        countryButton.setTitle(action.title, for: .normal)
        
        for i in 0..<countryNameArray.count
        {
            if let country = countryNameArray[i] as? String
            {
                let convertedString = country.split(separator: "(")
                
                if action.title == "\(convertedString[0])"
                {
                    setOrHide = 0
                    let int = countryIdArray[i] as! Int
                    serviceCall.API_GetStateListByCountry(countryId: "\(int)", delegate: self)
                    if let language = UserDefaults.standard.value(forKey: "language") as? String
                    {
                        if language == "en"
                        {
                            stateButton.setTitle("State", for: .normal)
                        }
                        else if language == "ar"
                        {
                            stateButton.setTitle("الامارة", for: .normal)
                        }
                    }
                    else
                    {
                        stateButton.setTitle("State", for: .normal)
                    }
                }
            }
        }
    }
    
    @objc func stateButtonAction(sender : UIButton)
    {
        if stateNameArray.count == 0
        {
            if checkStateName == 0
            {
                var emptyAlert = UIAlertController()
                
                if let language = UserDefaults.standard.value(forKey: "language") as? String
                {
                    if language == "en"
                    {
                        emptyAlert = UIAlertController(title: "Alert", message: "States not available in this country", preferredStyle: .alert)
                        emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    }
                    else if language == "ar"
                    {
                        emptyAlert = UIAlertController(title: "تنبيه", message: "الدول غير متوفرة في هذا البلد", preferredStyle: .alert)
                        emptyAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: nil))
                    }
                }
                else
                {
                    emptyAlert = UIAlertController(title: "Alert", message: "States not available in this country", preferredStyle: .alert)
                    emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                }
                
                self.navigationController?.present(emptyAlert, animated: true, completion: nil)
            }
            else
            {
                var emptyAlert = UIAlertController()
                
                if let language = UserDefaults.standard.value(forKey: "language") as? String
                {
                    if language == "en"
                    {
                        emptyAlert = UIAlertController(title: "Alert", message: "Please select your country first", preferredStyle: .alert)
                        emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    }
                    else if language == "ar"
                    {
                        emptyAlert = UIAlertController(title: "تنبيه", message: "يرجى اختيار بلدك أولا", preferredStyle: .alert)
                        emptyAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: nil))
                    }
                }
                else
                {
                    emptyAlert = UIAlertController(title: "Alert", message: "Please select your country first", preferredStyle: .alert)
                    emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                }
                
                self.navigationController?.present(emptyAlert, animated: true, completion: nil)
            }
        }
        else
        {
            var stateAlert = UIAlertController()
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    stateAlert = UIAlertController(title: "State", message: "Please choose your state", preferredStyle: .alert)
                    for i in 0..<stateNameArray.count
                    {
                        if let state = stateNameArray[i] as? String
                        {
                            stateAlert.addAction(UIAlertAction(title: "\(state)", style: .default, handler: stateAlertAction(action:)))
                        }
                    }
                    stateAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                }
                else if language == "ar"
                {
                    stateAlert = UIAlertController(title: "المدينة", message: "الرجاء اختيار ولايتك", preferredStyle: .alert)
                    for i in 0..<stateNameArray.count
                    {
                        if let state = stateNameArray[i] as? String
                        {
                            stateAlert.addAction(UIAlertAction(title: "\(state)", style: .default, handler: stateAlertAction(action:)))
                        }
                    }
                    stateAlert.addAction(UIAlertAction(title: "الغاء", style: .cancel, handler: nil))
                }
            }
            else
            {
                stateAlert = UIAlertController(title: "State", message: "Please choose your state", preferredStyle: .alert)
                for i in 0..<stateNameArray.count
                {
                    if let state = stateNameArray[i] as? String
                    {
                        stateAlert.addAction(UIAlertAction(title: "\(state)", style: .default, handler: stateAlertAction(action:)))
                    }
                }
                stateAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            }
            
            
            self.present(stateAlert, animated: true, completion: nil)
        }
    }
    
    func stateAlertAction(action : UIAlertAction)
    {
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                areaButton.setTitle("Area", for: .normal)
            }
            else if language == "ar"
            {
                areaButton.setTitle("المنطقة", for: .normal)
            }
        }
        else
        {
            areaButton.setTitle("Area", for: .normal)
        }
        
        stateButton.setTitle(action.title, for: .normal)
        
        for i in 0..<stateNameArray.count
        {
            if let state = stateNameArray[i] as? String
            {
                if state == action.title
                {
                    setOrHide = 0
                    getStateId = stateCodeArray[i] as! Int
                    serviceCall.API_GetAreaByState(stateId: "\(getStateId)", delegate: self)
                    activityContents()
                }
            }
        }
    }
    
    @objc func saveAndNextButtonAction(sender : UIButton)
    {
        var emptyAlert = UIAlertController()
        var buyerId = String()
        
        if let getBuyerId = UserDefaults.standard.value(forKey: "userId") as? String
        {
            buyerId = getBuyerId
        }
        else if let getBuyerId = UserDefaults.standard.value(forKey: "userId") as? Int
        {
            buyerId = "\(getBuyerId)"
        }
        
        /*let FirstNameStr = firstNameEnglishTextField.text!
        let lastNameStr = secondNameEnglishTextField.text!
        let CountryId = 1
        let AreaStr = areaButton.titleLabel?.text!
        let floorStr = floorTextField.text!
        let LandmarkStr = landMarkTextField.text!
        let locationTypeStr = locationTypeTextField.text!
        let shippingStr = shippingNotesTextField.text!
        let CountryCode = mobileCountryCodeLabel.text!
        let PhoneNum = mobileTextField.text!
        
        
        print("GET OF LAT AND LONG", latitude, longitude)
        
        print("FIRST NAME", FirstNameStr)
        print(lastNameStr)
        print(AreaStr)
        print(floorStr)
        print(LandmarkStr)
        print(locationTypeStr)
        print(shippingStr)
        print(CountryCode)
        print(PhoneNum)*/
        
        let latitude = getLocation.latitude
        let longitude = getLocation.longitude
        
        if firstNameEnglishTextField.text != "" || firstNameEnglishTextField.text?.count != 0 || firstNameEnglishTextField.text?.isEmpty != true
        {
            if secondNameEnglishTextField.text != "" || secondNameEnglishTextField.text?.count != 0 || secondNameEnglishTextField.text?.isEmpty != true
            {
                if countryButton.titleLabel?.text != "Country" || countryButton.titleLabel?.text?.isEmpty == true || countryButton.titleLabel?.text == nil
                {
                    if stateButton.titleLabel?.text != "State" || stateButton.titleLabel?.text?.isEmpty == true || stateButton.titleLabel?.text == nil
                    {
                        if areaButton.titleLabel?.text != "Area" || areaButton.titleLabel?.text?.isEmpty == true || areaButton.titleLabel?.text == nil
                        {
//                            if floorTextField.text != "" || floorTextField.text?.count != 0 || floorTextField.text?.isEmpty != true
//                            {
                                if landMarkTextField.text != "" || landMarkTextField.text?.count != 0 || landMarkTextField.text?.isEmpty != true
                                {
                                    if locationTypeTextField.text != "" || locationTypeTextField.text?.count != 0 || locationTypeTextField.text?.isEmpty != true
                                    {
                                        if mobileTextField.text != "" || mobileTextField.text?.count != 0 || mobileTextField.text?.isEmpty != true
                                        {
                                            if insertOrUpdate == 1
                                            {
                                                activityContents()
                                                serviceCall.API_InsertAddress(BuyerId: buyerId, FirstName: firstNameEnglishTextField.text!, LastName: secondNameEnglishTextField.text!, CountryId: getCountryId, StateId: getStateId, Area: "\(getAreaId)", Floor: floorTextField.text!, LandMark: landMarkTextField.text!, LocationType: locationTypeTextField.text!, ShippingNotes: shippingNotesTextField.text!, IsDefault: setDefault, CountryCode: mobileCountryCodeLabel.text!, PhoneNo: mobileTextField.text!, Longitude: Float(longitude), Latitude: Float(latitude), delegate: self)
                                            }
                                            else
                                            {
                                                activityContents()
                                                serviceCall.API_UpdateAddress(Id: getEditId, BuyerId: buyerId, FirstName: firstNameEnglishTextField.text!, LastName: secondNameEnglishTextField.text!, CountryId: getCountryId, StateId: getStateId, Area: "\(getAreaId)", Floor: floorTextField.text!, LandMark: landMarkTextField.text!, LocationType: locationTypeTextField.text!, ShippingNotes: shippingNotesTextField.text!, IsDefault: setDefault, CountryCode: mobileCountryCodeLabel.text!, PhoneNo: mobileTextField.text!, Longitude: Float(longitude), Latitude: Float(latitude), delegate: self)
                                            }
                                        }
                                        else
                                        {
                                            if let language = UserDefaults.standard.value(forKey: "language") as? String
                                            {
                                                if language == "en"
                                                {
                                                    emptyAlert = UIAlertController(title: "Alert", message: "Please fill mobile number to proceed", preferredStyle: .alert)
                                                    emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                                }
                                                else if language == "ar"
                                                {
                                                    emptyAlert = UIAlertController(title: "تنبيه", message: "يرجى ملء رقم هاتفك المحمول للمتابعة", preferredStyle: .alert)
                                                    emptyAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: nil))
                                                }
                                            }
                                            else
                                            {
                                                emptyAlert = UIAlertController(title: "Alert", message: "Please fill mobile number to proceed", preferredStyle: .alert)
                                                emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                            }
                                            
                                            self.present(emptyAlert, animated: true, completion: nil)
                                        }
                                    }
                                    else
                                    {
                                        if let language = UserDefaults.standard.value(forKey: "language") as? String
                                        {
                                            if language == "en"
                                            {
                                                emptyAlert = UIAlertController(title: "Alert", message: "Please select location type to proceed", preferredStyle: .alert)
                                                emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                            }
                                            else if language == "ar"
                                            {
                                                emptyAlert = UIAlertController(title: "تنبيه", message: "يرجى تحديد نوع الموقع للمتابعة", preferredStyle: .alert)
                                                emptyAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: nil))
                                            }
                                        }
                                        else
                                        {
                                            emptyAlert = UIAlertController(title: "Alert", message: "Please select location type to proceed", preferredStyle: .alert)
                                            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                        }
                                        
                                        self.present(emptyAlert, animated: true, completion: nil)
                                    }
                                }
                                else
                                {
                                    if let language = UserDefaults.standard.value(forKey: "language") as? String
                                    {
                                        if language == "en"
                                        {
                                            emptyAlert = UIAlertController(title: "Alert", message: "Please fill landmark details to proceed", preferredStyle: .alert)
                                            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                        }
                                        else if language == "ar"
                                        {
                                            emptyAlert = UIAlertController(title: "تنبيه", message: "تفاصيل علامة الأرض فارغة", preferredStyle: .alert)
                                            emptyAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: nil))
                                        }
                                    }
                                    else
                                    {
                                        emptyAlert = UIAlertController(title: "Alert", message: "Please fill landmark details to proceed", preferredStyle: .alert)
                                        emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    }
                                    
                                    self.present(emptyAlert, animated: true, completion: nil)
                                }
//                            }
//                            else
//                            {
//                                if let language = UserDefaults.standard.value(forKey: "language") as? String
//                                {
//                                    if language == "en"
//                                    {
//                                        emptyAlert = UIAlertController(title: "Alert", message: "Please fill floor details to proceed", preferredStyle: .alert)
//                                        emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                                    }
//                                    else if language == "ar"
//                                    {
//                                        emptyAlert = UIAlertController(title: "تنبيه", message: "يرجى ملء تفاصيل الكلمة للمضي قدما", preferredStyle: .alert)
//                                        emptyAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: nil))
//                                    }
//                                }
//                                else
//                                {
//                                    emptyAlert = UIAlertController(title: "Alert", message: "Please fill floor details to proceed", preferredStyle: .alert)
//                                    emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                                }
//
//                                self.present(emptyAlert, animated: true, completion: nil)
//                            }
                        }
                        else
                        {
                            if let language = UserDefaults.standard.value(forKey: "language") as? String
                            {
                                if language == "en"
                                {
                                    emptyAlert = UIAlertController(title: "Alert", message: "Please select your area to proceed", preferredStyle: .alert)
                                    emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                }
                                else if language == "ar"
                                {
                                    emptyAlert = UIAlertController(title: "تنبيه", message: "يرجى اختيار منطقتك للمتابعة", preferredStyle: .alert)
                                    emptyAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: nil))
                                }
                            }
                            else
                            {
                                emptyAlert = UIAlertController(title: "Alert", message: "Please select your area to proceed", preferredStyle: .alert)
                                emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            }
                            
                            self.present(emptyAlert, animated: true, completion: nil)
                        }
                    }
                    else
                    {
                        if let language = UserDefaults.standard.value(forKey: "language") as? String
                        {
                            if language == "en"
                            {
                                emptyAlert = UIAlertController(title: "Alert", message: "Please select your state to proceed", preferredStyle: .alert)
                                emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            }
                            else if language == "ar"
                            {
                                emptyAlert = UIAlertController(title: "تنبيه", message: "يرجى تحديد ولايتك للمتابعة", preferredStyle: .alert)
                                emptyAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: nil))
                            }
                        }
                        else
                        {
                            emptyAlert = UIAlertController(title: "Alert", message: "Please select your state to proceed", preferredStyle: .alert)
                            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        }
                        
                        self.present(emptyAlert, animated: true, completion: nil)
                    }
                }
                else
                {
                    if let language = UserDefaults.standard.value(forKey: "language") as? String
                    {
                        if language == "en"
                        {
                            emptyAlert = UIAlertController(title: "Alert", message: "Please select your country to proceed", preferredStyle: .alert)
                            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        }
                        else if language == "ar"
                        {
                            emptyAlert = UIAlertController(title: "تنبيه", message: "الرجاء اختيار بلدك للمتابعة", preferredStyle: .alert)
                            emptyAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: nil))
                        }
                    }
                    else
                    {
                        emptyAlert = UIAlertController(title: "Alert", message: "Please select your country to proceed", preferredStyle: .alert)
                        emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    }
                    
                    self.present(emptyAlert, animated: true, completion: nil)
                }
            }
            else
            {
                if let language = UserDefaults.standard.value(forKey: "language") as? String
                {
                    if language == "en"
                    {
                        emptyAlert = UIAlertController(title: "Alert", message: "Please fill second name to proceed", preferredStyle: .alert)
                        emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    }
                    else if language == "ar"
                    {
                        emptyAlert = UIAlertController(title: "تنبيه", message: "يرجى ملء الاسم الثاني للمتابعة", preferredStyle: .alert)
                        emptyAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: nil))
                    }
                }
                else
                {
                    emptyAlert = UIAlertController(title: "Alert", message: "Please fill second name to proceed", preferredStyle: .alert)
                    emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                }
                
                self.present(emptyAlert, animated: true, completion: nil)
            }
        }
        else
        {
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    emptyAlert = UIAlertController(title: "Alert", message: "Please fill first name to proceed", preferredStyle: .alert)
                    emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                }
                else if language == "ar"
                {
                    emptyAlert = UIAlertController(title: "تنبيه", message: "يرجى ملء الاسم الأول للمتابعة", preferredStyle: .alert)
                    emptyAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: nil))
                }
            }
            else
            {
                emptyAlert = UIAlertController(title: "Alert", message: "Please fill first name to proceed", preferredStyle: .alert)
                emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            }
            
            self.present(emptyAlert, animated: true, completion: nil)
        }
        
        /*if FirstNameStr.isEmpty != true || FirstNameStr != ""
        {
            if lastNameStr.isEmpty != true || lastNameStr != ""
            {
                if AreaStr!.isEmpty != true || AreaStr != "" || AreaStr != "Area"
                {
                    if floorStr.isEmpty != true || floorStr != ""
                    {
                        if LandmarkStr.isEmpty != true || LandmarkStr != ""
                        {
//                            if shippingStr.isEmpty != true || shippingStr != ""
//                            {
                                if CountryCode.isEmpty != true || CountryCode != ""
                                {
                                    if PhoneNum.isEmpty != true || PhoneNum != ""
                                    {
                                        if locationTypeStr.isEmpty != true || locationTypeStr != ""
                                        {
                                            if insertOrUpdate == 1
                                            {
                                                activityContents()
                                                serviceCall.API_InsertAddress(BuyerId: buyerId, FirstName: FirstNameStr, LastName: lastNameStr, CountryId: getCountryId, StateId: getStateId, Area: "\(getAreaId)", Floor: floorStr, LandMark: LandmarkStr, LocationType: locationTypeStr, ShippingNotes: shippingStr, IsDefault: setDefault, CountryCode: CountryCode, PhoneNo: PhoneNum, Longitude: Float(longitude), Latitude: Float(latitude), delegate: self)
                                            }
                                            else
                                            {
                                                activityContents()
                                                print("STATE AND AREA ID WHILE UPDATING", getCountryId, getStateId, getAreaId)
                                                serviceCall.API_UpdateAddress(Id: getEditId, BuyerId: buyerId, FirstName: FirstNameStr, LastName: lastNameStr, CountryId: getCountryId, StateId: getStateId, Area: "\(getAreaId)", Floor: floorStr, LandMark: LandmarkStr, LocationType: locationTypeStr, ShippingNotes: shippingStr, IsDefault: setDefault, CountryCode: CountryCode, PhoneNo: PhoneNum, Longitude: Float(longitude), Latitude: Float(latitude), delegate: self)
                                            }
                                        }
                                        else
                                        {
                                            emptyAlert = UIAlertController(title: "Alert", message: "Please fill location type to proceed", preferredStyle: .alert)
                                            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                            self.present(emptyAlert, animated: true, completion: nil)
                                        }
                                    }
                                    else
                                    {
                                        emptyAlert = UIAlertController(title: "Alert", message: "Please fill phone number to proceed", preferredStyle: .alert)
                                        emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                        self.present(emptyAlert, animated: true, completion: nil)
                                    }
                                }
                                else
                                {
                                    emptyAlert = UIAlertController(title: "Alert", message: "Please select country code to proceed", preferredStyle: .alert)
                                    emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    self.present(emptyAlert, animated: true, completion: nil)
                                }
                            /*}
                            else
                            {
                                emptyAlert = UIAlertController(title: "Alert", message: "Please fill shipping notes to proceed", preferredStyle: .alert)
                                emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(emptyAlert, animated: true, completion: nil)
                            }*/
                        }
                        else
                        {
                            emptyAlert = UIAlertController(title: "Alert", message: "Please fill landmark to proceed", preferredStyle: .alert)
                            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(emptyAlert, animated: true, completion: nil)
                        }
                    }
                    else
                    {
                        emptyAlert = UIAlertController(title: "Alert", message: "Please fill floor to proceed", preferredStyle: .alert)
                        emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(emptyAlert, animated: true, completion: nil)
                    }
                }
                else
                {
                    emptyAlert = UIAlertController(title: "Alert", message: "Please select area to proceed", preferredStyle: .alert)
                    emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(emptyAlert, animated: true, completion: nil)
                }
            }
            else
            {
                emptyAlert = UIAlertController(title: "Alert", message: "Please fill last name to proceed", preferredStyle: .alert)
                emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(emptyAlert, animated: true, completion: nil)
            }
        }
        else
        {
            emptyAlert = UIAlertController(title: "Alert", message: "Please fill first name to proceed", preferredStyle: .alert)
            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(emptyAlert, animated: true, completion: nil)
        }*/
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var returnCount = Int()
        
        if tableView == areaTableView
        {
            returnCount =  areaNameArray.count
        }
        else
        {
            returnCount = countryNameArray.count
        }
        
        return returnCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CountryCodeTableViewCell.self), for: indexPath as IndexPath) as! CountryCodeTableViewCell
        
        if tableView == countryTableView
        {
            cell.countryName.frame = CGRect(x: (2 * x), y: y, width: cell.frame.width - (4 * x), height: (2 * y))
            
            if let country = countryNameArray[indexPath.row] as? String
            {
                let convertedString = country.split(separator: "(")
                cell.countryName.text = "\(convertedString[0])"
            }
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    cell.countryName.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    cell.countryName.textAlignment = .left
                }
                else if language == "ar"
                {
                    cell.countryName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    cell.countryName.textAlignment = .right
                }
            }
            else
            {
                cell.countryName.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                cell.countryName.textAlignment = .left
            }
        }
        else if tableView == areaTableView
        {
            cell.countryName.frame = CGRect(x: cell.flagImage.frame.maxX + (2 * x), y: y, width: cell.frame.width - (4 * x), height: (2 * y))
            
            if let country = areaNameArray[indexPath.row] as? String
            {
                let convertedString = country.split(separator: "(")
                cell.countryName.text = "\(convertedString[0])"
            }
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    cell.countryName.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    cell.countryName.textAlignment = .left
                }
                else if language == "ar"
                {
                    cell.countryName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    cell.countryName.textAlignment = .right
                }
            }
            else
            {
                cell.countryName.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                cell.countryName.textAlignment = .left
            }
        }
        else
        {
            cell.flagImage.frame = CGRect(x: x, y: y, width: (2.5 * x), height: (2 * y))
            
            if let imageName = countryFlagArray[indexPath.row] as? String
            {
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/flags/\(imageName)"
                let apiurl = URL(string: api)
                
                if apiurl != nil
                {
                    cell.flagImage.dowloadFromServer(url: apiurl!)
                }
                else
                {
                    cell.flagImage.image = UIImage(named: "empty")
                }
            }
            
            cell.countryName.frame = CGRect(x: cell.flagImage.frame.maxX + (2 * x), y: y, width: cell.frame.width - (4 * x), height: (2 * y))
            
            if let country = countryNameArray[indexPath.row] as? String
            {
                let convertedString = country.split(separator: "(")
                cell.countryName.text = country
            }
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    cell.flagImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    cell.countryName.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    cell.countryName.textAlignment = .left
                }
                else if language == "ar"
                {
                    cell.flagImage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    cell.countryName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    cell.countryName.textAlignment = .right
                }
            }
            else
            {
                cell.flagImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                cell.countryName.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                cell.countryName.textAlignment = .left
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == countryTableView
        {
            print("BEFORE OF COUNTRY", areaNameArray.count, areaCodeArray.count)

            let dummyArray = NSArray()
            areaNameArray = dummyArray
            areaCodeArray = dummyArray
            
            print("AFTER OF COUNTRY", areaNameArray.count, areaCodeArray.count)
            for i in 0..<countryNameArray.count
            {
                if let country = countryNameArray[i] as? String
                {
                    let convertedString = country.split(separator: "(")
                    
                    if let compareString = countryNameArray[indexPath.row] as? String
                    {
                        let compareString1 = compareString.split(separator: "(")
                        
                        print("COMPARE STRING", compareString, convertedString[0])
                        if "\(compareString1[0])" == "\(convertedString[0])"
                        {
                            countryButton.setTitle("\(compareString1[0])", for: .normal)
                            setOrHide = 0
                            let int = countryIdArray[i] as! Int
                            serviceCall.API_GetStateListByCountry(countryId: "\(int)", delegate: self)
                            if let language = UserDefaults.standard.value(forKey: "language") as? String
                            {
                                if language == "en"
                                {
                                    stateButton.setTitle("State", for: .normal)
                                    areaButton.setTitle("Area", for: .normal)
                                }
                                else if language == "ar"
                                {
                                    stateButton.setTitle("الامارة", for: .normal)
                                    areaButton.setTitle("المنطقة", for: .normal)
                                }
                            }
                            else
                            {
                                stateButton.setTitle("State", for: .normal)
                                areaButton.setTitle("Area", for: .normal)
                            }
                            getCountryId = countryIdArray[i] as! Int
                        }
                        else
                        {
                            
                        }
                    }
                }
            }
        }
        else if tableView == areaTableView
        {
            let textString = areaNameArray[indexPath.row] as! String
            areaButton.setTitle(textString, for: .normal)
            
            print("GET AREA CODE", areaCodeArray[indexPath.row])
            getAreaId = areaCodeArray[indexPath.row] as! Int
            
            areaBlurView.removeFromSuperview()
        }
        else
        {
            flagImageView.image = nil
            
            if let imageName = countryFlagArray[indexPath.row] as? String
            {
                let api = "http://appsapi.mzyoon.com/images/flags/\(imageName)"
                let apiurl = URL(string: api)
                print("SELECTED COUNTRY - \(imageName)", apiurl)
                if apiurl != nil
                {
                    flagImageView.dowloadFromServer(url: apiurl!)
                }
                else
                {
                    flagImageView.image = UIImage(named: "empty")
                }
            }
            
            mobileCountryCodeLabel.text = countryCodeArray[indexPath.row] as? String
        }
        
        blurView.removeFromSuperview()
    }
    
    func locationTypeContents()
    {
        var locationAlert = UIAlertController()
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                locationAlert = UIAlertController(title: "Alert", message: "Choose your location type", preferredStyle: .alert)
                locationAlert.addAction(UIAlertAction(title: "Home", style: .default, handler: emptyAlertActions(action:)))
                locationAlert.addAction(UIAlertAction(title: "Work", style: .default, handler: emptyAlertActions(action:)))
                locationAlert.addAction(UIAlertAction(title: "Others", style: .default, handler: emptyAlertActions(action:)))
                locationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            }
            else if language == "ar"
            {
                locationAlert = UIAlertController(title: "تنبيه", message: "اختر نوع موقعك", preferredStyle: .alert)
                locationAlert.addAction(UIAlertAction(title: "موقع المنزل", style: .default, handler: emptyAlertActions(action:)))
                locationAlert.addAction(UIAlertAction(title: "مكان العمل", style: .default, handler: emptyAlertActions(action:)))
                locationAlert.addAction(UIAlertAction(title: "الآخرين", style: .default, handler: emptyAlertActions(action:)))
                locationAlert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: nil))
            }
        }
        else
        {
            locationAlert = UIAlertController(title: "Alert", message: "Choose your location type", preferredStyle: .alert)
            locationAlert.addAction(UIAlertAction(title: "Home", style: .default, handler: emptyAlertActions(action:)))
            locationAlert.addAction(UIAlertAction(title: "Work", style: .default, handler: emptyAlertActions(action:)))
            locationAlert.addAction(UIAlertAction(title: "Others", style: .default, handler: emptyAlertActions(action:)))
            locationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        }
        
        self.present(locationAlert, animated: true, completion: nil)
    }
    
    func emptyAlertActions(action : UIAlertAction)
    {
        /*if action.title == "Home"
        {
            locationTypeTextField.text = "Home"
        }
        else if action.title == "Work"
        {
            locationTypeTextField.text = "Work"
        }
        else if action.title == "Others"
        {
            locationTypeTextField.text = "Others"
        }*/
        
        locationTypeTextField.text = action.title
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == locationTypeTextField
        {
            locationTypeContents()
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == firstNameEnglishTextField
        {
            firstNameEnglishTextField.resignFirstResponder()
            //            secondNameEnglishTextField.becomeFirstResponder()
        }
        else if textField == secondNameEnglishTextField
        {
            secondNameEnglishTextField.resignFirstResponder()
            //            areaNameTextField.becomeFirstResponder()
        }
        else if textField == areaButton
        {
            areaButton.resignFirstResponder()
            //            floorTextField.becomeFirstResponder()
        }
        else if textField == floorTextField
        {
            floorTextField.resignFirstResponder()
            //            landMarkTextField.becomeFirstResponder()
        }
        else if textField == landMarkTextField
        {
            landMarkTextField.resignFirstResponder()
//            locationTypeTextField.becomeFirstResponder()
        }
        else if textField == locationTypeTextField
        {
            locationTypeTextField.resignFirstResponder()
            //            mobileTextField.becomeFirstResponder()
        }
        else if textField == mobileTextField
        {
            mobileTextField.resignFirstResponder()
            //            shippingNotesTextField.becomeFirstResponder()
        }
        else if textField == shippingNotesTextField
        {
            shippingNotesTextField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let ACCEPTABLE_CHARACTERS = "0123456789"
        var returnParameter = Bool()
        
        if textField == mobileTextField
        {
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            returnParameter = (string == filtered)
        }
        else
        {
            returnParameter = true
        }
        print("return parameter", returnParameter)
        return returnParameter
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
