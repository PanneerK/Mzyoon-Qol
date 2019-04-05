//
//  PaymentViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 24/01/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit
//import TelrSDK

class PaymentViewController: CommonViewController,ServerAPIDelegate,UITextFieldDelegate
{
   
    
  //  let KEY:String = "XZCQ~9wRvD^prrJx"
 //   let STOREID:String = "21552"
 //   let EMAIL:String = "rohith.qol@gmail.com"
    
    let serviceCall = ServerAPI()
    
    let Amount_TF = UITextField()
    
    //Billing Address Fields..
    let Line1_TF = UITextField()
    let Line2_TF = UITextField()
    let Line3_TF = UITextField()
    let City_TF = UITextField()
    let State_TF = UITextField()
    let Country_TF = UITextField()
    let ZipCode_TF = UITextField()
    let Email_TF = UITextField()
    
    var TotalAmount:String!
    
    // Parameters:
    var KEY:String!
    var STOREID:String!
    var MerchantID:String!
    
    var EMAIL:String!
    var AddLine1:String!
    var AddLine2:String!
    var AddLine3:String!
    var City:String!
    var State:String!
    var Country:String!
    var Zipcode:String!
    
    var TailorId:Int!
    
    var DeviceType:String!
    var DeviceNum:String!
    var DeviceAgent:String!
    var DeviceAccept:String!
    
    var AppName:String!
    var AppVersion:String!
    var AppUser:String!
    var AppId:String!
    
    var UserName:String!
    
    var CardNum:String!
    var CVVNum:String!
    var ExpMonth:String!
    var ExpYear:String!
    
    var RequestId:String!
    var Currency:String!
    var Description:String!
    
    var dictionaryData = NSDictionary()
    var UrlDict = NSDictionary()
    var TelrStartUrl:String!
    var TelrCloseUrl:String!
    var TelrAbortUrl:String!
    var TelrTransCode:String!
    
    var TransMsg:String!
    var StatusCode:String!
    
    var ResponseView : UIWebView!
    
   // var paymentRequest:PaymentRequest?

    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()
    let BillingView = UIView()
    let PayButton = UIButton()


    // Error PAram...
    var DeviceNumStr:String!
    var UserType:String!
    var AppVersionStr:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
   // var x = CGFloat()
  //  var y = CGFloat()
    
    var foundViewTagArray = [Int]()
    
    var applicationDelegate = AppDelegate()

    var Line1Str:String!
    var Line2Str:String!
    var Line3Str:String!
    var CityStr:String!
    var StateStr:String!
    var CountryStr:String!
    var EmailStr:String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
      
        print("TailorId",TailorId)
        print("Global TailorID:",Variables.sharedManager.TailorID)
      
        
        navigationBar.isHidden = true

        // Do any additional setup after loading the view.
        
      /*
           UserDefaults.standard.set(TailorId, forKey: "TailorID")
         
        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
      */
        
     /*
       if(TotalAmount == nil)
       {
         self.Amount_TF.text = "1"
       }
       else
       {
         self.Amount_TF.text = Variables.sharedManager.TotalAmount
        // self.Amount_TF.text = TotalAmount!
       }
     */
        
         //   KEY = "XZCQ~9wRvD^prrJx"  //"0d644cd3MsvS6r49sBDqdd29"  // "XZCQ~9wRvD^prrJx"
         //   STOREID = "21552"
        
     //   MerchantID = "12168"
        
        
       // EMAIL = UserDefaults.standard.value(forKey: "Email") as? String
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        DeviceType = UIDevice.current.name
        DeviceAgent = ""
        DeviceAccept = ""
        
        AppName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String
        AppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        AppUser = Bundle.main.bundleIdentifier
        AppId = "12345"
        CardNum = ""
        ExpYear = ""
        ExpMonth = ""
        CVVNum = ""
       
        Currency = "AED"
        Description = "Mzyoon App Payment Confirmation.."
       
        
       // ConvertBase64()
        
        self.serviceCall.API_GetPaymentStoreDetails(delegate: self)
      
        
        if let userId = UserDefaults.standard.value(forKey: "userId") as? String
        {
            self.serviceCall.API_GetPaymentAddress(BuyerId: userId, delegate: self)
        }
        else if let userId = UserDefaults.standard.value(forKey: "userId") as? Int
        {
            self.serviceCall.API_GetPaymentAddress(BuyerId: "\(userId)", delegate: self)
        }
        
        //  self.Email_TF.text = UserDefaults.standard.value(forKey: "Email") as? String
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
        let navigationArray = self.navigationController?.viewControllers
        print("viewControllers Aray:",navigationArray!)
        
        // UITextfield Move upward & Downward Code..
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func ConvertBase64()
    {
        let BaseString : String = "\(MerchantID!):\(KEY!)"
        let data = (BaseString).data(using: String.Encoding.utf8)
        let base64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        print("Base64:",base64)
        
        DeviceAgent = "Authorization: Basic \(base64)"
        DeviceAccept = "Authorization: Basic \(base64)"
    }
    
    func DeviceError()
    {
        DeviceNumStr = UIDevice.current.identifierForVendor?.uuidString
        AppVersionStr = UIDevice.current.systemVersion
        UserType = "customer"
        // ErrorStr = "Default Error"
        PageNumStr = "PaymentViewController"
        //  MethodName = "do"
        
        print("UUID", UIDevice.current.identifierForVendor?.uuidString as Any)
        
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNumStr!, PageName: PageNumStr!, MethodName: MethodName!, Error: ErrorStr!, ApiVersion: AppVersionStr!, Type: UserType!, delegate: self)
        
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
         print("Payment summary : ", errorMessage)
         stopActivity()
        
