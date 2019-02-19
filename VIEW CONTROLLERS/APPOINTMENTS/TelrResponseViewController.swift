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
    
    var TransRef:String!
    var TransTraceNum:String!
    var TelrTransCode:String!
    
    let PaymentNavigationBar = UIView()
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
    var EMAIL:String!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        KEY = "XZCQ~9wRvD^prrJx" //"0d644cd3MsvS6r49sBDqdd29"  // "XZCQ~9wRvD^prrJx"
        STOREID = "21552"
        TelrTransCode = UserDefaults.standard.value(forKey: "TransCode") as? String
        
        
       // ResponseContent()
        
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
                            
                            let RefNum = AuthDict.object(forKey: "tranref")! as AnyObject
                            //  print("StartWebView:",StartWebView)
                            
                            self.TransRef = (RefNum.object(forKey: "text") as AnyObject) as? String
                            print("TransRef :",self.TransRef)
                            
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
    

    func ResponseContent()
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
        //PaymentNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: PaymentNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "TRANSACTION SUMMARY"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        PaymentNavigationBar.addSubview(navigationTitle)
        
        
        // Payment View..
        
        let TransactionView = UIView()
        TransactionView.frame = CGRect(x: (3 * x), y: ((view.frame.height - (10 * y)) / 2), width: view.frame.width - (6 * x), height: (10 * y))
        TransactionView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(TransactionView)
        
        // Transaction Label..
        let TransLabel = UILabel()
        TransLabel.frame = CGRect(x: x, y: (y / 2), width: TransactionView.frame.width - (2 * x), height: (5 * y))
        // TransLabel.backgroundColor = UIColor.gray
        TransLabel.font = UIFont.boldSystemFont(ofSize: 16)
        TransLabel.text = "Payment Success, Your Transaction Reference Number is  : \(TransRef!)"
        TransLabel.font = UIFont(name: "Avenir Next", size: 16)
        TransLabel.textColor = UIColor.white
        TransLabel.textAlignment = .center
        TransLabel.lineBreakMode = .byWordWrapping
        TransLabel.numberOfLines = 3
        TransactionView.addSubview(TransLabel)
        
     
        // Done Button
        let DoneButton = UIButton()
        DoneButton.frame = CGRect(x: ((TransactionView.frame.width - (15 * x)) / 2), y: TransLabel.frame.maxY + y, width: (15 * x), height: (3 * y))
        DoneButton.backgroundColor = UIColor.orange
        DoneButton.setTitle("Done", for: .normal)
        DoneButton.setTitleColor(UIColor.white, for: .normal)
        DoneButton.titleLabel?.font =  UIFont(name: "Avenir-Regular", size: (1.3 * x))
        DoneButton.layer.cornerRadius = 10  // this value vary as per your desire
        DoneButton.isUserInteractionEnabled = true
        DoneButton.addTarget(self, action: #selector(self.DoneButtonAction(sender:)), for: .touchUpInside)
        TransactionView.addSubview(DoneButton)
        
        self.view.bringSubviewToFront(DoneButton)
    }
    
    
    @objc func otpBackButtonAction(sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func DoneButtonAction(sender : UIButton)
    {
        
        /*
        if let orderId = UserDefaults.standard.value(forKey: "OrderID") as? Int
        {
            self.serviceCall.API_updatePaymentStatus(PaymentStatus: 1, OrderId: orderId, delegate: self)
        }
        else if let orderId = UserDefaults.standard.value(forKey: "userId") as? String
        {
            self.serviceCall.API_updatePaymentStatus(PaymentStatus: 1, OrderId:Int(orderId)!, delegate: self)
        }
        */
        
        
        let orderId = UserDefaults.standard.value(forKey: "OrderID") as? Int
        let TailorId = UserDefaults.standard.value(forKey: "TailorID") as? Int
        
        print("orderId :",orderId!)
        print("TailorId :",TailorId!)
        
        self.serviceCall.API_updatePaymentStatus(PaymentStatus: 1, OrderId: orderId!, delegate: self)
        self.serviceCall.API_BuyerOrderApproval(OrderId: orderId!, ApprovedTailorId: TailorId!, delegate: self)
        
      /*
        let HomeScreen = HomeViewController()
        self.navigationController?.pushViewController(HomeScreen, animated: true)
        self.present(HomeScreen, animated: true, completion: nil)
      */
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let HomeScreen = HomeViewController()
        let navigationScreen = UINavigationController(rootViewController: HomeScreen)
        navigationScreen.isNavigationBarHidden = true
        window?.rootViewController = navigationScreen
        window?.makeKeyAndVisible()
        
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
            MethodName = ""
            
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
            MethodName = ""
            
            DeviceError()
            
        }
    }

}
