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
    let ServiceLabel = UILabel()
    let ServiceTypeLabel = UILabel()
    
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
    var Product_Name_Arabic = NSArray()
    var ServiceType = NSArray()
    var qty = NSArray()
    var ServiceTypeinArabic = NSArray()
    
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
            
            Product_Name_Arabic = OrderDetail.value(forKey: "NameInArabic") as! NSArray
            print("Product_Name_Arabic:",Product_Name_Arabic)
            
            qty = OrderDetail.value(forKey: "qty") as! NSArray
            print("qty:",qty)
            
            ServiceType = OrderDetail.value(forKey: "ServiceType") as! NSArray
            print("ServiceType:",ServiceType)
            
            ServiceTypeinArabic = OrderDetail.value(forKey: "ServiceTypeInArabic") as! NSArray
            print("ServiceTypeinArabic:",ServiceTypeinArabic)
            
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
        SubTotalPriceLabel.textAlignment = .left
        ShippingLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        ShippingLabel.text = "الشحن والتسليم"
        ShippingLabel.textAlignment = .right
        ShippingPriceLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        ShippingPriceLabel.textAlignment = .left
        TaxLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        TaxLabel.text = "ضريبة"
        TaxLabel.textAlignment = .right
        TaxPriceLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        TaxPriceLabel.textAlignment = .left
        AppointmentLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        AppointmentLabel.text = "رسوم التعيين"
        AppointmentLabel.textAlignment = .right
        AppointmentPriceLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        AppointmentPriceLabel.textAlignment = .left
        TotalLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        TotalLabel.text = "مجموع"
        TotalLabel.textAlignment = .right
        TotalPriceLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        TotalPriceLabel.textAlignment = .left
        ServiceLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        ServiceLabel.text = "نوع الخدمة"
        ServiceLabel.textAlignment = .right
        ServiceTypeLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        ServiceTypeLabel.textAlignment = .left
        PaymentLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        PaymentLabel.text = "نوع الدفع"
        PaymentLabel.textAlignment = .right
        PaymentTypeLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        PaymentTypeLabel.text = "(بطاقة)"
        PaymentTypeLabel.textAlignment = .left
    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.text = "ORDER DETAILS"
        
        OrderDetailsScrollView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        orderIdLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        orderIdLabel.text = "ORDER ID      :"
        orderIdLabel.textAlignment = .left
        orderIdNumLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        orderIdNumLabel.textAlignment = .left
        
        orderPlacedLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        orderPlacedLabel.text = "Order Placed On  :"
        orderPlacedLabel.textAlignment = .left
        orderPlacedDateLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        orderPlacedDateLabel.textAlignment = .left
        
        PaymentInfoLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        PaymentInfoLabel.text = " PAYMENT INFORMATION"
        PaymentInfoLabel.textAlignment = .left
        
        DressTypeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        DressTypeLabel.textAlignment = .left
        QtyLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        QtyLabel.text = "Qty    : "
        QtyLabel.textAlignment = .left
        QtyNumLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        QtyNumLabel.textAlignment = .left
        PriceLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        PriceLabel.text = "Price  : "
        PriceLabel.textAlignment = .left
        PriceNumLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        PriceNumLabel.textAlignment = .left
        
        SubTotalLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        SubTotalLabel.text = "Sub Total"
        SubTotalPriceLabel.textAlignment = .left
        SubTotalPriceLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        SubTotalPriceLabel.textAlignment = .right
        ShippingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        ShippingLabel.text = "Shipping & Handling"
        ShippingLabel.textAlignment = .left
        ShippingPriceLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        ShippingPriceLabel.textAlignment = .right
        TaxLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        TaxLabel.text = "Tax"
        TaxLabel.textAlignment = .left
        TaxPriceLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        TaxPriceLabel.textAlignment = .right
        AppointmentLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        AppointmentLabel.text = "Appointment Charges"
        AppointmentLabel.textAlignment = .left
        AppointmentPriceLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        AppointmentPriceLabel.textAlignment = .right
        TotalLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        TotalLabel.text = "Total"
        TotalLabel.textAlignment = .left
        TotalPriceLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        TotalPriceLabel.textAlignment = .right
        ServiceLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        ServiceLabel.text = "Service Type"
        ServiceLabel.textAlignment = .left
        ServiceTypeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        ServiceTypeLabel.textAlignment = .right
        PaymentLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        PaymentLabel.text = "Payment Type"
        PaymentLabel.textAlignment = .left
        PaymentTypeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        PaymentTypeLabel.text = "(Card)"
        PaymentTypeLabel.textAlignment = .right
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
        orderIdView.frame = CGRect(x: 0, y: y, width: OrderDetailsScrollView.frame.width, height: (6 * y))
        orderIdView.backgroundColor = UIColor.white
        orderIdView.layer.borderWidth = 1.0
        orderIdView.layer.borderColor = UIColor.lightGray.cgColor
        OrderDetailsScrollView.addSubview(orderIdView)
        
        // Order Id Label..
        orderIdLabel.frame = CGRect(x: x, y: orderIdView.frame.minY, width: (13 * x), height: (2 * x))
       // orderIdLabel.backgroundColor = UIColor.gray
        orderIdLabel.font = UIFont.boldSystemFont(ofSize: 16)
        orderIdLabel.text = "ORDER ID              :"
        orderIdLabel.font = UIFont(name: "Avenir Next", size: (1.6 * x))
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
          orderIdNumLabel.text =  "#0"
        }
        orderIdNumLabel.font = UIFont(name: "Avenir Next", size: (1.6 * x))
         orderIdNumLabel.textColor = UIColor.black
        orderIdNumLabel.textAlignment = .left
        orderIdView.addSubview(orderIdNumLabel)
        
        // Order Placed Label..
        orderPlacedLabel.frame = CGRect(x: x, y: orderIdLabel.frame.maxY + y, width: (13 * x), height: (2 * x))
       // orderPlacedLabel.backgroundColor = UIColor.gray
        orderPlacedLabel.text = "Order Placed On :"
        orderPlacedLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
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
          OrderDate = "0"
       }
        orderPlacedDateLabel.text = OrderDate
        orderPlacedDateLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
        orderPlacedDateLabel.textColor = UIColor.black
        orderIdView.addSubview(orderPlacedDateLabel)
        
        
        // PaymentInfo Label..
        PaymentInfoLabel.frame = CGRect(x: 0, y: orderIdView.frame.maxY + (2 * y), width: orderIdView.frame.width, height: (2 * x))
        PaymentInfoLabel.text = " PAYMENT INFORMATION"
        PaymentInfoLabel.textAlignment = .left
        PaymentInfoLabel.backgroundColor = UIColor.clear
        PaymentInfoLabel.font = UIFont(name: "Avenir Next", size: 14)
        PaymentInfoLabel.font = UIFont.boldSystemFont(ofSize: (1.4 * x))
        PaymentInfoLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        OrderDetailsScrollView.addSubview(PaymentInfoLabel)
        
        // PaymentUnderLine..
        let PaymentUnderLine = UILabel()
        PaymentUnderLine.frame = CGRect(x: 0, y: PaymentInfoLabel.frame.maxY, width: orderIdView.frame.width , height: 0.3)
        PaymentUnderLine.backgroundColor = UIColor.lightGray
        OrderDetailsScrollView.addSubview(PaymentUnderLine)
        
        // PaymentInfo View..
        let PaymentInfoView = UIView()
        PaymentInfoView.frame = CGRect(x: 0, y: PaymentUnderLine.frame.maxY + y/2, width: OrderDetailsScrollView.frame.width, height: (24 * y))
        PaymentInfoView.backgroundColor = UIColor.groupTableViewBackground
        PaymentInfoView.layer.borderWidth = 1.0
        PaymentInfoView.layer.borderColor = UIColor.lightGray.cgColor
        OrderDetailsScrollView.addSubview(PaymentInfoView)
        
        // ProductInfo View..
        let ProductInfoView = UIView()
        ProductInfoView.frame = CGRect(x: x, y: y, width: OrderDetailsScrollView.frame.width - (2 * x), height: (8 * y))
        ProductInfoView.backgroundColor = UIColor.white
        ProductInfoView.layer.borderWidth = 1.0
        ProductInfoView.layer.borderColor = UIColor.lightGray.cgColor
        PaymentInfoView.addSubview(ProductInfoView)
       
        let DressImageView = UIImageView()
        
      //  DressImageView.frame = CGRect(x: x, y: y, width: (6 * x), height:(6 * y))
        
        DressImageView.frame = CGRect(x: x, y: y, width: (6 * y), height: (6 * y))
        DressImageView.backgroundColor = UIColor.white
        DressImageView.layer.cornerRadius = DressImageView.frame.height / 2
        DressImageView.layer.borderWidth = 1
        DressImageView.layer.borderColor = UIColor.lightGray.cgColor
        DressImageView.layer.masksToBounds = true
       
       
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
        
        ProductInfoView.addSubview(DressImageView)
        
        // Straight Line..
        let StraightLine = UILabel()
        StraightLine.frame = CGRect(x: DressImageView.frame.maxX + x, y: 0, width: 0.3, height: ProductInfoView.frame.height)
        StraightLine.backgroundColor = UIColor.lightGray
        ProductInfoView.addSubview(StraightLine)
        
        
        // DressType Label..
        DressTypeLabel.frame = CGRect(x: StraightLine.frame.maxX + x, y: y , width: (20 * x), height: (2 * y))
       if(Product_Name.count > 0)
       {
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                DressTypeLabel.text = Product_Name[0] as? String
            }
            else if language == "ar"
            {
                DressTypeLabel.text = Product_Name_Arabic[0] as? String
            }
        }
        else
        {
            DressTypeLabel.text = Product_Name[0] as? String
        }
       }
       else
       {
          DressTypeLabel.text = ""
       }
       
        DressTypeLabel.textColor = UIColor.black
        //  DressTypeLabel.backgroundColor = UIColor.gray
        DressTypeLabel.textAlignment = .left
        DressTypeLabel.font = UIFont(name: "Avenir Next", size: 16)
        ProductInfoView.addSubview(DressTypeLabel)
        
        // Qty Label..
        QtyLabel.frame = CGRect(x: StraightLine.frame.maxX + x, y: DressTypeLabel.frame.minY + (2 * y), width: (6 * x), height: (2 * y))
        QtyLabel.text = "Qty : "
        QtyLabel.textColor = UIColor.black
        QtyLabel.textAlignment = .left
        QtyLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        ProductInfoView.addSubview(QtyLabel)
        
        QtyNumLabel.frame = CGRect(x: QtyLabel.frame.maxX, y: DressTypeLabel.frame.minY + (2 * y), width: (4 * x), height: (2 * y))
        if(qty.count > 0)
        {
            let QtyNum : Int = qty[0] as! Int
            QtyNumLabel.text =  "\(QtyNum)"
        }
        else
        {
            QtyNumLabel.text = "0"
        }
        QtyNumLabel.textColor = UIColor.black
        QtyNumLabel.textAlignment = .left
        QtyNumLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        ProductInfoView.addSubview(QtyNumLabel)
        
        // Price Label..
        PriceLabel.frame = CGRect(x: StraightLine.frame.maxX + x, y: QtyLabel.frame.minY + (2 * y), width: (6 * x), height: (2 * y))
        PriceLabel.text = "Price : "
        PriceLabel.textColor = UIColor.black
        PriceLabel.textAlignment = .left
        PriceLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        ProductInfoView.addSubview(PriceLabel)
        
        PriceNumLabel.frame = CGRect(x: PriceLabel.frame.maxX, y: QtyLabel.frame.minY + (2 * y), width: (8 * x), height: (2 * y))
        if(Price.count > 0)
        {
            let PriceNum : Int = Price[0] as! Int
            PriceNumLabel.text = "\(PriceNum) AED"
        }
        else
        {
            PriceNumLabel.text = "0"
        }
        
        PriceNumLabel.textColor = UIColor.black
        PriceNumLabel.textAlignment = .left
        PriceNumLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        ProductInfoView.addSubview(PriceNumLabel)
        
        
        // Sub-Total Label
