//
//  TelrResponseViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 14/02/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class TelrResponseViewController: CommonViewController,ServerAPIDelegate
{
   
    let serviceCall = ServerAPI()
    
     var TelrTransCode:String!
    
     var TransStatus:String!
     var TransCode:String!
     var TransMessage:String!
     var TransRef:String!
     var TransCvv:String!
     var TransAvs:String!
     var TransCardcode:String!
     var TransCardlast4:String!
     var TransCa_valid:String!
     var TransTraceNum:String!
    
     let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()
    let TransactionView = UIView()
    let TransLabel = UILabel()
    let DoneButton = UIButton()

     var dictionaryData = NSDictionary()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    // Parameters:
    var KEY:String!
    var STOREID:String!
    var MerchantID:String!
    var EMAIL:String!
    
    var applicationDelegate = AppDelegate()

    override func viewDidLoad()
    {
        super.viewDidLoad()

         navigationBar.isHidden = true
        
        // Do any additional setup after loading the view.
        
      //  KEY = "XZCQ~9wRvD^prrJx" //"0d644cd3MsvS6r49sBDqdd29"  // "XZCQ~9wRvD^prrJx"
      //  STOREID = "21552"
        
        TelrTransCode = UserDefaults.standard.value(forKey: "TransCode") as? String
        
        self.serviceCall.API_GetPaymentStoreDetails(delegate: self)
        
       // ResponseContent()
        
        let navigationArray = self.navigationController?.viewControllers
        print("viewControllers Aray:",navigationArray!)
        
    }
    func API_CALLBACK_GetPaymentStore(StoreDetails: NSDictionary)
    {
        let ResponseMsg = StoreDetails.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = StoreDetails.object(forKey: "Result") as! NSArray
            print("Result", Result)
            
            let StoreId = Result.value(forKey: "StoreId") as? NSArray
            let sID : Int = StoreId![0] as! Int
            STOREID = "\(sID)"
            print("STOREID", STOREID)
            
            let Key = Result.value(forKey: "KeyId") as? NSArray
            KEY = Key![0] as? String
            print("KEY", KEY)
            
            let MerchantId = Result.value(forKey: "MerchantId") as? NSArray
            MerchantID = MerchantId![0] as? String
            print("MerchantID", MerchantID)
            
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = StoreDetails.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetPaymentStore"
            ErrorStr = Result
            
            DeviceError()
            
        }
        
          TransactionRequest()
        
    }
    func TransactionRequest()
    {
        let Message: String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
            "<mobile>" +
            "<store>\(STOREID!)</store>" +
            "<key>\(KEY!)</key>" +
            "<complete>\(TelrTransCode!)</complete>" +
        "</mobile>"
        
        let urlString = "https://secure.innovatepayments.com/gateway/mobile_complete.xml"
        if let url = NSURL(string: urlString)
        {
            let theRequest = NSMutableURLRequest(url: url as URL)
            theRequest.addValue("application/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            theRequest.addValue((Message), forHTTPHeaderField: "Content-Length")
            theRequest.httpMethod = "POST"
            theRequest.httpBody = Message.data(using: String.Encoding.utf8)
            let task = URLSession.shared.dataTask(with: theRequest as URLRequest)
            { (data, response, error) in
                if error == nil
                {
                    if let data = data, let responseString = String(data: data, encoding: String.Encoding.utf8)
                    {
                        print("responseString = \(responseString)")
                        do
                        {
                            self.dictionaryData = try XMLReader.dictionary(forXMLData: data, options:UInt(XMLReaderOptionsProcessNamespaces)) as NSDictionary
                            
                            print("Value:",self.dictionaryData)
                            
                            let mobileDict = (self.dictionaryData.object(forKey: "mobile")! as AnyObject)
                            // print("mobileDict:",mobileDict)
                            
                            let AuthDict = mobileDict.object(forKey: "auth")! as AnyObject
                            //  print("webViewDict:",webViewDict)
                            
                            let status = AuthDict.object(forKey: "status")! as AnyObject
                            //  print("StartWebView:",StartWebView)
                            self.TransStatus = (status.object(forKey: "text") as AnyObject) as? String
                            print("TransStatus :",self.TransStatus)
                            
                            let code = AuthDict.object(forKey: "code")! as AnyObject
                            //  print("StartWebView:",StartWebView)
                            self.TransCode = (code.object(forKey: "text") as AnyObject) as? String
                            print("TransCode :",self.TransCode)
                            
                            let message = AuthDict.object(forKey: "message")! as AnyObject
                            //  print("StartWebView:",StartWebView)
                            self.TransMessage = (message.object(forKey: "text") as AnyObject) as? String
                            print("TransMessage :",self.TransMessage)
                            
                            let RefNum = AuthDict.object(forKey: "tranref")! as AnyObject
                            //  print("StartWebView:",StartWebView)
                            self.TransRef = (RefNum.object(forKey: "text") as AnyObject) as? String
                            print("TransRef :",self.TransRef)
                          
                            let cvv = AuthDict.object(forKey: "cvv")! as AnyObject
                            //  print("StartWebView:",StartWebView)
                            self.TransCvv = (cvv.object(forKey: "text") as AnyObject) as? String
                            print("TransCvv :",self.TransCvv)
                            
                            let avs = AuthDict.object(forKey: "avs")! as AnyObject
                            //  print("StartWebView:",StartWebView)
                            self.TransAvs = (avs.object(forKey: "text") as AnyObject) as? String
                            print("TransAvs :",self.TransAvs)
                            
                            let cardcode = AuthDict.object(forKey: "cardcode")! as AnyObject
                            //  print("StartWebView:",StartWebView)
                            self.TransCardcode = (cardcode.object(forKey: "text") as AnyObject) as? String
                            print("TransCardcode :",self.TransCardcode)
                            
                            let cardlast4 = AuthDict.object(forKey: "cardlast4")! as AnyObject
                            //  print("StartWebView:",StartWebView)
                            self.TransCardlast4 = (cardlast4.object(forKey: "text") as AnyObject) as? String
                            print("TransCardlast4 :",self.TransCardlast4)
                            
                            let ca_valid = AuthDict.object(forKey: "ca_valid")! as AnyObject
                            //  print("StartWebView:",StartWebView)
                            self.TransCa_valid = (ca_valid.object(forKey: "text") as AnyObject) as? String
                            print("TransCa_valid :",self.TransCa_valid)
                            
                            let TraceDict = mobileDict.object(forKey: "trace")! as AnyObject
                            //  print("webViewDict:",webViewDict)
                            self.TransTraceNum = (TraceDict.object(forKey: "text") as AnyObject) as? String
                            print("TransTraceNum :",self.TransTraceNum)
                            
                            
                            DispatchQueue.main.async (execute: { () -> Void in
                                self.ResponseContent()
                            })
                        }
                        catch
                        {
                            print("Your Dictionary value nil")
                        }
                        //print(dictionaryData)
                    }
                }
                else
                {
                    print(error!)
                }
            }
            task.resume()
        }
    }
    
    func changeViewToArabicInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.text = "ملخص المعاملات"
        TransactionView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        TransLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        if(self.TransMessage == "Authorised")
        {
            TransLabel.text = "الدفع الناجح ، رقم مرجع المعاملة الخاص بك هو  : \(TransRef!)"
        }
        else if(self.TransMessage == "Cancelled" || self.TransMessage == "3DSecure authentication rejected")
        {
            TransLabel.text = "فشلت العملية .. يرجى المحاولة مرة أخرى .."
        }
        DoneButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        DoneButton.setTitle("لكى يفعل", for: .normal)

    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.text = "TRANSACTION SUMMARY"
        TransactionView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        TransLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        if(self.TransMessage == "Authorised")
        {
            TransLabel.text = "Payment Success, Your Transaction Reference Number is  : \(TransRef!)"
        }
        else if(self.TransMessage == "Cancelled" || self.TransMessage == "3DSecure authentication rejected")
        {
            TransLabel.text = "Transaction Failed.. Please Try Again.."
        }
        DoneButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        DoneButton.setTitle("Done", for: .normal)

    }
    

    func ResponseContent()
    {
        stopActivity()
        activity.stopActivity()
        
        // let PaymentNavigationBar = UIView()
        selfScreenNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        selfScreenNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(selfScreenNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 4
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        //PaymentNavigationBar.addSubview(backButton)
        
        selfScreenNavigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: selfScreenNavigationBar.frame.width, height: (3 * y))
        selfScreenNavigationTitle.text = "TRANSACTION SUMMARY"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationTitle.font = selfScreenNavigationTitle.font.withSize(2 * x)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        
        // Payment View..
        
        TransactionView.frame = CGRect(x: (3 * x), y: ((view.frame.height - (10 * y)) / 2), width: view.frame.width - (6 * x), height: (10 * y))
        TransactionView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(TransactionView)
        
        // Transaction Label..
        TransLabel.frame = CGRect(x: x, y: (y / 2), width: TransactionView.frame.width - (2 * x), height: (5 * y))
        // TransLabel.backgroundColor = UIColor.gray
        TransLabel.font = UIFont.boldSystemFont(ofSize: 16)
        if(self.TransMessage == "Authorised")
        {
          TransLabel.text = "Payment Success, Your Transaction Reference Number is  : \(TransRef!)"
        }
        else if(self.TransMessage == "Cancelled" || self.TransMessage == "3DSecure authentication rejected")
        {
          TransLabel.text = "Transaction Failed.. Please Try Again.."
        }
        TransLabel.font = UIFont(name: "Avenir Next", size: 16)
        TransLabel.textColor = UIColor.white
        TransLabel.textAlignment = .center
        TransLabel.lineBreakMode = .byWordWrapping
        TransLabel.numberOfLines = 3
        TransactionView.addSubview(TransLabel)
        
     
        // Done Button
        DoneButton.frame = CGRect(x: ((TransactionView.frame.width - (15 * x)) / 2), y: TransLabel.frame.maxY + y, width: (15 * x), height: (3 * y))
        DoneButton.backgroundColor = UIColor(red:0.29, green:0.48, blue:0.92, alpha:1.0)
        DoneButton.setTitle("Done", for: .normal)
        DoneButton.setTitleColor(UIColor.white, for: .normal)
        DoneButton.titleLabel?.font =  UIFont(name: "Avenir-Regular", size: (1.3 * x))
        DoneButton.layer.cornerRadius = 10  // this value vary as per your desire
        DoneButton.isUserInteractionEnabled = true
        DoneButton.addTarget(self, action: #selector(self.DoneButtonAction(sender:)), for: .touchUpInside)
        TransactionView.addSubview(DoneButton)
        
        self.view.bringSubviewToFront(DoneButton)
        
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
    
    
    @objc func otpBackButtonAction(sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func DoneButtonAction(sender : UIButton)
    {
        
        //  let orderId = UserDefaults.standard.value(forKey: "OrderID") as? Int
         //   let TailorId = UserDefaults.standard.value(forKey: "TailorID") as? Int
        // let TotalAmt = UserDefaults.standard.value(forKey: "TotalAmount") as? String
        
        let orderId = Variables.sharedManager.OrderID
        let TailorId = Variables.sharedManager.TailorID
        let TotalAmt = Variables.sharedManager.TotalAmount
        
        if(self.TransMessage == "Authorised")
        {
            print("orderId :",orderId)
            print("TailorId :",TailorId)
            print("Total Amt :",TotalAmt)
            
            self.serviceCall.API_updatePaymentStatus(PaymentStatus: 1, OrderId: orderId, delegate: self)
            self.serviceCall.API_BuyerOrderApproval(OrderId: orderId, ApprovedTailorId: TailorId, delegate: self)
            
            self.serviceCall.API_InsertPaymentStatus(OrderId: orderId, Transactionid: TransRef, Amount: TotalAmt, Status: TransStatus, Code: TransCode, message: TransMessage, cvv: TransCvv, avs: TransAvs, cardcode: TransCardcode, cardlast4: TransCardlast4, Trace: TransTraceNum, ca_Valid: TransCa_valid, delegate: self)
            
         //   Variables.sharedManager.TotalAmount = ""
        //    Variables.sharedManager.TailorID = 0
         //   Variables.sharedManager.OrderID = 0
            
            window = UIWindow(frame: UIScreen.main.bounds)
            let HomeScreen = HomeViewController()
            let navigationScreen = UINavigationController(rootViewController: HomeScreen)
            navigationScreen.isNavigationBarHidden = true
            window?.rootViewController = navigationScreen
            window?.makeKeyAndVisible()
            
        }
        else if(self.TransMessage == "Cancelled" || self.TransMessage == "3DSecure authentication rejected")
        {
            window = UIWindow(frame: UIScreen.main.bounds)
            let HomeScreen = PaymentViewController()
            let navigationScreen = UINavigationController(rootViewController: HomeScreen)
            navigationScreen.isNavigationBarHidden = true
            window?.rootViewController = navigationScreen
            window?.makeKeyAndVisible()
        }
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        // ErrorStr = "Default Error"
        PageNumStr = "TelrResponseViewController"
        //  MethodName = "do"
        
        print("UUID", UIDevice.current.identifierForVendor?.uuidString as Any)
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
        
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("Book an appointment : ", errorMessage)
        stopActivity()
        activity.stopActivity()
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
    
    func API_CALLBACK_UpdatePaymentStatus(updatePaymentStatus: NSDictionary)
    {
        let ResponseMsg = updatePaymentStatus.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = updatePaymentStatus.object(forKey: "Result") as! String
            print("Result", Result)
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = updatePaymentStatus.object(forKey: "Result") as! String
            
            ErrorStr = Result
            MethodName = "UpdatePaymentStatus"
            
            DeviceError()
          
        }
        
    }
    func API_CALLBACK_BuyerOrderApproval(buyerOrderApproval: NSDictionary)
    {
        let ResponseMsg = buyerOrderApproval.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = buyerOrderApproval.object(forKey: "Result") as! String
            print("Result", Result)
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = buyerOrderApproval.object(forKey: "Result") as! String
            
            ErrorStr = Result
            MethodName = "BuyerOrderApproval"
            
            DeviceError()
            
        }
    }
    func API_CALLBACK_InsertPaymentStatus(status: NSDictionary)
    {
        let ResponseMsg = status.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = status.object(forKey: "Result") as! String
            print("Result", Result)
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = status.object(forKey: "Result") as! String
            
            ErrorStr = Result
            MethodName = "InsertPaymentStatus"
            
            DeviceError()
            
        }
    }
}
