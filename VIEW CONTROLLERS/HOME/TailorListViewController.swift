//
//  TailorListViewController.swift
//  Mzyoon
//
//  Created by QOL on 23/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import GoogleMaps
import GooglePlaces


class TailorListViewController: CommonViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UITableViewDataSource, UITableViewDelegate, ServerAPIDelegate,UIGestureRecognizerDelegate
{
    
    let serviceCall = ServerAPI()
    
    var locationManager = CLLocationManager()
    
    let mapView = GMSMapView()
    let marker = GMSMarker()
    let addressLabel = UILabel()
    let tailorDeatiledView = UIView()
    let shopName = UILabel()
    let shopNameBtn = UIButton()
    let ratingImageView = UIImageView()
    let ratingCountLabel = UILabel()
    let reviewsButton = UIButton()
    let ordersCountLabel = UILabel()
    let distanceLabel = UILabel()
    
    
    var IdArray = NSArray()
    var TailorNameArray = NSArray()
    var EmailIdArray = NSArray()
    var GenderArray = NSArray()
    var ModifiedOnArray = NSArray()
    var LastViewedOnArray = NSArray()
    var ModifiedByArray = NSArray()
    var CreatedOnArray = NSArray()
    var DobArray = NSArray()
    var CountryCodeArray = NSArray()
    var PhoneNumberArray = NSArray()
    var AddressArray = NSArray()
    var latitudeArray = NSArray()
    var longitudeArray = NSArray()
    var ShopNameArray = NSArray()
    var ShopOwnerImageArray = NSArray()
    var ConvertedShopOwnerImageArray = [UIImage]()
    var orderCountArray = NSArray()
    var ratingArray = NSArray()
    
    let tailorListScrollView = UIScrollView()
    var currentLocation: CLLocation!
    
    var selectedTailorListArray = [Int]()
    var selectedTailorListNameArray = [String]()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    var destinationLocation = CLLocationCoordinate2D()
    var rectanglePolyline = GMSPolyline()
    
    //SCREEN CONTENTS PARAMETERS
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()
    let selfScreenContents = UIView()
    let listViewButton = UIButton()
    let mapViewButton = UIButton()
    
    let backDrop = UIView()
    let totalTailersCountLabel = UILabel()
    let totalTailersLabel = UILabel()
    let totalTailersSelectedCountLabel = UILabel()
    let totalSelectedTailersLabel = UILabel()
    let sortButton = UIButton()
    let confirmSelectionButton = UIButton()
    let tailorListTableView = UITableView()

    var applicationDelegate = AppDelegate()
    
    var TailorID:Int!
    
    var swipeGesture = UISwipeGestureRecognizer()
    
    override func viewDidLoad()
    {
        navigationBar.isHidden = true
      //  fetchingCurrentLocation()

         super.viewDidLoad()
        
        // Do any additional setup after loading the view.
  
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
         navigationBar.isHidden = true
         fetchingCurrentLocation()
        
    }
    
    func fetchingCurrentLocation()
    {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        currentLocation = locationManager.location
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        else
        {
            
        }
        
        #if targetEnvironment(simulator)
        // your simulator code
        print("APP IS RUNNING ON SIMULATOR")
        self.serviceCall.API_GetTailorList(delegate: self)

        #else
        // your real device code
        print("APP IS RUNNING ON DEVICE")
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways)
        {
            
            currentLocation = locationManager.location
            print("Current Loc:",currentLocation.coordinate)
            self.serviceCall.API_GetTailorList(delegate: self)
        }
        
        #endif
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("Tailor List : ", errorMessage)
        stopActivity()
        applicationDelegate.exitContents()
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        // ErrorStr = "Default Error"
        PageNumStr = "TailorListViewController"
        //  MethodName = "do"
        
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
    
