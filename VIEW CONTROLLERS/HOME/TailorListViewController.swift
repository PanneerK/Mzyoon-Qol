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


class TailorListViewController: CommonViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UITableViewDataSource, UITableViewDelegate, ServerAPIDelegate
{

    let serviceCall = ServerAPI()

    let listViewButton = UIButton()
    let mapViewButton = UIButton()
    
    let tailorListTableView = UITableView()
    
    var locationManager = CLLocationManager()
    
    let mapView = GMSMapView()
    let marker = GMSMarker()
    
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
    
    let totalTailersSelectedCountLabel = UILabel()
    
    let tailorListScrollView = UIScrollView()
    var currentLocation: CLLocation!
    
    var selectedTailorListArray = [Int]()
    
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
        
        self.serviceCall.API_GetTailorList(delegate: self)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("Tailor List : ", errorMessage)
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
            
            AddressArray = Result.value(forKey: "AddressInEnglish") as! NSArray
            print("AddressArray", AddressArray)
            
            ShopNameArray = Result.value(forKey: "ShopNameInEnglish") as! NSArray
            print("ShopNameArray", ShopNameArray)
            
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
    
    
    func orderSummaryContent()
    {
        self.stopActivity()
        
        let tailorListNavigationBar = UIView()
        tailorListNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        tailorListNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(tailorListNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 4
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        tailorListNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: tailorListNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "TAILOR LIST"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        tailorListNavigationBar.addSubview(navigationTitle)
        
        listViewButton.frame = CGRect(x: 0, y: tailorListNavigationBar.frame.maxY, width: ((view.frame.width / 2) - 1), height: 50)
        listViewButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        listViewButton.setTitle("LIST VIEW", for: .normal)
        listViewButton.setTitleColor(UIColor.white, for: .normal)
        listViewButton.tag = 0
        listViewButton.addTarget(self, action: #selector(self.selectionViewButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(listViewButton)
        
        mapViewButton.frame = CGRect(x: listViewButton.frame.maxX + 1, y: tailorListNavigationBar.frame.maxY, width: view.frame.width / 2, height: 50)
        mapViewButton.backgroundColor = UIColor.lightGray
        mapViewButton.setTitle("MAP VIEW", for: .normal)
        mapViewButton.setTitleColor(UIColor.black, for: .normal)
        mapViewButton.tag = 1
        mapViewButton.addTarget(self, action: #selector(self.selectionViewButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(mapViewButton)
        
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
        let backDrop = UIView()
        backDrop.frame = CGRect(x: (3 * x), y: listViewButton.frame.maxY + y, width: view.frame.width - (6 * x), height: view.frame.height - (18 * y))
        backDrop.backgroundColor = UIColor.clear
        view.addSubview(backDrop)
        
        backDrop.isHidden = isHidden
        
        let totalTailersCountLabel = UILabel()
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
        
        let totalTailersLabel = UILabel()
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
        
        let totalSelectedTailersLabel = UILabel()
        totalSelectedTailersLabel.frame = CGRect(x: totalTailersSelectedCountLabel.frame.maxX + x, y: y, width: (15 * x), height: (3 * y))
        totalSelectedTailersLabel.text = "SELECTED TAILORS"
        totalSelectedTailersLabel.textColor = UIColor.black
        totalSelectedTailersLabel.textAlignment = .left
        totalSelectedTailersLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        totalSelectedTailersLabel.font = totalTailersLabel.font.withSize(12)
        backDrop.addSubview(totalSelectedTailersLabel)
        
        let sortButton = UIButton()
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
                let api = "http://appsapi.mzyoon.com/images/Tailorimages/\(imageName)"
                print("SMALL ICON", api)
                let apiurl = URL(string: api)
                
                let dummyImageView = UIImageView()
                dummyImageView.frame = CGRect(x: 0, y: 0, width: tailorImageButton.frame.width, height: tailorImageButton.frame.height)
                dummyImageView.dowloadFromServer(url: apiurl!)
                dummyImageView.tag = -1
                tailorImageButton.addSubview(dummyImageView)
            }
            
            tailorImageButton.tag = i
            tailorImageButton.addTarget(self, action: #selector(self.tailorSelectionButtonAction(sender:)), for: .touchUpInside)
            tailorView.addSubview(tailorImageButton)
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: tailorImageButton.frame.maxX + x, y: 0, width: (5 * x), height: (2 * y))
            nameLabel.text = "Name : "
            nameLabel.textColor = UIColor.blue
            nameLabel.textAlignment = .left
            nameLabel.font = nameLabel.font.withSize(14)
            tailorView.addSubview(nameLabel)
            
            let tailorName = UILabel()
            tailorName.frame = CGRect(x: nameLabel.frame.maxX, y: 0, width: tailorView.frame.width / 2, height: (2 * y))
            tailorName.text = TailorNameArray[i] as? String
            tailorName.textColor = UIColor.black
            tailorName.textAlignment = .left
            tailorName.font = tailorName.font.withSize(14)
            tailorView.addSubview(tailorName)
            
            let shopLabel = UILabel()
            shopLabel.frame = CGRect(x: tailorImageButton.frame.maxX + x, y: nameLabel.frame.maxY, width: (8 * x), height: (2 * y))
            shopLabel.text = "Shop Name : "
            shopLabel.textColor = UIColor.blue
            shopLabel.textAlignment = .left
            shopLabel.font = nameLabel.font.withSize(14)
            tailorView.addSubview(shopLabel)
            
            let shopName = UILabel()
            shopName.frame = CGRect(x: shopLabel.frame.maxX, y: nameLabel.frame.maxY, width: tailorView.frame.width / 2.5, height: (2 * y))
            shopName.text = ShopNameArray[i] as? String
            shopName.textColor = UIColor.black
            shopName.textAlignment = .left
            shopName.font = tailorName.font.withSize(14)
            shopName.adjustsFontSizeToFitWidth = true
            tailorView.addSubview(shopName)
            
            let ordersLabel = UILabel()
            ordersLabel.frame = CGRect(x: tailorImageButton.frame.maxX + x, y: shopLabel.frame.maxY, width: (9 * x), height: (2 * y))
            ordersLabel.text = "No. of Orders : "
            ordersLabel.textColor = UIColor.blue
            ordersLabel.textAlignment = .left
            ordersLabel.font = ordersLabel.font.withSize(14)
            tailorView.addSubview(ordersLabel)
            
            let ordersCountLabel = UILabel()
            ordersCountLabel.frame = CGRect(x: ordersLabel.frame.maxX, y: shopLabel.frame.maxY, width: tailorView.frame.width / 2.5, height: (2 * y))
            ordersCountLabel.text = "\(IdArray[i])"
            ordersCountLabel.textColor = UIColor.black
            ordersCountLabel.textAlignment = .left
            ordersCountLabel.font = ordersCountLabel.font.withSize(14)
            ordersCountLabel.adjustsFontSizeToFitWidth = true
            tailorView.addSubview(ordersCountLabel)
            
            let ratingLabel = UILabel()
            ratingLabel.frame = CGRect(x: tailorImageButton.frame.maxX + x, y: ordersLabel.frame.maxY, width: (5 * x), height: (2 * y))
            ratingLabel.text = "Rating : "
            ratingLabel.textColor = UIColor.blue
            ratingLabel.textAlignment = .left
            ratingLabel.font = ratingLabel.font.withSize(14)
            tailorView.addSubview(ratingLabel)
            
            let ratingCountLabel = UILabel()
            ratingCountLabel.frame = CGRect(x: ratingLabel.frame.maxX, y: ordersLabel.frame.maxY, width: tailorView.frame.width / 2.5, height: (2 * y))
            ratingCountLabel.text = "\(IdArray[i])"
            ratingCountLabel.textColor = UIColor.black
            ratingCountLabel.textAlignment = .left
            ratingCountLabel.font = ordersCountLabel.font.withSize(14)
            ratingCountLabel.adjustsFontSizeToFitWidth = true
            tailorView.addSubview(ratingCountLabel)
            
            let distanceLabel = UILabel()
            distanceLabel.frame = CGRect(x: tailorImageButton.frame.maxX + x, y: ratingLabel.frame.maxY, width: tailorView.frame.width / 2.15, height: (2 * y))
            distanceLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            distanceLabel.text = "\(i) Km. from your location"
            distanceLabel.textColor = UIColor.white
            distanceLabel.textAlignment = .center
            distanceLabel.font = ordersCountLabel.font.withSize(14)
            distanceLabel.adjustsFontSizeToFitWidth = true
            tailorView.addSubview(distanceLabel)
            
            let locationButton = UIButton()
            locationButton.frame = CGRect(x: tailorView.frame.width - (5 * x), y: tailorView.frame.height - (5 * y), width: (5 * x), height: (5 * y))
//            locationButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            locationButton.layer.borderWidth = 1
            locationButton.layer.borderColor = UIColor.lightGray.cgColor
            locationButton.setImage(UIImage(named: "locationMarker"), for: .normal)
            locationButton.tag = i
//            locationButton.addTarget(self, action: #selector(self.selectionViewButtonAction(sender:)), for: .touchUpInside)
            tailorView.addSubview(locationButton)
            
            y1 = tailorView.frame.maxY + y
        }
        
        let confirmSelectionButton = UIButton()
        confirmSelectionButton.frame = CGRect(x: ((backDrop.frame.width - (17 * x)) / 2), y: tailorListScrollView.frame.maxY + (2 * y), width: (17 * x), height: (3 * y))
        confirmSelectionButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        confirmSelectionButton.setTitle("Confirm Selection", for: .normal)
        confirmSelectionButton.addTarget(self, action: #selector(self.confirmSelectionButtonAction(sender:)), for: .touchUpInside)
        backDrop.addSubview(confirmSelectionButton)
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
        
        print("SEASONAL ARRAY", selectedTailorListArray)
        
        totalTailersSelectedCountLabel.text = "\(selectedTailorListArray.count)"
    }
    
    @objc func confirmSelectionButtonAction(sender : UIButton)
    {
        let orderSummaryScreen = OrderSummaryViewController()
        self.navigationController?.pushViewController(orderSummaryScreen, animated: true)
    }
    
    func mapViewContents(isHidden : Bool)
    {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        else
        {
            
        }
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways)
        {
            
            currentLocation = locationManager.location
            print("Current Loc:",currentLocation.coordinate)
        }
        
        let camera = GMSCameraPosition(target: currentLocation.coordinate, zoom: 15.0, bearing: 0, viewingAngle: 0)

        
        mapView.frame = CGRect(x: 0, y: listViewButton.frame.maxY, width: view.frame.width, height: view.frame.height - (10.4 * y))
        mapView.camera = camera
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        view.addSubview(mapView)
        
        mapView.isHidden = isHidden
        
        let markerImageView = UIImageView()
        markerImageView.frame = CGRect(x: 0, y: 0, width: (6 * x), height: (5 * y))
        markerImageView.image = UIImage(named: "marker")
        view.addSubview(markerImageView)
        
        marker.position = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.75)
        marker.iconView = markerImageView
        marker.map = mapView
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TailorListTableViewCell.self), for: indexPath as IndexPath) as! TailorListTableViewCell
        cell.textLabel!.text = "PADMAPANNEER"
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
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