//        let SubTotalLabel = UILabel()
        SubTotalLabel.frame = CGRect(x: x, y: ProductInfoView.frame.maxY + y/2 , width: (8 * x), height: (2 * y))
        SubTotalLabel.text = "Sub Total"
        SubTotalLabel.textColor = UIColor.black
        SubTotalLabel.textAlignment = .left
        SubTotalLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
        SubTotalLabel.font = UIFont.boldSystemFont(ofSize: (1.2 * x))
        PaymentInfoView.addSubview(SubTotalLabel)
        
        
//        let SubTotalPriceLabel = UILabel()
        SubTotalPriceLabel.frame = CGRect(x:SubTotalLabel.frame.maxX + (12 * x), y: ProductInfoView.frame.maxY + y/2, width: (8 * x), height: (2 * y))
        if(Price.count > 0)
        {
            let SubPriceNum : Int = Price[0] as! Int
            SubTotalPriceLabel.text = "\(SubPriceNum) AED"
        }
        else
        {
            SubTotalPriceLabel.text = "0 AED"
        }
        SubTotalPriceLabel.textColor = UIColor.black
        SubTotalPriceLabel.textAlignment = .right
        SubTotalPriceLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
        SubTotalPriceLabel.font = UIFont.boldSystemFont(ofSize: (1.2 * x))
        PaymentInfoView.addSubview(SubTotalPriceLabel)
        
        // UnderLine1..
        let underLine1 = UILabel()
        underLine1.frame = CGRect(x: 0, y: SubTotalLabel.frame.maxY, width: PaymentInfoView.frame.width, height: 0.3)
        underLine1.backgroundColor = UIColor.lightGray
        PaymentInfoView.addSubview(underLine1)
        
        // Shipping Label
