//
//  AddressViewController.swift
//  Mzyoon
//
//  Created by QOL on 19/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import GoogleMaps
import GooglePlaces


class AddressViewController: UIViewController, ServerAPIDelegate
{
    
    var x = CGFloat()
    var y = CGFloat()
    
    var addressCount = 0
    
    let serviceCall = ServerAPI()
    
    var viewController = String()
    
    var FirstName = NSArray()
    var LastName = NSArray()
    var Id = NSArray()
    var BuyerId = NSArray()
    var Lattitude = NSArray()
    var Longitude = NSArray()
    var CountryId = NSArray()
    var StateId = NSArray()
    var areaArray = NSArray()
    var Building = NSArray()
    var Floor = NSArray()
    var LandMark = NSArray()
    var LocationType = NSArray()
    var ShippingNotes = NSArray()
    var PhoneNo = NSArray()
    var CountryCode = NSArray()
    var isDefault = NSArray()
    var CreatedBy = NSArray()
    var ModifiedBy = NSArray()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    var activeView = UIView()
    var activityView = UIActivityIndicatorView()
    
    var selectedAddressString = String()
    
    override func viewDidLoad()
    {
        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
        
        view.backgroundColor = UIColor.white
        
        activityContents()
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if let userId = UserDefaults.standard.value(forKey: "userId") as? String
        {
            self.serviceCall.API_GetBuyerAddress(BuyerAddressId: userId, delegate: self)
        }
        else if let userId = UserDefaults.standard.value(forKey: "userId") as? Int
        {
            self.serviceCall.API_GetBuyerAddress(BuyerAddressId: "\(userId)", delegate: self)
        }
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
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("Address ", errorMessage)
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        //  ErrorStr = "Default Error"
        PageNumStr = "AddressViewController"
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
    
    func API_CALLBACK_GetBuyerAddress(getBuyerAddr: NSDictionary)
    {
        let ResponseMsg = getBuyerAddr.object(forKey: "ResponseMsg") as! String
        
        stopActivity()
        
        if ResponseMsg == "Success"
        {
            let Result = getBuyerAddr.object(forKey: "Result") as! NSArray
            print("Buyer Address List:", Result)
            addressCount = Result.count
            print("addressCount:", addressCount)
            
            FirstName = Result.value(forKey: "FirstName") as! NSArray
            print("FirstName", FirstName)
            
            LastName = Result.value(forKey: "LastName") as! NSArray
            print("LastName", LastName)
            
            areaArray = Result.value(forKey: "Area") as! NSArray
            print("Area", areaArray)
            
            PhoneNo = Result.value(forKey: "PhoneNo") as! NSArray
            print("PhoneNo", PhoneNo)
            
            Lattitude = Result.value(forKey: "Lattitude") as! NSArray
            print("Lattitude", Lattitude)
            
            Longitude = Result.value(forKey: "Longitude") as! NSArray
            print("Longitude", Longitude)
            
            isDefault = Result.value(forKey: "IsDefault") as! NSArray
            print("IsDefault", isDefault)
            
            Id = Result.value(forKey: "Id") as! NSArray
            print("ADDRESS ID ARRAY", Id)
            
            LocationType = Result.value(forKey: "LocationType") as! NSArray
            print("LocationType", LocationType)
            
            Floor = Result.value(forKey: "Floor") as! NSArray
            print("Floor", Floor)
            
            LandMark = Result.value(forKey: "LandMark") as! NSArray
            print("LandMark", LandMark)
            
            CountryCode = Result.value(forKey: "CountryCode") as! NSArray
            print("CountryCode", CountryCode)
            
            ShippingNotes = Result.value(forKey: "ShippingNotes") as! NSArray
            print("ShippingNotes", ShippingNotes)
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = getBuyerAddr.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetBuyerAddressById"
            ErrorStr = Result
            DeviceError()
        }
        
        addressContent()
    }
    
    func API_CALLBACK_UpdateAddress(updateAddr: NSDictionary)
    {
        let ResponseMsg = updateAddr.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = updateAddr.object(forKey: "Result") as! String
            print("Result", Result)
            
            if Result == "1"
            {
                let alert = UIAlertController(title: "", message: "Updated Sucessfully", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
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
    
    func API_CALLBACK_DeleteAddress(deleteAddr: NSDictionary)
    {
        print("RESPONSE MSG FOR DELETE", deleteAddr)
        let ResponseMsg = deleteAddr.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = deleteAddr.object(forKey: "Result") as! String
            print("Result", Result)
            
            if Result == "1"
            {
                let alert = UIAlertController(title: "", message: "Deleted Sucessfully", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            if let userId = UserDefaults.standard.value(forKey: "userId") as? String
            {
                self.serviceCall.API_GetBuyerAddress(BuyerAddressId: userId, delegate: self)
            }
            else if let userId = UserDefaults.standard.value(forKey: "userId") as? Int
            {
                self.serviceCall.API_GetBuyerAddress(BuyerAddressId: "\(userId)", delegate: self)
            }
        }
        else if ResponseMsg == "Failure"
        {
            let alert = UIAlertController(title: "Alert", message: "Please try after some time", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            let Result = deleteAddr.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "DeleteBuyerAddressByAddressId"
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func addressContent()
    {
        let backgroundImageview = UIImageView()
        backgroundImageview.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        backgroundImageview.image = UIImage(named: "background")
        view.addSubview(backgroundImageview)
        
        let addressNavigationBar = UIView()
        addressNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        addressNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(addressNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 4
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        addressNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: addressNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "ADDRESS"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        addressNavigationBar.addSubview(navigationTitle)
        
        if addressCount == 0
        {
            let addressImageView = UIImageView()
            addressImageView.frame = CGRect(x: (2 * x), y: ((view.frame.height - (25 * y)) / 2), width: view.frame.width - (4 * x), height: (25 * y))
            addressImageView.image = UIImage(named: "locatingImage")
            view.addSubview(addressImageView)
        }
        else
        {
            let addressScrollView = UIScrollView()
            addressScrollView.frame = CGRect(x: x, y: addressNavigationBar.frame.maxY + (2 * y), width: view.frame.width - (2 * x), height: view.frame.height - (14 * y))
            addressScrollView.backgroundColor = UIColor.clear
            view.addSubview(addressScrollView)
            
            var y1:CGFloat = 0
            
            for i in 0..<FirstName.count
            {
                let addressSelectButton = UIButton()
                addressSelectButton.frame = CGRect(x: 0, y: y1, width: addressScrollView.frame.width, height: (21 * y))
                addressSelectButton.backgroundColor = UIColor.white
                addressSelectButton.tag = Id[i] as! Int
                addressScrollView.addSubview(addressSelectButton)
                
                if viewController == "reference"
                {
                    addressSelectButton.addTarget(self, action: #selector(self.addressSelectButtonAction(sender:)), for: .touchUpInside)
                }
                else
                {
                    
                }
                
                y1 = addressSelectButton.frame.maxY + (2 * y)
                
                let addressIcon = UIImageView()
                addressIcon.frame = CGRect(x: x, y: y, width: (2 * x), height: (2 * y))
                addressIcon.image = UIImage(named: "locationMarker")
                addressSelectButton.addSubview(addressIcon)
                
                let addressTitle = UILabel()
                addressTitle.frame = CGRect(x: addressIcon.frame.maxX + x, y: y, width: (10 * x), height: (2 * y))
                addressTitle.text = (LocationType[i] as! String)
                addressTitle.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
                addressTitle.textAlignment = .left
                addressSelectButton.addSubview(addressTitle)
                
                let addressEditButton = UIButton()
                addressEditButton.frame = CGRect(x: addressTitle.frame.maxX + x, y: y, width: (10 * x), height: (2 * y))
//                addressEditButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
                addressEditButton.setTitle("Edit", for: .normal)
                addressEditButton.setTitleColor(UIColor.black, for: .normal)
                addressEditButton.tag = i
                addressEditButton.addTarget(self, action: #selector(self.editButtonAction(sender:)), for: .touchUpInside)
                addressSelectButton.addSubview(addressEditButton)
                
                let addressEditIcon = UIImageView()
                addressEditIcon.frame = CGRect(x: 0, y: 0, width: (2 * x), height: (2 * y))
                addressEditIcon.image = UIImage(named: "edit")
                addressEditButton.addSubview(addressEditIcon)
                
                let linelabel = UILabel()
                linelabel.frame = CGRect(x: addressEditButton.frame.maxX, y: y +  y / 2, width: 1, height: y)
                linelabel.backgroundColor = UIColor.lightGray
//                addressSelectButton.addSubview(linelabel)
                
                let addressDeleteButton = UIButton()
                addressDeleteButton.frame = CGRect(x: addressEditButton.frame.maxX, y: y, width: (10 * x), height: (2 * y))
//                addressDeleteButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
                addressDeleteButton.setTitle("Delete", for: .normal)
                addressDeleteButton.setTitleColor(UIColor.black, for: .normal)
                addressDeleteButton.tag = i
                addressDeleteButton.addTarget(self, action: #selector(self.deleteButtonAction(sender:)), for: .touchUpInside)
                addressSelectButton.addSubview(addressDeleteButton)
                
                let addressDeleteIcon = UIImageView()
                addressDeleteIcon.frame = CGRect(x: 0, y: 0, width: (2 * x), height: (2 * y))
                addressDeleteIcon.image = UIImage(named: "delete")
                addressDeleteButton.addSubview(addressDeleteIcon)
                
                let underLine = UILabel()
                underLine.frame = CGRect(x: x, y: addressEditButton.frame.maxY, width: addressSelectButton.frame.width - (2 * x), height: 1)
                underLine.backgroundColor = UIColor.lightGray
                addressSelectButton.addSubview(underLine)
                
                let nameLabel = UILabel()
                nameLabel.frame = CGRect(x: x, y: underLine.frame.maxY + y, width: (5 * x), height: (2 * x))
                nameLabel.text = "Name"
                nameLabel.textColor = UIColor.black
                nameLabel.textAlignment = .left
                addressSelectButton.addSubview(nameLabel)
                
                let getNameLabel = UILabel()
                getNameLabel.frame = CGRect(x: nameLabel.frame.maxX + (10 * x), y: underLine.frame.maxY + y, width: (18.5 * x), height: (2 * x))
                getNameLabel.text = FirstName[i] as? String
                getNameLabel.textColor = UIColor.black
                getNameLabel.textAlignment = .left
                addressSelectButton.addSubview(getNameLabel)
                
                let addressLabel = UILabel()
                addressLabel.frame = CGRect(x: x, y: nameLabel.frame.maxY + y, width: (6 * x), height: (2 * x))
                addressLabel.text = "Address"
                addressLabel.textColor = UIColor.black
                addressLabel.textAlignment = .left
                addressSelectButton.addSubview(addressLabel)
                
                let getAddressLabel = UILabel()
                getAddressLabel.frame = CGRect(x: getNameLabel.frame.minX, y: nameLabel.frame.maxY + y, width: (18.5 * x), height: (6 * x))
                getAddressLabel.text = areaArray[i] as? String
                getAddressLabel.textColor = UIColor.black
                getAddressLabel.textAlignment = .left
                getAddressLabel.numberOfLines = 3
                addressSelectButton.addSubview(getAddressLabel)
                
                let mobileLabel = UILabel()
                mobileLabel.frame = CGRect(x: x, y: getAddressLabel.frame.maxY + y, width: (12 * x), height: (2 * x))
                mobileLabel.text = "Phone Number"
                mobileLabel.textColor = UIColor.black
                mobileLabel.textAlignment = .left
                addressSelectButton.addSubview(mobileLabel)
                
                let getMobileLabel = UILabel()
                getMobileLabel.frame = CGRect(x: getNameLabel.frame.minX, y: getAddressLabel.frame.maxY + y, width: (18.5 * x), height: (2 * x))
                getMobileLabel.text = PhoneNo[i] as? String
                getMobileLabel.textColor = UIColor.black
                getMobileLabel.textAlignment = .left
                addressSelectButton.addSubview(getMobileLabel)
                
                if let defaultString = isDefault[i] as? Int
                {
                    let defaultAddressImage = UIImageView()
                    defaultAddressImage.frame = CGRect(x: addressSelectButton.frame.width - (15 * x), y: addressSelectButton.frame.height - (3 * y), width: (2 * x), height: (2 * y))
                    defaultAddressImage.image = UIImage(named: "defaultAddress")
                    
                    let defaultAddressLabel = UILabel()
                    defaultAddressLabel.frame = CGRect(x: defaultAddressImage.frame.maxX, y: addressSelectButton.frame.height - (3 * y), width: (12 * x), height: (2 * y))
                    //                    defaultAddressLabel.backgroundColor = UIColor.orange
                    defaultAddressLabel.text = "Default Address"
                    defaultAddressLabel.textColor = UIColor.black
                    defaultAddressLabel.textAlignment = .left
                    defaultAddressLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
                    
                    let defaultSwitch = UISwitch()
                    defaultSwitch.frame = CGRect(x: defaultAddressLabel.frame.maxX + x, y: addressSelectButton.frame.height - (3 * y), width: (3 * x), height: (2 * y))
                    
                    if defaultString == 1
                    {
                        defaultSwitch.isOn = true
                        addressSelectButton.addSubview(defaultAddressImage)
                        addressSelectButton.addSubview(defaultAddressLabel)
                        addressSelectButton.layer.borderWidth = 2
                        addressSelectButton.layer.borderColor = UIColor.orange.cgColor
                    }
                    else
                    {
                        defaultSwitch.isOn = false
                    }
                    defaultSwitch.isUserInteractionEnabled = false
                    //                    addressSelectButton.addSubview(defaultSwitch)
                }
            }
            
            addressScrollView.contentSize.height = y1
            
        }
        
        let addNewAddressButton = UIButton()
        addNewAddressButton.frame = CGRect(x: 0, y: view.frame.height - (5 * y), width: view.frame.width, height: (5 * y))
        addNewAddressButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        addNewAddressButton.setTitle("ADD NEW ADDRESS", for: .normal)
        addNewAddressButton.setTitleColor(UIColor.white, for: .normal)
        addNewAddressButton.addTarget(self, action: #selector(self.addNewAddressButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(addNewAddressButton)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addressSelectButtonAction(sender : UIButton)
    {
        UserDefaults.standard.set(sender.tag, forKey: "addressId")
        let serviceScreen = ServiceTypeViewController()
        self.navigationController?.pushViewController(serviceScreen, animated: true)
    }
    
    @objc func editButtonAction(sender : UIButton)
    {
        let selectedCoordinate = CLLocationCoordinate2D(latitude: Lattitude[sender.tag] as! CLLocationDegrees, longitude: Longitude[sender.tag] as! CLLocationDegrees)
        reverseGeocodeCoordinate(selectedCoordinate)
        
        print("PRINT SELECTION", FirstName[sender.tag], selectedCoordinate)
        let address2Screen = Address2ViewController()
        
        address2Screen.firstNameEnglishTextField.text = FirstName[sender.tag] as? String
        address2Screen.secondNameEnglishTextField.text = ""
        address2Screen.locationTypeTextField.text = LocationType[sender.tag] as? String
        address2Screen.areaNameTextField.text = areaArray[sender.tag] as? String
        address2Screen.floorTextField.text = Floor[sender.tag] as? String
        address2Screen.landMarkTextField.text = LandMark[sender.tag] as? String
        address2Screen.mobileTextField.text = PhoneNo[sender.tag] as? String
        address2Screen.mobileCountryCodeLabel.text = CountryCode[sender.tag] as? String
        address2Screen.shippingNotesTextField.text = ShippingNotes[sender.tag] as? String
        address2Screen.getEditId = Id[sender.tag] as! Int
        address2Screen.checkDefault = isDefault[sender.tag] as! Int
        address2Screen.addressString = selectedAddressString
        
        self.navigationController?.pushViewController(address2Screen, animated: true)
    }
    
    @objc func deleteButtonAction(sender : UIButton)
    {
        if let userId = UserDefaults.standard.value(forKey: "userId") as? String
        {
            serviceCall.API_DeleteAddress(AddressId: Id[sender.tag] as! Int, userId: userId, delegate: self)
        }
        else if let userId = UserDefaults.standard.value(forKey: "userId") as? Int
        {
            serviceCall.API_DeleteAddress(AddressId: Id[sender.tag] as! Int, userId: "\(userId)", delegate: self)
        }
    }
    
    @objc func addNewAddressButtonAction(sender : UIButton)
    {
        let locationScreen = LocationViewController()
        self.navigationController?.pushViewController(locationScreen, animated: true)
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D)
    {
        
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            
            print("RESPONSE IN ADDRESS", response)
            guard let address = response?.firstResult(), let lines = address.lines else {
                print("FAILED TO RTURN ADDRESS")
                return
            }
            print("FAILED TO RTURN ADDRESS", address)

            // 3
            print("GET CURRENT ADDRESS", lines.joined(separator: "\n"))
            
            self.selectedAddressString = lines.joined(separator: "\n")
            
            //  self.addressLabel.text = lines.joined(separator: "\n")
            
            // 4
            UIView.animate(withDuration: 0.25)
            {
                self.view.layoutIfNeeded()
            }
            
            self.stopActivity()
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
