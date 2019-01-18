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
    
    let PricingButton = UIButton()
    let DeliveryDetailsButton = UIButton()
    let ProceedToPayButton = UIButton()
    let CurrencyButton = UIButton()
    var CurrencyCodes = [String]()
    
    let PricingView = UIView()
    let deliveryDetailsView = UIView()
     let QtyNumTF = UITextField()
    var qtyNum : Int!
    var orderID : Int!
    
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
    
    override func viewDidLoad()
    {
       // print("SUCCESS")
        
         navigationBar.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of seconds
            // Your code with delay
            
       
        self.serviceCall.API_OrderApprovalPrice(TailorResponseId: 27, delegate: self)
            
      //  self.serviceCall.API_OrderApprovalDelivery(TailorResponseId: 27, delegate: self)
        
      //  self.orderApprovalContent()
            
//        self.tab2Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
            self.selectedButton(tag: 1)
            
          self.addDoneButtonOnKeyboard()
            
        }
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  
     
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("Order approval : ", errorMessage)
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
           // print("DressSubType:",DressSubType)
            
            DressImageArray = DressSubType.value(forKey: "Image") as! NSArray
            //print("DressImageArray:",DressImageArray)
            
            DressNameArray = DressSubType.value(forKey: "NameInEnglish") as! NSArray
            //print("DressNameArray:",DressNameArray)
            
            let TailorCharges = Result.object(forKey: "TailorCharges") as! NSArray
           // print("TailorCharges:",TailorCharges)
            
            ChargesNameArray = TailorCharges.value(forKey: "DescInEnglish") as! NSArray
            //print("ChargesNameArray:",ChargesNameArray)
            
            ChargesAmountArray = TailorCharges.value(forKey: "Amount") as! NSArray
           //print("ChargesAmountArray:",ChargesAmountArray)
            
           
        }
        else if ResponseMsg == "Failure"
        {
            let Result = orderApprovalPrice.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetTailorResponseList"
            ErrorStr = Result
            
            DeviceError()
            
        }
        
        self.serviceCall.API_OrderApprovalDelivery(TailorResponseId: 27, delegate: self)
        
        // self.orderApprovalContent()
    }
    
    func API_CALLBACK_OrderApprovalDelivery(orderApprovalDelivery: NSDictionary)
    {
        
        let ResponseMsg = orderApprovalDelivery.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = orderApprovalDelivery.object(forKey: "Result") as! NSDictionary
            print("Result", Result)
         
            let Appointments = Result.object(forKey: "Appoinments") as! NSArray
            AppoinmentArray = Appointments.value(forKey: "Appoinment") as! NSArray
            print("AppoinmentArray", AppoinmentArray)
            
            let DeliveryDate = Result.object(forKey: "DeliveryDate") as! NSArray
            DeliveryDateArray = DeliveryDate.value(forKey: "DeliveryDate") as! NSArray
            print("DeliveryDateArray", DeliveryDateArray)
            
            let DeliveryTypes = Result.object(forKey: "DeliveryTypes") as! NSArray
            DeliveryTypeArray = DeliveryTypes.value(forKey: "DeliveryType") as! NSArray
            print("DeliveryTypes", DeliveryTypes)
            
            let StichingTime = Result.object(forKey: "StichingTime") as! NSArray
            StichingTimesArray = StichingTime.value(forKey: "StichingTimes") as! NSArray
            print("StichingTime", StichingTime)
            
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
            
            let appointmentAlert = UIAlertController(title: "Info!", message: "Please Book An Appointment Before Proceed to Pay", preferredStyle: .alert)
            appointmentAlert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: proceedAlertAction(action:)))
            appointmentAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(appointmentAlert, animated: true, completion: nil)
            
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
        AppointmentScreen.OrderID = orderID
        self.navigationController?.pushViewController(AppointmentScreen, animated: true)
    }
    
    func orderApprovalContent()
    {
        self.stopActivity()
        
        let orderApprovalNavigationBar = UIView()
        orderApprovalNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        orderApprovalNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(orderApprovalNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 4
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        orderApprovalNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: orderApprovalNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "ORDER APPROVAL"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        orderApprovalNavigationBar.addSubview(navigationTitle)
        
        let DressDetView = UIView()
        DressDetView.frame = CGRect(x: x + 15 , y: orderApprovalNavigationBar.frame.maxY + y, width: view.frame.width - (5 * x), height: (10 * y))
        DressDetView.layer.cornerRadius = 5
        DressDetView.layer.borderWidth = 1
        DressDetView.layer.backgroundColor = UIColor.orange.cgColor
        DressDetView.layer.borderColor = UIColor.black.cgColor
        view.addSubview(DressDetView)
        
        let DressImageView = UIImageView()
        DressImageView.frame = CGRect(x: x, y: y, width: (8 * x), height:(8 * y))
        DressImageView.backgroundColor = UIColor.white
        if let imageName = DressImageArray[0] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/DressSubType/\(imageName)"
          //  let api = "http://192.168.0.21/TailorAPI/Images/DressSubType/\(imageName)"
            let apiurl = URL(string: api)
            print("Image Of Dress", apiurl!)
            DressImageView.dowloadFromServer(url: apiurl!)
        }
        DressDetView.addSubview(DressImageView)
        
        let DressTypeLabel = UILabel()
        DressTypeLabel.frame = CGRect(x: DressImageView.frame.maxX + x, y: DressDetView.frame.minY - (6 * y), width: (20 * x), height: (2 * y))
        DressTypeLabel.text = DressNameArray[0] as? String
        DressTypeLabel.textColor = UIColor.white
    //  DressTypeLabel.backgroundColor = UIColor.gray
        DressTypeLabel.textAlignment = .left
        DressTypeLabel.font = UIFont(name: "Avenir Next", size: 1.5 * x)
        DressDetView.addSubview(DressTypeLabel)
        
     /*
        let ColorLabel = UILabel()
        ColorLabel.frame = CGRect(x: DressImageView.frame.maxX + x, y: DressTypeLabel.frame.minY + (2.5 * y), width: (6 * x), height: (2 * y))
        ColorLabel.text = "Color  : "
        ColorLabel.textColor = UIColor.white
        ColorLabel.textAlignment = .left
        ColorLabel.font = UIFont(name: "Avenir Next", size: 14)
        DressDetView.addSubview(ColorLabel)
        
        let ColorTypeLabel = UILabel()
        ColorTypeLabel.frame = CGRect(x: ColorLabel.frame.maxX , y: DressTypeLabel.frame.minY + (2.5 * y), width: (8 * x), height: (2 * y))
        ColorTypeLabel.text = "Grey"
       // ColorTypeLabel.backgroundColor = UIColor.gray
        ColorTypeLabel.textColor = UIColor.white
        ColorTypeLabel.textAlignment = .left
        ColorTypeLabel.font = UIFont(name: "Avenir Next", size: 14)
        DressDetView.addSubview(ColorTypeLabel)
     */
        
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
        QtyNumTF.textColor = UIColor.black
        QtyNumTF.textAlignment = .left
        QtyNumTF.font = QtyNumTF.font!.withSize(14)
        QtyNumTF.adjustsFontSizeToFitWidth = true
        QtyNumTF.keyboardType = .numberPad
        QtyNumTF.clearsOnBeginEditing = true
        QtyNumTF.returnKeyType = .done
        QtyNumTF.delegate = self
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func PricingViewContents(isHidden : Bool)
    {
        PricingView.frame = CGRect(x: (3 * x), y: DeliveryDetailsButton.frame.maxY + y , width: view.frame.width - (4 * x), height: view.frame.height - (30 * y))
        PricingView.backgroundColor = UIColor.clear
        view.addSubview(PricingView)
        
        let backgroundImage = UIImageView()
        backgroundImage.frame = CGRect(x: 0, y: 0, width: PricingView.frame.width, height: PricingView.frame.height)
        backgroundImage.image = UIImage(named: "background")
//        PricingView.addSubview(backgroundImage)
 
        PricingView.isHidden = isHidden
       
        // Currency Button:-
        CurrencyButton.frame = CGRect(x: (24 * x), y: PricingView.frame.minY - (22 * y), width: (8 * x), height: (2 * y))
        CurrencyButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        CurrencyButton.setTitle("AED", for: .normal)
        CurrencyButton.setTitleColor(UIColor.white, for: .normal)
        CurrencyButton.titleLabel?.font =  UIFont(name: "Avenir Next", size: 1.5 * x)
        CurrencyButton.layer.cornerRadius = 5;  // this value vary as per your desire
        CurrencyButton.clipsToBounds = true;
        CurrencyButton.addTarget(self, action: #selector(self.CurrencyButtonAction(sender:)), for: .touchUpInside)
        PricingView.addSubview(CurrencyButton)
        
        let downArrowImageView = UIImageView()
        downArrowImageView.frame = CGRect(x: CurrencyButton.frame.width - 15, y: ((CurrencyButton.frame.height - (1.5 * x)) / 2), width: (1.5 * x), height: (1.5 * y))
        downArrowImageView.image = UIImage(named: "downArrow")
        CurrencyButton.addSubview(downArrowImageView)
        
        // MeasurementChargesLabel..
        let MeasurementChargesLabel = UILabel()
        MeasurementChargesLabel.frame = CGRect(x: x, y: CurrencyButton.frame.minY + (4 * y), width: (PricingView.frame.width / 2), height: 30)
       // MeasurementChargesLabel.backgroundColor = UIColor.gray
        MeasurementChargesLabel.text = "Measurement Charges"
        MeasurementChargesLabel.textColor = UIColor.black
        MeasurementChargesLabel.textAlignment = .left
        MeasurementChargesLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
       // MeasurementChargesLabel.font = MeasurementChargesLabel.font.withSize(14)
        PricingView.addSubview(MeasurementChargesLabel)
      
        let MeasureRupeeValueLBL = UILabel()
        MeasureRupeeValueLBL.frame = CGRect(x: MeasurementChargesLabel.frame.maxX + (2 * x) , y: CurrencyButton.frame.minY + (4 * y), width: (10 * x), height: 30)
       // MeasureRupeeValueLBL.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        let MeasureRupeeValue : Int = ChargesAmountArray[4] as! Int
        MeasureRupeeValueLBL.text =  "\(MeasureRupeeValue)"
        MeasureRupeeValueLBL.textColor = UIColor.blue
        MeasureRupeeValueLBL.textAlignment = .center
        MeasureRupeeValueLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PricingView.addSubview(MeasureRupeeValueLBL)
        
    /*
        //TextField1..
        let MeasureRupeeTF = UITextField()
        MeasureRupeeTF.frame = CGRect(x: MeasurementChargesLabel.frame.maxX + (2 * x), y: CurrencyButton.frame.minY + (4 * y), width: (6 * x), height: 30)
        MeasureRupeeTF.backgroundColor = UIColor.white
        MeasureRupeeTF.layer.borderColor = UIColor.lightGray.cgColor
        MeasureRupeeTF.layer.borderWidth = 1.0
        MeasureRupeeTF.text = "750"
        MeasureRupeeTF.textColor = UIColor.blue
        MeasureRupeeTF.textAlignment = .center
        MeasureRupeeTF.font = MeasureRupeeTF.font!.withSize(12)
        PricingView.addSubview(MeasureRupeeTF)
        
        //TextField2..
        let MeasurePaiseTF = UITextField()
        MeasurePaiseTF.frame = CGRect(x: MeasureRupeeTF.frame.maxX + 1, y: CurrencyButton.frame.minY + (4 * y), width: (4 * x), height: 30)
        MeasurePaiseTF.backgroundColor = UIColor.white
        MeasurePaiseTF.layer.borderColor = UIColor.lightGray.cgColor
        MeasurePaiseTF.layer.borderWidth = 1.0
        MeasurePaiseTF.text = "00"
        MeasurePaiseTF.textColor = UIColor.blue
        MeasurePaiseTF.textAlignment = .center
        MeasurePaiseTF.font = MeasurePaiseTF.font!.withSize(12)
        PricingView.addSubview(MeasurePaiseTF)
   */
        
        // CurrencyLabel..
        let CurrencyLabel = UILabel()
        CurrencyLabel.frame = CGRect(x: MeasureRupeeValueLBL.frame.maxX + 1, y: CurrencyButton.frame.minY + (4 * y), width: (3 * x), height: 30)
       // CurrencyLabel.backgroundColor = UIColor.gray
        CurrencyLabel.text = "AED"
        CurrencyLabel.textColor = UIColor.blue
        CurrencyLabel.textAlignment = .center
        CurrencyLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PricingView.addSubview(CurrencyLabel)
        
        
        // Customization and Stiching Charges Label..
        let StichingChargesLabel = UILabel()
        StichingChargesLabel.frame = CGRect(x: x, y: MeasurementChargesLabel.frame.maxY + 8 , width: (PricingView.frame.width / 2), height: 40)
       // StichingChargesLabel.backgroundColor = UIColor.gray
        StichingChargesLabel.text = "Customization and Stiching Charges"
        StichingChargesLabel.textColor = UIColor.black
        StichingChargesLabel.textAlignment = .left
        StichingChargesLabel.lineBreakMode = .byWordWrapping
        StichingChargesLabel.numberOfLines = 2
        StichingChargesLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PricingView.addSubview(StichingChargesLabel)
      
        
        let StichingRupeeValueLBL = UILabel()
        StichingRupeeValueLBL.frame = CGRect(x: StichingChargesLabel.frame.maxX + (2 * x) , y: MeasurementChargesLabel.frame.minY + (4 * y), width: (10 * x), height: 30)
        // MeasureRupeeValueLBL.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        let StichingRupeeValue : Int = ChargesAmountArray[1] as! Int
        StichingRupeeValueLBL.text =  "\(StichingRupeeValue)"
        StichingRupeeValueLBL.textColor = UIColor.blue
        StichingRupeeValueLBL.textAlignment = .center
        StichingRupeeValueLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PricingView.addSubview(StichingRupeeValueLBL)
        
        
      /*
        //TextField1..
        let StichingRupeeTF = UITextField()
        StichingRupeeTF.frame = CGRect(x: StichingChargesLabel.frame.maxX + (2 * x), y: MeasurementChargesLabel.frame.minY + (4 * y), width: (6 * x), height: 30)
        StichingRupeeTF.backgroundColor = UIColor.white
        StichingRupeeTF.layer.borderColor = UIColor.lightGray.cgColor
        StichingRupeeTF.layer.borderWidth = 1.0
        StichingRupeeTF.text = "4205"
        StichingRupeeTF.textColor = UIColor.blue
        StichingRupeeTF.textAlignment = .center
        StichingRupeeTF.font = StichingRupeeTF.font!.withSize(12)
        PricingView.addSubview(StichingRupeeTF)
        
        //TextField2..
        let StichingPaiseTF = UITextField()
        StichingPaiseTF.frame = CGRect(x: StichingRupeeTF.frame.maxX + 1, y: MeasurementChargesLabel.frame.minY + (4 * y), width: (4 * x), height: 30)
        StichingPaiseTF.backgroundColor = UIColor.white
        StichingPaiseTF.layer.borderColor = UIColor.lightGray.cgColor
        StichingPaiseTF.layer.borderWidth = 1.0
        StichingPaiseTF.text = "00"
        StichingPaiseTF.textColor = UIColor.blue
        StichingPaiseTF.textAlignment = .center
        StichingPaiseTF.font = StichingPaiseTF.font!.withSize(12)
        PricingView.addSubview(StichingPaiseTF)
       */
        
        // CurrencyLabel..
        let StichingCurrLabel = UILabel()
        StichingCurrLabel.frame = CGRect(x: StichingRupeeValueLBL.frame.maxX + 1, y: MeasurementChargesLabel.frame.minY + (4 * y), width: (3 * x), height: 30)
      //  StichingCurrLabel.backgroundColor = UIColor.gray
        StichingCurrLabel.text = "AED"
        StichingCurrLabel.textColor = UIColor.blue
        StichingCurrLabel.textAlignment = .center
        StichingCurrLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PricingView.addSubview(StichingCurrLabel)
        
        
        // Appointment Charges Label..
        let AppointmentChargesLabel = UILabel()
        AppointmentChargesLabel.frame = CGRect(x: x, y: StichingChargesLabel.frame.maxY + 8 , width: (PricingView.frame.width / 2), height: 30)
      //  AppointmentChargesLabel.backgroundColor = UIColor.gray
        AppointmentChargesLabel.text = "Appointment Charges"
        AppointmentChargesLabel.textColor = UIColor.black
        AppointmentChargesLabel.textAlignment = .left
        AppointmentChargesLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PricingView.addSubview(AppointmentChargesLabel)
        
      /*
        //TextField1..
        let AppointmentRupeeTF = UITextField()
        AppointmentRupeeTF.frame = CGRect(x: AppointmentChargesLabel.frame.maxX + (2 * x), y: StichingChargesLabel.frame.minY + (4 * y), width: (6 * x), height: 30)
        AppointmentRupeeTF.backgroundColor = UIColor.white
        AppointmentRupeeTF.layer.borderColor = UIColor.lightGray.cgColor
        AppointmentRupeeTF.layer.borderWidth = 1.0
        AppointmentRupeeTF.text = "300"
        AppointmentRupeeTF.textColor = UIColor.blue
        AppointmentRupeeTF.textAlignment = .center
        AppointmentRupeeTF.font = AppointmentRupeeTF.font!.withSize(12)
        PricingView.addSubview(AppointmentRupeeTF)
        
        //TextField2..
        let AppointmentPaiseTF = UITextField()
        AppointmentPaiseTF.frame = CGRect(x: AppointmentRupeeTF.frame.maxX + 1, y: StichingChargesLabel.frame.minY + (4 * y), width: (4 * x), height: 30)
        AppointmentPaiseTF.backgroundColor = UIColor.white
        AppointmentPaiseTF.layer.borderColor = UIColor.lightGray.cgColor
        AppointmentPaiseTF.layer.borderWidth = 1.0
        AppointmentPaiseTF.text = "00"
        AppointmentPaiseTF.textColor = UIColor.blue
        AppointmentPaiseTF.textAlignment = .center
        AppointmentPaiseTF.font = AppointmentPaiseTF.font!.withSize(12)
        PricingView.addSubview(AppointmentPaiseTF)
       */
        
        let AppointmentRupeeValueLBL = UILabel()
        AppointmentRupeeValueLBL.frame = CGRect(x: StichingChargesLabel.frame.maxX + (2 * x) , y: StichingChargesLabel.frame.minY + (4 * y), width: (10 * x), height: 30)
        // MeasureRupeeValueLBL.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        let AppointmentRupeeValue : Int = ChargesAmountArray[0] as! Int
        AppointmentRupeeValueLBL.text =  "\(AppointmentRupeeValue)"
        AppointmentRupeeValueLBL.textColor = UIColor.blue
        AppointmentRupeeValueLBL.textAlignment = .center
        AppointmentRupeeValueLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PricingView.addSubview(AppointmentRupeeValueLBL)
        
        // CurrencyLabel..
        let AppointmentCurrLabel = UILabel()
        AppointmentCurrLabel.frame = CGRect(x: AppointmentRupeeValueLBL.frame.maxX + 1, y: StichingChargesLabel.frame.minY + (4 * y), width: (3 * x), height: 30)
      //  AppointmentCurrLabel.backgroundColor = UIColor.gray
        AppointmentCurrLabel.text = "AED"
        AppointmentCurrLabel.textColor = UIColor.blue
        AppointmentCurrLabel.textAlignment = .center
        AppointmentCurrLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PricingView.addSubview(AppointmentCurrLabel)
        
        
        // Material Delivery Charges Label..
        let MaterialDeliveryChargesLabel = UILabel()
        MaterialDeliveryChargesLabel.frame = CGRect(x: x, y: AppointmentChargesLabel.frame.maxY + 8 , width: (PricingView.frame.width / 2), height: 30)
      //  MaterialDeliveryChargesLabel.backgroundColor = UIColor.gray
        MaterialDeliveryChargesLabel.text = "Material Delivery Charges"
        MaterialDeliveryChargesLabel.textColor = UIColor.black
        MaterialDeliveryChargesLabel.textAlignment = .left
        MaterialDeliveryChargesLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PricingView.addSubview(MaterialDeliveryChargesLabel)
        
        /*
        //TextField1..
        let MaterialRupeeTF = UITextField()
        MaterialRupeeTF.frame = CGRect(x: MaterialDeliveryChargesLabel.frame.maxX + (2 * x), y: AppointmentChargesLabel.frame.minY + (3 * y), width: (6 * x), height: 30)
        MaterialRupeeTF.backgroundColor = UIColor.white
        MaterialRupeeTF.layer.borderColor = UIColor.lightGray.cgColor
        MaterialRupeeTF.layer.borderWidth = 1.0
        MaterialRupeeTF.text = "750"
        MaterialRupeeTF.textColor = UIColor.blue
        MaterialRupeeTF.textAlignment = .center
        MaterialRupeeTF.font = MaterialRupeeTF.font!.withSize(12)
        PricingView.addSubview(MaterialRupeeTF)
        
        //TextField2..
        let MaterialPaiseTF = UITextField()
        MaterialPaiseTF.frame = CGRect(x: MaterialRupeeTF.frame.maxX + 1, y: AppointmentChargesLabel.frame.minY + (3 * y), width: (4 * x), height: 30)
        MaterialPaiseTF.backgroundColor = UIColor.white
        MaterialPaiseTF.layer.borderColor = UIColor.lightGray.cgColor
        MaterialPaiseTF.layer.borderWidth = 1.0
        MaterialPaiseTF.text = "00"
        MaterialPaiseTF.textColor = UIColor.blue
        MaterialPaiseTF.textAlignment = .center
        MaterialPaiseTF.font = MaterialPaiseTF.font!.withSize(12)
        PricingView.addSubview(MaterialPaiseTF)
        */
        
        let MaterialRupeeValueLBL = UILabel()
        MaterialRupeeValueLBL.frame = CGRect(x: MaterialDeliveryChargesLabel.frame.maxX + (2 * x) , y: AppointmentChargesLabel.frame.minY + (3 * y), width: (10 * x), height: 30)
        // MeasureRupeeValueLBL.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        let MaterialRupeeValue : Int = ChargesAmountArray[3] as! Int
        MaterialRupeeValueLBL.text =  "\(MaterialRupeeValue)"
        MaterialRupeeValueLBL.textColor = UIColor.blue
        MaterialRupeeValueLBL.textAlignment = .center
        MaterialRupeeValueLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PricingView.addSubview(MaterialRupeeValueLBL)
        
        // CurrencyLabel..
        let MaterialCurrLabel = UILabel()
        MaterialCurrLabel.frame = CGRect(x: MaterialRupeeValueLBL.frame.maxX + 1, y: AppointmentChargesLabel.frame.minY + (3 * y), width: (3 * x), height: 30)
       // MaterialCurrLabel.backgroundColor = UIColor.gray
        MaterialCurrLabel.text = "AED"
        MaterialCurrLabel.textColor = UIColor.blue
        MaterialCurrLabel.textAlignment = .center
        MaterialCurrLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PricingView.addSubview(MaterialCurrLabel)
        
        
        // Urgent Stiching Charges Label..
        let UrgentStichChargesLabel = UILabel()
        UrgentStichChargesLabel.frame = CGRect(x: x, y: MaterialDeliveryChargesLabel.frame.maxY + 8 , width: (PricingView.frame.width / 2), height: 30)
      //  UrgentStichChargesLabel.backgroundColor = UIColor.gray
        UrgentStichChargesLabel.text = "Urgent Stiching Charges"
        UrgentStichChargesLabel.textColor = UIColor.black
        UrgentStichChargesLabel.textAlignment = .left
        UrgentStichChargesLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PricingView.addSubview(UrgentStichChargesLabel)
        
        /*
        //TextField1..
        let UrgentRupeeTF = UITextField()
        UrgentRupeeTF.frame = CGRect(x: UrgentStichChargesLabel.frame.maxX + (2 * x), y: MaterialDeliveryChargesLabel.frame.minY + (3 * y), width: (6 * x), height: 30)
        UrgentRupeeTF.backgroundColor = UIColor.white
        UrgentRupeeTF.layer.borderColor = UIColor.lightGray.cgColor
        UrgentRupeeTF.layer.borderWidth = 1.0
        UrgentRupeeTF.text = "800"
        UrgentRupeeTF.textColor = UIColor.blue
        UrgentRupeeTF.textAlignment = .center
        UrgentRupeeTF.font = UrgentRupeeTF.font!.withSize(12)
        PricingView.addSubview(UrgentRupeeTF)
        
        //TextField2..
        let UrgentPaiseTF = UITextField()
        UrgentPaiseTF.frame = CGRect(x: UrgentRupeeTF.frame.maxX + 1, y: MaterialDeliveryChargesLabel.frame.minY + (3 * y), width: (4 * x), height: 30)
        UrgentPaiseTF.backgroundColor = UIColor.white
        UrgentPaiseTF.layer.borderColor = UIColor.lightGray.cgColor
        UrgentPaiseTF.layer.borderWidth = 1.0
        UrgentPaiseTF.text = "00"
        UrgentPaiseTF.textColor = UIColor.blue
        UrgentPaiseTF.textAlignment = .center
        UrgentPaiseTF.font = UrgentPaiseTF.font!.withSize(12)
        PricingView.addSubview(UrgentPaiseTF)
        */
        
        let UrgentStichValueLBL = UILabel()
        UrgentStichValueLBL.frame = CGRect(x: UrgentStichChargesLabel.frame.maxX + (2 * x) , y: MaterialDeliveryChargesLabel.frame.minY + (3 * y), width: (10 * x), height: 30)
        // MeasureRupeeValueLBL.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        let UrgentStichValue : Int = ChargesAmountArray[8] as! Int
        UrgentStichValueLBL.text =  "\(UrgentStichValue)"
        UrgentStichValueLBL.textColor = UIColor.blue
        UrgentStichValueLBL.textAlignment = .center
        UrgentStichValueLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PricingView.addSubview(UrgentStichValueLBL)
        
        // CurrencyLabel..
        let UrgentCurrLabel = UILabel()
        UrgentCurrLabel.frame = CGRect(x: UrgentStichValueLBL.frame.maxX + 1, y: MaterialDeliveryChargesLabel.frame.minY + (3 * y), width: (3 * x), height: 30)
       // UrgentCurrLabel.backgroundColor = UIColor.gray
        UrgentCurrLabel.text = "AED"
        UrgentCurrLabel.textColor = UIColor.blue
        UrgentCurrLabel.textAlignment = .center
        UrgentCurrLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PricingView.addSubview(UrgentCurrLabel)
        
        
        // Delivery Charges Label..
        let DeliveryChargesLabel = UILabel()
        DeliveryChargesLabel.frame = CGRect(x: x, y: UrgentStichChargesLabel.frame.maxY + 8 , width: (PricingView.frame.width / 2), height: 30)
      //  DeliveryChargesLabel.backgroundColor = UIColor.gray
        DeliveryChargesLabel.text = "Delivery Charges"
        DeliveryChargesLabel.textColor = UIColor.black
        DeliveryChargesLabel.textAlignment = .left
        DeliveryChargesLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PricingView.addSubview(DeliveryChargesLabel)
       
        /*
        //TextField1..
        let DeliveryRupeeTF = UITextField()
        DeliveryRupeeTF.frame = CGRect(x: DeliveryChargesLabel.frame.maxX + (2 * x), y: UrgentStichChargesLabel.frame.minY + (3 * y), width: (6 * x), height: 30)
        DeliveryRupeeTF.backgroundColor = UIColor.white
        DeliveryRupeeTF.layer.borderColor = UIColor.lightGray.cgColor
        DeliveryRupeeTF.layer.borderWidth = 1.0
        DeliveryRupeeTF.text = "100"
        DeliveryRupeeTF.textColor = UIColor.blue
        DeliveryRupeeTF.textAlignment = .center
        DeliveryRupeeTF.font = DeliveryRupeeTF.font!.withSize(12)
        PricingView.addSubview(DeliveryRupeeTF)
        
        //TextField2..
        let DeliveryPaiseTF = UITextField()
        DeliveryPaiseTF.frame = CGRect(x: DeliveryRupeeTF.frame.maxX + 1, y: UrgentStichChargesLabel.frame.minY + (3 * y), width: (4 * x), height: 30)
        DeliveryPaiseTF.backgroundColor = UIColor.white
        DeliveryPaiseTF.layer.borderColor = UIColor.lightGray.cgColor
        DeliveryPaiseTF.layer.borderWidth = 1.0
        DeliveryPaiseTF.text = "00"
        DeliveryPaiseTF.textColor = UIColor.blue
        DeliveryPaiseTF.textAlignment = .center
        DeliveryPaiseTF.font = DeliveryPaiseTF.font!.withSize(12)
        PricingView.addSubview(DeliveryPaiseTF)
       */
        
        let DeliveryRupeeValueLBL = UILabel()
        DeliveryRupeeValueLBL.frame = CGRect(x: DeliveryChargesLabel.frame.maxX + (2 * x) , y: UrgentStichChargesLabel.frame.minY + (3 * y), width: (10 * x), height: 30)
        // MeasureRupeeValueLBL.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        let DeliveryRupeeValue : Int = ChargesAmountArray[2] as! Int
        DeliveryRupeeValueLBL.text =  "\(DeliveryRupeeValue)"
        DeliveryRupeeValueLBL.textColor = UIColor.blue
        DeliveryRupeeValueLBL.textAlignment = .center
        DeliveryRupeeValueLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PricingView.addSubview(DeliveryRupeeValueLBL)
        
        // CurrencyLabel..
        let DeliveryCurrLabel = UILabel()
        DeliveryCurrLabel.frame = CGRect(x: DeliveryRupeeValueLBL.frame.maxX + 1, y: UrgentStichChargesLabel.frame.minY + (3 * y), width: (3 * x), height: 30)
      //  DeliveryCurrLabel.backgroundColor = UIColor.gray
        DeliveryCurrLabel.text = "AED"
        DeliveryCurrLabel.textColor = UIColor.blue
        DeliveryCurrLabel.textAlignment = .center
        DeliveryCurrLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PricingView.addSubview(DeliveryCurrLabel)
        
        
        // Service Charges Label..
        let ServiceChargesLabel = UILabel()
        ServiceChargesLabel.frame = CGRect(x: x, y: DeliveryChargesLabel.frame.maxY + 8 , width: (PricingView.frame.width / 2), height: 30)
       // ServiceChargesLabel.backgroundColor = UIColor.gray
        ServiceChargesLabel.text = "Service Charges"
        ServiceChargesLabel.textColor = UIColor.black
        ServiceChargesLabel.textAlignment = .left
        ServiceChargesLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PricingView.addSubview(ServiceChargesLabel)
        
       /*
        //TextField1..
        let ServiceRupeeTF = UITextField()
        ServiceRupeeTF.frame = CGRect(x: ServiceChargesLabel.frame.maxX + (2 * x), y: DeliveryChargesLabel.frame.minY + (3 * y), width: (6 * x), height: 30)
        ServiceRupeeTF.backgroundColor = UIColor.white
        ServiceRupeeTF.layer.borderColor = UIColor.lightGray.cgColor
        ServiceRupeeTF.layer.borderWidth = 1.0
        ServiceRupeeTF.text = "150"
        ServiceRupeeTF.textColor = UIColor.blue
        ServiceRupeeTF.textAlignment = .center
        ServiceRupeeTF.font = ServiceRupeeTF.font!.withSize(12)
        PricingView.addSubview(ServiceRupeeTF)
        
        //TextField2..
        let ServicePaiseTF = UITextField()
        ServicePaiseTF.frame = CGRect(x: ServiceRupeeTF.frame.maxX + 1, y: DeliveryChargesLabel.frame.minY + (3 * y), width: (4 * x), height: 30)
        ServicePaiseTF.backgroundColor = UIColor.white
        ServicePaiseTF.layer.borderColor = UIColor.lightGray.cgColor
        ServicePaiseTF.layer.borderWidth = 1.0
        ServicePaiseTF.text = "00"
        ServicePaiseTF.textColor = UIColor.blue
        ServicePaiseTF.textAlignment = .center
        ServicePaiseTF.font = ServicePaiseTF.font!.withSize(12)
        PricingView.addSubview(ServicePaiseTF)
        */
        
        let ServiceRupeeValueLBL = UILabel()
        ServiceRupeeValueLBL.frame = CGRect(x: ServiceChargesLabel.frame.maxX + (2 * x) , y: DeliveryChargesLabel.frame.minY + (3 * y), width: (10 * x), height: 30)
        // MeasureRupeeValueLBL.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        let ServiceRupeeValue : Int = ChargesAmountArray[5] as! Int
        ServiceRupeeValueLBL.text =  "\(ServiceRupeeValue)"
        ServiceRupeeValueLBL.textColor = UIColor.blue
        ServiceRupeeValueLBL.textAlignment = .center
        ServiceRupeeValueLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PricingView.addSubview(ServiceRupeeValueLBL)
        
        // CurrencyLabel..
        let ServiceCurrLabel = UILabel()
        ServiceCurrLabel.frame = CGRect(x: ServiceRupeeValueLBL.frame.maxX + 1, y: DeliveryChargesLabel.frame.minY + (3 * y), width: (3 * x), height: 30)
     //   ServiceCurrLabel.backgroundColor = UIColor.gray
        ServiceCurrLabel.text = "AED"
        ServiceCurrLabel.textColor = UIColor.blue
        ServiceCurrLabel.textAlignment = .center
        ServiceCurrLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PricingView.addSubview(ServiceCurrLabel)
        
        
        // Tax Charges Label..
        let TaxChargesLabel = UILabel()
        TaxChargesLabel.frame = CGRect(x: x, y: ServiceChargesLabel.frame.maxY + 8 , width: (PricingView.frame.width / 2), height: 30)
    //    TaxChargesLabel.backgroundColor = UIColor.gray
        TaxChargesLabel.text = "Tax"
        TaxChargesLabel.textColor = UIColor.black
        TaxChargesLabel.textAlignment = .left
        TaxChargesLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PricingView.addSubview(TaxChargesLabel)
       
        /*
        //TextField1..
        let TaxRupeeTF = UITextField()
        TaxRupeeTF.frame = CGRect(x: TaxChargesLabel.frame.maxX + (2 * x), y: ServiceChargesLabel.frame.minY + (3 * y), width: (6 * x), height: 30)
        TaxRupeeTF.backgroundColor = UIColor.white
        TaxRupeeTF.layer.borderColor = UIColor.lightGray.cgColor
        TaxRupeeTF.layer.borderWidth = 1.0
        TaxRupeeTF.text = "750"
        TaxRupeeTF.textColor = UIColor.blue
        TaxRupeeTF.textAlignment = .center
        TaxRupeeTF.font = TaxRupeeTF.font!.withSize(12)
        PricingView.addSubview(TaxRupeeTF)
        
        //TextField2..
        let TaxPaiseTF = UITextField()
        TaxPaiseTF.frame = CGRect(x: TaxRupeeTF.frame.maxX + 1, y: ServiceChargesLabel.frame.minY + (3 * y), width: (4 * x), height: 30)
        TaxPaiseTF.backgroundColor = UIColor.white
        TaxPaiseTF.layer.borderColor = UIColor.lightGray.cgColor
        TaxPaiseTF.layer.borderWidth = 1.0
        TaxPaiseTF.text = "00"
        TaxPaiseTF.textColor = UIColor.blue
        TaxPaiseTF.textAlignment = .center
        TaxPaiseTF.font = TaxPaiseTF.font!.withSize(12)
        PricingView.addSubview(TaxPaiseTF)
       */
        
        let TaxRupeeValueLBL = UILabel()
        TaxRupeeValueLBL.frame = CGRect(x: ServiceChargesLabel.frame.maxX + (2 * x) , y: ServiceChargesLabel.frame.minY + (3 * y), width: (10 * x), height: 30)
        // MeasureRupeeValueLBL.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        let TaxRupeeValue : Int = ChargesAmountArray[6] as! Int
        TaxRupeeValueLBL.text =  "\(TaxRupeeValue)"
        TaxRupeeValueLBL.textColor = UIColor.blue
        TaxRupeeValueLBL.textAlignment = .center
        TaxRupeeValueLBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PricingView.addSubview(TaxRupeeValueLBL)
        
        // CurrencyLabel..
        let TaxCurrLabel = UILabel()
        TaxCurrLabel.frame = CGRect(x: TaxRupeeValueLBL.frame.maxX + 1, y: ServiceChargesLabel.frame.minY + (3 * y), width: (3 * x), height: 30)
      //  TaxCurrLabel.backgroundColor = UIColor.gray
        TaxCurrLabel.text = "AED"
        TaxCurrLabel.textColor = UIColor.blue
        TaxCurrLabel.textAlignment = .center
        TaxCurrLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PricingView.addSubview(TaxCurrLabel)
        
        
        // Upper_UnderLine..
        let PriceUpperUnderline = UILabel()
        PriceUpperUnderline.frame = CGRect(x: x, y: TaxChargesLabel.frame.maxY + (y / 2), width: PricingView.frame.width - x, height: 0.5)
        PriceUpperUnderline.backgroundColor = UIColor.lightGray
        PricingView.addSubview(PriceUpperUnderline)
        
        // Grand Total...
        let OrderTotalLabel = UILabel()
        OrderTotalLabel.frame = CGRect(x: x, y: TaxChargesLabel.frame.minY + (4 * y), width: (PricingView.frame.width / 2), height: 30)
       // OrderTotalLabel.backgroundColor = UIColor.gray
        OrderTotalLabel.text = "ORDER TOTAL"
        OrderTotalLabel.textColor = UIColor.blue
        OrderTotalLabel.textAlignment = .left
        OrderTotalLabel.font = UIFont(name: "Avenir Next", size: 1.5 * x)
        PricingView.addSubview(OrderTotalLabel)
        
        let OrderTotalValueLBL = UILabel()
        OrderTotalValueLBL.frame = CGRect(x: OrderTotalLabel.frame.maxX + (2 * x) , y: TaxChargesLabel.frame.minY + (4 * y), width: (10 * x), height: 30)
        OrderTotalValueLBL.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        let OrderTotalValue : Int = ChargesAmountArray[7] as! Int
        OrderTotalValueLBL.text =  "\(OrderTotalValue)"
        OrderTotalValueLBL.textColor = UIColor.white
        OrderTotalValueLBL.textAlignment = .center
        OrderTotalValueLBL.font = UIFont(name: "Avenir Next", size: 1.5 * x)
        PricingView.addSubview(OrderTotalValueLBL)
        
        // CurrencyLabel..
        let TotalCurrLabel = UILabel()
        TotalCurrLabel.frame = CGRect(x: OrderTotalValueLBL.frame.maxX + 1, y: TaxChargesLabel.frame.minY + (4 * y), width: (3 * x), height: 30)
        //TaxCurrLabel.backgroundColor = UIColor.gray
        TotalCurrLabel.text = "AED"
        TotalCurrLabel.textColor = UIColor.blue
        TotalCurrLabel.textAlignment = .center
        TotalCurrLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
        PricingView.addSubview(TotalCurrLabel)
     
        // Lower_UnderLine..
        let PriceLowerUnderline = UILabel()
        PriceLowerUnderline.frame = CGRect(x: x, y: OrderTotalLabel.frame.maxY + (y / 2), width: PricingView.frame.width - x, height: 0.5)
        PriceLowerUnderline.backgroundColor = UIColor.lightGray
        PricingView.addSubview(PriceLowerUnderline)
        
         ProceedToPayButton.isHidden = true
    }
    
    func DeliveryDetailsViewContents(isHidden : Bool)
    {
        
       // let deliveryDetailsView = UIView()
        deliveryDetailsView.frame = CGRect(x: (3 * x), y: DeliveryDetailsButton.frame.maxY + y , width: view.frame.width - (4 * x), height: view.frame.height - (32 * y))
       deliveryDetailsView.backgroundColor = UIColor.clear
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
           AppointmentsLabels.frame = CGRect(x: x, y: AppointmentsView.frame.minY , width:AppointmentsView.frame.width - (20 * x) , height: (6 * y))
           //AppointmentsLabels.backgroundColor = UIColor.gray
           AppointmentsLabels.text = "Appointments"
           AppointmentsLabels.textColor = UIColor.white
           AppointmentsLabels.textAlignment = .left
           AppointmentsLabels.font = UIFont(name: "Avenir Next", size: 1.3 * x)
           AppointmentsView.addSubview(AppointmentsLabels)
        
        // DeliveryColonLabel :-
        let AppointColonLabel = UILabel()
        AppointColonLabel.frame = CGRect(x: AppointmentsLabels.frame.maxX , y: AppointmentsView.frame.minY , width: 2 * x, height: (6 * y))
        //AppointColonLabel.backgroundColor = UIColor.gray
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
        AppointmentValueLabel.frame = CGRect(x: AppointColonLabel.frame.maxX + x, y: y1, width: 15 * x, height: (3 * y))
         // AppointmentValueLabel.backgroundColor = UIColor.gray
        AppointmentValueLabel.text = AppoinmentArray[i] as? String
        AppointmentValueLabel.lineBreakMode = .byWordWrapping
        AppointmentValueLabel.numberOfLines = 2
        AppointmentValueLabel.textColor = UIColor.white
        AppointmentValueLabel.textAlignment = .left
        AppointmentValueLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        AppointmentsView.addSubview(AppointmentValueLabel)
        
        y1 = AppointmentValueLabel.frame.maxY + y
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
        DeliveryTypeLabel.frame = CGRect(x: x, y: DeliveryTypeView.frame.minY , width: DeliveryTypeView.frame.width - (20 * x), height: (2 * y))
        DeliveryTypeLabel.backgroundColor = UIColor.gray
        DeliveryTypeLabel.text = "Delivery Type"
        DeliveryTypeLabel.textColor = UIColor.white
        DeliveryTypeLabel.textAlignment = .left
        DeliveryTypeLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        DeliveryTypeView.addSubview(DeliveryTypeLabel)
        
        // DeliveryColonLabel :-
        let DeliveryColonLabel = UILabel()
        DeliveryColonLabel.frame = CGRect(x: DeliveryTypeLabel.frame.minX, y: DeliveryTypeView.frame.minY , width: 2 * x, height: (2 * y))
       // DeliveryColonLabel.backgroundColor = UIColor.gray
        DeliveryColonLabel.text = "-"
        DeliveryColonLabel.textColor = UIColor.white
        DeliveryColonLabel.textAlignment = .center
        DeliveryColonLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
       // DeliveryTypeView.addSubview(DeliveryColonLabel)
        
        
        
        
        // StichTimeView :-
        let StichTimeView = UIView()
        StichTimeView.frame = CGRect(x: x, y: 105 + (6 * y), width: DeliveryTypeView.frame.width , height: (6 * y))
        StichTimeView.layer.cornerRadius = 10
        StichTimeView.layer.masksToBounds = true
        StichTimeView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        deliveryDetailsView.addSubview(StichTimeView)
        
        
        // Label :-
        let StichTimeLabel = UILabel()
        StichTimeLabel.frame = CGRect(x: 5, y: 8 , width: 15 * x, height: (3 * y))
       // StichTimeLabel.backgroundColor = UIColor.gray
        StichTimeLabel.text = "Stiching time required for stiches"
        StichTimeLabel.lineBreakMode = .byWordWrapping
        StichTimeLabel.numberOfLines = 2
        StichTimeLabel.textColor = UIColor.white
        StichTimeLabel.textAlignment = .left
        StichTimeLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        StichTimeView.addSubview(StichTimeLabel)
        
        
        // StichColon Label :-
        let StichColonLabel = UILabel()
        StichColonLabel.frame = CGRect(x: StichTimeLabel.frame.maxX, y: StichTimeView.frame.minY , width: 2 * x, height: (2 * y))
       // StichColonLabel.backgroundColor = UIColor.gray
        StichColonLabel.text = "-"
        StichColonLabel.textColor = UIColor.white
        StichColonLabel.textAlignment = .center
        StichColonLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        StichTimeView.addSubview(StichColonLabel)
       
        
        // DeliveryDateView :-
        let DeliveryDateView = UIView()
        DeliveryDateView.frame = CGRect(x: x, y: 195 + (6 * y), width: StichTimeView.frame.width , height: (10 * y))
        DeliveryDateView.layer.cornerRadius = 10
        DeliveryDateView.layer.masksToBounds = true
        DeliveryDateView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        deliveryDetailsView.addSubview(DeliveryDateView)
 
        // Label :-
        let DeliveryDateLabel = UILabel()
        DeliveryDateLabel.frame = CGRect(x: 5, y: 25 , width: 15 * x, height: (3 * y))
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
        DateColonLabel.frame = CGRect(x: DeliveryDateLabel.frame.maxX, y: DeliveryDateView.frame.minY , width: 2 * x, height: (2 * y))
        //DateColonLabel.backgroundColor = UIColor.gray
        DateColonLabel.text = "-"
        DateColonLabel.textColor = UIColor.white
        DateColonLabel.textAlignment = .center
        DateColonLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        DeliveryDateView.addSubview(DateColonLabel)
        
        // Pay Button :-
        ProceedToPayButton.frame = CGRect(x: 0, y: deliveryDetailsView.frame.maxY, width: view.frame.width , height: (4 * y))
        ProceedToPayButton.backgroundColor = UIColor.orange
        ProceedToPayButton.setTitle("PROCEED TO PAY", for: .normal)
        ProceedToPayButton.setTitleColor(UIColor.white, for: .normal)
        ProceedToPayButton.titleLabel?.font =  UIFont(name: "Avenir Next", size: 1.5 * x)
        ProceedToPayButton.addTarget(self, action: #selector(self.ProccedToPayButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(ProceedToPayButton)
        
       ProceedToPayButton.isHidden = isHidden
   
    }
    
    @objc func ProccedToPayButtonAction(sender : UIButton)
    {
        qtyNum = Int(QtyNumTF.text!)
       
        print("Qty:",qtyNum)
        print("orderID:",orderID)
        
        self.serviceCall.API_UpdateQtyOrderApproval(OrderId: orderID, Qty: qtyNum, delegate: self)
        print("Redirect To Next Page.. !")
       
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
