//
//  OrderDetailsViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 20/12/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class OrderDetailsViewController: CommonViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        orderDetailsContent()
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
        navigationTitle.text = "ORDER DETAILS"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        orderDetailsNavigationBar.addSubview(navigationTitle)
        
       // Scrollview...
      let OrderDetailsScrollView = UIScrollView()
        OrderDetailsScrollView.frame = CGRect(x: 0, y: orderDetailsNavigationBar.frame.maxY + y, width: view.frame.width, height: view.frame.height - (13 * y))
        OrderDetailsScrollView.backgroundColor = UIColor.clear
        OrderDetailsScrollView.contentSize.height = (1.75 * view.frame.height)
        view.addSubview(OrderDetailsScrollView)
        
        // OrderId View..
        let orderIdView = UIView()
        orderIdView.frame = CGRect(x: (3 * x), y: y, width: OrderDetailsScrollView.frame.width - (6 * x), height: (8 * y))
        orderIdView.backgroundColor = UIColor.white
        OrderDetailsScrollView.addSubview(orderIdView)
        
        // Order Id Label..
        let orderIdLabel = UILabel()
        orderIdLabel.frame = CGRect(x: x, y: orderIdView.frame.minY, width: (8 * x), height: (2 * x))
       // orderIdLabel.backgroundColor = UIColor.gray
        orderIdLabel.font = UIFont.boldSystemFont(ofSize: 16)
        orderIdLabel.text = "ORDER ID : "
        orderIdLabel.font = UIFont(name: "Avenir Next", size: 16)
        orderIdLabel.textColor = UIColor.black
        orderIdView.addSubview(orderIdLabel)
        
        let orderIdNumLabel = UILabel()
        orderIdNumLabel.frame = CGRect(x: orderIdLabel.frame.maxX, y: orderIdView.frame.minY, width: (15 * x), height: (2 * x))
       // orderIdNumLabel.backgroundColor = UIColor.gray
        orderIdNumLabel.font = UIFont.boldSystemFont(ofSize: 16)
        orderIdNumLabel.text = "#60123456"
        orderIdNumLabel.font = UIFont(name: "Avenir Next", size: 16)
         orderIdNumLabel.textColor = UIColor.black
        orderIdView.addSubview(orderIdNumLabel)
        
        // Order Placed Label..
        let orderPlacedLabel = UILabel()
        orderPlacedLabel.frame = CGRect(x: x, y: orderIdLabel.frame.maxY + y, width: (13 * x), height: (2 * x))
       // orderPlacedLabel.backgroundColor = UIColor.gray
        orderPlacedLabel.text = "Order Placed On :"
        orderPlacedLabel.font = UIFont(name: "Avenir Next", size: 14)
        orderPlacedLabel.textColor = UIColor.black
        orderIdView.addSubview(orderPlacedLabel)
        
        
        let orderPlacedDateLabel = UILabel()
        orderPlacedDateLabel.frame = CGRect(x: orderPlacedLabel.frame.maxX , y: orderIdLabel.frame.maxY + y, width: (17 * x), height: (2 * x))
       // orderPlacedDateLabel.backgroundColor = UIColor.gray
        orderPlacedDateLabel.text = "Wednesday, 02 jan 2019"
        orderPlacedDateLabel.font = UIFont(name: "Avenir Next", size: 14)
        orderPlacedDateLabel.textColor = UIColor.black
        orderIdView.addSubview(orderPlacedDateLabel)
        
        // PaymentInfo View..
        let PaymentInfoView = UIView()
        PaymentInfoView.frame = CGRect(x: (3 * x), y: orderIdView.frame.maxY + (3 * y), width: OrderDetailsScrollView.frame.width - (6 * x), height: (42 * y))
        PaymentInfoView.backgroundColor = UIColor.lightGray
        OrderDetailsScrollView.addSubview(PaymentInfoView)
        
        
         // PaymentInfo Label..
         let PaymentInfoLabel = UILabel()
         PaymentInfoLabel.frame = CGRect(x: 0, y: 0, width: PaymentInfoView.frame.width, height: (4 * x))
         PaymentInfoLabel.text = " PAYMENT INFORMATION"
         PaymentInfoLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
         PaymentInfoLabel.font = UIFont(name: "Avenir Next", size: 16)
         PaymentInfoLabel.font = UIFont.boldSystemFont(ofSize: 16)
         PaymentInfoLabel.textColor = UIColor.white
         PaymentInfoView.addSubview(PaymentInfoLabel)
        
        let DressImageView = UIImageView()
        DressImageView.frame = CGRect(x: x, y: PaymentInfoLabel.frame.maxY + (2 * y), width: (10 * x), height:(13 * y))
        DressImageView.backgroundColor = UIColor.white
       /*
        if let imageName = DressImageArray[0] as? String
        {
            let api = "http://appsapi.mzyoon.com/images/DressSubType/\(imageName)"
            //  let api = "http://192.168.0.21/TailorAPI/Images/DressSubType/\(imageName)"
            let apiurl = URL(string: api)
            print("Image Of Dress", apiurl!)
            DressImageView.dowloadFromServer(url: apiurl!)
        }
        */
        PaymentInfoView.addSubview(DressImageView)
        
        // DressType Label..
        let DressTypeLabel = UILabel()
        DressTypeLabel.frame = CGRect(x: DressImageView.frame.maxX + (2 * x), y: PaymentInfoLabel.frame.maxY + (3 * y) , width: (20 * x), height: (2 * y))
        DressTypeLabel.text = "Men's Mandarin Suits"
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
        QtyLabel.font = UIFont(name: "Avenir Next", size: 14)
        PaymentInfoView.addSubview(QtyLabel)
        
        let QtyNumLabel = UILabel()
        QtyNumLabel.frame = CGRect(x: QtyLabel.frame.minX + (5 * x), y: DressTypeLabel.frame.minY + (3 * y), width: (4 * x), height: (2 * y))
        QtyNumLabel.text = "1"
        QtyNumLabel.textColor = UIColor.black
        QtyNumLabel.textAlignment = .left
        QtyNumLabel.font = UIFont(name: "Avenir Next", size: 14)
        PaymentInfoView.addSubview(QtyNumLabel)
        
        // Price Label..
        let PriceLabel = UILabel()
        PriceLabel.frame = CGRect(x: DressImageView.frame.maxX + (2 * x), y: QtyLabel.frame.minY + (3 * y), width: (6 * x), height: (2 * y))
        PriceLabel.text = "Price : "
        PriceLabel.textColor = UIColor.black
        PriceLabel.textAlignment = .left
        PriceLabel.font = UIFont(name: "Avenir Next", size: 14)
        PaymentInfoView.addSubview(PriceLabel)
        
        let PriceNumLabel = UILabel()
        PriceNumLabel.frame = CGRect(x: QtyLabel.frame.minX + (5 * x), y: QtyLabel.frame.minY + (3 * y), width: (8 * x), height: (2 * y))
        PriceNumLabel.text = "2312 AED"
        PriceNumLabel.textColor = UIColor.black
        PriceNumLabel.textAlignment = .left
        PriceNumLabel.font = UIFont(name: "Avenir Next", size: 14)
        PaymentInfoView.addSubview(PriceNumLabel)
        
        
        // Sub-Total Label
        let SubTotalLabel = UILabel()
        SubTotalLabel.frame = CGRect(x:x, y: DressImageView.frame.maxY + (3 * y), width: (8 * x), height: (2 * y))
        SubTotalLabel.text = "Sub Total"
        SubTotalLabel.textColor = UIColor.black
        SubTotalLabel.textAlignment = .left
        SubTotalLabel.font = UIFont(name: "Avenir Next", size: 14)
        SubTotalLabel.font = UIFont.boldSystemFont(ofSize: 14)
        PaymentInfoView.addSubview(SubTotalLabel)
        
        
        let SubTotalPriceLabel = UILabel()
        SubTotalPriceLabel.frame = CGRect(x:SubTotalLabel.frame.maxX + (12 * x), y: DressImageView.frame.maxY + (3 * y), width: (8 * x), height: (2 * y))
        SubTotalPriceLabel.text = "2312.00 AED"
        SubTotalPriceLabel.textColor = UIColor.black
        SubTotalPriceLabel.textAlignment = .right
        SubTotalPriceLabel.font = UIFont(name: "Avenir Next", size: 14)
        SubTotalPriceLabel.font = UIFont.boldSystemFont(ofSize: 14)
        PaymentInfoView.addSubview(SubTotalPriceLabel)
        
        
        // Shipping Label
        let ShippingLabel = UILabel()
        ShippingLabel.frame = CGRect(x:x, y: SubTotalLabel.frame.maxY + y, width: (15 * x), height: (2 * y))
        ShippingLabel.text = "Shipping & Handling"
        ShippingLabel.textColor = UIColor.black
        ShippingLabel.textAlignment = .left
        ShippingLabel.font = UIFont(name: "Avenir Next", size: 14)
        ShippingLabel.font = UIFont.boldSystemFont(ofSize: 14)
        PaymentInfoView.addSubview(ShippingLabel)
        
        
        let ShippingPriceLabel = UILabel()
        ShippingPriceLabel.frame = CGRect(x:ShippingLabel.frame.maxX + (5 * x), y: SubTotalPriceLabel.frame.maxY + y, width: (8 * x), height: (2 * y))
        ShippingPriceLabel.text = "50.00 AED"
        ShippingPriceLabel.textColor = UIColor.black
        ShippingPriceLabel.textAlignment = .right
        ShippingPriceLabel.font = UIFont(name: "Avenir Next", size: 14)
        ShippingPriceLabel.font = UIFont.boldSystemFont(ofSize: 14)
        PaymentInfoView.addSubview(ShippingPriceLabel)
        
        
        // Tax Label
        let TaxLabel = UILabel()
        TaxLabel.frame = CGRect(x:x, y: ShippingLabel.frame.maxY + y, width: (8 * x), height: (2 * y))
        TaxLabel.text = "Tax"
        TaxLabel.textColor = UIColor.black
        TaxLabel.textAlignment = .left
        TaxLabel.font = UIFont(name: "Avenir Next", size: 14)
        TaxLabel.font = UIFont.boldSystemFont(ofSize: 14)
        PaymentInfoView.addSubview(TaxLabel)
        
    
        let TaxPriceLabel = UILabel()
        TaxPriceLabel.frame = CGRect(x:TaxLabel.frame.maxX + (12 * x), y: ShippingPriceLabel.frame.maxY + y, width: (8 * x), height: (2 * y))
        TaxPriceLabel.text = "60.00 AED"
        TaxPriceLabel.textColor = UIColor.black
        TaxPriceLabel.textAlignment = .right
        TaxPriceLabel.font = UIFont(name: "Avenir Next", size: 14)
        TaxPriceLabel.font = UIFont.boldSystemFont(ofSize: 14)
        PaymentInfoView.addSubview(TaxPriceLabel)
        
        
        // Appointment Label
        let AppointmentLabel = UILabel()
        AppointmentLabel.frame = CGRect(x:x, y: TaxLabel.frame.maxY + y, width: (15 * x), height: (2 * y))
        AppointmentLabel.text = "Appointment Charges"
        AppointmentLabel.textColor = UIColor.black
        AppointmentLabel.textAlignment = .left
        AppointmentLabel.font = UIFont(name: "Avenir Next", size: 14)
        AppointmentLabel.font = UIFont.boldSystemFont(ofSize: 14)
        PaymentInfoView.addSubview(AppointmentLabel)
        
       
        let AppointmentPriceLabel = UILabel()
        AppointmentPriceLabel.frame = CGRect(x:AppointmentLabel.frame.maxX + (5 * x), y: TaxPriceLabel.frame.maxY + y, width: (8 * x), height: (2 * y))
        AppointmentPriceLabel.text = "300.00 AED"
        AppointmentPriceLabel.textColor = UIColor.black
        AppointmentPriceLabel.textAlignment = .right
        AppointmentPriceLabel.font = UIFont(name: "Avenir Next", size: 14)
        AppointmentPriceLabel.font = UIFont.boldSystemFont(ofSize: 14)
        PaymentInfoView.addSubview(AppointmentPriceLabel)
        
        
        // Total Label
        let TotalLabel = UILabel()
        TotalLabel.frame = CGRect(x:x, y: AppointmentLabel.frame.maxY + y, width: (15 * x), height: (2 * y))
        TotalLabel.text = "Total"
        TotalLabel.textColor = UIColor.black
        TotalLabel.textAlignment = .left
        TotalLabel.font = UIFont(name: "Avenir Next", size: 14)
        TotalLabel.font = UIFont.boldSystemFont(ofSize: 14)
        PaymentInfoView.addSubview(TotalLabel)
        
       
        let TotalPriceLabel = UILabel()
        TotalPriceLabel.frame = CGRect(x:TotalLabel.frame.maxX + (5 * x), y: AppointmentPriceLabel.frame.maxY + y, width: (8 * x), height: (2 * y))
        TotalPriceLabel.text = "50.00 AED"
        TotalPriceLabel.textColor = UIColor.black
        TotalPriceLabel.textAlignment = .right
        TotalPriceLabel.font = UIFont(name: "Avenir Next", size: 14)
        TotalPriceLabel.font = UIFont.boldSystemFont(ofSize: 14)
        PaymentInfoView.addSubview(TotalPriceLabel)
        
        
        // Payment Type Label
        let PaymentLabel = UILabel()
        PaymentLabel.frame = CGRect(x:x, y: TotalLabel.frame.maxY + y, width: (15 * x), height: (2 * y))
        PaymentLabel.text = "Payment Type"
        PaymentLabel.textColor = UIColor.blue
        PaymentLabel.textAlignment = .left
        PaymentLabel.font = UIFont(name: "Avenir Next", size: 14)
        PaymentLabel.font = UIFont.boldSystemFont(ofSize: 14)
        PaymentInfoView.addSubview(PaymentLabel)
        
        
        let PaymentTypeLabel = UILabel()
        PaymentTypeLabel.frame = CGRect(x:PaymentLabel.frame.maxX - (2 * x), y: TotalPriceLabel.frame.maxY + y, width: (15 * x), height: (2 * y))
        PaymentTypeLabel.text = "(Cash On Delivery)"
        PaymentTypeLabel.textColor = UIColor.blue
        PaymentTypeLabel.textAlignment = .right
        PaymentTypeLabel.font = UIFont(name: "Avenir Next", size: 14)
        PaymentTypeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        PaymentInfoView.addSubview(PaymentTypeLabel)
        
        
        // Order Status View..
        let OrderStatusView = UIView()
        OrderStatusView.frame = CGRect(x: (3 * x), y: PaymentInfoView.frame.maxY + (3 * y), width: OrderDetailsScrollView.frame.width - (6 * x), height: (20 * y))
        OrderStatusView.backgroundColor = UIColor.white
        OrderDetailsScrollView.addSubview(OrderStatusView)
        
        
        // Order status Label..
        let OrderStatusLabel = UILabel()
        OrderStatusLabel.frame = CGRect(x: 0, y: 0, width: OrderStatusView.frame.width, height: (4 * x))
        OrderStatusLabel.text = " ORDER STATUS"
        OrderStatusLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        OrderStatusLabel.font = UIFont(name: "Avenir Next", size: 16)
        OrderStatusLabel.font = UIFont.boldSystemFont(ofSize: 16)
        OrderStatusLabel.textColor = UIColor.white
        OrderStatusView.addSubview(OrderStatusLabel)
        
        
        // Order Status View..
        let DeliveryInfoView = UIView()
        DeliveryInfoView.frame = CGRect(x: (3 * x), y: OrderStatusView.frame.maxY + (3 * y), width: OrderDetailsScrollView.frame.width - (6 * x), height: (20 * y))
        DeliveryInfoView.backgroundColor = UIColor.white
        OrderDetailsScrollView.addSubview(DeliveryInfoView)
        
        
        // Order status Label..
        let DeliveryInfoLabel = UILabel()
        DeliveryInfoLabel.frame = CGRect(x: 0, y: 0, width: DeliveryInfoView.frame.width, height: (4 * x))
        DeliveryInfoLabel.text = " DELIVERY INFORMATION"
        DeliveryInfoLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        DeliveryInfoLabel.font = UIFont(name: "Avenir Next", size: 16)
        DeliveryInfoLabel.font = UIFont.boldSystemFont(ofSize: 16)
        DeliveryInfoLabel.textColor = UIColor.white
        DeliveryInfoView.addSubview(DeliveryInfoLabel)
        
        
        let MapImageView = UIImageView()
        MapImageView.frame = CGRect(x: x, y: DeliveryInfoLabel.frame.maxY + (2 * y), width: (8 * x), height:(8 * y))
        MapImageView.backgroundColor = UIColor.gray
        
        /*
         if let imageName = DressImageArray[0] as? String
         {
         let api = "http://appsapi.mzyoon.com/images/DressSubType/\(imageName)"
         //  let api = "http://192.168.0.21/TailorAPI/Images/DressSubType/\(imageName)"
         let apiurl = URL(string: api)
         print("Image Of Dress", apiurl!)
         DressImageView.dowloadFromServer(url: apiurl!)
         }
         */
        DeliveryInfoView.addSubview(MapImageView)
        
        // Name Label..
        let NameLabel = UILabel()
        NameLabel.frame = CGRect(x: MapImageView.frame.maxX + (2 * x), y: DeliveryInfoLabel.frame.maxY + (3 * y) , width: (20 * x), height: (2 * y))
        NameLabel.text = "Noorul Huq"
        NameLabel.textColor = UIColor.black
        //NameLabel.backgroundColor = UIColor.gray
        NameLabel.textAlignment = .left
        NameLabel.font = UIFont(name: "Avenir Next", size: 16)
        DeliveryInfoView.addSubview(NameLabel)
        
        
        
       // OrderDetailsScrollView.contentSize.height = y1 + (20 * y)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
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
