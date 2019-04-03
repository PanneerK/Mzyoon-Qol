//
//  OrderDetailsDeliveredVC.swift
//  Mzyoon
//
//  Created by QOLSoft on 25/02/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class OrderDetailsDeliveredVC: CommonViewController,ServerAPIDelegate
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
    var TailorID:Int!
    
    let OrderDetailsScrollView = UIScrollView()
    
    var applicationDelegate = AppDelegate()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

         navigationBar.isHidden = true
        
        // Do any additional setup after loading the view.
        
        selectedButton(tag: 2)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        let navigationArray = self.navigationController?.viewControllers
        print("viewControllers Aray:",navigationArray!)
        
       // TailorID = UserDefaults.standard.value(forKey: "TailorID") as? Int
        
        print("Tailor ID:",TailorID!)
        
        self.serviceCall.API_GetOrderDetails(OrderId: OrderID, delegate: self)
        
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
        PageNumStr = "OrderDetailsDeliveredVC"
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
    
    func changeViewToArabicInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.text = "تفاصيل التسليم للنظام"
        
//        OrderDetailsScrollView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.text = "DELIVERED ORDER DETAILS"
        
//        OrderDetailsScrollView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
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
        selfScreenNavigationTitle.text = "DELIVERED ORDER DETAILS"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationTitle.font = selfScreenNavigationTitle.font.withSize(2 * x)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        // Scrollview...
        // let OrderDetailsScrollView = UIScrollView()
      //  OrderDetailsScrollView.frame = CGRect(x: 0, y: selfScreenNavigationBar.frame.maxY + y, width: view.frame.width, height: view.frame.height - (13 * y))
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
       // orderIdView.frame = CGRect(x: (3 * x), y: y, width: OrderDetailsScrollView.frame.width - (6 * x), height: (6 * y))
         orderIdView.frame = CGRect(x: 0, y: y, width: OrderDetailsScrollView.frame.width, height: (6 * y))
        orderIdView.backgroundColor = UIColor.white
        orderIdView.layer.borderWidth = 1.0
        orderIdView.layer.borderColor = UIColor.lightGray.cgColor
        OrderDetailsScrollView.addSubview(orderIdView)
        
        // Order Id Label..
        let orderIdLabel = UILabel()
        orderIdLabel.frame = CGRect(x: x, y: orderIdView.frame.minY, width: (13 * x), height: (2 * x))
        // orderIdLabel.backgroundColor = UIColor.gray
        orderIdLabel.font = UIFont.boldSystemFont(ofSize: 16)
        orderIdLabel.text = "ORDER ID      :"
        orderIdLabel.font = UIFont(name: "Avenir Next", size: (1.6 * x))
        orderIdLabel.textColor = UIColor.black
        orderIdLabel.textAlignment = .left
        orderIdView.addSubview(orderIdLabel)
        
        let orderIdNumLabel = UILabel()
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
        let orderPlacedLabel = UILabel()
        orderPlacedLabel.frame = CGRect(x: x, y: orderIdLabel.frame.maxY + y, width: (13 * x), height: (2 * x))
        // orderPlacedLabel.backgroundColor = UIColor.gray
        orderPlacedLabel.text = "Order Placed On  :"
        orderPlacedLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
        orderPlacedLabel.textColor = UIColor.black
        orderPlacedLabel.textAlignment = .left
        orderIdView.addSubview(orderPlacedLabel)
        
        
        let orderPlacedDateLabel = UILabel()
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
        orderPlacedDateLabel.textAlignment = .left
        orderIdView.addSubview(orderPlacedDateLabel)
      
        
      /*
        // PaymentInfo View..
        let PaymentInfoView = UIView()
        PaymentInfoView.frame = CGRect(x: (3 * x), y: orderIdView.frame.maxY + (3 * y), width: OrderDetailsScrollView.frame.width - (6 * x), height: (40 * y))
        PaymentInfoView.backgroundColor = UIColor.groupTableViewBackground
        OrderDetailsScrollView.addSubview(PaymentInfoView)
        
        // PaymentInfo Label..
        let PaymentInfoLabel = UILabel()
        PaymentInfoLabel.frame = CGRect(x: 0, y: 0, width: PaymentInfoView.frame.width, height: (4 * x))
        PaymentInfoLabel.text = " PAYMENT INFORMATION"
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
                
               // DressImageView.dowloadFromServer(url: apiurl!)
            }
        }
        else
        {
            DressImageView.backgroundColor = UIColor.lightGray
        }
        PaymentInfoView.addSubview(DressImageView)
        
        // DressType Label..
        let DressTypeLabel = UILabel()
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
        let QtyLabel = UILabel()
        QtyLabel.frame = CGRect(x: DressImageView.frame.maxX + (2 * x), y: DressTypeLabel.frame.minY + (3 * y), width: (6 * x), height: (2 * y))
        QtyLabel.text = "Qty : "
        QtyLabel.textColor = UIColor.black
        QtyLabel.textAlignment = .left
        QtyLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        PaymentInfoView.addSubview(QtyLabel)
        
        let QtyNumLabel = UILabel()
        QtyNumLabel.frame = CGRect(x: QtyLabel.frame.minX + (5 * x), y: DressTypeLabel.frame.minY + (3 * y), width: (4 * x), height: (2 * y))
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
        PaymentInfoView.addSubview(QtyNumLabel)
        
        // Price Label..
        let PriceLabel = UILabel()
        PriceLabel.frame = CGRect(x: DressImageView.frame.maxX + (2 * x), y: QtyLabel.frame.minY + (3 * y), width: (6 * x), height: (2 * y))
        PriceLabel.text = "Price : "
        PriceLabel.textColor = UIColor.black
        PriceLabel.textAlignment = .left
        PriceLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        PaymentInfoView.addSubview(PriceLabel)
        
        let PriceNumLabel = UILabel()
        PriceNumLabel.frame = CGRect(x: QtyLabel.frame.minX + (5 * x), y: QtyLabel.frame.minY + (3 * y), width: (8 * x), height: (2 * y))
        if(Price.count > 0)
        {
            let PriceNum : Int = Price[0] as! Int
            PriceNumLabel.text = "\(PriceNum) AED"
        }
        else
        {
            PriceNumLabel.text = "0 AED"
        }
        
        PriceNumLabel.textColor = UIColor.black
        PriceNumLabel.textAlignment = .left
        PriceNumLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        PaymentInfoView.addSubview(PriceNumLabel)
        
        
        // Sub-Total Label
        let SubTotalLabel = UILabel()
        SubTotalLabel.frame = CGRect(x:x, y: DressImageView.frame.maxY + (3 * y), width: (8 * x), height: (2 * y))
        SubTotalLabel.text = "Sub Total"
        SubTotalLabel.textColor = UIColor.black
        SubTotalLabel.textAlignment = .left
        SubTotalLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        SubTotalLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(SubTotalLabel)
        
        
        let SubTotalPriceLabel = UILabel()
        SubTotalPriceLabel.frame = CGRect(x:SubTotalLabel.frame.maxX + (12 * x), y: DressImageView.frame.maxY + (3 * y), width: (8 * x), height: (2 * y))
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
        SubTotalPriceLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        SubTotalPriceLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(SubTotalPriceLabel)
        
        
        // Shipping Label
        let ShippingLabel = UILabel()
        ShippingLabel.frame = CGRect(x:x, y: SubTotalLabel.frame.maxY + y, width: (15 * x), height: (2 * y))
        ShippingLabel.text = "Shipping & Handling"
        ShippingLabel.textColor = UIColor.black
        ShippingLabel.textAlignment = .left
        ShippingLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        ShippingLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(ShippingLabel)
        
        
        let ShippingPriceLabel = UILabel()
        ShippingPriceLabel.frame = CGRect(x:ShippingLabel.frame.maxX + (5 * x), y: SubTotalPriceLabel.frame.maxY + y, width: (8 * x), height: (2 * y))
        if(ShippingCharges.count > 0)
        {
            ShippingPriceLabel.text = "0 AED" //ShippingCharges[0] as? String
        }
        else
        {
            ShippingPriceLabel.text = "0 AED"
        }
        ShippingPriceLabel.textColor = UIColor.black
        ShippingPriceLabel.textAlignment = .right
        ShippingPriceLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        ShippingPriceLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(ShippingPriceLabel)
        
        
        // Tax Label
        let TaxLabel = UILabel()
        TaxLabel.frame = CGRect(x:x, y: ShippingLabel.frame.maxY + y, width: (8 * x), height: (2 * y))
        TaxLabel.text = "Tax"
        TaxLabel.textColor = UIColor.black
        TaxLabel.textAlignment = .left
        TaxLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        TaxLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(TaxLabel)
        
        
        let TaxPriceLabel = UILabel()
        TaxPriceLabel.frame = CGRect(x:TaxLabel.frame.maxX + (12 * x), y: ShippingPriceLabel.frame.maxY + y, width: (8 * x), height: (2 * y))
        if(Tax.count > 0)
        {
           // TaxPriceLabel.text = Tax[0] as? String
             TaxPriceLabel.text = "0 AED"
        }
        else
        {
            TaxPriceLabel.text = "0 AED"
        }
        TaxPriceLabel.textColor = UIColor.black
        TaxPriceLabel.textAlignment = .right
        TaxPriceLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        TaxPriceLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(TaxPriceLabel)
        
        
        // Appointment Label
        let AppointmentLabel = UILabel()
        AppointmentLabel.frame = CGRect(x:x, y: TaxLabel.frame.maxY + y, width: (15 * x), height: (2 * y))
        AppointmentLabel.text = "Appointment Charges"
        AppointmentLabel.textColor = UIColor.black
        AppointmentLabel.textAlignment = .left
        AppointmentLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        AppointmentLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(AppointmentLabel)
        
        
        let AppointmentPriceLabel = UILabel()
        AppointmentPriceLabel.frame = CGRect(x:AppointmentLabel.frame.maxX + (5 * x), y: TaxPriceLabel.frame.maxY + y, width: (8 * x), height: (2 * y))
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
        AppointmentPriceLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        AppointmentPriceLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(AppointmentPriceLabel)
        
        
        // Total Label
        let TotalLabel = UILabel()
        TotalLabel.frame = CGRect(x:x, y: AppointmentLabel.frame.maxY + y, width: (15 * x), height: (2 * y))
        TotalLabel.text = "Total"
        TotalLabel.textColor = UIColor.black
        TotalLabel.textAlignment = .left
        TotalLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        TotalLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(TotalLabel)
        
        
        let TotalPriceLabel = UILabel()
        TotalPriceLabel.frame = CGRect(x:TotalLabel.frame.maxX + (5 * x), y: AppointmentPriceLabel.frame.maxY + y, width: (8 * x), height: (2 * y))
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
        TotalPriceLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        TotalPriceLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(TotalPriceLabel)
        
        
        // Payment Type Label
        let PaymentLabel = UILabel()
        PaymentLabel.frame = CGRect(x:x, y: TotalLabel.frame.maxY + y, width: (15 * x), height: (2 * y))
        PaymentLabel.text = "Payment Type"
        PaymentLabel.textColor = UIColor.blue
        PaymentLabel.textAlignment = .left
        PaymentLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        PaymentLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(PaymentLabel)
        
        
        let PaymentTypeLabel = UILabel()
        PaymentTypeLabel.frame = CGRect(x:PaymentLabel.frame.maxX - (2 * x), y: TotalPriceLabel.frame.maxY + y, width: (15 * x), height: (2 * y))
        PaymentTypeLabel.text = "(Card)"
        PaymentTypeLabel.textColor = UIColor.blue
        PaymentTypeLabel.textAlignment = .right
        PaymentTypeLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        PaymentTypeLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(PaymentTypeLabel)
        
      
         // Order Status View..
         let OrderStatusView = UIView()
         OrderStatusView.frame = CGRect(x: (3 * x), y: PaymentInfoView.frame.maxY + (3 * y), width: OrderDetailsScrollView.frame.width - (6 * x), height: (12 * y))
         OrderStatusView.backgroundColor = UIColor.white
         OrderDetailsScrollView.addSubview(OrderStatusView)
         
         
         // Order status Label..
         let OrderStatusLabel = UILabel()
         OrderStatusLabel.frame = CGRect(x: 0, y: 0, width: OrderStatusView.frame.width, height: (4 * x))
         OrderStatusLabel.text = " RATE US"
         OrderStatusLabel.textAlignment = .left
         OrderStatusLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
         OrderStatusLabel.font = UIFont(name: "Avenir Next", size: (1.5 * x))
         OrderStatusLabel.font = UIFont.boldSystemFont(ofSize: (1.5 * x))
         OrderStatusLabel.textColor = UIColor.white
         OrderStatusView.addSubview(OrderStatusLabel)
         
         //TrackingButton
         let TrackingButton = UIButton()
         TrackingButton.frame = CGRect(x: (2 * x), y: OrderStatusLabel.frame.maxY + (2 * y), width: OrderStatusView.frame.width - (4 * x), height:(3 * y))
         TrackingButton.backgroundColor = UIColor.orange
         TrackingButton.setTitle("RATE AND WRITE A REVIEW", for: .normal)
         TrackingButton.setTitleColor(UIColor.white, for: .normal)
         TrackingButton.titleLabel?.font =  UIFont(name: "Avenir-Regular", size: (1.2 * x))
         TrackingButton.layer.cornerRadius = 10;  // this value vary as per your desire
         TrackingButton.clipsToBounds = true;
         TrackingButton.addTarget(self, action: #selector(self.RatingButtonAction(sender:)), for: .touchUpInside)
         OrderStatusView.addSubview(TrackingButton)
    */
        
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
        DressImageView.frame = CGRect(x: x, y: y, width: (6 * x), height:(6 * y))
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
            ServiceTypeLabel.text = ServiceType[0] as? String
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
        OrderStatusLabel.text = " RATE US"
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
        OrderStatusView.frame = CGRect(x: 0, y: OrderUnderLine.frame.maxY + y/2, width: OrderDetailsScrollView.frame.width, height: (4.5 * y))
        OrderStatusView.backgroundColor = UIColor.white
        OrderStatusView.layer.borderWidth = 1.0
        OrderStatusView.layer.borderColor = UIColor.lightGray.cgColor
        OrderDetailsScrollView.addSubview(OrderStatusView)
        
        //TrackingButton
        let TrackingButton = UIButton()
        TrackingButton.frame = CGRect(x: (2 * x), y: y, width: OrderStatusView.frame.width - (4 * x), height:(2.5 * y))
        TrackingButton.backgroundColor = UIColor.orange
        TrackingButton.setTitle("RATE AND WRITE A REVIEW", for: .normal)
        TrackingButton.setTitleColor(UIColor.white, for: .normal)
        TrackingButton.titleLabel?.font =  UIFont(name: "Avenir Next", size: (1.5 * x))
        TrackingButton.layer.cornerRadius = 10;  // this value vary as per your desire
        TrackingButton.clipsToBounds = true;
        TrackingButton.addTarget(self, action: #selector(self.RatingButtonAction(sender:)), for: .touchUpInside)
        OrderStatusView.addSubview(TrackingButton)
        
        
        OrderDetailsScrollView.contentSize.height = OrderStatusView.frame.maxY + (2 * y)
        
        
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                orderIdView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
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
                PaymentInfoView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                DressImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
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
                SubTotalLabel.textAlignment = .left
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
                OrderStatusView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                OrderStatusLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                OrderStatusLabel.text = " RATE US"
                OrderStatusLabel.textAlignment = .left
                TrackingButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                TrackingButton.setTitle("RATE AND WRITE A REVIEW", for: .normal)
                
                changeViewToEnglishInSelf()
            }
            else if language == "ar"
            {
                orderIdView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
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
                PaymentInfoView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                DressImageView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
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
                SubTotalLabel.textAlignment = .right
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
                ServiceLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                ServiceLabel.text = "نوع الخدمة"
                ServiceLabel.textAlignment = .right
                ServiceTypeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                ServiceTypeLabel.textAlignment = .left
                PaymentLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                PaymentLabel.text = "نوع الدفع"
                PaymentLabel.textAlignment = .right
                PaymentTypeLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                PaymentTypeLabel.text = "(بطاقة)"
                PaymentTypeLabel.textAlignment = .left
                OrderStatusView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                OrderStatusLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                OrderStatusLabel.text = " قيمنا"
                OrderStatusLabel.textAlignment = .right
                TrackingButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                TrackingButton.setTitle("معدل وكتابة مراجعة", for: .normal)
                
                changeViewToArabicInSelf()
            }
        }
        else
        {
            orderIdView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
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
            PaymentInfoView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            DressImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            DressTypeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            DressTypeLabel.textAlignment = .left
            QtyLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            QtyLabel.text = "Qty     : "
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
            SubTotalLabel.textAlignment = .left
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
            OrderStatusView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            OrderStatusLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            OrderStatusLabel.text = " RATE US"
            OrderStatusLabel.textAlignment = .left
            TrackingButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            TrackingButton.setTitle("RATE AND WRITE A REVIEW", for: .normal)
            
            changeViewToEnglishInSelf()
        }
        
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func RatingButtonAction(sender : UIButton)
    {
        let RatingScreen = WriteReviewRateViewController()
        RatingScreen.OrderID = OrderID!
        RatingScreen.TailorID = TailorID!
        self.navigationController?.pushViewController(RatingScreen, animated: true)
    }
    
}
