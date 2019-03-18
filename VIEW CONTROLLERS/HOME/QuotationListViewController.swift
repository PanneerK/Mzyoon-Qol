//
//  QuotationListViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 26/12/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class QuotationListViewController: CommonViewController,ServerAPIDelegate
{
    
    
   let serviceCall = ServerAPI()
    
    //SCREEN PARAMETERS
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()
    let backDrop = UIView()

    let tailorListScrollView = UIScrollView()
   // var selectedTailorListArray = [Int]()
    var OrderId:Int!
    var TailorId:Int!
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    var OrderIdArray = NSArray()
    var IdArray = NSArray()
    var TailorIdArray = NSArray()
    var TailorNameArray = NSArray()
    var ShopImageArray = NSArray()
    var ShopNameArray = NSArray()
    var StichTimeArray = NSArray()
    var TotalAmountArray = NSArray()
    
    let emptyLabel = UILabel()
    
    var applicationDelegate = AppDelegate()

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

         navigationBar.isHidden = true
        
        // Do any additional setup after loading the view.
        
         selectedButton(tag: 1)

          print("request Order ID :",OrderId)
     //   UserDefaults.standard.set(OrderId, forKey: "OrderID")
        
        
         //  self.ServiceCall.API_GetQuotationList(OrderId: 2, delegate: self)
        
       // quotationListContent()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        let navigationArray = self.navigationController?.viewControllers
        print("viewControllers Aray:",navigationArray!)
        
        print("request Order ID :",OrderId)
        UserDefaults.standard.set(OrderId, forKey: "OrderID")
        
        self.serviceCall.API_GetQuotationList(OrderId: OrderId, delegate: self)
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        // ErrorStr = "Default Error"
        PageNumStr = "QuotationListViewController"
        //  MethodName = "do"
        
        print("UUID", UIDevice.current.identifierForVendor?.uuidString as Any)
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
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
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
         print("Quotation List : ", errorMessage)
        stopActivity()
        applicationDelegate.exitContents()
    }
    
    func API_CALLBACK_GetQuotationList(quotationList: NSDictionary)
    {
        let ResponseMsg = quotationList.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = quotationList.object(forKey: "Result") as! NSDictionary
            print("Result:", Result)
            
           let QuotationList = Result.object(forKey: "QuotationList") as! NSArray
             // print("QuotationList:",QuotationList)
            if QuotationList.count == 0 || QuotationList == nil
            {
                
                emptyLabel.frame = CGRect(x: (4 * x), y: ((view.frame.height - (3 * y)) / 2), width: view.frame.width - (8 * x), height: (6 * y))
                emptyLabel.text = "Tailors Yet to Accept Request.,Please Come Back After Some time..!"
                emptyLabel.textColor = UIColor.black
                emptyLabel.textAlignment = .center
                emptyLabel.font = UIFont(name: "Avenir Next", size: (1.5 * x))
                emptyLabel.font = emptyLabel.font.withSize(1.5 * x)
                emptyLabel.textAlignment = .left
                emptyLabel.lineBreakMode = .byWordWrapping
                emptyLabel.numberOfLines = 4
                view.addSubview(emptyLabel)
            }
            
            OrderIdArray = QuotationList.value(forKey: "OrderId") as! NSArray
          //  print("OrderIdArray", OrderIdArray)
            
            IdArray = QuotationList.value(forKey: "Id") as! NSArray
           // print("IdArray", QuotationList)
            
            TailorIdArray = QuotationList.value(forKey: "TailorId") as! NSArray
            // print("TailorIdArray", TailorIdArray)
            
            TailorNameArray = QuotationList.value(forKey: "TailorNameInEnglish") as! NSArray
           // print("TailorNameArray", TailorNameArray)
            
            ShopImageArray = QuotationList.value(forKey: "ShopOwnerImageURL") as! NSArray
          //  print("ShopImageArray ", ShopImageArray)
            
            ShopNameArray = QuotationList.value(forKey: "ShopNameInEnglish") as! NSArray
           // print("ShopNameArray", ShopNameArray)
            
            StichTimeArray = QuotationList.value(forKey: "StichingTime") as! NSArray
            //print("StichTimeArray", StichTimeArray)
            
            TotalAmountArray = QuotationList.value(forKey: "TotalAmount") as! NSArray
           // print("TotalAmountArray", TotalAmountArray)
            
            self.quotationListContent()
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = quotationList.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetQuotationList"
            ErrorStr = Result
            DeviceError()
        }
        
    }
    
    func changeViewToArabicInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.text = "قائمة الاقتباس"
        
        backDrop.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.text = "QUOTATION LIST"
        
        backDrop.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
  
    
    func quotationListContent()
    {
        self.stopActivity()
        
        //let quotationListNavigationBar = UIView()
        selfScreenNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        selfScreenNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(selfScreenNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 4
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        selfScreenNavigationBar.addSubview(backButton)
        
        selfScreenNavigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: selfScreenNavigationBar.frame.width, height: (3 * y))
        selfScreenNavigationTitle.text = "QUOTATION LIST"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
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
        
        TailorListView() 
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func TailorListView()
    {
        backDrop.frame = CGRect(x: (3 * x), y: selfScreenNavigationBar.frame.maxY, width: view.frame.width - (6 * x), height: view.frame.height - (navigationBar.frame.height + tabBar.frame.height))
        backDrop.backgroundColor = UIColor.clear
        view.addSubview(backDrop)
        
        let sortButton = UIButton()
        sortButton.frame = CGRect(x: backDrop.frame.width - (10 * x), y: y, width: (10 * x), height: (2 * y))
        sortButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        sortButton.setTitle("SORT", for: .normal)
        sortButton.setTitleColor(UIColor.white, for: .normal)
        sortButton.tag = 0
        //        sortButton.addTarget(self, action: #selector(self.selectionViewButtonAction(sender:)), for: .touchUpInside)
//        backDrop.addSubview(sortButton)
        
        tailorListScrollView.frame = CGRect(x: 0, y: sortButton.frame.maxY + y, width: backDrop.frame.width, height: (48 * y))
        backDrop.addSubview(tailorListScrollView)
        
        tailorListScrollView.contentSize.height = (12 * y * CGFloat(IdArray.count))
        
        for views in tailorListScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        var y1:CGFloat = 0
        
        for i in 0..<IdArray.count
        {
            let tailorViewButton = UIButton()
            tailorViewButton.frame = CGRect(x: 0, y: y1, width: tailorListScrollView.frame.width, height: (8 * y))
            tailorViewButton.backgroundColor = UIColor.white
            tailorListScrollView.addSubview(tailorViewButton)
            
            let tailorImageView = UIImageView()
            tailorImageView.frame = CGRect(x: 0, y: 0, width: (8 * x), height: tailorViewButton.frame.height)
            tailorImageView.backgroundColor = UIColor.white
            //UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            tailorImageView.layer.borderWidth = 1.0
            tailorImageView.layer.borderColor = UIColor.lightGray.cgColor
          //  tailorImageView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
           // tailorImageView.setImage(UIImage(named: "men"), for: .normal)
         
          
            if let imageName = ShopImageArray[i] as? String
            {
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/Tailorimages/\(imageName)"
                print("SMALL ICON", api)
                let apiurl = URL(string: api)
                
                let dummyImageView = UIImageView()
                dummyImageView.frame = CGRect(x: 0, y: 0, width: tailorImageView.frame.width, height: tailorImageView.frame.height)
                if apiurl != nil
                {
                    dummyImageView.dowloadFromServer(url: apiurl!)
                }
                dummyImageView.tag = -1
                tailorImageView.addSubview(dummyImageView)
            }
             tailorViewButton.addSubview(tailorImageView)
            
          /*
            tailorImageButton.tag = i
            tailorImageButton.addTarget(self, action: #selector(self.tailorSelectionButtonAction(sender:)), for: .touchUpInside)
            tailorView.addSubview(tailorImageButton)
          */
            
            let TailorResponseID : Int = IdArray[i] as! Int
            print("TailorResponseID:","\(TailorResponseID)")
            tailorViewButton.tag = IdArray[i] as! Int
            
            TailorId = TailorIdArray[i] as? Int
            print("TailorId:","\(String(describing: TailorId))")
            
            let Name_Icon = UIImageView()
            Name_Icon.frame = CGRect(x: tailorImageView.frame.maxX + x, y: y/2, width: x, height: y)
            Name_Icon.image = UIImage(named: "TailorName")
            tailorViewButton.addSubview(Name_Icon)
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: Name_Icon.frame.maxX + x, y: 0, width: (5 * x), height: (2 * y))
            nameLabel.text = "Name : "
            nameLabel.textColor = UIColor.blue
            nameLabel.textAlignment = .left
            nameLabel.font =  UIFont(name: "Avenir Next", size: 1.2 * x)  //nameLabel.font.withSize(1.2 * x)
            tailorViewButton.addSubview(nameLabel)
            
            let tailorName = UILabel()
            tailorName.frame = CGRect(x: nameLabel.frame.maxX, y: 0, width: tailorViewButton.frame.width / 2, height: (2 * y))
            tailorName.text = TailorNameArray[i] as? String
            tailorName.textColor = UIColor.black
            tailorName.textAlignment = .left
            tailorName.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            tailorViewButton.addSubview(tailorName)
            
            //
            let ShopName_Icon = UIImageView()
            ShopName_Icon.frame = CGRect(x: tailorImageView.frame.maxX + x, y: Name_Icon.frame.maxY + y, width: x, height: y)
            ShopName_Icon.image = UIImage(named: "ShopName")
            tailorViewButton.addSubview(ShopName_Icon)
            
            let shopLabel = UILabel()
            shopLabel.frame = CGRect(x: ShopName_Icon.frame.maxX + x, y: nameLabel.frame.maxY, width: (8 * x), height: (2 * y))
            shopLabel.text = "Shop Name : "
            shopLabel.textColor = UIColor.blue
            shopLabel.textAlignment = .left
            shopLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            tailorViewButton.addSubview(shopLabel)
            
            let shopName = UILabel()
            shopName.frame = CGRect(x: shopLabel.frame.maxX, y: nameLabel.frame.maxY, width: tailorViewButton.frame.width / 2.5, height: (2 * y))
            shopName.text =  ShopNameArray[i] as? String
            shopName.textColor = UIColor.black
            shopName.textAlignment = .left
            shopName.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            shopName.adjustsFontSizeToFitWidth = true
            tailorViewButton.addSubview(shopName)
            
            //
            let Price_Icon = UIImageView()
            Price_Icon.frame = CGRect(x: tailorImageView.frame.maxX + x, y: ShopName_Icon.frame.maxY + y, width: x, height: y)
            Price_Icon.image = UIImage(named: "ProductName")
            tailorViewButton.addSubview(Price_Icon)
            
            let ordersLabel = UILabel()
            ordersLabel.frame = CGRect(x: Price_Icon.frame.maxX + x, y: shopLabel.frame.maxY, width: (5 * x), height: (2 * y))
            ordersLabel.text = "Price : "
            ordersLabel.textColor = UIColor.blue
            ordersLabel.textAlignment = .left
            ordersLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            tailorViewButton.addSubview(ordersLabel)
            
            let ordersCountLabel = UILabel()
            ordersCountLabel.frame = CGRect(x: ordersLabel.frame.maxX, y: shopLabel.frame.maxY, width: tailorViewButton.frame.width / 2.5, height: (2 * y))
            let orderPrice : Int = TotalAmountArray[i] as! Int
            ordersCountLabel.text =  "\(orderPrice)"
            ordersCountLabel.textColor = UIColor.black
            ordersCountLabel.textAlignment = .left
            ordersCountLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            ordersCountLabel.adjustsFontSizeToFitWidth = true
            tailorViewButton.addSubview(ordersCountLabel)
            
            //
            let Days_Icon = UIImageView()
            Days_Icon.frame = CGRect(x: tailorImageView.frame.maxX + x, y: Price_Icon.frame.maxY + y, width: x, height: y)
            Days_Icon.image = UIImage(named: "OrderDate")
            tailorViewButton.addSubview(Days_Icon)
            
            let ratingLabel = UILabel()
            ratingLabel.frame = CGRect(x: Days_Icon.frame.maxX + x, y: ordersLabel.frame.maxY, width: (8 * x), height: (2 * y))
            ratingLabel.text = "No Of Days : "
            ratingLabel.textColor = UIColor.blue
            ratingLabel.textAlignment = .left
            ratingLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            tailorViewButton.addSubview(ratingLabel)
            
            let ratingCountLabel = UILabel()
            ratingCountLabel.frame = CGRect(x: ratingLabel.frame.maxX, y: ordersLabel.frame.maxY, width: tailorViewButton.frame.width / 2.5, height: (2 * y))
            ratingCountLabel.text = StichTimeArray[i] as? String
            ratingCountLabel.textColor = UIColor.black
            ratingCountLabel.textAlignment = .left
            ratingCountLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            ratingCountLabel.adjustsFontSizeToFitWidth = true
            tailorViewButton.addSubview(ratingCountLabel)
            
            tailorViewButton.addTarget(self, action: #selector(self.confirmSelectionButtonAction(sender:)), for: .touchUpInside)
            
            y1 = tailorViewButton.frame.maxY + y
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    tailorImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    
                    nameLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    nameLabel.text = "Name : "
                    nameLabel.textAlignment = .left
                    
                    tailorName.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    tailorName.textAlignment = .left
                    
                    shopLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    shopLabel.text = "Shop Name : "
                    shopLabel.textAlignment = .left
                    
                    shopName.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    shopName.textAlignment = .left
                    
                    ordersLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    ordersLabel.text = "Price : "
                    ordersLabel.textAlignment = .left
                    
                    ordersCountLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    ordersCountLabel.textAlignment = .left
                    
                    ratingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    ratingLabel.text = "No. of Days : "
                    ratingLabel.textAlignment = .left
                    
                    ratingCountLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    ratingCountLabel.textAlignment = .left
                }
                else if language == "ar"
                {
                    tailorImageView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    
                    nameLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    nameLabel.text = "الاسم : "
                    nameLabel.textAlignment = .right
                    
                    tailorName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    tailorName.textAlignment = .right
                    
                    shopLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    shopLabel.text = "اسم المحل : "
                    shopLabel.textAlignment = .right
                    
                    shopName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    shopName.textAlignment = .right
                    
                    ordersLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    ordersLabel.text = "السعر : "
                    ordersLabel.textAlignment = .right
                    
                    ordersCountLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    ordersCountLabel.textAlignment = .right
                    
                    ratingLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    ratingLabel.text = "عدد الايام : "
                    ratingLabel.textAlignment = .right
                    
                    ratingCountLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    ratingCountLabel.textAlignment = .right
                }
            }
            else
            {
                tailorImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                nameLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                nameLabel.text = "Name : "
                nameLabel.textAlignment = .left
                
                tailorName.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                tailorName.textAlignment = .left
                
                shopLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                shopLabel.text = "Shop Name : "
                shopLabel.textAlignment = .left
                
                shopName.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                shopName.textAlignment = .left
                
                ordersLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                ordersLabel.text = "Price : "
                ordersLabel.textAlignment = .left
                
                ordersCountLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                ordersCountLabel.textAlignment = .left
                
                ratingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                ratingLabel.text = "No. of Days : "
                ratingLabel.textAlignment = .left
                
                ratingCountLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                ratingCountLabel.textAlignment = .left
            }
        }
        
      /*
        let confirmSelectionButton = UIButton()
        confirmSelectionButton.frame = CGRect(x: ((backDrop.frame.width - (17 * x)) / 2), y: tailorListScrollView.frame.maxY + y, width: (17 * x), height: (3 * y))
        confirmSelectionButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        confirmSelectionButton.setTitle("Confirm Selection", for: .normal)
        confirmSelectionButton.addTarget(self, action: #selector(self.confirmSelectionButtonAction(sender:)), for: .touchUpInside)
        backDrop.addSubview(confirmSelectionButton)
     */
        
    }
    
 
    @objc func confirmSelectionButtonAction(sender : UIButton)
    {
        let orderApproveScreen = OrderApprovalViewController()
        orderApproveScreen.TailorResponseID = sender.tag
        orderApproveScreen.TailorID = TailorId
        self.navigationController?.pushViewController(orderApproveScreen, animated: true)
    }
    
 
}