        applicationDelegate.exitContents()
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
        
    }
    func API_CALLBACK_GetPaymentAddress(getAddress: NSDictionary)
    {
        let ResponseMsg = getAddress.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = getAddress.object(forKey: "Result") as! NSArray
            print("Result", Result)
            
            if Result.count > 0
            {
                let Floor = Result.value(forKey: "Floor") as? NSArray
                Line1Str = Floor![0] as? String
                print("Line1Str", Line1Str)
                
                let Building = Result.value(forKey: "Building") as? NSArray
                Line2Str = Building![0] as? String
                print("Line2Str", Line2Str)
                
                let Landmark = Result.value(forKey: "Landmark") as? NSArray
                Line3Str = Landmark![0] as? String
                print("Line3Str", Line3Str)
                
                let Area = Result.value(forKey: "Area") as? NSArray
                CityStr = Area![0] as? String
                print("CityStr", CityStr)
                
                let StateName = Result.value(forKey: "StateName") as? NSArray
                StateStr = StateName![0] as? String
                print("StateStr", StateStr)
                
                let CountryName = Result.value(forKey: "CountryName") as? NSArray
                CountryStr = CountryName![0] as? String
                print("CountryStr", CountryStr)
                
                let Email = Result.value(forKey: "Email") as? NSArray
                EmailStr = Email![0] as? String
                print("EmailStr", EmailStr)
                
                self.Line1_TF.text = Line1Str
                self.Line2_TF.text = Line2Str
                self.Line3_TF.text = Line3Str
                self.City_TF.text = CityStr
                self.State_TF.text = StateStr
                self.Country_TF.text = CountryStr
                self.Email_TF.text = EmailStr
                
                PaymentContent()
            }
        }
        else if ResponseMsg == "Failure"
        {
            let Result = getAddress.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetPaymentAddress"
            ErrorStr = Result
            
            DeviceError()
            
        }
    }
    
  /*
    func PaymentRequest()
    {
        let Message: String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
            "<mobile>" +
            "<store>\(STOREID!)</store>" +
            "<key>\(KEY!)</key>" +
            "<device>" +
            "<type>\(DeviceType!)</type>" +
            "<id>\(DeviceNum!)</id>" +
            "<agent>\(DeviceAgent!)</agent>" +
            "<accept>\(DeviceAccept!)</accept>" +
            "</device>" +
            "<app>" +
            "<name>\(AppName!)</name>" +
            "<version>\(AppVersion!)</version>" +
            "<user>\(AppUser!)</user>" +
            "<id>\(AppId!)</id>" +
            "</app>" +
            "<tran>" +
            "<test>0</test>" +
            "<type>PAYPAGE</type>" +
            "<class>ecom</class>" +
            "<cartid>\(RequestId!)</cartid>" +
            "<description>\(Description!)</description>" +
            "<currency>\(Currency!)</currency>" +
            "<amount>\(TotalAmount!)</amount>" +
            "<ref>000000000001</ref>" +
            "</tran>" +
            "<card>" +
            "<number>\(CardNum!)</number>" +
            "<expiry>" +
            "<month>\(ExpMonth!)</month>" +
            "<year>\(ExpYear!)</year>" +
            "</expiry>" +
            "<cvv>\(CVVNum!)</cvv>" +
            "</card>" +
            "<billing>" +
            "<name>" +
            "<title></title>" +
            "<first></first>" +
            "<last></last>" +
            "</name>" +
            "<address>" +
            "<line1>Venkatapuram</line1>" +
            "<line2>velachery Road</line2>" +
            "<line3>Saidapet</line3>" +
            "<city>Chennai</city>" +
            "<region>TN</region>" +
            "<country>IN</country>" +
            "<zip>600020</zip>" +
            "</address>" +
            "<email>\(EMAIL!)</email>" +
            "</billing>" +
        "</mobile>"
        
        print("Request:",Message)
        let urlString = "https://secure.innovatepayments.com/gateway/mobile.xml"
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
                             print("Count:",[data.count])
                            
                          //  let mainDict = ((self.dictionaryData.object(forKey: "mobile")! as AnyObject).object(forKey: "webview")! as AnyObject).object(forKey: "text") ?? NSDictionary()
                        //  if (Int(data.count) == 410)  {
                            
                                let mobileDict = (self.dictionaryData.object(forKey: "mobile")! as AnyObject)
                                // print("mobileDict:",mobileDict)
                                
                                let webViewDict = mobileDict.object(forKey: "webview")! as AnyObject
                                //  print("webViewDict:",webViewDict)
                                
                                let StartWebView = webViewDict.object(forKey: "start")! as AnyObject
                                //  print("StartWebView:",StartWebView)
                                self.TelrStartUrl = (StartWebView.object(forKey: "text") as AnyObject) as? String
                                print("TelrStartUrl :",self.TelrStartUrl)
                                
                                let CloseWebView = webViewDict.object(forKey: "close")! as AnyObject
                                self.TelrCloseUrl = (CloseWebView.object(forKey: "text") as AnyObject) as? String
                                print("TelrCloseUrl :",self.TelrCloseUrl)
                                
                                let AbortWebView = webViewDict.object(forKey: "abort")! as AnyObject
                                self.TelrAbortUrl = (AbortWebView.object(forKey: "text") as AnyObject) as? String
                                print("TelrAbortUrl :",self.TelrAbortUrl)
                                
                                let CodeWebView = webViewDict.object(forKey: "code")! as AnyObject
                                self.TelrTransCode = (CodeWebView.object(forKey: "text") as AnyObject) as? String
                                print("TelrTransCode :",self.TelrTransCode)
                            
                                UserDefaults.standard.set(self.TelrTransCode, forKey: "TransCode")
                            
                                if (self.TelrStartUrl != nil)
                                {
                                    DispatchQueue.main.async (execute: { () -> Void in
                                        
                                        self.window = UIWindow(frame: UIScreen.main.bounds)
                                        let TelrScreen = TelrGateWayViewController()
                                        TelrScreen.TelrStartUrl = self.TelrStartUrl
                                        TelrScreen.TelrCloseUrl = self.TelrCloseUrl
                                        TelrScreen.TelrAbortUrl = self.TelrAbortUrl
                                        TelrScreen.TelrTransCode = self.TelrTransCode
                                        let navigationScreen = UINavigationController(rootViewController: TelrScreen)
                                        navigationScreen.isNavigationBarHidden = true
                                        self.window?.rootViewController = navigationScreen
                                        self.window?.makeKeyAndVisible()
                                    })
                                    
                                }
                                else
                                {
                                    
                                }
                                
                          //  }
                                /*
                            else
                            {
                                let mobileDict = (self.dictionaryData.object(forKey: "mobile")! as AnyObject)
                                // print("mobileDict:",mobileDict)
                                
                                let AuthDict = mobileDict.object(forKey: "auth")! as AnyObject
                                //  print("webViewDict:",webViewDict)
                                
                                let MessageDict = AuthDict.object(forKey: "message")! as AnyObject
                                //  print("webViewDict:",webViewDict)
                                
                                self.TransMsg = (MessageDict.object(forKey: "text") as AnyObject) as? String
                                print("Msg:",self.TransMsg)
                               
                                let StatusDict = AuthDict.object(forKey: "status")! as AnyObject
                                //  print("webViewDict:",webViewDict)
                                
                                self.StatusCode = (StatusDict.object(forKey: "text") as AnyObject) as? String
                                print("Status:",self.StatusCode)
                                
                                if self.StatusCode == "H"
                                {
                                    DispatchQueue.main.async (execute: { () -> Void in
                                       
                                        let alert = UIAlertController(title: "Message", message: "Transaction Placed On hold" , preferredStyle:.alert)
                                        // add an action (button)
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                        // show the alert
                                        self.present(alert, animated: true, completion: nil)
                                    })
                                    
                                }
                                else
                                {
                                    DispatchQueue.main.async (execute: { () -> Void in
                                        
                                        let alert = UIAlertController(title: "Message", message: "Request could not be processed" , preferredStyle:.alert)
                                        // add an action (button)
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                        // show the alert
                                        self.present(alert, animated: true, completion: nil)
                                    })
                                }
                                
                             }
                            */
                      
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
  */
    
    func PayPageRequest()
    {
        let Message: String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
            "<mobile>" +
            "<store>\(STOREID!)</store>" +
            "<key>\(KEY!)</key>" +
            "<device>" +
            "<type>\(DeviceType!)</type>" +
            "<id>\(DeviceNum!)</id>" +
            "<agent>\(DeviceAgent!)</agent>" +
            "<accept>\(DeviceAccept!)</accept>" +
            "</device>" +
            "<app>" +
            "<name>\(AppName!)</name>" +
            "<version>\(AppVersion!)</version>" +
            "<user>\(AppUser!)</user>" +
            "<id>\(AppId!)</id>" +
            "</app>" +
            "<tran>" +
            "<test>1</test>" +
            "<type>PAYPAGE</type>" +
            "<cartid>\(RequestId!)</cartid>" +
            "<description>\(Description!)</description>" +
            "<currency>\(Currency!)</currency>" +
            "<amount>\(TotalAmount!)</amount>" +
            "</tran>" +
            "<billing>" +
            "<name>" +
            "<title></title>" +
            "<first></first>" +
            "<last></last>" +
            "</name>" +
            "<address>" +
            "<line1>\(AddLine1!)</line1>" +
            "<line2>\(AddLine2!)</line2>" +
            "<line3>\(AddLine3!)</line3>" +
            "<city>\(City!)</city>" +
            "<region>\(State!)</region>" +
            "<country>\(Country!)</country>" +
            "<zip>\(Zipcode!)</zip>" +
            "</address>" +
            "<email>\(EMAIL!)</email>" +
            "</billing>" +
        "</mobile>"
        
        print("Request:",Message)
        let urlString = "https://secure.innovatepayments.com/gateway/mobile.xml"
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
                            print("Count:",[data.count])
                            
                            //  let mainDict = ((self.dictionaryData.object(forKey: "mobile")! as AnyObject).object(forKey: "webview")! as AnyObject).object(forKey: "text") ?? NSDictionary()
                            //  if (Int(data.count) == 410)  {
                            
                            let mobileDict = (self.dictionaryData.object(forKey: "mobile")! as AnyObject)
                            // print("mobileDict:",mobileDict)
                            
                            let webViewDict = mobileDict.object(forKey: "webview")! as AnyObject
                            //  print("webViewDict:",webViewDict)
                            
                            let StartWebView = webViewDict.object(forKey: "start")! as AnyObject
                            //  print("StartWebView:",StartWebView)
                            self.TelrStartUrl = (StartWebView.object(forKey: "text") as AnyObject) as? String
                            print("TelrStartUrl :",self.TelrStartUrl)
                            
                            let CloseWebView = webViewDict.object(forKey: "close")! as AnyObject
                            self.TelrCloseUrl = (CloseWebView.object(forKey: "text") as AnyObject) as? String
                            print("TelrCloseUrl :",self.TelrCloseUrl)
                            
                            let AbortWebView = webViewDict.object(forKey: "abort")! as AnyObject
                            self.TelrAbortUrl = (AbortWebView.object(forKey: "text") as AnyObject) as? String
                            print("TelrAbortUrl :",self.TelrAbortUrl)
                            
                            let CodeWebView = webViewDict.object(forKey: "code")! as AnyObject
                            self.TelrTransCode = (CodeWebView.object(forKey: "text") as AnyObject) as? String
                            print("TelrTransCode :",self.TelrTransCode)
                            
                            UserDefaults.standard.set(self.TelrTransCode, forKey: "TransCode")
                            
                            if (self.TelrStartUrl != nil)
                            {
                                DispatchQueue.main.async (execute: { () -> Void in
                                    
                                    self.window = UIWindow(frame: UIScreen.main.bounds)
                                    let TelrScreen = TelrGateWayViewController()
                                    TelrScreen.TelrStartUrl = self.TelrStartUrl
                                    TelrScreen.TelrCloseUrl = self.TelrCloseUrl
                                    TelrScreen.TelrAbortUrl = self.TelrAbortUrl
                                    TelrScreen.TelrTransCode = self.TelrTransCode
                                    let navigationScreen = UINavigationController(rootViewController: TelrScreen)
                                    navigationScreen.isNavigationBarHidden = true
                                    self.window?.rootViewController = navigationScreen
                                    self.window?.makeKeyAndVisible()
                                })
                                
                            }
                            else
                            {
                                
                            }
                            
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
        selfScreenNavigationTitle.text = "ملخص الدفع"
        
        BillingView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        PayButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        PayButton.setTitle("دفع", for: .normal)
    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.text = "PAYMENT SUMMARY"
        
        BillingView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        PayButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        PayButton.setTitle("Pay", for: .normal)
    }
    
    func PaymentContent()
    {
          stopActivity()
        
        // let PaymentNavigationBar = UIView()
        selfScreenNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        selfScreenNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(selfScreenNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 4
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
       // selfScreenNavigationBar.addSubview(backButton)
        
        selfScreenNavigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: selfScreenNavigationBar.frame.width, height: (3 * y))
        selfScreenNavigationTitle.text = "PAYMENT SUMMARY"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationTitle.font = selfScreenNavigationTitle.font.withSize(2 * x)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
    
        // Billing Details View..
        BillingView.frame = CGRect(x: (3 * x), y: selfScreenNavigationBar.frame.maxY, width: view.frame.width - (6 * x), height: view.frame.height - ((5 * y) + selfScreenNavigationBar.frame.maxY))
        BillingView.backgroundColor = UIColor.clear
        view.addSubview(BillingView)
        
        //BILLINGLabel..
        let BILLINGLabel = UILabel()
        BILLINGLabel.frame = CGRect(x: 0, y: y, width: (15 * x), height: (2.5 * y))
        BILLINGLabel.text = "BILLING ADDRESS"
        BILLINGLabel.font = UIFont(name: "Avenir Next", size: (1.4 * x))
        BILLINGLabel.textColor =  UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        BILLINGLabel.textAlignment = .left
        BillingView.addSubview(BILLINGLabel)
        
        // UnderLine..
        let BillingUnderline = UILabel()
        BillingUnderline.frame = CGRect(x: 0, y: BILLINGLabel.frame.maxY, width: (12 * x), height: 0.5)
        BillingUnderline.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        BillingView.addSubview(BillingUnderline)
        
        var y3:CGFloat = BillingUnderline.frame.maxY + (2 * y)
        
        var headingLabelEnglishArray = ["Line 1", "Line 2", "Line 3", "City", "State", "Country", "Zip Code", "Email", "Amount"]
        var headingLabelArabicArray = ["خط 1", "خط 2", "الخط 3", "مدينة", "دولة", "بلد", "الكود البريدى", "البريد الإلكتروني", "كمية"]
        
        let count = 9
        
        for i in 0..<count
        {
            let headingLabel = UILabel()
            headingLabel.frame = CGRect(x: 0, y: y3, width: (11 * x), height: (3 * y))
            headingLabel.text = headingLabelEnglishArray[i]
            headingLabel.font = UIFont(name: "Avenir Next", size: 15)
            headingLabel.textAlignment = .left
            headingLabel.textColor = UIColor.black
            BillingView.addSubview(headingLabel)
            
            let colonLabel = UILabel()
            colonLabel.frame = CGRect(x: headingLabel.frame.maxX, y: y3, width: x / 2, height: (3 * y))
            colonLabel.text = ":"
            colonLabel.textColor = UIColor.black
            BillingView.addSubview(colonLabel)
            
            let valuesTextField = UITextField()
            valuesTextField.frame = CGRect(x: colonLabel.frame.maxX + x, y: y3, width: BillingView.frame.width - (headingLabel.frame.width + colonLabel.frame.width + x), height: (3 * y))
            valuesTextField.backgroundColor = UIColor.white
            valuesTextField.font = UIFont(name: "Avenir Next", size: 14)
            valuesTextField.textAlignment = .left
            valuesTextField.returnKeyType = .done
            valuesTextField.delegate = self
            valuesTextField.tag = (i * 1) + 500
            
            if i == 0
            {
                valuesTextField.text = Line1Str
                valuesTextField.keyboardType = .default
            }
            else if i == 1
            {
                valuesTextField.text = Line2Str
                valuesTextField.keyboardType = .default
            }
            else if i == 2
            {
                valuesTextField.text = Line3Str
                valuesTextField.keyboardType = .default
            }
            else if i == 3
            {
                valuesTextField.text = CityStr
                valuesTextField.keyboardType = .default
            }
            else if i == 4
            {
                valuesTextField.text = StateStr
                valuesTextField.keyboardType = .default
            }
            else if i == 5
            {
                valuesTextField.text = CountryStr
                valuesTextField.keyboardType = .default
            }
            else if i == 6
            {
                valuesTextField.text = ""
                valuesTextField.keyboardType = .numberPad
            }
            else if i == 7
            {
                valuesTextField.text = EmailStr
                valuesTextField.keyboardType = .default
            }
            else if i == 8
            {
                /*
                if(TotalAmount == nil)
                {
                    valuesTextField.text = "1"
                }
                else
                {
                  // valuesTextField.text = TotalAmount
                    valuesTextField.text = Variables.sharedManager.TotalAmount
                }
                */
                valuesTextField.text = Variables.sharedManager.TotalAmount
            }
            
            print("I VALUES-\(i) ->", count - 1)
            if i == count - 1
            {
                valuesTextField.isUserInteractionEnabled = false
            }
            else
            {
                valuesTextField.isUserInteractionEnabled = true
            }
            BillingView.addSubview(valuesTextField)
            
            y3 = headingLabel.frame.maxY + y
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    headingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    headingLabel.text = headingLabelEnglishArray[i]
                    headingLabel.textAlignment = .left
                    valuesTextField.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    valuesTextField.textAlignment = .left
                }
                else if language == "ar"
                {
                    headingLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    headingLabel.text = headingLabelArabicArray[i]
                    headingLabel.textAlignment = .right
                    valuesTextField.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    valuesTextField.textAlignment = .right
                }
            }
            else
            {
                headingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                headingLabel.text = headingLabelEnglishArray[i]
                headingLabel.textAlignment = .left
                valuesTextField.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                valuesTextField.textAlignment = .left
            }
        }
        
        self.addDoneButtonOnKeyboard()
        
        /*// Line1Label..
        let Line1Label = UILabel()
        Line1Label.frame = CGRect(x: (2 * x), y: BillingUnderline.frame.maxY + (2 * y), width: (8 * x), height: (3 * y))
        // FNameLabel.backgroundColor = UIColor.gray
        Line1Label.font = UIFont.boldSystemFont(ofSize: 16)
        Line1Label.text = "Line-1 : "
        Line1Label.font = UIFont(name: "Avenir Next", size: 16)
        Line1Label.textColor = UIColor.black
        Line1Label.textAlignment = .right
        BillingView.addSubview(Line1Label)
        
        // let Line1_TF = UITextField()
        Line1_TF.frame = CGRect(x: Line1Label.frame.maxX + x, y: BillingUnderline.frame.maxY + (2 * y), width: (20 * x), height: (3 * y))
        Line1_TF.backgroundColor = UIColor.white
        Line1_TF.font = UIFont.boldSystemFont(ofSize: 14)
        //Line1_TF.text = "250.00"
        Line1_TF.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        Line1_TF.textColor = UIColor.black
        Line1_TF.adjustsFontSizeToFitWidth = true
        Line1_TF.keyboardType = .default
        Line1_TF.clearsOnBeginEditing = false
        Line1_TF.returnKeyType = .done
        Line1_TF.delegate = self
        //Line1_TF.layer.borderWidth = 0.5
        Line1_TF.textAlignment = .left
      //  Line1_TF.addTarget(self, action: #selector(self.DoneAction), for: .allEditingEvents)
        BillingView.addSubview(Line1_TF)
        
        
        // Line2Label..
        let Line2Label = UILabel()
        Line2Label.frame = CGRect(x: (2 * x), y: Line1Label.frame.maxY + y, width: (8 * x), height: (3 * y))
        // FNameLabel.backgroundColor = UIColor.gray
        Line2Label.font = UIFont.boldSystemFont(ofSize: 16)
        Line2Label.text = "Line-2 : "
        Line2Label.font = UIFont(name: "Avenir Next", size: 16)
        Line2Label.textColor = UIColor.black
        Line2Label.textAlignment = .right
        BillingView.addSubview(Line2Label)
        
        // let Line2_TF = UITextField()
        Line2_TF.frame = CGRect(x: Line2Label.frame.maxX + x, y: Line1Label.frame.maxY + y, width: (20 * x), height: (3 * y))
        Line2_TF.backgroundColor = UIColor.white
        Line2_TF.font = UIFont.boldSystemFont(ofSize: 16)
        //Line2_TF.text = "250.00"
        Line2_TF.font = UIFont(name: "Avenir Next", size: 16)
        Line2_TF.textColor = UIColor.black
        Line2_TF.adjustsFontSizeToFitWidth = true
        Line2_TF.keyboardType = .default
        Line2_TF.clearsOnBeginEditing = false
        Line2_TF.returnKeyType = .done
        Line2_TF.delegate = self
        //Line2_TF.layer.borderWidth = 0.5
        Line2_TF.textAlignment = .left
      //  Line2_TF.addTarget(self, action: #selector(self.DoneAction), for: .allEditingEvents)
        BillingView.addSubview(Line2_TF)
       
        
        // Line3Label..
        let Line3Label = UILabel()
        Line3Label.frame = CGRect(x: (2 * x), y: Line2Label.frame.maxY + y, width: (8 * x), height: (3 * y))
        // FNameLabel.backgroundColor = UIColor.gray
        Line3Label.font = UIFont.boldSystemFont(ofSize: 16)
        Line3Label.text = "Line-3 : "
        Line3Label.font = UIFont(name: "Avenir Next", size: 16)
        Line3Label.textColor = UIColor.black
        Line3Label.textAlignment = .right
        BillingView.addSubview(Line3Label)
        
        // let Line3_TF = UITextField()
        Line3_TF.frame = CGRect(x: Line3Label.frame.maxX + x, y: Line2Label.frame.maxY + y, width: (20 * x), height: (3 * y))
        Line3_TF.backgroundColor = UIColor.white
        Line3_TF.font = UIFont.boldSystemFont(ofSize: 16)
        //Line3_TF.text = "250.00"
        Line3_TF.font = UIFont(name: "Avenir Next", size: 16)
        Line3_TF.textColor = UIColor.black
        Line3_TF.adjustsFontSizeToFitWidth = true
        Line3_TF.keyboardType = .default
        Line3_TF.clearsOnBeginEditing = false
        Line3_TF.returnKeyType = .done
        Line3_TF.delegate = self
        //Line3_TF.layer.borderWidth = 0.5
        Line3_TF.textAlignment = .left
      //  Line3_TF.addTarget(self, action: #selector(self.DoneAction), for: .allEditingEvents)
        BillingView.addSubview(Line3_TF)
        
        
        // CityLabel..
        let CityLabel = UILabel()
        CityLabel.frame = CGRect(x: (2 * x), y: Line3Label.frame.maxY + y, width: (8 * x), height: (3 * y))
        // CityLabel.backgroundColor = UIColor.gray
        CityLabel.font = UIFont.boldSystemFont(ofSize: 16)
        CityLabel.text = "City : "
        CityLabel.font = UIFont(name: "Avenir Next", size: 16)
        CityLabel.textColor = UIColor.black
        CityLabel.textAlignment = .right
        BillingView.addSubview(CityLabel)
        
        // let City_TF = UITextField()
        City_TF.frame = CGRect(x: CityLabel.frame.maxX + x, y: Line3Label.frame.maxY + y, width: (20 * x), height: (3 * y))
        City_TF.backgroundColor = UIColor.white
        City_TF.font = UIFont.boldSystemFont(ofSize: 16)
        //City_TF.text = "250.00"
        City_TF.font = UIFont(name: "Avenir Next", size: 16)
        City_TF.textColor = UIColor.black
        City_TF.adjustsFontSizeToFitWidth = true
        City_TF.keyboardType = .default
        City_TF.clearsOnBeginEditing = false
        City_TF.returnKeyType = .done
        City_TF.delegate = self
        //City_TF.layer.borderWidth = 0.5
        City_TF.textAlignment = .left
     //   City_TF.addTarget(self, action: #selector(self.DoneAction), for: .allEditingEvents)
        BillingView.addSubview(City_TF)
        
        
        // StateLabel..
        let StateLabel = UILabel()
        StateLabel.frame = CGRect(x: (2 * x), y: CityLabel.frame.maxY + y, width: (8 * x), height: (3 * y))
        // StateLabel.backgroundColor = UIColor.gray
        StateLabel.font = UIFont.boldSystemFont(ofSize: 16)
        StateLabel.text = "State : "
        StateLabel.font = UIFont(name: "Avenir Next", size: 16)
        StateLabel.textColor = UIColor.black
        StateLabel.textAlignment = .right
        BillingView.addSubview(StateLabel)
        
        // let State_TF = UITextField()
        State_TF.frame = CGRect(x: StateLabel.frame.maxX + x, y: CityLabel.frame.maxY + y, width: (20 * x), height: (3 * y))
        State_TF.backgroundColor = UIColor.white
        State_TF.font = UIFont.boldSystemFont(ofSize: 16)
        //State_TF.text = "250.00"
        State_TF.font = UIFont(name: "Avenir Next", size: 16)
        State_TF.textColor = UIColor.black
        State_TF.adjustsFontSizeToFitWidth = true
        State_TF.keyboardType = .default
        State_TF.clearsOnBeginEditing = false
        State_TF.returnKeyType = .done
        State_TF.delegate = self
        //State_TF.layer.borderWidth = 0.5
        State_TF.textAlignment = .left
      //  State_TF.addTarget(self, action: #selector(self.DoneAction), for: .allEditingEvents)
        BillingView.addSubview(State_TF)
        
        
        // CountryLabel..
        let CountryLabel = UILabel()
        CountryLabel.frame = CGRect(x: (2 * x), y: StateLabel.frame.maxY + y, width: (8 * x), height: (3 * y))
        // CountryLabel.backgroundColor = UIColor.gray
        CountryLabel.font = UIFont.boldSystemFont(ofSize: 16)
        CountryLabel.text = "Country : "
        CountryLabel.font = UIFont(name: "Avenir Next", size: 16)
        CountryLabel.textColor = UIColor.black
        CountryLabel.textAlignment = .right
        BillingView.addSubview(CountryLabel)
        
        // let Country_TF = UITextField()
        Country_TF.frame = CGRect(x: CountryLabel.frame.maxX + x, y: StateLabel.frame.maxY + y, width: (20 * x), height: (3 * y))
        Country_TF.backgroundColor = UIColor.white
        Country_TF.font = UIFont.boldSystemFont(ofSize: 16)
        //Country_TF.text = "250.00"
        Country_TF.font = UIFont(name: "Avenir Next", size: 16)
        Country_TF.textColor = UIColor.black
        Country_TF.adjustsFontSizeToFitWidth = true
        Country_TF.keyboardType = .default
        Country_TF.clearsOnBeginEditing = false
        Country_TF.returnKeyType = .done
        Country_TF.delegate = self
        //Country_TF.layer.borderWidth = 0.5
        Country_TF.textAlignment = .left
      //  Country_TF.addTarget(self, action: #selector(self.DoneAction), for: .allEditingEvents)
        BillingView.addSubview(Country_TF)
        
        
        // ZipCodeLabel..
        let ZipCodeLabel = UILabel()
        ZipCodeLabel.frame = CGRect(x: (2 * x), y: CountryLabel.frame.maxY + y, width: (8 * x), height: (3 * y))
        // ZipCodeLabel.backgroundColor = UIColor.gray
        ZipCodeLabel.font = UIFont.boldSystemFont(ofSize: 16)
        ZipCodeLabel.text = "Zip Code : "
        ZipCodeLabel.font = UIFont(name: "Avenir Next", size: 16)
        ZipCodeLabel.textColor = UIColor.black
        ZipCodeLabel.textAlignment = .right
        BillingView.addSubview(ZipCodeLabel)
        
        
        // let ZipCode_TF = UITextField()
        ZipCode_TF.frame = CGRect(x: ZipCodeLabel.frame.maxX + x, y: CountryLabel.frame.maxY + y, width: (20 * x), height: (3 * y))
        ZipCode_TF.backgroundColor = UIColor.white
        ZipCode_TF.font = UIFont.boldSystemFont(ofSize: 16)
        //ZipCode_TF.text = "250.00"
        ZipCode_TF.font = UIFont(name: "Avenir Next", size: 16)
        ZipCode_TF.textColor = UIColor.black
        ZipCode_TF.adjustsFontSizeToFitWidth = true
        ZipCode_TF.keyboardType = .numberPad
        ZipCode_TF.clearsOnBeginEditing = false
        ZipCode_TF.returnKeyType = .done
        ZipCode_TF.delegate = self
        //ZipCode_TF.layer.borderWidth = 0.5
        ZipCode_TF.textAlignment = .left
        BillingView.addSubview(ZipCode_TF)
        
        
        // EmailLabel..
        let EmailLabel = UILabel()
        EmailLabel.frame = CGRect(x: (2 * x), y: ZipCodeLabel.frame.maxY + y, width: (8 * x), height: (3 * y))
        // ZipCodeLabel.backgroundColor = UIColor.gray
        EmailLabel.font = UIFont.boldSystemFont(ofSize: 16)
        EmailLabel.text = "Email : "
        EmailLabel.font = UIFont(name: "Avenir Next", size: 16)
        EmailLabel.textColor = UIColor.black
        EmailLabel.textAlignment = .right
        BillingView.addSubview(EmailLabel)
        
        // let ZipCode_TF = UITextField()
        Email_TF.frame = CGRect(x: EmailLabel.frame.maxX + x, y: ZipCodeLabel.frame.maxY + y, width: (20 * x), height: (3 * y))
        Email_TF.backgroundColor = UIColor.white
        Email_TF.font = UIFont.boldSystemFont(ofSize: 16)
        //Email_TF.text = "250.00"
        Email_TF.font = UIFont(name: "Avenir Next", size: 16)
        Email_TF.textColor = UIColor.black
        Email_TF.adjustsFontSizeToFitWidth = true
        Email_TF.keyboardType = .default
        Email_TF.clearsOnBeginEditing = false
        Email_TF.returnKeyType = .done
        Email_TF.delegate = self
        //Email_TF.layer.borderWidth = 0.5
        Email_TF.textAlignment = .left
      //  Email_TF.addTarget(self, action: #selector(self.DoneAction), for: .allEditingEvents)
        BillingView.addSubview(Email_TF)
        
        
        // Amount Label..
        let AmountLabel = UILabel()
        AmountLabel.frame = CGRect(x: (2 * x), y: EmailLabel.frame.maxY + y, width: (8 * x), height: (3 * y))
        // AmountLabel.backgroundColor = UIColor.gray
        AmountLabel.font = UIFont.boldSystemFont(ofSize: 16)
        AmountLabel.text = "Amount : "
        AmountLabel.font = UIFont(name: "Avenir Next", size: 16)
        AmountLabel.textColor = UIColor.black
        AmountLabel.textAlignment = .right
        BillingView.addSubview(AmountLabel)
        
        // let Amount_TF = UITextField()
        Amount_TF.frame = CGRect(x: AmountLabel.frame.maxX + x, y: EmailLabel.frame.maxY + y, width: (20 * x), height: (3 * y))
        Amount_TF.backgroundColor = UIColor.white
        Amount_TF.font = UIFont.boldSystemFont(ofSize: 16)
        //Amount_TF.text = "250.00"
        Amount_TF.font = UIFont(name: "Avenir Next", size: 16)
        Amount_TF.textColor = UIColor.black
        Amount_TF.adjustsFontSizeToFitWidth = true
        Amount_TF.keyboardType = .numberPad
        Amount_TF.clearsOnBeginEditing = false
        Amount_TF.returnKeyType = .done
        Amount_TF.delegate = self
        //Amount_TF.layer.borderWidth = 0.5
        Amount_TF.textAlignment = .left
        Amount_TF.isUserInteractionEnabled = false
        BillingView.addSubview(Amount_TF)*/
        
        
        //PayButton
        PayButton.frame = CGRect(x: ((BillingView.frame.width - (15 * x)) / 2), y: BillingView.frame.height - (10 * y), width: (15 * x), height: (4 * y))
        PayButton.backgroundColor = UIColor.orange
        PayButton.setTitle("Pay", for: .normal)
        PayButton.setTitleColor(UIColor.white, for: .normal)
        PayButton.titleLabel?.font =  UIFont(name: "Avenir-Regular", size: 20)
        PayButton.layer.cornerRadius = 5;  // this value vary as per your desire
        PayButton.clipsToBounds = true;
        PayButton.addTarget(self, action: #selector(self.PayButtonAction(sender:)), for: .touchUpInside)
        BillingView.addSubview(PayButton)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                changeViewToEnglishInSelf()
                BILLINGLabel.text = "BILLING ADDRESS"
                BILLINGLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                BILLINGLabel.textAlignment = .left
            }
            else if language == "ar"
            {
                changeViewToArabicInSelf()
                BILLINGLabel.text = "عنوان وصول الفواتير"
                BILLINGLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                BILLINGLabel.textAlignment = .right
            }
        }
        else
        {
            changeViewToEnglishInSelf()
            BILLINGLabel.text = "BILLING ADDRESS"
            BILLINGLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            BILLINGLabel.textAlignment = .left
        }
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
        
      //  self.Amount_TF.inputAccessoryView = doneToolbar
        
        if let foundView = view.viewWithTag(506)
        {
            if let text = foundView as? UITextField
            {
                text.inputAccessoryView = doneToolbar
            }
        }
        self.ZipCode_TF.inputAccessoryView = doneToolbar
    }
    
    @objc func DoneAction()
    {
        Line1_TF.resignFirstResponder()
        Line2_TF.resignFirstResponder()
        Line3_TF.resignFirstResponder()
        City_TF.resignFirstResponder()
        State_TF.resignFirstResponder()
        Country_TF.resignFirstResponder()
        Email_TF.resignFirstResponder()
        
       // reviewStr = self.Review_TF.text
    }
    
    @objc func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        view.endEditing(true)
        return true
    }
    
    @objc func PayButtonAction(sender : UIButton)
    {
        for views in BillingView.subviews
        {
            if let foundView = views as? UITextField
            {
                if foundView.text?.isEmpty == true || foundView.text == ""
                {
                    alertFunctionCall()
                    return
                }
                else
                {
                    if foundViewTagArray.contains(foundView.tag)
                    {
                        if foundView.tag == 500
                        {
                            AddLine1 = foundView.text!
                        }
                        else if foundView.tag == 501
                        {
                            AddLine2 = foundView.text!
                        }
                        else if foundView.tag == 502
                        {
                            AddLine3 = foundView.text!
                        }
                        else if foundView.tag == 503
                        {
                            City = foundView.text!
                        }
                        else if foundView.tag == 504
                        {
                            State = foundView.text!
                        }
                        else if foundView.tag == 505
                        {
                            Country = foundView.text!
                        }
                        else if foundView.tag == 506
                        {
                            Zipcode = foundView.text!
                        }
                        else if foundView.tag == 507
                        {
                            EMAIL = foundView.text!
                        }
                        else if foundView.tag == 508
                        {
                            TotalAmount = foundView.text!
                        }
                    }
                    else
                    {
                        if foundView.tag == 500
                        {
                            AddLine1 = foundView.text!
                        }
                        else if foundView.tag == 501
                        {
                            AddLine2 = foundView.text!
                        }
                        else if foundView.tag == 502
                        {
                            AddLine3 = foundView.text!
                        }
                        else if foundView.tag == 503
                        {
                            City = foundView.text!
                        }
                        else if foundView.tag == 504
                        {
                            State = foundView.text!
                        }
                        else if foundView.tag == 505
                        {
                            Country = foundView.text!
                        }
                        else if foundView.tag == 506
                        {
                            Zipcode = foundView.text!
                        }
                        else if foundView.tag == 507
                        {
                            EMAIL = foundView.text!
                        }
                        else if foundView.tag == 508
                        {
                            TotalAmount = foundView.text!
                        }
                        
                        foundViewTagArray.append(foundView.tag)
                    }
                }
                /*if foundView.tag == 500
                {
                    if foundView.text?.isEmpty == true || foundView.text == ""
                    {
                        alertFunctionCall()
                        return
                    }
                    else
                    {
                        
                    }
                }
                else if foundView.tag == 501
                {
                    if foundView.text?.isEmpty == true || foundView.text == ""
                    {
                        alertFunctionCall()
                        return
                    }
                    else
                    {
                        
                    }
                }
                else if foundView.tag == 502
                {
                    if foundView.text?.isEmpty == true || foundView.text == ""
                    {
                        alertFunctionCall()
                        return
                    }
                    else
                    {
                        
                    }
                }
                else if foundView.tag == 503
                {
                    if foundView.text?.isEmpty == true || foundView.text == ""
                    {
                        alertFunctionCall()
                        return
                    }
                    else
                    {
                        
                    }
                }
                else if foundView.tag == 504
                {
                    if foundView.text?.isEmpty == true || foundView.text == ""
                    {
                        alertFunctionCall()
                        return
                    }
                    else
                    {
                        
                    }
                }
                else if foundView.tag == 505
                {
                    if foundView.text?.isEmpty == true || foundView.text == ""
                    {
                        alertFunctionCall()
                        return
                    }
                    else
                    {
                        
                    }
                }
                else if foundView.tag == 506
                {
                    if foundView.text?.isEmpty == true || foundView.text == ""
                    {
                        alertFunctionCall()
                        return
                    }
                    else
                    {
                        
                    }
                }
                else if foundView.tag == 507
                {
                    if foundView.text?.isEmpty == true || foundView.text == ""
                    {
                        alertFunctionCall()
                        return
                    }
                    else
                    {
                        
                    }
                }
                else if foundView.tag == 508
                {
                    if (TotalAmount != "0")
                    {
//                        PayPageRequest()
                    }
                    else
                    {
                        let alert = UIAlertController(title: "Alert", message: "Amount Should Not Be Zero or Empty" , preferredStyle:.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }*/
            }
        }
        
        if foundViewTagArray.count == 9
        {
            UserName = UserDefaults.standard.value(forKey: "userName") as? String
            
            print("Total Amount:",Variables.sharedManager.TotalAmount)
            
         //   UserDefaults.standard.set(TotalAmount, forKey: "TotalAmount")
            
            if Country == "UNITED ARAB EMIRATES"
            {
                Country = "UAE"
            }
            else if Country == "INDIA"
            {
                Country = "IN"
            }
            
            if(RequestId == nil)
            {
                RequestId = String(arc4random())
            }
            else
            {
                RequestId = "\(Variables.sharedManager.OrderID)"
            }
            
            print("ALL VALUES BEFORE SENDING", AddLine1, AddLine2, AddLine3, City, State, Country, Zipcode, EMAIL, TotalAmount)
            
            PayPageRequest()
        }
        else
        {
            alertFunctionCall()
        }
    }
    
    /*{
        AddLine1 = self.Line1_TF.text
        AddLine2 = self.Line2_TF.text
        AddLine3 = self.Line3_TF.text
        City = self.City_TF.text
        State = self.State_TF.text
        Country = self.Country_TF.text
        Zipcode = self.ZipCode_TF.text
        EMAIL = self.Email_TF.text
        TotalAmount = self.Amount_TF.text
       
        UserDefaults.standard.set(TotalAmount, forKey: "TotalAmount")
        
     //   RequestId = UserDefaults.standard.value(forKey: "requestId") as? String
        UserName = UserDefaults.standard.value(forKey: "userName") as? String
        
      if Country == "UNITED ARAB EMIRATES"
      {
          Country = "UAE"
      }
      else if Country == "INDIA"
      {
          Country = "IN"
      }
        
        /*
      if RequestId == nil
      {
        RequestId = String(arc4random())
        print("Request ID:",RequestId)
      }
        else
      {
         RequestId = String(arc4random())
         print("Request ID:",RequestId)
      }
      */
        
        RequestId = String(arc4random())
       
    /*
       if UserName == nil
       {
         UserName = "QolTech"
       }
    */
        
      //  PaymentRequest()
      
    if (EMAIL.isEmpty)
    {
        var alert = UIAlertController()
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                alert = UIAlertController(title: "Message", message: "Please Enter Your Email Id..!" , preferredStyle:.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            }
            else if language == "ar"
            {
                alert = UIAlertController(title: "رسالة", message: "الرجاء إدخال اسم المستخدم الخاص بك البريد الإلكتروني ..!" , preferredStyle:.alert)
                alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertAction.Style.default, handler: nil))
            }
        }
        else
        {
            alert = UIAlertController(title: "Message", message: "Please Enter Your Email Id..!" , preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        }
        
        
            self.present(alert, animated: true, completion: nil)
    }
    else
    {
        if (TotalAmount != "0")
        {
            PayPageRequest()
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "Amount Should Not Be Zero or Empty" , preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
        
  }*/
    
    func alertFunctionCall()
    {
        var alert = UIAlertController()
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                alert = UIAlertController(title: "Message", message: "Please fill all the fields to proceed" , preferredStyle:.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            }
            else if language == "ar"
            {
                alert = UIAlertController(title: "رسالة", message: "يرجى ملء جميع الحقول للمتابعة" , preferredStyle:.alert)
                alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertAction.Style.default, handler: nil))
            }
        }
        else
        {
            alert = UIAlertController(title: "Message", message: "Please fill all the fields to proceed" , preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
  
    // UITextfield Move upward & Downward Code..
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
       animateViewMoving(up: true, moveValue: 90)
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        animateViewMoving(up: false, moveValue: 90)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat)
    {
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
}

