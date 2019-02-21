//
//  PaymentViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 24/01/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit
import TelrSDK

class PaymentViewController: CommonViewController,ServerAPIDelegate,UITextFieldDelegate
{
   
    
    
  //  let KEY:String = "XZCQ~9wRvD^prrJx"
 //   let STOREID:String = "21552"
 //   let EMAIL:String = "rohith.qol@gmail.com"
    
    let serviceCall = ServerAPI()
    
    let Amount_TF = UITextField()
    var TotalAmount:String!
    
    // Parameters:
    var KEY:String!
    var STOREID:String!
    var EMAIL:String!
    var MerchantID:String!
    
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

    let PaymentNavigationBar = UIView()
    
    // Error PAram...
    var DeviceNumStr:String!
    var UserType:String!
    var AppVersionStr:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
   // var x = CGFloat()
  //  var y = CGFloat()
    
    override func viewDidLoad()
    {
        print("TailorId",TailorId)
        UserDefaults.standard.set(TailorId, forKey: "TailorID")
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
      /*
        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
      */
        
       self.Amount_TF.text = TotalAmount!
        
         PaymentContent()
        
         self.addDoneButtonOnKeyboard()
        
          KEY = "XZCQ~9wRvD^prrJx"  //"0d644cd3MsvS6r49sBDqdd29"  // "XZCQ~9wRvD^prrJx"
          STOREID = "21552"
     //   MerchantID = "12168"
        
        EMAIL = UserDefaults.standard.value(forKey: "Email") as? String
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
        RequestId = UserDefaults.standard.value(forKey: "requestId") as? String
        UserName = UserDefaults.standard.value(forKey: "userName") as? String
        
       // ConvertBase64()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.serviceCall.API_GetPaymentStoreDetails(delegate: self)
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
        PageNumStr = "AppointmentViewController"
        //  MethodName = "do"
        
        print("UUID", UIDevice.current.identifierForVendor?.uuidString as Any)
        
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNumStr!, PageName: PageNumStr!, MethodName: MethodName!, Error: ErrorStr!, ApiVersion: AppVersionStr!, Type: UserType!, delegate: self)
        
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
         print("Payment summary : ", errorMessage)
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
            
          //  DeviceError()
            
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
    func PaymentContent()
    {
          stopActivity()
        
        // let PaymentNavigationBar = UIView()
        PaymentNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        PaymentNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(PaymentNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 4
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        PaymentNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: PaymentNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "PAYMENT SUMMARY"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        PaymentNavigationBar.addSubview(navigationTitle)
        
    
    // Payment View..
        
        let PaymentView = UIView()
        PaymentView.frame = CGRect(x: (3 * x), y: PaymentNavigationBar.frame.maxY + (3 * y), width: view.frame.width - (6 * x), height: (10 * y))
        PaymentView.backgroundColor = UIColor.white
        view.addSubview(PaymentView)
        
        // Order Id Label..
        let AmountLabel = UILabel()
        AmountLabel.frame = CGRect(x: (2 * x), y: y, width: (8 * x), height: (3 * y))
       // AmountLabel.backgroundColor = UIColor.gray
        AmountLabel.font = UIFont.boldSystemFont(ofSize: 16)
        AmountLabel.text = "Amount : "
        AmountLabel.font = UIFont(name: "Avenir Next", size: 16)
        AmountLabel.textColor = UIColor.black
        AmountLabel.textAlignment = .right
        PaymentView.addSubview(AmountLabel)
        
       // let Amount_TF = UITextField()
        Amount_TF.frame = CGRect(x: AmountLabel.frame.maxX + x, y: y, width: PaymentView.frame.width / 2, height: (3 * y))
        Amount_TF.backgroundColor = UIColor.groupTableViewBackground
        Amount_TF.font = UIFont.boldSystemFont(ofSize: 16)
        //Amount_TF.text = "250.00"
        Amount_TF.font = UIFont(name: "Avenir Next", size: 16)
        Amount_TF.textColor = UIColor.black
        Amount_TF.adjustsFontSizeToFitWidth = true
        Amount_TF.keyboardType = .numberPad
        Amount_TF.clearsOnBeginEditing = true
        Amount_TF.returnKeyType = .done
        Amount_TF.delegate = self
        //Amount_TF.layer.borderWidth = 0.5
        Amount_TF.textAlignment = .left
        PaymentView.addSubview(Amount_TF)
        
        
        //TrackingButton
        let PayButton = UIButton()
        PayButton.frame = CGRect(x: (8 * x), y: Amount_TF.frame.maxY + (3 * y), width: (15 * x), height: (3 * y))
        PayButton.backgroundColor = UIColor.orange
        PayButton.setTitle("Pay", for: .normal)
        PayButton.setTitleColor(UIColor.white, for: .normal)
        PayButton.titleLabel?.font =  UIFont(name: "Avenir-Regular", size: 10)
        PayButton.layer.cornerRadius = 10;  // this value vary as per your desire
        PayButton.clipsToBounds = true;
        PayButton.addTarget(self, action: #selector(self.PayButtonAction(sender:)), for: .touchUpInside)
        PaymentView.addSubview(PayButton)
        
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
        
        self.Amount_TF.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func PayButtonAction(sender : UIButton)
    {
        
       TotalAmount = self.Amount_TF.text
        
       UserDefaults.standard.set(TotalAmount, forKey: "TotalAmount")
        
    
      if RequestId == nil
      {
        RequestId = String(arc4random())
        print("Request ID:",RequestId)
      }
 
     //  RequestId = String(arc4random())
        
    
      if UserName == nil
      {
         UserName = "QolTech"
      }
     
        
      //  PaymentRequest()
      
       if (TotalAmount != "0")
       {
          PayPageRequest()
       }
       else
       {
         let alert = UIAlertController(title: "Alert", message: "Amount Should Be Greater Than 0" , preferredStyle:.alert)
         alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
       }
        
  }
  
}

