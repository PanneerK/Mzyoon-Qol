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
      let AppointmentSelectionView = UIView()
      let RejectButtonView = UIView()
    
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
        orderTypeLabel.frame = CGRect(x: ((view.frame.width - (12 * x)) / 2), y: (7 * y), width: (14 * x), height: (3 * y))
        orderTypeLabel.backgroundColor = UIColor.white
        orderTypeLabel.text = "ORDER TYPE"
        orderTypeLabel.layer.borderColor = UIColor.lightGray.cgColor
        orderTypeLabel.layer.borderWidth = 1.0
        orderTypeLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        orderTypeLabel.textAlignment = .center
        orderTypeLabel.font = UIFont(name: "Avenir Next", size: 16)
        view.addSubview(orderTypeLabel)
        
        
       let AppointmentStatusView = UIView()
        AppointmentStatusView.frame = CGRect(x: ((view.frame.width - (2 * x)) / 2), y: orderTypeLabel.frame.maxY + y, width: (19 * x), height: (2 * y))
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
        StatusBtn.setTitle("Reject", for: .normal)
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
        courierImageView.frame = CGRect(x: (3 * x), y: courierDeliveryUnderline.frame.maxY + y, width: view.frame.width - (6 * x), height: (10 * y))
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
        
        
        let From_OrderTypeLBL = UILabel()
        From_OrderTypeLBL.frame = CGRect(x: (3 * x), y: courierImageView.frame.maxY + y , width: courierImageView.frame.width / 2 , height: (2 * y))
        From_OrderTypeLBL.text = "FROM"
        From_OrderTypeLBL.textColor = UIColor.black
        From_OrderTypeLBL.textAlignment = .left
        From_OrderTypeLBL.font = UIFont(name: "Avenir Next", size: 12)
        From_OrderTypeLBL.adjustsFontSizeToFitWidth = true
       // From_OrderTypeLBL.backgroundColor = UIColor.lightGray
        view.addSubview(From_OrderTypeLBL)
        
        let TO_OrderTypeLBL = UILabel()
        TO_OrderTypeLBL.frame = CGRect(x: From_OrderTypeLBL.frame.maxX + 1, y: courierImageView.frame.maxY + y , width: courierImageView.frame.width / 2, height: (2 * y))
        TO_OrderTypeLBL.text = "TO"
        TO_OrderTypeLBL.textColor = UIColor.black
        TO_OrderTypeLBL.textAlignment = .left
        TO_OrderTypeLBL.font = UIFont(name: "Avenir Next", size: 12)
        TO_OrderTypeLBL.adjustsFontSizeToFitWidth = true
       // TO_OrderTypeLBL.backgroundColor = UIColor.lightGray
        view.addSubview(TO_OrderTypeLBL)
        
       
        let From_OrderType_TF = UITextField()
        From_OrderType_TF.frame = CGRect(x: (3 * x), y: From_OrderTypeLBL.frame.maxY, width: courierImageView.frame.width / 2 , height: (2 * y))
        From_OrderType_TF.text = "28 Dec 2018 2.00 PM"
        From_OrderType_TF.textColor = UIColor.white
        From_OrderType_TF.textAlignment = .center
        From_OrderType_TF.font = UIFont(name: "Avenir Next", size: 12)
        From_OrderType_TF.adjustsFontSizeToFitWidth = true
        From_OrderType_TF.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(From_OrderType_TF)
        
        let TO_OrderType_TF = UITextField()
        TO_OrderType_TF.frame = CGRect(x: From_OrderType_TF.frame.maxX + 1, y: From_OrderTypeLBL.frame.maxY, width: courierImageView.frame.width / 2, height: (2 * y))
        TO_OrderType_TF.text = "31 Dec 2018 10.00 AM"
        TO_OrderType_TF.textColor = UIColor.white
        TO_OrderType_TF.textAlignment = .center
        TO_OrderType_TF.font = UIFont(name: "Avenir Next", size: 12)
        TO_OrderType_TF.adjustsFontSizeToFitWidth = true
        TO_OrderType_TF.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(TO_OrderType_TF)
        
        
        
        // Material Type..
        
        let MaterialTypeLabel = UILabel()
        MaterialTypeLabel.frame = CGRect(x: ((view.frame.width - (12 * x)) / 2), y: From_OrderType_TF.frame.maxY + y, width: (14 * x), height: (3 * y))
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
        TailorImageView.frame = CGRect(x: (3 * x), y: TailorUnderline.frame.maxY + y, width: view.frame.width - (6 * x), height: (10 * y))
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
         */
        view.addSubview(TailorImageView)
        
        let From_MaterialTypeLBL = UILabel()
        From_MaterialTypeLBL.frame = CGRect(x: (3 * x), y: TailorImageView.frame.maxY + y, width: TailorImageView.frame.width / 2 , height: (2 * y))
        From_MaterialTypeLBL.text = "FROM"
        From_MaterialTypeLBL.textColor = UIColor.black
        From_MaterialTypeLBL.textAlignment = .left
        From_MaterialTypeLBL.font = UIFont(name: "Avenir Next", size: 12)
        From_MaterialTypeLBL.adjustsFontSizeToFitWidth = true
       // From_MaterialTypeLBL.backgroundColor = UIColor.lightGray
        view.addSubview(From_MaterialTypeLBL)
        
        let TO_MaterialTypeLBL = UILabel()
        TO_MaterialTypeLBL.frame = CGRect(x: From_MaterialTypeLBL.frame.maxX + 1, y: TailorImageView.frame.maxY + y, width: TailorImageView.frame.width / 2, height: (2 * y))
        TO_MaterialTypeLBL.text = "TO"
        TO_MaterialTypeLBL.textColor = UIColor.black
        TO_MaterialTypeLBL.textAlignment = .left
        TO_MaterialTypeLBL.font = UIFont(name: "Avenir Next", size: 12)
        TO_MaterialTypeLBL.adjustsFontSizeToFitWidth = true
       //  TO_OrderTypeLBL.backgroundColor = UIColor.lightGray
        view.addSubview(TO_MaterialTypeLBL)
        
        let From_MaterialType_TF = UITextField()
        From_MaterialType_TF.frame = CGRect(x: (3 * x), y: From_MaterialTypeLBL.frame.maxY, width: courierImageView.frame.width / 2 , height: (2 * y))
        From_MaterialType_TF.text = "15 Dec 2018 2.00 PM"
        From_MaterialType_TF.textColor = UIColor.white
        From_MaterialType_TF.textAlignment = .center
        From_MaterialType_TF.font = UIFont(name: "Avenir Next", size: 12)
        From_MaterialType_TF.adjustsFontSizeToFitWidth = true
        From_MaterialType_TF.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(From_MaterialType_TF)
        
        let TO_MaterialType_TF = UITextField()
        TO_MaterialType_TF.frame = CGRect(x: From_MaterialType_TF.frame.maxX + 1, y: From_MaterialTypeLBL.frame.maxY, width: courierImageView.frame.width / 2, height: (2 * y))
        TO_MaterialType_TF.text = "20 Dec 2018 10.00 AM"
        TO_MaterialType_TF.textColor = UIColor.white
        TO_MaterialType_TF.textAlignment = .center
        TO_MaterialType_TF.font = UIFont(name: "Avenir Next", size: 12)
        TO_MaterialType_TF.adjustsFontSizeToFitWidth = true
        TO_MaterialType_TF.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(TO_MaterialType_TF)
        
        let ApproveButton = UIButton()
       ApproveButton.frame = CGRect(x: (8 * x), y: From_MaterialType_TF.frame.maxY + y, width: (10 * x), height: (2 * y))
         ApproveButton.backgroundColor = UIColor.black
        ApproveButton.setTitle("Approve", for: .normal)
        ApproveButton.setTitleColor(UIColor.white, for: .normal)
        ApproveButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 14)!
        ApproveButton.layer.borderColor = UIColor.lightGray.cgColor
        ApproveButton.layer.borderWidth = 1.0
        ApproveButton.layer.cornerRadius = 10
        ApproveButton.addTarget(self, action: #selector(self.ApproveButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(ApproveButton)
        
        let RejectButton = UIButton()
       RejectButton.frame = CGRect(x: ApproveButton.frame.maxX + (2 * x), y: From_MaterialType_TF.frame.maxY + y, width: (10 * x), height: (2 * y))
         RejectButton.backgroundColor = UIColor.black
        RejectButton.setTitle("Reject", for: .normal)
        RejectButton.setTitleColor(UIColor.white, for: .normal)
        RejectButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 14)!
        RejectButton.layer.borderColor = UIColor.lightGray.cgColor
        RejectButton.layer.borderWidth = 1.0
        RejectButton.layer.cornerRadius = 10
        RejectButton.addTarget(self, action: #selector(self.RejectButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(RejectButton)
        
        
        let SaveButton = UIButton()
        SaveButton.frame = CGRect(x: TailorImageView.frame.width - (5 * x), y: RejectButton.frame.minY + (2.5 * y) , width: (8 * x), height: (2 * y))
        SaveButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        SaveButton.setTitle("Save", for: .normal)
        SaveButton.setTitleColor(UIColor.white, for: .normal)
        SaveButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 14)!
  
        SaveButton.addTarget(self, action: #selector(self.SaveButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(SaveButton)
    }

    
    @objc func otpBackButtonAction(sender : UIButton)
    {
     self.navigationController?.popViewController(animated: true)
    }
    
    @objc func statusButtonAction(sender : UIButton)
    {
        print("status Page..")
        AppointmentStatusContent()
    }
    @objc func ApproveButtonAction(sender : UIButton)
    {
        print("Approve Status Page..")
    }
    @objc func RejectButtonAction(sender : UIButton)
    {
        print("Reject Status Page..")
        
        RejectButtonContent()
    }
    @objc func SaveButtonAction(sender : UIButton)
    {
        print("Save Action..")
    }
    
    func AppointmentStatusContent()
    {
        AppointmentSelectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        AppointmentSelectionView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        view.addSubview(AppointmentSelectionView)
        
        let Rescheduleview = UIView()
        Rescheduleview.frame = CGRect(x: 0, y: (AppointmentSelectionView.frame.height / 2 ) - (5 * y) , width: view.frame.width, height: (12 * y))
        Rescheduleview.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        AppointmentSelectionView.addSubview(Rescheduleview)
        
        let reschedule_LBL = UILabel()
        reschedule_LBL.frame = CGRect(x: x, y: Rescheduleview.frame.minY, width: Rescheduleview.frame.width - x, height: (8 * y))
        //reschedule_LBL.backgroundColor = UIColor.gray
        reschedule_LBL.text = "The Appointment for your time is not available, please reschedule your date and time for your appointment"
        reschedule_LBL.textColor = UIColor.white
        reschedule_LBL.textAlignment = .left
        reschedule_LBL.lineBreakMode = .byWordWrapping
        reschedule_LBL.numberOfLines = 3
        reschedule_LBL.font = UIFont(name: "Avenir Next", size: 1.5 * x)
        AppointmentSelectionView.addSubview(reschedule_LBL)
      
        let rescheduleButton = UIButton()
        rescheduleButton.frame = CGRect(x: x, y: reschedule_LBL.frame.maxY + y , width: (15 * x), height: (2 * y))
        rescheduleButton.backgroundColor = UIColor.blue
        rescheduleButton.setTitle("Click Here to Reschedule", for: .normal)
        rescheduleButton.setTitleColor(UIColor.white, for: .normal)
        rescheduleButton.layer.borderColor = UIColor.lightGray.cgColor
        rescheduleButton.layer.borderWidth = 1.0
        rescheduleButton.layer.cornerRadius = 10
        rescheduleButton.addTarget(self, action: #selector(self.RescheduleButtonAction(sender:)), for: .touchUpInside)
        rescheduleButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.2 * x)!
        AppointmentSelectionView.addSubview(rescheduleButton)
        
        let okButton = UIButton()
        okButton.frame = CGRect(x: rescheduleButton.frame.maxX + (8 * x), y: reschedule_LBL.frame.maxY + y, width: (10 * x), height: (2 * y))
        okButton.backgroundColor = UIColor.blue
        okButton.setTitle("Ok", for: .normal)
        okButton.setTitleColor(UIColor.white, for: .normal)
        okButton.layer.borderColor = UIColor.lightGray.cgColor
        okButton.layer.borderWidth = 1.0
        okButton.layer.cornerRadius = 10
        okButton.addTarget(self, action: #selector(self.RescheduleButtonAction(sender:)), for: .touchUpInside)
        okButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.2 * x)!
        AppointmentSelectionView.addSubview(okButton)
      
    }
    
    func RejectButtonContent()
    {
        RejectButtonView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        RejectButtonView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        view.addSubview(RejectButtonView)
        
        let RejectView = UIView()
        RejectView.frame = CGRect(x: 0, y: (RejectButtonView.frame.height / 2 ) - (5 * y) , width: view.frame.width, height: (10 * y))
        RejectView.backgroundColor = UIColor.white
        RejectButtonView.addSubview(RejectView)
        
        let rejectReason_TF = UITextField()
        rejectReason_TF.frame = CGRect(x: x, y: RejectView.frame.minY, width: RejectView.frame.width - (2 * x), height: (6 * y))
       // rejectReason_TF.backgroundColor = UIColor.gray
        rejectReason_TF.placeholder = "please Mention your reason for rejecting.."
        //rejectReason_TF.text = "The Appointment for your time is not available, please reschedule your date and time for your appointment"
       rejectReason_TF.textColor = UIColor.black
        rejectReason_TF.textAlignment = .left
        rejectReason_TF.contentVerticalAlignment = .top
        rejectReason_TF.font = UIFont(name: "Avenir Next", size: 1.5 * x)
        RejectButtonView.addSubview(rejectReason_TF)
        
        let CancelButton = UIButton()
        CancelButton.frame = CGRect(x: (2 * x), y: rejectReason_TF.frame.maxY + y , width: (10 * x), height: (2 * y))
        CancelButton.backgroundColor = UIColor.lightGray
        CancelButton.setTitle("Cancel", for: .normal)
        CancelButton.setTitleColor(UIColor.white, for: .normal)
        CancelButton.layer.borderColor = UIColor.lightGray.cgColor
        CancelButton.layer.borderWidth = 1.0
        CancelButton.layer.cornerRadius = 10
        CancelButton.addTarget(self, action: #selector(self.CancelButtonAction(sender:)), for: .touchUpInside)
        CancelButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.2 * x)!
        RejectButtonView.addSubview(CancelButton)
        
        let saveButton = UIButton()
        saveButton.frame = CGRect(x: CancelButton.frame.maxX + (12 * x), y: rejectReason_TF.frame.maxY + y, width: (10 * x), height: (2 * y))
        saveButton.backgroundColor = UIColor.blue
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.layer.borderColor = UIColor.lightGray.cgColor
        saveButton.layer.borderWidth = 1.0
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(self.SaveRejectButtonAction(sender:)), for: .touchUpInside)
        saveButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.2 * x)!
        RejectButtonView.addSubview(saveButton)
        
    }
    
    @objc func RescheduleButtonAction(sender : UIButton)
    {
        AppointmentSelectionView.removeFromSuperview()
    }
    
    @objc func CancelButtonAction(sender : UIButton)
    {
        RejectButtonView.removeFromSuperview()
    }
    
    @objc func SaveRejectButtonAction(sender : UIButton)
    {
        //AppointmentSelectionView.removeFromSuperview()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let loginScreen = HomeViewController()
        let navigationScreen = UINavigationController(rootViewController: loginScreen)
        navigationScreen.isNavigationBarHidden = true
        window?.rootViewController = navigationScreen
        window?.makeKeyAndVisible()
    }
}
