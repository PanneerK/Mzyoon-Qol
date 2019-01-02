//
//  ListOfOrdersViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 28/12/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class ListOfOrdersViewController: CommonViewController
{

    let DeliveredButton = UIButton()
    let PendingButton = UIButton()
    
    let ListOfOrdersNavigationBar = UIView()
    let tailorListScrollView = UIScrollView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
         self.tab3Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        
        ListOfOrdersContent()
    }
    

 /*
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        // ErrorStr = "Default Error"
        PageNumStr = "QuotationListViewController"
        //  MethodName = "do"
        
        print("UUID", UIDevice.current.identifierForVendor?.uuidString as Any)
        self.ServiceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
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
            
            OrderIdArray = QuotationList.value(forKey: "OrderId") as! NSArray
            //  print("OrderIdArray", OrderIdArray)
            
            IdArray = QuotationList.value(forKey: "Id") as! NSArray
            // print("IdArray", IdArray)
            
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
   */
    
    
    func ListOfOrdersContent()
    {
        self.stopActivity()
        
       // let ListOfOrdersNavigationBar = UIView()
        ListOfOrdersNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        ListOfOrdersNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(ListOfOrdersNavigationBar)
    
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
        ListOfOrdersNavigationBar.addSubview(navigationTitle)
        
     
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
        let PendingViewBackDrop = UIView()
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
        
        tailorListScrollView.frame = CGRect(x: 0, y: y, width: PendingViewBackDrop.frame.width, height: (50 * y))
        // tailorListScrollView.backgroundColor = UIColor.gray
        PendingViewBackDrop.addSubview(tailorListScrollView)
        
        tailorListScrollView.contentSize.height = (12 * y * CGFloat(4))
        
        for views in tailorListScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        var y1:CGFloat = 0
        
        for i in 0..<4
        {
            let PendingViewButton = UIButton()
            PendingViewButton.frame = CGRect(x: 0, y: y1, width: tailorListScrollView.frame.width, height: (10 * y))
            PendingViewButton.backgroundColor = UIColor.white
            tailorListScrollView.addSubview(PendingViewButton)
            
            let tailorImageView = UIImageView()
            tailorImageView.frame = CGRect(x: x, y: y, width: (8 * x), height: (8 * y))
            tailorImageView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            // tailorImageView.setImage(UIImage(named: "men"), for: .normal)
            
            /*
             if let imageName = ShopImageArray[i] as? String
             {
             // let api = "http://appsapi.mzyoon.com/images/Tailorimages/\(imageName)"
             let api = "http://192.168.0.21/TailorAPI/Images/TailorImages/\(imageName)"
             print("SMALL ICON", api)
             let apiurl = URL(string: api)
             
             let dummyImageView = UIImageView()
             dummyImageView.frame = CGRect(x: 0, y: 0, width: tailorImageView.frame.width, height: tailorImageView.frame.height)
             dummyImageView.dowloadFromServer(url: apiurl!)
             dummyImageView.tag = -1
             tailorImageView.addSubview(dummyImageView)
             }
             */
            
            PendingViewButton.addSubview(tailorImageView)
            
            
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: tailorImageView.frame.maxX + x, y: 0, width: (10 * x), height: (2 * y))
            nameLabel.text = "Order Id : "
            nameLabel.textColor = UIColor.blue
            nameLabel.textAlignment = .left
            nameLabel.font =  UIFont(name: "Avenir Next", size: 1.2 * x)  //nameLabel.font.withSize(1.2 * x)
            PendingViewButton.addSubview(nameLabel)
            
            let tailorName = UILabel()
            tailorName.frame = CGRect(x: nameLabel.frame.maxX, y: 0, width: PendingViewButton.frame.width / 2, height: (2 * y))
            tailorName.text = "00000"
            tailorName.textColor = UIColor.black
            tailorName.textAlignment = .left
            tailorName.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            PendingViewButton.addSubview(tailorName)
            
            let shopLabel = UILabel()
            shopLabel.frame = CGRect(x: tailorImageView.frame.maxX + x, y: nameLabel.frame.maxY, width: (10 * x), height: (2 * y))
            shopLabel.text = "Tailor Name : "
            shopLabel.textColor = UIColor.blue
            shopLabel.textAlignment = .left
            shopLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            PendingViewButton.addSubview(shopLabel)
            
            let shopName = UILabel()
            shopName.frame = CGRect(x: shopLabel.frame.maxX, y: nameLabel.frame.maxY, width: PendingViewButton.frame.width / 2.5, height: (2 * y))
            shopName.text =  "Sha"
            shopName.textColor = UIColor.black
            shopName.textAlignment = .left
            shopName.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            shopName.adjustsFontSizeToFitWidth = true
            PendingViewButton.addSubview(shopName)
            
            let ordersLabel = UILabel()
            ordersLabel.frame = CGRect(x: tailorImageView.frame.maxX + x, y: shopLabel.frame.maxY, width: (10 * x), height: (2 * y))
            ordersLabel.text = "Shop Name : "
            ordersLabel.textColor = UIColor.blue
            ordersLabel.textAlignment = .left
            ordersLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            PendingViewButton.addSubview(ordersLabel)
            
            let ordersCountLabel = UILabel()
            ordersCountLabel.frame = CGRect(x: ordersLabel.frame.maxX, y: shopLabel.frame.maxY, width: PendingViewButton.frame.width / 2.5, height: (2 * y))
            ordersCountLabel.text =  "Golden Works"
            ordersCountLabel.textColor = UIColor.black
            ordersCountLabel.textAlignment = .left
            ordersCountLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            ordersCountLabel.adjustsFontSizeToFitWidth = true
            PendingViewButton.addSubview(ordersCountLabel)
            
            let ProductLabel = UILabel()
            ProductLabel.frame = CGRect(x: tailorImageView.frame.maxX + x, y: ordersLabel.frame.maxY, width: (10 * x), height: (2 * y))
            ProductLabel.text = "Product Name : "
            ProductLabel.textColor = UIColor.blue
            ProductLabel.textAlignment = .left
            ProductLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            PendingViewButton.addSubview(ProductLabel)
            
            let ProductNameLabel = UILabel()
            ProductNameLabel.frame = CGRect(x: ProductLabel.frame.maxX, y: ordersLabel.frame.maxY, width: PendingViewButton.frame.width / 2.5, height: (2 * y))
            ProductNameLabel.text =  "Slim Fit"
            ProductNameLabel.textColor = UIColor.black
            ProductNameLabel.textAlignment = .left
            ProductNameLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            ProductNameLabel.adjustsFontSizeToFitWidth = true
            PendingViewButton.addSubview(ProductNameLabel)
            
            
            let OrderDateLabel = UILabel()
            OrderDateLabel.frame = CGRect(x: tailorImageView.frame.maxX + x, y: ProductLabel.frame.maxY, width: (12 * x), height: (2 * y))
            OrderDateLabel.text = "Order Date/Time : "
            OrderDateLabel.textColor = UIColor.blue
            OrderDateLabel.textAlignment = .left
            OrderDateLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            PendingViewButton.addSubview(OrderDateLabel)
            
            let OrderDatesLabel = UILabel()
            OrderDatesLabel.frame = CGRect(x: OrderDateLabel.frame.maxX, y: ProductLabel.frame.maxY, width: PendingViewButton.frame.width / 2.5, height: (2 * y))
            OrderDatesLabel.text =  "28-10-2018"
            OrderDatesLabel.textColor = UIColor.black
            OrderDatesLabel.textAlignment = .left
            OrderDatesLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            OrderDatesLabel.adjustsFontSizeToFitWidth = true
            PendingViewButton.addSubview(OrderDatesLabel)
            
          //  RequestViewButton.addTarget(self, action: #selector(self.confirmSelectionButtonAction(sender:)), for: .touchUpInside)
            
            y1 = PendingViewButton.frame.maxY + y
        }
    }
    
    func DeliveredViewContents(isHidden : Bool)
    {
        let DeliveredViewBackDrop = UIView()
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
        
        tailorListScrollView.frame = CGRect(x: 0, y: y, width: DeliveredViewBackDrop.frame.width, height: (50 * y))
        // tailorListScrollView.backgroundColor = UIColor.gray
        DeliveredViewBackDrop.addSubview(tailorListScrollView)
        
        tailorListScrollView.contentSize.height = (12 * y * CGFloat(4))
        
        for views in tailorListScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        var y1:CGFloat = 0
        
        for i in 0..<4
        {
            let DeliveredViewButton = UIButton()
            DeliveredViewButton.frame = CGRect(x: 0, y: y1, width: tailorListScrollView.frame.width, height: (10 * y))
            DeliveredViewButton.backgroundColor = UIColor.white
            tailorListScrollView.addSubview(DeliveredViewButton)
            
            let tailorImageView = UIImageView()
            tailorImageView.frame = CGRect(x: x, y: y, width: (8 * x), height: (8 * y))
            tailorImageView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            // tailorImageView.setImage(UIImage(named: "men"), for: .normal)
            
            /*
             if let imageName = ShopImageArray[i] as? String
             {
             // let api = "http://appsapi.mzyoon.com/images/Tailorimages/\(imageName)"
             let api = "http://192.168.0.21/TailorAPI/Images/TailorImages/\(imageName)"
             print("SMALL ICON", api)
             let apiurl = URL(string: api)
             
             let dummyImageView = UIImageView()
             dummyImageView.frame = CGRect(x: 0, y: 0, width: tailorImageView.frame.width, height: tailorImageView.frame.height)
             dummyImageView.dowloadFromServer(url: apiurl!)
             dummyImageView.tag = -1
             tailorImageView.addSubview(dummyImageView)
             }
             */
            
            DeliveredViewButton.addSubview(tailorImageView)
            
            
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: tailorImageView.frame.maxX + x, y: 0, width: (10 * x), height: (2 * y))
            nameLabel.text = "Order Id : "
            nameLabel.textColor = UIColor.blue
            nameLabel.textAlignment = .left
            nameLabel.font =  UIFont(name: "Avenir Next", size: 1.2 * x)  //nameLabel.font.withSize(1.2 * x)
            DeliveredViewButton.addSubview(nameLabel)
            
            let tailorName = UILabel()
            tailorName.frame = CGRect(x: nameLabel.frame.maxX, y: 0, width: DeliveredViewButton.frame.width / 2, height: (2 * y))
            tailorName.text = "123456789"
            tailorName.textColor = UIColor.black
            tailorName.textAlignment = .left
            tailorName.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            DeliveredViewButton.addSubview(tailorName)
            
            let shopLabel = UILabel()
            shopLabel.frame = CGRect(x: tailorImageView.frame.maxX + x, y: nameLabel.frame.maxY, width: (10 * x), height: (2 * y))
            shopLabel.text = "Tailor Name : "
            shopLabel.textColor = UIColor.blue
            shopLabel.textAlignment = .left
            shopLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            DeliveredViewButton.addSubview(shopLabel)
            
            let shopName = UILabel()
            shopName.frame = CGRect(x: shopLabel.frame.maxX, y: nameLabel.frame.maxY, width: DeliveredViewButton.frame.width / 2.5, height: (2 * y))
            shopName.text =  "Abdullah"
            shopName.textColor = UIColor.black
            shopName.textAlignment = .left
            shopName.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            shopName.adjustsFontSizeToFitWidth = true
            DeliveredViewButton.addSubview(shopName)
            
            let ordersLabel = UILabel()
            ordersLabel.frame = CGRect(x: tailorImageView.frame.maxX + x, y: shopLabel.frame.maxY, width: (10 * x), height: (2 * y))
            ordersLabel.text = "Shop Name : "
            ordersLabel.textColor = UIColor.blue
            ordersLabel.textAlignment = .left
            ordersLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            DeliveredViewButton.addSubview(ordersLabel)
            
            let ordersCountLabel = UILabel()
            ordersCountLabel.frame = CGRect(x: ordersLabel.frame.maxX, y: shopLabel.frame.maxY, width: DeliveredViewButton.frame.width / 2.5, height: (2 * y))
            ordersCountLabel.text =  "Golden Stiching"
            ordersCountLabel.textColor = UIColor.black
            ordersCountLabel.textAlignment = .left
            ordersCountLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            ordersCountLabel.adjustsFontSizeToFitWidth = true
            DeliveredViewButton.addSubview(ordersCountLabel)
            
            let ProductLabel = UILabel()
            ProductLabel.frame = CGRect(x: tailorImageView.frame.maxX + x, y: ordersLabel.frame.maxY, width: (10 * x), height: (2 * y))
            ProductLabel.text = "Product Name : "
            ProductLabel.textColor = UIColor.blue
            ProductLabel.textAlignment = .left
            ProductLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            DeliveredViewButton.addSubview(ProductLabel)
            
            let ProductNameLabel = UILabel()
            ProductNameLabel.frame = CGRect(x: ProductLabel.frame.maxX, y: ordersLabel.frame.maxY, width: DeliveredViewButton.frame.width / 2.5, height: (2 * y))
            ProductNameLabel.text =  "One button Slim Fit"
            ProductNameLabel.textColor = UIColor.black
            ProductNameLabel.textAlignment = .left
            ProductNameLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            ProductNameLabel.adjustsFontSizeToFitWidth = true
            DeliveredViewButton.addSubview(ProductNameLabel)
            
            
            let OrderDateLabel = UILabel()
            OrderDateLabel.frame = CGRect(x: tailorImageView.frame.maxX + x, y: ProductLabel.frame.maxY, width: (12 * x), height: (2 * y))
            OrderDateLabel.text = "Order Date/Time : "
            OrderDateLabel.textColor = UIColor.blue
            OrderDateLabel.textAlignment = .left
            OrderDateLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            DeliveredViewButton.addSubview(OrderDateLabel)
            
            let OrderDatesLabel = UILabel()
            OrderDatesLabel.frame = CGRect(x: OrderDateLabel.frame.maxX, y: ProductLabel.frame.maxY, width: DeliveredViewButton.frame.width / 2.5, height: (2 * y))
            OrderDatesLabel.text =  "28-10-2018"
            OrderDatesLabel.textColor = UIColor.black
            OrderDatesLabel.textAlignment = .left
            OrderDatesLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            OrderDatesLabel.adjustsFontSizeToFitWidth = true
            DeliveredViewButton.addSubview(OrderDatesLabel)
            
            DeliveredViewButton.addTarget(self, action: #selector(self.confirmSelectionButtonAction(sender:)), for: .touchUpInside)
            
            y1 = DeliveredViewButton.frame.maxY + y
        }
    }
    
    @objc func confirmSelectionButtonAction(sender : UIButton)
    {
        let orderDetailsScreen = OrderDetailsViewController()
        self.navigationController?.pushViewController(orderDetailsScreen, animated: true)
    }
    
}
