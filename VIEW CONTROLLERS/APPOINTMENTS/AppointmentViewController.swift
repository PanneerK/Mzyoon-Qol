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
    
      let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()

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
    var TailorID:Int!
    
    var TotalAmount:String!
    var MeasureSucessStr:String!
    var MaterialSucessStr:String!
    
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
    var materialInArabic = NSArray()
    var MaterailHeaderImage = NSArray()
    var MaterialBodyImage = NSArray()
    var MaterialAppointID = NSArray()
    var MaterialOrderID = NSArray()
    var MaterialPayment = NSArray()
    
    var MaterialFromDtArr = NSArray()
    var MaterialToDtArr = NSArray()
    var MaterialAppointTimeArr = NSArray()
    
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
    var measurementInArabic = NSArray()
    var MeasurementHeaderImage = NSArray()
    var MeasurementBodyImage = NSArray()
    var MeasurementAppointID = NSArray()
    var MeasurementOrderID = NSArray()
    var MeasurementPayment = NSArray()
    
    var MeasureFromDtArr = NSArray()
    var MeasureToDtArr = NSArray()
    var MeasureAppointTimeArr = NSArray()
    
    var Material_rejectReason_TF = UITextField()
    var Measure_rejectReason_TF = UITextField()
    
     let emptyLabel = UILabel()
    
    var applicationDelegate = AppDelegate()

    var MaterialFromDate = String()
    var MaterialToDate = String()
    var MeasureFromDate = String()
    var MeasureToDate = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
 
        navigationBar.isHidden = true
        slideMenuButton.isHidden = true
        
        selectedButton(tag: 1)
        
        // Do any additional setup after loading the view.
       
     //  AppointmentContent()
        
        print("TailorID:",TailorID)
        print("View DidLoad")
        
         UserDefaults.standard.set(TailorID, forKey: "TailorID")
        
         print("order ID:", OrderID)
        
        if(OrderID != nil)
        {
            self.serviceCall.API_GetAppointmentMaterial(OrderId: OrderID, delegate: self)
        }
     
        
     /*
        if let order_Id = UserDefaults.standard.value(forKey: "OrderID") as? Int
        {
            
            // Material Details like image,Heading etc..
            self.serviceCall.API_GetAppointmentMaterial(OrderId: order_Id, delegate: self)
            
            // Measurement Details like image,Heading etc..
           // self.serviceCall.API_GetAppointmentMeasurement(OrderId: order_Id, delegate: self)
            
            // Material Dates from Tailor..
           // self.serviceCall.API_GetAppointmentDateForMaterail(OrderId: order_Id, delegate: self)
            
            // Measurement Dates from Tailor..
           // self.serviceCall.API_GetAppointmentDateForMeasurement(OrderId: order_Id, delegate: self)
            
        }
    */
        
        TimeSlotArray = ["6.00 A.M  to  8.00 A.M","8.00 A.M  to  10.00 A.M","10.00 A.M  to  12.00 P.M","12.00 P.M  to  2.00 P.M","2.00 A.M  to  4.00 P.M","4.00 P.M  to  6.00 P.M","6.00 P.M  to  8.00 P.M","8.00 P.M  to  10.00 P.M","10.00 P.M  to  12.00 P.M"]
        
        MeasureSucessStr = ""
        MaterialSucessStr = ""
        
    }
 
    override func viewWillAppear(_ animated: Bool)
    {
         print("View WillAppear")
        
        let navigationArray = self.navigationController?.viewControllers
        print("viewControllers Aray:",navigationArray!)
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
         stopActivity()
         applicationDelegate.exitContents()
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
            
            MaterialSucessStr = "True"
            
            let appointmentAlert = UIAlertController(title: "Sucess..!", message: "Appointment: \(Result)", preferredStyle:  .alert)
            appointmentAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: proceedAlertAction(action:)))
           // appointmentAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
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
            
            MeasureSucessStr = "True"
            
            let appointmentAlert = UIAlertController(title: "Sucess..!", message: "Appointment: \(Result)", preferredStyle: .alert)
            appointmentAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: proceedAlertAction(action:)))
           // appointmentAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
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
    
    // Material Details API...
    func API_CALLBACK_GetAppointmentMaterial(getAppointmentMaterial: NSDictionary)
    {
        let ResponseMsg = getAppointmentMaterial.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = getAppointmentMaterial.object(forKey: "Result") as! NSArray
            print("Result", Result)
            
            if Result.count == 0
            {
                emptyLabel.frame = CGRect(x: 0, y: ((view.frame.height - (3 * y)) / 2), width: view.frame.width, height: (3 * y))
                emptyLabel.text = "You don't have any Appointment request"
                emptyLabel.textColor = UIColor.black
                emptyLabel.textAlignment = .center
                emptyLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
                emptyLabel.font = emptyLabel.font.withSize(1.5 * x)
                view.addSubview(emptyLabel)
            }
            
            MaterialBodyImage = Result.value(forKey:"BodyImage") as! NSArray
            print("Body Image:",MaterialBodyImage)
            
            MaterialAppointID = Result.value(forKey:"AppointmentId") as! NSArray
            print("Appointment ID:",MaterialAppointID)
            
            MaterailHeaderImage = Result.value(forKey:"HeaderImage") as! NSArray
            print("Header Image:",MaterailHeaderImage)
            
            MaterialInEnglish = Result.value(forKey:"HeaderInEnglish") as! NSArray
             print("Header Name:",MaterialInEnglish)
            
            materialInArabic = Result.value(forKey: "HeaderInArabic") as! NSArray
            print("materialInArabic", materialInArabic)
            
            MaterialOrderID = Result.value(forKey:"OrderId") as! NSArray
             print("Order ID:",MaterialOrderID)
            
            MaterialStatus = Result.value(forKey:"status") as! NSArray
            print("status:",MaterialStatus)
            
            MaterialPayment = Result.value(forKey:"Payment") as! NSArray
            print("MaterialPayment:",MaterialPayment)
            
            if(OrderID != nil)
            {
                self.serviceCall.API_GetAppointmentMeasurement(OrderId: OrderID, delegate: self)
                
                self.serviceCall.API_GetAppointmentDateForMaterail(OrderId: OrderID, delegate: self)
            }
            /*
            if let order_Id = UserDefaults.standard.value(forKey: "OrderID") as? Int
            {
             // Measurement Details like image,Heading etc..
             self.serviceCall.API_GetAppointmentMeasurement(OrderId: order_Id, delegate: self)
                
             self.serviceCall.API_GetAppointmentDateForMaterail(OrderId: order_Id, delegate: self)
            }
          */
         //   AppointmentContent()
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = getAppointmentMaterial.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetCustomerInAppoinmentMeaterial"
            ErrorStr = Result
            
            DeviceError()
            
            emptyLabel.frame = CGRect(x: 0, y: ((view.frame.height - (3 * y)) / 2), width: view.frame.width, height: (3 * y))
            emptyLabel.text = "You don't have any Appointment request"
            emptyLabel.textColor = UIColor.black
            emptyLabel.textAlignment = .center
            emptyLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
            emptyLabel.font = emptyLabel.font.withSize(1.5 * x)
            view.addSubview(emptyLabel)
            
        }
        
         //  AppointmentContent()
        
    }
    
    // Measurement Details API...
    func API_CALLBACK_GetAppointmentMeasurement(getAppointmentMeasure: NSDictionary)
    {
        let ResponseMsg = getAppointmentMeasure.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = getAppointmentMeasure.object(forKey: "Result") as! NSArray
            print("Result", Result)
           
            if Result.count == 0
            {
                emptyLabel.frame = CGRect(x: 0, y: ((view.frame.height - (3 * y)) / 2), width: view.frame.width, height: (3 * y))
                emptyLabel.text = "You don't have any Appointment request"
                emptyLabel.textColor = UIColor.black
                emptyLabel.textAlignment = .center
                emptyLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
                emptyLabel.font = emptyLabel.font.withSize(1.5 * x)
                view.addSubview(emptyLabel)
            }
            
            MeasurementBodyImage = Result.value(forKey:"BodyImage") as! NSArray
            print("Body Image:",MeasurementBodyImage)
            
            MeasurementAppointID = Result.value(forKey:"AppointmentId") as! NSArray
            print("Appointment ID:",MeasurementAppointID)
            
         //   MeasurementHeaderImage = Result.value(forKey:"HeaderImage") as! NSArray
          //  print("Header Image:",MeasurementHeaderImage)
            
            MeasurementInEnglish = Result.value(forKey:"MeasurementInEnglish") as! NSArray
            print("Header Name:",MeasurementInEnglish)
            
            measurementInArabic = Result.value(forKey: "MeasurementInArabic") as! NSArray
            print("measurementInArabic", measurementInArabic)
            
            MeasurementOrderID = Result.value(forKey:"OrderId") as! NSArray
            print("Order ID:",MeasurementOrderID)
            
            MeasureStatus = Result.value(forKey:"Status") as! NSArray
            print("status:",MeasureStatus)
            
            MeasurementPayment = Result.value(forKey:"Payment") as! NSArray
            print("MeasurementPayment:",MeasurementPayment)
            
            
            if(OrderID != nil)
            {
                self.serviceCall.API_GetAppointmentDateForMeasurement(OrderId: OrderID, delegate: self)
            }
           
           /*
             if let order_Id = UserDefaults.standard.value(forKey: "OrderID") as? Int
             {
              // Measurement Dates from Tailor..
               self.serviceCall.API_GetAppointmentDateForMeasurement(OrderId: order_Id, delegate: self)
             }
           */
            
             AppointmentContent()
        }
        else if ResponseMsg == "Failure"
        {
            let Result = getAppointmentMeasure.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetCustomerInAppoinmentMeasurement"
            ErrorStr = Result
            
            DeviceError()
            
            emptyLabel.frame = CGRect(x: 0, y: ((view.frame.height - (3 * y)) / 2), width: view.frame.width, height: (3 * y))
            emptyLabel.text = "You don't have any Appointment request"
            emptyLabel.textColor = UIColor.black
            emptyLabel.textAlignment = .center
            emptyLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
            emptyLabel.font = emptyLabel.font.withSize(1.5 * x)
            view.addSubview(emptyLabel)
            
        }
        
      //  AppointmentContent()
    }
    
    func API_CALLBACK_IsApproveAptMaterial(IsApproveMaterial: NSDictionary)
    {
        let ResponseMsg = IsApproveMaterial.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = IsApproveMaterial.object(forKey: "Result") as! String
            print("Result", Result)
            
            MaterialSucessStr = "True"
            
            let appointmentAlert = UIAlertController(title: "Sucess..!", message: "Appointment Approved", preferredStyle: .alert)
            appointmentAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: proceedAlertAction(action:)))
            // appointmentAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(appointmentAlert, animated: true, completion: nil)
            
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
            let Result = IsApproveMeasure.object(forKey: "Result") as! String
            print("Result", Result)
            
            MeasureSucessStr = "True"
            
            let appointmentAlert = UIAlertController(title: "Sucess..!", message: "Appointment Approved", preferredStyle: .alert)
            appointmentAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: proceedAlertAction(action:)))
            // appointmentAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(appointmentAlert, animated: true, completion: nil)
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
    
    // Material Dates API...
    func API_CALLBACK_GetAppointmentDateForMaterail(MaterialDate: NSDictionary)
    {
        let ResponseMsg = MaterialDate.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = MaterialDate.object(forKey: "Result") as! NSArray
            print("Material Dates From Tailor Result:", Result)
            
            MaterialFromDtArr = Result.value(forKey: "FromDt") as! NSArray
            print("MaterialFromDtArr:",MaterialFromDtArr)
            
            MaterialToDtArr = Result.value(forKey: "ToDt") as! NSArray
            print("MaterialToDtArr:",MaterialToDtArr)
            
            MaterialAppointTimeArr = Result.value(forKey: "AppointmentTime") as! NSArray
            print("MaterialAppointTimeArr:",MaterialAppointTimeArr)
          
                
           if MaterialInEnglish.contains("Own Material-Direct Delivery")
           {
              if(MaterialFromDtArr.count > 0)
              {
                 From_MaterialType_TF.text = MaterialFromDtArr[0] as? String
              }
            
            if(MaterialToDtArr.count > 0)
            {
                TO_MaterialType_TF.text = MaterialToDtArr[0] as? String
            }
            
            if(MaterialAppointTimeArr.count > 0)
            {
               SLOT_MaterialType_TF.text = MaterialAppointTimeArr[0] as? String
            }
            
           }
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = MaterialDate.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetAppointmentDateForMaterail"
            ErrorStr = Result
            
            DeviceError()
            
        }
        
      //  AppointmentContent()
        
    }
    
    // Measurement Dates API...
    func API_CALLBACK_GetAppointmentDateForMeasurement(MeasurementDate: NSDictionary)
    {
        let ResponseMsg = MeasurementDate.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = MeasurementDate.object(forKey: "Result") as! NSArray
            print("Measurement Dates From Tailor Result", Result)
            
            MeasureFromDtArr = Result.value(forKey: "FromDt") as! NSArray
            print("MeasureFromDtArr:",MeasureFromDtArr)
            
            MeasureToDtArr = Result.value(forKey: "ToDt") as! NSArray
            print("MeasureToDtArr:",MeasureToDtArr)
            
            MeasureAppointTimeArr = Result.value(forKey: "AppointmentTime") as! NSArray
            print("MeasureAppointTimeArr:",MeasureAppointTimeArr)
            
           if MeasurementInEnglish.contains("Go to Tailor Shop")
           {
             if(MeasureFromDtArr.count > 0)
             {
                From_MeasurementType_TF.text = MeasureFromDtArr[0] as? String
             }
            
            if(MeasureToDtArr.count > 0)
            {
              TO_MeasurementType_TF.text = MeasureToDtArr[0] as? String
            }
          
            if(MeasureAppointTimeArr.count > 0)
            {
              SLOT_MeasurementType_TF.text = MeasureAppointTimeArr[0] as? String
            }
          }
         
        }
        else if ResponseMsg == "Failure"
        {
            let Result = MeasurementDate.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetAppointmentDateForMeasurement"
            ErrorStr = Result
            
            DeviceError()
        }
        
        // AppointmentContent()
    }
    
    func proceedAlertAction(action : UIAlertAction)
    {
        
        if (MaterialSucessStr == "True" && MeasureSucessStr == "True")
        {
            if (MaterialPayment.contains("Not Paid") && MeasurementPayment.contains("Not Paid"))
            {
                let PayScreen = PaymentViewController()
                PayScreen.TailorId = TailorID
                PayScreen.TotalAmount = TotalAmount
                self.navigationController?.pushViewController(PayScreen, animated: true)
            }
            else
            {
                window = UIWindow(frame: UIScreen.main.bounds)
                let loginScreen = HomeViewController()
                let navigationScreen = UINavigationController(rootViewController: loginScreen)
                navigationScreen.isNavigationBarHidden = true
                window?.rootViewController = navigationScreen
                window?.makeKeyAndVisible()
            }
        }
       
    }
    
    func changeViewToArabicInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.text = "موعد"
        
        AppointmentScrollview.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.text = "APPOINTMENT"
        
        AppointmentScrollview.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    func AppointmentContent()
    {
        self.stopActivity()
        
       // let AppointmentNavigationBar = UIView()
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
        selfScreenNavigationTitle.text = "APPOINTMENT"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: (2 * x))
        selfScreenNavigationTitle.font = selfScreenNavigationTitle.font.withSize(2 * x)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
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
        
        AppointmentTypeView()
    }
    
    func AppointmentTypeView()
    {
        var y2:CGFloat = y/2
        //ScrollView..
        
        //let AppointmentScrollview = UIScrollView()
        AppointmentScrollview.frame = CGRect(x: 0, y: selfScreenNavigationBar.frame.maxY, width: view.frame.width, height: view.frame.height - (12 * y))
        AppointmentScrollview.backgroundColor = UIColor.clear
        view.addSubview(AppointmentScrollview)
        
 //----------------------------------------OrderType View---------------------------------------------------------------
        
        // OrderType View..
       
        
        if MaterialInEnglish.contains("Companies-Material")
        {
            OrderTypeView.removeFromSuperview()
            MaterialSucessStr = "True"
        }
        else if MaterialInEnglish.contains("Own Material-Direct Delivery")
        {
            OrderTypeView.frame = CGRect(x: x/2, y: y2, width: view.frame.width - x, height: (40 * y))
            //   OrderTypeView.backgroundColor = UIColor.lightGray
            OrderTypeView.layer.borderWidth = 1
            OrderTypeView.layer.borderColor = UIColor(red:0.05, green:0.17, blue:0.46, alpha:1.0).cgColor
            AppointmentScrollview.addSubview(OrderTypeView)
            y2 = OrderTypeView.frame.maxY + y/2
        }
        else
        {
            OrderTypeView.frame = CGRect(x: x/2, y: y2, width: view.frame.width - x, height: (40 * y))
            //   OrderTypeView.backgroundColor = UIColor.lightGray
            OrderTypeView.layer.borderWidth = 1
            OrderTypeView.layer.borderColor = UIColor(red:0.05, green:0.17, blue:0.46, alpha:1.0).cgColor
            AppointmentScrollview.addSubview(OrderTypeView)
            y2 = OrderTypeView.frame.maxY + y/2
        }
        
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
      
        
 // -------------------------------AppointmentStatusView---------------------
        
        let Material_AppointmentStatusView = UIView()
       // Material_AppointmentStatusView.frame = CGRect(x: ((view.frame.width - (2 * x)) / 2), y: orderTypeLabel.frame.maxY + (2 * y), width: (19 * x), height: (2 * y))
        Material_AppointmentStatusView.frame = CGRect(x: ((view.frame.width - (7 * x)) / 2), y: orderTypeLabel.frame.maxY + (2 * y), width: (19 * x), height: (2 * y))
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
           if(MaterialStatus.contains("Not Approved"))
           {
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    Material_StatusBtn.setTitle("Pending", for: .normal)
                }
                else if language == "ar"
                {
                    Material_StatusBtn.setTitle("قيد الانتظار", for: .normal)
                }
            }
            else
            {
                Material_StatusBtn.setTitle("Pending", for: .normal)
            }
           }
           else
           {
             if(MaterialStatus.count == 1)
             {
               Material_StatusBtn.setTitle("\(MaterialStatus[0])", for: .normal)
             }
             else if(MaterialStatus.count == 2)
             {
               Material_StatusBtn.setTitle("\(MaterialStatus[1])", for: .normal)
             }
             else if(MaterialStatus.count == 3)
             {
                Material_StatusBtn.setTitle("\(MaterialStatus[2])", for: .normal)
             }
           }
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
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/OrderType/\(imageName)"
            print("Order Type - Header Image", api)
            let apiurl = URL(string: api)
            if apiurl != nil
            {
                courierDeliveryIcon.dowloadFromServer(url: apiurl!)
            }
        }
      }
       OrderTypeView.addSubview(courierDeliveryIcon)
        
        let couriertDeliveryLabel = UILabel()
        couriertDeliveryLabel.frame = CGRect(x: courierDeliveryIcon.frame.maxX + x, y: Material_AppointmentStatusView.frame.maxY + y, width: view.frame.width - (5 * x), height: (2 * y))
        if(MaterialInEnglish.count > 0)
        {
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    couriertDeliveryLabel.text = MaterialInEnglish[0] as? String
                }
                else if language == "ar"
                {
                    couriertDeliveryLabel.text = materialInArabic[0] as? String
                }
            }
            else
            {
                couriertDeliveryLabel.text = MaterialInEnglish[0] as? String
            }
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
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/OrderType/\(imageName)"
            print("Order Type - Body Image", api)
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: courierImageView.frame.width, height: courierImageView.frame.height)
            if apiurl != nil{
                dummyImageView.dowloadFromServer(url: apiurl!)
            }
            courierImageView.addSubview(dummyImageView)
        }
         OrderTypeView.addSubview(courierImageView)
      }
       
        
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
        FromDateView.frame = CGRect(x: (3 * x), y: From_OrderTypeLBL.frame.maxY, width: courierImageView.frame.width / 2, height: (3.5 * y))
        FromDateView.backgroundColor = UIColor(red:0.05, green:0.17, blue:0.46, alpha:1.0)
        OrderTypeView.addSubview(FromDateView)
        
        // FromDate Icon..
        let FromDateMatrl_Icon = UIImageView()
        FromDateMatrl_Icon.frame = CGRect(x: 1, y: (y/2) - 4, width:(2 * x), height: (2 * y))
        //FromDateMatrl_Icon.backgroundColor = UIColor.white
        FromDateMatrl_Icon.image = UIImage(named: "OrderDate_WH")
       // FromDateView.addSubview(FromDateMatrl_Icon)
        
        //let From_MaterialType_TF = UITextField()
        From_MaterialType_TF.frame = CGRect(x: FromDateMatrl_Icon.frame.maxX, y: (y/2) - 4, width: (10 * x) , height: (3.5 * y))
        From_MaterialType_TF.attributedPlaceholder = NSAttributedString(string: "Date",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        From_MaterialType_TF.textColor = UIColor.white
        From_MaterialType_TF.textAlignment = .center
        From_MaterialType_TF.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        From_MaterialType_TF.adjustsFontSizeToFitWidth = true
        //From_MaterialType_TF.backgroundColor = UIColor.gray
        if MaterialInEnglish.contains("Own Material-Direct Delivery")
        {
           From_MaterialType_TF.isUserInteractionEnabled = false
        }
        else
        {
            From_MaterialType_TF.isUserInteractionEnabled = true
        }
        From_MaterialType_TF.addTarget(self, action: #selector(self.FMaterial_calendarAction), for: .allEditingEvents)
        From_MaterialType_TF.delegate = self as? UITextFieldDelegate
        FromDateView.addSubview(From_MaterialType_TF)
        
        // Edit icon..
        let FromDateEditMatrl_Icon = UIImageView()
        FromDateEditMatrl_Icon.frame = CGRect(x: From_MaterialType_TF.frame.maxX, y: (y/2) - 4, width:(2 * x), height: (1.5 * y))
        //FromDateEditMatrl_Icon.backgroundColor = UIColor.white
        FromDateEditMatrl_Icon.image = UIImage(named: "OrderDate_WH")
        //FromDateView.addSubview(FromDateEditMatrl_Icon)
 
        
     //-----------------OrderType ToDate View----------------------------
        
        //ToDateView
        let ToDateView = UIView()
        ToDateView.frame = CGRect(x: FromDateView.frame.maxX + 1, y: TO_OrderTypeLBL.frame.maxY, width: courierImageView.frame.width / 2, height: (3.5 * y))
        ToDateView.backgroundColor = UIColor(red:0.10, green:0.30, blue:0.76, alpha:1.0)
        OrderTypeView.addSubview(ToDateView)
        
        // ToDAteIcon..
        let ToDateMatrl_Icon = UIImageView()
        ToDateMatrl_Icon.frame = CGRect(x: 1, y: (y/2) - 4, width:(2 * x), height: (2 * y))
        //ToDateMatrl_Icon.backgroundColor = UIColor.white
        ToDateMatrl_Icon.image = UIImage(named: "OrderDate_WH")
        // ToDateView.addSubview(ToDateMatrl_Icon)
        
       // let TO_MaterialType_TF = UITextField()
        TO_MaterialType_TF.frame = CGRect(x: ToDateMatrl_Icon.frame.maxX , y: (y/2) - 4, width: (10 * x), height: (3.5 * y))
        TO_MaterialType_TF.attributedPlaceholder = NSAttributedString(string: "Date",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        TO_MaterialType_TF.textColor = UIColor.white
        TO_MaterialType_TF.textAlignment = .center
        TO_MaterialType_TF.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        TO_MaterialType_TF.adjustsFontSizeToFitWidth = true
       // TO_MaterialType_TF.backgroundColor = UIColor.gray  //UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        if MaterialInEnglish.contains("Own Material-Direct Delivery")
        {
            TO_MaterialType_TF.isUserInteractionEnabled = false
        }
        else
        {
            TO_MaterialType_TF.isUserInteractionEnabled = true
        }
        TO_MaterialType_TF.addTarget(self, action: #selector(self.TMaterial_calendarAction), for: .allEditingEvents)
        TO_MaterialType_TF.delegate = self as? UITextFieldDelegate
        ToDateView.addSubview(TO_MaterialType_TF)
        
        // Edit icon..
        let ToDateEditMatrl_Icon = UIImageView()
        ToDateEditMatrl_Icon.frame = CGRect(x: From_MaterialType_TF.frame.maxX, y: (y/2) - 4, width:(2 * x), height: (1.5 * y))
        //ToDateEditMatrl_Icon.backgroundColor = UIColor.white
        ToDateEditMatrl_Icon.image = UIImage(named: "OrderDate_WH")
        // ToDateView.addSubview(ToDateEditMatrl_Icon)
        
        
    //-----------------OrderType TimeSlot View----------------------------
        
        let Slot_MaterialTypeLBL = UILabel()
        Slot_MaterialTypeLBL.frame = CGRect(x: (3 * x), y: FromDateView.frame.maxY + y, width: (8 * x), height: (3.5 * y))
        Slot_MaterialTypeLBL.text = "TIME SLOT"
        Slot_MaterialTypeLBL.textColor = UIColor.black
        Slot_MaterialTypeLBL.textAlignment = .left
        Slot_MaterialTypeLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        Slot_MaterialTypeLBL.adjustsFontSizeToFitWidth = true
        // Slot_MaterialTypeLBL.backgroundColor = UIColor.lightGray
        OrderTypeView.addSubview(Slot_MaterialTypeLBL)
        
        
        //TimeSlotView
        let Material_TimeSlotView = UIView()
        Material_TimeSlotView.frame = CGRect(x: Slot_MaterialTypeLBL.frame.maxX, y: FromDateView.frame.maxY + y, width: (23.5 * x), height: (3.5 * y))
        Material_TimeSlotView.backgroundColor = UIColor(red:0.05, green:0.17, blue:0.46, alpha:1.0)
        OrderTypeView.addSubview(Material_TimeSlotView)
        
        // TimeMatrl_Icon..
        let TimeMatrl_Icon = UIImageView()
        TimeMatrl_Icon.frame = CGRect(x: 2, y: (y/2) - 4, width:(2 * x), height: (2 * y))
        //TimeMatrl_Icon.backgroundColor = UIColor.white
        TimeMatrl_Icon.image = UIImage(named: "OrderTime_WH")
       // Material_TimeSlotView.addSubview(TimeMatrl_Icon)
        
        // let SLOT_MaterialType_TF.frame = UITextField()
        SLOT_MaterialType_TF.frame = CGRect(x: TimeMatrl_Icon.frame.maxX, y: (y/2) - 4, width: (20 * x), height: (3.5 * y))
        SLOT_MaterialType_TF.attributedPlaceholder = NSAttributedString(string: "Time",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        SLOT_MaterialType_TF.textColor = UIColor.white
        SLOT_MaterialType_TF.textAlignment = .left
        SLOT_MaterialType_TF.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        SLOT_MaterialType_TF.adjustsFontSizeToFitWidth = true
        // SLOT_MaterialType_TF.frame.backgroundColor = UIColor.lightGray //UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        if MaterialInEnglish.contains("Own Material-Direct Delivery")
        {
            SLOT_MaterialType_TF.isUserInteractionEnabled = false
            
        }
        else
        {
            SLOT_MaterialType_TF.isUserInteractionEnabled = true
        }
        SLOT_MaterialType_TF.addTarget(self, action: #selector(self.SlotMaterial_calendarAction), for: .allEditingEvents)
        SLOT_MaterialType_TF.delegate = self as? UITextFieldDelegate
        Material_TimeSlotView.addSubview(SLOT_MaterialType_TF)
        
    //---------------Material Approve Button----------------
        
        //let Material_ApproveButton = UIButton()
        Material_ApproveButton.frame = CGRect(x: (8 * x), y: Material_TimeSlotView.frame.maxY + y, width: (10 * x), height: (3.5 * y))
        Material_ApproveButton.backgroundColor = UIColor(red:0.24, green:0.62, blue:0.24, alpha:1.0)
        Material_ApproveButton.setTitle("Approve", for: .normal)
        Material_ApproveButton.setTitleColor(UIColor.white, for: .normal)
        Material_ApproveButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.3 * x)!
        Material_ApproveButton.layer.borderColor = UIColor.lightGray.cgColor
        Material_ApproveButton.layer.borderWidth = 1.0
        Material_ApproveButton.layer.cornerRadius = 15
        Material_ApproveButton.addTarget(self, action: #selector(self.MaterialApproveButtonAction(sender:)), for: .touchUpInside)
        if MaterialInEnglish.contains("Own Material-Direct Delivery")
        {
            if (MaterialStatus.contains("Approved") && MaterialPayment.contains("Paid"))
            {
                
            }
            else
            {
             OrderTypeView.addSubview(Material_ApproveButton)
            }
        }
        else
        {
            
            
        }
        
  
    //-----------------MAterial Reject button-----------------
        
        
       // let Material_RejectButton = UIButton()
        Material_RejectButton.frame = CGRect(x: Material_ApproveButton.frame.maxX + (2 * x), y: Material_TimeSlotView.frame.maxY + y, width: (10 * x), height: (3.5 * y))
        Material_RejectButton.backgroundColor = UIColor(red:0.89, green:0.13, blue:0.11, alpha:1.0)
        Material_RejectButton.setTitle("Reject", for: .normal)
        Material_RejectButton.setTitleColor(UIColor.white, for: .normal)
        Material_RejectButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.3 * x)!
        Material_RejectButton.layer.borderColor = UIColor.lightGray.cgColor
        Material_RejectButton.layer.borderWidth = 1.0
        Material_RejectButton.layer.cornerRadius = 15
        Material_RejectButton.addTarget(self, action: #selector(self.MaterialRejectButtonAction(sender:)), for: .touchUpInside)
        if MaterialInEnglish.contains("Own Material-Direct Delivery")
        {
            if (MaterialStatus.contains("Approved") && MaterialPayment.contains("Paid"))
            {
            }
            else
            {
              OrderTypeView.addSubview(Material_RejectButton)
            }
        }
        else
        {
           
        }
        
    //-----------------Material Save Button------------------------
        
        let Material_SaveButton = UIButton()
        Material_SaveButton.frame = CGRect(x: courierImageView.frame.width - (7 * x), y: Material_RejectButton.frame.minY + y, width: (10 * x), height: (3.5 * y))
        Material_SaveButton.backgroundColor = UIColor(red:0.10, green:0.30, blue:0.76, alpha:1.0)
        Material_SaveButton.setTitle("Save", for: .normal)
        Material_SaveButton.setTitleColor(UIColor.white, for: .normal)
        Material_SaveButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.4 * x)!
        Material_SaveButton.addTarget(self, action: #selector(self.Material_SaveButtonAction(sender:)), for: .touchUpInside)
        if MaterialInEnglish.contains("Own Material-Direct Delivery")
        {
           // MaterialSucessStr = "True"
        }
        else
        {
            OrderTypeView.addSubview(Material_SaveButton)
        }
        
     
        
        
    //------------------------------------------MeasurementType View--------------------------------------------------------
        
        // MEASUREMENT_1 Type View..
        
      //  print("ROHITH", y2)

        
        if MeasurementInEnglish.contains("Manually")
        {
            MeasurementTypeView.removeFromSuperview()
             MeasureSucessStr = "True"
        }
        else if MeasurementInEnglish.contains("Go to Tailor Shop")
        {
            MeasurementTypeView.frame = CGRect(x: x/2, y: y2, width: view.frame.width - x, height: (40 * y))
            //MeasurementTypeView.backgroundColor = UIColor.darkGray
            MeasurementTypeView.layer.borderWidth = 1
            MeasurementTypeView.layer.borderColor = UIColor(red:0.05, green:0.17, blue:0.46, alpha:1.0).cgColor
            AppointmentScrollview.addSubview(MeasurementTypeView)
            
           // y2 = OrderTypeView.frame.maxY + y
        }
        else
        {
            MeasurementTypeView.frame = CGRect(x: x/2, y: y2, width: view.frame.width - x, height: (40 * y))
            //MeasurementTypeView.backgroundColor = UIColor.darkGray
            MeasurementTypeView.layer.borderWidth = 1
            MeasurementTypeView.layer.borderColor = UIColor(red:0.05, green:0.17, blue:0.46, alpha:1.0).cgColor
            AppointmentScrollview.addSubview(MeasurementTypeView)
        }
        
      
        
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
        Measurement_AppointmentStatusView.frame = CGRect(x: ((view.frame.width - (7 * x)) / 2), y: MaterialTypeLabel.frame.maxY + (2 * y), width: (19 * x), height: (2 * y))
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
            if(MeasureStatus.contains("Not Approved"))
            {
                if let language = UserDefaults.standard.value(forKey: "language") as? String
                {
                    if language == "en"
                    {
                        Measure_StatusBtn.setTitle("Pending", for: .normal)
                    }
                    else if language == "ar"
                    {
                        Measure_StatusBtn.setTitle("قيد الانتظار", for: .normal)
                    }
                }
                else
                {
                    Measure_StatusBtn.setTitle("Pending", for: .normal)
                }
            }
            else
            {
                if(MeasureStatus.count == 1)
                {
                    Measure_StatusBtn.setTitle("\(MeasureStatus[0])", for: .normal)
                }
                else if(MeasureStatus.count == 2)
                {
                    Measure_StatusBtn.setTitle("\(MeasureStatus[1])", for: .normal)
                }
                else if(MeasureStatus.count == 3)
                {
                    Measure_StatusBtn.setTitle("\(MeasureStatus[2])", for: .normal)
                }
            }
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
         let urlString = serviceCall.baseURL
         let api = "\(urlString)/images/Measurement1/\(imageName)"
         print("Measurement - Header Image", api)
         let apiurl = URL(string: api)
         courierDeliveryIcon.dowloadFromServer(url: apiurl!)
         }
         */
        MeasurementTypeView.addSubview(TailorShopIcon)
        
        let TailorTypeLabel = UILabel()
        TailorTypeLabel.frame = CGRect(x: TailorShopIcon.frame.maxX, y: Measurement_AppointmentStatusView.frame.maxY + y, width: view.frame.width - (5 * x), height: (2 * y))
        if(MeasurementInEnglish.count > 0)
        {
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    TailorTypeLabel.text = MeasurementInEnglish[0] as? String
                }
                else if language == "ar"
                {
                    TailorTypeLabel.text = measurementInArabic[0] as? String
                }
            }
            else
            {
                TailorTypeLabel.text = MeasurementInEnglish[0] as? String
            }
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
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/Measurement1/\(imageName)"
                print("Measurement - Body Image", api)
                let apiurl = URL(string: api)
                
                let dummyImageView = UIImageView()
                dummyImageView.frame = CGRect(x: 0, y: 0, width: courierImageView.frame.width, height: TailorImageView.frame.height)
                if apiurl != nil{
                    dummyImageView.dowloadFromServer(url: apiurl!)
                }
                TailorImageView.addSubview(dummyImageView)
            }
             MeasurementTypeView.addSubview(TailorImageView)
        }
       
        
        
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
        Measure_FromDateView.frame = CGRect(x: (3 * x), y: From_MaterialTypeLBL.frame.maxY, width: TailorImageView.frame.width / 2, height: (3.5 * y))
        Measure_FromDateView.backgroundColor = UIColor(red:0.05, green:0.17, blue:0.46, alpha:1.0)
        MeasurementTypeView.addSubview(Measure_FromDateView)
        
        // FromDate Icon..
        let FromDateMeasure_Icon = UIImageView()
        FromDateMeasure_Icon.frame = CGRect(x: 1, y: (y/2) - 4, width:(2 * x), height: (2 * y))
        //FromDateMeasure_Icon.backgroundColor = UIColor.white
        FromDateMeasure_Icon.image = UIImage(named: "OrderDate_WH")
       // Measure_FromDateView.addSubview(FromDateMeasure_Icon)
        
        //let From_MeasurementType_TF = UITextField()
        From_MeasurementType_TF.frame = CGRect(x: FromDateMeasure_Icon.frame.maxX, y: (y/2) - 4, width: (10 * x) , height: (3.5 * y))
        From_MeasurementType_TF.attributedPlaceholder = NSAttributedString(string: "Date",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        From_MeasurementType_TF.textColor = UIColor.white
        From_MeasurementType_TF.textAlignment = .center
        From_MeasurementType_TF.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        From_MeasurementType_TF.adjustsFontSizeToFitWidth = true
        //From_MeasurementType_TF.backgroundColor = UIColor.gray
        if MeasurementInEnglish.contains("Go to Tailor Shop")
        {
           From_MeasurementType_TF.isUserInteractionEnabled = false
        }
        else
        {
            From_MeasurementType_TF.isUserInteractionEnabled = true
        }
        From_MeasurementType_TF.addTarget(self, action: #selector(self.FMeasurement_calendarAction), for: .allEditingEvents)
        From_MeasurementType_TF.delegate = self as? UITextFieldDelegate
        Measure_FromDateView.addSubview(From_MeasurementType_TF)
        
        // Edit icon..
        let FromDateEditMeasure_Icon = UIImageView()
        FromDateEditMeasure_Icon.frame = CGRect(x: From_MaterialType_TF.frame.maxX, y: (y/2) - 4, width:(2 * x), height: (1.5 * y))
        //FromDateEditMeasure_Icon.backgroundColor = UIColor.white
        FromDateEditMeasure_Icon.image = UIImage(named: "OrderDate_WH")
        //Measure_FromDateView.addSubview(FromDateEditMeasure_Icon)
        
        
   //--------------------Measure ToDate View----------------------
        
        //ToDateView
        let Measure_ToDateView = UIView()
        Measure_ToDateView.frame = CGRect(x: Measure_FromDateView.frame.maxX + 1, y: TO_MaterialTypeLBL.frame.maxY, width: TailorImageView.frame.width / 2, height: (3.5 * y))
        Measure_ToDateView.backgroundColor = UIColor(red:0.10, green:0.30, blue:0.76, alpha:1.0)
        MeasurementTypeView.addSubview(Measure_ToDateView)
        
        // ToDAteIcon..
        let ToDateMeasure_Icon = UIImageView()
        ToDateMeasure_Icon.frame = CGRect(x: 1, y: (y/2) - 4, width:(2 * x), height: (2 * y))
        //ToDateMeasure_Icon.backgroundColor = UIColor.white
        ToDateMeasure_Icon.image = UIImage(named: "OrderDate_WH")
       // Measure_ToDateView.addSubview(ToDateMeasure_Icon)
        
        // let TO_MeasurementType_TF = UITextField()
        TO_MeasurementType_TF.frame = CGRect(x: ToDateMeasure_Icon.frame.maxX , y: (y/2) - 4, width: (10 * x), height: (3.5 * y))
        TO_MeasurementType_TF.attributedPlaceholder = NSAttributedString(string: "Date",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        TO_MeasurementType_TF.textColor = UIColor.white
        TO_MeasurementType_TF.textAlignment = .center
        TO_MeasurementType_TF.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        TO_MeasurementType_TF.adjustsFontSizeToFitWidth = true
        // TO_MeasurementType_TF.backgroundColor = UIColor.gray  //UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        if MeasurementInEnglish.contains("Go to Tailor Shop")
        {
            TO_MeasurementType_TF.isUserInteractionEnabled = false
        }
        else
        {
            TO_MeasurementType_TF.isUserInteractionEnabled = true
        }
        TO_MeasurementType_TF.addTarget(self, action: #selector(self.TMeasurement_calendarAction), for: .allEditingEvents)
        TO_MeasurementType_TF.delegate = self as? UITextFieldDelegate
        Measure_ToDateView.addSubview(TO_MeasurementType_TF)
        
        // Edit icon..
        let ToDateEditMeasure_Icon = UIImageView()
        ToDateEditMeasure_Icon.frame = CGRect(x: TO_MeasurementType_TF.frame.maxX, y: (y/2) - 4, width:(2 * x), height: (1.5 * y))
        //ToDateEditMeasure_Icon.backgroundColor = UIColor.white
        ToDateEditMeasure_Icon.image = UIImage(named: "OrderDate_WH")
        // Measure_ToDateView.addSubview(ToDateEditMeasure_Icon)
        
        
         
    //----------------Time Slot View------------------------------------
         
        let Slot_MeasureTypeLBL = UILabel()
        Slot_MeasureTypeLBL.frame = CGRect(x: (3 * x), y: Measure_FromDateView.frame.maxY + y, width: (7 * x), height: (3.5 * y))
        Slot_MeasureTypeLBL.text = "TIME SLOT"
        Slot_MeasureTypeLBL.textColor = UIColor.black
        Slot_MeasureTypeLBL.textAlignment = .left
        Slot_MeasureTypeLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        Slot_MeasureTypeLBL.adjustsFontSizeToFitWidth = true
        // Slot_MeasureTypeLBL.backgroundColor = UIColor.lightGray
        MeasurementTypeView.addSubview(Slot_MeasureTypeLBL)
        
        
        //TimeSlotView
        let Measure_TimeSlotView = UIView()
        Measure_TimeSlotView.frame = CGRect(x: Slot_MeasureTypeLBL.frame.maxX, y: Measure_FromDateView.frame.maxY + y, width: (24.5 * x), height: (3.5 * y))
        Measure_TimeSlotView.backgroundColor = UIColor(red:0.05, green:0.17, blue:0.46, alpha:1.0)
        MeasurementTypeView.addSubview(Measure_TimeSlotView)
        //print("width value :",TailorImageView.frame.width / 2)
        
        // TimeMatrl_Icon..
        let TimeMeasure_Icon = UIImageView()
        TimeMeasure_Icon.frame = CGRect(x: 2, y: (y/2) - 4, width:(2 * x), height: (2 * y))
        //TimeMeasure_Icon.backgroundColor = UIColor.white
        TimeMeasure_Icon.image = UIImage(named: "OrderTime_WH")
        // Measure_TimeSlotView.addSubview(TimeMeasure_Icon)
        
        // let SLOT_MeasurementType_TF = UITextField()
        SLOT_MeasurementType_TF.frame = CGRect(x: TimeMeasure_Icon.frame.maxX + x, y: (y/2) - 4, width: (20 * x), height: (3.5 * y))
        SLOT_MeasurementType_TF.attributedPlaceholder = NSAttributedString(string: "Time",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        SLOT_MeasurementType_TF.textColor = UIColor.white
        SLOT_MeasurementType_TF.textAlignment = .left
        SLOT_MeasurementType_TF.font = UIFont(name: "Avenir Next", size: 1.4 * x)
        SLOT_MeasurementType_TF.adjustsFontSizeToFitWidth = true
       // SLOT_MeasurementType_TF.backgroundColor = UIColor.lightGray //UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        if MeasurementInEnglish.contains("Go to Tailor Shop")
        {
            SLOT_MeasurementType_TF.isUserInteractionEnabled = false
        }
        else
        {
            SLOT_MeasurementType_TF.isUserInteractionEnabled = true
        }
        SLOT_MeasurementType_TF.addTarget(self, action: #selector(self.SlotMeasure_calendarAction), for: .allEditingEvents)
        SLOT_MeasurementType_TF.delegate = self as? UITextFieldDelegate
        Measure_TimeSlotView.addSubview(SLOT_MeasurementType_TF)
 

     // -------------------------------------------------------------
        
        
       // let ApproveButton = UIButton()
       Measure_ApproveButton.frame = CGRect(x: (8 * x), y: Measure_TimeSlotView.frame.maxY + y, width: (10 * x), height: (3.5 * y))
         Measure_ApproveButton.backgroundColor = UIColor(red:0.24, green:0.62, blue:0.24, alpha:1.0)
        Measure_ApproveButton.setTitle("Approve", for: .normal)
        Measure_ApproveButton.setTitleColor(UIColor.white, for: .normal)
        Measure_ApproveButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.3 * x)!
        Measure_ApproveButton.layer.borderColor = UIColor.lightGray.cgColor
        Measure_ApproveButton.layer.borderWidth = 1.0
        Measure_ApproveButton.layer.cornerRadius = 15
        Measure_ApproveButton.addTarget(self, action: #selector(self.MeasureApproveButtonAction(sender:)), for: .touchUpInside)
        if MeasurementInEnglish.contains("Go to Tailor Shop")
        {
            if (MeasureStatus.contains("Approved") && MeasurementPayment.contains("Paid"))
            { }
            else
            {
               MeasurementTypeView.addSubview(Measure_ApproveButton)
            }
        }
      
        
        
       // let RejectButton = UIButton()
        Measure_RejectButton.frame = CGRect(x: Measure_ApproveButton.frame.maxX + (2 * x), y: Measure_TimeSlotView.frame.maxY + y, width: (10 * x), height: (3.5 * y))
        Measure_RejectButton.backgroundColor = UIColor(red:0.89, green:0.13, blue:0.11, alpha:1.0)
        Measure_RejectButton.setTitle("Reject", for: .normal)
        Measure_RejectButton.setTitleColor(UIColor.white, for: .normal)
        Measure_RejectButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.3 * x)!
        Measure_RejectButton.layer.borderColor = UIColor.lightGray.cgColor
        Measure_RejectButton.layer.borderWidth = 1.0
        Measure_RejectButton.layer.cornerRadius = 15
        Measure_RejectButton.addTarget(self, action: #selector(self.MeasureRejectButtonAction(sender:)), for: .touchUpInside)
        if MeasurementInEnglish.contains("Go to Tailor Shop")
        {
            if (MeasureStatus.contains("Approved") && MeasurementPayment.contains("Paid"))
            { }
            else
            {
               MeasurementTypeView.addSubview(Measure_RejectButton)
            }
        }
      
        
        let Measure_SaveButton = UIButton()
        Measure_SaveButton.frame = CGRect(x: TailorImageView.frame.width - (7 * x), y: Measure_RejectButton.frame.minY + y , width: (10 * x), height: (3.5 * y))
        Measure_SaveButton.backgroundColor = UIColor(red:0.10, green:0.30, blue:0.76, alpha:1.0)
        Measure_SaveButton.setTitle("Save", for: .normal)
        Measure_SaveButton.setTitleColor(UIColor.white, for: .normal)
        Measure_SaveButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.4 * x)!
        Measure_SaveButton.addTarget(self, action: #selector(self.Measure_SaveButtonAction(sender:)), for: .touchUpInside)
        if MeasurementInEnglish.contains("Go to Tailor Shop")
        {
             // MeasureSucessStr = "True"
        }
        else
        {
           MeasurementTypeView.addSubview(Measure_SaveButton)
        }
        
        AppointmentScrollview.contentSize.height = MeasurementTypeView.frame.maxY
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                MaterialTypeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                MaterialTypeLabel.text = "MEASUREMENT_1"
                
                Material_StatusLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                Material_StatusLabel.text = "Appointment Status:"
                Material_StatusLabel.textAlignment = .left
                
                Material_StatusBtn.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                Measure_StatusLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                Measure_StatusLabel.text = "Appointment Status:"
                Measure_StatusLabel.textAlignment = .left
                
                Measure_StatusBtn.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                TailorTypeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                TailorTypeLabel.textAlignment = .left
                
                TailorImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                From_MaterialTypeLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                From_MaterialTypeLBL.text = "FROM"
                From_MaterialTypeLBL.textAlignment = .left
                
                TO_MaterialTypeLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                TO_MaterialTypeLBL.text = "TO"
                TO_MaterialTypeLBL.textAlignment = .left

                From_MeasurementType_TF.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                From_MeasurementType_TF.placeholder = "Date"
                TO_MeasurementType_TF.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                From_MeasurementType_TF.placeholder = "Date"

                
                Slot_MeasureTypeLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                Slot_MeasureTypeLBL.text = "TIME SLOT"
                Slot_MeasureTypeLBL.textAlignment = .left
                
                SLOT_MeasurementType_TF.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                SLOT_MeasurementType_TF.placeholder = "Time"
                SLOT_MeasurementType_TF.textAlignment = .left
                
                Measure_ApproveButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                Measure_ApproveButton.setTitle("Approve", for: .normal)
                
                Measure_RejectButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                Measure_RejectButton.setTitle("Reject", for: .normal)
                
                Measure_SaveButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                Measure_SaveButton.setTitle("Save", for: .normal)
                
                orderTypeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                orderTypeLabel.text = "ORDER TYPE"
                
                From_OrderTypeLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                From_OrderTypeLBL.text = "FROM"
                From_OrderTypeLBL.textAlignment = .left
                TO_OrderTypeLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                TO_OrderTypeLBL.text = "TO"
                TO_OrderTypeLBL.textAlignment = .left

                From_MaterialType_TF.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                From_MaterialType_TF.placeholder = "Date"
                TO_MaterialType_TF.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                TO_MaterialType_TF.placeholder = "Date"
                
                Slot_MaterialTypeLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                Slot_MaterialTypeLBL.text = "TIME SLOT"
                Slot_MaterialTypeLBL.textAlignment = .left
                
                SLOT_MaterialType_TF.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                SLOT_MaterialType_TF.placeholder = "Time"
                SLOT_MaterialType_TF.textAlignment = .left
                
                Material_ApproveButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                Material_ApproveButton.setTitle("Approve", for: .normal)
                
                Material_RejectButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                Material_RejectButton.setTitle("Reject", for: .normal)
                
                Material_SaveButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                Material_SaveButton.setTitle("Save", for: .normal)

                changeViewToEnglishInSelf()
            }
            else if language == "ar"
            {
                MaterialTypeLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                MaterialTypeLabel.text = "قياس_1"
                
                Material_StatusLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                Material_StatusLabel.text = "حالة التعيين : "
                Material_StatusLabel.textAlignment = .right
                
                Material_StatusBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                
                Measure_StatusLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                Measure_StatusLabel.text = "حالة التعيين : "
                Measure_StatusLabel.textAlignment = .right
                
                Measure_StatusBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                
                TailorTypeLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                TailorTypeLabel.textAlignment = .right
                
                TailorImageView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                
                From_MaterialTypeLBL.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                From_MaterialTypeLBL.text = "من عند"
                From_MaterialTypeLBL.textAlignment = .right
            
                
                TO_MaterialTypeLBL.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                TO_MaterialTypeLBL.text = "حتى"
                TO_MaterialTypeLBL.textAlignment = .right
                
                From_MeasurementType_TF.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                From_MeasurementType_TF.placeholder = "تاريخ"
                TO_MeasurementType_TF.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                TO_MeasurementType_TF.placeholder = "تاريخ"
                
                Slot_MeasureTypeLBL.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                Slot_MeasureTypeLBL.text = "فسحة زمنية"
                Slot_MeasureTypeLBL.textAlignment = .right
                
                SLOT_MeasurementType_TF.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                SLOT_MeasurementType_TF.placeholder = "زمن"
                SLOT_MeasurementType_TF.textAlignment = .right
                
                Measure_ApproveButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                Measure_ApproveButton.setTitle("يوافق", for: .normal)
                
                Measure_RejectButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                Measure_RejectButton.setTitle("رفض", for: .normal)
                
                Measure_SaveButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                Measure_SaveButton.setTitle("حفظ", for: .normal)
                
                orderTypeLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                orderTypeLabel.text = "نوع الطلبية"
                
                From_OrderTypeLBL.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                From_OrderTypeLBL.text = "من عند"
                From_OrderTypeLBL.textAlignment = .right
                TO_OrderTypeLBL.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                TO_OrderTypeLBL.text = "حتى"
                TO_OrderTypeLBL.textAlignment = .right
                
                From_MaterialType_TF.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                From_MaterialType_TF.placeholder = "تاريخ"
                TO_MaterialType_TF.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                TO_MaterialType_TF.placeholder = "تاريخ"
                
                Slot_MaterialTypeLBL.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                Slot_MaterialTypeLBL.text = "فسحة زمنية"
                Slot_MaterialTypeLBL.textAlignment = .right
                
                SLOT_MaterialType_TF.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                SLOT_MaterialType_TF.placeholder = "زمن"
                SLOT_MaterialType_TF.textAlignment = .right
                
                Material_ApproveButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                Material_ApproveButton.setTitle("يوافق", for: .normal)
                
                Material_RejectButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                Material_RejectButton.setTitle("رفض", for: .normal)
                
                Material_SaveButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                Material_SaveButton.setTitle("حفظ", for: .normal)

                changeViewToArabicInSelf()
            }
        }
        else
        {
            MaterialTypeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            MaterialTypeLabel.text = "MEASUREMENT_1"

            changeViewToEnglishInSelf()
        }
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
     self.navigationController?.popViewController(animated: true)
    }
    
    @objc func MaterialStatusButtonAction(sender : UIButton)
    {
        print("Material status Page..")
        if(MaterialStatus .contains("Rejected"))
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
        if(MeasureStatus .contains("Rejected"))
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
        
        if (MaterialAppointID.count != 0)
        {
           var AppointID : Int!
        
            if(MaterialAppointID.count == 1)
            {
                AppointID = MaterialAppointID[0] as? Int
            }
            else if(MaterialAppointID.count == 2)
            {
                AppointID = MaterialAppointID[1] as? Int
            }
            else if(MaterialAppointID.count == 3)
            {
                AppointID = MaterialAppointID[2] as? Int
            }
      
        // let AppointID = MaterialAppointID[0] as! Int
         let Msg = ""
         self.serviceCall.API_IsApproveAppointmentMaterial(AppointmentId: AppointID!, IsApproved: 1, Reason: Msg, delegate: self)
       }
       else
       {
        
       }
       
    }
    
    @objc func MaterialRejectButtonAction(sender : UIButton)
    {
        print("Material Reject Status Page..")
        MaterialRejectButtonContent()
    }
    
    @objc func MeasureApproveButtonAction(sender : UIButton)
    {
        print("Measure Approve Status Page..")
        if (MeasurementAppointID.count != 0)
        {
            var AppointID : Int!
            
            if(MeasurementAppointID.count == 1)
            {
                AppointID = MeasurementAppointID[0] as? Int
            }
            else if(MeasurementAppointID.count == 2)
            {
                AppointID = MeasurementAppointID[1] as? Int
            }
            else if(MeasurementAppointID.count == 3)
            {
                AppointID = MeasurementAppointID[2] as? Int
            }
            
           // let AppointID : Int = MeasurementAppointID[0] as! Int
            let Msg = ""
            self.serviceCall.API_IsApproveAppointmentMeasurement(AppointmentId: AppointID, IsApproved: 1, Reason: Msg, delegate: self)
        
       }
     
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
        
      if(MaterialAppointID.count != 0)
      {
        
        var AppointID : Int!
        
        if(MaterialAppointID.count == 1)
        {
            AppointID = MaterialAppointID[0] as? Int
        }
        else if(MaterialAppointID.count == 2)
        {
            AppointID = MaterialAppointID[1] as? Int
        }
        else if(MaterialAppointID.count == 3)
        {
            AppointID = MaterialAppointID[2] as? Int
        }
        
       // let AppointID = MaterialAppointID[0] as! Int
        let Msg : String = self.Material_rejectReason_TF.text!
        self.serviceCall.API_IsApproveAppointmentMaterial(AppointmentId: AppointID, IsApproved: 2, Reason: Msg, delegate: self)
      }
    }
    
    @objc func Save_MeasureRejectAction(sender : UIButton)
    {
        MeasureRejectButtonView.removeFromSuperview()
        
        if(MeasurementAppointID.count != 0)
        {
            
            var AppointID : Int!
            
            if(MeasurementAppointID.count == 1)
            {
                AppointID = MeasurementAppointID[0] as? Int
            }
            else if(MeasurementAppointID.count == 2)
            {
                AppointID = MeasurementAppointID[1] as? Int
            }
            else if(MeasurementAppointID.count == 3)
            {
                AppointID = MeasurementAppointID[2] as? Int
            }
            
       // let AppointID = MeasurementAppointID[0] as! Int
        let Msg : String = self.Measure_rejectReason_TF.text!
        self.serviceCall.API_IsApproveAppointmentMeasurement(AppointmentId: AppointID, IsApproved: 2, Reason: Msg, delegate: self)
        }
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
        FromMaterial_dateFormatter.dateFormat = "MM/dd/yyyy"  //"yyyy/MM/dd"
        From_MaterialType_TF.text = FromMaterial_dateFormatter.string(from: Material_FromDatePick.date)
        From_MaterialType_TF.resignFirstResponder()
        
    }
    @objc func TMaterial_DoneClick()
    {
        let ToMaterial_dateFormatter = DateFormatter()
        ToMaterial_dateFormatter.dateStyle = .medium
        ToMaterial_dateFormatter.timeStyle = .none
        ToMaterial_dateFormatter.dateFormat = "MM/dd/yyyy"  //"yyyy/MM/dd"
        TO_MaterialType_TF.text = ToMaterial_dateFormatter.string(from: Material_ToDatePick.date)
        TO_MaterialType_TF.resignFirstResponder()
        
    }
    @objc func SlotMaterial_DoneClick()
    {
        SLOT_MaterialType_TF.resignFirstResponder()
       // SLOT_MaterialType_TF.text = TimeSlotArray[0] as? String
    }
    @objc func SlotMeasure_DoneClick()
    {
        SLOT_MeasurementType_TF.resignFirstResponder()
       // SLOT_MeasurementType_TF.text = TimeSlotArray[0] as? String
    }
    @objc func FMeasurement_DoneClick()
    {
        let FromMeasure_dateFormatter = DateFormatter()
        FromMeasure_dateFormatter.dateStyle = .medium
        FromMeasure_dateFormatter.timeStyle = .none
        FromMeasure_dateFormatter.dateFormat = "MM/dd/yyyy"  //"yyyy/MM/dd"
        From_MeasurementType_TF.text = FromMeasure_dateFormatter.string(from: Measure_FromDatePick.date)
        From_MeasurementType_TF.resignFirstResponder()
        
    }
    @objc func TMeasurement_DoneClick()
    {
        
        let ToMeasure_dateFormatter = DateFormatter()
        ToMeasure_dateFormatter.dateStyle = .medium
        ToMeasure_dateFormatter.timeStyle = .none
        ToMeasure_dateFormatter.dateFormat = "MM/dd/yyyy"  //"yyyy/MM/dd"
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
        else
        {
            Mat_OrderID = 0
        }
        
        let FMaterial : String = self.From_MaterialType_TF.text!
        let TMaterial : String = self.TO_MaterialType_TF.text!
        
        print("From_Material:",FMaterial)
        print("To_Material:",TMaterial)
        
        if (FMaterial.isEmpty || TMaterial.isEmpty || SlotStr.isEmpty)
        {
            print("Date/Time are Empty")
            let appointmentAlert = UIAlertController(title: "Alert..!", message: "Date/Time is Empty..!", preferredStyle: .alert)
            appointmentAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(appointmentAlert, animated: true, completion: nil)
        }
        else
        {
            if (FMaterial.compare(TMaterial) == .orderedAscending || FMaterial.compare(TMaterial) == .orderedSame)
            {
                print("From-Date is smaller than To-Date")
                
                self.serviceCall.API_InsertAppoinmentMaterial(OrderId: Mat_OrderID, AppointmentType: 1, AppointmentTime: SlotStr, From: FMaterial, To: TMaterial, CreatedBy:"Customer", delegate: self)
            }
            else
            {
                print("From-Date is Lesser then To-Date")
                
                let appointmentAlert = UIAlertController(title: "Alert..!", message: "To-Date Should Greater Than From-Date..!", preferredStyle: .alert)
                appointmentAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                // appointmentAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(appointmentAlert, animated: true, completion: nil)
                
            }
            
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
        else
        {
            Msr_OrderID = 0
        }
       
        let FMeasure : String = self.From_MeasurementType_TF.text!
        let TMeasure : String = self.TO_MeasurementType_TF.text!
        
         print("From_Measure:",FMeasure)
         print("To_Measure:",TMeasure)
        
        
        if (FMeasure.isEmpty || TMeasure.isEmpty || SlotStr.isEmpty)
        {
            print("Dates are Empty")
            let appointmentAlert = UIAlertController(title: "Alert..!", message: "Date/Time is Empty..!", preferredStyle: .alert)
            appointmentAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(appointmentAlert, animated: true, completion: nil)
        }
        else
        {
            
            if (FMeasure.compare(TMeasure) == .orderedAscending || FMeasure.compare(TMeasure) == .orderedSame)
            {
                print("From-Date is smaller then To-Date")
                
               self.serviceCall.API_InsertAppoinmentMeasurement(OrderId: Msr_OrderID, AppointmentType: 2, AppointmentTime: SlotStr, From: FMeasure, To: TMeasure, CreatedBy: "Customer", delegate: self)
            }
            else
            {
                print("From-Date is Lesser then To-Date")
                
                let appointmentAlert = UIAlertController(title: "Alert..!", message: "To-Date Should Greater Than From-Date..!", preferredStyle: .alert)
                appointmentAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                // appointmentAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(appointmentAlert, animated: true, completion: nil)
            }
        }
    }
    
}