    func API_CALLBACK_GetTailorList(TailorList: NSDictionary)
    {
        let ResponseMsg = TailorList.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = TailorList.object(forKey: "Result") as! NSArray
            print("Tailor List:", Result)
            
            IdArray = Result.value(forKey: "Id") as! NSArray
            print("IdArray", IdArray)
            
            TailorNameArray = Result.value(forKey: "TailorNameInEnglish") as! NSArray
            print("TailorNameArray", TailorNameArray)
            
            ShopNameArray = Result.value(forKey: "ShopNameInEnglish") as! NSArray
            print("ShopNameArray", ShopNameArray)
            
            orderCountArray = Result.value(forKey: "OrderCount") as! NSArray
            print("ORDER COUNT ARRAY", orderCountArray)
            
            ratingArray = Result.value(forKey: "Rating") as! NSArray
            print("RATING ARRAY", ratingArray)
            
            AddressArray = Result.value(forKey: "AddressInEnglish") as! NSArray
            print("AddressArray", AddressArray)
            
            latitudeArray = Result.value(forKey: "Latitude") as! NSArray
            print("latitudeArray", latitudeArray)
            
            longitudeArray = Result.value(forKey: "Longitude") as! NSArray
            print("longitudeArray", longitudeArray)
            
            EmailIdArray = Result.value(forKey: "EmailId") as! NSArray
            print("EmailIdArray", EmailIdArray)
            
            GenderArray = Result.value(forKey: "Gender") as! NSArray
            print("GenderArray", GenderArray)
            
            ModifiedOnArray = Result.value(forKey: "ModifiedOn") as! NSArray
            print("ModifiedOnArray", ModifiedOnArray)
            
            LastViewedOnArray = Result.value(forKey: "LastViewedOn") as! NSArray
            print("LastViewedOnArray", LastViewedOnArray)
            
            ModifiedByArray = Result.value(forKey: "ModifiedBy") as! NSArray
            print("ModifiedByArray", ModifiedByArray)
            
            CreatedOnArray = Result.value(forKey: "CreatedOn") as! NSArray
            print("CreatedOnArray", CreatedOnArray)
            
            DobArray = Result.value(forKey: "Dob") as! NSArray
            print("DobArray", DobArray)
            
            CountryCodeArray = Result.value(forKey: "CountryCode") as! NSArray
            print("CountryCodeArray", CountryCodeArray)
            
            PhoneNumberArray = Result.value(forKey: "PhoneNumber") as! NSArray
            print("PhoneNumberArray", PhoneNumberArray)
            
            ShopOwnerImageArray = Result.value(forKey:"ShopOwnerImageURL") as! NSArray
            print("ShopOwnerImageArray",ShopOwnerImageArray)
            
            
            /*for i in 0..<ShopOwnerImageArray.count
             {
             if let imageName = ShopOwnerImageArray[i] as? String
             {
             let urlString = serviceCall.baseURL
             let api = "\(urlString)/images/Measurement2/\(imageName)"
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
             self.ConvertedShopOwnerImageArray.append(image)
             }
             }
             else
             {
             let emptyImage = UIImage(named: "empty")
             self.ConvertedShopOwnerImageArray.append(emptyImage!)
             }
             }
             }
             else if ShopOwnerImageArray[i] is NSNull
             {
             let emptyImage = UIImage(named: "empty")
             self.ConvertedShopOwnerImageArray.append(emptyImage!)
             }
             }*/
            
            self.orderSummaryContent()
        }
        else if ResponseMsg == "Failure"
        {
            let Result = TailorList.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetTailorlist"
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func API_CALLBACK_DirectionRequest(direction: NSDictionary) {
        print("SELF OF DIRECTION REQUEST", direction)
    }
    
    func changeViewToArabicInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.text = "قائمة الخياطين"
        
        selfScreenContents.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        listViewButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        mapViewButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        listViewButton.setTitle("عرض القائمة", for: .normal)
        mapViewButton.setTitle("عرض الخريطة", for: .normal)
        
        totalTailersCountLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        totalTailersLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        totalTailersSelectedCountLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        totalSelectedTailersLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        sortButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        confirmSelectionButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        totalTailersLabel.text = "قائمة من الخياطين"
        totalTailersLabel.textAlignment = .right
        totalSelectedTailersLabel.text = "الخياطين المختارة"
        totalSelectedTailersLabel.textAlignment = .right
        
        sortButton.setTitle("فرز", for: .normal)
        confirmSelectionButton.setTitle("تأكيد التحديد", for: .normal)
    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.text = "TAILORS LIST"
        
        selfScreenContents.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        listViewButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        mapViewButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        listViewButton.setTitle("LIST VIEW", for: .normal)
        mapViewButton.setTitle("MAP VIEW", for: .normal)
        
        totalTailersCountLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        totalTailersLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        totalTailersSelectedCountLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        totalSelectedTailersLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        sortButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        confirmSelectionButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        totalTailersLabel.text = "LIST OF TAILORS"
        totalTailersLabel.textAlignment = .left
        totalSelectedTailersLabel.text = "SELECTED TAILORS"
        totalSelectedTailersLabel.textAlignment = .left
        
        sortButton.setTitle("SORT", for: .normal)
        confirmSelectionButton.setTitle("Confirm Selection", for: .normal)
    }
    
