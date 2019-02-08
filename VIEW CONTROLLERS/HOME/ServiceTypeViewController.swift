//
//  ServiceTypeViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 08/01/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class ServiceTypeViewController: CommonViewController, ServerAPIDelegate
{
    
    let serviceCall = ServerAPI()
    
    let serviceTypeView = UIView()
    
    var deliveryTypeImageArray = NSArray()
    var deliveryTypeEnglishNameArray = NSArray()
    var deliveryTypeArabicNameArray = NSArray()
    var deliveryTypeIdArray = NSArray()
    var deliveryTypeIconArray = NSArray()
    
    override func viewDidLoad()
    {
        serviceCall.API_ServiceRequest(delegate: self)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String) {
        print("ERROR", errorMessage)
    }
    
    func API_CALLBACK_ServiceRequest(service: NSDictionary) {
        print("SERVICE REQUEST", service)
        
        let ResponseMsg = service.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = service.object(forKey: "Result") as! NSArray
            
            deliveryTypeImageArray = Result.value(forKey: "DeliveryImage") as! NSArray
            
            deliveryTypeEnglishNameArray = Result.value(forKey: "DeliveryTypeInEnglish") as! NSArray
            
            deliveryTypeArabicNameArray = Result.value(forKey: "DeliveryTypeInArabic") as! NSArray
            
            deliveryTypeIdArray = Result.value(forKey: "Id") as! NSArray
            
            deliveryTypeIconArray = Result.value(forKey: "HeaderImage") as! NSArray
            
            serviceTypeContent()
        }
    }
    
    func serviceTypeContent()
    {
        self.stopActivity()
        serviceTypeView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        serviceTypeView.backgroundColor = UIColor.white
        //        view.addSubview(serviceTypeView)
        
        let orderTypeNavigationBar = UIView()
        orderTypeNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        orderTypeNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(orderTypeNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 3
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        orderTypeNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: orderTypeNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "SERVICE TYPE"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        orderTypeNavigationBar.addSubview(navigationTitle)
        
        // Urgent...
        let directDeliveryIcon = UIImageView()
        directDeliveryIcon.frame = CGRect(x: (3 * x), y: orderTypeNavigationBar.frame.maxY + (2 * y), width: (2 * x), height: (2 * y))
        if let imageName = deliveryTypeIconArray[0] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/ServiceType/\(imageName)"
            let apiurl = URL(string: api)
            directDeliveryIcon.dowloadFromServer(url: apiurl!)
        }
        view.addSubview(directDeliveryIcon)
        
        let directDeliveryLabel = UILabel()
        directDeliveryLabel.frame = CGRect(x: directDeliveryIcon.frame.maxX + x, y: orderTypeNavigationBar.frame.maxY + (2 * y), width: view.frame.width, height: (2 * y))
        directDeliveryLabel.text = (deliveryTypeEnglishNameArray[0] as! String).uppercased()
        directDeliveryLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        directDeliveryLabel.textAlignment = .left
        directDeliveryLabel.font = UIFont(name: "AvenirNext-Regular", size: 12)
        view.addSubview(directDeliveryLabel)
        
        let directDeliveryUnderline = UILabel()
        directDeliveryUnderline.frame = CGRect(x: (3 * x), y: directDeliveryLabel.frame.maxY + (y / 2), width: view.frame.width - (6 * x), height: 0.5)
        directDeliveryUnderline.backgroundColor = UIColor.lightGray
        view.addSubview(directDeliveryUnderline)
        
        let directDeliveryButton = UIButton()
        directDeliveryButton.frame = CGRect(x: (3 * x), y: directDeliveryUnderline.frame.maxY + y, width: view.frame.width - (6 * x), height: (12 * y))
        directDeliveryButton.backgroundColor = UIColor.lightGray
        if let imageName = deliveryTypeImageArray[0] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/ServiceType/\(imageName)"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: directDeliveryButton.frame.width, height: directDeliveryButton.frame.height)
            dummyImageView.dowloadFromServer(url: apiurl!)
            directDeliveryButton.addSubview(dummyImageView)
        }
        directDeliveryLabel.tag = deliveryTypeIdArray[0] as! Int
        directDeliveryButton.addTarget(self, action: #selector(self.UrgentButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(directDeliveryButton)
        
        // Appointment..
        let courierDeliveryIcon = UIImageView()
        courierDeliveryIcon.frame = CGRect(x: (3 * x), y: directDeliveryButton.frame.maxY + (2 * y), width: (2 * x), height: (2 * y))
        if let imageName = deliveryTypeIconArray[1] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/ServiceType/\(imageName)"
            let apiurl = URL(string: api)
            print("API FOR 2", apiurl)
            courierDeliveryIcon.dowloadFromServer(url: apiurl!)
        }
        view.addSubview(courierDeliveryIcon)
        
        let couriertDeliveryLabel = UILabel()
        couriertDeliveryLabel.frame = CGRect(x: courierDeliveryIcon.frame.maxX + x, y: directDeliveryButton.frame.maxY + (2 * y), width: view.frame.width - (5 * x), height: (2 * y))
        couriertDeliveryLabel.text = (deliveryTypeEnglishNameArray[1] as! String).uppercased()
        couriertDeliveryLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        couriertDeliveryLabel.textAlignment = .left
        couriertDeliveryLabel.font = UIFont(name: "AvenirNext-Regular", size: 12)
        couriertDeliveryLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(couriertDeliveryLabel)
        
        let courierDeliveryUnderline = UILabel()
        courierDeliveryUnderline.frame = CGRect(x: (3 * x), y: couriertDeliveryLabel.frame.maxY + (y / 2), width: view.frame.width - (6 * x), height: 0.5)
        courierDeliveryUnderline.backgroundColor = UIColor.lightGray
        view.addSubview(courierDeliveryUnderline)
        
        let courierDeliveryButton = UIButton()
        courierDeliveryButton.frame = CGRect(x: (3 * x), y: courierDeliveryUnderline.frame.maxY + y, width: view.frame.width - (6 * x), height: (12 * y))
        courierDeliveryButton.backgroundColor = UIColor.lightGray
        if let imageName = deliveryTypeImageArray[1] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/ServiceType/\(imageName)"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: courierDeliveryButton.frame.width, height: courierDeliveryButton.frame.height)
            dummyImageView.dowloadFromServer(url: apiurl!)
            courierDeliveryButton.addSubview(dummyImageView)
        }
        courierDeliveryButton.tag = deliveryTypeIdArray[1] as! Int
        courierDeliveryButton.addTarget(self, action: #selector(self.AppointmentButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(courierDeliveryButton)
        
        // Normal...
        let companyIcon = UIImageView()
        companyIcon.frame = CGRect(x: (3 * x), y: courierDeliveryButton.frame.maxY + (2 * y), width: (2 * x), height: (2 * y))
        if let imageName = deliveryTypeIconArray[2] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/ServiceType/\(imageName)"
            let apiurl = URL(string: api)
            companyIcon.dowloadFromServer(url: apiurl!)
        }
        view.addSubview(companyIcon)
        
        let companyLabel = UILabel()
        companyLabel.frame = CGRect(x: companyIcon.frame.maxX + x, y: courierDeliveryButton.frame.maxY + (2 * y), width: view.frame.width, height: (2 * y))
        companyLabel.text = (deliveryTypeEnglishNameArray[2] as! String).uppercased()
        companyLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        companyLabel.textAlignment = .left
        companyLabel.font = UIFont(name: "AvenirNext-Regular", size: 12)
        view.addSubview(companyLabel)
        
        let companyUnderline = UILabel()
        companyUnderline.frame = CGRect(x: (3 * x), y: companyLabel.frame.maxY + (y / 2), width: view.frame.width - (6 * x), height: 0.5)
        companyUnderline.backgroundColor = UIColor.lightGray
        view.addSubview(companyUnderline)
        
        let companyButton = UIButton()
        companyButton.frame = CGRect(x: (3 * x), y: companyUnderline.frame.maxY + y, width: view.frame.width - (6 * x), height: (12 * y))
        companyButton.backgroundColor = UIColor.lightGray
        if let imageName = deliveryTypeImageArray[2] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/ServiceType/\(imageName)"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: companyButton.frame.width, height: companyButton.frame.height)
            dummyImageView.dowloadFromServer(url: apiurl!)
            companyButton.addSubview(dummyImageView)
        }
        companyButton.tag = deliveryTypeIdArray[2] as! Int
        companyButton.addTarget(self, action: #selector(self.NormalButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(companyButton)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func UrgentButtonAction(sender : UIButton)
    {
        UserDefaults.standard.set(0, forKey: "serviceType")
        let tailorScreen = TailorListViewController()
        self.navigationController?.pushViewController(tailorScreen, animated: true)
    }
    
    @objc func AppointmentButtonAction(sender : UIButton)
    {
        UserDefaults.standard.set(1, forKey: "serviceType")
        let tailorScreen = TailorListViewController()
        self.navigationController?.pushViewController(tailorScreen, animated: true)
    }
    
    @objc func NormalButtonAction(sender : UIButton)
    {
        UserDefaults.standard.set(2, forKey: "serviceType")
        let tailorScreen = TailorListViewController()
        self.navigationController?.pushViewController(tailorScreen, animated: true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
