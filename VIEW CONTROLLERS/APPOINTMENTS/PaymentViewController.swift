//
//  PaymentViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 24/01/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit
import TelrSDK

class PaymentViewController: CommonViewController
{
    
    let KEY:String = "qTTvw#d4mg@d5k3j"
    let STOREID:String = "21552"
    let EMAIL:String = "rohith.qol@gmail.com"
    
    var Amount_TF = UITextField()
    
   // var paymentRequest:PaymentRequest?

    let PaymentNavigationBar = UIView()
    
   // var x = CGFloat()
  //  var y = CGFloat()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
      /*
        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
      */
        
         PaymentContent()
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
        PaymentView.frame = CGRect(x: (3 * x), y: PaymentNavigationBar.frame.maxY + (2 * y), width: view.frame.width - (6 * x), height: (10 * y))
        //PaymentView.backgroundColor = UIColor.white
        view.addSubview(PaymentView)
        
        // Order Id Label..
        let AmountLabel = UILabel()
        AmountLabel.frame = CGRect(x: x, y: y, width: PaymentView.frame.width / 2, height: (3 * x))
        // AmountLabel.backgroundColor = UIColor.gray
        AmountLabel.font = UIFont.boldSystemFont(ofSize: 16)
        AmountLabel.text = "Amount : "
        AmountLabel.font = UIFont(name: "Avenir Next", size: 16)
        AmountLabel.textColor = UIColor.black
        PaymentView.addSubview(AmountLabel)
        
       // let Amount_TF = UITextField()
        Amount_TF.frame = CGRect(x: AmountLabel.frame.maxX - x, y: y, width: PaymentView.frame.width / 2, height: (3 * x))
         Amount_TF.backgroundColor = UIColor.lightGray
        Amount_TF.font = UIFont.boldSystemFont(ofSize: 16)
        Amount_TF.text = "50.00"
        Amount_TF.font = UIFont(name: "Avenir Next", size: 16)
        Amount_TF.textColor = UIColor.black
        PaymentView.addSubview(Amount_TF)
        
        
        //TrackingButton
        let PayButton = UIButton()
        PayButton.frame = CGRect(x: (8 * x), y: Amount_TF.frame.maxY + (2 * y), width: (15 * x), height: (2 * y))
        PayButton.backgroundColor = UIColor.orange
        PayButton.setTitle("Pay", for: .normal)
        PayButton.setTitleColor(UIColor.white, for: .normal)
        PayButton.titleLabel?.font =  UIFont(name: "Avenir-Regular", size: 10)
        PayButton.layer.cornerRadius = 10;  // this value vary as per your desire
        PayButton.clipsToBounds = true;
        PayButton.addTarget(self, action: #selector(self.PayButtonAction(sender:)), for: .touchUpInside)
        PaymentView.addSubview(PayButton)
        
    }
    
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func PayButtonAction(sender : UIButton)
    {
       // paymentRequest = preparePaymentRequest()
        
    }
   
    /*
    private func preparePaymentRequest() -> PaymentRequest
     {
        
        let paymentReq = PaymentRequest()
        paymentReq.key = KEY
        paymentReq.store = STOREID
        paymentReq.appId = "123456789"
        paymentReq.appName = "TelrSDK"
        paymentReq.appUser = "123456"
        paymentReq.appVersion = "0.0.1"
        paymentReq.transTest = "1"
        paymentReq.transType = "auth"
        paymentReq.transClass = "paypage"
        paymentReq.transCartid = String(arc4random())
        paymentReq.transDesc = "Test API"
        paymentReq.transCurrency = "AED"
        paymentReq.transAmount = self.Amount_TF.text!
        paymentReq.transLanguage = "en"
        paymentReq.billingEmail = EMAIL // TODO fill email
        paymentReq.billingFName = "Hany"
        paymentReq.billingLName = "Sakr"
        paymentReq.billingTitle = "Mr"
        paymentReq.city = "Dubai"
        paymentReq.country = "AE"
        paymentReq.region = "Dubai"
        paymentReq.address = "line 1"
        paymentReq.billingPhone="8785643"
        return paymentReq
    }
    */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