//        let ShippingLabel = UILabel()
        ShippingLabel.frame = CGRect(x:x, y: SubTotalLabel.frame.maxY, width: (15 * x), height: (2 * y))
        ShippingLabel.text = "Shipping & Handling"
        ShippingLabel.textColor = UIColor.black
        ShippingLabel.textAlignment = .left
        ShippingLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
        ShippingLabel.font = UIFont.boldSystemFont(ofSize: (1.2 * x))
        PaymentInfoView.addSubview(ShippingLabel)
        
//        let ShippingPriceLabel = UILabel()
        ShippingPriceLabel.frame = CGRect(x:ShippingLabel.frame.maxX + (5 * x), y: SubTotalPriceLabel.frame.maxY, width: (8 * x), height: (2 * y))
        if(ShippingCharges.count > 0)
        {
            ShippingPriceLabel.text = "0 AED"  //ShippingCharges[0] as? String
        }
        else
        {
            ShippingPriceLabel.text = "0 AED"
        }
        ShippingPriceLabel.textColor = UIColor.black
        ShippingPriceLabel.textAlignment = .right
        ShippingPriceLabel.font = UIFont(name: "Avenir Next", size: (2.3 * x))
        ShippingPriceLabel.font = UIFont.boldSystemFont(ofSize: (1.2 * x))
        PaymentInfoView.addSubview(ShippingPriceLabel)
        
        // UnderLine2..
        let UnderLine2 = UILabel()
        UnderLine2.frame = CGRect(x: 0, y: ShippingLabel.frame.maxY, width: PaymentInfoView.frame.width, height: 0.3)
        UnderLine2.backgroundColor = UIColor.lightGray
        PaymentInfoView.addSubview(UnderLine2)
        
        // Tax Label
