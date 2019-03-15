//
//  ListOfOrdersViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 28/12/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class ListOfOrdersViewController: CommonViewController,ServerAPIDelegate
{
    let serviceCall = ServerAPI()
    
    let DeliveredButton = UIButton()
    let PendingButton = UIButton()
    
    var BuyerId : Int!
    var TailorId : Int!
    
    let ListOfOrdersNavigationBar = UIView()
    
    let PendingScrollView = UIScrollView()
    let DeliveredScrollView = UIScrollView()
    
    let DeliveredViewBackDrop = UIView()
    let PendingViewBackDrop = UIView()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    // Pending Arrays..
    var PendImageArray = NSArray()
    var PendOrderDateArray = NSArray()
    var PendOrderIdArray = NSArray()
    var PendProdNameArray = NSArray()
    var PendShopNameEngArray = NSArray()
    var PendTailorNameEngArray = NSArray()
    
    // Delivered Arrays..
    var DelivImageArray = NSArray()
    var DelivOrderDateArray = NSArray()
    var DelivOrderIdArray = NSArray()
    var DelivProdNameArray = NSArray()
    var DelivShopNameEngArray = NSArray()
    var DelivTailorNameEngArray = NSArray()
    var DelivTailorIdArray = NSArray()
    
    let emptyLabel = UILabel()
    var OrderPendDate = String()
    var OrderDelvDate = String()
    
    var applicationDelegate = AppDelegate()

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
      //  self.tab3Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        navigationBar.isHidden = true
        selectedButton(tag: 2)
 
      //  ListOfOrdersContent()
        
      
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if let userId = UserDefaults.standard.value(forKey: "userId") as? String
        {
            self.serviceCall.API_ListOfOrdersPending(BuyerId: userId, delegate: self)
            self.serviceCall.API_ListOfOrdersDelivered(BuyerId: userId, delegate: self)
        }
        else if let userId = UserDefaults.standard.value(forKey: "userId") as? Int
        {
            self.serviceCall.API_ListOfOrdersPending(BuyerId: "\(userId)", delegate: self)
            self.serviceCall.API_ListOfOrdersDelivered(BuyerId: "\(userId)", delegate: self)
        }
    }
 
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        // ErrorStr = "Default Error"
        PageNumStr = "ListOfOrdersViewController"
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
    
    func API_CALLBACK_ListOfPendOrders(PendingOrdersList: NSDictionary)
    {
        let ResponseMsg = PendingOrdersList.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = PendingOrdersList.object(forKey: "Result") as! NSArray
            print("Pending Result:", Result)
            
            if Result == nil || Result.count == 0
            {
                emptyLabel.frame = CGRect(x: 0, y: ((PendingViewBackDrop.frame.height - (3 * y)) / 2), width: PendingViewBackDrop.frame.width, height: (3 * y))
                emptyLabel.text = "You Dont Have Pending Orders"
                emptyLabel.textColor = UIColor.black
                emptyLabel.textAlignment = .center
                emptyLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
                emptyLabel.font = emptyLabel.font.withSize(1.5 * x)
                view.addSubview(emptyLabel)
            }
            
            PendImageArray = Result.value(forKey: "Image") as! NSArray
             print("PendImageArray:",PendImageArray)
            
            PendOrderDateArray = Result.value(forKey: "OrderDate") as! NSArray
            print("PendOrderDateArray", PendOrderDateArray)
            
            PendOrderIdArray = Result.value(forKey: "OrderId") as! NSArray
            print("PendOrderIdArray", PendOrderIdArray)
            
            PendProdNameArray = Result.value(forKey: "Product_Name") as! NSArray
            print("PendProdNameArray", PendProdNameArray)
            
            PendShopNameEngArray = Result.value(forKey: "ShopNameInEnglish") as! NSArray
            print("PendShopNameEngArray ", PendShopNameEngArray)
            
            PendTailorNameEngArray = Result.value(forKey: "TailorNameInEnglish") as! NSArray
            print("PendTailorNameEngArray", PendTailorNameEngArray)
           
             ListOfOrdersContent()
            
        }
        else if ResponseMsg == "Failure"
        {
            
            let Result = PendingOrdersList.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "ListOfOrderPending"
            ErrorStr = Result
            DeviceError()
        }
      }
   
    func API_CALLBACK_ListOfDeliverOrders(DeliverOrdersList: NSDictionary)
    {
        let ResponseMsg = DeliverOrdersList.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = DeliverOrdersList.object(forKey: "Result") as! NSArray
            print("Delivered Result:", Result)
            
            if Result == nil || Result.count == 0
            {
                emptyLabel.frame = CGRect(x: 0, y: ((DeliveredViewBackDrop.frame.height - (3 * y)) / 2), width: DeliveredViewBackDrop.frame.width, height: (3 * y))
                emptyLabel.text = "You Dont Have Delivered orders"
                emptyLabel.textColor = UIColor.black
                emptyLabel.textAlignment = .center
                emptyLabel.font = UIFont(name: "Avenir Next", size: (1.5 * x))
                emptyLabel.font = emptyLabel.font.withSize(1.5 * x)
                DeliveredViewBackDrop.addSubview(emptyLabel)
            }
            
            DelivImageArray = Result.value(forKey: "Image") as! NSArray
            print("DelivImageArray:",DelivImageArray)
            
            DelivOrderDateArray = Result.value(forKey: "OrderDate") as! NSArray
            print("DelivOrderDateArray", DelivOrderDateArray)
            
            DelivOrderIdArray = Result.value(forKey: "OrderId") as! NSArray
            print("DelivOrderIdArray", DelivOrderIdArray)
            
            DelivProdNameArray = Result.value(forKey: "Product_Name") as! NSArray
            print("DelivProdNameArray", DelivProdNameArray)
            
            DelivShopNameEngArray = Result.value(forKey: "ShopNameInEnglish") as! NSArray
            print("DelivShopNameEngArray ", DelivShopNameEngArray)
            
            DelivTailorNameEngArray = Result.value(forKey: "TailorNameInEnglish") as! NSArray
            print("DelivTailorNameEngArray", DelivTailorNameEngArray)
            
            DelivTailorIdArray = Result.value(forKey: "TailorId") as! NSArray
            print("DelivTailorIdArray", DelivTailorIdArray)
            
            ListOfOrdersContent()
            
        }
        else if ResponseMsg == "Failure"
        {
            
            let Result = DeliverOrdersList.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "ListOfOrderDelivered"
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func changeViewToArabicInSelf()
    {
        self.navigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.navigationTitle.text = "LIST OF ORDERS"
    }
    
    func changeViewToEnglishInSelf()
    {
        self.navigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.navigationTitle.text = "LIST OF ORDERS"
    }
    
    func ListOfOrdersContent()
    {
        self.stopActivity()
        
       // let ListOfOrdersNavigationBar = UIView()
        ListOfOrdersNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        ListOfOrdersNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
//        view.addSubview(ListOfOrdersNavigationBar)
    
     /*
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 4
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        ListOfOrdersNavigationBar.addSubview(backButton)
      */
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: ListOfOrdersNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "LIST OF ORDERS"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
//        ListOfOrdersNavigationBar.addSubview(navigationTitle)
        
     
        PendingButton.frame = CGRect(x: 0, y: ListOfOrdersNavigationBar.frame.maxY, width: ((view.frame.width / 2) - 1), height: (4 * y))
        PendingButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        PendingButton.setTitle("PENDING", for: .normal)
        PendingButton.setTitleColor(UIColor.white, for: .normal)
        PendingButton.tag = 0
        PendingButton.addTarget(self, action: #selector(self.selectionViewButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(PendingButton)
        
    
        DeliveredButton.frame = CGRect(x: PendingButton.frame.maxX + 1, y: ListOfOrdersNavigationBar.frame.maxY, width: view.frame.width / 2, height: (4 * y))
        DeliveredButton.backgroundColor = UIColor.lightGray
        DeliveredButton.setTitle("DELIVERED", for: .normal)
        DeliveredButton.setTitleColor(UIColor.black, for: .normal)
        DeliveredButton.tag = 1
        DeliveredButton.addTarget(self, action: #selector(self.selectionViewButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(DeliveredButton)
        
        DeliveredButton.backgroundColor = UIColor.lightGray
        DeliveredButton.setTitleColor(UIColor.black, for: .normal)
        
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
        
        PendingViewContents(isHidden: false)
        DeliveredViewContents(isHidden: true)
    }
 
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
 
    @objc func selectionViewButtonAction(sender : UIButton)
    {
        if sender.tag == 0
        {
            DeliveredButton.backgroundColor = UIColor.lightGray
            DeliveredButton.setTitleColor(UIColor.black, for: .normal)
            PendingViewContents(isHidden: false)
            DeliveredViewContents(isHidden: true)
        }
        else if sender.tag == 1
        {
            PendingButton.backgroundColor = UIColor.lightGray
            PendingButton.setTitleColor(UIColor.black, for: .normal)
            PendingViewContents(isHidden: true)
            DeliveredViewContents(isHidden: false)
        }
        
        sender.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        sender.setTitleColor(UIColor.white, for: .normal)
    }
    
    func PendingViewContents(isHidden : Bool)
    {
       // let PendingViewBackDrop = UIView()
        PendingViewBackDrop.frame = CGRect(x: (3 * x), y: DeliveredButton.frame.maxY , width: view.frame.width - (6 * x), height: view.frame.height - (16 * y))
        PendingViewBackDrop.backgroundColor = UIColor.clear
        view.addSubview(PendingViewBackDrop)
        
        PendingViewBackDrop.isHidden = isHidden
        
        /*
         let sortButton = UIButton()
         sortButton.frame = CGRect(x: backDrop.frame.width - (10 * x), y: y, width: (10 * x), height: (2 * y))
         sortButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
         sortButton.setTitle("SORT", for: .normal)
         sortButton.setTitleColor(UIColor.white, for: .normal)
         sortButton.tag = 0
         //        sortButton.addTarget(self, action: #selector(self.selectionViewButtonAction(sender:)), for: .touchUpInside)
         backDrop.addSubview(sortButton)
         */
        
        PendingScrollView.frame = CGRect(x: 0, y: y, width: PendingViewBackDrop.frame.width, height: (50 * y))
       // PendingScrollView.backgroundColor = UIColor.gray
        PendingViewBackDrop.addSubview(PendingScrollView)
        
        PendingScrollView.contentSize.height = (12 * y * CGFloat(PendOrderIdArray.count))
        
        for views in PendingScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        var y1:CGFloat = 0
        
    if(PendOrderIdArray.count > 0)
     {
        for i in 0..<PendOrderIdArray.count
        {
            let PendingViewButton = UIButton()
            PendingViewButton.frame = CGRect(x: 0, y: y1, width: PendingScrollView.frame.width, height: (10 * y))
            PendingViewButton.backgroundColor = UIColor.white
            PendingScrollView.addSubview(PendingViewButton)
            
            let tailorImageView = UIImageView()
            tailorImageView.frame = CGRect(x: 0, y: 0, width: (8 * x), height: PendingViewButton.frame.height)
            tailorImageView.backgroundColor = UIColor.white  //UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            tailorImageView.layer.borderWidth = 1.0
            tailorImageView.layer.borderColor = UIColor.lightGray.cgColor
           // tailorImageView.setImage(UIImage(named: "men"), for: .normal)
            
            
             if let imageName = PendImageArray[i] as? String
             {
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/DressSubType/\(imageName)"
                print("SMALL ICON", api)
                let apiurl = URL(string: api)
             
                let dummyImageView = UIImageView()
                dummyImageView.frame = CGRect(x: 0, y: 0, width: tailorImageView.frame.width, height: tailorImageView.frame.height)
                dummyImageView.dowloadFromServer(url: apiurl!)
                dummyImageView.tag = -1
                tailorImageView.addSubview(dummyImageView)
             }
            
            PendingViewButton.addSubview(tailorImageView)
            
            
            let orderId_Icon = UIImageView()
            orderId_Icon.frame = CGRect(x: tailorImageView.frame.maxX + x, y: y/2, width: x, height: y)
            orderId_Icon.image = UIImage(named: "OrderID")
            PendingViewButton.addSubview(orderId_Icon)
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: orderId_Icon.frame.maxX + x, y: 0, width: (10 * x), height: (2 * y))
            nameLabel.text = "Order Id : "
            nameLabel.textColor = UIColor.blue
            nameLabel.textAlignment = .left
            nameLabel.font =  UIFont(name: "Avenir Next", size: 1.2 * x)  //nameLabel.font.withSize(1.2 * x)
            PendingViewButton.addSubview(nameLabel)
            
            let tailorName = UILabel()
            tailorName.frame = CGRect(x: nameLabel.frame.maxX - x, y: 0, width: PendingViewButton.frame.width / 2, height: (2 * y))
            let orderNum:Int = PendOrderIdArray[i] as! Int
            tailorName.text = "\(orderNum)"
            PendingViewButton.tag = PendOrderIdArray[i] as! Int
            tailorName.textColor = UIColor.black
            tailorName.textAlignment = .left
            tailorName.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            PendingViewButton.addSubview(tailorName)
            
            
            let TailorName_Icon = UIImageView()
            TailorName_Icon.frame = CGRect(x: tailorImageView.frame.maxX + x, y: orderId_Icon.frame.maxY + y, width: x, height: y)
            TailorName_Icon.image = UIImage(named: "TailorName")
            PendingViewButton.addSubview(TailorName_Icon)
            
            let shopLabel = UILabel()
            shopLabel.frame = CGRect(x: TailorName_Icon.frame.maxX + x, y: nameLabel.frame.maxY, width: (10 * x), height: (2 * y))
            shopLabel.text = "Tailor Name : "
            shopLabel.textColor = UIColor.blue
            shopLabel.textAlignment = .left
            shopLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            PendingViewButton.addSubview(shopLabel)
            
            let shopName = UILabel()
            shopName.frame = CGRect(x: shopLabel.frame.maxX - x, y: nameLabel.frame.maxY, width: PendingViewButton.frame.width / 2.5, height: (2 * y))
            shopName.text =  PendTailorNameEngArray[i] as? String
            shopName.textColor = UIColor.black
            shopName.textAlignment = .left
            shopName.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            shopName.adjustsFontSizeToFitWidth = true
            PendingViewButton.addSubview(shopName)
            
            
            let ShopName_Icon = UIImageView()
            ShopName_Icon.frame = CGRect(x: tailorImageView.frame.maxX + x, y: TailorName_Icon.frame.maxY + y, width: x, height: y)
            ShopName_Icon.image = UIImage(named: "ShopName")
            PendingViewButton.addSubview(ShopName_Icon)
            
            let ordersLabel = UILabel()
            ordersLabel.frame = CGRect(x: ShopName_Icon.frame.maxX + x, y: shopLabel.frame.maxY , width: (10 * x), height: (2 * y))
            ordersLabel.text = "Shop Name : "
            ordersLabel.textColor = UIColor.blue
            ordersLabel.textAlignment = .left
            ordersLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            PendingViewButton.addSubview(ordersLabel)
            
            let ordersCountLabel = UILabel()
            ordersCountLabel.frame = CGRect(x: ordersLabel.frame.maxX - x, y: shopLabel.frame.maxY, width: PendingViewButton.frame.width / 2.5, height: (2 * y))
            ordersCountLabel.text =  PendShopNameEngArray[i] as? String
            ordersCountLabel.textColor = UIColor.black
            ordersCountLabel.textAlignment = .left
            ordersCountLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            ordersCountLabel.adjustsFontSizeToFitWidth = true
            PendingViewButton.addSubview(ordersCountLabel)
            
            
            let ProductName_Icon = UIImageView()
            ProductName_Icon.frame = CGRect(x: tailorImageView.frame.maxX + x, y: ShopName_Icon.frame.maxY + y, width: x, height: y)
            ProductName_Icon.image = UIImage(named: "ProductName")
            PendingViewButton.addSubview(ProductName_Icon)
            
            let ProductLabel = UILabel()
            ProductLabel.frame = CGRect(x: ProductName_Icon.frame.maxX + x, y: ordersLabel.frame.maxY, width: (10 * x), height: (2 * y))
            ProductLabel.text = "Product Name : "
            ProductLabel.textColor = UIColor.blue
            ProductLabel.textAlignment = .left
            ProductLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            PendingViewButton.addSubview(ProductLabel)
            
            let ProductNameLabel = UILabel()
            ProductNameLabel.frame = CGRect(x: ProductLabel.frame.maxX - x, y: ordersLabel.frame.maxY, width: PendingViewButton.frame.width / 2.5, height: (2 * y))
            ProductNameLabel.text = PendProdNameArray[i] as? String
            ProductNameLabel.textColor = UIColor.black
            ProductNameLabel.textAlignment = .left
            ProductNameLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            ProductNameLabel.adjustsFontSizeToFitWidth = true
            PendingViewButton.addSubview(ProductNameLabel)
            
            
            let OrderDT_Icon = UIImageView()
            OrderDT_Icon.frame = CGRect(x: tailorImageView.frame.maxX + x, y: ProductName_Icon.frame.maxY + y, width: x, height: y)
            OrderDT_Icon.image = UIImage(named: "OrderDate_Time")
            PendingViewButton.addSubview(OrderDT_Icon)
            
            let OrderDateLabel = UILabel()
            OrderDateLabel.frame = CGRect(x: OrderDT_Icon.frame.maxX + x, y: ProductLabel.frame.maxY, width: (12 * x), height: (2 * y))
            OrderDateLabel.text = "Order Date/Time : "
            OrderDateLabel.textColor = UIColor.blue
            OrderDateLabel.textAlignment = .left
            OrderDateLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            PendingViewButton.addSubview(OrderDateLabel)
            
            let OrderDatesLabel = UILabel()
            OrderDatesLabel.frame = CGRect(x: OrderDateLabel.frame.maxX - x, y: ProductLabel.frame.maxY, width: PendingViewButton.frame.width / 2.5, height: (2 * y))
            if let date = PendOrderDateArray[i] as? String
            {
                OrderPendDate = String(date.prefix(10))
            }
            OrderDatesLabel.text = OrderPendDate
            OrderDatesLabel.textColor = UIColor.black
            OrderDatesLabel.textAlignment = .left
            OrderDatesLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            OrderDatesLabel.adjustsFontSizeToFitWidth = true
            PendingViewButton.addSubview(OrderDatesLabel)
            
           PendingViewButton.addTarget(self, action: #selector(self.confirmSelectionButtonAction(sender:)), for: .touchUpInside)
            
            y1 = PendingViewButton.frame.maxY + y
         }
        }
      else
      {
          // let alert = UIAlertController(title: "Alert", message: "No Orders Placed", preferredStyle: .alert)
          // alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          // self.present(alert, animated: true, completion: nil)

      }
    }
    
    func DeliveredViewContents(isHidden : Bool)
    {
        // let DeliveredViewBackDrop = UIView()
        DeliveredViewBackDrop.frame = CGRect(x: (3 * x), y: DeliveredButton.frame.maxY , width: view.frame.width - (6 * x), height: view.frame.height - (16 * y))
        DeliveredViewBackDrop.backgroundColor = UIColor.clear
        view.addSubview(DeliveredViewBackDrop)
        
        DeliveredViewBackDrop.isHidden = isHidden
        
       /*
         let sortButton = UIButton()
         sortButton.frame = CGRect(x: backDrop.frame.width - (10 * x), y: y, width: (10 * x), height: (2 * y))
         sortButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
         sortButton.setTitle("SORT", for: .normal)
         sortButton.setTitleColor(UIColor.white, for: .normal)
         sortButton.tag = 0
         //        sortButton.addTarget(self, action: #selector(self.selectionViewButtonAction(sender:)), for: .touchUpInside)
         backDrop.addSubview(sortButton)
       */
        
        DeliveredScrollView.frame = CGRect(x: 0, y: y, width: DeliveredViewBackDrop.frame.width, height: (50 * y))
        // tailorListScrollView.backgroundColor = UIColor.gray
        DeliveredViewBackDrop.addSubview(DeliveredScrollView)
        
        DeliveredScrollView.contentSize.height = (12 * y * CGFloat(DelivOrderIdArray.count))
        
        for views in DeliveredScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        var y2:CGFloat = 0
    
        
    if(DelivOrderIdArray.count > 0)
    {
        for i in 0..<DelivOrderIdArray.count
        {
            let DeliveredViewButton = UIButton()
            DeliveredViewButton.frame = CGRect(x: 0, y: y2, width: DeliveredScrollView.frame.width, height: (10 * y))
            DeliveredViewButton.backgroundColor = UIColor.white
            DeliveredScrollView.addSubview(DeliveredViewButton)
            
            let tailorImageView = UIImageView()
            tailorImageView.frame = CGRect(x: 0, y: 0, width: (8 * x), height: DeliveredViewButton.frame.height)
            tailorImageView.backgroundColor = UIColor.white  //UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            tailorImageView.layer.borderWidth = 1.0
            tailorImageView.layer.borderColor = UIColor.lightGray.cgColor
            // tailorImageView.setImage(UIImage(named: "men"), for: .normal)
            
            
             if let imageName = DelivImageArray[i] as? String
             {
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/DressSubType/\(imageName)"
                print("SMALL ICON", api)
                let apiurl = URL(string: api)
             
                let dummyImageView = UIImageView()
                dummyImageView.frame = CGRect(x: 0, y: 0, width: tailorImageView.frame.width, height: tailorImageView.frame.height)
                dummyImageView.dowloadFromServer(url: apiurl!)
                dummyImageView.tag = -1
                tailorImageView.addSubview(dummyImageView)
             }
            
            
            DeliveredViewButton.addSubview(tailorImageView)
            
            
            let orderId_Icon = UIImageView()
            orderId_Icon.frame = CGRect(x: tailorImageView.frame.maxX + x, y: y/2, width: x, height: y)
            orderId_Icon.image = UIImage(named: "OrderID")
            DeliveredViewButton.addSubview(orderId_Icon)
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: orderId_Icon.frame.maxX + x, y: 0, width: (10 * x), height: (2 * y))
            nameLabel.text = "Order Id : "
            nameLabel.textColor = UIColor.blue
            nameLabel.textAlignment = .left
            nameLabel.font =  UIFont(name: "Avenir Next", size: 1.2 * x)  //nameLabel.font.withSize(1.2 * x)
            DeliveredViewButton.addSubview(nameLabel)
            
            let tailorName = UILabel()
            tailorName.frame = CGRect(x: nameLabel.frame.maxX - x, y: 0, width: DeliveredViewButton.frame.width / 2, height: (2 * y))
            let orderNum:Int = DelivOrderIdArray[i] as! Int
            tailorName.text = "\(orderNum)"
            DeliveredViewButton.tag = DelivOrderIdArray[i] as! Int
            tailorName.textColor = UIColor.black
            tailorName.textAlignment = .left
            tailorName.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            DeliveredViewButton.addSubview(tailorName)
            
            let TailorName_Icon = UIImageView()
            TailorName_Icon.frame = CGRect(x: tailorImageView.frame.maxX + x, y: orderId_Icon.frame.maxY + y, width: x, height: y)
            TailorName_Icon.image = UIImage(named: "TailorName")
            DeliveredViewButton.addSubview(TailorName_Icon)
            
            let shopLabel = UILabel()
            shopLabel.frame = CGRect(x: TailorName_Icon.frame.maxX + x, y: nameLabel.frame.maxY, width: (10 * x), height: (2 * y))
            shopLabel.text = "Tailor Name : "
            shopLabel.textColor = UIColor.blue
            shopLabel.textAlignment = .left
            shopLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            DeliveredViewButton.addSubview(shopLabel)
            
            let shopName = UILabel()
            shopName.frame = CGRect(x: shopLabel.frame.maxX - x, y: nameLabel.frame.maxY, width: DeliveredViewButton.frame.width / 2.5, height: (2 * y))
            shopName.text = DelivTailorNameEngArray[i] as? String
            shopName.textColor = UIColor.black
            shopName.textAlignment = .left
            shopName.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            shopName.adjustsFontSizeToFitWidth = true
            DeliveredViewButton.addSubview(shopName)
            
            
            let ShopName_Icon = UIImageView()
            ShopName_Icon.frame = CGRect(x: tailorImageView.frame.maxX + x, y: TailorName_Icon.frame.maxY + y, width: x, height: y)
            ShopName_Icon.image = UIImage(named: "ShopName")
            DeliveredViewButton.addSubview(ShopName_Icon)
            
            let ordersLabel = UILabel()
            ordersLabel.frame = CGRect(x: ShopName_Icon.frame.maxX + x, y: shopLabel.frame.maxY, width: (10 * x), height: (2 * y))
            ordersLabel.text = "Shop Name : "
            ordersLabel.textColor = UIColor.blue
            ordersLabel.textAlignment = .left
            ordersLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            DeliveredViewButton.addSubview(ordersLabel)
            
            let ordersCountLabel = UILabel()
            ordersCountLabel.frame = CGRect(x: ordersLabel.frame.maxX - x, y: shopLabel.frame.maxY, width: DeliveredViewButton.frame.width / 2.5, height: (2 * y))
            ordersCountLabel.text = DelivShopNameEngArray[i] as? String
            ordersCountLabel.textColor = UIColor.black
            ordersCountLabel.textAlignment = .left
            ordersCountLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            ordersCountLabel.adjustsFontSizeToFitWidth = true
            DeliveredViewButton.addSubview(ordersCountLabel)
            
            
            let ProductName_Icon = UIImageView()
            ProductName_Icon.frame = CGRect(x: tailorImageView.frame.maxX + x, y: ShopName_Icon.frame.maxY + y, width: x, height: y)
            ProductName_Icon.image = UIImage(named: "ProductName")
            DeliveredViewButton.addSubview(ProductName_Icon)
            
            let ProductLabel = UILabel()
            ProductLabel.frame = CGRect(x: ProductName_Icon.frame.maxX + x, y: ordersLabel.frame.maxY, width: (10 * x), height: (2 * y))
            ProductLabel.text = "Product Name : "
            ProductLabel.textColor = UIColor.blue
            ProductLabel.textAlignment = .left
            ProductLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            DeliveredViewButton.addSubview(ProductLabel)
            
            let ProductNameLabel = UILabel()
            ProductNameLabel.frame = CGRect(x: ProductLabel.frame.maxX - x, y: ordersLabel.frame.maxY, width: DeliveredViewButton.frame.width / 2.5, height: (2 * y))
            ProductNameLabel.text = DelivProdNameArray[i] as? String
            ProductNameLabel.textColor = UIColor.black
            ProductNameLabel.textAlignment = .left
            ProductNameLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            ProductNameLabel.adjustsFontSizeToFitWidth = true
            DeliveredViewButton.addSubview(ProductNameLabel)
            
            
            let OrderDT_Icon = UIImageView()
            OrderDT_Icon.frame = CGRect(x: tailorImageView.frame.maxX + x, y: ProductName_Icon.frame.maxY + y, width: x, height: y)
            OrderDT_Icon.image = UIImage(named: "OrderDate_Time")
            DeliveredViewButton.addSubview(OrderDT_Icon)
            
            let OrderDateLabel = UILabel()
            OrderDateLabel.frame = CGRect(x: OrderDT_Icon.frame.maxX + x, y: ProductLabel.frame.maxY, width: (12 * x), height: (2 * y))
            OrderDateLabel.text = "Order Date/Time : "
            OrderDateLabel.textColor = UIColor.blue
            OrderDateLabel.textAlignment = .left
            OrderDateLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            DeliveredViewButton.addSubview(OrderDateLabel)
            
            let OrderDatesLabel = UILabel()
            OrderDatesLabel.frame = CGRect(x: OrderDateLabel.frame.maxX - x, y: ProductLabel.frame.maxY, width: DeliveredViewButton.frame.width / 2.5, height: (2 * y))
            if let date = DelivOrderDateArray[i] as? String
            {
                OrderDelvDate = String(date.prefix(10))
            }
            OrderDatesLabel.text = OrderDelvDate
            OrderDatesLabel.textColor = UIColor.black
            OrderDatesLabel.textAlignment = .left
            OrderDatesLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            OrderDatesLabel.adjustsFontSizeToFitWidth = true
            DeliveredViewButton.addSubview(OrderDatesLabel)
            
          
            TailorId = DelivTailorIdArray[i] as? Int
            print("TailorId:","\(String(describing: TailorId))")
            
            DeliveredViewButton.addTarget(self, action: #selector(self.DeliveredDetailsButtonAction(sender:)), for: .touchUpInside)
            
            y2 = DeliveredViewButton.frame.maxY + y
        }
      }
    else
    {
       // let alert = UIAlertController(title: "Alert", message: "No Orders Delivered", preferredStyle: .alert)
       // alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
       // self.present(alert, animated: true, completion: nil)
    }
        
  }
    
    @objc func confirmSelectionButtonAction(sender : UIButton)
    {
        let orderDetailsScreen = OrderDetailsViewController()
        orderDetailsScreen.OrderID = sender.tag
        self.navigationController?.pushViewController(orderDetailsScreen, animated: true)
    }
    
    @objc func DeliveredDetailsButtonAction(sender : UIButton)
    {
       // let TailorID = UserDefaults.standard.value(forKey: "TailorID")
        print("Tailor ID:",TailorId!)
        
        let orderDetVCScreen = OrderDetailsDeliveredVC()
        orderDetVCScreen.OrderID = sender.tag
        orderDetVCScreen.TailorID = TailorId
        self.navigationController?.pushViewController(orderDetVCScreen, animated: true)
    }
}
