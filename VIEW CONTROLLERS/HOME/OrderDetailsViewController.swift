//
//  OrderDetailsViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 20/12/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class OrderDetailsViewController: CommonViewController,ServerAPIDelegate
{
    let serviceCall = ServerAPI()
    
    //SCREEN PARAMETERS
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()

    let orderIdLabel = UILabel()
    let orderIdNumLabel = UILabel()
    let orderPlacedLabel = UILabel()
    let orderPlacedDateLabel = UILabel()

    let PaymentInfoLabel = UILabel()

    let DressTypeLabel = UILabel()
    let QtyLabel = UILabel()
    let QtyNumLabel = UILabel()
    let PriceLabel = UILabel()
    let PriceNumLabel = UILabel()

    let SubTotalLabel = UILabel()
    let SubTotalPriceLabel = UILabel()
    let ShippingLabel = UILabel()
    let ShippingPriceLabel = UILabel()
    let TaxLabel = UILabel()
    let TaxPriceLabel = UILabel()
    let AppointmentLabel = UILabel()
    let AppointmentPriceLabel = UILabel()
    let TotalLabel = UILabel()
    let TotalPriceLabel = UILabel()
    let PaymentLabel = UILabel()
    let PaymentTypeLabel = UILabel()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    

    //BuyerAddress Array..
    var Area = NSArray()
    var Country_Name = NSArray()
    var FirstName = NSArray()
    var Floor = NSArray()
    var PhoneNo = NSArray()
    var StateName = NSArray()
    
    //OrderDetails Array..
    var Image = NSArray()
    var OrderId = NSArray()
    var OrderDt = NSArray()
    var Product_Name = NSArray()
    var ServiceType = NSArray()
    var qty = NSArray()
    
    // ProductPrice Array..
    var Appoinment = NSArray()
    var Price = NSArray()
    var Tax = NSArray()
    var Total = NSArray()
    
     var ShippingCharges = NSArray()
    
     var OrderID:Int!
    var OrderDate = String()
    
    //Tracking array..
    var DateArray = NSArray()
    var StatusArray = NSArray()
    var TrackingStatusIdArray = NSArray()
    
    let OrderDetailsScrollView = UIScrollView()
    
    var applicationDelegate = AppDelegate()

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.tab3Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        
         navigationBar.isHidden = true
        
         selectedButton(tag: 2)
  
       
        //orderDetailsContent()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        let navigationArray = self.navigationController?.viewControllers
        print("viewControllers Aray:",navigationArray!)
        
        OrderID = 33
        
         self.serviceCall.API_GetOrderDetails(OrderId: OrderID, delegate: self)
        
        // self.serviceCall.API_GetTrackingDetails(OrderId: OrderID, delegate: self)
        
    }
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("Order Details :", errorNumber)
        stopActivity()
        applicationDelegate.exitContents()
    }
    
    func API_CALLBACK_GetOrderDetails(getOrderDetails: NSDictionary)
    {
        let ResponseMsg = getOrderDetails.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = getOrderDetails.object(forKey: "Result") as! NSDictionary
            print("Result", Result)
            
            let BuyerAddress = Result.value(forKey: "BuyerAddress") as! NSArray
            // print("BuyerAddress:", BuyerAddress)
            
            Area = BuyerAddress.value(forKey: "Area") as! NSArray
            print("Area:",Area)
            
            Country_Name = BuyerAddress.value(forKey: "Country_Name") as! NSArray
            print("Country_Name:",Country_Name)
            
            FirstName = BuyerAddress.value(forKey: "FirstName") as! NSArray
            print("FirstName:",FirstName)
            
            Floor = BuyerAddress.value(forKey: "Floor") as! NSArray
            print("Floor:",Floor)
            
            PhoneNo = BuyerAddress.value(forKey: "PhoneNo") as! NSArray
            print("PhoneNo:",PhoneNo)
            
            StateName = BuyerAddress.value(forKey: "StateName") as! NSArray
            print("StateName:",StateName)
            
            
            let OrderDetail = Result.value(forKey: "OrderDetail") as! NSArray
            // print("OrderDetail:", OrderDetail)
            
            Image = OrderDetail.value(forKey: "Image") as! NSArray
            print("Image:",Image)
            
            OrderId = OrderDetail.value(forKey: "OrderId") as! NSArray
            print("OrderId:",OrderId)
            
            OrderDt = OrderDetail.value(forKey: "OrderDt") as! NSArray
            print("OrderDt:",OrderDt)
            
            Product_Name = OrderDetail.value(forKey: "Product_Name") as! NSArray
            print("Product_Name:",Product_Name)
            
            qty = OrderDetail.value(forKey: "qty") as! NSArray
            print("qty:",qty)
            
            ServiceType = OrderDetail.value(forKey: "ServiceType") as! NSArray
            print("ServiceType:",ServiceType)
            
            
            let ProductPrice = Result.value(forKey: "ProductPrice") as! NSArray
            //print("ProductPrice:", ProductPrice)
            
            Appoinment = ProductPrice.value(forKey: "Appoinment") as! NSArray
            print("Appoinment:", Appoinment)
            
            Price = ProductPrice.value(forKey: "Price") as! NSArray
            print("Price:", Price)
            
            Tax = ProductPrice.value(forKey: "Tax") as! NSArray
            print("Tax:", Tax)
            
            Total = ProductPrice.value(forKey: "Total") as! NSArray
            print("Total:", Total)
            
            
            let Shipping_Charges = Result.value(forKey: "Shipping_Charges") as! NSArray
            
            ShippingCharges = Shipping_Charges.value(forKey: "Shipping_Charges") as! NSArray
            print("ShippingCharges:", ShippingCharges)
            
            
          //  orderDetailsContent()
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = getOrderDetails.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetOrderDetails"
            ErrorStr = Result
            
            DeviceError()
            
        }
        
         orderDetailsContent()
    }
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        // ErrorStr = "Default Error"
        PageNumStr = "OrderDetailsViewController"
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
    func API_CALLBACK_GetTrackingDetails(getTrackingDetails: NSDictionary)
    {
        let ResponseMsg = getTrackingDetails.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = getTrackingDetails.object(forKey: "Result") as! NSArray
            // print("Result", Result)
            
            DateArray = Result.value(forKey: "Date") as! NSArray
            print("DateArray:",DateArray)
            
            StatusArray = Result.value(forKey: "Status") as! NSArray
            print("StatusArray:",StatusArray)
            
            TrackingStatusIdArray = Result.value(forKey: "Id") as! NSArray
            print("TrackingStatusIdArray:",TrackingStatusIdArray)
            
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = getTrackingDetails.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetTrackingDetails"
            ErrorStr = Result
            
            DeviceError()
            
        }
        
       // orderDetailsContent()
    }
    
    func changeViewToArabicInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.text = "تفاصيل الطلبية"
        
        OrderDetailsScrollView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        orderIdLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        orderIdLabel.text = "معرف الطلبية : "
        orderIdLabel.textAlignment = .right
        orderIdNumLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        orderIdNumLabel.textAlignment = .right
        
        orderPlacedLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        orderPlacedLabel.text = "تم تقديم الطلب بتاريخ : "
        orderPlacedLabel.textAlignment = .right
        orderPlacedDateLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        orderPlacedDateLabel.textAlignment = .right
        
        PaymentInfoLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        PaymentInfoLabel.text = " معلومات الدفع"
        PaymentInfoLabel.textAlignment = .right
        
        DressTypeLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        DressTypeLabel.textAlignment = .right
        QtyLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        QtyLabel.text = "كمية : "
        QtyLabel.textAlignment = .right
        QtyNumLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        QtyNumLabel.textAlignment = .right
        PriceLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        PriceLabel.text = "السعر : "
        PriceLabel.textAlignment = .right
        PriceNumLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        PriceNumLabel.textAlignment = .right
        
        SubTotalLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        SubTotalLabel.text = "حاصل الجمع"
        SubTotalPriceLabel.textAlignment = .right
        SubTotalPriceLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        SubTotalPriceLabel.textAlignment = .right
        ShippingLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        ShippingLabel.text = "الشحن والتسليم"
        ShippingLabel.textAlignment = .right
        ShippingPriceLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        ShippingPriceLabel.textAlignment = .right
        TaxLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        TaxLabel.text = "ضريبة"
        TaxLabel.textAlignment = .right
        TaxPriceLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        TaxPriceLabel.textAlignment = .right
        AppointmentLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        AppointmentLabel.text = "رسوم التعيين"
        AppointmentLabel.textAlignment = .right
        AppointmentPriceLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        AppointmentPriceLabel.textAlignment = .right
        TotalLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        TotalLabel.text = "مجموع"
        TotalLabel.textAlignment = .right
        TotalPriceLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        TotalPriceLabel.textAlignment = .right
        PaymentLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        PaymentLabel.text = "نوع الدفع"
        PaymentLabel.textAlignment = .right
        PaymentTypeLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        PaymentTypeLabel.text = "(بطاقة)"
        PaymentTypeLabel.textAlignment = .right
    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.text = "ORDER DETAILS"
        
        OrderDetailsScrollView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        orderIdLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        orderIdLabel.text = "ORDER ID : "
        orderIdLabel.textAlignment = .left
        orderIdNumLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        orderIdNumLabel.textAlignment = .left
        
        orderPlacedLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        orderPlacedLabel.text = "Order Placed On :"
        orderPlacedLabel.textAlignment = .left
        orderPlacedDateLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        orderPlacedDateLabel.textAlignment = .left
        
        PaymentInfoLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        PaymentInfoLabel.text = " PAYMENT INFORMATION"
        PaymentInfoLabel.textAlignment = .left
        
        DressTypeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        DressTypeLabel.textAlignment = .left
        QtyLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        QtyLabel.text = "Qty : "
        QtyLabel.textAlignment = .left
        QtyNumLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        QtyNumLabel.textAlignment = .left
        PriceLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        PriceLabel.text = "Price : "
        PriceLabel.textAlignment = .left
        PriceNumLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        PriceNumLabel.textAlignment = .left
        
        SubTotalLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        SubTotalLabel.text = "Sub Total"
        SubTotalPriceLabel.textAlignment = .left
        SubTotalPriceLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        SubTotalPriceLabel.textAlignment = .left
        ShippingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        ShippingLabel.text = "Shipping & Handling"
        ShippingLabel.textAlignment = .left
        ShippingPriceLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        ShippingPriceLabel.textAlignment = .left
        TaxLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        TaxLabel.text = "Tax"
        TaxLabel.textAlignment = .left
        TaxPriceLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        TaxPriceLabel.textAlignment = .left
        AppointmentLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        AppointmentLabel.text = "Appointment Charges"
        AppointmentLabel.textAlignment = .left
        AppointmentPriceLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        AppointmentPriceLabel.textAlignment = .left
        TotalLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        TotalLabel.text = "Total"
        TotalLabel.textAlignment = .left
        TotalPriceLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        TotalPriceLabel.textAlignment = .left
        PaymentLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        PaymentLabel.text = "Payment Type"
        PaymentLabel.textAlignment = .left
        PaymentTypeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        PaymentTypeLabel.text = "(Card)"
        PaymentTypeLabel.textAlignment = .left
    }
    
    func orderDetailsContent()
    {
        self.stopActivity()
        
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
        selfScreenNavigationTitle.text = "ORDER DETAILS"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationTitle.font = selfScreenNavigationTitle.font.withSize(2 * x)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
       // Scrollview...
        // let OrderDetailsScrollView = UIScrollView()
        OrderDetailsScrollView.frame = CGRect(x: (3 * x), y: selfScreenNavigationBar.frame.maxY + y, width: view.frame.width - (6 * x), height: view.frame.height - (13 * y))
        OrderDetailsScrollView.backgroundColor = UIColor.clear
        OrderDetailsScrollView.contentSize.height = (1.75 * view.frame.height)
        view.addSubview(OrderDetailsScrollView)
        
        
        for views in OrderDetailsScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        // OrderId View..
        let orderIdView = UIView()
        orderIdView.frame = CGRect(x: 0, y: y, width: OrderDetailsScrollView.frame.width, height: (8 * y))
        orderIdView.backgroundColor = UIColor.white
        OrderDetailsScrollView.addSubview(orderIdView)
        
        // Order Id Label..
        orderIdLabel.frame = CGRect(x: x, y: orderIdView.frame.minY, width: (10 * x), height: (2 * x))
       // orderIdLabel.backgroundColor = UIColor.gray
        orderIdLabel.font = UIFont.boldSystemFont(ofSize: 16)
        orderIdLabel.text = "ORDER ID : "
        orderIdLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        orderIdLabel.textColor = UIColor.black
        orderIdLabel.textAlignment = .left
        orderIdView.addSubview(orderIdLabel)
        
        orderIdNumLabel.frame = CGRect(x: orderIdLabel.frame.maxX, y: orderIdView.frame.minY, width: (15 * x), height: (2 * x))
       // orderIdNumLabel.backgroundColor = UIColor.gray
        orderIdNumLabel.font = UIFont.boldSystemFont(ofSize: 16)
       if (OrderId.count > 0)
       {
        let orderIdNum : Int = OrderId[0] as! Int
        orderIdNumLabel.text =  "#\(orderIdNum)"
        }
        else
       {
          orderIdNumLabel.text =  "#"
        }
        orderIdNumLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
         orderIdNumLabel.textColor = UIColor.black
        orderIdNumLabel.textAlignment = .left
        orderIdView.addSubview(orderIdNumLabel)
        
        // Order Placed Label..
        orderPlacedLabel.frame = CGRect(x: x, y: orderIdLabel.frame.maxY + y, width: (13 * x), height: (2 * x))
       // orderPlacedLabel.backgroundColor = UIColor.gray
        orderPlacedLabel.text = "Order Placed On :"
        orderPlacedLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        orderPlacedLabel.textColor = UIColor.black
        orderIdView.addSubview(orderPlacedLabel)
        
        
        orderPlacedDateLabel.frame = CGRect(x: orderPlacedLabel.frame.maxX , y: orderIdLabel.frame.maxY + y, width: (17 * x), height: (2 * x))
       // orderPlacedDateLabel.backgroundColor = UIColor.gray
       if(OrderDt.count > 0)
       {
        if let date = OrderDt[0] as? String
        {
            OrderDate = String(date.prefix(10))
        }
        }
       else
       {
          OrderDate = ""
       }
        orderPlacedDateLabel.text = OrderDate
        orderPlacedDateLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        orderPlacedDateLabel.textColor = UIColor.black
        orderIdView.addSubview(orderPlacedDateLabel)
        
        // PaymentInfo View..
        let PaymentInfoView = UIView()
        PaymentInfoView.frame = CGRect(x: 0, y: orderIdView.frame.maxY + (3 * y), width: OrderDetailsScrollView.frame.width, height: (40 * y))
        PaymentInfoView.backgroundColor = UIColor.groupTableViewBackground
        OrderDetailsScrollView.addSubview(PaymentInfoView)
        
        
         // PaymentInfo Label..
         PaymentInfoLabel.frame = CGRect(x: 0, y: 0, width: PaymentInfoView.frame.width, height: (4 * x))
         PaymentInfoLabel.text = " PAYMENT INFORMATION"
        PaymentInfoLabel.textAlignment = .left
         PaymentInfoLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
         PaymentInfoLabel.font = UIFont(name: "Avenir Next", size: 16)
         PaymentInfoLabel.font = UIFont.boldSystemFont(ofSize: (1.5 * x))
         PaymentInfoLabel.textColor = UIColor.white
         PaymentInfoView.addSubview(PaymentInfoLabel)
        
        let DressImageView = UIImageView()
        DressImageView.frame = CGRect(x: x, y: PaymentInfoLabel.frame.maxY + (2 * y), width: (10 * x), height:(13 * y))
        DressImageView.backgroundColor = UIColor.white
       
     if(Image.count > 0)
     {
        if let imageName = Image[0] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/DressSubType/\(imageName)"
            let apiurl = URL(string: api)
            
          //  print("Image Of Dress", apiurl!)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: DressImageView.frame.width, height: DressImageView.frame.height)
            
            if apiurl != nil
            {
                dummyImageView.dowloadFromServer(url: apiurl!)
            }
            dummyImageView.tag = -1
            DressImageView.addSubview(dummyImageView)
            
          //  DressImageView.dowloadFromServer(url: apiurl!)
        }
     }
     else
     {
        DressImageView.backgroundColor = UIColor.lightGray
     }
        
        PaymentInfoView.addSubview(DressImageView)
        
        // DressType Label..
        DressTypeLabel.frame = CGRect(x: DressImageView.frame.maxX + (2 * x), y: PaymentInfoLabel.frame.maxY + (3 * y) , width: (20 * x), height: (2 * y))
       if(Product_Name.count > 0)
       {
           DressTypeLabel.text = Product_Name[0] as? String
       }
       else
       {
          DressTypeLabel.text = ""
       }
       
        DressTypeLabel.textColor = UIColor.black
        //  DressTypeLabel.backgroundColor = UIColor.gray
        DressTypeLabel.textAlignment = .left
        DressTypeLabel.font = UIFont(name: "Avenir Next", size: 16)
        PaymentInfoView.addSubview(DressTypeLabel)
        
        // Qty Label..
        QtyLabel.frame = CGRect(x: DressImageView.frame.maxX + (2 * x), y: DressTypeLabel.frame.minY + (3 * y), width: (6 * x), height: (2 * y))
        QtyLabel.text = "Qty : "
        QtyLabel.textColor = UIColor.black
        QtyLabel.textAlignment = .left
        QtyLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        PaymentInfoView.addSubview(QtyLabel)
        
        QtyNumLabel.frame = CGRect(x: QtyLabel.frame.minX + (5 * x), y: DressTypeLabel.frame.minY + (3 * y), width: (4 * x), height: (2 * y))
        if(qty.count > 0)
        {
            let QtyNum : Int = qty[0] as! Int
            QtyNumLabel.text =  "\(QtyNum)"
        }
        else
        {
            QtyNumLabel.text = ""
        }
        QtyNumLabel.textColor = UIColor.black
        QtyNumLabel.textAlignment = .left
        QtyNumLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        PaymentInfoView.addSubview(QtyNumLabel)
        
        // Price Label..
        PriceLabel.frame = CGRect(x: DressImageView.frame.maxX + (2 * x), y: QtyLabel.frame.minY + (3 * y), width: (6 * x), height: (2 * y))
        PriceLabel.text = "Price : "
        PriceLabel.textColor = UIColor.black
        PriceLabel.textAlignment = .left
        PriceLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        PaymentInfoView.addSubview(PriceLabel)
        
        PriceNumLabel.frame = CGRect(x: QtyLabel.frame.minX + (5 * x), y: QtyLabel.frame.minY + (3 * y), width: (8 * x), height: (2 * y))
        if(Price.count > 0)
        {
            let PriceNum : Int = Price[0] as! Int
            PriceNumLabel.text = "\(PriceNum)"
        }
        else
        {
            PriceNumLabel.text = ""
        }
        
        PriceNumLabel.textColor = UIColor.black
        PriceNumLabel.textAlignment = .left
        PriceNumLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        PaymentInfoView.addSubview(PriceNumLabel)
        
        
        // Sub-Total Label
        SubTotalLabel.frame = CGRect(x:x, y: DressImageView.frame.maxY + (3 * y), width: (8 * x), height: (2 * y))
        SubTotalLabel.text = "Sub Total"
        SubTotalLabel.textColor = UIColor.black
        SubTotalLabel.textAlignment = .left
        SubTotalLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        SubTotalLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(SubTotalLabel)
        
        
        SubTotalPriceLabel.frame = CGRect(x:SubTotalLabel.frame.maxX + (12 * x), y: DressImageView.frame.maxY + (3 * y), width: (8 * x), height: (2 * y))
        if(Price.count > 0)
        {
            let SubPriceNum : Int = Price[0] as! Int
            SubTotalPriceLabel.text = "\(SubPriceNum)"
        }
        else
        {
            SubTotalPriceLabel.text = ""
        }
        SubTotalPriceLabel.textColor = UIColor.black
        SubTotalPriceLabel.textAlignment = .right
        SubTotalPriceLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        SubTotalPriceLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(SubTotalPriceLabel)
        
        
        // Shipping Label
        ShippingLabel.frame = CGRect(x:x, y: SubTotalLabel.frame.maxY + y, width: (15 * x), height: (2 * y))
        ShippingLabel.text = "Shipping & Handling"
        ShippingLabel.textColor = UIColor.black
        ShippingLabel.textAlignment = .left
        ShippingLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        ShippingLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(ShippingLabel)
        
        
        ShippingPriceLabel.frame = CGRect(x:ShippingLabel.frame.maxX + (5 * x), y: SubTotalPriceLabel.frame.maxY + y, width: (8 * x), height: (2 * y))
        if(ShippingCharges.count > 0)
        {
            ShippingPriceLabel.text = ShippingCharges[0] as? String
        }
        else
        {
            ShippingPriceLabel.text = ""
        }
        ShippingPriceLabel.textColor = UIColor.black
        ShippingPriceLabel.textAlignment = .right
        ShippingPriceLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        ShippingPriceLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(ShippingPriceLabel)
        
        
        // Tax Label
        TaxLabel.frame = CGRect(x:x, y: ShippingLabel.frame.maxY + y, width: (8 * x), height: (2 * y))
        TaxLabel.text = "Tax"
        TaxLabel.textColor = UIColor.black
        TaxLabel.textAlignment = .left
        TaxLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        TaxLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(TaxLabel)
        
    
        TaxPriceLabel.frame = CGRect(x:TaxLabel.frame.maxX + (12 * x), y: ShippingPriceLabel.frame.maxY + y, width: (8 * x), height: (2 * y))
        if(Tax.count > 0)
        {
          // let TaxNum : Int = Tax[0] as! Int
          // TaxPriceLabel.text = "\(TaxNum)"
            TaxPriceLabel.text = Tax[0] as? String
        }
        else
        {
            TaxPriceLabel.text = ""
        }
        TaxPriceLabel.textColor = UIColor.black
        TaxPriceLabel.textAlignment = .right
        TaxPriceLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        TaxPriceLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(TaxPriceLabel)
        
        
        // Appointment Label
        AppointmentLabel.frame = CGRect(x:x, y: TaxLabel.frame.maxY + y, width: (15 * x), height: (2 * y))
        AppointmentLabel.text = "Appointment Charges"
        AppointmentLabel.textColor = UIColor.black
        AppointmentLabel.textAlignment = .left
        AppointmentLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        AppointmentLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(AppointmentLabel)
        
        AppointmentPriceLabel.frame = CGRect(x:AppointmentLabel.frame.maxX + (5 * x), y: TaxPriceLabel.frame.maxY + y, width: (8 * x), height: (2 * y))
        if(Appoinment.count > 0)
        {
        let AppointNum : Int = Appoinment[0] as! Int
        AppointmentPriceLabel.text = "\(AppointNum)"
        }
        else
        {
            AppointmentPriceLabel.text = ""
        }
        AppointmentPriceLabel.textColor = UIColor.black
        AppointmentPriceLabel.textAlignment = .right
        AppointmentPriceLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        AppointmentPriceLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(AppointmentPriceLabel)
        
        
        // Total Label
        TotalLabel.frame = CGRect(x:x, y: AppointmentLabel.frame.maxY + y, width: (15 * x), height: (2 * y))
        TotalLabel.text = "Total"
        TotalLabel.textColor = UIColor.black
        TotalLabel.textAlignment = .left
        TotalLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        TotalLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(TotalLabel)
        
        TotalPriceLabel.frame = CGRect(x:TotalLabel.frame.maxX + (5 * x), y: AppointmentPriceLabel.frame.maxY + y, width: (8 * x), height: (2 * y))
        if(Total.count > 0)
        {
          let TotalNum : Int = Total[0] as! Int
          TotalPriceLabel.text = "\(TotalNum)"
        }
        else
        {
            TotalPriceLabel.text = ""
        }
        TotalPriceLabel.textColor = UIColor.black
        TotalPriceLabel.textAlignment = .right
        TotalPriceLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        TotalPriceLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(TotalPriceLabel)
        
        
        // Payment Type Label
        PaymentLabel.frame = CGRect(x:x, y: TotalLabel.frame.maxY + y, width: (15 * x), height: (2 * y))
        PaymentLabel.text = "Payment Type"
        PaymentLabel.textColor = UIColor.blue
        PaymentLabel.textAlignment = .left
        PaymentLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        PaymentLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(PaymentLabel)
        
        
        PaymentTypeLabel.frame = CGRect(x:PaymentLabel.frame.maxX - (2 * x), y: TotalPriceLabel.frame.maxY + y, width: (15 * x), height: (2 * y))
        PaymentTypeLabel.text = "(Card)"
        PaymentTypeLabel.textColor = UIColor.blue
        PaymentTypeLabel.textAlignment = .right
        PaymentTypeLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        PaymentTypeLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(PaymentTypeLabel)
        
        // Order Status View..
        let OrderStatusView = UIView()
        OrderStatusView.frame = CGRect(x: 0, y: PaymentInfoView.frame.maxY + (3 * y), width: OrderDetailsScrollView.frame.width, height: (18 * y))
        OrderStatusView.backgroundColor = UIColor.white
        OrderDetailsScrollView.addSubview(OrderStatusView)
        
        // Order status Label..
        let OrderStatusLabel = UILabel()
        OrderStatusLabel.frame = CGRect(x: 0, y: 0, width: OrderStatusView.frame.width, height: (4 * x))
        OrderStatusLabel.text = " ORDER STATUS"
        OrderStatusLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        OrderStatusLabel.font = UIFont(name: "Avenir Next", size: (1.5 * x))
        OrderStatusLabel.font = UIFont.boldSystemFont(ofSize: (1.5 * x))
        OrderStatusLabel.textColor = UIColor.white
        OrderStatusView.addSubview(OrderStatusLabel)
        
        
        // Imageview
        let TrackImageView = UIImageView()
        TrackImageView.frame = CGRect(x: (2 * x), y: OrderStatusLabel.frame.maxY + (2 * y), width: x, height:(6 * y))
        TrackImageView.backgroundColor = UIColor.white
        TrackImageView.image = UIImage(named: "TrackingStatus")
        OrderStatusView.addSubview(TrackImageView)
        
        //orderedLabel..
        let orderedLabel = UILabel()
        orderedLabel.frame = CGRect(x: TrackImageView.frame.maxX + (2 * x), y: OrderStatusLabel.frame.minY + (5 * y), width: (20 * x), height: (2 * y))
        orderedLabel.text = "Ordered"
        orderedLabel.textColor = UIColor.black
       // orderedLabel.backgroundColor = UIColor.gray
        orderedLabel.textAlignment = .left
        orderedLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        OrderStatusView.addSubview(orderedLabel)
        
        //DateLabel..
        let DateLabel = UILabel()
        DateLabel.frame = CGRect(x: TrackImageView.frame.maxX + (2 * x), y: orderedLabel.frame.maxY, width: (20 * x), height: (2 * y))
        
        if(OrderDt.count > 0)
        {
            if let date = OrderDt[0] as? String
            {
                OrderDate = String(date.prefix(10))
            }
        }
        else
        {
            OrderDate = ""
        }
        DateLabel.text = OrderDate
        DateLabel.textColor = UIColor.lightGray
       // DateLabel.backgroundColor = UIColor.gray
        DateLabel.textAlignment = .left
        DateLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        OrderStatusView.addSubview(DateLabel)
  
        //PackedLabel..
         let PackedLabel = UILabel()
         PackedLabel.frame = CGRect(x: TrackImageView.frame.maxX + (2 * x), y: DateLabel.frame.maxY + y, width: (20 * x), height: (2 * y))
         PackedLabel.text = "Cloth Recieved"
         PackedLabel.textColor = UIColor.black
        // PackedLabel.backgroundColor = UIColor.gray
        PackedLabel.textAlignment = .left
        PackedLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        OrderStatusView.addSubview(PackedLabel)
        
        //TrackingButton
        let TrackingButton = UIButton()
        TrackingButton.frame = CGRect(x: TrackImageView.frame.maxX, y: DateLabel.frame.maxY + (4 * y), width: (15 * x), height: (2 * y))
        TrackingButton.backgroundColor = UIColor.orange
        TrackingButton.setTitle("Tracking Details", for: .normal)
        TrackingButton.setTitleColor(UIColor.white, for: .normal)
        TrackingButton.titleLabel?.font =  UIFont(name: "Avenir-Regular", size: (1.3 * x))
        TrackingButton.layer.cornerRadius = 10;  // this value vary as per your desire
        TrackingButton.clipsToBounds = true;
        TrackingButton.addTarget(self, action: #selector(self.TrackingButtonAction(sender:)), for: .touchUpInside)
        OrderStatusView.addSubview(TrackingButton)
  
        
        // Delivery Info View..
        let DeliveryInfoView = UIView()
        DeliveryInfoView.frame = CGRect(x: 0, y: OrderStatusView.frame.maxY + (3 * y), width: OrderDetailsScrollView.frame.width, height: (24 * y))
        DeliveryInfoView.backgroundColor = UIColor.white
        OrderDetailsScrollView.addSubview(DeliveryInfoView)
        
        
        // Delivery Info Label..
        let DeliveryInfoLabel = UILabel()
        DeliveryInfoLabel.frame = CGRect(x: 0, y: 0, width: DeliveryInfoView.frame.width, height: (4 * x))
        DeliveryInfoLabel.text = " DELIVERY INFORMATION"
        DeliveryInfoLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        DeliveryInfoLabel.font = UIFont(name: "Avenir Next", size: (1.5 * x))
        DeliveryInfoLabel.font = UIFont.boldSystemFont(ofSize: (1.5 * x))
        DeliveryInfoLabel.textColor = UIColor.white
        DeliveryInfoView.addSubview(DeliveryInfoLabel)
        
        
        let MapImageView = UIImageView()
        MapImageView.frame = CGRect(x: x, y: DeliveryInfoLabel.frame.maxY + (2 * y), width: (5 * x), height:(4 * y))
        MapImageView.backgroundColor = UIColor.white
        MapImageView.image = UIImage(named: "locationMarker")
        DeliveryInfoView.addSubview(MapImageView)
        
        // Name Label..
        let NameLabel = UILabel()
        NameLabel.frame = CGRect(x: MapImageView.frame.maxX + (2 * x), y: DeliveryInfoLabel.frame.maxY + (2 * y) , width: (20 * x), height: (2 * y))
       if(FirstName.count > 0)
       {
          NameLabel.text = FirstName[0] as? String
        }
        else
       {
          NameLabel.text = ""
        }
        NameLabel.textColor = UIColor.black
       // NameLabel.backgroundColor = UIColor.gray
        NameLabel.textAlignment = .left
        NameLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        DeliveryInfoView.addSubview(NameLabel)
        
        // Floor Label..
        let FloorLabel = UILabel()
        FloorLabel.frame = CGRect(x: MapImageView.frame.maxX + (2 * x), y: NameLabel.frame.maxY + y , width: (20 * x), height: (2 * y))
        if(Floor.count > 0)
        {
            FloorLabel.text = Floor[0] as? String
        }
        else
        {
            FloorLabel.text = ""
        }
        
        FloorLabel.textColor = UIColor.black
       // FloorLabel.backgroundColor = UIColor.gray
        FloorLabel.textAlignment = .left
        FloorLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        DeliveryInfoView.addSubview(FloorLabel)
        
        //Area Label..
        let AreaLabel = UILabel()
        AreaLabel.frame = CGRect(x: MapImageView.frame.maxX + (2 * x), y: FloorLabel.frame.maxY + y , width: (20 * x), height: (2 * y))
        if(Area.count > 0)
        {
             AreaLabel.text = Area[0] as? String
        }
        else
        {
            AreaLabel.text = ""
        }
       
        AreaLabel.textColor = UIColor.black
        //AreaLabel.backgroundColor = UIColor.gray
        AreaLabel.textAlignment = .left
        AreaLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        DeliveryInfoView.addSubview(AreaLabel)
        
        //State Label..
        let StateLabel = UILabel()
        StateLabel.frame = CGRect(x: MapImageView.frame.maxX + (2 * x), y: AreaLabel.frame.maxY + y , width: (20 * x), height: (2 * y))
        if(StateName.count > 0)
        {
           StateLabel.text = StateName[0] as? String
        }
        else
        {
            StateLabel.text = ""
        }
        
        StateLabel.textColor = UIColor.black
        //StateLabel.backgroundColor = UIColor.gray
        StateLabel.textAlignment = .left
        StateLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        DeliveryInfoView.addSubview(StateLabel)
        
        //Country Label..
        let CountryLabel = UILabel()
        CountryLabel.frame = CGRect(x: MapImageView.frame.maxX + (2 * x), y: StateLabel.frame.maxY + y , width: (20 * x), height: (2 * y))
        if(Country_Name.count > 0)
        {
            CountryLabel.text = Country_Name[0] as? String
        }
        else
        {
            CountryLabel.text = ""
        }
        
        CountryLabel.textColor = UIColor.black
        //CountryLabel.backgroundColor = UIColor.gray
        CountryLabel.textAlignment = .left
        CountryLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        DeliveryInfoView.addSubview(CountryLabel)
        
        //PhoneNum Label..
        let PhoneNumLabel = UILabel()
        PhoneNumLabel.frame = CGRect(x: MapImageView.frame.maxX + (2 * x), y: CountryLabel.frame.maxY + y , width: (20 * x), height: (2 * y))
        if(PhoneNo.count > 0)
        {
            PhoneNumLabel.text = PhoneNo[0] as? String
        }
        else
        {
            PhoneNumLabel.text = ""
        }
        
        PhoneNumLabel.textColor = UIColor.black
        //PhoneNumLabel.backgroundColor = UIColor.gray
        PhoneNumLabel.textAlignment = .left
        PhoneNumLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        DeliveryInfoView.addSubview(PhoneNumLabel)
        
        OrderDetailsScrollView.contentSize.height = DeliveryInfoView.frame.maxY + (2 * y)
        
        
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
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func TrackingButtonAction(sender : UIButton)
    {
        print("Tracking ViewController")
        
          let TrackingScreen = TrackingViewController()
          TrackingScreen.OrderID = OrderID!
          self.navigationController?.pushViewController(TrackingScreen, animated: true)
    }
    
}
