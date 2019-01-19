//
//  AppointmentViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 04/01/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class AppointmentViewController: CommonViewController,ServerAPIDelegate
{
     let serviceCall = ServerAPI()
    
      let AppointmentNavigationBar = UIView()
      let AppointmentScrollview = UIScrollView()
      let AppointmentSelectionView = UIView()
      let RejectButtonView = UIView()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
   
    var Material_FromDatePick = UIDatePicker()
    var Material_ToDatePick = UIDatePicker()
    
    var Measure_FromDatePick = UIDatePicker()
    var Measure_ToDatePick = UIDatePicker()
    
    var OrderID:Int!
    
    var From_MaterialType_TF = UITextField()
    var TO_MaterialType_TF = UITextField()
    var Material_ApproveButton = UIButton()
    var Material_RejectButton = UIButton()
    
    var From_MeasurementType_TF = UITextField()
    var TO_MeasurementType_TF = UITextField()
    var Measure_ApproveButton = UIButton()
    var Measure_RejectButton = UIButton()
    
    var MeasureStatus:String!
    var MeasurementInEnglish:String!
    var MeasurementHeaderImage:UIImage!
    var MeasurementBodyImage:UIImage!
    
    var MaterialStatus:String!
    var MaterialInEnglish:String!
    var MaterailHeaderImage:UIImage!
    var MaterialBodyImage:UIImage!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view.
       
       AppointmentContent()
        
        print("order ID:", OrderID)
        
      if(OrderID != nil)
      {
         self.serviceCall.API_GetAppointmentMaterial(OrderId: OrderID, delegate: self)
         self.serviceCall.API_GetAppointmentMeasurement(OrderId: OrderID, delegate: self)
        
          AppointmentContent()
      }
      else
      {
         print("Order ID Empty/nil..")
      }
        
    }
    func DeviceError() 
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        // ErrorStr = "Default Error"
        PageNumStr = "AppointmentViewController"
        //  MethodName = "do"
        
        print("UUID", UIDevice.current.identifierForVendor?.uuidString as Any)
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
        
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
         print("Book an appointment : ", errorMessage)
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
    func API_CALLBACK_InsertAppointmentMaterial(insertAppointmentMaterial: NSDictionary)
    {
        let ResponseMsg = insertAppointmentMaterial.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = insertAppointmentMaterial.object(forKey: "Result") as! String
            print("Result", Result)
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = insertAppointmentMaterial.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "InsertAppointforMaterial"
            ErrorStr = Result
            
            DeviceError()
            
        }
        
    }
    func API_CALLBACK_InsertAppointmentMeasurement(insertAppointmentMeasure: NSDictionary)
    {
        let ResponseMsg = insertAppointmentMeasure.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = insertAppointmentMeasure.object(forKey: "Result") as! String
            print("Result", Result)
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = insertAppointmentMeasure.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "InsertAppointforMeasurement"
            ErrorStr = Result
            
            DeviceError()
            
        }
    }
    
    func API_CALLBACK_GetAppointmentMaterial(getAppointmentMaterial: NSDictionary)
    {
        let ResponseMsg = getAppointmentMaterial.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = getAppointmentMaterial.object(forKey: "Result") as! NSDictionary
            print("Result", Result)
            
            let AppOrderType = Result.object(forKey: "GetAppoinmentOrderType") as! NSArray
            print("ORder Type:",AppOrderType)
            
            let Status = Result.object(forKey: "status") as! NSArray
            print("Status:",Status)
            
            MaterialStatus = Status.value(forKey:"Status") as? String
            print("status:",MaterialStatus)
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = getAppointmentMaterial.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetCustomerInAppoinmentMeaterial"
            ErrorStr = Result
            
            DeviceError()
            
        }
    }
    
    func API_CALLBACK_GetAppointmentMeasurement(getAppointmentMeasure: NSDictionary)
    {
        let ResponseMsg = getAppointmentMeasure.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = getAppointmentMeasure.object(forKey: "Result") as! NSDictionary
            print("Result", Result)
            
            let AppMeasurement = Result.object(forKey: "GetAppoinmentMeasurement") as! NSArray
            print("Measurement:",AppMeasurement)
            
            
            let Status = Result.object(forKey: "Status") as! NSArray
            print("Status:",Status)
            
            MeasureStatus = Status.value(forKey:"Status") as? String
            print("status:",MeasureStatus)
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = getAppointmentMeasure.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetCustomerInAppoinmentMeasurement"
            ErrorStr = Result
            
            DeviceError()
            
        }
    }
    
    func AppointmentContent()
    {
        self.stopActivity()
        
       // let AppointmentNavigationBar = UIView()
        AppointmentNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        AppointmentNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(AppointmentNavigationBar)
        
        let backButton = UIButton()
         backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
         backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
         backButton.tag = 4
         backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
         AppointmentNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: AppointmentNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "APPOINTMENT"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        AppointmentNavigationBar.addSubview(navigationTitle)
        
        AppointmentTypeView()
    }
    
    func AppointmentTypeView()
    {
        //ScrollView..
        
        //let AppointmentScrollview = UIScrollView()
        AppointmentScrollview.frame = CGRect(x: 0, y: AppointmentNavigationBar.frame.maxY + y, width: view.frame.width, height: view.frame.height - (13 * y))
        AppointmentScrollview.backgroundColor = UIColor.clear
        view.addSubview(AppointmentScrollview)
        
        // Order Type..
        
        let orderTypeLabel = UILabel()
        orderTypeLabel.frame = CGRect(x: ((view.frame.width - (14 * x)) / 2), y: y, width: (16 * x), height: (3 * y))
        orderTypeLabel.backgroundColor = UIColor.white
        orderTypeLabel.text = "ORDER TYPE"
        orderTypeLabel.layer.borderColor = UIColor.lightGray.cgColor
        orderTypeLabel.layer.borderWidth = 1.0
        orderTypeLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        orderTypeLabel.textAlignment = .center
        orderTypeLabel.font = UIFont(name: "Avenir Next", size: 1.5 * x)
        AppointmentScrollview.addSubview(orderTypeLabel)
        
        
       let Material_AppointmentStatusView = UIView()
        Material_AppointmentStatusView.frame = CGRect(x: ((view.frame.width - (2 * x)) / 2), y: orderTypeLabel.frame.maxY + (2 * y), width: (19 * x), height: (2 * y))
        Material_AppointmentStatusView.backgroundColor = UIColor.white
        Material_AppointmentStatusView.layer.borderColor = UIColor.lightGray.cgColor
        Material_AppointmentStatusView.layer.borderWidth = 1.0
        Material_AppointmentStatusView.layer.cornerRadius = 5
        AppointmentScrollview.addSubview(Material_AppointmentStatusView)
        
        
        let Material_StatusLabel = UILabel()
        Material_StatusLabel.frame = CGRect(x: x, y: 0, width: (12 * x), height: (2 * y))
       // Material_StatusLabel.backgroundColor = UIColor.gray
        Material_StatusLabel.text = "Appointment Status :"
         Material_StatusLabel.textColor = UIColor.black
        Material_StatusLabel.textAlignment = .left
        Material_StatusLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
        Material_AppointmentStatusView.addSubview(Material_StatusLabel)
        
        let Material_StatusBtn = UIButton()
        Material_StatusBtn.frame = CGRect(x: Material_StatusLabel.frame.maxX, y: 0, width: (6 * x), height: (2 * y))
       // Material_StatusBtn.backgroundColor = UIColor.gray
        Material_StatusBtn.setTitle("Reject", for: .normal)
        Material_StatusBtn.setTitleColor(UIColor.blue, for: .normal)
        Material_StatusBtn.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.2 * x)!
        Material_StatusBtn.addTarget(self, action: #selector(self.statusButtonAction(sender:)), for: .touchUpInside)
        Material_AppointmentStatusView.addSubview(Material_StatusBtn)
        
        // orderType View...
        let courierDeliveryIcon = UIImageView()
        courierDeliveryIcon.frame = CGRect(x: (3 * x), y: Material_AppointmentStatusView.frame.maxY +  y, width: (2 * x), height: (2 * y))
        
       /*
        if let imageName = orderTypeHeaderImage[1] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/OrderType/\(imageName)"
            let apiurl = URL(string: api)
            courierDeliveryIcon.dowloadFromServer(url: apiurl!)
        }
       */
        AppointmentScrollview.addSubview(courierDeliveryIcon)
        
        let couriertDeliveryLabel = UILabel()
        couriertDeliveryLabel.frame = CGRect(x: courierDeliveryIcon.frame.maxX, y: Material_AppointmentStatusView.frame.maxY + y, width: view.frame.width - (5 * x), height: (2 * y))
        couriertDeliveryLabel.text = "Own Material - Courier the Material"
        couriertDeliveryLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        couriertDeliveryLabel.textAlignment = .left
        couriertDeliveryLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        couriertDeliveryLabel.adjustsFontSizeToFitWidth = true
        AppointmentScrollview.addSubview(couriertDeliveryLabel)
        
        let courierDeliveryUnderline = UILabel()
        courierDeliveryUnderline.frame = CGRect(x: (3 * x), y: couriertDeliveryLabel.frame.maxY + (y / 2), width: view.frame.width - (6 * x), height: 0.5)
        courierDeliveryUnderline.backgroundColor = UIColor.lightGray
        AppointmentScrollview.addSubview(courierDeliveryUnderline)
        
        let courierImageView = UIImageView()
        courierImageView.frame = CGRect(x: (3 * x), y: courierDeliveryUnderline.frame.maxY + y, width: view.frame.width - (6 * x), height: (10 * y))
        courierImageView.backgroundColor = UIColor.lightGray
        /*
        if let imageName = orderTypeBodyImage[1] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/OrderType/\(imageName)"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: courierImageView.frame.width, height: courierImageView.frame.height)
            dummyImageView.dowloadFromServer(url: apiurl!)
            courierImageView.addSubview(dummyImageView)
        }
        */
        AppointmentScrollview.addSubview(courierImageView)
        
        
        let From_OrderTypeLBL = UILabel()
        From_OrderTypeLBL.frame = CGRect(x: (3 * x), y: courierImageView.frame.maxY + y , width: courierImageView.frame.width / 2 , height: (2 * y))
        From_OrderTypeLBL.text = "FROM"
        From_OrderTypeLBL.textColor = UIColor.black
        From_OrderTypeLBL.textAlignment = .left
        From_OrderTypeLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        From_OrderTypeLBL.adjustsFontSizeToFitWidth = true
       // From_OrderTypeLBL.backgroundColor = UIColor.lightGray
        AppointmentScrollview.addSubview(From_OrderTypeLBL)
        
        let TO_OrderTypeLBL = UILabel()
        TO_OrderTypeLBL.frame = CGRect(x: From_OrderTypeLBL.frame.maxX + 1, y: courierImageView.frame.maxY + y , width: courierImageView.frame.width / 2, height: (2 * y))
        TO_OrderTypeLBL.text = "TO"
        TO_OrderTypeLBL.textColor = UIColor.black
        TO_OrderTypeLBL.textAlignment = .left
        TO_OrderTypeLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        TO_OrderTypeLBL.adjustsFontSizeToFitWidth = true
       // TO_OrderTypeLBL.backgroundColor = UIColor.lightGray
        AppointmentScrollview.addSubview(TO_OrderTypeLBL)
        
       // FromDate Icon..
        let FromDateMatrl_Icon = UIImageView()
        FromDateMatrl_Icon.frame = CGRect(x: (3 * x), y: From_OrderTypeLBL.frame.maxY, width:(2 * x), height: (2 * y))
        FromDateMatrl_Icon.backgroundColor = UIColor.white
        FromDateMatrl_Icon.image = UIImage(named: "OrderDate")
       // AppointmentScrollview.addSubview(FromDateMatrl_Icon)
        
        //let From_MaterialType_TF = UITextField()
        From_MaterialType_TF.frame = CGRect(x: (3 * x), y: From_OrderTypeLBL.frame.maxY, width: courierImageView.frame.width / 2 , height: (2.5 * y))
        From_MaterialType_TF.placeholder = "dd/mm/yyyy"
        From_MaterialType_TF.textColor = UIColor.white
        From_MaterialType_TF.textAlignment = .left
        From_MaterialType_TF.font = UIFont(name: "Avenir Next", size: 1.2 * x)
        From_MaterialType_TF.adjustsFontSizeToFitWidth = true
        From_MaterialType_TF.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        From_MaterialType_TF.addTarget(self, action: #selector(self.calendarButtonAction), for: .allEditingEvents)
        From_MaterialType_TF.delegate = self as? UITextFieldDelegate
        AppointmentScrollview.addSubview(From_MaterialType_TF)
        
      
        // Edit icon..
        let FromDateEditMatrl_Icon = UIImageView()
        FromDateEditMatrl_Icon.frame = CGRect(x: From_MaterialType_TF.frame.minX, y: 0, width:(2 * x), height: (2 * y))
        // FromDateEditMatrl_Icon.backgroundColor = UIColor.gray
        FromDateEditMatrl_Icon.image = UIImage(named: "OrderDate")
       // From_MaterialType_TF.addSubview(FromDateEditMatrl_Icon)
 
        // ToDAteIcon..
        let ToDateMatrl_Icon = UIImageView()
        ToDateMatrl_Icon.frame = CGRect(x: From_MaterialType_TF.frame.maxX + 1, y: From_OrderTypeLBL.frame.maxY, width:(2 * x), height: (2 * y))
        ToDateMatrl_Icon.backgroundColor = UIColor.white
        ToDateMatrl_Icon.image = UIImage(named: "OrderDate")
        // AppointmentScrollview.addSubview(ToDateMatrl_Icon)
        
       // let TO_MaterialType_TF = UITextField()
        TO_MaterialType_TF.frame = CGRect(x: From_MaterialType_TF.frame.maxX + 1, y: From_OrderTypeLBL.frame.maxY, width: courierImageView.frame.width / 2, height: (2.5 * y))
        TO_MaterialType_TF.placeholder = "dd/mm/yyyy"
        TO_MaterialType_TF.textColor = UIColor.white
        TO_MaterialType_TF.textAlignment = .center
        TO_MaterialType_TF.font = UIFont(name: "Avenir Next", size: 1.2 * x)
        TO_MaterialType_TF.adjustsFontSizeToFitWidth = true
        TO_MaterialType_TF.backgroundColor = UIColor.blue   //UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        TO_MaterialType_TF.addTarget(self, action: #selector(self.calendarButtonAction), for: .allEditingEvents)
        TO_MaterialType_TF.delegate = self as? UITextFieldDelegate
        AppointmentScrollview.addSubview(TO_MaterialType_TF)
        
        //let Material_ApproveButton = UIButton()
        Material_ApproveButton.frame = CGRect(x: (8 * x), y: From_MaterialType_TF.frame.maxY + y, width: (10 * x), height: (2 * y))
        Material_ApproveButton.backgroundColor = UIColor.black
        Material_ApproveButton.setTitle("Approve", for: .normal)
        Material_ApproveButton.setTitleColor(UIColor.white, for: .normal)
        Material_ApproveButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.3 * x)!
        Material_ApproveButton.layer.borderColor = UIColor.lightGray.cgColor
        Material_ApproveButton.layer.borderWidth = 1.0
        Material_ApproveButton.layer.cornerRadius = 10
        Material_ApproveButton.addTarget(self, action: #selector(self.ApproveButtonAction(sender:)), for: .touchUpInside)
        AppointmentScrollview.addSubview(Material_ApproveButton)
        
       // let Material_RejectButton = UIButton()
        Material_RejectButton.frame = CGRect(x: Material_ApproveButton.frame.maxX + (2 * x), y: From_MaterialType_TF.frame.maxY + y, width: (10 * x), height: (2 * y))
        Material_RejectButton.backgroundColor = UIColor.black
        Material_RejectButton.setTitle("Reject", for: .normal)
        Material_RejectButton.setTitleColor(UIColor.white, for: .normal)
        Material_RejectButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.3 * x)!
        Material_RejectButton.layer.borderColor = UIColor.lightGray.cgColor
        Material_RejectButton.layer.borderWidth = 1.0
        Material_RejectButton.layer.cornerRadius = 10
        Material_RejectButton.addTarget(self, action: #selector(self.RejectButtonAction(sender:)), for: .touchUpInside)
        AppointmentScrollview.addSubview(Material_RejectButton)
        
        
        // MEASUREMENT_1 Type..
        
        let MaterialTypeLabel = UILabel()
        MaterialTypeLabel.frame = CGRect(x: ((view.frame.width - (14 * x)) / 2), y: Material_ApproveButton.frame.maxY + (2 * y), width: (16 * x), height: (3 * y))
        MaterialTypeLabel.backgroundColor = UIColor.white
        MaterialTypeLabel.text = "MEASUREMENT_1"
        MaterialTypeLabel.layer.borderColor = UIColor.lightGray.cgColor
        MaterialTypeLabel.layer.borderWidth = 1.0
        MaterialTypeLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        MaterialTypeLabel.textAlignment = .center
        MaterialTypeLabel.font = UIFont(name: "Avenir Next", size: 1.5 * x)
        AppointmentScrollview.addSubview(MaterialTypeLabel)
        
      
        let Measurement_AppointmentStatusView = UIView()
        Measurement_AppointmentStatusView.frame = CGRect(x: ((view.frame.width - (2 * x)) / 2), y: MaterialTypeLabel.frame.maxY + (2 * y), width: (19 * x), height: (2 * y))
        Measurement_AppointmentStatusView.backgroundColor = UIColor.white
        Measurement_AppointmentStatusView.layer.borderColor = UIColor.lightGray.cgColor
        Measurement_AppointmentStatusView.layer.borderWidth = 1.0
        Measurement_AppointmentStatusView.layer.cornerRadius = 5
        AppointmentScrollview.addSubview(Measurement_AppointmentStatusView)
        
        
        let Measure_StatusLabel = UILabel()
        Measure_StatusLabel.frame = CGRect(x: x, y: 0, width: (12 * x), height: (2 * y))
        // SMeasure_StatusLabel.backgroundColor = UIColor.gray
        Measure_StatusLabel.text = "Appointment Status :"
        Measure_StatusLabel.textColor = UIColor.black
        Measure_StatusLabel.textAlignment = .left
        Measure_StatusLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
        Measurement_AppointmentStatusView.addSubview(Measure_StatusLabel)
        
        let Measure_StatusBtn = UIButton()
        Measure_StatusBtn.frame = CGRect(x: Measure_StatusLabel.frame.maxX, y: 0, width: (6 * x), height: (2 * y))
        // Measure_StatusBtn.backgroundColor = UIColor.gray
        Measure_StatusBtn.setTitle("Approve", for: .normal)
        Measure_StatusBtn.setTitleColor(UIColor.blue, for: .normal)
        Measure_StatusBtn.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.2 * x)!
        Measure_StatusBtn.addTarget(self, action: #selector(self.statusButtonAction(sender:)), for: .touchUpInside)
        Measurement_AppointmentStatusView.addSubview(Measure_StatusBtn)
        
        
        // orderType View...
        let TailorShopIcon = UIImageView()
        TailorShopIcon.frame = CGRect(x: (3 * x), y: Measurement_AppointmentStatusView.frame.maxY + y, width: (2 * x), height: (2 * y))
        
        /*
         if let imageName = orderTypeHeaderImage[1] as? String
         {
         let api = "http://appsapi.mzyoon.com/images/OrderType/\(imageName)"
         let apiurl = URL(string: api)
         courierDeliveryIcon.dowloadFromServer(url: apiurl!)
         }
         */
        AppointmentScrollview.addSubview(TailorShopIcon)
        
        let TailorTypeLabel = UILabel()
        TailorTypeLabel.frame = CGRect(x: TailorShopIcon.frame.maxX, y: Measurement_AppointmentStatusView.frame.maxY + y, width: view.frame.width - (5 * x), height: (2 * y))
        TailorTypeLabel.text = "Go To Tailor Shop"
        TailorTypeLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        TailorTypeLabel.textAlignment = .left
        TailorTypeLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        TailorTypeLabel.adjustsFontSizeToFitWidth = true
        AppointmentScrollview.addSubview(TailorTypeLabel)
        
        let TailorUnderline = UILabel()
        TailorUnderline.frame = CGRect(x: (3 * x), y: TailorTypeLabel.frame.maxY + (y / 2), width: view.frame.width - (6 * x), height: 0.5)
        TailorUnderline.backgroundColor = UIColor.lightGray
        AppointmentScrollview.addSubview(TailorUnderline)
        
        let TailorImageView = UIImageView()
        TailorImageView.frame = CGRect(x: (3 * x), y: TailorUnderline.frame.maxY + y, width: view.frame.width - (6 * x), height: (10 * y))
        TailorImageView.backgroundColor = UIColor.lightGray
        
        /*
         if let imageName = orderTypeBodyImage[1] as? String
         {
         let api = "http://appsapi.mzyoon.com/images/OrderType/\(imageName)"
         print("SMALL ICON", api)
         let apiurl = URL(string: api)
         
         let dummyImageView = UIImageView()
         dummyImageView.frame = CGRect(x: 0, y: 0, width: courierImageView.frame.width, height: courierImageView.frame.height)
         dummyImageView.dowloadFromServer(url: apiurl!)
         courierImageView.addSubview(dummyImageView)
         */
        AppointmentScrollview.addSubview(TailorImageView)
        
        let From_MaterialTypeLBL = UILabel()
        From_MaterialTypeLBL.frame = CGRect(x: (3 * x), y: TailorImageView.frame.maxY + y, width: TailorImageView.frame.width / 2 , height: (2 * y))
        From_MaterialTypeLBL.text = "FROM"
        From_MaterialTypeLBL.textColor = UIColor.black
        From_MaterialTypeLBL.textAlignment = .left
        From_MaterialTypeLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        From_MaterialTypeLBL.adjustsFontSizeToFitWidth = true
       // From_MaterialTypeLBL.backgroundColor = UIColor.lightGray
        AppointmentScrollview.addSubview(From_MaterialTypeLBL)
        
        let TO_MaterialTypeLBL = UILabel()
        TO_MaterialTypeLBL.frame = CGRect(x: From_MaterialTypeLBL.frame.maxX + 1, y: TailorImageView.frame.maxY + y, width: TailorImageView.frame.width / 2, height: (2 * y))
        TO_MaterialTypeLBL.text = "TO"
        TO_MaterialTypeLBL.textColor = UIColor.black
        TO_MaterialTypeLBL.textAlignment = .left
        TO_MaterialTypeLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        TO_MaterialTypeLBL.adjustsFontSizeToFitWidth = true
       //  TO_OrderTypeLBL.backgroundColor = UIColor.lightGray
        AppointmentScrollview.addSubview(TO_MaterialTypeLBL)
        
       // let From_MeasurementType_TF = UITextField()
        From_MeasurementType_TF.frame = CGRect(x: (3 * x), y: From_MaterialTypeLBL.frame.maxY, width: courierImageView.frame.width / 2 , height: (2.5 * y))
        From_MeasurementType_TF.placeholder = "dd/mm/yyyy"
        From_MeasurementType_TF.textColor = UIColor.white
        From_MeasurementType_TF.textAlignment = .left
        From_MeasurementType_TF.font = UIFont(name: "Avenir Next", size: 1.2 * x)
        From_MeasurementType_TF.adjustsFontSizeToFitWidth = true
        From_MeasurementType_TF.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        From_MeasurementType_TF.addTarget(self, action: #selector(self.calendarButtonAction), for: .allEditingEvents)
        From_MeasurementType_TF.delegate = self as? UITextFieldDelegate
        AppointmentScrollview.addSubview(From_MeasurementType_TF)
        
       // let TO_MaterialType_TF = UITextField()
        TO_MeasurementType_TF.frame = CGRect(x: From_MeasurementType_TF.frame.maxX + 1, y: From_MaterialTypeLBL.frame.maxY, width: courierImageView.frame.width / 2, height: (2.5 * y))
        TO_MeasurementType_TF.placeholder = "dd/mm/yyyy"
        TO_MeasurementType_TF.textColor = UIColor.white
        TO_MeasurementType_TF.textAlignment = .center
        TO_MeasurementType_TF.font = UIFont(name: "Avenir Next", size: 1.2 * x)
        TO_MeasurementType_TF.adjustsFontSizeToFitWidth = true
        TO_MeasurementType_TF.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        TO_MeasurementType_TF.addTarget(self, action: #selector(self.calendarButtonAction), for: .allEditingEvents)
        TO_MeasurementType_TF.delegate = self as? UITextFieldDelegate
        AppointmentScrollview.addSubview(TO_MeasurementType_TF)
        
       // let ApproveButton = UIButton()
       Measure_ApproveButton.frame = CGRect(x: (8 * x), y: From_MeasurementType_TF.frame.maxY + y, width: (10 * x), height: (2 * y))
         Measure_ApproveButton.backgroundColor = UIColor.black
        Measure_ApproveButton.setTitle("Approve", for: .normal)
        Measure_ApproveButton.setTitleColor(UIColor.white, for: .normal)
        Measure_ApproveButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.3 * x)!
        Measure_ApproveButton.layer.borderColor = UIColor.lightGray.cgColor
        Measure_ApproveButton.layer.borderWidth = 1.0
        Measure_ApproveButton.layer.cornerRadius = 10
        Measure_ApproveButton.addTarget(self, action: #selector(self.ApproveButtonAction(sender:)), for: .touchUpInside)
        AppointmentScrollview.addSubview(Measure_ApproveButton)
        
       // let RejectButton = UIButton()
       Measure_RejectButton.frame = CGRect(x: Measure_ApproveButton.frame.maxX + (2 * x), y: From_MeasurementType_TF.frame.maxY + y, width: (10 * x), height: (2 * y))
         Measure_RejectButton.backgroundColor = UIColor.black
        Measure_RejectButton.setTitle("Reject", for: .normal)
        Measure_RejectButton.setTitleColor(UIColor.white, for: .normal)
        Measure_RejectButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.3 * x)!
        Measure_RejectButton.layer.borderColor = UIColor.lightGray.cgColor
        Measure_RejectButton.layer.borderWidth = 1.0
        Measure_RejectButton.layer.cornerRadius = 10
        Measure_RejectButton.addTarget(self, action: #selector(self.RejectButtonAction(sender:)), for: .touchUpInside)
        AppointmentScrollview.addSubview(Measure_RejectButton)
        
        
        let SaveButton = UIButton()
        SaveButton.frame = CGRect(x: TailorImageView.frame.width - (5 * x), y: Measure_RejectButton.frame.minY + (4 * y) , width: (8 * x), height: (2 * y))
        SaveButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        SaveButton.setTitle("Save", for: .normal)
        SaveButton.setTitleColor(UIColor.white, for: .normal)
        SaveButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.3 * x)!
  
        SaveButton.addTarget(self, action: #selector(self.SaveButtonAction(sender:)), for: .touchUpInside)
        AppointmentScrollview.addSubview(SaveButton)
        
        AppointmentScrollview.contentSize.height = SaveButton.frame.maxY + (2 * y)
    }

    
    @objc func otpBackButtonAction(sender : UIButton)
    {
     self.navigationController?.popViewController(animated: true)
    }
    
    @objc func statusButtonAction(sender : UIButton)
    {
        print("status Page..")
        AppointmentStatusContent()
    }
    @objc func ApproveButtonAction(sender : UIButton)
    {
        print("Approve Status Page..")
    }
    @objc func RejectButtonAction(sender : UIButton)
    {
        print("Reject Status Page..")
        
        RejectButtonContent()
    }
    @objc func SaveButtonAction(sender : UIButton)
    {
        print("Save Action..")
    }
    
    func AppointmentStatusContent()
    {
        AppointmentSelectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        AppointmentSelectionView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        view.addSubview(AppointmentSelectionView)
        
        let Rescheduleview = UIView()
        Rescheduleview.frame = CGRect(x: 0, y: (AppointmentSelectionView.frame.height / 2 ) - (5 * y) , width: view.frame.width, height: (12 * y))
        Rescheduleview.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        AppointmentSelectionView.addSubview(Rescheduleview)
        
        let reschedule_LBL = UILabel()
        reschedule_LBL.frame = CGRect(x: x, y: Rescheduleview.frame.minY, width: Rescheduleview.frame.width - x, height: (8 * y))
        //reschedule_LBL.backgroundColor = UIColor.gray
        reschedule_LBL.text = "The Appointment for your time is not available, please reschedule your date and time for your appointment"
        reschedule_LBL.textColor = UIColor.white
        reschedule_LBL.textAlignment = .left
        reschedule_LBL.lineBreakMode = .byWordWrapping
        reschedule_LBL.numberOfLines = 3
        reschedule_LBL.font = UIFont(name: "Avenir Next", size: 1.5 * x)
        AppointmentSelectionView.addSubview(reschedule_LBL)
      
        let rescheduleButton = UIButton()
        rescheduleButton.frame = CGRect(x: x, y: reschedule_LBL.frame.maxY + y , width: (15 * x), height: (2 * y))
        rescheduleButton.backgroundColor = UIColor.blue
        rescheduleButton.setTitle("Click Here to Reschedule", for: .normal)
        rescheduleButton.setTitleColor(UIColor.white, for: .normal)
        rescheduleButton.layer.borderColor = UIColor.lightGray.cgColor
        rescheduleButton.layer.borderWidth = 1.0
        rescheduleButton.layer.cornerRadius = 10
        rescheduleButton.addTarget(self, action: #selector(self.RescheduleButtonAction(sender:)), for: .touchUpInside)
        rescheduleButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.2 * x)!
        AppointmentSelectionView.addSubview(rescheduleButton)
        
        let okButton = UIButton()
        okButton.frame = CGRect(x: rescheduleButton.frame.maxX + (8 * x), y: reschedule_LBL.frame.maxY + y, width: (10 * x), height: (2 * y))
        okButton.backgroundColor = UIColor.blue
        okButton.setTitle("Ok", for: .normal)
        okButton.setTitleColor(UIColor.white, for: .normal)
        okButton.layer.borderColor = UIColor.lightGray.cgColor
        okButton.layer.borderWidth = 1.0
        okButton.layer.cornerRadius = 10
        okButton.addTarget(self, action: #selector(self.RescheduleButtonAction(sender:)), for: .touchUpInside)
        okButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.2 * x)!
        AppointmentSelectionView.addSubview(okButton)
      
    }
    
    func RejectButtonContent()
    {
        RejectButtonView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        RejectButtonView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        view.addSubview(RejectButtonView)
        
        let RejectView = UIView()
        RejectView.frame = CGRect(x: 0, y: (RejectButtonView.frame.height / 2 ) - (5 * y) , width: view.frame.width, height: (10 * y))
        RejectView.backgroundColor = UIColor.white
        RejectButtonView.addSubview(RejectView)
        
        let rejectReason_TF = UITextField()
        rejectReason_TF.frame = CGRect(x: x, y: RejectView.frame.minY, width: RejectView.frame.width - (2 * x), height: (6 * y))
       // rejectReason_TF.backgroundColor = UIColor.gray
        rejectReason_TF.placeholder = "please Mention your reason for rejecting.."
        //rejectReason_TF.text = "The Appointment for your time is not available, please reschedule your date and time for your appointment"
       rejectReason_TF.textColor = UIColor.black
        rejectReason_TF.textAlignment = .left
        rejectReason_TF.contentVerticalAlignment = .top
        rejectReason_TF.font = UIFont(name: "Avenir Next", size: 1.5 * x)
        RejectButtonView.addSubview(rejectReason_TF)
        
        let CancelButton = UIButton()
        CancelButton.frame = CGRect(x: (2 * x), y: rejectReason_TF.frame.maxY + y , width: (10 * x), height: (2 * y))
        CancelButton.backgroundColor = UIColor.lightGray
        CancelButton.setTitle("Cancel", for: .normal)
        CancelButton.setTitleColor(UIColor.white, for: .normal)
        CancelButton.layer.borderColor = UIColor.lightGray.cgColor
        CancelButton.layer.borderWidth = 1.0
        CancelButton.layer.cornerRadius = 10
        CancelButton.addTarget(self, action: #selector(self.CancelButtonAction(sender:)), for: .touchUpInside)
        CancelButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.2 * x)!
        RejectButtonView.addSubview(CancelButton)
        
        let saveButton = UIButton()
        saveButton.frame = CGRect(x: CancelButton.frame.maxX + (12 * x), y: rejectReason_TF.frame.maxY + y, width: (10 * x), height: (2 * y))
        saveButton.backgroundColor = UIColor.blue
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.layer.borderColor = UIColor.lightGray.cgColor
        saveButton.layer.borderWidth = 1.0
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(self.SaveRejectButtonAction(sender:)), for: .touchUpInside)
        saveButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.2 * x)!
        RejectButtonView.addSubview(saveButton)
        
    }
    
    @objc func RescheduleButtonAction(sender : UIButton)
    {
        AppointmentSelectionView.removeFromSuperview()
    }
    
    @objc func CancelButtonAction(sender : UIButton)
    {
        RejectButtonView.removeFromSuperview()
    }
    
    @objc func SaveRejectButtonAction(sender : UIButton)
    {
        //AppointmentSelectionView.removeFromSuperview()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let loginScreen = HomeViewController()
        let navigationScreen = UINavigationController(rootViewController: loginScreen)
        navigationScreen.isNavigationBarHidden = true
        window?.rootViewController = navigationScreen
        window?.makeKeyAndVisible()
    }
    
    @objc func calendarButtonAction()
    {
        pickUpDate(From_MaterialType_TF)
        pickUpDate(TO_MaterialType_TF)
        pickUpDate(From_MeasurementType_TF)
        pickUpDate(TO_MeasurementType_TF)
    }
    
    func pickUpDate(_ textField : UITextField)
    {
        
        // Material DatePicker
        self.Material_FromDatePick = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.Material_FromDatePick.backgroundColor = UIColor.white
        self.Material_FromDatePick.datePickerMode = UIDatePicker.Mode.date
       // self.FromDatePick.maximumDate = Date()
        textField.inputView = self.Material_FromDatePick
        
        self.Material_ToDatePick = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.Material_ToDatePick.backgroundColor = UIColor.white
        self.Material_ToDatePick.datePickerMode = UIDatePicker.Mode.date
       // self.ToDatePick.maximumDate = Date()
        textField.inputView = self.Material_ToDatePick
        
        // Measure DatePicker
        self.Measure_FromDatePick = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.Measure_FromDatePick.backgroundColor = UIColor.white
        self.Measure_FromDatePick.datePickerMode = UIDatePicker.Mode.date
        // self.FromDatePick.maximumDate = Date()
        textField.inputView = self.Material_FromDatePick
        
        self.Measure_ToDatePick = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.Measure_ToDatePick.backgroundColor = UIColor.white
        self.Measure_ToDatePick.datePickerMode = UIDatePicker.Mode.date
        // self.ToDatePick.maximumDate = Date()
        textField.inputView = self.Measure_ToDatePick
        
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    @objc func doneClick()
    {
        let FromMaterial_dateFormatter = DateFormatter()
        FromMaterial_dateFormatter.dateStyle = .medium
        FromMaterial_dateFormatter.timeStyle = .none
        FromMaterial_dateFormatter.dateFormat = "dd/MM/yyyy"  //"yyyy/MM/dd"
        From_MaterialType_TF.text = FromMaterial_dateFormatter.string(from: Material_FromDatePick.date)
        From_MaterialType_TF.resignFirstResponder()
        
        
        let ToMaterial_dateFormatter = DateFormatter()
        ToMaterial_dateFormatter.dateStyle = .medium
        ToMaterial_dateFormatter.timeStyle = .none
        ToMaterial_dateFormatter.dateFormat = "dd/MM/yyyy"  //"yyyy/MM/dd"
        TO_MaterialType_TF.text = ToMaterial_dateFormatter.string(from: Material_ToDatePick.date)
        TO_MaterialType_TF.resignFirstResponder()
        
        
        let FromMeasure_dateFormatter = DateFormatter()
        FromMeasure_dateFormatter.dateStyle = .medium
        FromMeasure_dateFormatter.timeStyle = .none
        FromMeasure_dateFormatter.dateFormat = "dd/MM/yyyy"  //"yyyy/MM/dd"
        From_MeasurementType_TF.text = FromMeasure_dateFormatter.string(from: Measure_FromDatePick.date)
        From_MeasurementType_TF.resignFirstResponder()
        
        let ToMeasure_dateFormatter = DateFormatter()
        ToMeasure_dateFormatter.dateStyle = .medium
        ToMeasure_dateFormatter.timeStyle = .none
        ToMeasure_dateFormatter.dateFormat = "dd/MM/yyyy"  //"yyyy/MM/dd"
        TO_MeasurementType_TF.text = ToMeasure_dateFormatter.string(from: Measure_ToDatePick.date)
        TO_MeasurementType_TF.resignFirstResponder()
        
        
    }
    @objc func cancelClick()
    {
        From_MaterialType_TF.resignFirstResponder()
        TO_MaterialType_TF.resignFirstResponder()
        
        From_MeasurementType_TF.resignFirstResponder()
        TO_MeasurementType_TF.resignFirstResponder()
    }
}