//        let TaxLabel = UILabel()
        TaxLabel.frame = CGRect(x:x, y: ShippingLabel.frame.maxY, width: (8 * x), height: (2 * y))
        TaxLabel.text = "Tax"
        TaxLabel.textColor = UIColor.black
        TaxLabel.textAlignment = .left
        TaxLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
        TaxLabel.font = UIFont.boldSystemFont(ofSize: (1.2 * x))
        PaymentInfoView.addSubview(TaxLabel)
        
//        let TaxPriceLabel = UILabel()
        TaxPriceLabel.frame = CGRect(x:TaxLabel.frame.maxX + (12 * x), y: ShippingPriceLabel.frame.maxY, width: (8 * x), height: (2 * y))
        if(Tax.count > 0)
        {
          // let TaxNum : Int = Tax[0] as! Int
          // TaxPriceLabel.text = "\(TaxNum)"
            TaxPriceLabel.text = "0 AED"  //Tax[0] as? String
        }
        else
        {
            TaxPriceLabel.text = "0 AED"
        }
        TaxPriceLabel.textColor = UIColor.black
        TaxPriceLabel.textAlignment = .right
        TaxPriceLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
        TaxPriceLabel.font = UIFont.boldSystemFont(ofSize: (1.2 * x))
        PaymentInfoView.addSubview(TaxPriceLabel)
        
        // UnderLine3..
        let UnderLine3 = UILabel()
        UnderLine3.frame = CGRect(x: 0, y: TaxLabel.frame.maxY, width: PaymentInfoView.frame.width, height: 0.3)
        UnderLine3.backgroundColor = UIColor.lightGray
        PaymentInfoView.addSubview(UnderLine3)
        
        // Appointment Label
