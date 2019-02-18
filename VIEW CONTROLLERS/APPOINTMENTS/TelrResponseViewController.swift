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
    
    let PaymentNavigationBar = UIView()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ResponseContent()
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
        TransactionView.frame = CGRect(x: (3 * x), y: PaymentNavigationBar.frame.maxY + (3 * y), width: view.frame.width - (6 * x), height: (10 * y))
        //PaymentView.backgroundColor = UIColor.white
        view.addSubview(TransactionView)
        
        // Transaction Label..
        let TransLabel = UILabel()
        TransLabel.frame = CGRect(x: x, y: y, width: TransactionView.frame.width - (2 * x), height: (6 * y))
        // TransLabel.backgroundColor = UIColor.gray
        TransLabel.font = UIFont.boldSystemFont(ofSize: 16)
        TransLabel.text = "Payment Success, Your Transaction Reference Number is  : \(TransRef!)"
        TransLabel.font = UIFont(name: "Avenir Next", size: 16)
        TransLabel.textColor = UIColor.black
        TransLabel.textAlignment = .left
        TransLabel.lineBreakMode = .byWordWrapping
        TransLabel.numberOfLines = 3
        TransactionView.addSubview(TransLabel)
        
     
        // Done Button
        let DoneButton = UIButton()
        DoneButton.frame = CGRect(x: (8 * x), y: TransLabel.frame.maxY + (4 * y), width: (15 * x), height: (3 * y))
        DoneButton.backgroundColor = UIColor.orange
        DoneButton.setTitle("Done", for: .normal)
        DoneButton.setTitleColor(UIColor.white, for: .normal)
        DoneButton.titleLabel?.font =  UIFont(name: "Avenir-Regular", size: 10)
        DoneButton.layer.cornerRadius = 10;  // this value vary as per your desire
        DoneButton.clipsToBounds = true;
        DoneButton.addTarget(self, action: #selector(self.DoneButtonAction(sender:)), for: .touchUpInside)
        TransactionView.addSubview(DoneButton)
        
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
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
        
        
        let HomeScreen = HomeViewController()
        self.navigationController?.pushViewController(HomeScreen, animated: true)
        self.present(HomeScreen, animated: true, completion: nil)
        
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
