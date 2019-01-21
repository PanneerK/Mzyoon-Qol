//
//  OrderSummaryViewController.swift
//  Mzyoon
//
//  Created by QOL on 19/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class OrderSummaryViewController: CommonViewController,ServerAPIDelegate
{
    
    let randomInt = Int.random(in: 10265..<10365)

    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    let serviceCall = ServerAPI()
    
    var customization3 = NSDictionary()
    var selectedTailors = [String]()
    
    override func viewDidLoad()
    {
        navigationBar.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of seconds
            // Your code with delay
            self.orderSummaryContent()
        }
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func orderSummaryContent()
    {
        self.stopActivity()
        let orderSummaryNavigationBar = UIView()
        orderSummaryNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        orderSummaryNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(orderSummaryNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 4
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        orderSummaryNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: orderSummaryNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "ORDER SUMMARY"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        orderSummaryNavigationBar.addSubview(navigationTitle)
        
        let orderSummaryScrollView = UIScrollView()
        orderSummaryScrollView.frame = CGRect(x: 0, y: orderSummaryNavigationBar.frame.maxY + y, width: view.frame.width, height: view.frame.height - (13 * y))
        orderSummaryScrollView.backgroundColor = UIColor.clear
        view.addSubview(orderSummaryScrollView)
        
        let dressTypeHeadingLabel = UILabel()
        dressTypeHeadingLabel.frame = CGRect(x: (3 * x), y: y, width: view.frame.width, height: (3 * y))
        dressTypeHeadingLabel.text = "DRESS TYPE"
        dressTypeHeadingLabel.textColor = UIColor.black
        dressTypeHeadingLabel.textAlignment = .left
        dressTypeHeadingLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        orderSummaryScrollView.addSubview(dressTypeHeadingLabel)
        
        let dressTypeView = UIView()
        dressTypeView.frame = CGRect(x: (3 * x), y: dressTypeHeadingLabel.frame.maxY, width: orderSummaryScrollView.frame.width - (6 * x), height: (24 * x))
        dressTypeView.backgroundColor = UIColor.white
        orderSummaryScrollView.addSubview(dressTypeView)
        
        let dressTypeArray = ["Gender - ", "Seasonal - ", "Place of Industry - ", "Brand - ", "Material Type - "]
        let dressTypeImageArray = ["Gender-3", "Seasonal", "Place_of_industry", "Material_type", "Brand"]
        let getDressTypeArray = ["Men", "", "", "", ""]
        var y1:CGFloat = y
        
        for i in 0..<5
        {
            let dressSubViews = UIView()
            dressSubViews.frame = CGRect(x: x, y: y1, width: dressTypeView.frame.width - (2 * x), height: (4 * y))
            dressSubViews.layer.cornerRadius = 10
            dressSubViews.backgroundColor = UIColor(red: 0.0471, green: 0.1725, blue: 0.4588, alpha: 1.0)
            dressSubViews.layer.masksToBounds = true
            dressTypeView.addSubview(dressSubViews)
            
            let dressTypeImages = UIImageView()
            dressTypeImages.frame = CGRect(x: (x / 2), y: y / 2, width: (3 * x), height: (3 * y))
            dressTypeImages.layer.cornerRadius = dressTypeImages.frame.height / 2
            dressTypeImages.image = UIImage(named: dressTypeImageArray[i])
            dressSubViews.addSubview(dressTypeImages)
            
            let dressTypeLabels = UILabel()
            dressTypeLabels.frame = CGRect(x: dressTypeImages.frame.maxX + (x / 2), y: y / 2, width: (13 * x), height: (3 * y))
            dressTypeLabels.backgroundColor = UIColor.clear
            dressTypeLabels.text = dressTypeArray[i]
            dressTypeLabels.textColor = UIColor.white
            dressTypeLabels.textAlignment = .left
            dressSubViews.addSubview(dressTypeLabels)
            
            let getDressTypeLabels = UILabel()
            getDressTypeLabels.frame = CGRect(x: dressTypeLabels.frame.maxX + (x / 2), y: (y / 2), width: (11 * x), height: (3 * y))
            getDressTypeLabels.backgroundColor = UIColor.clear
            getDressTypeLabels.text = getDressTypeArray[i]
            getDressTypeLabels.textColor = UIColor.white
            getDressTypeLabels.textAlignment = .left
            dressSubViews.addSubview(getDressTypeLabels)
            
            y1 = dressSubViews.frame.maxY + (y / 2)
        }
        
        
        let customizationHeadingLabel = UILabel()
        customizationHeadingLabel.frame = CGRect(x: (3 * x), y: dressTypeView.frame.maxY + y, width: view.frame.width, height: (3 * y))
        customizationHeadingLabel.text = "CUSTOMIZATION"
        customizationHeadingLabel.textColor = UIColor.black
        customizationHeadingLabel.textAlignment = .left
        customizationHeadingLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        orderSummaryScrollView.addSubview(customizationHeadingLabel)
        
        if let custom3 = UserDefaults.standard.value(forKey: "custom3") as? NSDictionary
        {
            customization3 = custom3
        }
        
        
        let customizationView = UIView()
        customizationView.frame = CGRect(x: (3 * x), y: customizationHeadingLabel.frame.maxY, width: orderSummaryScrollView.frame.width - (6 * x), height: (5 * x * CGFloat(customization3.count)))
        customizationView.backgroundColor = UIColor.white
        orderSummaryScrollView.addSubview(customizationView)
        
        print("CUSTOM 3 SELECTED", customization3)
        
        var customKeys = [String]()
        var customvalues = [String]()
        
        for (keys, values) in customization3
        {
            customKeys.append(keys as! String)
            customvalues.append(values as! String)
        }
        
        let customizationArray = ["Lapels - ", "Buttons - ", "Pockets - ", "Vents - "]
        let customizationImageArray = ["Lapels", "Buttons", "Pockets", "Vents"]
        var y2:CGFloat = y
        
        for i in 0..<customization3.count
        {
            let dressSubViews = UIView()
            dressSubViews.frame = CGRect(x: x, y: y2, width: dressTypeView.frame.width - (2 * x), height: (4 * y))
            dressSubViews.layer.cornerRadius = 10
            dressSubViews.backgroundColor = UIColor(red: 0.0471, green: 0.1725, blue: 0.4588, alpha: 1.0)
            dressSubViews.layer.masksToBounds = true
            customizationView.addSubview(dressSubViews)
            
            let dressTypeImages = UIImageView()
            dressTypeImages.frame = CGRect(x: (x / 2), y: y / 2, width: (3 * x), height: (3 * y))
            dressTypeImages.layer.cornerRadius = dressTypeImages.frame.height / 2
            dressTypeImages.image = UIImage(named: customizationImageArray[i])
            dressSubViews.addSubview(dressTypeImages)
            
            let dressTypeLabels = UILabel()
            dressTypeLabels.frame = CGRect(x: dressTypeImages.frame.maxX + (x / 2), y: y / 2, width: (13 * x), height: (3 * y))
            dressTypeLabels.backgroundColor = UIColor.clear
            dressTypeLabels.text = "\(customKeys[i]) - "
            dressTypeLabels.textColor = UIColor.white
            dressTypeLabels.textAlignment = .left
            dressSubViews.addSubview(dressTypeLabels)
            
            let getDressTypeLabels = UILabel()
            getDressTypeLabels.frame = CGRect(x: dressTypeLabels.frame.maxX + (x / 2), y: (y / 2), width: (11 * x), height: (3 * y))
            getDressTypeLabels.backgroundColor = UIColor.clear
            getDressTypeLabels.text = customvalues[i]
            getDressTypeLabels.textColor = UIColor.white
            getDressTypeLabels.textAlignment = .left
            dressSubViews.addSubview(getDressTypeLabels)
            
            y2 = dressSubViews.frame.maxY + (y / 2)
        }
        
        let premiumServicesHeadingLabel = UILabel()
        premiumServicesHeadingLabel.frame = CGRect(x: (3 * x), y: customizationView.frame.maxY + y, width: view.frame.width, height: (3 * y))
        premiumServicesHeadingLabel.text = "PREMIUM SERVICES"
        premiumServicesHeadingLabel.textColor = UIColor.black
        premiumServicesHeadingLabel.textAlignment = .left
        premiumServicesHeadingLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        orderSummaryScrollView.addSubview(premiumServicesHeadingLabel)
        
        let premiumServicesView = UIView()
        premiumServicesView.frame = CGRect(x: (3 * x), y: premiumServicesHeadingLabel.frame.maxY, width: orderSummaryScrollView.frame.width - (6 * x), height: (24 * x))
        premiumServicesView.backgroundColor = UIColor.white
        orderSummaryScrollView.addSubview(premiumServicesView)
        
        let premiumArray = ["Measurement + Service - ", "Material Delivery - ", "Urgent Stitches - ", "Additional Design - ", "Special Delivery - "]
        let premiumImagesArray = ["Measurement+Service", "material_delivery", "urgent_stitches", "Additional_design", "Special_delivery"]
        let getPremiumArray = ["50.00 AED", "70.00 AED", "150.00 AED", "20.00 AED", "30.00 AED"]
        var y3:CGFloat = y
        
        for i in 0..<5
        {
            let dressSubViews = UIView()
            dressSubViews.frame = CGRect(x: x, y: y3, width: dressTypeView.frame.width - (2 * x), height: (4 * y))
            dressSubViews.layer.cornerRadius = 10
            dressSubViews.backgroundColor = UIColor(red: 0.0471, green: 0.1725, blue: 0.4588, alpha: 1.0)
            dressSubViews.layer.masksToBounds = true
            premiumServicesView.addSubview(dressSubViews)
            
            let dressTypeImages = UIImageView()
            dressTypeImages.frame = CGRect(x: (x / 2), y: y / 2, width: (3 * x), height: (3 * y))
            dressTypeImages.layer.cornerRadius = dressTypeImages.frame.height / 2
            dressTypeImages.image = UIImage(named: premiumImagesArray[i])
            dressSubViews.addSubview(dressTypeImages)
            
            let dressTypeLabels = UILabel()
            dressTypeLabels.frame = CGRect(x: dressTypeImages.frame.maxX + (x / 2), y: y / 2, width: (19 * x), height: (3 * y))
            dressTypeLabels.backgroundColor = UIColor.clear
            dressTypeLabels.text = premiumArray[i]
            dressTypeLabels.textColor = UIColor.white
            dressTypeLabels.textAlignment = .left
            dressSubViews.addSubview(dressTypeLabels)
            
            let getDressTypeLabels = UILabel()
            getDressTypeLabels.frame = CGRect(x: dressTypeLabels.frame.maxX, y: (y / 2), width: (9 * x), height: (3 * y))
            getDressTypeLabels.backgroundColor = UIColor.clear
            getDressTypeLabels.text = getPremiumArray[i]
            getDressTypeLabels.textColor = UIColor.white
            getDressTypeLabels.textAlignment = .left
            dressSubViews.addSubview(getDressTypeLabels)
            
            y3 = dressSubViews.frame.maxY + (y / 2)
        }
        
        let noteView = UIView()
        noteView.frame = CGRect(x: (3 * x), y: premiumServicesView.frame.maxY, width: orderSummaryScrollView.frame.width - (6 * x), height: (5 * x))
        noteView.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        orderSummaryScrollView.addSubview(noteView)
        
        let noteLabel = UILabel()
        noteLabel.frame = CGRect(x: x, y: 0, width: noteView.frame.width - (2 * x), height: (4 * y))
        noteLabel.text = "NOTE : The price, services and courier will add to order total amount"
        noteLabel.textAlignment = .center
        noteLabel.textColor = UIColor.white
        noteLabel.font = noteLabel.font.withSize(15)
        noteLabel.numberOfLines = 2
        noteView.addSubview(noteLabel)
        
        
        let tailorListHeadingLabel = UILabel()
        tailorListHeadingLabel.frame = CGRect(x: (3 * x), y: noteView.frame.maxY + y, width: view.frame.width, height: (3 * y))
        tailorListHeadingLabel.text = "TOTAL NUMBER OF TAILORS"
        tailorListHeadingLabel.textColor = UIColor.black
        tailorListHeadingLabel.textAlignment = .left
        tailorListHeadingLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        orderSummaryScrollView.addSubview(tailorListHeadingLabel)
        
        
        if let tailorList = UserDefaults.standard.value(forKey: "selectedTailors")
        {
            selectedTailors = tailorList as! [String]
        }
        
        let tailorView = UIView()
        tailorView.frame = CGRect(x: (3 * x), y: tailorListHeadingLabel.frame.maxY, width: orderSummaryScrollView.frame.width - (6 * x), height: (6 * x * CGFloat(selectedTailors.count)))
        tailorView.backgroundColor = UIColor.white
        orderSummaryScrollView.addSubview(tailorView)
        
        var y4:CGFloat = y
        
        let tailorArray = ["Noorul", "Ameen"]
        
        for i in 0..<selectedTailors.count
        {
            let dressSubViews = UIView()
            dressSubViews.frame = CGRect(x: x, y: y4, width: dressTypeView.frame.width - (2 * x), height: (4 * y))
            dressSubViews.layer.cornerRadius = 10
            dressSubViews.backgroundColor = UIColor(red: 0.0471, green: 0.1725, blue: 0.4588, alpha: 1.0)
            dressSubViews.layer.masksToBounds = true
            tailorView.addSubview(dressSubViews)
            
            let dressTypeImages = UIImageView()
            dressTypeImages.frame = CGRect(x: (x / 2), y: y / 2, width: (3 * x), height: (3 * y))
            dressTypeImages.layer.cornerRadius = dressTypeImages.frame.height / 2
            dressTypeImages.image = UIImage(named: "Tailor")
            dressSubViews.addSubview(dressTypeImages)
            
            let dressTypeLabels = UILabel()
            dressTypeLabels.frame = CGRect(x: dressTypeImages.frame.maxX + (x / 2), y: y / 2, width: (10 * x), height: (3 * y))
            dressTypeLabels.backgroundColor = UIColor.clear
            dressTypeLabels.text = "Tailor_\(i) - "
            dressTypeLabels.textColor = UIColor.white
            dressTypeLabels.textAlignment = .left
            dressSubViews.addSubview(dressTypeLabels)
            
            let getDressTypeLabels = UILabel()
            getDressTypeLabels.frame = CGRect(x: dressTypeLabels.frame.maxX + (x / 2), y: (y / 2), width: (14 * x), height: (3 * y))
            getDressTypeLabels.backgroundColor = UIColor.clear
            getDressTypeLabels.text = selectedTailors[i]
            getDressTypeLabels.textColor = UIColor.white
            getDressTypeLabels.textAlignment = .left
            dressSubViews.addSubview(getDressTypeLabels)
            
            y4 = dressSubViews.frame.maxY + (y / 2)
        }
        
        
        let submitButton = UIButton()
        submitButton.frame = CGRect(x: orderSummaryScrollView.frame.width - (13 * x), y: tailorView.frame.maxY + (2 * y), width: (10 * x), height: (4 * y))
        submitButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.addTarget(self, action: #selector(self.submitButtonAction(sender:)), for: .touchUpInside)
        orderSummaryScrollView.addSubview(submitButton)
        
        orderSummaryScrollView.contentSize.height = submitButton.frame.maxY + (2 * y)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func submitButtonAction(sender : UIButton)
    {
        var userId = String()
        var dressId = Int()
        var orderId = Int()
        var addressId = Int()
        var patternId = Int()
        var measurementBy = String()
        var measurementName = String()
        var measurementId = NSArray()
        var measurementValues = [Float]()
        var tailorId = [Int]()
        var custom3Key = [String]()
        var custom3Values = [String]()
        var custom3KeyInt = [Int]()
        var custom3ValuesInt = [Int]()
        
        if let id = UserDefaults.standard.value(forKey: "userId") as? String
        {
            userId = id
        }
        
        if let dressid = UserDefaults.standard.value(forKey: "dressType") as? Int
        {
            dressId = dressid
        }
        
        if let orderid = UserDefaults.standard.value(forKey: "orderType") as? Int
        {
            orderId = orderid
        }
        
        if let id = UserDefaults.standard.value(forKey: "addressId") as? Int
        {
            addressId = id
        }
        
        if let measurementby = UserDefaults.standard.value(forKey: "measurementBy") as? String
        {
            measurementBy = measurementby
        }
        
        if let partsId = UserDefaults.standard.value(forKey: "measurementId") as? NSArray
        {
            measurementId = partsId
        }
        
        if measurementBy == "User"
        {
            if let name = UserDefaults.standard.value(forKey: "measurementName") as? String
            {
                measurementName = name
            }
        }
        else
        {
            measurementName = ""
        }
        
        if let patId = UserDefaults.standard.value(forKey: "patternId") as? Int
        {
            patternId = patId
        }
        else
        {
            patternId = 0
        }
        
        if let dictValues = UserDefaults.standard.value(forKey: "measurementValues") as? [Float]
        {
            measurementValues = dictValues
        }
        
        if let taiId = UserDefaults.standard.value(forKey: "selectedTailorsId") as? [Int]
        {
            tailorId = taiId
        }
        
        if let custom3 = UserDefaults.standard.value(forKey: "custom3") as? [String : String]
        {
            for (keys, values) in custom3
            {
                custom3Key.append(keys)
                custom3Values.append(values)
            }
        }
        print("MEAUREMENT VALUES", custom3Key, custom3Values)

        for i in 0..<custom3Key.count
        {
            custom3KeyInt.append(Int(custom3Key[i])!)
            custom3ValuesInt.append(Int(custom3Values[i])!)
        }
        
        print("MEAUREMENT VALUES", custom3KeyInt, custom3ValuesInt)
        self.serviceCall.API_InsertOrderSummary(dressType: dressId, CustomerId: userId, AddressId: addressId, PatternId: patternId, Ordertype: orderId, MeasurementId: -1, MaterialImage: [], ReferenceImage: [], OrderCustomizationAttributeId: custom3KeyInt, OrderCustomizationAttributeImageId: custom3ValuesInt, TailorId: tailorId, MeasurementBy: measurementBy, CreatedBy: userId, MeasurementName: measurementName, UserMeasurementValuesId: measurementId, UserMeasurementValues: measurementValues, DeliveryTypeId: 1, delegate: self)
       
        let alert = UIAlertController(title: "Oredered Placed Successfully", message: "Order Id = \(randomInt)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: navigateToHomeScreen(action:)))
        self.present(alert, animated: true, completion: nil)
 
    }
    
    func navigateToHomeScreen(action : UIAlertAction)
    {
        window = UIWindow(frame: UIScreen.main.bounds)
        let loginScreen = HomeViewController()
        let navigationScreen = UINavigationController(rootViewController: loginScreen)
        navigationScreen.isNavigationBarHidden = true
        window?.rootViewController = navigationScreen
        window?.makeKeyAndVisible()
    }

    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
         print("Order Summary", errorMessage)
    }
    
    func API_CALLBACK_InsertOrderSummary(insertOrder: NSDictionary)
    {
        let ResponseMsg = insertOrder.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = insertOrder.object(forKey: "Result") as! String
            print("Result", Result)
            
            let alert = UIAlertController(title: "Oredered Placed Successfully", message: "Order Id = \(Result)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: navigateToHomeScreen(action:)))
            self.present(alert, animated: true, completion: nil)
        }
        else if ResponseMsg == "Failure"
        {
            let Result = insertOrder.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "InsertOrder"
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        //  ErrorStr = "Default Error"
        PageNumStr = "OrderSummary ViewController"
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
