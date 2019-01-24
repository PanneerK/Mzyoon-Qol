//
//  AppointmentViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 04/01/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class AppointmentViewController: CommonViewController,ServerAPIDelegate,UIPickerViewDelegate,UIPickerViewDataSource
{
     let serviceCall = ServerAPI()
    
      let AppointmentNavigationBar = UIView()
      let AppointmentScrollview = UIScrollView()
    
       let OrderTypeView = UIView()
       let MeasurementTypeView = UIView()
    
      let AppointmentSelectionView = UIView()
    
      let MaterialRejectButtonView = UIView()
      let MeasureRejectButtonView = UIView()
    
    var TimeSlotArray = NSArray()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    var OrderID:Int!
   
    
    // Material...
    var Material_FromDatePick = UIDatePicker()
    var Material_ToDatePick = UIDatePicker()
    var Material_TimeSlotPick : UIPickerView!
    
    var From_MaterialType_TF = UITextField()
    var TO_MaterialType_TF = UITextField()
    var SLOT_MaterialType_TF = UITextField()
    var Material_ApproveButton = UIButton()
    var Material_RejectButton = UIButton()
    
    var MaterialStatus = NSArray()
    var MaterialInEnglish = NSArray()
    var MaterailHeaderImage = NSArray()
    var MaterialBodyImage = NSArray()
    var MaterialAppointID = NSArray()
    var MaterialOrderID = NSArray()
    
    
    // Measurement...
    var Measure_FromDatePick = UIDatePicker()
    var Measure_ToDatePick = UIDatePicker()
    var Measure_TimeSlotPick : UIPickerView!
    
    var From_MeasurementType_TF = UITextField()
    var TO_MeasurementType_TF = UITextField()
    var SLOT_MeasurementType_TF = UITextField()
    var Measure_ApproveButton = UIButton()
    var Measure_RejectButton = UIButton()
    
    var MeasureStatus = NSArray()
    var MeasurementInEnglish = NSArray()
    var MeasurementHeaderImage = NSArray()
    var MeasurementBodyImage = NSArray()
    var MeasurementAppointID = NSArray()
    var MeasurementOrderID = NSArray()
    
    var Material_rejectReason_TF = UITextField()
    var Measure_rejectReason_TF = UITextField()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view.
       
     //  AppointmentContent()
        
        print("order ID:", OrderID)
        
      if(OrderID != nil)
      {
         self.serviceCall.API_GetAppointmentMaterial(OrderId: OrderID, delegate: self)
         self.serviceCall.API_GetAppointmentMeasurement(OrderId: OrderID, delegate: self)
        
         // AppointmentContent()
      }
      else
      {
         print("Order ID Empty/nil..")
        
          // self.serviceCall.API_GetAppointmentMaterial(OrderId: 1, delegate: self)
          // self.serviceCall.API_GetAppointmentMeasurement(OrderId: 4, delegate: self)
      }
        
       TimeSlotArray = ["8.00 A.M  to  9.00 A.M","9.00 A.M  to  10.00 A.M","10.00 A.M  to  11.00 A.M","11.00 A.M  to  12.00 P.M","12.00 P.M  to  1.00 P.M","2.00 P.M  to  3.00 P.M","3.00 P.M  to  4.00 P.M","4.00 P.M  to  5.00 P.M","5.00 P.M  to  6.00 P.M","6.00 P.M  to  7.00 P.M","7.00 P.M  to  8.00 P.M"]
        
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
            
            
            let appointmentAlert = UIAlertController(title: "Message..!", message: Result, preferredStyle: .alert)
            appointmentAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: proceedAlertAction(action:)))
            appointmentAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(appointmentAlert, animated: true, completion: nil)
            
            /*
             window = UIWindow(frame: UIScreen.main.bounds)
             let loginScreen = HomeViewController()
             let navigationScreen = UINavigationController(rootViewController: loginScreen)
             navigationScreen.isNavigationBarHidden = true
             window?.rootViewController = navigationScreen
             window?.makeKeyAndVisible()
             */
            
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
            
            
            let appointmentAlert = UIAlertController(title: "Message..!", message: Result, preferredStyle: .alert)
            appointmentAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: proceedAlertAction(action:)))
            appointmentAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(appointmentAlert, animated: true, completion: nil)
            
            /*
             window = UIWindow(frame: UIScreen.main.bounds)
             let loginScreen = HomeViewController()
             let navigationScreen = UINavigationController(rootViewController: loginScreen)
             navigationScreen.isNavigationBarHidden = true
             window?.rootViewController = navigationScreen
             window?.makeKeyAndVisible()
           */
            
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
            let Result = getAppointmentMaterial.object(forKey: "Result") as! NSArray
            print("Result", Result)
            if(Result.count > 0)
            {
            MaterialBodyImage = Result.value(forKey:"BodyImage") as! NSArray
            print("Body Image:",MaterialBodyImage)
            
            MaterialAppointID = Result.value(forKey:"BookAppointId") as! NSArray
            print("Appointment ID:",MaterialAppointID)
            
            MaterailHeaderImage = Result.value(forKey:"HeaderImage") as! NSArray
            print("Header Image:",MaterailHeaderImage)
            
            MaterialInEnglish = Result.value(forKey:"HeaderInEnglish") as! NSArray
             print("Header Name:",MaterialInEnglish)
            
            MaterialOrderID = Result.value(forKey:"OrderId") as! NSArray
             print("Order ID:",MaterialOrderID)
            
            MaterialStatus = Result.value(forKey:"status") as! NSArray
            print("status:",MaterialStatus)
            
           }
           else
           {
                
           }
            
           // AppointmentContent()
            
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
            let Result = getAppointmentMeasure.object(forKey: "Result") as! NSArray
            print("Result", Result)
           
          if(Result.count > 0)
          {
            MeasurementBodyImage = Result.value(forKey:"BodyImage") as! NSArray
            print("Body Image:",MeasurementBodyImage)
            
            MeasurementAppointID = Result.value(forKey:"BookAppointId") as! NSArray
            print("Appointment ID:",MeasurementAppointID)
            
         //   MeasurementHeaderImage = Result.value(forKey:"HeaderImage") as! NSArray
          //  print("Header Image:",MeasurementHeaderImage)
            
            MeasurementInEnglish = Result.value(forKey:"MeasurementInEnglish") as! NSArray
            print("Header Name:",MeasurementInEnglish)
            
            MeasurementOrderID = Result.value(forKey:"OrderId") as! NSArray
            print("Order ID:",MeasurementOrderID)
            
            MeasureStatus = Result.value(forKey:"Status") as! NSArray
            print("status:",MeasureStatus)
            
            
            AppointmentContent()
        }
        else
        {
           
            AppointmentContent()
        }
            
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
    
    func API_CALLBACK_IsApproveAptMaterial(IsApproveMaterial: NSDictionary)
    {
        let ResponseMsg = IsApproveMaterial.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = IsApproveMaterial.object(forKey: "Result") as! NSDictionary
            print("Result", Result)
            
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = IsApproveMaterial.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "BuyerOrderApprovalMaterial"
            ErrorStr = Result
            
            DeviceError()
            
        }
    }
    
    func API_CALLBACK_IsApproveAptMeasurement(IsApproveMeasure: NSDictionary)
    {
        let ResponseMsg = IsApproveMeasure.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = IsApproveMeasure.object(forKey: "Result") as! NSDictionary
            print("Result", Result)
            
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = IsApproveMeasure.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "BuyerOrderApprovalMeasurement"
            ErrorStr = Result
            
            DeviceError()
            
        }
    }
    
    func proceedAlertAction(action : UIAlertAction)
    {
        let HomeScreen = HomeViewController()
        self.navigationController?.pushViewController(HomeScreen, animated: true)
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
        AppointmentScrollview.frame = CGRect(x: 0, y: AppointmentNavigationBar.frame.maxY, width: view.frame.width, height: view.frame.height - (12 * y))
        AppointmentScrollview.backgroundColor = UIColor.clear
        view.addSubview(AppointmentScrollview)
        
        var viewType : Float!
        
        if MaterialInEnglish .contains("Companies-Material")
        {
            OrderTypeView.removeFromSuperview()
           
            //viewType = (OrderTypeView.frame.maxY + y)
            
            
        }
        
        
  //----------------------------------------OrderType View---------------------------------------------------------------
        
        // OrderType View..
        OrderTypeView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (40 * y))
       // OrderTypeView.backgroundColor = UIColor.lightGray
        AppointmentScrollview.addSubview(OrderTypeView)
        
        // Order Type..
        let orderTypeLabel = UILabel()
        orderTypeLabel.frame = CGRect(x: ((OrderTypeView.frame.width - (14 * x)) / 2), y: y, width: (16 * x), height: (3 * y))
        orderTypeLabel.backgroundColor = UIColor.white
        orderTypeLabel.text = "ORDER TYPE"
        orderTypeLabel.layer.borderColor = UIColor.lightGray.cgColor
        orderTypeLabel.layer.borderWidth = 1.0
        orderTypeLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        orderTypeLabel.textAlignment = .center
        orderTypeLabel.font = UIFont(name: "Avenir Next", size: 1.5 * x)
        OrderTypeView.addSubview(orderTypeLabel)
      
        
      //-------------------------------AppointmentStatusView---------------------
        
        let Material_AppointmentStatusView = UIView()
        Material_AppointmentStatusView.frame = CGRect(x: ((view.frame.width - (2 * x)) / 2), y: orderTypeLabel.frame.maxY + (2 * y), width: (19 * x), height: (2 * y))
        Material_AppointmentStatusView.backgroundColor = UIColor.white
        Material_AppointmentStatusView.layer.borderColor = UIColor.lightGray.cgColor
        Material_AppointmentStatusView.layer.borderWidth = 1.0
        Material_AppointmentStatusView.layer.cornerRadius = 5
        OrderTypeView.addSubview(Material_AppointmentStatusView)
        
        let Material_StatusLabel = UILabel()
        Material_StatusLabel.frame = CGRect(x: x, y: 0, width: (12 * x), height: (2 * y))
       // Material_StatusLabel.backgroundColor = UIColor.gray
        Material_StatusLabel.text = "Appointment Status:"
         Material_StatusLabel.textColor = UIColor.black
        Material_StatusLabel.textAlignment = .left
        Material_StatusLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
        Material_AppointmentStatusView.addSubview(Material_StatusLabel)
        
        let Material_StatusBtn = UIButton()
        Material_StatusBtn.frame = CGRect(x: Material_StatusLabel.frame.maxX, y: 0, width: (6 * x), height: (2 * y))
       // Material_StatusBtn.backgroundColor = UIColor.gray
        if(MaterialStatus.count > 0)
        {
          Material_StatusBtn.setTitle("\(MaterialStatus[0])", for: .normal)
        }
        else
        {
          Material_StatusBtn.setTitle("", for: .normal)
        }
        Material_StatusBtn.setTitleColor(UIColor.blue, for: .normal)
        Material_StatusBtn.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.2 * x)!
        Material_StatusBtn.addTarget(self, action: #selector(self.MaterialStatusButtonAction(sender:)), for: .touchUpInside)
        Material_AppointmentStatusView.addSubview(Material_StatusBtn)
      
        
    // orderType imageView...
        let courierDeliveryIcon = UIImageView()
        courierDeliveryIcon.frame = CGRect(x: (3 * x), y: Material_AppointmentStatusView.frame.maxY +  y, width: (2 * x), height: (2 * y))
       
      if(MaterailHeaderImage.count > 0)
      {
        if let imageName = MaterailHeaderImage[0] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/OrderType/\(imageName)"
            let apiurl = URL(string: api)
            courierDeliveryIcon.dowloadFromServer(url: apiurl!)
        }
      }
       OrderTypeView.addSubview(courierDeliveryIcon)
        
        let couriertDeliveryLabel = UILabel()
        couriertDeliveryLabel.frame = CGRect(x: courierDeliveryIcon.frame.maxX + x, y: Material_AppointmentStatusView.frame.maxY + y, width: view.frame.width - (5 * x), height: (2 * y))
        if(MaterialInEnglish.count > 0)
        {
            couriertDeliveryLabel.text = MaterialInEnglish[0] as? String
        }
        else
        {
            couriertDeliveryLabel.text = ""
        }
        couriertDeliveryLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        couriertDeliveryLabel.textAlignment = .left
        couriertDeliveryLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        couriertDeliveryLabel.adjustsFontSizeToFitWidth = true
        OrderTypeView.addSubview(couriertDeliveryLabel)
        
        let courierDeliveryUnderline = UILabel()
        courierDeliveryUnderline.frame = CGRect(x: (3 * x), y: couriertDeliveryLabel.frame.maxY + (y / 2), width: view.frame.width - (6 * x), height: 0.5)
        courierDeliveryUnderline.backgroundColor = UIColor.lightGray
        OrderTypeView.addSubview(courierDeliveryUnderline)
        
        let courierImageView = UIImageView()
        courierImageView.frame = CGRect(x: (3 * x), y: courierDeliveryUnderline.frame.maxY + y, width: view.frame.width - (6 * x), height: (10 * y))
       // courierImageView.backgroundColor = UIColor.lightGray
      
      if(MaterialBodyImage.count > 0)
      {
        if let imageName = MaterialBodyImage[0] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/OrderType/\(imageName)"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: courierImageView.frame.width, height: courierImageView.frame.height)
            dummyImageView.dowloadFromServer(url: apiurl!)
            courierImageView.addSubview(dummyImageView)
        }
      }
        OrderTypeView.addSubview(courierImageView)
        
    //---------------OrderType FromDate Label---------------------
        
        let From_OrderTypeLBL = UILabel()
        From_OrderTypeLBL.frame = CGRect(x: (3 * x), y: courierImageView.frame.maxY + y , width: courierImageView.frame.width / 2 , height: (2 * y))
        From_OrderTypeLBL.text = "FROM"
        From_OrderTypeLBL.textColor = UIColor.black
        From_OrderTypeLBL.textAlignment = .left
        From_OrderTypeLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        From_OrderTypeLBL.adjustsFontSizeToFitWidth = true
       // From_OrderTypeLBL.backgroundColor = UIColor.lightGray
        OrderTypeView.addSubview(From_OrderTypeLBL)
   
     //---------------OrderType ToDate Label---------------------
        
        let TO_OrderTypeLBL = UILabel()
        TO_OrderTypeLBL.frame = CGRect(x: From_OrderTypeLBL.frame.maxX + 1, y: courierImageView.frame.maxY + y , width: courierImageView.frame.width / 2, height: (2 * y))
        TO_OrderTypeLBL.text = "TO"
        TO_OrderTypeLBL.textColor = UIColor.black
        TO_OrderTypeLBL.textAlignment = .left
        TO_OrderTypeLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        TO_OrderTypeLBL.adjustsFontSizeToFitWidth = true
        // TO_OrderTypeLBL.backgroundColor = UIColor.lightGray
        OrderTypeView.addSubview(TO_OrderTypeLBL)
        
    //-----------------OrderType FromDate View----------------------------
        
        //FromDateView
        let FromDateView = UIView()
        FromDateView.frame = CGRect(x: (3 * x), y: From_OrderTypeLBL.frame.maxY, width: courierImageView.frame.width / 2, height: (2.5 * y))
        FromDateView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        OrderTypeView.addSubview(FromDateView)
        
        // FromDate Icon..
        let FromDateMatrl_Icon = UIImageView()
        FromDateMatrl_Icon.frame = CGRect(x: 1, y: (y/2) - 4, width:(2 * x), height: (2 * y))
        FromDateMatrl_Icon.backgroundColor = UIColor.white
        FromDateMatrl_Icon.image = UIImage(named: "OrderDate")
        FromDateView.addSubview(FromDateMatrl_Icon)
        
        //let From_MaterialType_TF = UITextField()
        From_MaterialType_TF.frame = CGRect(x: FromDateMatrl_Icon.frame.maxX, y: (y/2) - 4, width: (10 * x) , height: (2 * y))
        From_MaterialType_TF.placeholder = "dd/mm/yyyy"
        From_MaterialType_TF.textColor = UIColor.white
        From_MaterialType_TF.textAlignment = .center
        From_MaterialType_TF.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        From_MaterialType_TF.adjustsFontSizeToFitWidth = true
        //From_MaterialType_TF.backgroundColor = UIColor.gray
        From_MaterialType_TF.addTarget(self, action: #selector(self.FMaterial_calendarAction), for: .allEditingEvents)
        From_MaterialType_TF.delegate = self as? UITextFieldDelegate
        FromDateView.addSubview(From_MaterialType_TF)
        
        // Edit icon..
        let FromDateEditMatrl_Icon = UIImageView()
        FromDateEditMatrl_Icon.frame = CGRect(x: From_MaterialType_TF.frame.maxX, y: (y/2) - 4, width:(2 * x), height: (1.5 * y))
        FromDateEditMatrl_Icon.backgroundColor = UIColor.white
        FromDateEditMatrl_Icon.image = UIImage(named: "OrderDate")
        //FromDateView.addSubview(FromDateEditMatrl_Icon)
 
        
     //-----------------OrderType ToDate View----------------------------
        
        //ToDateView
        let ToDateView = UIView()
        ToDateView.frame = CGRect(x: FromDateView.frame.maxX + 1, y: TO_OrderTypeLBL.frame.maxY, width: courierImageView.frame.width / 2, height: (2.5 * y))
        ToDateView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        OrderTypeView.addSubview(ToDateView)
        
        // ToDAteIcon..
        let ToDateMatrl_Icon = UIImageView()
        ToDateMatrl_Icon.frame = CGRect(x: 1, y: (y/2) - 4, width:(2 * x), height: (2 * y))
        ToDateMatrl_Icon.backgroundColor = UIColor.white
        ToDateMatrl_Icon.image = UIImage(named: "OrderDate")
         ToDateView.addSubview(ToDateMatrl_Icon)
        
       // let TO_MaterialType_TF = UITextField()
        TO_MaterialType_TF.frame = CGRect(x: ToDateMatrl_Icon.frame.maxX , y: (y/2) - 4, width: (10 * x), height: (2 * y))
        TO_MaterialType_TF.placeholder = "dd/mm/yyyy"
        TO_MaterialType_TF.textColor = UIColor.white
        TO_MaterialType_TF.textAlignment = .center
        TO_MaterialType_TF.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        TO_MaterialType_TF.adjustsFontSizeToFitWidth = true
       // TO_MaterialType_TF.backgroundColor = UIColor.gray  //UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        TO_MaterialType_TF.addTarget(self, action: #selector(self.TMaterial_calendarAction), for: .allEditingEvents)
        TO_MaterialType_TF.delegate = self as? UITextFieldDelegate
        ToDateView.addSubview(TO_MaterialType_TF)
        
        // Edit icon..
        let ToDateEditMatrl_Icon = UIImageView()
        ToDateEditMatrl_Icon.frame = CGRect(x: From_MaterialType_TF.frame.maxX, y: (y/2) - 4, width:(2 * x), height: (1.5 * y))
        ToDateEditMatrl_Icon.backgroundColor = UIColor.white
        ToDateEditMatrl_Icon.image = UIImage(named: "OrderDate")
        // ToDateView.addSubview(ToDateEditMatrl_Icon)
        
        
    //-----------------OrderType TimeSlot View----------------------------
        
        let Slot_MaterialTypeLBL = UILabel()
        Slot_MaterialTypeLBL.frame = CGRect(x: (3 * x), y: FromDateView.frame.maxY + y, width: (8 * x), height: (2.5 * y))
        Slot_MaterialTypeLBL.text = "TIME SLOT"
        Slot_MaterialTypeLBL.textColor = UIColor.black
        Slot_MaterialTypeLBL.textAlignment = .left
        Slot_MaterialTypeLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        Slot_MaterialTypeLBL.adjustsFontSizeToFitWidth = true
        // Slot_MaterialTypeLBL.backgroundColor = UIColor.lightGray
        OrderTypeView.addSubview(Slot_MaterialTypeLBL)
        
        
        //TimeSlotView
        let Material_TimeSlotView = UIView()
        Material_TimeSlotView.frame = CGRect(x: Slot_MaterialTypeLBL.frame.maxX, y: FromDateView.frame.maxY + y, width: (23.5 * x), height: (2.5 * y))
        Material_TimeSlotView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        OrderTypeView.addSubview(Material_TimeSlotView)
        
        // TimeMatrl_Icon..
        let TimeMatrl_Icon = UIImageView()
        TimeMatrl_Icon.frame = CGRect(x: 2, y: (y/2) - 4, width:(2 * x), height: (2 * y))
        TimeMatrl_Icon.backgroundColor = UIColor.white
        TimeMatrl_Icon.image = UIImage(named: "OrderDate")
        Material_TimeSlotView.addSubview(TimeMatrl_Icon)
        
        // let SLOT_MaterialType_TF.frame = UITextField()
        SLOT_MaterialType_TF.frame = CGRect(x: TimeMatrl_Icon.frame.maxX, y: (y/2) - 4, width: (20 * x), height: (2 * y))
        SLOT_MaterialType_TF.placeholder = "Select Time Slot"
        SLOT_MaterialType_TF.textColor = UIColor.white
        SLOT_MaterialType_TF.textAlignment = .center
        SLOT_MaterialType_TF.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        SLOT_MaterialType_TF.adjustsFontSizeToFitWidth = true
        // SLOT_MaterialType_TF.frame.backgroundColor = UIColor.lightGray //UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        SLOT_MaterialType_TF.addTarget(self, action: #selector(self.SlotMaterial_calendarAction), for: .allEditingEvents)
        SLOT_MaterialType_TF.delegate = self as? UITextFieldDelegate
        Material_TimeSlotView.addSubview(SLOT_MaterialType_TF)
        
    //---------------Material Approve Button----------------
        
        //let Material_ApproveButton = UIButton()
        Material_ApproveButton.frame = CGRect(x: (8 * x), y: Material_TimeSlotView.frame.maxY + y, width: (10 * x), height: (2 * y))
        Material_ApproveButton.backgroundColor = UIColor.black
        Material_ApproveButton.setTitle("Approve", for: .normal)
        Material_ApproveButton.setTitleColor(UIColor.white, for: .normal)
        Material_ApproveButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.3 * x)!
        Material_ApproveButton.layer.borderColor = UIColor.lightGray.cgColor
        Material_ApproveButton.layer.borderWidth = 1.0
        Material_ApproveButton.layer.cornerRadius = 10
        Material_ApproveButton.addTarget(self, action: #selector(self.MaterialApproveButtonAction(sender:)), for: .touchUpInside)
        OrderTypeView.addSubview(Material_ApproveButton)
  
    //-----------------MAterial Reject button-----------------
        
       // let Material_RejectButton = UIButton()
        Material_RejectButton.frame = CGRect(x: Material_ApproveButton.frame.maxX + (2 * x), y: Material_TimeSlotView.frame.maxY + y, width: (10 * x), height: (2 * y))
        Material_RejectButton.backgroundColor = UIColor.black
        Material_RejectButton.setTitle("Reject", for: .normal)
        Material_RejectButton.setTitleColor(UIColor.white, for: .normal)
        Material_RejectButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.3 * x)!
        Material_RejectButton.layer.borderColor = UIColor.lightGray.cgColor
        Material_RejectButton.layer.borderWidth = 1.0
        Material_RejectButton.layer.cornerRadius = 10
        Material_RejectButton.addTarget(self, action: #selector(self.MaterialRejectButtonAction(sender:)), for: .touchUpInside)
        OrderTypeView.addSubview(Material_RejectButton)
        
    //-----------------Material Save Button------------------------
        
        let Material_SaveButton = UIButton()
        Material_SaveButton.frame = CGRect(x: courierImageView.frame.width - (5 * x), y: Material_RejectButton.frame.minY + (4 * y) , width: (8 * x), height: (2 * y))
        Material_SaveButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        Material_SaveButton.setTitle("Save", for: .normal)
        Material_SaveButton.setTitleColor(UIColor.white, for: .normal)
        Material_SaveButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.3 * x)!
        
        Material_SaveButton.addTarget(self, action: #selector(self.Material_SaveButtonAction(sender:)), for: .touchUpInside)
        OrderTypeView.addSubview(Material_SaveButton)
     
        
    //------------------------------------------MeasurementType View--------------------------------------------------------
        
        // MEASUREMENT_1 Type View..

        MeasurementTypeView.frame = CGRect(x: 0, y: OrderTypeView.frame.maxY + y, width: view.frame.width, height: (40 * y))
        //MeasurementTypeView.backgroundColor = UIColor.darkGray
        AppointmentScrollview.addSubview(MeasurementTypeView)
        
        
        // MEASUREMENT_1 Type..
        let MaterialTypeLabel = UILabel()
        MaterialTypeLabel.frame = CGRect(x: ((MeasurementTypeView.frame.width - (14 * x)) / 2), y: y, width: (16 * x), height: (3 * y))  // Y:Material_ApproveButton.frame.maxY + (2 * y)
        MaterialTypeLabel.backgroundColor = UIColor.white
        MaterialTypeLabel.text = "MEASUREMENT_1"
        MaterialTypeLabel.layer.borderColor = UIColor.lightGray.cgColor
        MaterialTypeLabel.layer.borderWidth = 1.0
        MaterialTypeLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        MaterialTypeLabel.textAlignment = .center
        MaterialTypeLabel.font = UIFont(name: "Avenir Next", size: 1.5 * x)
        MeasurementTypeView.addSubview(MaterialTypeLabel)
        
      
        let Measurement_AppointmentStatusView = UIView()
        Measurement_AppointmentStatusView.frame = CGRect(x: ((view.frame.width - (2 * x)) / 2), y: MaterialTypeLabel.frame.maxY + (2 * y), width: (19 * x), height: (2 * y))
        Measurement_AppointmentStatusView.backgroundColor = UIColor.white
        Measurement_AppointmentStatusView.layer.borderColor = UIColor.lightGray.cgColor
        Measurement_AppointmentStatusView.layer.borderWidth = 1.0
        Measurement_AppointmentStatusView.layer.cornerRadius = 5
        MeasurementTypeView.addSubview(Measurement_AppointmentStatusView)
        
        
        let Measure_StatusLabel = UILabel()
        Measure_StatusLabel.frame = CGRect(x: x, y: 0, width: (12 * x), height: (2 * y))
        // SMeasure_StatusLabel.backgroundColor = UIColor.gray
        Measure_StatusLabel.text = "Appointment Status:"
        Measure_StatusLabel.textColor = UIColor.black
        Measure_StatusLabel.textAlignment = .left
        Measure_StatusLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
        Measurement_AppointmentStatusView.addSubview(Measure_StatusLabel)
        
        let Measure_StatusBtn = UIButton()
        Measure_StatusBtn.frame = CGRect(x: Measure_StatusLabel.frame.maxX, y: 0, width: (6 * x), height: (2 * y))
        // Measure_StatusBtn.backgroundColor = UIColor.gray
        if(MeasureStatus.count > 0)
        {
           Measure_StatusBtn.setTitle("\(MeasureStatus[0])", for: .normal)
        }
        else
        {
            Measure_StatusBtn.setTitle("", for: .normal)
        }
        
        Measure_StatusBtn.setTitleColor(UIColor.blue, for: .normal)
        Measure_StatusBtn.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.2 * x)!
        Measure_StatusBtn.addTarget(self, action: #selector(self.MeasureStatusButtonAction(sender:)), for: .touchUpInside)
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
        MeasurementTypeView.addSubview(TailorShopIcon)
        
        let TailorTypeLabel = UILabel()
        TailorTypeLabel.frame = CGRect(x: TailorShopIcon.frame.maxX, y: Measurement_AppointmentStatusView.frame.maxY + y, width: view.frame.width - (5 * x), height: (2 * y))
        if(MeasurementInEnglish.count > 0)
        {
            TailorTypeLabel.text = MeasurementInEnglish[0] as? String
        }
        else
        {
            TailorTypeLabel.text = ""
        }
        TailorTypeLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        TailorTypeLabel.textAlignment = .left
        TailorTypeLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        TailorTypeLabel.adjustsFontSizeToFitWidth = true
        MeasurementTypeView.addSubview(TailorTypeLabel)
        
        let TailorUnderline = UILabel()
        TailorUnderline.frame = CGRect(x: (3 * x), y: TailorTypeLabel.frame.maxY + (y / 2), width: view.frame.width - (6 * x), height: 0.5)
        TailorUnderline.backgroundColor = UIColor.lightGray
        MeasurementTypeView.addSubview(TailorUnderline)
        
        let TailorImageView = UIImageView()
        TailorImageView.frame = CGRect(x: (3 * x), y: TailorUnderline.frame.maxY + y, width: view.frame.width - (6 * x), height: (10 * y))
       // TailorImageView.backgroundColor = UIColor.lightGray
       
        if(MeasurementBodyImage.count > 0)
        {
            if let imageName = MeasurementBodyImage[0] as? String
            {
                let api = "http://appsapi.mzyoon.com/images/OrderType/\(imageName)"
                print("SMALL ICON", api)
                let apiurl = URL(string: api)
                
                let dummyImageView = UIImageView()
                dummyImageView.frame = CGRect(x: 0, y: 0, width: courierImageView.frame.width, height: TailorImageView.frame.height)
                dummyImageView.dowloadFromServer(url: apiurl!)
                courierImageView.addSubview(dummyImageView)
            }
        }
       
         MeasurementTypeView.addSubview(TailorImageView)
        
        let From_MaterialTypeLBL = UILabel()
        From_MaterialTypeLBL.frame = CGRect(x: (3 * x), y: TailorImageView.frame.maxY + y, width: TailorImageView.frame.width / 2 , height: (2 * y))
        From_MaterialTypeLBL.text = "FROM"
        From_MaterialTypeLBL.textColor = UIColor.black
        From_MaterialTypeLBL.textAlignment = .left
        From_MaterialTypeLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        From_MaterialTypeLBL.adjustsFontSizeToFitWidth = true
       // From_MaterialTypeLBL.backgroundColor = UIColor.lightGray
        MeasurementTypeView.addSubview(From_MaterialTypeLBL)
        
        let TO_MaterialTypeLBL = UILabel()
        TO_MaterialTypeLBL.frame = CGRect(x: From_MaterialTypeLBL.frame.maxX + 1, y: TailorImageView.frame.maxY + y, width: TailorImageView.frame.width / 2, height: (2 * y))
        TO_MaterialTypeLBL.text = "TO"
        TO_MaterialTypeLBL.textColor = UIColor.black
        TO_MaterialTypeLBL.textAlignment = .left
        TO_MaterialTypeLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        TO_MaterialTypeLBL.adjustsFontSizeToFitWidth = true
       //  TO_OrderTypeLBL.backgroundColor = UIColor.lightGray
        MeasurementTypeView.addSubview(TO_MaterialTypeLBL)
        
   //--------------------Measure FromDate View----------------------
        
        //FromDateView
        let Measure_FromDateView = UIView()
        Measure_FromDateView.frame = CGRect(x: (3 * x), y: From_MaterialTypeLBL.frame.maxY, width: TailorImageView.frame.width / 2, height: (2.5 * y))
        Measure_FromDateView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        MeasurementTypeView.addSubview(Measure_FromDateView)
        
        // FromDate Icon..
        let FromDateMeasure_Icon = UIImageView()
        FromDateMeasure_Icon.frame = CGRect(x: 1, y: (y/2) - 4, width:(2 * x), height: (2 * y))
        FromDateMeasure_Icon.backgroundColor = UIColor.white
        FromDateMeasure_Icon.image = UIImage(named: "OrderDate")
        Measure_FromDateView.addSubview(FromDateMeasure_Icon)
        
        //let From_MeasurementType_TF = UITextField()
        From_MeasurementType_TF.frame = CGRect(x: FromDateMeasure_Icon.frame.maxX, y: (y/2) - 4, width: (10 * x) , height: (2 * y))
        From_MeasurementType_TF.placeholder = "dd/mm/yyyy"
        From_MeasurementType_TF.textColor = UIColor.white
        From_MeasurementType_TF.textAlignment = .center
        From_MeasurementType_TF.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        From_MeasurementType_TF.adjustsFontSizeToFitWidth = true
        //From_MeasurementType_TF.backgroundColor = UIColor.gray
        From_MeasurementType_TF.addTarget(self, action: #selector(self.FMeasurement_calendarAction), for: .allEditingEvents)
        From_MeasurementType_TF.delegate = self as? UITextFieldDelegate
        Measure_FromDateView.addSubview(From_MeasurementType_TF)
        
        // Edit icon..
        let FromDateEditMeasure_Icon = UIImageView()
        FromDateEditMeasure_Icon.frame = CGRect(x: From_MaterialType_TF.frame.maxX, y: (y/2) - 4, width:(2 * x), height: (1.5 * y))
        FromDateEditMeasure_Icon.backgroundColor = UIColor.white
        FromDateEditMeasure_Icon.image = UIImage(named: "OrderDate")
        //Measure_FromDateView.addSubview(FromDateEditMeasure_Icon)
        
        
   //--------------------Measure ToDate View----------------------
        
        //ToDateView
        let Measure_ToDateView = UIView()
        Measure_ToDateView.frame = CGRect(x: Measure_FromDateView.frame.maxX + 1, y: TO_MaterialTypeLBL.frame.maxY, width: TailorImageView.frame.width / 2, height: (2.5 * y))
        Measure_ToDateView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        MeasurementTypeView.addSubview(Measure_ToDateView)
        
        // ToDAteIcon..
        let ToDateMeasure_Icon = UIImageView()
        ToDateMeasure_Icon.frame = CGRect(x: 1, y: (y/2) - 4, width:(2 * x), height: (2 * y))
        ToDateMeasure_Icon.backgroundColor = UIColor.white
        ToDateMeasure_Icon.image = UIImage(named: "OrderDate")
        Measure_ToDateView.addSubview(ToDateMeasure_Icon)
        
        // let TO_MeasurementType_TF = UITextField()
        TO_MeasurementType_TF.frame = CGRect(x: ToDateMeasure_Icon.frame.maxX , y: (y/2) - 4, width: (10 * x), height: (2 * y))
        TO_MeasurementType_TF.placeholder = "dd/mm/yyyy"
        TO_MeasurementType_TF.textColor = UIColor.white
        TO_MeasurementType_TF.textAlignment = .center
        TO_MeasurementType_TF.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        TO_MeasurementType_TF.adjustsFontSizeToFitWidth = true
        // TO_MeasurementType_TF.backgroundColor = UIColor.gray  //UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        TO_MeasurementType_TF.addTarget(self, action: #selector(self.TMeasurement_calendarAction), for: .allEditingEvents)
        TO_MeasurementType_TF.delegate = self as? UITextFieldDelegate
        Measure_ToDateView.addSubview(TO_MeasurementType_TF)
        
        // Edit icon..
        let ToDateEditMeasure_Icon = UIImageView()
        ToDateEditMeasure_Icon.frame = CGRect(x: TO_MeasurementType_TF.frame.maxX, y: (y/2) - 4, width:(2 * x), height: (1.5 * y))
        ToDateEditMeasure_Icon.backgroundColor = UIColor.white
        ToDateEditMeasure_Icon.image = UIImage(named: "OrderDate")
        // Measure_ToDateView.addSubview(ToDateEditMeasure_Icon)
        
        
         
    //----------------Time Slot View------------------------------------
         
        let Slot_MeasureTypeLBL = UILabel()
        Slot_MeasureTypeLBL.frame = CGRect(x: (3 * x), y: Measure_FromDateView.frame.maxY + y, width: (7 * x), height: (2.5 * y))
        Slot_MeasureTypeLBL.text = "TIME SLOT"
        Slot_MeasureTypeLBL.textColor = UIColor.black
        Slot_MeasureTypeLBL.textAlignment = .left
        Slot_MeasureTypeLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        Slot_MeasureTypeLBL.adjustsFontSizeToFitWidth = true
        // Slot_MeasureTypeLBL.backgroundColor = UIColor.lightGray
        MeasurementTypeView.addSubview(Slot_MeasureTypeLBL)
        
        
        //TimeSlotView
        let Measure_TimeSlotView = UIView()
        Measure_TimeSlotView.frame = CGRect(x: Slot_MeasureTypeLBL.frame.maxX, y: Measure_FromDateView.frame.maxY + y, width: (24.5 * x), height: (2.5 * y))
        Measure_TimeSlotView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        MeasurementTypeView.addSubview(Measure_TimeSlotView)
        print("width value :",TailorImageView.frame.width / 2)
        
        // TimeMatrl_Icon..
        let TimeMeasure_Icon = UIImageView()
        TimeMeasure_Icon.frame = CGRect(x: 2, y: (y/2) - 4, width:(2 * x), height: (2 * y))
        TimeMeasure_Icon.backgroundColor = UIColor.white
        TimeMeasure_Icon.image = UIImage(named: "OrderDate")
         Measure_TimeSlotView.addSubview(TimeMeasure_Icon)
        
        // let SLOT_MeasurementType_TF = UITextField()
        SLOT_MeasurementType_TF.frame = CGRect(x: TimeMeasure_Icon.frame.maxX + x, y: (y/2) - 4, width: (20 * x), height: (2 * y))
        SLOT_MeasurementType_TF.placeholder = "Select Time Slot"
        SLOT_MeasurementType_TF.textColor = UIColor.white
        SLOT_MeasurementType_TF.textAlignment = .center
        SLOT_MeasurementType_TF.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        SLOT_MeasurementType_TF.adjustsFontSizeToFitWidth = true
       // SLOT_MeasurementType_TF.backgroundColor = UIColor.lightGray //UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        SLOT_MeasurementType_TF.addTarget(self, action: #selector(self.SlotMeasure_calendarAction), for: .allEditingEvents)
        SLOT_MeasurementType_TF.delegate = self as? UITextFieldDelegate
        Measure_TimeSlotView.addSubview(SLOT_MeasurementType_TF)
 

    //----------------------------------------------------
        
        
       // let ApproveButton = UIButton()
       Measure_ApproveButton.frame = CGRect(x: (8 * x), y: Measure_TimeSlotView.frame.maxY + y, width: (10 * x), height: (2 * y))
         Measure_ApproveButton.backgroundColor = UIColor.black
        Measure_ApproveButton.setTitle("Approve", for: .normal)
        Measure_ApproveButton.setTitleColor(UIColor.white, for: .normal)
        Measure_ApproveButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.3 * x)!
        Measure_ApproveButton.layer.borderColor = UIColor.lightGray.cgColor
        Measure_ApproveButton.layer.borderWidth = 1.0
        Measure_ApproveButton.layer.cornerRadius = 10
        Measure_ApproveButton.addTarget(self, action: #selector(self.MeasureApproveButtonAction(sender:)), for: .touchUpInside)
        MeasurementTypeView.addSubview(Measure_ApproveButton)
        
       // let RejectButton = UIButton()
       Measure_RejectButton.frame = CGRect(x: Measure_ApproveButton.frame.maxX + (2 * x), y: Measure_TimeSlotView.frame.maxY + y, width: (10 * x), height: (2 * y))
         Measure_RejectButton.backgroundColor = UIColor.black
        Measure_RejectButton.setTitle("Reject", for: .normal)
        Measure_RejectButton.setTitleColor(UIColor.white, for: .normal)
        Measure_RejectButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.3 * x)!
        Measure_RejectButton.layer.borderColor = UIColor.lightGray.cgColor
        Measure_RejectButton.layer.borderWidth = 1.0
        Measure_RejectButton.layer.cornerRadius = 10
        Measure_RejectButton.addTarget(self, action: #selector(self.MeasureRejectButtonAction(sender:)), for: .touchUpInside)
        MeasurementTypeView.addSubview(Measure_RejectButton)
        
 
        let Measure_SaveButton = UIButton()
        Measure_SaveButton.frame = CGRect(x: TailorImageView.frame.width - (5 * x), y: Measure_RejectButton.frame.minY + (4 * y) , width: (8 * x), height: (2 * y))
        Measure_SaveButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        Measure_SaveButton.setTitle("Save", for: .normal)
        Measure_SaveButton.setTitleColor(UIColor.white, for: .normal)
        Measure_SaveButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.3 * x)!
  
        Measure_SaveButton.addTarget(self, action: #selector(self.Measure_SaveButtonAction(sender:)), for: .touchUpInside)
        MeasurementTypeView.addSubview(Measure_SaveButton)
   
        
        AppointmentScrollview.contentSize.height = MeasurementTypeView.frame.maxY + (2 * y)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
     self.navigationController?.popViewController(animated: true)
    }
    
    @objc func MaterialStatusButtonAction(sender : UIButton)
    {
        print("Material status Page..")
        if(MaterialStatus .contains("Not Approved"))
        {
            AppointmentStatusContent()
        }
        else
        {
            
        }
        
    }
    @objc func MeasureStatusButtonAction(sender : UIButton)
    {
        print("Measure status Page..")
        if(MeasureStatus .contains("Not Approved"))
        {
            AppointmentStatusContent()
        }
        else
        {
            
        }
    }
    @objc func MaterialApproveButtonAction(sender : UIButton)
    {
        print("Material Approve Status Page..")
        
        let AppointID = MaterialAppointID[0] as! Int
        let Msg = ""
        self.serviceCall.API_IsApproveAppointmentMaterial(AppointmentId: AppointID, IsApproved: 1, Reason: Msg, delegate: self)
       
    }
    
    @objc func MaterialRejectButtonAction(sender : UIButton)
    {
        print("Material Reject Status Page..")
        MaterialRejectButtonContent()
    }
    
    @objc func MeasureApproveButtonAction(sender : UIButton)
    {
        print("Measure Approve Status Page..")
        
        let AppointID = MeasurementAppointID[0] as! Int
        let Msg = ""
        self.serviceCall.API_IsApproveAppointmentMeasurement(AppointmentId: AppointID, IsApproved: 1, Reason: Msg, delegate: self)
    }
    
    @objc func MeasureRejectButtonAction(sender : UIButton)
    {
        print("Measure Reject Status Page..")
        
        MeasureRejectButtonContent()
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
    
    func MaterialRejectButtonContent()
    {
        MaterialRejectButtonView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        MaterialRejectButtonView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        view.addSubview(MaterialRejectButtonView)
        
        let RejectView = UIView()
        RejectView.frame = CGRect(x: 0, y: (MaterialRejectButtonView.frame.height / 2 ) - (5 * y) , width: view.frame.width, height: (10 * y))
        RejectView.backgroundColor = UIColor.white
        MaterialRejectButtonView.addSubview(RejectView)
        
       // let Material_rejectReason_TF = UITextField()
        Material_rejectReason_TF.frame = CGRect(x: x, y: RejectView.frame.minY, width: RejectView.frame.width - (2 * x), height: (6 * y))
       // Material_rejectReason_TF.backgroundColor = UIColor.gray
        Material_rejectReason_TF.placeholder = "please Mention your reason for rejecting.."
        Material_rejectReason_TF.textColor = UIColor.black
        Material_rejectReason_TF.textAlignment = .left
        Material_rejectReason_TF.contentVerticalAlignment = .top
        Material_rejectReason_TF.font = UIFont(name: "Avenir Next", size: 1.5 * x)
        MaterialRejectButtonView.addSubview(Material_rejectReason_TF)
        
        let CancelButton = UIButton()
        CancelButton.frame = CGRect(x: (2 * x), y: Material_rejectReason_TF.frame.maxY + y , width: (10 * x), height: (2 * y))
        CancelButton.backgroundColor = UIColor.lightGray
        CancelButton.setTitle("Cancel", for: .normal)
        CancelButton.setTitleColor(UIColor.white, for: .normal)
        CancelButton.layer.borderColor = UIColor.lightGray.cgColor
        CancelButton.layer.borderWidth = 1.0
        CancelButton.layer.cornerRadius = 10
        CancelButton.addTarget(self, action: #selector(self.Material_CancelButtonAction(sender:)), for: .touchUpInside)
        CancelButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.2 * x)!
        MaterialRejectButtonView.addSubview(CancelButton)
        
        let saveButton = UIButton()
        saveButton.frame = CGRect(x: CancelButton.frame.maxX + (12 * x), y: Material_rejectReason_TF.frame.maxY + y, width: (10 * x), height: (2 * y))
        saveButton.backgroundColor = UIColor.blue
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.layer.borderColor = UIColor.lightGray.cgColor
        saveButton.layer.borderWidth = 1.0
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(self.Save_MaterialRejectAction(sender:)), for: .touchUpInside)
        saveButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.2 * x)!
        MaterialRejectButtonView.addSubview(saveButton)
        
    }
    
    func MeasureRejectButtonContent()
    {
        MeasureRejectButtonView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        MeasureRejectButtonView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        view.addSubview(MeasureRejectButtonView)
        
        let RejectView = UIView()
        RejectView.frame = CGRect(x: 0, y: (MeasureRejectButtonView.frame.height / 2 ) - (5 * y) , width: view.frame.width, height: (10 * y))
        RejectView.backgroundColor = UIColor.white
        MeasureRejectButtonView.addSubview(RejectView)
        
        // let Measure_rejectReason_TF = UITextField()
        Measure_rejectReason_TF.frame = CGRect(x: x, y: RejectView.frame.minY, width: RejectView.frame.width - (2 * x), height: (6 * y))
        // Measure_rejectReason_TF.backgroundColor = UIColor.gray
        Measure_rejectReason_TF.placeholder = "please Mention your reason for rejecting.."
        Measure_rejectReason_TF.textColor = UIColor.black
        Measure_rejectReason_TF.textAlignment = .left
        Measure_rejectReason_TF.contentVerticalAlignment = .top
        Measure_rejectReason_TF.font = UIFont(name: "Avenir Next", size: 1.5 * x)
        MeasureRejectButtonView.addSubview(Measure_rejectReason_TF)
        
        let CancelButton = UIButton()
        CancelButton.frame = CGRect(x: (2 * x), y: Measure_rejectReason_TF.frame.maxY + y , width: (10 * x), height: (2 * y))
        CancelButton.backgroundColor = UIColor.lightGray
        CancelButton.setTitle("Cancel", for: .normal)
        CancelButton.setTitleColor(UIColor.white, for: .normal)
        CancelButton.layer.borderColor = UIColor.lightGray.cgColor
        CancelButton.layer.borderWidth = 1.0
        CancelButton.layer.cornerRadius = 10
        CancelButton.addTarget(self, action: #selector(self.Measure_CancelButtonAction(sender:)), for: .touchUpInside)
        CancelButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.2 * x)!
        MeasureRejectButtonView.addSubview(CancelButton)
        
        let saveButton = UIButton()
        saveButton.frame = CGRect(x: CancelButton.frame.maxX + (12 * x), y: Measure_rejectReason_TF.frame.maxY + y, width: (10 * x), height: (2 * y))
        saveButton.backgroundColor = UIColor.blue
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.layer.borderColor = UIColor.lightGray.cgColor
        saveButton.layer.borderWidth = 1.0
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(self.Save_MeasureRejectAction(sender:)), for: .touchUpInside)
        saveButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.2 * x)!
        MeasureRejectButtonView.addSubview(saveButton)
        
    }
    
    
    @objc func RescheduleButtonAction(sender : UIButton)
    {
        AppointmentSelectionView.removeFromSuperview()
    }
    
    @objc func Measure_CancelButtonAction(sender : UIButton)
    {
        MeasureRejectButtonView.removeFromSuperview()
    }
    
    @objc func Material_CancelButtonAction(sender : UIButton)
    {
        MaterialRejectButtonView.removeFromSuperview()
    }
    
    @objc func Save_MaterialRejectAction(sender : UIButton)
    {
        MaterialRejectButtonView.removeFromSuperview()
        
        let AppointID = MaterialAppointID[0] as! Int
        let Msg : String = self.Material_rejectReason_TF.text!
        self.serviceCall.API_IsApproveAppointmentMaterial(AppointmentId: AppointID, IsApproved: 2, Reason: Msg, delegate: self)
    }
    
    @objc func Save_MeasureRejectAction(sender : UIButton)
    {
        MeasureRejectButtonView.removeFromSuperview()
        
        let AppointID = MeasurementAppointID[0] as! Int
        let Msg : String = self.Measure_rejectReason_TF.text!
        self.serviceCall.API_IsApproveAppointmentMeasurement(AppointmentId: AppointID, IsApproved: 2, Reason: Msg, delegate: self)
    }
    
    @objc func FMaterial_calendarAction()
    {
        FMaterial_pickUpDate(From_MaterialType_TF)
    }
    @objc func TMaterial_calendarAction()
    {
        TMaterial_pickUpDate(TO_MaterialType_TF)
    }
    @objc func SlotMaterial_calendarAction()
    {
        SlotMaterial_pickUpDate(SLOT_MaterialType_TF)
    }
    @objc func SlotMeasure_calendarAction()
    {
        SlotMeasure_pickUpDate(SLOT_MeasurementType_TF)
    }
    @objc func FMeasurement_calendarAction()
    {
        FMeasurement_pickUpDate(From_MeasurementType_TF)
    }
    @objc func TMeasurement_calendarAction()
    {
        TMeasurement_pickUpDate(TO_MeasurementType_TF)
    }
    
    func FMaterial_pickUpDate(_ textField : UITextField)
    {
        
        // Material DatePicker
        self.Material_FromDatePick = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.Material_FromDatePick.backgroundColor = UIColor.white
        self.Material_FromDatePick.datePickerMode = UIDatePicker.Mode.date
        self.Material_FromDatePick.minimumDate = Date()
        textField.inputView = self.Material_FromDatePick
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.FMaterial_DoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    func TMaterial_pickUpDate(_ textField : UITextField)
    {
        // Material DatePicker
        self.Material_ToDatePick = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.Material_ToDatePick.backgroundColor = UIColor.white
        self.Material_ToDatePick.datePickerMode = UIDatePicker.Mode.date
        self.Material_ToDatePick.minimumDate = Date()
        textField.inputView = self.Material_ToDatePick
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.TMaterial_DoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    func SlotMaterial_pickUpDate(_ textField : UITextField)
    {
        // Slot Picker Material..
        self.Material_TimeSlotPick = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.Material_TimeSlotPick.backgroundColor = UIColor.white
       
        textField.inputView = self.Material_TimeSlotPick
        
        Material_TimeSlotPick.showsSelectionIndicator = true
        Material_TimeSlotPick.delegate = self
        Material_TimeSlotPick.dataSource = self
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.SlotMaterial_DoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolBar
    }
    func SlotMeasure_pickUpDate(_ textField : UITextField)
    {
        // Slot Picker Measure..
        self.Measure_TimeSlotPick = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.Measure_TimeSlotPick.backgroundColor = UIColor.white
        
        textField.inputView = self.Measure_TimeSlotPick
        
        Measure_TimeSlotPick.showsSelectionIndicator = true
        Measure_TimeSlotPick.delegate = self
        Measure_TimeSlotPick.dataSource = self
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.SlotMeasure_DoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolBar
    }
    func FMeasurement_pickUpDate(_ textField : UITextField)
    {
        // Measure DatePicker
        self.Measure_FromDatePick = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.Measure_FromDatePick.backgroundColor = UIColor.white
        self.Measure_FromDatePick.datePickerMode = UIDatePicker.Mode.date
        self.Measure_FromDatePick.minimumDate = Date()
        textField.inputView = self.Measure_FromDatePick
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.FMeasurement_DoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    func TMeasurement_pickUpDate(_ textField : UITextField)
    {
        // Measure DatePicker
        self.Measure_ToDatePick = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.Measure_ToDatePick.backgroundColor = UIColor.white
        self.Measure_ToDatePick.datePickerMode = UIDatePicker.Mode.date
        self.Measure_ToDatePick.minimumDate = Date()
        textField.inputView = self.Measure_ToDatePick
        
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.TMeasurement_DoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    @objc func FMaterial_DoneClick()
    {
        let FromMaterial_dateFormatter = DateFormatter()
        FromMaterial_dateFormatter.dateStyle = .medium
        FromMaterial_dateFormatter.timeStyle = .none
        FromMaterial_dateFormatter.dateFormat = "dd/MM/yyyy"  //"yyyy/MM/dd"
        From_MaterialType_TF.text = FromMaterial_dateFormatter.string(from: Material_FromDatePick.date)
        From_MaterialType_TF.resignFirstResponder()
        
    }
    @objc func TMaterial_DoneClick()
    {
        let ToMaterial_dateFormatter = DateFormatter()
        ToMaterial_dateFormatter.dateStyle = .medium
        ToMaterial_dateFormatter.timeStyle = .none
        ToMaterial_dateFormatter.dateFormat = "dd/MM/yyyy"  //"yyyy/MM/dd"
        TO_MaterialType_TF.text = ToMaterial_dateFormatter.string(from: Material_ToDatePick.date)
        TO_MaterialType_TF.resignFirstResponder()
        
    }
    @objc func SlotMaterial_DoneClick()
    {
        SLOT_MaterialType_TF.resignFirstResponder()
    }
    @objc func SlotMeasure_DoneClick()
    {
        SLOT_MeasurementType_TF.resignFirstResponder()
    }
    @objc func FMeasurement_DoneClick()
    {
        let FromMeasure_dateFormatter = DateFormatter()
        FromMeasure_dateFormatter.dateStyle = .medium
        FromMeasure_dateFormatter.timeStyle = .none
        FromMeasure_dateFormatter.dateFormat = "dd/MM/yyyy"  //"yyyy/MM/dd"
        From_MeasurementType_TF.text = FromMeasure_dateFormatter.string(from: Measure_FromDatePick.date)
        From_MeasurementType_TF.resignFirstResponder()
        
    }
    @objc func TMeasurement_DoneClick()
    {
        
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
        SLOT_MaterialType_TF.resignFirstResponder()
        
        From_MeasurementType_TF.resignFirstResponder()
        TO_MeasurementType_TF.resignFirstResponder()
        SLOT_MeasurementType_TF.resignFirstResponder()
    }
    
    // PickerView Delegate Methods..
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return TimeSlotArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return TimeSlotArray[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == Material_TimeSlotPick
        {
          SLOT_MaterialType_TF.text = TimeSlotArray[row] as? String
        }
        else if pickerView == Measure_TimeSlotPick
        {
          SLOT_MeasurementType_TF.text = TimeSlotArray[row] as? String
        }
    }

    @objc func Material_SaveButtonAction(sender : UIButton)
    {
        print("Material Save Action..")
        var Mat_OrderID : Int!
        let SlotStr : String = self.SLOT_MaterialType_TF.text!
       // var Slot : Int! =  "\(SlotStr)" as Int!
       
        if(MaterialOrderID.count > 0)
        {
            Mat_OrderID = MaterialOrderID[0] as? Int
        }
        
        let FMaterial : String = self.From_MaterialType_TF.text!
        let TMaterial : String = self.TO_MaterialType_TF.text!
        
        
        if (FMaterial.isEmpty || TMaterial.isEmpty)
        {
            print("Dates are Empty")
        }
        else
        {
            self.serviceCall.API_InsertAppoinmentMaterial(OrderId: Mat_OrderID, AppointmentType: 1, AppointmentTime: SlotStr, From: FMaterial, To: TMaterial, Type: "Customer", CreatedBy:"Customer", delegate: self)
        }
    }
    
    @objc func Measure_SaveButtonAction(sender : UIButton)
    {
        print("Measure Save Action..")
        var Msr_OrderID : Int!
        let SlotStr : String = self.SLOT_MeasurementType_TF.text!
        
        if(MeasurementOrderID.count > 0)
        {
           Msr_OrderID = MeasurementOrderID[0] as? Int
        }
       
        let FMeasure : String = self.From_MeasurementType_TF.text!
        let TMeasure : String = self.TO_MeasurementType_TF.text!
        
        
        if (FMeasure.isEmpty || TMeasure.isEmpty)
        {
            print("Dates are Empty")
        }
        else
        {
          self.serviceCall.API_InsertAppoinmentMeasurement(OrderId: Msr_OrderID, AppointmentType: 2, AppointmentTime:  SlotStr, From: FMeasure, To: TMeasure, Type: "Customer", CreatedBy: "Customer", delegate: self)
        }
    }
    
}
