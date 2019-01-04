//
//  AppointmentViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 04/01/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class AppointmentViewController: CommonViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        AppointmentContent()
    }
    
    func AppointmentContent()
    {
        self.stopActivity()
        
        let AppointmentNavigationBar = UIView()
        AppointmentNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        AppointmentNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(AppointmentNavigationBar)
        
        let backButton = UIButton()
         backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
         backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
         backButton.tag = 4
         backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
         AppointmentNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: AppointmentNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "APPOINTMENT"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        AppointmentNavigationBar.addSubview(navigationTitle)
        
        AppointmentTypeView()
    }
    
    func AppointmentTypeView()
    {
        
        // Order Type..
        
        let orderTypeLabel = UILabel()
        orderTypeLabel.frame = CGRect(x: ((view.frame.width - (12 * x)) / 2), y: (8 * y), width: (12 * x), height: (3 * y))
        orderTypeLabel.backgroundColor = UIColor.white
        orderTypeLabel.text = "ORDER TYPE"
        orderTypeLabel.layer.borderColor = UIColor.lightGray.cgColor
        orderTypeLabel.layer.borderWidth = 1.0
        orderTypeLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        orderTypeLabel.textAlignment = .center
        orderTypeLabel.font = UIFont(name: "Avenir Next", size: 16)
        view.addSubview(orderTypeLabel)
        
        
       let AppointmentStatusView = UIView()
        AppointmentStatusView.frame = CGRect(x: ((view.frame.width - (2 * x)) / 2), y: orderTypeLabel.frame.maxY + (2 * y), width: (19 * x), height: (2 * y))
        AppointmentStatusView.backgroundColor = UIColor.white
        AppointmentStatusView.layer.borderColor = UIColor.lightGray.cgColor
        AppointmentStatusView.layer.borderWidth = 1.0
        AppointmentStatusView.layer.cornerRadius = 5
        view.addSubview(AppointmentStatusView)
        
        
        let StatusLabel = UILabel()
        StatusLabel.frame = CGRect(x: x, y: 0, width: (12 * x), height: (2 * y))
       // StatusLabel.backgroundColor = UIColor.gray
        StatusLabel.text = "Appointment Status :"
         StatusLabel.textColor = UIColor.black
        StatusLabel.textAlignment = .left
        StatusLabel.font = UIFont(name: "Avenir Next", size: 12)
        AppointmentStatusView.addSubview(StatusLabel)
        
        let StatusBtn = UIButton()
        StatusBtn.frame = CGRect(x: StatusLabel.frame.maxX, y: 0, width: (6 * x), height: (2 * y))
       // StatusBtn.backgroundColor = UIColor.gray
        StatusBtn.setTitle("Approve", for: .normal)
        StatusBtn.setTitleColor(UIColor.blue, for: .normal)
        StatusBtn.titleLabel?.font = UIFont(name: "Avenir Next", size: 12)!
        StatusBtn.addTarget(self, action: #selector(self.statusButtonAction(sender:)), for: .touchUpInside)
        AppointmentStatusView.addSubview(StatusBtn)
        
        // orderType View...
        let courierDeliveryIcon = UIImageView()
        courierDeliveryIcon.frame = CGRect(x: (3 * x), y: AppointmentStatusView.frame.maxY +  y, width: (2 * x), height: (2 * y))
        
       /*
        if let imageName = orderTypeHeaderImage[1] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/OrderType/\(imageName)"
            let apiurl = URL(string: api)
            courierDeliveryIcon.dowloadFromServer(url: apiurl!)
        }
       */
        view.addSubview(courierDeliveryIcon)
        
        let couriertDeliveryLabel = UILabel()
        couriertDeliveryLabel.frame = CGRect(x: courierDeliveryIcon.frame.maxX, y: AppointmentStatusView.frame.maxY + y, width: view.frame.width - (5 * x), height: (2 * y))
        couriertDeliveryLabel.text = "Own Material - Courier the Material"
        couriertDeliveryLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        couriertDeliveryLabel.textAlignment = .left
        couriertDeliveryLabel.font = UIFont(name: "Avenir Next", size: 12)
        couriertDeliveryLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(couriertDeliveryLabel)
        
        let courierDeliveryUnderline = UILabel()
        courierDeliveryUnderline.frame = CGRect(x: (3 * x), y: couriertDeliveryLabel.frame.maxY + (y / 2), width: view.frame.width - (6 * x), height: 0.5)
        courierDeliveryUnderline.backgroundColor = UIColor.lightGray
        view.addSubview(courierDeliveryUnderline)
        
        let courierImageView = UIImageView()
        courierImageView.frame = CGRect(x: (3 * x), y: courierDeliveryUnderline.frame.maxY + y, width: view.frame.width - (6 * x), height: (12 * y))
        courierImageView.backgroundColor = UIColor.lightGray
        /*
        if let imageName = orderTypeBodyImage[1] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/OrderType/\(imageName)"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: courierImageView.frame.width, height: courierImageView.frame.height)
            dummyImageView.dowloadFromServer(url: apiurl!)
            courierImageView.addSubview(dummyImageView)
        }
        */
        view.addSubview(courierImageView)
        
        
        // Material Type..
        
        let MaterialTypeLabel = UILabel()
        MaterialTypeLabel.frame = CGRect(x: ((view.frame.width - (12 * x)) / 2), y: courierImageView.frame.maxY + (2 * y), width: (12 * x), height: (3 * y))
        MaterialTypeLabel.backgroundColor = UIColor.white
        MaterialTypeLabel.text = "MATERIAL TYPE"
        MaterialTypeLabel.layer.borderColor = UIColor.lightGray.cgColor
        MaterialTypeLabel.layer.borderWidth = 1.0
        MaterialTypeLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        MaterialTypeLabel.textAlignment = .center
        MaterialTypeLabel.font = UIFont(name: "Avenir Next", size: 16)
        view.addSubview(MaterialTypeLabel)
        
      
        // orderType View...
        let TailorShopIcon = UIImageView()
        TailorShopIcon.frame = CGRect(x: (3 * x), y: MaterialTypeLabel.frame.maxY +  y, width: (2 * x), height: (2 * y))
        
        /*
         if let imageName = orderTypeHeaderImage[1] as? String
         {
         let api = "http://appsapi.mzyoon.com/images/OrderType/\(imageName)"
         let apiurl = URL(string: api)
         courierDeliveryIcon.dowloadFromServer(url: apiurl!)
         }
         */
        view.addSubview(TailorShopIcon)
        
        let TailorTypeLabel = UILabel()
        TailorTypeLabel.frame = CGRect(x: TailorShopIcon.frame.maxX, y: MaterialTypeLabel.frame.maxY + y, width: view.frame.width - (5 * x), height: (2 * y))
        TailorTypeLabel.text = "Go To Tailor Shop"
        TailorTypeLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        TailorTypeLabel.textAlignment = .left
        TailorTypeLabel.font = UIFont(name: "Avenir Next", size: 12)
        TailorTypeLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(TailorTypeLabel)
        
        let TailorUnderline = UILabel()
        TailorUnderline.frame = CGRect(x: (3 * x), y: TailorTypeLabel.frame.maxY + (y / 2), width: view.frame.width - (6 * x), height: 0.5)
        TailorUnderline.backgroundColor = UIColor.lightGray
        view.addSubview(TailorUnderline)
        
        let TailorImageView = UIImageView()
        TailorImageView.frame = CGRect(x: (3 * x), y: TailorUnderline.frame.maxY + y, width: view.frame.width - (6 * x), height: (12 * y))
        TailorImageView.backgroundColor = UIColor.lightGray
        /*
         if let imageName = orderTypeBodyImage[1] as? String
         {
         let api = "http://appsapi.mzyoon.com/images/OrderType/\(imageName)"
         print("SMALL ICON", api)
         let apiurl = URL(string: api)
         
         let dummyImageView = UIImageView()
         dummyImageView.frame = CGRect(x: 0, y: 0, width: courierImageView.frame.width, height: courierImageView.frame.height)
         dummyImageView.dowloadFromServer(url: apiurl!)
         courierImageView.addSubview(dummyImageView)
         }
         */
        view.addSubview(TailorImageView)
        
    }

    
    @objc func otpBackButtonAction(sender : UIButton)
    {
     self.navigationController?.popViewController(animated: true)
    }
    
    @objc func statusButtonAction(sender : UIButton)
    {
        print("status Page..")
    }
 
}