//        let AppointmentLabel = UILabel()
        AppointmentLabel.frame = CGRect(x:x, y: TaxLabel.frame.maxY, width: (15 * x), height: (2 * y))
        AppointmentLabel.text = "Appointment Charges"
        AppointmentLabel.textColor = UIColor.black
        AppointmentLabel.textAlignment = .left
        AppointmentLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
        AppointmentLabel.font = UIFont.boldSystemFont(ofSize: (1.2 * x))
        PaymentInfoView.addSubview(AppointmentLabel)
        
//        let AppointmentPriceLabel = UILabel()
        AppointmentPriceLabel.frame = CGRect(x:AppointmentLabel.frame.maxX + (5 * x), y: TaxPriceLabel.frame.maxY, width: (8 * x), height: (2 * y))
        if(Appoinment.count > 0)
        {
            /*
            let AppointNum : Int = Appoinment[0] as! Int
            AppointmentPriceLabel.text = "\(AppointNum)"
          */
            AppointmentPriceLabel.text = "0 AED"
        }
        else
        {
            AppointmentPriceLabel.text = "0 AED"
        }
        AppointmentPriceLabel.textColor = UIColor.black
        AppointmentPriceLabel.textAlignment = .right
        AppointmentPriceLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
        AppointmentPriceLabel.font = UIFont.boldSystemFont(ofSize: (1.2 * x))
        PaymentInfoView.addSubview(AppointmentPriceLabel)
        
        // UnderLine4..
        let UnderLine4 = UILabel()
        UnderLine4.frame = CGRect(x: 0, y: AppointmentLabel.frame.maxY, width: PaymentInfoView.frame.width, height: 0.3)
        UnderLine4.backgroundColor = UIColor.lightGray
        PaymentInfoView.addSubview(UnderLine4)
        
        // Total Label
//        let TotalLabel = UILabel()
        TotalLabel.frame = CGRect(x:x, y: AppointmentLabel.frame.maxY, width: (15 * x), height: (2 * y))
        TotalLabel.text = "Total"
        TotalLabel.textColor = UIColor.black
        TotalLabel.textAlignment = .left
        TotalLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
        TotalLabel.font = UIFont.boldSystemFont(ofSize: (1.2 * x))
        PaymentInfoView.addSubview(TotalLabel)
        
//        let TotalPriceLabel = UILabel()
        TotalPriceLabel.frame = CGRect(x:TotalLabel.frame.maxX + (5 * x), y: AppointmentPriceLabel.frame.maxY, width: (8 * x), height: (2 * y))
        if(Total.count > 0)
        {
          /*
            let TotalNum : Int = Total[0] as! Int
            TotalPriceLabel.text = "\(TotalNum)"
          */
            
            let SubPriceNum : Int = Price[0] as! Int
            TotalPriceLabel.text = "\(SubPriceNum) AED"
        }
        else
        {
            TotalPriceLabel.text = "0 AED"
        }
        TotalPriceLabel.textColor = UIColor.black
        TotalPriceLabel.textAlignment = .right
        TotalPriceLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
        TotalPriceLabel.font = UIFont.boldSystemFont(ofSize: (1.2 * x))
        PaymentInfoView.addSubview(TotalPriceLabel)
        
        // UnderLine5..
        let UnderLine5 = UILabel()
        UnderLine5.frame = CGRect(x: 0, y: TotalLabel.frame.maxY, width: PaymentInfoView.frame.width, height: 0.3)
        UnderLine5.backgroundColor = UIColor.lightGray
        PaymentInfoView.addSubview(UnderLine5)
        
        
        // Service Type Label
        //        let ServiceLabel = UILabel()
        ServiceLabel.frame = CGRect(x:x, y: TotalLabel.frame.maxY, width: (15 * x), height: (2 * y))
        ServiceLabel.text = "Service Type"
        ServiceLabel.textColor = UIColor.black
        ServiceLabel.textAlignment = .left
        ServiceLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
        ServiceLabel.font = UIFont.boldSystemFont(ofSize: (1.2 * x))
        PaymentInfoView.addSubview(ServiceLabel)
        
        //        let ServiceTypeLabel = UILabel()
        ServiceTypeLabel.frame = CGRect(x:ServiceLabel.frame.maxX - (2 * x), y: TotalPriceLabel.frame.maxY, width: (15 * x), height: (2 * y))
        if(ServiceType.count > 0)
        {
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    ServiceTypeLabel.text = ServiceType[0] as? String
                }
                else if language == "ar"
                {
                    ServiceTypeLabel.text = ServiceTypeinArabic[0] as? String
                }
            }
            else
            {
                ServiceTypeLabel.text = ServiceType[0] as? String
            }
        }
        else
        {
            ServiceTypeLabel.text = ""
        }
        ServiceTypeLabel.textColor = UIColor.black
        ServiceTypeLabel.textAlignment = .right
        ServiceTypeLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
        ServiceTypeLabel.font = UIFont.boldSystemFont(ofSize: (1.2 * x))
        PaymentInfoView.addSubview(ServiceTypeLabel)
        
        // UnderLine6..
        let UnderLine6 = UILabel()
        UnderLine6.frame = CGRect(x: 0, y: ServiceLabel.frame.maxY, width: PaymentInfoView.frame.width, height: 0.3)
        UnderLine6.backgroundColor = UIColor.lightGray
        PaymentInfoView.addSubview(UnderLine6)
        
        // Payment Type Label
