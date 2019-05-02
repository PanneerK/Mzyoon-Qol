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
    
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()
    let selfScreenContents = UIView()
    
    let directDeliveryIcon = UIImageView()
    let directDeliveryLabel = UILabel()
    let directDeliveryButton = UIButton()
    let courierDeliveryIcon = UIImageView()
    let courierDeliveryLabel = UILabel()
    let courierDeliveryButton = UIButton()
    let companyIcon = UIImageView()
    let companyLabel = UILabel()
    let companyButton = UIButton()

    var applicationDelegate = AppDelegate()

    
    override func viewDidLoad()
    {
        navigationBar.isHidden = true
        selectedButton(tag: 0)
        serviceCall.API_ServiceRequest(delegate: self)

        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        serviceCall.API_ServiceRequest(delegate: self)
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                slideMenu()
                changeViewToEnglish()
            }
            else if language == "ar"
            {
                slideMenuRight()
                changeViewToArabic()
            }
        }
        else
        {
            slideMenu()
            changeViewToEnglish()
        }
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("ERROR", errorMessage)
        stopActivity()
        applicationDelegate.exitContents()
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
        
        selfScreenNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        selfScreenNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(selfScreenNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 3
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        selfScreenNavigationBar.addSubview(backButton)
        
        selfScreenNavigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: selfScreenNavigationBar.frame.width, height: (3 * y))
        selfScreenNavigationTitle.text = "SERVICE TYPE"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationTitle.font = selfScreenNavigationTitle.font.withSize(2 * x)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        selfScreenContents.frame = CGRect(x: x, y: pageBar.frame.maxY, width: view.frame.width - (2 * x), height: view.frame.height - ((5 * y) + selfScreenNavigationBar.frame.maxY + pageBar.frame.height))
        selfScreenContents.backgroundColor = UIColor.clear
        view.addSubview(selfScreenContents)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                pageBar.image = UIImage(named: "ServiceBar")
            }
            else if language == "ar"
            {
                pageBar.image = UIImage(named: "serviceArabicHintImage")
            }
        }
        else
        {
            pageBar.image = UIImage(named: "ServiceBar")
        }
        
        self.view.bringSubviewToFront(slideMenuButton)
        
        // Urgent...
        
        /*directDeliveryIcon.frame = CGRect(x: 0, y: y, width: (2 * x), height: (2 * y))
        if let imageName = deliveryTypeIconArray[0] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/ServiceType/\(imageName)"
            let apiurl = URL(string: api)
            directDeliveryIcon.dowloadFromServer(url: apiurl!)
        }
        selfScreenContents.addSubview(directDeliveryIcon)

        directDeliveryLabel.frame = CGRect(x: directDeliveryIcon.frame.maxX + x, y: y, width: view.frame.width, height: (2 * y))
        directDeliveryLabel.text = (deliveryTypeEnglishNameArray[0] as! String).uppercased()
        directDeliveryLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        directDeliveryLabel.textAlignment = .left
        directDeliveryLabel.font = UIFont(name: "AvenirNext-Regular", size: (1.5 * x))
        selfScreenContents.addSubview(directDeliveryLabel)
        
        let directDeliveryUnderline = UILabel()
        directDeliveryUnderline.frame = CGRect(x: 0, y: directDeliveryLabel.frame.maxY + (y / 2), width: selfScreenContents.frame.width, height: 0.5)
        directDeliveryUnderline.backgroundColor = UIColor.lightGray
        selfScreenContents.addSubview(directDeliveryUnderline)
        
        directDeliveryButton.frame = CGRect(x: 0, y: directDeliveryUnderline.frame.maxY + y, width: selfScreenContents.frame.width, height: (11 * y))
        directDeliveryButton.backgroundColor = UIColor.lightGray
        if let imageName = deliveryTypeImageArray[0] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/ServiceType/\(imageName)"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: directDeliveryButton.frame.width, height: directDeliveryButton.frame.height)
            dummyImageView.dowloadFromServer(url: apiurl!)
            dummyImageView.contentMode = .scaleToFill
            directDeliveryButton.addSubview(dummyImageView)
        }
        directDeliveryButton.tag = deliveryTypeIdArray[0] as! Int
        directDeliveryButton.addTarget(self, action: #selector(self.UrgentButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(directDeliveryButton)*/
        
        // Appointment..
        courierDeliveryIcon.frame = CGRect(x: 0, y: y, width: (2 * x), height: (2 * y))
        if let imageName = deliveryTypeIconArray[1] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/ServiceType/\(imageName)"
            let apiurl = URL(string: api)
            print("API FOR 2", apiurl)
            courierDeliveryIcon.dowloadFromServer(url: apiurl!)
        }
        selfScreenContents.addSubview(courierDeliveryIcon)
        
        courierDeliveryLabel.frame = CGRect(x: courierDeliveryIcon.frame.maxX + x, y: y, width: view.frame.width, height: (2 * y))
        courierDeliveryLabel.text = (deliveryTypeEnglishNameArray[1] as! String).uppercased()
        courierDeliveryLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        courierDeliveryLabel.textAlignment = .left
        courierDeliveryLabel.font = UIFont(name: "AvenirNext-Regular", size: (1.5 * x))
        courierDeliveryLabel.adjustsFontSizeToFitWidth = true
        selfScreenContents.addSubview(courierDeliveryLabel)
        
        let courierDeliveryUnderline = UILabel()
        courierDeliveryUnderline.frame = CGRect(x: 0, y: courierDeliveryLabel.frame.maxY + (y / 2), width: selfScreenContents.frame.width, height: 0.5)
        courierDeliveryUnderline.backgroundColor = UIColor.lightGray
        selfScreenContents.addSubview(courierDeliveryUnderline)
        
        courierDeliveryButton.frame = CGRect(x: 0, y: courierDeliveryUnderline.frame.maxY + y, width: selfScreenContents.frame.width, height: (11 * y))
        courierDeliveryButton.backgroundColor = UIColor.lightGray
        if let imageName = deliveryTypeImageArray[1] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/ServiceType/\(imageName)"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: courierDeliveryButton.frame.width, height: courierDeliveryButton.frame.height)
            dummyImageView.dowloadFromServer(url: apiurl!)
            dummyImageView.contentMode = .scaleToFill
            courierDeliveryButton.addSubview(dummyImageView)
        }
        courierDeliveryButton.tag = deliveryTypeIdArray[1] as! Int
        courierDeliveryButton.addTarget(self, action: #selector(self.AppointmentButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(courierDeliveryButton)
        
        // Normal...
        companyIcon.frame = CGRect(x: 0, y: courierDeliveryButton.frame.maxY + y, width: (2 * x), height: (2 * y))
        if let imageName = deliveryTypeIconArray[2] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/ServiceType/\(imageName)"
            let apiurl = URL(string: api)
            companyIcon.dowloadFromServer(url: apiurl!)
        }
        selfScreenContents.addSubview(companyIcon)
        
        companyLabel.frame = CGRect(x: companyIcon.frame.maxX + x, y: courierDeliveryButton.frame.maxY + y, width: view.frame.width, height: (2 * y))
        companyLabel.text = (deliveryTypeEnglishNameArray[2] as! String).uppercased()
        companyLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        companyLabel.textAlignment = .left
        companyLabel.font = UIFont(name: "AvenirNext-Regular", size: (1.5 * x))
        selfScreenContents.addSubview(companyLabel)
        
        let companyUnderline = UILabel()
        companyUnderline.frame = CGRect(x: 0, y: companyLabel.frame.maxY + (y / 2), width: selfScreenContents.frame.width, height: 0.5)
        companyUnderline.backgroundColor = UIColor.lightGray
        selfScreenContents.addSubview(companyUnderline)
        
        companyButton.frame = CGRect(x: 0, y: companyUnderline.frame.maxY + y, width: selfScreenContents.frame.width, height: (11 * y))
        companyButton.backgroundColor = UIColor.lightGray
        if let imageName = deliveryTypeImageArray[2] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/ServiceType/\(imageName)"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: companyButton.frame.width, height: companyButton.frame.height)
            dummyImageView.dowloadFromServer(url: apiurl!)
            dummyImageView.contentMode = .scaleToFill
            companyButton.addSubview(dummyImageView)
        }
        companyButton.tag = deliveryTypeIdArray[2] as! Int
        companyButton.addTarget(self, action: #selector(self.NormalButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(companyButton)
        
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
    
    func changeViewToArabicInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        selfScreenNavigationTitle.text = "نوع الخدمة"
        
        selfScreenContents.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        directDeliveryIcon.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        directDeliveryLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        directDeliveryButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        directDeliveryLabel.text = deliveryTypeArabicNameArray[0] as? String
        directDeliveryLabel.textAlignment = .right
        
        courierDeliveryIcon.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        courierDeliveryLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        courierDeliveryButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        courierDeliveryLabel.text = deliveryTypeArabicNameArray[1] as? String
        courierDeliveryLabel.textAlignment = .right
        
        companyIcon.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        companyLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        companyButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        companyLabel.text = deliveryTypeArabicNameArray[2] as? String
        companyLabel.textAlignment = .right
    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        selfScreenNavigationTitle.text = "SERVICE TYPE"

        selfScreenContents.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        directDeliveryIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        directDeliveryLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        directDeliveryButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        directDeliveryLabel.text = deliveryTypeEnglishNameArray[0] as? String
        directDeliveryLabel.textAlignment = .left
        
        courierDeliveryIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        courierDeliveryLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        courierDeliveryButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        courierDeliveryLabel.text = deliveryTypeEnglishNameArray[1] as? String
        courierDeliveryLabel.textAlignment = .left
        
        companyIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        companyLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        companyButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        companyLabel.text = deliveryTypeEnglishNameArray[2] as? String
        companyLabel.textAlignment = .left
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func UrgentButtonAction(sender : UIButton)
    {
        print("UrgentButtonAction", sender.tag, deliveryTypeIdArray[0])
        UserDefaults.standard.set(sender.tag, forKey: "serviceType")
        let tailorScreen = TailorTypeViewController()
        self.navigationController?.pushViewController(tailorScreen, animated: true)
    }
    
    @objc func AppointmentButtonAction(sender : UIButton)
    {
        print("AppointmentButtonAction", sender.tag)
        UserDefaults.standard.set(sender.tag, forKey: "serviceType")
        let tailorScreen = TailorTypeViewController()
        self.navigationController?.pushViewController(tailorScreen, animated: true)
    }
    
    @objc func NormalButtonAction(sender : UIButton)
    {
        print("NormalButtonAction", sender.tag)
        UserDefaults.standard.set(sender.tag, forKey: "serviceType")
        let tailorScreen = TailorTypeViewController()
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