    func orderSummaryContent()
    {
        self.stopActivity()
    
        selfScreenNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        selfScreenNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(selfScreenNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 4
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        selfScreenNavigationBar.addSubview(backButton)
        
        selfScreenNavigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: selfScreenNavigationBar.frame.width, height: (3 * y))
        selfScreenNavigationTitle.text = "TAILORS LIST"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        selfScreenContents.frame = CGRect(x: 0, y: selfScreenNavigationBar.frame.maxY, width: view.frame.width, height: view.frame.height - ((5 * y) + selfScreenNavigationBar.frame.maxY))
        selfScreenContents.backgroundColor = UIColor.clear
        view.addSubview(selfScreenContents)
        
        listViewButton.frame = CGRect(x: 0, y: 0, width: ((view.frame.width / 2) - 1), height: 50)
        listViewButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        listViewButton.setTitle("LIST VIEW", for: .normal)
        listViewButton.setTitleColor(UIColor.white, for: .normal)
        listViewButton.tag = 0
        listViewButton.addTarget(self, action: #selector(self.selectionViewButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(listViewButton)
        
        mapViewButton.frame = CGRect(x: listViewButton.frame.maxX + 1, y: 0, width: view.frame.width / 2, height: 50)
        mapViewButton.backgroundColor = UIColor.lightGray
        mapViewButton.setTitle("MAP VIEW", for: .normal)
        mapViewButton.setTitleColor(UIColor.black, for: .normal)
        mapViewButton.tag = 1
        mapViewButton.addTarget(self, action: #selector(self.selectionViewButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(mapViewButton)
        
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
        
        mapViewButton.backgroundColor = UIColor.lightGray
        mapViewButton.setTitleColor(UIColor.black, for: .normal)
        listViewContents(isHidden: false)
        mapViewContents(isHidden: true)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func selectionViewButtonAction(sender : UIButton)
    {
        if sender.tag == 0
        {
            mapViewButton.backgroundColor = UIColor.lightGray
            mapViewButton.setTitleColor(UIColor.black, for: .normal)
            listViewContents(isHidden: false)
            mapViewContents(isHidden: true)
        }
        else if sender.tag == 1
        {
            listViewButton.backgroundColor = UIColor.lightGray
            listViewButton.setTitleColor(UIColor.black, for: .normal)
            listViewContents(isHidden: true)
            mapViewContents(isHidden: false)
        }
        
        sender.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        sender.setTitleColor(UIColor.white, for: .normal)
    }
    
    func listViewContents(isHidden : Bool)
    {
        backDrop.frame = CGRect(x: (3 * x), y: listViewButton.frame.maxY + y, width: view.frame.width - (6 * x), height: view.frame.height - (18 * y))
        backDrop.backgroundColor = UIColor.clear
        selfScreenContents.addSubview(backDrop)
        
        self.view.bringSubviewToFront(slideMenuButton)
        
        backDrop.isHidden = isHidden
        
        totalTailersCountLabel.frame = CGRect(x: 0, y: y, width: (3 * x), height: (3 * y))
        totalTailersCountLabel.layer.cornerRadius = totalTailersCountLabel.frame.height / 2
        totalTailersCountLabel.layer.borderWidth = 1
        totalTailersCountLabel.layer.borderColor = UIColor.lightGray.cgColor
        totalTailersCountLabel.layer.masksToBounds = true
        totalTailersCountLabel.backgroundColor = UIColor.white
        totalTailersCountLabel.text = "\(IdArray.count)"
        totalTailersCountLabel.textColor = UIColor.black
        totalTailersCountLabel.textAlignment = .center
        backDrop.addSubview(totalTailersCountLabel)
        
        totalTailersLabel.frame = CGRect(x: totalTailersCountLabel.frame.maxX + x, y: y, width: (10 * x), height: (3 * y))
        totalTailersLabel.text = "LIST OF TAILORS"
        totalTailersLabel.textColor = UIColor.black
        totalTailersLabel.textAlignment = .left
        totalTailersLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        totalTailersLabel.font = totalTailersLabel.font.withSize(12)
        backDrop.addSubview(totalTailersLabel)
        
        totalTailersSelectedCountLabel.frame = CGRect(x: totalTailersLabel.frame.maxX + x, y: y, width: (3 * x), height: (3 * y))
        totalTailersSelectedCountLabel.layer.cornerRadius = totalTailersCountLabel.frame.height / 2
        totalTailersSelectedCountLabel.layer.borderWidth = 1
        totalTailersSelectedCountLabel.layer.borderColor = UIColor.lightGray.cgColor
        totalTailersSelectedCountLabel.layer.masksToBounds = true
        totalTailersSelectedCountLabel.backgroundColor = UIColor.white
        totalTailersSelectedCountLabel.text = "0"
        totalTailersSelectedCountLabel.textColor = UIColor.black
        totalTailersSelectedCountLabel.textAlignment = .center
        backDrop.addSubview(totalTailersSelectedCountLabel)
        
        totalSelectedTailersLabel.frame = CGRect(x: totalTailersSelectedCountLabel.frame.maxX + x, y: y, width: (15 * x), height: (3 * y))
        totalSelectedTailersLabel.text = "SELECTED TAILORS"
        totalSelectedTailersLabel.textColor = UIColor.black
        totalSelectedTailersLabel.textAlignment = .left
        totalSelectedTailersLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        totalSelectedTailersLabel.font = totalTailersLabel.font.withSize(12)
        backDrop.addSubview(totalSelectedTailersLabel)
        
        sortButton.frame = CGRect(x: backDrop.frame.width - (10 * x), y: totalTailersSelectedCountLabel.frame.maxY, width: (10 * x), height: (3 * y))
        sortButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        sortButton.setTitle("SORT", for: .normal)
        sortButton.setTitleColor(UIColor.white, for: .normal)
        sortButton.tag = 0
        //        sortButton.addTarget(self, action: #selector(self.selectionViewButtonAction(sender:)), for: .touchUpInside)
        backDrop.addSubview(sortButton)
        
        tailorListTableView.frame = CGRect(x: 0, y: sortButton.frame.maxY, width: backDrop.frame.width, height: (30 * y))
        tailorListTableView.backgroundColor = UIColor.black
        tailorListTableView.register(TailorListTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(TailorListTableViewCell.self))
        tailorListTableView.dataSource = self
        tailorListTableView.delegate = self
        //        backDrop.addSubview(tailorListTableView)
        
        tailorListTableView.reloadData()
        
        tailorListScrollView.frame = CGRect(x: 0, y: sortButton.frame.maxY + y, width: backDrop.frame.width, height: (35 * y))
        backDrop.addSubview(tailorListScrollView)
        
        tailorListScrollView.contentSize.height = (12 * y * CGFloat(IdArray.count))
        
        for views in tailorListScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        var y1:CGFloat = 0
        
        for i in 0..<IdArray.count
        {
            let tailorView = UIView()
            tailorView.frame = CGRect(x: 0, y: y1, width: tailorListScrollView.frame.width, height: (10 * y))
            tailorView.backgroundColor = UIColor.white
            tailorListScrollView.addSubview(tailorView)
            
            let tailorImageButton = UIButton()
            tailorImageButton.frame = CGRect(x: x, y: y, width: (8 * x), height: (8 * y))
            tailorImageButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            //            tailorImageButton.setImage(UIImage(named: "men"), for: .normal)
            
            if let imageName = ShopOwnerImageArray[i] as? String
            {
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/Tailorimages/\(imageName)"
                print("SMALL ICON", api)
                let apiurl = URL(string: api)
                
                let dummyImageView = UIImageView()
                dummyImageView.frame = CGRect(x: 0, y: 0, width: tailorImageButton.frame.width, height: tailorImageButton.frame.height)
                if apiurl != nil
                {
                    dummyImageView.dowloadFromServer(url: apiurl!)
                }
                dummyImageView.tag = -1
                dummyImageView.contentMode = .scaleToFill
                tailorImageButton.addSubview(dummyImageView)
            }
            
            tailorImageButton.tag = IdArray[i] as! Int
            tailorImageButton.addTarget(self, action: #selector(self.tailorSelectionButtonAction(sender:)), for: .touchUpInside)
            tailorView.addSubview(tailorImageButton)
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: tailorImageButton.frame.maxX + x, y: 0, width: (5 * x), height: (2 * y))
            nameLabel.text = "Name : "
            nameLabel.textColor = UIColor.blue
            nameLabel.textAlignment = .left
            nameLabel.font = nameLabel.font.withSize(1.2 * x)
            tailorView.addSubview(nameLabel)
            
            let tailorName = UILabel()
            tailorName.frame = CGRect(x: nameLabel.frame.maxX, y: 0, width: tailorView.frame.width / 2, height: (2 * y))
            tailorName.text = TailorNameArray[i] as? String
            tailorName.textColor = UIColor.black
            tailorName.textAlignment = .left
            tailorName.font = tailorName.font.withSize(1.2 * x)
            tailorView.addSubview(tailorName)
            
            let shopLabel = UILabel()
            shopLabel.frame = CGRect(x: tailorImageButton.frame.maxX + x, y: nameLabel.frame.maxY, width: (8 * x), height: (2 * y))
            shopLabel.text = "Shop Name : "
            shopLabel.textColor = UIColor.blue
            shopLabel.textAlignment = .left
            shopLabel.font = nameLabel.font.withSize(1.2 * x)
            tailorView.addSubview(shopLabel)
            
            let shopName = UILabel()
            shopName.frame = CGRect(x: shopLabel.frame.maxX, y: nameLabel.frame.maxY, width: tailorView.frame.width / 2.5, height: (2 * y))
            shopName.text = (ShopNameArray[i] as? String)?.uppercased()
            shopName.textColor = UIColor.black
            shopName.textAlignment = .left
            shopName.font = tailorName.font.withSize(1.2 * x)
            shopName.adjustsFontSizeToFitWidth = true
            tailorView.addSubview(shopName)
            
            shopName.attributedText = NSAttributedString(string: ((ShopNameArray[i] as? String)?.uppercased())!, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
            
            let ordersLabel = UILabel()
            ordersLabel.frame = CGRect(x: tailorImageButton.frame.maxX + x, y: shopLabel.frame.maxY, width: (9 * x), height: (2 * y))
            ordersLabel.text = "No. of Orders : "
            ordersLabel.textColor = UIColor.blue
            ordersLabel.textAlignment = .left
            ordersLabel.font = ordersLabel.font.withSize(1.2 * x)
            tailorView.addSubview(ordersLabel)
            
            let ordersCountLabel = UILabel()
            ordersCountLabel.frame = CGRect(x: ordersLabel.frame.maxX, y: shopLabel.frame.maxY, width: tailorView.frame.width / 2.5, height: (2 * y))
            ordersCountLabel.text = "\(orderCountArray[i])"
            ordersCountLabel.textColor = UIColor.black
            ordersCountLabel.textAlignment = .left
            ordersCountLabel.font = ordersCountLabel.font.withSize(1.2 * x)
            ordersCountLabel.adjustsFontSizeToFitWidth = true
            tailorView.addSubview(ordersCountLabel)
            
            let ratingLabel = UILabel()
            ratingLabel.frame = CGRect(x: tailorImageButton.frame.maxX + x, y: ordersLabel.frame.maxY, width: (8 * x), height: (2 * y))
            ratingLabel.text = "Rating : "
            ratingLabel.textColor = UIColor.blue
            ratingLabel.textAlignment = .left
            ratingLabel.font = ratingLabel.font.withSize(1.2 * x)
            tailorView.addSubview(ratingLabel)
            
            let ratingCountLabel = UILabel()
            ratingCountLabel.frame = CGRect(x: ratingLabel.frame.maxX, y: ordersLabel.frame.maxY, width: tailorView.frame.width / 2.5, height: (2 * y))
            ratingCountLabel.text = "\(ratingArray[i])"
            ratingCountLabel.textColor = UIColor.black
            ratingCountLabel.textAlignment = .left
            ratingCountLabel.font = ordersCountLabel.font.withSize(1.2 * x)
            ratingCountLabel.adjustsFontSizeToFitWidth = true
            //  tailorView.addSubview(ratingCountLabel)
            
            
            let ratingImageView = UIImageView()
            ratingImageView.frame = CGRect(x: ratingLabel.frame.maxX, y: ordersLabel.frame.maxY + (y / 2), width: (5 * x), height: y)
            ratingImageView.image = UIImage(named: "\(ratingArray[i])")
            tailorView.addSubview(ratingImageView)
            
            let coordinate1 = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            let coordinate2 = CLLocation(latitude: latitudeArray[i] as! CLLocationDegrees, longitude: longitudeArray[i] as! CLLocationDegrees)
            
            let distanceInMeters = coordinate1.distance(from: coordinate2)
            
            let distanceInKiloMeters = distanceInMeters / 1000
            
            let distanceInt = Int(distanceInKiloMeters)
            
            let distanceLabel = UILabel()
            distanceLabel.frame = CGRect(x: tailorImageButton.frame.maxX + x, y: ratingLabel.frame.maxY, width: tailorView.frame.width / 2.15, height: (2 * y))
            distanceLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            distanceLabel.text = "\(distanceInt) Km. from your location"
            distanceLabel.textColor = UIColor.white
            distanceLabel.textAlignment = .center
            distanceLabel.font = ordersCountLabel.font.withSize(1.2 * x)
            distanceLabel.adjustsFontSizeToFitWidth = true
            tailorView.addSubview(distanceLabel)
            
            let locationButton = UIButton()
            locationButton.frame = CGRect(x: tailorView.frame.width - (5 * x), y: tailorView.frame.height - (5 * y), width: (5 * x), height: (5 * y))
            //            locationButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            locationButton.layer.borderWidth = 1
            locationButton.layer.borderColor = UIColor.lightGray.cgColor
            locationButton.setImage(UIImage(named: "locationMarker"), for: .normal)
            locationButton.tag = IdArray[i] as! Int
//            locationButton.addTarget(self, action: #selector(self.directionButtonAction(sender:)), for: .touchUpInside)
            tailorView.addSubview(locationButton)
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    tailorImageButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    nameLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    shopLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    ordersLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    ratingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    distanceLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    
                    distanceLabel.text = "\(distanceInt) Km. from your location"
                }
                else if language == "ar"
                {
                    tailorImageButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    nameLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    shopLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    ordersLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    ratingLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    distanceLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    
                    distanceLabel.text = "كم. من موقع  \(distanceInt)"
                }
            }
            else
            {
                tailorImageButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                nameLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                shopLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                ordersLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                ratingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                distanceLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                distanceLabel.text = "\(distanceInt) Km. from your location"
            }
            
            y1 = tailorView.frame.maxY + y
        }
        
        confirmSelectionButton.frame = CGRect(x: ((backDrop.frame.width - (17 * x)) / 2), y: tailorListScrollView.frame.maxY + (2 * y), width: (17 * x), height: (3 * y))
        confirmSelectionButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        confirmSelectionButton.setTitle("Confirm Selection", for: .normal)
        confirmSelectionButton.addTarget(self, action: #selector(self.confirmSelectionButtonAction(sender:)), for: .touchUpInside)
        backDrop.addSubview(confirmSelectionButton)
        
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
    
    @objc func directionButtonAction(sender : UIButton)
    {
        listViewContents(isHidden: true)
        mapViewContents(isHidden: true)
        
        for i in 0..<IdArray.count
        {
            if let id = IdArray[i] as? Int
            {
                if sender.tag == id
                {
                    destinationLocation = CLLocationCoordinate2D(latitude: latitudeArray[i] as! CLLocationDegrees, longitude: longitudeArray[i] as! CLLocationDegrees)
                    directionViewContents(isHidden: false)
                }
            }
        }
        
        //  serviceCall.API_DirectionRequest(origin: "\(currentLocation.coordinate.latitude)", destination: "\(currentLocation.coordinate.longitude)", delegate: self)
    }
    
    func directionViewContents(isHidden : Bool)
    {
        mapView.clear()
        mapView.frame = CGRect(x: 0, y: listViewButton.frame.maxY, width: view.frame.width, height: view.frame.height - (10.4 * y))
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        view.addSubview(mapView)
        
        mapView.isHidden = isHidden
        
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 17.0)
        self.mapView.animate(to: camera)
        
        if isHidden != true
        {
            let marker = GMSMarker()
            marker.position = destinationLocation
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.75)
            marker.tracksInfoWindowChanges = true
            marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
            marker.map = mapView
            
            drawPath(start: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude), end: destinationLocation)
        }
    }
    
    @objc func tailorSelectionButtonAction(sender : UIButton)
    {
        let selectionImage = UIImageView()
        selectionImage.frame = CGRect(x: x, y: y, width: (2 * x), height: (2 * y))
        selectionImage.image = UIImage(named: "selectionImage")
        selectionImage.tag = sender.tag
        
        if selectedTailorListArray.isEmpty == true
        {
            selectedTailorListArray.append(sender.tag)
            sender.addSubview(selectionImage)
        }
        else
        {
            if selectedTailorListArray.contains(sender.tag)
            {
                if let index = selectedTailorListArray.index(where: {$0 == sender.tag}) {
                    selectedTailorListArray.remove(at: index)
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
                selectedTailorListArray.append(sender.tag)
                sender.addSubview(selectionImage)
            }
        }
        
        print("TAILOR LIST ARRAY", selectedTailorListArray)
        
        totalTailersSelectedCountLabel.text = "\(selectedTailorListArray.count)"
    }
    
    @objc func confirmSelectionButtonAction(sender : UIButton)
    {
        if selectedTailorListArray.count == 0
        {
            let alert = UIAlertController(title: "Alert", message: "Please select atleast any one tailor to proceed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            selectedTailorListNameArray.removeAll()
            
            for i in 0..<IdArray.count
            {
                if let id1 = IdArray[i] as? Int
                {
                    for j in 0..<selectedTailorListArray.count
                    {
                        if let id2 = selectedTailorListArray[j] as? Int
                        {
                            if id1 == id2
                            {
                                selectedTailorListNameArray.append(TailorNameArray[i] as! String)
                            }
                        }
                    }
                }
            }
            
            print("SELECTED TAILOR LIST", selectedTailorListNameArray)
            print("SELECTED TAILOR NAME", selectedTailorListArray)
            
            /*for i in 0..<selectedTailorListArray.count
            {
                selectedTailorListNameArray.append(TailorNameArray[selectedTailorListArray[i]] as! String)
            }*/
            
            UserDefaults.standard.set(selectedTailorListNameArray, forKey: "selectedTailors")
            UserDefaults.standard.set(selectedTailorListArray, forKey: "selectedTailorsId")
            let orderSummaryScreen = OrderSummaryViewController()
            self.navigationController?.pushViewController(orderSummaryScreen, animated: true)
        }
    }
    
    func mapViewContents(isHidden : Bool)
    {
        mapView.clear()
        mapView.frame = CGRect(x: 0, y: listViewButton.frame.maxY, width: view.frame.width, height: view.frame.height - (10.4 * y))
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        view.addSubview(mapView)
        
        self.view.bringSubviewToFront(slideMenuButton)
        
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 17.0)
        self.mapView.animate(to: camera)
        
        mapView.isHidden = isHidden
        
        print("WELCOME OF", mapView.myLocation?.coordinate.latitude, mapView.myLocation?.coordinate.longitude)
        
        for i in 0..<latitudeArray.count
        {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: latitudeArray[i] as! CLLocationDegrees, longitude: longitudeArray[i] as! CLLocationDegrees)
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.75)
            marker.title = ShopNameArray[i] as? String
            marker.snippet = TailorNameArray[i] as? String
            marker.tracksInfoWindowChanges = true
            marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
            marker.map = mapView
        }
        
        /*let markerImageView = UIImageView()
        markerImageView.frame = CGRect(x: 0, y: 0, width: (6 * x), height: (5 * y))
        markerImageView.image = UIImage(named: "marker")
        
        if mapView.isHidden  == false
        {
            mapView.addSubview(markerImageView)
            
            marker.position = CLLocationCoordinate2D(latitude: (mapView.myLocation?.coordinate.latitude)!, longitude: (mapView.myLocation?.coordinate.longitude)!)
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.75)
            marker.iconView = markerImageView
            marker.map = mapView
        }
        else
        {
            // marker.position = CLLocationCoordinate2D(latitude: (mapView.myLocation?.coordinate.latitude)!, longitude: (mapView.myLocation?.coordinate.longitude)!)
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.75)
            marker.iconView = markerImageView
            marker.map = mapView
        }*/
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        
        self.mapView.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)
    {
        tailorDeatiledView.removeFromSuperview()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool
    {
        //        let camera = GMSCameraPosition(target: marker.position, zoom: mapView.camera.zoom, bearing: 0.0, viewingAngle: 0.0)
        //
        //        mapView.camera = camera
        addressOfMarker(marker: marker)
        
        return true
    }
    
    func addressOfMarker(marker : GMSMarker)
    {
        tailorDeatiledView.frame = CGRect(x: 0, y: mapView.frame.height - (17 * y), width: mapView.frame.width, height: (17 * y))
        tailorDeatiledView.backgroundColor = UIColor.white
        mapView.addSubview(tailorDeatiledView)
        
        for views in tailorDeatiledView.subviews
        {
            views.removeFromSuperview()
        }
      
       /*
        shopName.frame = CGRect(x: x, y: 0, width: tailorDeatiledView.frame.width / 2.5, height: (3 * y))
        shopName.text = marker.title?.uppercased()
        shopName.textColor = UIColor.blue
        shopName.textAlignment = .left
        shopName.font = shopName.font.withSize(1.5 * x)
        shopName.adjustsFontSizeToFitWidth = true
        tailorDeatiledView.addSubview(shopName)
       */
        
        shopNameBtn.frame = CGRect(x: x, y: 0, width: tailorDeatiledView.frame.width / 2.5, height: (3 * y))
        shopNameBtn.setTitle(marker.title?.uppercased(), for: .normal)
        shopNameBtn.setTitleColor(UIColor.blue, for: .normal)
        shopNameBtn.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.5 * x)!
        shopNameBtn.addTarget(self, action: #selector(self.ShopButtonAction(sender:)), for: .touchUpInside)
        tailorDeatiledView.addSubview(shopNameBtn)
        
        print("SHOP NAME", shopNameBtn.currentTitle!)
       // shopName.attributedText = NSAttributedString(string: shopNameBtn.currentTitle!, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        
        let ratingLabel = UILabel()
        ratingLabel.frame = CGRect(x: x, y: shopNameBtn.frame.maxY + (y / 2), width: (5 * x), height: (2 * y))
        ratingLabel.text = "Rating : "
        ratingLabel.textColor = UIColor.blue
        ratingLabel.textAlignment = .left
        ratingLabel.font = ratingLabel.font.withSize(1.2 * x)
        tailorDeatiledView.addSubview(ratingLabel)
        
        ratingImageView.frame = CGRect(x: ratingLabel.frame.maxX, y: shopNameBtn.frame.maxY + (y / 2), width: tailorDeatiledView.frame.width / 4, height: (1.5 * y))
        tailorDeatiledView.addSubview(ratingImageView)
        
        
       // let ReviewsButton = UIButton()
        reviewsButton.frame = CGRect(x: ratingImageView.frame.maxX, y: shopNameBtn.frame.maxY + (y / 2), width: (7 * x), height: (2 * y))
       // reviewsButton.backgroundColor = UIColor.lightGray
        reviewsButton.setTitleColor(UIColor.blue, for: .normal)
        reviewsButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.2 * x)!
        reviewsButton.addTarget(self, action: #selector(self.ReviewsButtonAction(sender:)), for: .touchUpInside)
        tailorDeatiledView.addSubview(reviewsButton)
        
        ratingCountLabel.frame = CGRect(x: ratingImageView.frame.maxX, y: shopNameBtn.frame.maxY + (y / 2), width: tailorDeatiledView.frame.width / 2.5, height: (2 * y))
        ratingCountLabel.textColor = UIColor.black
        ratingCountLabel.textAlignment = .left
        ratingCountLabel.font = ratingLabel.font.withSize(1.2 * x)
        ratingCountLabel.adjustsFontSizeToFitWidth = true
       // tailorDeatiledView.addSubview(ratingCountLabel)
        
        
        let nameLabel = UILabel()
        nameLabel.frame = CGRect(x: x, y: ratingLabel.frame.maxY, width: (5 * x), height: (2 * y))
        nameLabel.text = "Name : "
        nameLabel.textColor = UIColor.blue
        nameLabel.textAlignment = .left
        nameLabel.font = nameLabel.font.withSize(1.2 * x)
        tailorDeatiledView.addSubview(nameLabel)
        
        let tailorName = UILabel()
        tailorName.frame = CGRect(x: nameLabel.frame.maxX, y: ratingLabel.frame.maxY, width: tailorDeatiledView.frame.width / 2, height: (2 * y))
        tailorName.text = marker.snippet
        tailorName.textColor = UIColor.black
        tailorName.textAlignment = .left
        tailorName.font = tailorName.font.withSize(1.2 * x)
        tailorDeatiledView.addSubview(tailorName)
        
        let ordersLabel = UILabel()
        ordersLabel.frame = CGRect(x: x, y: nameLabel.frame.maxY, width: (9 * x), height: (2 * y))
        ordersLabel.text = "No. of Orders : "
        ordersLabel.textColor = UIColor.blue
        ordersLabel.textAlignment = .left
        ordersLabel.font = ordersLabel.font.withSize(1.2 * x)
        tailorDeatiledView.addSubview(ordersLabel)
        
        ordersCountLabel.frame = CGRect(x: ordersLabel.frame.maxX, y: nameLabel.frame.maxY, width: tailorDeatiledView.frame.width / 2.5, height: (2 * y))
        ordersCountLabel.textColor = UIColor.black
        ordersCountLabel.textAlignment = .left
        ordersCountLabel.font = ordersCountLabel.font.withSize(1.2 * x)
        ordersCountLabel.adjustsFontSizeToFitWidth = true
        tailorDeatiledView.addSubview(ordersCountLabel)
        
        let coordinate1 = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let coordinate2 = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
        
        let distanceInMeters = coordinate1.distance(from: coordinate2)
        
        let distanceInKiloMeters = distanceInMeters / 1000
        
        let distanceInt = Int(distanceInKiloMeters)
        
        print("DISTANCE IN KM", distanceInt)
        
        distanceLabel.frame = CGRect(x: x, y: ordersLabel.frame.maxY, width: tailorDeatiledView.frame.width - (2 * x), height: (2 * y))
        //        distanceLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        distanceLabel.text = "\(distanceInt) Km. from your location"
        distanceLabel.textColor = UIColor.black
        distanceLabel.textAlignment = .left
        distanceLabel.font = distanceLabel.font.withSize(1.2 * x)
        distanceLabel.adjustsFontSizeToFitWidth = true
        tailorDeatiledView.addSubview(distanceLabel)
        
        let locationButton = UIButton()
        locationButton.frame = CGRect(x: tailorDeatiledView.frame.width / 2, y: distanceLabel.frame.maxY, width: (17.25 * x), height: (4 * y))
        locationButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        locationButton.layer.borderWidth = 1
        locationButton.layer.borderColor = UIColor.lightGray.cgColor
        locationButton.setTitle("DIRECTIONS", for: .normal)
        locationButton.setTitleColor(UIColor.white, for: .normal)
        locationButton.tag = 0
//        locationButton.addTarget(self, action: #selector(self.directionButtonAction(sender:)), for: .touchUpInside)
        tailorDeatiledView.addSubview(locationButton)
      
        /*
        addressLabel.frame = CGRect(x: (2 * x), y: ((view.frame.height - (5 * y)) / 2), width: view.frame.width - (4 * x), height: (3 * y))
        addressLabel.backgroundColor = UIColor.white
        addressLabel.text = "\(marker.title!) \(marker.snippet!)"
        addressLabel.textColor = UIColor.black
        addressLabel.textAlignment = .left
        addressLabel.numberOfLines = 2
        mapView.addSubview(addressLabel)
       */
        
        for i in 0..<ShopNameArray.count
        {
            if let name = ShopNameArray[i] as? String
            {
                if name == marker.title
                {
                    ratingImageView.image = UIImage(named: "\(ratingArray[i])")
                    
                   // ratingCountLabel.text = "(\(ratingArray[i]) reviews)"
                     reviewsButton.setTitle("(\(ratingArray[i]) reviews)", for: .normal)
                     ordersCountLabel.text = "\(orderCountArray[i])"
                    
                      TailorID = IdArray[i] as? Int
             
                }
            }
        }
        
//        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.closeAddressLabel), userInfo: nil, repeats: false)
        
        
    }
    
    
    @objc func ShopButtonAction(sender : UIButton)
    {
        let ShopDetailsScreen = ShopDetailsViewController()
        ShopDetailsScreen.TailorID = TailorID!
        self.navigationController?.pushViewController(ShopDetailsScreen, animated: true)
    }
    
    @objc func ReviewsButtonAction(sender : UIButton)
    {
        let ReviewsScreen = ReviewsViewController()
        ReviewsScreen.TailorID = TailorID!
        self.navigationController?.pushViewController(ReviewsScreen, animated: true)
    }
    
   
    
    @objc func closeAddressLabel()
    {
        //  addressLabel.removeFromSuperview()
        tailorDeatiledView.removeFromSuperview()
    }
    
    func markerView(yPos : CGFloat)
    {
        let addressView = UIView()
        addressView.frame = CGRect(x: x, y: yPos, width: mapView.frame.width - (2 * x), height: (10 * y))
        addressView.backgroundColor = UIColor.white
        mapView.addSubview(addressView)
        
        let address1 = UILabel()
        address1.frame = CGRect(x: x, y: y, width: addressView.frame.width - (2 * x), height: (2 * y))
        address1.text = "NEW ADDRESS"
        addressView.addSubview(address1)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TailorListTableViewCell.self), for: indexPath as IndexPath) as! TailorListTableViewCell
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 100
    //    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func drawPath(start : CLLocationCoordinate2D, end : CLLocationCoordinate2D)
    {
        let rectanglePath = GMSMutablePath()
        
        if (start.latitude != 0.0 || end.latitude != 0.0){
            rectanglePath.add(start)
            rectanglePath.add(end)
            
            /* show what you have drawn */
            rectanglePolyline = GMSPolyline(path: rectanglePath)
            rectanglePolyline.strokeColor = UIColor.blue
            rectanglePolyline.strokeWidth = CGFloat(2)
            rectanglePolyline.map = mapView
            print("rectanglePath start ==>",start,end)
        }
        else
        {
            print("rectanglePath ENDS ==>",start,end)
        }
    }
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D)
    {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }else{
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                        
                        let routes = json["routes"] as? [Any]
                        print("ROUTES", routes, json["routes"])
                        let overview_polyline = routes?[0] as?[String:Any]
                        let polyString = overview_polyline?["points"] as?String
                        
                        //Call this method to draw path on map
                        self.showPath(polyStr: polyString!)
                    }
                    
                }catch{
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }
    
    func showPath(polyStr :String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = mapView // Your map view
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
