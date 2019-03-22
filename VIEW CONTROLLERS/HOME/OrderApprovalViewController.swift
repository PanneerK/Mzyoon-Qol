//
//  OrderApprovalViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 13/12/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class OrderApprovalViewController: CommonViewController,ServerAPIDelegate,UITextFieldDelegate
{
    
    //SCREEN PARAMETERS
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()
    
    let PricingButton = UIButton()
    let DeliveryDetailsButton = UIButton()
    let ProceedToPayButton = UIButton()
    let CurrencyButton = UIButton()
    var CurrencyCodes = [String]()
    
    let PricingView = UIView()
    let deliveryDetailsView = UIView()
    let QtyNumTF = UITextField()
    var qtyNum : Int!
    var TailorResponseID : Int!
    var TailorID : Int!
    var DeliveryDate:String!
    var OrderId : Int!
    
    let serviceCall = ServerAPI()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    
    var DressImageArray = NSArray()
    var DressNameArray = NSArray()
    var ChargesAmountArray = NSArray()
    var ChargesNameArray = NSArray()
    
    var AppoinmentArray = NSArray()
    var DeliveryDateArray = NSArray()
    var DeliveryTypeArray = NSArray()
    var StichingTimesArray = NSArray()
    
    let emptyLabel = UILabel()
    
    let ApprovalListScrollView = UIScrollView()
    
    var applicationDelegate = AppDelegate()

    
    override func viewDidLoad()
    {
        print("Tailor ID:",TailorID)
        print("Tailor ResponseID:",TailorResponseID)
        
        navigationBar.isHidden = true
        
        Variables.sharedManager.ApprovalQty = "1"
        
        self.selectedButton(tag: 1)
        
        self.addDoneButtonOnKeyboard()
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
          self.serviceCall.API_OrderApprovalPrice(TailorResponseId: self.TailorResponseID, delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        let navigationArray = self.navigationController?.viewControllers
        print("viewControllers Aray:",navigationArray!)
        
        // self.serviceCall.API_OrderApprovalPrice(TailorResponseId: self.TailorResponseID, delegate: self)
    }
     
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("Order approval : ", errorMessage)
        stopActivity()
        applicationDelegate.exitContents()
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        // ErrorStr = "Default Error"
        PageNumStr = "OrderApprovalViewController"
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
    func API_CALLBACK_OrderApprovalPrice(orderApprovalPrice: NSDictionary)
    {
        let ResponseMsg = orderApprovalPrice.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = orderApprovalPrice.object(forKey: "Result") as! NSDictionary
            print("Result", Result)
            
            let DressSubType = Result.object(forKey: "DressSubType") as! NSArray
            print("DressSubType:",DressSubType)
            
            DressImageArray = DressSubType.value(forKey: "Image") as! NSArray
            print("DressImageArray:",DressImageArray)
            
            DressNameArray = DressSubType.value(forKey: "NameInEnglish") as! NSArray
            print("DressNameArray:",DressNameArray)
            
            let TailorCharges = Result.object(forKey: "TailorCharges") as! NSArray
            print("TailorCharges:",TailorCharges)
            
            ChargesNameArray = TailorCharges.value(forKey: "DescInEnglish") as! NSArray
            print("ChargesNameArray:",ChargesNameArray)
            
            ChargesAmountArray = TailorCharges.value(forKey: "Amount") as! NSArray
           print("ChargesAmountArray:",ChargesAmountArray)
            
           
        }
        else if ResponseMsg == "Failure"
        {
            let Result = orderApprovalPrice.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetTailorResponseList"
            ErrorStr = Result
            
            DeviceError()
            
        }
        
        self.serviceCall.API_OrderApprovalDelivery(TailorResponseId: self.TailorResponseID, delegate: self)
        
        // self.orderApprovalContent()
    }
    
    func API_CALLBACK_OrderApprovalDelivery(orderApprovalDelivery: NSDictionary)
    {
        
        let ResponseMsg = orderApprovalDelivery.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = orderApprovalDelivery.object(forKey: "Result") as! NSDictionary
            print("Result", Result)
            
            if Result.count == 0 || Result == nil
            {
                emptyLabel.frame = CGRect(x: 0, y: ((view.frame.height - (3 * y)) / 2), width: view.frame.width, height: (3 * y))
                emptyLabel.text = "You don't have any order request"
                emptyLabel.textColor = UIColor.black
                emptyLabel.textAlignment = .center
                emptyLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
                emptyLabel.font = emptyLabel.font.withSize(1.5 * x)
                view.addSubview(emptyLabel)
            }
            
          let Appointments = Result.object(forKey: "Appoinments") as! NSArray
            AppoinmentArray = Appointments.value(forKey: "Appoinment") as! NSArray
            print("AppoinmentArray", AppoinmentArray)
            
            let DeliveryDate = Result.object(forKey: "DeliveryDate") as! NSArray
            DeliveryDateArray = DeliveryDate.value(forKey: "DeliveryDate") as! NSArray
            print("DeliveryDateArray", DeliveryDateArray)
            
            let DeliveryTypes = Result.object(forKey: "DeliveryTypes") as! NSArray
            DeliveryTypeArray = DeliveryTypes.value(forKey: "DeliveryType") as! NSArray
            print("DeliveryTypeArray", DeliveryTypeArray)
            
            let DressSubType = Result.object(forKey: "DressSubType") as! NSArray
            DressImageArray = DressSubType.value(forKey: "Image") as! NSArray
            print("DressImageArray:",DressImageArray)
            
            DressNameArray = DressSubType.value(forKey: "NameInEnglish") as! NSArray
            print("DressNameArray:",DressNameArray)
            
            let StichingTime = Result.object(forKey: "StichingTime") as! NSArray
            StichingTimesArray = StichingTime.value(forKey: "StichingTimes") as! NSArray
            print("StichingTimesArray", StichingTimesArray)
            
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = orderApprovalDelivery.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetTailorResponseList"
            ErrorStr = Result
            
            DeviceError()
            
        }
        
        self.orderApprovalContent()
    }
    
    func API_CALLBACK_UpdateQtyOrderApproval(updateQtyOA: NSDictionary)
    {
        
        let ResponseMsg = updateQtyOA.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = updateQtyOA.object(forKey: "Result") as! String
            print("Result", Result)
            
            if (AppoinmentArray.contains("Companies-Material") && AppoinmentArray.contains("Manually"))
            {
                let PaymentScreen = PaymentViewController()
                let TotalValue : Int = ChargesAmountArray[7] as! Int
                PaymentScreen.TotalAmount = "\(TotalValue)"
                PaymentScreen.TailorId = TailorID
                self.navigationController?.pushViewController(PaymentScreen, animated: true)
            }
            else
            {
                if let language = UserDefaults.standard.value(forKey: "language") as? String
                {
                    if language == "en"
                    {
                        let appointmentAlert = UIAlertController(title: "Info!", message: "Please Book An Appointment Before Proceed to Pay", preferredStyle: .alert)
                        appointmentAlert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: proceedAlertAction(action:)))
                        appointmentAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                        self.present(appointmentAlert, animated: true, completion: nil)

                    }
                    else if language == "ar"
                    {
                        let appointmentAlert = UIAlertController(title: "المعلومات!", message: "يرجى حجز موعد قبل الاستمرار في الدفع", preferredStyle: .alert)
                        appointmentAlert.addAction(UIAlertAction(title: "استمر", style: .default, handler: proceedAlertAction(action:)))
                        appointmentAlert.addAction(UIAlertAction(title: "إلغاء", style: .default, handler: nil))
                        self.present(appointmentAlert, animated: true, completion: nil)
                    }
                }
                else
                {
                    let appointmentAlert = UIAlertController(title: "Info!", message: "Please Book An Appointment Before Proceed to Pay", preferredStyle: .alert)
                    appointmentAlert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: proceedAlertAction(action:)))
                    appointmentAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    self.present(appointmentAlert, animated: true, completion: nil)
                }
            }
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = updateQtyOA.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "UPdateQtyInOrderApproval"
            ErrorStr = Result
            
            DeviceError()
            
        }
    }
     
    func proceedAlertAction(action : UIAlertAction)
    {
          let AppointmentScreen = AppointmentViewController()
         if(ChargesAmountArray.count != 0)
         {
            let TotalValue : Int = ChargesAmountArray[7] as! Int
            AppointmentScreen.TotalAmount = "\(TotalValue)"
         }
        else
         {
             AppointmentScreen.TotalAmount = "1"
         }
            AppointmentScreen.TailorID = TailorID
           AppointmentScreen.OrderID = OrderId
        
           self.navigationController?.pushViewController(AppointmentScreen, animated: true)
    }
    
    func changeViewToArabicInSelf()
    {
        view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.text = "طلب موافقة"
        
        QtyNumTF.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        PricingButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        PricingButton.setTitle("تفاصيل السعر", for: .normal)
        DeliveryDetailsButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        DeliveryDetailsButton.setTitle("تفاصيل التسليم", for: .normal)
        
        CurrencyButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        ProceedToPayButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        ProceedToPayButton.setTitle("المضي قدما في الدفع", for: .normal)
    }
    
    func changeViewToEnglishInSelf()
    {
        view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.text = "ORDER APPROVAL"
        
        QtyNumTF.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        PricingButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        PricingButton.setTitle("Price Details", for: .normal)
        DeliveryDetailsButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        DeliveryDetailsButton.setTitle("Delivery Details", for: .normal)
        
        CurrencyButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        ProceedToPayButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        ProceedToPayButton.setTitle("PROCEED TO PAY", for: .normal)
    }
    
    func orderApprovalContent()
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
        selfScreenNavigationTitle.text = "ORDER APPROVAL"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationTitle.font = selfScreenNavigationTitle.font.withSize(2 * x)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        let DressDetView = UIView()
        DressDetView.frame = CGRect(x: x + 15 , y: selfScreenNavigationBar.frame.maxY + y, width: view.frame.width - (5 * x), height: (10 * y))
        DressDetView.layer.cornerRadius = 5
        DressDetView.layer.borderWidth = 1
        DressDetView.layer.backgroundColor = UIColor.orange.cgColor
        DressDetView.layer.borderColor = UIColor.black.cgColor
        view.addSubview(DressDetView)
        
        let DressImageView = UIImageView()
        DressImageView.frame = CGRect(x: x, y: y, width: (8 * x), height:(8 * y))
        DressImageView.backgroundColor = UIColor.white
        
       if(DressImageArray.count != 0)
       {
        if let imageName = DressImageArray[0] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/DressSubType/\(imageName)"
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: DressImageView.frame.width, height: DressImageView.frame.height)
            
           // print("Image Of Dress", apiurl!)
            
            if apiurl != nil
            {
                dummyImageView.dowloadFromServer(url: apiurl!)
            }
            dummyImageView.tag = -1
            DressImageView.addSubview(dummyImageView)
        }
         DressDetView.addSubview(DressImageView)
       }
      else
       {
          DressImageView.backgroundColor = UIColor.lightGray
          DressDetView.addSubview(DressImageView)
        }
        
        let DressTypeLabel = UILabel()
        DressTypeLabel.frame = CGRect(x: DressImageView.frame.maxX + x, y: DressDetView.frame.minY - (6 * y), width: (20 * x), height: (2 * y))
        if(DressNameArray.count != 0)
        {
          DressTypeLabel.text = DressNameArray[0] as? String
        }
        else
        {
            DressTypeLabel.text = ""
        }
        DressTypeLabel.textColor = UIColor.white
    //  DressTypeLabel.backgroundColor = UIColor.gray
        DressTypeLabel.textAlignment = .left
        DressTypeLabel.font = UIFont(name: "Avenir Next", size: 1.5 * x)
        DressDetView.addSubview(DressTypeLabel)
        
        
        let QtyLabel = UILabel()
        QtyLabel.frame = CGRect(x: DressImageView.frame.maxX + x, y: DressTypeLabel.frame.minY + (3 * y), width: (8 * x), height: (2 * y))
        QtyLabel.text = "Qty   : "
        QtyLabel.textColor = UIColor.white
        QtyLabel.textAlignment = .left
        QtyLabel.font = UIFont(name: "Avenir Next", size: 1.5 * x)
        DressDetView.addSubview(QtyLabel)
        
        
        QtyNumTF.frame = CGRect(x: QtyLabel.frame.minX + (5 * x), y: DressTypeLabel.frame.minY + (3 * y), width: (4 * x), height: (2 * y))
        QtyNumTF.backgroundColor = UIColor.white
        QtyNumTF.placeholder = "Qty"
        QtyNumTF.text = "1" // Variables.sharedManager.ApprovalQty
        QtyNumTF.textColor = UIColor.black
        QtyNumTF.textAlignment = .center
        QtyNumTF.font = QtyNumTF.font!.withSize(14)
        QtyNumTF.adjustsFontSizeToFitWidth = true
        QtyNumTF.keyboardType = .numberPad
        QtyNumTF.clearsOnBeginEditing = false
        QtyNumTF.returnKeyType = .done
        QtyNumTF.delegate = self
        QtyNumTF.isUserInteractionEnabled = false
        DressDetView.addSubview(QtyNumTF)
        
        
        PricingButton.frame = CGRect(x: 0, y: DressDetView.frame.maxY + y, width: ((view.frame.width / 2) - 1), height: 40)
        PricingButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        PricingButton.setTitle("PRICE DETAILS", for: .normal)
        PricingButton.setTitleColor(UIColor.white, for: .normal)
        PricingButton.titleLabel?.font =  UIFont(name: "Avenir Next", size: 1.5 * x)
        PricingButton.tag = 0
        PricingButton.addTarget(self, action: #selector(self.selectionViewButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(PricingButton)
        
        DeliveryDetailsButton.frame = CGRect(x: PricingButton.frame.maxX + 1, y: DressDetView.frame.maxY + y, width: view.frame.width / 2, height: 40)
        DeliveryDetailsButton.backgroundColor = UIColor.lightGray
        DeliveryDetailsButton.setTitle("DELIVERY DETAILS", for: .normal)
        DeliveryDetailsButton.setTitleColor(UIColor.black, for: .normal)
        DeliveryDetailsButton.titleLabel?.font =  UIFont(name: "Avenir Next", size: 1.5 * x)
        DeliveryDetailsButton.tag = 1
        DeliveryDetailsButton.addTarget(self, action: #selector(self.selectionViewButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(DeliveryDetailsButton)
        
        DeliveryDetailsButton.backgroundColor = UIColor.lightGray
        DeliveryDetailsButton.setTitleColor(UIColor.black, for: .normal)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                DressImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                DressTypeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                DressTypeLabel.textAlignment = .left
                QtyLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                QtyLabel.text = "Qty   : "
                QtyLabel.textAlignment = .left
                
                changeViewToEnglishInSelf()
            }
            else if language == "ar"
            {
                DressImageView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                DressTypeLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                DressTypeLabel.textAlignment = .right
                QtyLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                QtyLabel.text = "كمية   : "
                QtyLabel.textAlignment = .right
                
                changeViewToArabicInSelf()
            }
        }
        else
        {
            DressImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            DressTypeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            DressTypeLabel.textAlignment = .left
            QtyLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            QtyLabel.text = "Qty   : "
            QtyLabel.textAlignment = .left
            
            changeViewToEnglishInSelf()
        }
        
        PricingViewContents(isHidden: false)
        DeliveryDetailsViewContents(isHidden: true)
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
        
        self.QtyNumTF.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        
        Variables.sharedManager.ApprovalQty = self.QtyNumTF.text!
        self.view.endEditing(true)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func selectionViewButtonAction(sender : UIButton)
    {
        if sender.tag == 0
        {
            // self.serviceCall.API_OrderApprovalPrice(TailorResponseId: 27, delegate: self)
            
            DeliveryDetailsButton.backgroundColor = UIColor.lightGray
            DeliveryDetailsButton.setTitleColor(UIColor.black, for: .normal)
            PricingViewContents(isHidden: false)
            DeliveryDetailsViewContents(isHidden: true)
            
        }
        else if sender.tag == 1
        {
          //  self.serviceCall.API_OrderApprovalDelivery(TailorResponseId: 27, delegate: self)
            
            PricingButton.backgroundColor = UIColor.lightGray
            PricingButton.setTitleColor(UIColor.black, for: .normal)
            PricingViewContents(isHidden: true)
            DeliveryDetailsViewContents(isHidden: false)
            
        }
        
        sender.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        sender.setTitleColor(UIColor.white, for: .normal)
    }
    
    
    func PricingViewContents(isHidden : Bool)
    {
        ApprovalListScrollView.frame = CGRect(x: (3 * x), y: DeliveryDetailsButton.frame.maxY + y , width: view.frame.width - (6 * x), height: (37 * y))
        ApprovalListScrollView.backgroundColor = UIColor.clear
        view.addSubview(ApprovalListScrollView)
       
        
//        for views in ApprovalListScrollView.subviews
//        {
//            views.removeFromSuperview()
//        }
        
       // var y1:CGFloat = 0
        
      //  PricingView.frame = CGRect(x: (3 * x), y: DeliveryDetailsButton.frame.maxY + y , width: view.frame.width - (4 * x), height: view.frame.height - (40 * y))
        // PricingView.backgroundColor = UIColor.cyan
      //  ApprovalListScrollView.addSubview(PricingView)
        
        PricingView.frame = CGRect(x: 0, y: 0, width: ApprovalListScrollView.frame.width, height: (35 * y))
        PricingView.backgroundColor = UIColor.lightGray
       // ApprovalListScrollView.addSubview(PricingView)
        
        let backgroundImage = UIImageView()
        backgroundImage.frame = CGRect(x: 0, y: 0, width: PricingView.frame.width, height: PricingView.frame.height)
        backgroundImage.image = UIImage(named: "background")
//        PricingView.addSubview(backgroundImage)
 
        ApprovalListScrollView.isHidden = isHidden
       
        // Currency Button:-
        CurrencyButton.frame = CGRect(x: (22 * x), y: ApprovalListScrollView.frame.minY - (22 * y), width: (8 * x), height: (2 * y))
        CurrencyButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        CurrencyButton.setTitle("AED", for: .normal)
        CurrencyButton.setTitleColor(UIColor.white, for: .normal)
        CurrencyButton.titleLabel?.font =  UIFont(name: "Avenir Next", size: 1.5 * x)
        CurrencyButton.layer.cornerRadius = 5;  // this value vary as per your desire
        CurrencyButton.clipsToBounds = true;
        CurrencyButton.addTarget(self, action: #selector(self.CurrencyButtonAction(sender:)), for: .touchUpInside)
        ApprovalListScrollView.addSubview(CurrencyButton)
        
        let downArrowImageView = UIImageView()
        downArrowImageView.frame = CGRect(x: CurrencyButton.frame.width - 15, y: ((CurrencyButton.frame.height - (1.5 * x)) / 2), width: (1.5 * x), height: (1.5 * y))
        downArrowImageView.image = UIImage(named: "downArrow")
        CurrencyButton.addSubview(downArrowImageView)
        
        // MeasurementChargesLabel..
        let MeasurementChargesLabel = UILabel()
        MeasurementChargesLabel.frame = CGRect(x: x, y: CurrencyButton.frame.minY + (4 * y), width: (ApprovalListScrollView.frame.width / 2), height: (3 * y))
       // MeasurementChargesLabel.backgroundColor = UIColor.gray
        MeasurementChargesLabel.text = "Measurement Charges"
        MeasurementChargesLabel.textColor = UIColor.black
        MeasurementChargesLabel.textAlignment = .left
        MeasurementChargesLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
       // MeasurementChargesLabel.font = MeasurementChargesLabel.font.withSize(14)
        ApprovalListScrollView.addSubview(MeasurementChargesLabel)
      
        let MeasureRupeeValueLBL = UILabel()
        MeasureRupeeValueLBL.frame = CGRect(x: MeasurementChargesLabel.frame.maxX + x , y: CurrencyButton.frame.minY + (4 * y), width: (10 * x), height: (3 * y))
       // MeasureRupeeValueLBL.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        
     
       if (ChargesAmountArray.count != 0)
       {
          let MeasureRupeeValue : Int = ChargesAmountArray[4] as! Int
          MeasureRupeeValueLBL.text =  "\(MeasureRupeeValue)"
        }
        else
        {
           MeasureRupeeValueLBL.text = ""
        }
        MeasureRupeeValueLBL.textColor = UIColor.blue
        MeasureRupeeValueLBL.textAlignment = .center
        MeasureRupeeValueLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ApprovalListScrollView.addSubview(MeasureRupeeValueLBL)
        
        // CurrencyLabel..
        let CurrencyLabel = UILabel()
        CurrencyLabel.frame = CGRect(x: MeasureRupeeValueLBL.frame.maxX + 1, y: CurrencyButton.frame.minY + (4 * y), width: (3 * x), height: (3 * y))
       // CurrencyLabel.backgroundColor = UIColor.gray
        CurrencyLabel.text = "AED"
        CurrencyLabel.textColor = UIColor.blue
        CurrencyLabel.textAlignment = .center
        CurrencyLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ApprovalListScrollView.addSubview(CurrencyLabel)
        
        
        // Customization and Stiching Charges Label..
        let StichingChargesLabel = UILabel()
        StichingChargesLabel.frame = CGRect(x: x, y: MeasurementChargesLabel.frame.maxY + 8 , width: (ApprovalListScrollView.frame.width / 2), height: (4 * y))
       // StichingChargesLabel.backgroundColor = UIColor.gray
        StichingChargesLabel.text = "Customization and Stiching Charges"
        StichingChargesLabel.textColor = UIColor.black
        StichingChargesLabel.textAlignment = .left
        StichingChargesLabel.lineBreakMode = .byWordWrapping
        StichingChargesLabel.numberOfLines = 2
        StichingChargesLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ApprovalListScrollView.addSubview(StichingChargesLabel)
      
        
        let StichingRupeeValueLBL = UILabel()
        StichingRupeeValueLBL.frame = CGRect(x: StichingChargesLabel.frame.maxX + x , y: MeasurementChargesLabel.frame.minY + (4 * y), width: (10 * x), height: (3 * y))
        // MeasureRupeeValueLBL.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        if(ChargesAmountArray.count != 0)
        {
            let StichingRupeeValue : Int = ChargesAmountArray[1] as! Int
            StichingRupeeValueLBL.text =  "\(StichingRupeeValue)"
        }
        else
        {
            StichingRupeeValueLBL.text = ""
        }
        
        StichingRupeeValueLBL.textColor = UIColor.blue
        StichingRupeeValueLBL.textAlignment = .center
        StichingRupeeValueLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ApprovalListScrollView.addSubview(StichingRupeeValueLBL)
        
       
        // CurrencyLabel..
        let StichingCurrLabel = UILabel()
        StichingCurrLabel.frame = CGRect(x: StichingRupeeValueLBL.frame.maxX + 1, y: MeasurementChargesLabel.frame.minY + (4 * y), width: (3 * x), height: (3 * y))
      //  StichingCurrLabel.backgroundColor = UIColor.gray
        StichingCurrLabel.text = "AED"
        StichingCurrLabel.textColor = UIColor.blue
        StichingCurrLabel.textAlignment = .center
        StichingCurrLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ApprovalListScrollView.addSubview(StichingCurrLabel)
        
        
        // Appointment Charges Label..
        let AppointmentChargesLabel = UILabel()
        AppointmentChargesLabel.frame = CGRect(x: x, y: StichingChargesLabel.frame.maxY + 8 , width: (ApprovalListScrollView.frame.width / 2), height: (3 * y))
      //  AppointmentChargesLabel.backgroundColor = UIColor.gray
        AppointmentChargesLabel.text = "Appointment Charges"
        AppointmentChargesLabel.textColor = UIColor.black
        AppointmentChargesLabel.textAlignment = .left
        AppointmentChargesLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ApprovalListScrollView.addSubview(AppointmentChargesLabel)
        
        let AppointmentRupeeValueLBL = UILabel()
        AppointmentRupeeValueLBL.frame = CGRect(x: StichingChargesLabel.frame.maxX + x , y: StichingChargesLabel.frame.minY + (4 * y), width: (10 * x), height: (3 * y))
        // MeasureRupeeValueLBL.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        if(ChargesAmountArray.count != 0)
        {
            let AppointmentRupeeValue : Int = ChargesAmountArray[0] as! Int
            AppointmentRupeeValueLBL.text =  "\(AppointmentRupeeValue)"
        }
        else
        {
            AppointmentRupeeValueLBL.text = ""
        }
       
        AppointmentRupeeValueLBL.textColor = UIColor.blue
        AppointmentRupeeValueLBL.textAlignment = .center
        AppointmentRupeeValueLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ApprovalListScrollView.addSubview(AppointmentRupeeValueLBL)
        
        // CurrencyLabel..
        let AppointmentCurrLabel = UILabel()
        AppointmentCurrLabel.frame = CGRect(x: AppointmentRupeeValueLBL.frame.maxX + 1, y: StichingChargesLabel.frame.minY + (4 * y), width: (3 * x), height: (3 * y))
      //  AppointmentCurrLabel.backgroundColor = UIColor.gray
        AppointmentCurrLabel.text = "AED"
        AppointmentCurrLabel.textColor = UIColor.blue
        AppointmentCurrLabel.textAlignment = .center
        AppointmentCurrLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ApprovalListScrollView.addSubview(AppointmentCurrLabel)
        
        
        // Material Delivery Charges Label..
        let MaterialDeliveryChargesLabel = UILabel()
        MaterialDeliveryChargesLabel.frame = CGRect(x: x, y: AppointmentChargesLabel.frame.maxY + 8 , width: (ApprovalListScrollView.frame.width / 2), height: (3 * y))
      //  MaterialDeliveryChargesLabel.backgroundColor = UIColor.gray
        MaterialDeliveryChargesLabel.text = "Material Delivery Charges"
        MaterialDeliveryChargesLabel.textColor = UIColor.black
        MaterialDeliveryChargesLabel.textAlignment = .left
        MaterialDeliveryChargesLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ApprovalListScrollView.addSubview(MaterialDeliveryChargesLabel)
        
  
        
        let MaterialRupeeValueLBL = UILabel()
        MaterialRupeeValueLBL.frame = CGRect(x: MaterialDeliveryChargesLabel.frame.maxX + x , y: AppointmentChargesLabel.frame.minY + (3 * y), width: (10 * x), height: (3 * y))
        // MeasureRupeeValueLBL.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        if(ChargesAmountArray.count != 0)
        {
            let MaterialRupeeValue : Int = ChargesAmountArray[3] as! Int
            MaterialRupeeValueLBL.text =  "\(MaterialRupeeValue)"
        }
        else
        {
            MaterialRupeeValueLBL.text = ""
        }
        
        MaterialRupeeValueLBL.textColor = UIColor.blue
        MaterialRupeeValueLBL.textAlignment = .center
        MaterialRupeeValueLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ApprovalListScrollView.addSubview(MaterialRupeeValueLBL)
        
        // CurrencyLabel..
        let MaterialCurrLabel = UILabel()
        MaterialCurrLabel.frame = CGRect(x: MaterialRupeeValueLBL.frame.maxX + 1, y: AppointmentChargesLabel.frame.minY + (3 * y), width: (3 * x), height: (3 * y))
       // MaterialCurrLabel.backgroundColor = UIColor.gray
        MaterialCurrLabel.text = "AED"
        MaterialCurrLabel.textColor = UIColor.blue
        MaterialCurrLabel.textAlignment = .center
        MaterialCurrLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ApprovalListScrollView.addSubview(MaterialCurrLabel)
        
        
        // Urgent Stiching Charges Label..
        let UrgentStichChargesLabel = UILabel()
        UrgentStichChargesLabel.frame = CGRect(x: x, y: MaterialDeliveryChargesLabel.frame.maxY + 8 , width: (ApprovalListScrollView.frame.width / 2), height: (3 * y))
      //  UrgentStichChargesLabel.backgroundColor = UIColor.gray
        UrgentStichChargesLabel.text = "Urgent Stiching Charges"
        UrgentStichChargesLabel.textColor = UIColor.black
        UrgentStichChargesLabel.textAlignment = .left
        UrgentStichChargesLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ApprovalListScrollView.addSubview(UrgentStichChargesLabel)
        
    
        let UrgentStichValueLBL = UILabel()
        UrgentStichValueLBL.frame = CGRect(x: UrgentStichChargesLabel.frame.maxX + x , y: MaterialDeliveryChargesLabel.frame.minY + (3 * y), width: (10 * x), height: (3 * y))
        // MeasureRupeeValueLBL.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        if(ChargesAmountArray.count != 0)
        {
            let UrgentStichValue : Int = ChargesAmountArray[8] as! Int
            UrgentStichValueLBL.text =  "\(UrgentStichValue)"
        }
        else
        {
            UrgentStichValueLBL.text = ""
        }
        
        UrgentStichValueLBL.textColor = UIColor.blue
        UrgentStichValueLBL.textAlignment = .center
        UrgentStichValueLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ApprovalListScrollView.addSubview(UrgentStichValueLBL)
        
        // CurrencyLabel..
        let UrgentCurrLabel = UILabel()
        UrgentCurrLabel.frame = CGRect(x: UrgentStichValueLBL.frame.maxX + 1, y: MaterialDeliveryChargesLabel.frame.minY + (3 * y), width: (3 * x), height: (3 * y))
       // UrgentCurrLabel.backgroundColor = UIColor.gray
        UrgentCurrLabel.text = "AED"
        UrgentCurrLabel.textColor = UIColor.blue
        UrgentCurrLabel.textAlignment = .center
        UrgentCurrLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ApprovalListScrollView.addSubview(UrgentCurrLabel)
        
        
        // Delivery Charges Label..
        let DeliveryChargesLabel = UILabel()
        DeliveryChargesLabel.frame = CGRect(x: x, y: UrgentStichChargesLabel.frame.maxY + 8 , width: (ApprovalListScrollView.frame.width / 2), height: (3 * y))
      //  DeliveryChargesLabel.backgroundColor = UIColor.gray
        DeliveryChargesLabel.text = "Delivery Charges"
        DeliveryChargesLabel.textColor = UIColor.black
        DeliveryChargesLabel.textAlignment = .left
        DeliveryChargesLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ApprovalListScrollView.addSubview(DeliveryChargesLabel)
        
        let DeliveryRupeeValueLBL = UILabel()
        DeliveryRupeeValueLBL.frame = CGRect(x: DeliveryChargesLabel.frame.maxX + x , y: UrgentStichChargesLabel.frame.minY + (3 * y), width: (10 * x), height: (3 * y))
        // MeasureRupeeValueLBL.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        if(ChargesAmountArray.count != 0)
        {
            let DeliveryRupeeValue : Int = ChargesAmountArray[2] as! Int
            DeliveryRupeeValueLBL.text =  "\(DeliveryRupeeValue)"
        }
        else
        {
            DeliveryRupeeValueLBL.text = ""
        }
       
        DeliveryRupeeValueLBL.textColor = UIColor.blue
        DeliveryRupeeValueLBL.textAlignment = .center
        DeliveryRupeeValueLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ApprovalListScrollView.addSubview(DeliveryRupeeValueLBL)
        
        // CurrencyLabel..
        let DeliveryCurrLabel = UILabel()
        DeliveryCurrLabel.frame = CGRect(x: DeliveryRupeeValueLBL.frame.maxX + 1, y: UrgentStichChargesLabel.frame.minY + (3 * y), width: (3 * x), height: (3 * y))
      //  DeliveryCurrLabel.backgroundColor = UIColor.gray
        DeliveryCurrLabel.text = "AED"
        DeliveryCurrLabel.textColor = UIColor.blue
        DeliveryCurrLabel.textAlignment = .center
        DeliveryCurrLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ApprovalListScrollView.addSubview(DeliveryCurrLabel)
        
        
        // Service Charges Label..
        let ServiceChargesLabel = UILabel()
        ServiceChargesLabel.frame = CGRect(x: x, y: DeliveryChargesLabel.frame.maxY + 8 , width: (ApprovalListScrollView.frame.width / 2), height: (3 * y))
       // ServiceChargesLabel.backgroundColor = UIColor.gray
        ServiceChargesLabel.text = "Service Charges"
        ServiceChargesLabel.textColor = UIColor.black
        ServiceChargesLabel.textAlignment = .left
        ServiceChargesLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ApprovalListScrollView.addSubview(ServiceChargesLabel)
        
        let ServiceRupeeValueLBL = UILabel()
        ServiceRupeeValueLBL.frame = CGRect(x: ServiceChargesLabel.frame.maxX + x , y: DeliveryChargesLabel.frame.minY + (3 * y), width: (10 * x), height: (3 * y))
        // MeasureRupeeValueLBL.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        if(ChargesAmountArray.count != 0)
        {
            let ServiceRupeeValue : Int = ChargesAmountArray[5] as! Int
            ServiceRupeeValueLBL.text =  "\(ServiceRupeeValue)"
        }
        else
        {
            ServiceRupeeValueLBL.text = ""
        }
        
        ServiceRupeeValueLBL.textColor = UIColor.blue
        ServiceRupeeValueLBL.textAlignment = .center
        ServiceRupeeValueLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ApprovalListScrollView.addSubview(ServiceRupeeValueLBL)
        
        // CurrencyLabel..
        let ServiceCurrLabel = UILabel()
        ServiceCurrLabel.frame = CGRect(x: ServiceRupeeValueLBL.frame.maxX + 1, y: DeliveryChargesLabel.frame.minY + (3 * y), width: (3 * x), height: (3 * y))
     //   ServiceCurrLabel.backgroundColor = UIColor.gray
        ServiceCurrLabel.text = "AED"
        ServiceCurrLabel.textColor = UIColor.blue
        ServiceCurrLabel.textAlignment = .center
        ServiceCurrLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ApprovalListScrollView.addSubview(ServiceCurrLabel)
        
        // Tax Charges Label..
        let TaxChargesLabel = UILabel()
        TaxChargesLabel.frame = CGRect(x: x, y: ServiceChargesLabel.frame.maxY + 8 , width: (ApprovalListScrollView.frame.width / 2), height: (3 * y))
    //    TaxChargesLabel.backgroundColor = UIColor.gray
        TaxChargesLabel.text = "Tax"
        TaxChargesLabel.textColor = UIColor.black
        TaxChargesLabel.textAlignment = .left
        TaxChargesLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ApprovalListScrollView.addSubview(TaxChargesLabel)
       
        let TaxRupeeValueLBL = UILabel()
        TaxRupeeValueLBL.frame = CGRect(x: ServiceChargesLabel.frame.maxX + x , y: ServiceChargesLabel.frame.minY + (3 * y), width: (10 * x), height: (3 * y))
        // MeasureRupeeValueLBL.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        if(ChargesAmountArray.count != 0)
        {
            let TaxRupeeValue : Int = ChargesAmountArray[6] as! Int
            TaxRupeeValueLBL.text =  "\(TaxRupeeValue)"
        }
        else
        {
            TaxRupeeValueLBL.text = ""
        }
       
        TaxRupeeValueLBL.textColor = UIColor.blue
        TaxRupeeValueLBL.textAlignment = .center
        TaxRupeeValueLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ApprovalListScrollView.addSubview(TaxRupeeValueLBL)
        
        // CurrencyLabel..
        let TaxCurrLabel = UILabel()
        TaxCurrLabel.frame = CGRect(x: TaxRupeeValueLBL.frame.maxX + 1, y: ServiceChargesLabel.frame.minY + (3 * y), width: (3 * x), height: (3 * y))
      //  TaxCurrLabel.backgroundColor = UIColor.gray
        TaxCurrLabel.text = "AED"
        TaxCurrLabel.textColor = UIColor.blue
        TaxCurrLabel.textAlignment = .center
        TaxCurrLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ApprovalListScrollView.addSubview(TaxCurrLabel)
        
        
        // Upper_UnderLine..
        let PriceUpperUnderline = UILabel()
        PriceUpperUnderline.frame = CGRect(x: x, y: TaxChargesLabel.frame.maxY + (y / 2), width: ApprovalListScrollView.frame.width - (2 * x), height: 0.5)
        PriceUpperUnderline.backgroundColor = UIColor.lightGray
        ApprovalListScrollView.addSubview(PriceUpperUnderline)
        
        // Grand Total...
        let OrderTotalLabel = UILabel()
        OrderTotalLabel.frame = CGRect(x: x, y: TaxChargesLabel.frame.minY + (4 * y), width: (ApprovalListScrollView.frame.width / 2), height: (3 * y))
       // OrderTotalLabel.backgroundColor = UIColor.gray
        OrderTotalLabel.text = "ORDER TOTAL"
        OrderTotalLabel.textColor = UIColor.blue
        OrderTotalLabel.textAlignment = .left
        OrderTotalLabel.font = UIFont(name: "Avenir Next", size: 1.5 * x)
        ApprovalListScrollView.addSubview(OrderTotalLabel)
        
        let OrderTotalValueLBL = UILabel()
        OrderTotalValueLBL.frame = CGRect(x: OrderTotalLabel.frame.maxX + x , y: TaxChargesLabel.frame.minY + (4 * y), width: (10 * x), height: (3 * y))
        OrderTotalValueLBL.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        if(ChargesAmountArray.count != 0)
        {
            let OrderTotalValue : Int = ChargesAmountArray[7] as! Int
            OrderTotalValueLBL.text =  "\(OrderTotalValue)"
        }
        else
        {
            OrderTotalValueLBL.text = ""
        }
        
        OrderTotalValueLBL.textColor = UIColor.white
        OrderTotalValueLBL.textAlignment = .center
        OrderTotalValueLBL.font = UIFont(name: "Avenir Next", size: 1.5 * x)
        ApprovalListScrollView.addSubview(OrderTotalValueLBL)
        
        // CurrencyLabel..
        let TotalCurrLabel = UILabel()
        TotalCurrLabel.frame = CGRect(x: OrderTotalValueLBL.frame.maxX + 1, y: TaxChargesLabel.frame.minY + (4 * y), width: (3 * x), height: (3 * y))
        //TaxCurrLabel.backgroundColor = UIColor.gray
        TotalCurrLabel.text = "AED"
        TotalCurrLabel.textColor = UIColor.blue
        TotalCurrLabel.textAlignment = .center
        TotalCurrLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
        ApprovalListScrollView.addSubview(TotalCurrLabel)
     
        // Lower_UnderLine..
        let PriceLowerUnderline = UILabel()
        PriceLowerUnderline.frame = CGRect(x: x, y: OrderTotalLabel.frame.maxY + (y / 2), width: ApprovalListScrollView.frame.width - (2 * x), height: 0.5)
        PriceLowerUnderline.backgroundColor = UIColor.lightGray
        ApprovalListScrollView.addSubview(PriceLowerUnderline)
        
        ApprovalListScrollView.contentSize.height = OrderTotalValueLBL.frame.maxY + (2 * y)
        
         ProceedToPayButton.isHidden = true
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                MeasurementChargesLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                MeasurementChargesLabel.text = "Measurement Charges"
                MeasurementChargesLabel.textAlignment = .left
                MeasureRupeeValueLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                CurrencyLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                StichingChargesLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                StichingChargesLabel.text = "Customization and Stitching Charges"
                StichingChargesLabel.textAlignment = .left
                StichingRupeeValueLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                StichingCurrLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                AppointmentChargesLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                AppointmentChargesLabel.text = "Appointment Charges"
                AppointmentChargesLabel.textAlignment = .left
                AppointmentRupeeValueLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                AppointmentCurrLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                MaterialDeliveryChargesLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                MaterialDeliveryChargesLabel.text = "Material Delivery Charges"
                MaterialDeliveryChargesLabel.textAlignment = .left
                MaterialRupeeValueLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                MaterialCurrLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                UrgentStichChargesLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                UrgentStichChargesLabel.text = "Urgent Stitching Charges"
                UrgentStichChargesLabel.textAlignment = .left
                UrgentStichValueLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                UrgentCurrLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                DeliveryChargesLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                DeliveryChargesLabel.text = "Delivery Charges"
                DeliveryChargesLabel.textAlignment = .left
                DeliveryRupeeValueLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                DeliveryCurrLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                ServiceChargesLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                ServiceChargesLabel.text = "Service Charges"
                ServiceChargesLabel.textAlignment = .left
                ServiceRupeeValueLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                ServiceCurrLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                TaxChargesLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                TaxChargesLabel.text = "Tax"
                TaxChargesLabel.textAlignment = .left
                TaxRupeeValueLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                TaxCurrLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                OrderTotalLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                OrderTotalLabel.text = "ORDER TOTAL"
                OrderTotalLabel.textAlignment = .left
                OrderTotalValueLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                TotalCurrLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                changeViewToEnglishInSelf()
            }
            else if language == "ar"
            {
                MeasurementChargesLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                MeasurementChargesLabel.text = "رسوم القياس"
                MeasurementChargesLabel.textAlignment = .right
                MeasureRupeeValueLBL.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                CurrencyLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                
                StichingChargesLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                StichingChargesLabel.text = "التخصيص وخياطة الرسوم"
                StichingChargesLabel.textAlignment = .right
                StichingRupeeValueLBL.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                StichingCurrLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                
                AppointmentChargesLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                AppointmentChargesLabel.text = "رسوم التعيين"
                AppointmentChargesLabel.textAlignment = .right
                AppointmentRupeeValueLBL.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                AppointmentCurrLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                
                MaterialDeliveryChargesLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                MaterialDeliveryChargesLabel.text = "رسوم تسليم المواد"
                MaterialDeliveryChargesLabel.textAlignment = .right
                MaterialRupeeValueLBL.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                MaterialCurrLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                
                UrgentStichChargesLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                UrgentStichChargesLabel.text = "رسوم الخياطة العاجلة"
                UrgentStichChargesLabel.textAlignment = .right
                UrgentStichValueLBL.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                UrgentCurrLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                
                DeliveryChargesLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                DeliveryChargesLabel.text = "رسوم التوصيل"
                DeliveryChargesLabel.textAlignment = .right
                DeliveryRupeeValueLBL.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                DeliveryCurrLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                
                ServiceChargesLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                ServiceChargesLabel.text = "رسوم الخدمة"
                ServiceChargesLabel.textAlignment = .right
                ServiceRupeeValueLBL.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                ServiceCurrLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                
                TaxChargesLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                TaxChargesLabel.text = "ضريبة"
                TaxChargesLabel.textAlignment = .right
                TaxRupeeValueLBL.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                TaxCurrLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                
                OrderTotalLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                OrderTotalLabel.text = "إجمالي الطلب"
                OrderTotalLabel.textAlignment = .right
                OrderTotalValueLBL.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                TotalCurrLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                
                changeViewToArabicInSelf()
            }
        }
        else
        {
            MeasurementChargesLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            MeasurementChargesLabel.text = "Measurement Charges"
            MeasurementChargesLabel.textAlignment = .left
            MeasureRupeeValueLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            CurrencyLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            StichingChargesLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            StichingChargesLabel.text = "Customization and Stiching Charges"
            StichingChargesLabel.textAlignment = .left
            StichingRupeeValueLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            StichingCurrLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            AppointmentChargesLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            AppointmentChargesLabel.text = "Appointment Charges"
            AppointmentChargesLabel.textAlignment = .left
            AppointmentRupeeValueLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            AppointmentCurrLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            MaterialDeliveryChargesLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            MaterialDeliveryChargesLabel.text = "Material Delivery Charges"
            MaterialDeliveryChargesLabel.textAlignment = .left
            MaterialRupeeValueLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            MaterialCurrLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            UrgentStichChargesLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            UrgentStichChargesLabel.text = "Urgent Stiching Charges"
            UrgentStichChargesLabel.textAlignment = .left
            UrgentStichValueLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            UrgentCurrLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            DeliveryChargesLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            DeliveryChargesLabel.text = "Delivery Charges"
            DeliveryChargesLabel.textAlignment = .left
            DeliveryRupeeValueLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            DeliveryCurrLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            ServiceChargesLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            ServiceChargesLabel.text = "Service Charges"
            ServiceChargesLabel.textAlignment = .left
            ServiceRupeeValueLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            ServiceCurrLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            TaxChargesLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            TaxChargesLabel.text = "Tax"
            TaxChargesLabel.textAlignment = .left
            TaxRupeeValueLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            TaxCurrLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            OrderTotalLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            OrderTotalLabel.text = "ORDER TOTAL"
            OrderTotalLabel.textAlignment = .left
            OrderTotalValueLBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            TotalCurrLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            changeViewToEnglishInSelf()
        }
    }
    
    func DeliveryDetailsViewContents(isHidden : Bool)
    {
        
       // let deliveryDetailsView = UIView()
        deliveryDetailsView.frame = CGRect(x: (3 * x), y: DeliveryDetailsButton.frame.maxY + y , width: view.frame.width - (4 * x), height: (35 * y))
        //deliveryDetailsView.backgroundColor = UIColor.cyan
        view.addSubview(deliveryDetailsView)
   
        let backgroundImage = UIImageView()
        backgroundImage.frame = CGRect(x: 0, y: 0, width: deliveryDetailsView.frame.width, height: deliveryDetailsView.frame.height)
        backgroundImage.image = UIImage(named: "background")
//        deliveryDetailsView.addSubview(backgroundImage)
      
        deliveryDetailsView.isHidden = isHidden
        
      //   var y1:CGFloat = y
        
        // AppointmentView :-
            let AppointmentsView = UIView()
            AppointmentsView.frame = CGRect(x: x, y: deliveryDetailsView.frame.minY - (22 * y), width: deliveryDetailsView.frame.width - (2 * x), height: (8 * y))
            AppointmentsView.layer.cornerRadius = 10
            AppointmentsView.layer.masksToBounds = true
            AppointmentsView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        
          //  DeliveryDetLabels.text = dressTypeArray[i]
           // AppointmentViewLabels.textColor = UIColor.white
           // AppointmentViewLabels.textAlignment = .left
           // AppointmentViewLabels.font = AppointmentViewLabels.font.withSize(14)
        
            deliveryDetailsView.addSubview(AppointmentsView)
            
    //        y1 = AppointmentsView.frame.maxY + (y / 2)
        
        // Label :-  width: 15 * x
           let AppointmentsLabels = UILabel()
           AppointmentsLabels.frame = CGRect(x: x, y: 0 , width:AppointmentsView.frame.width - (20 * x) , height: (8 * y))
           //AppointmentsLabels.backgroundColor = UIColor.gray
           AppointmentsLabels.text = "Appointments"
           AppointmentsLabels.textColor = UIColor.white
           AppointmentsLabels.textAlignment = .left
           AppointmentsLabels.font = UIFont(name: "Avenir Next", size: 1.3 * x)
           AppointmentsView.addSubview(AppointmentsLabels)
        
        // DeliveryColonLabel :-
        let AppointColonLabel = UILabel()
        AppointColonLabel.frame = CGRect(x: AppointmentsLabels.frame.maxX , y: 0 , width: (2 * x), height: (8 * y))
       // AppointColonLabel.backgroundColor = UIColor.gray
        AppointColonLabel.text = "-"
        AppointColonLabel.textColor = UIColor.white
        AppointColonLabel.textAlignment = .center
        AppointColonLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        AppointmentsView.addSubview(AppointColonLabel)
        
        // AppointmentValueLabel :-
        var y1:CGFloat = 0
        
      for i in 0..<AppoinmentArray.count
      {
        let AppointmentValueLabel = UILabel()
        AppointmentValueLabel.frame = CGRect(x: AppointColonLabel.frame.maxX + x, y: y1, width: 15 * x, height: (4 * y))
         // AppointmentValueLabel.backgroundColor = UIColor.gray
        AppointmentValueLabel.text = AppoinmentArray[i] as? String
        AppointmentValueLabel.lineBreakMode = .byWordWrapping
        AppointmentValueLabel.numberOfLines = 2
        AppointmentValueLabel.textColor = UIColor.white
        AppointmentValueLabel.textAlignment = .left
        AppointmentValueLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        AppointmentsView.addSubview(AppointmentValueLabel)
        
        y1 = AppointmentValueLabel.frame.maxY + 1
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                AppointmentValueLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                AppointmentValueLabel.textAlignment = .left
            }
            else if language == "ar"
            {
                AppointmentValueLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                AppointmentValueLabel.textAlignment = .right
            }
        }
        else
        {
            AppointmentValueLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            AppointmentValueLabel.textAlignment = .left
        }
     }
        
        // DeliveryTypeView :-
        let DeliveryTypeView = UIView()
        DeliveryTypeView.frame = CGRect(x: x, y: AppointmentsView.frame.maxY + y, width: deliveryDetailsView.frame.width - (2 * x) , height: (4 * y))
        DeliveryTypeView.layer.cornerRadius = 10
        DeliveryTypeView.layer.masksToBounds = true
        DeliveryTypeView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        deliveryDetailsView.addSubview(DeliveryTypeView)
       
        // Label :-
        let DeliveryTypeLabel = UILabel()
        DeliveryTypeLabel.frame = CGRect(x: x, y: 0, width: DeliveryTypeView.frame.width - (20 * x), height: (4 * y))
       // DeliveryTypeLabel.backgroundColor = UIColor.gray
        DeliveryTypeLabel.text = "Delivery Type"
        DeliveryTypeLabel.textColor = UIColor.white
        DeliveryTypeLabel.textAlignment = .left
        DeliveryTypeLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        DeliveryTypeView.addSubview(DeliveryTypeLabel)
        
        // DeliveryColonLabel :-
        let DeliveryColonLabel = UILabel()
        DeliveryColonLabel.frame = CGRect(x: DeliveryTypeLabel.frame.maxX, y: 0, width: (2 * x), height: (4 * y))
        // DeliveryColonLabel.backgroundColor = UIColor.gray
        DeliveryColonLabel.text = "-"
        DeliveryColonLabel.textColor = UIColor.white
        DeliveryColonLabel.textAlignment = .center
        DeliveryColonLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        DeliveryTypeView.addSubview(DeliveryColonLabel)
        
        // DeliveryValueLabel :-
        let DeliveryValueLabel = UILabel()
        DeliveryValueLabel.frame = CGRect(x: DeliveryColonLabel.frame.maxX + x, y: 0, width: (15 * x), height: (4 * y))
        // DeliveryValueLabel.backgroundColor = UIColor.gray
        DeliveryValueLabel.text = DeliveryTypeArray[0] as? String
        DeliveryValueLabel.textColor = UIColor.white
        DeliveryValueLabel.textAlignment = .left
        DeliveryValueLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        DeliveryTypeView.addSubview(DeliveryValueLabel)
        
    
        // StichTimeView :-
        let StichTimeView = UIView()
        StichTimeView.frame = CGRect(x: x, y: DeliveryTypeView.frame.maxY + y, width: deliveryDetailsView.frame.width - (2 * x) , height: (6 * y))
        StichTimeView.layer.cornerRadius = 10
        StichTimeView.layer.masksToBounds = true
        StichTimeView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        deliveryDetailsView.addSubview(StichTimeView)
        
        
        // Label :-
        let StichTimeLabel = UILabel()
        StichTimeLabel.frame = CGRect(x: x, y: 0 , width: StichTimeView.frame.width - (20 * x), height: (6 * y))
        //StichTimeLabel.backgroundColor = UIColor.gray
        StichTimeLabel.text = "Stiching time required for stiches"
        StichTimeLabel.lineBreakMode = .byWordWrapping
        StichTimeLabel.numberOfLines = 2
        StichTimeLabel.textColor = UIColor.white
        StichTimeLabel.textAlignment = .left
        StichTimeLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        StichTimeView.addSubview(StichTimeLabel)
        
        
        // StichColon Label :-
        let StichColonLabel = UILabel()
        StichColonLabel.frame = CGRect(x: StichTimeLabel.frame.maxX, y: 0 , width: 2 * x, height: (6 * y))
       // StichColonLabel.backgroundColor = UIColor.gray
        StichColonLabel.text = "-"
        StichColonLabel.textColor = UIColor.white
        StichColonLabel.textAlignment = .center
        StichColonLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        StichTimeView.addSubview(StichColonLabel)
       
        
        // StichValueLabel :-
        let StichValueLabel = UILabel()
        StichValueLabel.frame = CGRect(x: StichColonLabel.frame.maxX + x, y: 0, width: (15 * x), height: (6 * y))
        // StichValueLabel.backgroundColor = UIColor.gray
        let date = StichingTimesArray[0] as? String
        StichValueLabel.text = "\(date!) Days"
        StichValueLabel.textColor = UIColor.white
        StichValueLabel.textAlignment = .left
        StichValueLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        StichTimeView.addSubview(StichValueLabel)
        
        
        // DeliveryDateView :-
        let DeliveryDateView = UIView()
        DeliveryDateView.frame = CGRect(x: x, y: StichTimeView.frame.maxY + y, width: deliveryDetailsView.frame.width - (2 * x) , height: (6 * y))
        DeliveryDateView.layer.cornerRadius = 10
        DeliveryDateView.layer.masksToBounds = true
        DeliveryDateView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        deliveryDetailsView.addSubview(DeliveryDateView)
 
        // Label :-
        let DeliveryDateLabel = UILabel()
        DeliveryDateLabel.frame = CGRect(x: x, y: 0 , width: DeliveryDateView.frame.width - (20 * x), height: (6 * y))
       // DeliveryDateLabel.backgroundColor = UIColor.gray
        DeliveryDateLabel.text = "Approximate delivery date"
        DeliveryDateLabel.lineBreakMode = .byWordWrapping
        DeliveryDateLabel.numberOfLines = 2
        DeliveryDateLabel.textColor = UIColor.white
        DeliveryDateLabel.textAlignment = .left
        DeliveryDateLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        DeliveryDateView.addSubview(DeliveryDateLabel)
        
        // DateColon Label :-
        let DateColonLabel = UILabel()
        DateColonLabel.frame = CGRect(x: DeliveryDateLabel.frame.maxX, y: 0, width: 2 * x, height: (6 * y))
        //DateColonLabel.backgroundColor = UIColor.gray
        DateColonLabel.text = "-"
        DateColonLabel.textColor = UIColor.white
        DateColonLabel.textAlignment = .center
        DateColonLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        DeliveryDateView.addSubview(DateColonLabel)
        
        // Label :-
        let DateValueLabel = UILabel()
        DateValueLabel.frame = CGRect(x: DateColonLabel.frame.maxX + x, y: 0 , width: (15 * x), height: (6 * y))
        // DateValueLabel.backgroundColor = UIColor.gray
        if let date = DeliveryDateArray[0] as? String
        {
            DeliveryDate = String(date.prefix(10))
        }
        DateValueLabel.text = DeliveryDate
        DateValueLabel.lineBreakMode = .byWordWrapping
        DateValueLabel.numberOfLines = 2
        DateValueLabel.textColor = UIColor.white
        DateValueLabel.textAlignment = .left
        DateValueLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        DeliveryDateView.addSubview(DateValueLabel)
        
        
        // Pay Button :-
        ProceedToPayButton.frame = CGRect(x: 0, y: view.frame.height - (9 * y), width: view.frame.width , height: (4 * y))
        ProceedToPayButton.backgroundColor = UIColor.orange
        ProceedToPayButton.setTitle("PROCEED TO PAY", for: .normal)
        ProceedToPayButton.setTitleColor(UIColor.white, for: .normal)
        ProceedToPayButton.titleLabel?.font =  UIFont(name: "Avenir Next", size: 1.5 * x)
        ProceedToPayButton.addTarget(self, action: #selector(self.ProccedToPayButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(ProceedToPayButton)
        
        ProceedToPayButton.isHidden = isHidden
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                AppointmentsLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                AppointmentsLabels.text = "Appointments"
                AppointmentsLabels.textAlignment = .left
                
                DeliveryTypeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                DeliveryTypeLabel.text = "Delivery Type"
                DeliveryTypeLabel.textAlignment = .left
                
                DeliveryValueLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                DeliveryValueLabel.textAlignment = .left
                
                StichTimeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                StichTimeLabel.text = "Stiching time required for stiches"
                StichTimeLabel.textAlignment = .left
                
                StichValueLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                StichValueLabel.textAlignment = .left
                
                DeliveryDateLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                DeliveryDateLabel.text = "Approximate delivery date"
                DeliveryDateLabel.textAlignment = .left
                
                DateValueLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                DateValueLabel.textAlignment = .left
                
                changeViewToEnglishInSelf()
            }
            else if language == "ar"
            {
                AppointmentsLabels.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                AppointmentsLabels.text = "المواعيد"
                AppointmentsLabels.textAlignment = .right
                
                DeliveryTypeLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                DeliveryTypeLabel.text = "نوع التوصيل"
                DeliveryTypeLabel.textAlignment = .right
                
                DeliveryValueLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                DeliveryValueLabel.textAlignment = .right
                
                StichTimeLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                StichTimeLabel.text = "الوقت المتوقع للخياطة والتفصيل"
                StichTimeLabel.textAlignment = .right
                
                StichValueLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                StichValueLabel.textAlignment = .right
                
                DeliveryDateLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                DeliveryDateLabel.text = "الوقت المتوقع للتوصيل"
                DeliveryDateLabel.textAlignment = .right
                
                DateValueLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                DateValueLabel.textAlignment = .right
                
                changeViewToArabicInSelf()
            }
        }
        else
        {
            AppointmentsLabels.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            AppointmentsLabels.text = "Appointments"
            AppointmentsLabels.textAlignment = .left
            
            DeliveryTypeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            DeliveryTypeLabel.text = "Delivery Type"
            DeliveryTypeLabel.textAlignment = .left
            
            DeliveryValueLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            DeliveryValueLabel.textAlignment = .left
            
            StichTimeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            StichTimeLabel.text = "Stiching time required for stiches"
            StichTimeLabel.textAlignment = .left
            
            StichValueLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            StichValueLabel.textAlignment = .left
            
            DeliveryDateLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            DeliveryDateLabel.text = "Approximate delivery date"
            DeliveryDateLabel.textAlignment = .left
            
            DateValueLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            DateValueLabel.textAlignment = .left
            
            changeViewToEnglishInSelf()
        }
   
    }
    
    @objc func ProccedToPayButtonAction(sender : UIButton)
    {
        qtyNum = Int(QtyNumTF.text!)
       
        print("Qty:",qtyNum)
        let order_Id = UserDefaults.standard.value(forKey: "OrderID") as? Int
        print("order_Id:",order_Id!)
        OrderId = order_Id
        
      if qtyNum != nil
      {
        self.serviceCall.API_UpdateQtyOrderApproval(OrderId: order_Id!, Qty: qtyNum, delegate: self)
         print("Redirect To Next Page.. !")
      }
      else
      {
         let appointmentAlert = UIAlertController(title: "Alert!", message: "Please Enter Quantity..!", preferredStyle: .alert)
         appointmentAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
         self.present(appointmentAlert, animated: true, completion: nil)
      }
        
       
     /*
        let OrderDetailsScreen = OrderDetailsViewController()
        self.navigationController?.pushViewController(OrderDetailsScreen, animated: true)
     */
    }
    
    @objc func CurrencyButtonAction(sender : UIButton)
    {
        print("Pop UP.. !")
    }
    

}
