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
    var qty = NSArray()
    
    // ProductPrice Array..
    var Appoinment = NSArray()
    var Price = NSArray()
    var Tax = NSArray()
    var Total = NSArray()
    
    var OrderID:Int!
    var OrderDate = String()
    var TailorID:Int!
    
    let OrderDetailsScrollView = UIScrollView()
    
    var applicationDelegate = AppDelegate()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        selectedButton(tag: 2)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
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
  
    func orderDetailsContent()
    {
        self.stopActivity()
        
        let orderDetailsNavigationBar = UIView()
        orderDetailsNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        orderDetailsNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(orderDetailsNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 4
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        orderDetailsNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: orderDetailsNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "DELIVERED ORDER DETAILS"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        orderDetailsNavigationBar.addSubview(navigationTitle)
        
        // Scrollview...
        // let OrderDetailsScrollView = UIScrollView()
        OrderDetailsScrollView.frame = CGRect(x: 0, y: orderDetailsNavigationBar.frame.maxY + y, width: view.frame.width, height: view.frame.height - (13 * y))
        OrderDetailsScrollView.backgroundColor = UIColor.clear
        OrderDetailsScrollView.contentSize.height = (1.75 * view.frame.height)
        view.addSubview(OrderDetailsScrollView)
        
        
        for views in OrderDetailsScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        // OrderId View..
        let orderIdView = UIView()
        orderIdView.frame = CGRect(x: (3 * x), y: y, width: OrderDetailsScrollView.frame.width - (6 * x), height: (8 * y))
        orderIdView.backgroundColor = UIColor.white
        OrderDetailsScrollView.addSubview(orderIdView)
        
        // Order Id Label..
        let orderIdLabel = UILabel()
        orderIdLabel.frame = CGRect(x: x, y: orderIdView.frame.minY, width: (10 * x), height: (2 * x))
        // orderIdLabel.backgroundColor = UIColor.gray
        orderIdLabel.font = UIFont.boldSystemFont(ofSize: 16)
        orderIdLabel.text = "ORDER ID : "
        orderIdLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        orderIdLabel.textColor = UIColor.black
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
            orderIdNumLabel.text =  "#"
        }
        orderIdNumLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        orderIdNumLabel.textColor = UIColor.black
        orderIdView.addSubview(orderIdNumLabel)
        
        // Order Placed Label..
        let orderPlacedLabel = UILabel()
        orderPlacedLabel.frame = CGRect(x: x, y: orderIdLabel.frame.maxY + y, width: (13 * x), height: (2 * x))
        // orderPlacedLabel.backgroundColor = UIColor.gray
        orderPlacedLabel.text = "Order Placed On :"
        orderPlacedLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        orderPlacedLabel.textColor = UIColor.black
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
            OrderDate = ""
        }
        orderPlacedDateLabel.text = OrderDate
        orderPlacedDateLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        orderPlacedDateLabel.textColor = UIColor.black
        orderIdView.addSubview(orderPlacedDateLabel)
        
        // PaymentInfo View..
        let PaymentInfoView = UIView()
        PaymentInfoView.frame = CGRect(x: (3 * x), y: orderIdView.frame.maxY + (3 * y), width: OrderDetailsScrollView.frame.width - (6 * x), height: (36 * y))
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
                print("Image Of Dress", apiurl!)
                DressImageView.dowloadFromServer(url: apiurl!)
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
            QtyNumLabel.text = ""
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
        let ShippingLabel = UILabel()
        ShippingLabel.frame = CGRect(x:x, y: SubTotalLabel.frame.maxY + y, width: (15 * x), height: (2 * y))
        ShippingLabel.text = "Shipping & Handling"
        ShippingLabel.textColor = UIColor.black
        ShippingLabel.textAlignment = .left
        ShippingLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        ShippingLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        //PaymentInfoView.addSubview(ShippingLabel)
        
        
        let ShippingPriceLabel = UILabel()
        ShippingPriceLabel.frame = CGRect(x:ShippingLabel.frame.maxX + (5 * x), y: SubTotalPriceLabel.frame.maxY + y, width: (8 * x), height: (2 * y))
        ShippingPriceLabel.text = ""
        ShippingPriceLabel.textColor = UIColor.black
        ShippingPriceLabel.textAlignment = .right
        ShippingPriceLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        ShippingPriceLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        //PaymentInfoView.addSubview(ShippingPriceLabel)
        
        
        // Tax Label
        let TaxLabel = UILabel()
        TaxLabel.frame = CGRect(x:x, y: SubTotalLabel.frame.maxY + y, width: (8 * x), height: (2 * y))
        TaxLabel.text = "Tax"
        TaxLabel.textColor = UIColor.black
        TaxLabel.textAlignment = .left
        TaxLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
        TaxLabel.font = UIFont.boldSystemFont(ofSize: (1.3 * x))
        PaymentInfoView.addSubview(TaxLabel)
        
        
        let TaxPriceLabel = UILabel()
        TaxPriceLabel.frame = CGRect(x:TaxLabel.frame.maxX + (12 * x), y: SubTotalPriceLabel.frame.maxY + y, width: (8 * x), height: (2 * y))
        if(Tax.count > 0)
        {
            let TaxNum : Int = Tax[0] as! Int
            TaxPriceLabel.text = "\(TaxNum)"
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
        
        
        OrderDetailsScrollView.contentSize.height = OrderStatusView.frame.maxY + (2 * y)
        
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
