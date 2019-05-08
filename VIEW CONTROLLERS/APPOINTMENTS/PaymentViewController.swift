//
//  PaymentViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 24/01/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

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

    var UserNameStr:String!
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
        
        if let UserName = UserDefaults.standard.value(forKey: "userName") as? String
        {
            print("UserName :",UserName)
            UserNameStr = UserName
        }
        
        if let RequestID = UserDefaults.standard.value(forKey: "requestId") as? Int
        {
            // Variables.sharedManager.OrderID = RequestID
             RequestId = "\(RequestID)"
        }
        else if let RequestID = UserDefaults.standard.value(forKey: "requestId") as? String
        {
             RequestId = "\(RequestID)"
        }
        
        //  self.Email_TF.text = UserDefaults.standard.value(forKey: "Email") as? String
        
        TotalAmount = Variables.sharedManager.TotalAmount
        
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
                
               /*
                self.Line1_TF.text = Line1Str
                self.Line2_TF.text = Line2Str
                self.Line3_TF.text = Line3Str
                self.City_TF.text = CityStr
                self.State_TF.text = StateStr
                self.Country_TF.text = CountryStr
                self.Email_TF.text = EmailStr
               */
                
                
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
            "<first>\(UserNameStr!)</first>" +
            "<last></last>" +
            "</name>" +
            "<address>" +
            "<line1>\(AddLine1!)</line1>" +
            "<line2>\(AddLine2!)</line2>" +
            "<line3>\(AddLine3!)</line3>" +
            "<city>\(City!)</city>" +
            "<region>\(State!)</region>" +
            "<country>\(Country!)</country>" +
            "<zip></zip>" +
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
        BillingView.frame = CGRect(x: x, y: selfScreenNavigationBar.frame.maxY + (3 * y), width: view.frame.width - (2 * x), height: (20 * y))
        BillingView.backgroundColor = UIColor.clear
        view.addSubview(BillingView)
        
        // Amount Label..
        let AmountLabel = UILabel()
        AmountLabel.frame = CGRect(x: (4 * x), y: (2 * y), width: (12 * x), height: (3 * y))
        // AmountLabel.backgroundColor = UIColor.gray
        AmountLabel.font = UIFont.boldSystemFont(ofSize: 16)
        AmountLabel.text = "Total Amount :"
        AmountLabel.font = UIFont(name: "Avenir Next", size: 16)
        AmountLabel.textColor = UIColor.black
        AmountLabel.textAlignment = .right
        BillingView.addSubview(AmountLabel)
        
        // let Amount_TF = UITextField()
        Amount_TF.frame = CGRect(x: AmountLabel.frame.maxX + x, y: (2 * y), width: (15 * x), height: (3 * y))
        Amount_TF.backgroundColor = UIColor.white
        Amount_TF.font = UIFont.boldSystemFont(ofSize: 16)
        Amount_TF.text = TotalAmount
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
        BillingView.addSubview(Amount_TF)

        //PayButton
        PayButton.frame = CGRect(x: ((BillingView.frame.width - (15 * x)) / 2), y: Amount_TF.frame.height + (5 * y), width: (15 * x), height: (4 * y))
        PayButton.backgroundColor = UIColor(red:0.29, green:0.48, blue:0.92, alpha:1.0)
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
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func PayButtonAction(sender : UIButton)
    {
        
        if(RequestId == nil)
        {
            RequestId = String(arc4random())
        }
        else
        {
            RequestId = "\(Variables.sharedManager.OrderID)"
        }

        if(Line1Str == nil)
        {
            AddLine1 = ""
        }
        else
        {
            AddLine1 = Line1Str
        }
        
        if(Line2Str == nil)
        {
            AddLine2 = ""
        }
        else
        {
            AddLine2 = Line2Str
        }
        
        if(Line3Str == nil)
        {
            AddLine3 = ""
        }
        else
        {
            AddLine3 = Line3Str
        }
        
        if(CityStr == nil)
        {
            City = ""
        }
        else
        {
            City = CityStr
        }
        
        if(StateStr == nil)
        {
            State = ""
        }
        else
        {
            State = StateStr
        }
        
        if(CountryStr == nil)
        {
            Country = ""
        }
        else
        {
            Country = CountryStr
        }
        
        if(EmailStr == nil)
        {
            EMAIL = ""
        }
        else
        {
            EMAIL = EmailStr
        }
        
         PayPageRequest()
    }
    
}