//        let PaymentLabel = UILabel()
        PaymentLabel.frame = CGRect(x:x, y: ServiceLabel.frame.maxY, width: (15 * x), height: (2 * y))
        PaymentLabel.text = "Payment Type"
        PaymentLabel.textColor = UIColor.blue
        PaymentLabel.textAlignment = .left
        PaymentLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
        PaymentLabel.font = UIFont.boldSystemFont(ofSize: (1.2 * x))
        PaymentInfoView.addSubview(PaymentLabel)
        
//        let PaymentTypeLabel = UILabel()
        PaymentTypeLabel.frame = CGRect(x:PaymentLabel.frame.maxX - (2 * x), y: ServiceTypeLabel.frame.maxY, width: (15 * x), height: (2 * y))
        PaymentTypeLabel.text = "(Card)"
        PaymentTypeLabel.textColor = UIColor.blue
        PaymentTypeLabel.textAlignment = .right
        PaymentTypeLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
        PaymentTypeLabel.font = UIFont.boldSystemFont(ofSize: (1.2 * x))
        PaymentInfoView.addSubview(PaymentTypeLabel)
        
        
        // Order status Label..
        let OrderStatusLabel = UILabel()
        OrderStatusLabel.frame = CGRect(x: 0, y: PaymentInfoView.frame.maxY + (2 * y), width: PaymentInfoView.frame.width, height: (2 * x))
        OrderStatusLabel.text = " ORDER STATUS"
        OrderStatusLabel.backgroundColor = UIColor.clear
        OrderStatusLabel.font = UIFont(name: "Avenir Next", size: (1.4 * x))
        OrderStatusLabel.font = UIFont.boldSystemFont(ofSize: (1.4 * x))
        OrderStatusLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        OrderStatusLabel.textAlignment = .left
        OrderDetailsScrollView.addSubview(OrderStatusLabel)
        
        // OrderUnderLine..
        let OrderUnderLine = UILabel()
        OrderUnderLine.frame = CGRect(x: 0, y: OrderStatusLabel.frame.maxY, width: PaymentInfoView.frame.width , height: 0.3)
        OrderUnderLine.backgroundColor = UIColor.lightGray
        OrderDetailsScrollView.addSubview(OrderUnderLine)
        
        // Order Status View..
        let OrderStatusView = UIView()
        OrderStatusView.frame = CGRect(x: 0, y: OrderUnderLine.frame.maxY + y/2, width: OrderDetailsScrollView.frame.width, height: (12 * y))
        OrderStatusView.backgroundColor = UIColor.white
        OrderStatusView.layer.borderWidth = 1.0
        OrderStatusView.layer.borderColor = UIColor.lightGray.cgColor
        OrderDetailsScrollView.addSubview(OrderStatusView)
        
        
        // Imageview
        let TrackImageView = UIImageView()
        TrackImageView.frame = CGRect(x: (2 * x), y: (2 * y), width: x, height:(5 * y))
        TrackImageView.backgroundColor = UIColor.white
        TrackImageView.image = UIImage(named: "TrackingStatus")
        OrderStatusView.addSubview(TrackImageView)
        
        //orderedLabel..
        let orderedLabel = UILabel()
        orderedLabel.frame = CGRect(x: TrackImageView.frame.maxX + (2 * x), y: (2 * y), width: (20 * x), height: y)
        orderedLabel.text = "Order Placed"
        orderedLabel.textColor = UIColor.black
       // orderedLabel.backgroundColor = UIColor.gray
        orderedLabel.textAlignment = .left
        orderedLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        OrderStatusView.addSubview(orderedLabel)
        
        //DateLabel..
        let DateLabel = UILabel()
        DateLabel.frame = CGRect(x: TrackImageView.frame.maxX + (2 * x), y: orderedLabel.frame.maxY + y/2, width: (20 * x), height: y)
        
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
         PackedLabel.frame = CGRect(x: TrackImageView.frame.maxX + (2 * x), y: DateLabel.frame.maxY + (2 * y), width: (20 * x), height: y)
         PackedLabel.text = "Cloth Recieved"
         PackedLabel.textColor = UIColor.black
        // PackedLabel.backgroundColor = UIColor.gray
        PackedLabel.textAlignment = .left
        PackedLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        OrderStatusView.addSubview(PackedLabel)
        
        //TrackingButton
        let TrackingButton = UIButton()
        TrackingButton.frame = CGRect(x: TrackImageView.frame.maxX, y: DateLabel.frame.maxY + (4 * y), width: (15 * x), height: (2.5 * y))
        TrackingButton.backgroundColor = UIColor.orange
        TrackingButton.setTitle("Tracking Details", for: .normal)
        TrackingButton.setTitleColor(UIColor.white, for: .normal)
        TrackingButton.titleLabel?.font =  UIFont(name: "Avenir-Regular", size: (1.3 * x))
        TrackingButton.layer.cornerRadius = 10;  // this value vary as per your desire
        TrackingButton.clipsToBounds = true;
        TrackingButton.addTarget(self, action: #selector(self.TrackingButtonAction(sender:)), for: .touchUpInside)
        OrderStatusView.addSubview(TrackingButton)
  
       
        // Delivery Info Label..
        let DeliveryInfoLabel = UILabel()
        DeliveryInfoLabel.frame = CGRect(x: 0, y: OrderStatusView.frame.maxY + (2 * y), width: OrderStatusView.frame.width, height: (2 * x))
        DeliveryInfoLabel.text = " DELIVERY INFORMATION"
        DeliveryInfoLabel.backgroundColor = UIColor.clear
        DeliveryInfoLabel.font = UIFont(name: "Avenir Next", size: (1.4 * x))
        DeliveryInfoLabel.font = UIFont.boldSystemFont(ofSize: (1.4 * x))
        DeliveryInfoLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        DeliveryInfoLabel.textAlignment = .left
        OrderDetailsScrollView.addSubview(DeliveryInfoLabel)
        
        // DeliveryUnderLine..
        let DeliveryUnderLine = UILabel()
        DeliveryUnderLine.frame = CGRect(x: 0, y: DeliveryInfoLabel.frame.maxY, width: OrderStatusView.frame.width , height: 0.3)
        DeliveryUnderLine.backgroundColor = UIColor.lightGray
        OrderDetailsScrollView.addSubview(DeliveryUnderLine)
        
        // Delivery Info View..
        let DeliveryInfoView = UIView()
        DeliveryInfoView.frame = CGRect(x: 0, y: DeliveryUnderLine.frame.maxY + y/2, width: OrderDetailsScrollView.frame.width, height: (14 * y))
        DeliveryInfoView.backgroundColor = UIColor.white
        DeliveryInfoView.layer.borderWidth = 1.0
        DeliveryInfoView.layer.borderColor = UIColor.lightGray.cgColor
        OrderDetailsScrollView.addSubview(DeliveryInfoView)
        
        
        let MapImageView = UIImageView()
        MapImageView.frame = CGRect(x: x, y: (2 * y), width: (4 * x), height:(3 * y))
        MapImageView.backgroundColor = UIColor.white
        MapImageView.image = UIImage(named: "locationMarker")
        DeliveryInfoView.addSubview(MapImageView)
        
        // Name Label..
        let NameLabel = UILabel()
        NameLabel.frame = CGRect(x: MapImageView.frame.maxX + (2 * x), y: y , width: (20 * x), height: (2 * y))
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
        FloorLabel.frame = CGRect(x: MapImageView.frame.maxX + (2 * x), y: NameLabel.frame.maxY, width: (20 * x), height: (2 * y))
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
        AreaLabel.frame = CGRect(x: MapImageView.frame.maxX + (2 * x), y: FloorLabel.frame.maxY, width: (20 * x), height: (2 * y))
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
        StateLabel.frame = CGRect(x: MapImageView.frame.maxX + (2 * x), y: AreaLabel.frame.maxY, width: (20 * x), height: (2 * y))
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
        CountryLabel.frame = CGRect(x: MapImageView.frame.maxX + (2 * x), y: StateLabel.frame.maxY, width: (20 * x), height: (2 * y))
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
        PhoneNumLabel.frame = CGRect(x: MapImageView.frame.maxX + (2 * x), y: CountryLabel.frame.maxY, width: (20 * x), height: (2 * y))
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
                OrderStatusLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                OrderStatusLabel.text = " ORDER STATUS"
                OrderStatusLabel.textAlignment = .left
                
                orderedLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                orderedLabel.text = "Order Placed"
                orderedLabel.textAlignment = .left
                
                PackedLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                PackedLabel.text = "Cloth Recieved"
                PackedLabel.textAlignment = .left
                
                TrackingButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                TrackingButton.setTitle("Tracking Details", for: .normal)
                
                DeliveryInfoLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                DeliveryInfoLabel.text = " DELIVERY INFORMATION"
                DeliveryInfoLabel.textAlignment = .left
                
                MapImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                NameLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                NameLabel.textAlignment = .left
                
                FloorLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                FloorLabel.textAlignment = .left

                AreaLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                AreaLabel.textAlignment = .left

                StateLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                StateLabel.textAlignment = .left

                CountryLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                CountryLabel.textAlignment = .left

                PhoneNumLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                PhoneNumLabel.textAlignment = .left

                changeViewToEnglishInSelf()
            }
            else if language == "ar"
            {
                OrderStatusLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                OrderStatusLabel.text = " حالة الطلب"
                OrderStatusLabel.textAlignment = .right
                
                orderedLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                orderedLabel.text = "وصف دواء"
                orderedLabel.textAlignment = .right
                
                PackedLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                PackedLabel.text = "تلقى القماش"
                PackedLabel.textAlignment = .right
                
                TrackingButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                TrackingButton.setTitle("تفاصيل المسار", for: .normal)
                
                DeliveryInfoLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                DeliveryInfoLabel.text = " معلومات التوصيل"
                DeliveryInfoLabel.textAlignment = .right
                
                MapImageView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                
                NameLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                NameLabel.textAlignment = .right
                
                FloorLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                FloorLabel.textAlignment = .right
                
                AreaLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                AreaLabel.textAlignment = .right
                
                StateLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                StateLabel.textAlignment = .right
                
                CountryLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                CountryLabel.textAlignment = .right
                
                PhoneNumLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                PhoneNumLabel.textAlignment = .right
                
                changeViewToArabicInSelf()
            }
        }
        else
        {
            OrderStatusLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            OrderStatusLabel.text = " ORDER STATUS"
            OrderStatusLabel.textAlignment = .left
            
            orderedLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            orderedLabel.text = "Order Placed"
            orderedLabel.textAlignment = .left
            
            PackedLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            PackedLabel.text = "Cloth Recieved"
            PackedLabel.textAlignment = .left
            
            TrackingButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            TrackingButton.setTitle("Tracking Details", for: .normal)
            
            DeliveryInfoLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            DeliveryInfoLabel.text = " DELIVERY INFORMATION"
            DeliveryInfoLabel.textAlignment = .left
            
            MapImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            NameLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            NameLabel.textAlignment = .left
            
            FloorLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            FloorLabel.textAlignment = .left
            
            AreaLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            AreaLabel.textAlignment = .left
            
            StateLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            StateLabel.textAlignment = .left
            
            CountryLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            CountryLabel.textAlignment = .left
            
            PhoneNumLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            PhoneNumLabel.textAlignment = .left
            
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
