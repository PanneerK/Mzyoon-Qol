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
            dressTypeImages.backgroundColor = UIColor.white
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
        
        let customizationView = UIView()
        customizationView.frame = CGRect(x: (3 * x), y: customizationHeadingLabel.frame.maxY, width: orderSummaryScrollView.frame.width - (6 * x), height: (19.5 * x))
        customizationView.backgroundColor = UIColor.white
        orderSummaryScrollView.addSubview(customizationView)
        
        let customizationArray = ["Lapels - ", "Buttons - ", "Pockets - ", "Vents - "]
        var y2:CGFloat = y
        
        for i in 0..<4
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
            dressTypeImages.backgroundColor = UIColor.white
            dressSubViews.addSubview(dressTypeImages)
            
            let dressTypeLabels = UILabel()
            dressTypeLabels.frame = CGRect(x: dressTypeImages.frame.maxX + (x / 2), y: y / 2, width: (13 * x), height: (3 * y))
            dressTypeLabels.backgroundColor = UIColor.clear
            dressTypeLabels.text = customizationArray[i]
            dressTypeLabels.textColor = UIColor.white
            dressTypeLabels.textAlignment = .left
            dressSubViews.addSubview(dressTypeLabels)
            
            let getDressTypeLabels = UILabel()
            getDressTypeLabels.frame = CGRect(x: dressTypeLabels.frame.maxX + (x / 2), y: (y / 2), width: (11 * x), height: (3 * y))
            getDressTypeLabels.backgroundColor = UIColor.clear
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
            dressTypeImages.backgroundColor = UIColor.white
            dressSubViews.addSubview(dressTypeImages)
            
            let dressTypeLabels = UILabel()
            dressTypeLabels.frame = CGRect(x: dressTypeImages.frame.maxX + (x / 2), y: y / 2, width: (19 * x), height: (3 * y))
            dressTypeLabels.backgroundColor = UIColor.clear
            dressTypeLabels.text = premiumArray[i]
            dressTypeLabels.textColor = UIColor.white
            dressTypeLabels.textAlignment = .left
            dressSubViews.addSubview(dressTypeLabels)
            
            let getDressTypeLabels = UILabel()
            getDressTypeLabels.frame = CGRect(x: dressTypeLabels.frame.maxX + (x / 2), y: (y / 2), width: (5 * x), height: (3 * y))
            getDressTypeLabels.backgroundColor = UIColor.clear
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
        
        let tailorView = UIView()
        tailorView.frame = CGRect(x: (3 * x), y: tailorListHeadingLabel.frame.maxY, width: orderSummaryScrollView.frame.width - (6 * x), height: (10.5 * x))
        tailorView.backgroundColor = UIColor.white
        orderSummaryScrollView.addSubview(tailorView)
        
        var y4:CGFloat = y
        
        let tailorArray = ["Noorul", "Ameen"]
        
        for i in 0..<2
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
            dressTypeImages.backgroundColor = UIColor.white
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
        
        self.serviceCall.API_InsertOrderSummary(dressType: 1, CustomerId: 1, AddressId: 2, PatternId: 1, Ordertype: 3, MeasurementId: -1, MaterialImage: [], ReferenceImage: [], OrderCustomizationAttributeId: [1], OrderCustomizationAttributeImageId: [1], TailorId: [2], MeasurementBy: "Tailor", CreatedBy: 1, MeasurementName: "Raghu", UserMeasurementValuesId: [19], UserMeasurementValues: "20.00", DeliveryTypeId: 1, delegate: self)
       
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
