//
//  OrderRequestListViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 28/12/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class OrderRequestListViewController: CommonViewController,ServerAPIDelegate
{

    let serviceCall = ServerAPI()
    
    let RequestListNavigationBar = UIView()
    let RequestListScrollView = UIScrollView()
    // var RequestViewButton = UIButton()
    //let orderIdNumLabel = UILabel()
    
    var BuyerId : Int!
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    
    var NoOfTailorsArray = NSArray()
    var OrderIdArray = NSArray()
    var ProductImageArray = NSArray()
    var ProductNameArray = NSArray()
    var RequestDtArray = NSArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//         self.tab2Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        selectedButton(tag: 1)

      if(BuyerId != nil)
      {
        let BuyerId = UserDefaults.standard.value(forKey: "userId") as! String
         print("Buyer ID:",BuyerId)
        self.serviceCall.API_GetOrderRequest(RequestId: Int(BuyerId)!, delegate: self)
      }
      else
      {
        // let BuyerID = UserDefaults.standard.value(forKey: "userId") as? String
        self.serviceCall.API_GetOrderRequest(RequestId: 1055, delegate: self)
      }
        // Do any additional setup after loading the view.
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("Order Request : ", errorMessage)
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        // ErrorStr = "Default Error"
        PageNumStr = "OrderRequestListViewController"
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
    
    func API_CALLBACK_GetOrderRequest(requestList: NSDictionary)
    {
        let ResponseMsg = requestList.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = requestList.object(forKey: "Result") as! NSArray
            print("Request List:", Result)
            
            
            NoOfTailorsArray = Result.value(forKey: "NoOfTailors") as! NSArray
            print("NoOfTailorsArray", NoOfTailorsArray)
            
            OrderIdArray = Result.value(forKey: "OrderId") as! NSArray
            print("OrderIdArray", OrderIdArray)
            
            ProductImageArray = Result.value(forKey: "ProductImage") as! NSArray
            print("ProductImageArray", ProductImageArray)
            
            ProductNameArray = Result.value(forKey: "Product_NameInEnglish") as! NSArray
            print("ProductNameArray", ProductNameArray)
            
            RequestDtArray = Result.value(forKey: "RequestDt") as! NSArray
            print("RequestDtArray", RequestDtArray)
            
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = requestList.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "/GetOrderRequest"
            ErrorStr = Result
            DeviceError()
        }
        
         OrderRequestListContent()
    }
        
    
    func OrderRequestListContent()
    {
        self.stopActivity()
        
        //let RequestListNavigationBar = UIView()
        RequestListNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        RequestListNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(RequestListNavigationBar)
        
       let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: RequestListNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "ORDER REQUEST LIST"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        RequestListNavigationBar.addSubview(navigationTitle)
        
        RequestListView()
    }
    
  
    
    func RequestListView()
    {
        let backDrop = UIView()
        backDrop.frame = CGRect(x: (3 * x), y: RequestListNavigationBar.frame.maxY + y, width: view.frame.width - (4 * x), height: view.frame.height - (13 * y))
        backDrop.backgroundColor = UIColor.clear
        view.addSubview(backDrop)
     
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
        
        RequestListScrollView.frame = CGRect(x: 0, y: y, width: backDrop.frame.width, height: (52 * y))
       // RequestListScrollView.backgroundColor = UIColor.gray
        backDrop.addSubview(RequestListScrollView)
        
        RequestListScrollView.contentSize.height = (12 * y * CGFloat(OrderIdArray.count))
        
        for views in RequestListScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        var y1:CGFloat = 0
        
        for i in 0..<OrderIdArray.count
        {
             let RequestViewButton = UIButton()
            RequestViewButton.frame = CGRect(x: 0, y: y1, width: RequestListScrollView.frame.width, height: (8 * y))
            RequestViewButton.backgroundColor = UIColor.white
            RequestListScrollView.addSubview(RequestViewButton)
            
            let tailorImageView = UIImageView()
            tailorImageView.frame = CGRect(x: 0, y: 0, width: (8 * x), height: RequestViewButton.frame.height)
            tailorImageView.layer.borderWidth = 1.0
            tailorImageView.layer.borderColor = UIColor.lightGray.cgColor
            tailorImageView.backgroundColor = UIColor.white  // UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            // tailorImageView.setImage(UIImage(named: "men"), for: .normal)
            
        
            if let imageName = ProductImageArray[i] as? String
            {
                // let api = "http://appsapi.mzyoon.com/images/DressSubType/\(imageName)"
                let api = "http://192.168.0.21/TailorAPI/Images/DressSubType/\(imageName)"
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
         
            RequestViewButton.addSubview(tailorImageView)
 
            //
            let orderId_Icon = UIImageView()
            orderId_Icon.frame = CGRect(x: tailorImageView.frame.maxX + x, y: y/2, width: x, height: y)
            orderId_Icon.image = UIImage(named: "OrderDate")
            RequestViewButton.addSubview(orderId_Icon)
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: orderId_Icon.frame.maxX + x, y: 0, width: (10 * x), height: (2 * y))
            nameLabel.text = "Request Date :"
            nameLabel.textColor = UIColor.blue
            nameLabel.textAlignment = .left
            nameLabel.font =  UIFont(name: "Avenir Next", size: 1.2 * x)  //nameLabel.font.withSize(1.2 * x)
            RequestViewButton.addSubview(nameLabel)
            
            let tailorName = UILabel()
            tailorName.frame = CGRect(x: nameLabel.frame.maxX - x, y: 0, width: RequestViewButton.frame.width / 2, height: (2 * y))
            tailorName.text = RequestDtArray[i] as? String
            tailorName.textColor = UIColor.black
            tailorName.textAlignment = .left
            tailorName.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            RequestViewButton.addSubview(tailorName)
            
            //
            let ProductName_Icon = UIImageView()
            ProductName_Icon.frame = CGRect(x: tailorImageView.frame.maxX + x, y: orderId_Icon.frame.maxY + y, width: x, height: y)
            ProductName_Icon.image = UIImage(named: "ProductName")
            RequestViewButton.addSubview(ProductName_Icon)
            
            let shopLabel = UILabel()
            shopLabel.frame = CGRect(x: ProductName_Icon.frame.maxX + x, y: nameLabel.frame.maxY, width: (10 * x), height: (2 * y))
            shopLabel.text = "Product Name :"
            shopLabel.textColor = UIColor.blue
            shopLabel.textAlignment = .left
            shopLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            RequestViewButton.addSubview(shopLabel)
            
            let shopName = UILabel()
            shopName.frame = CGRect(x: shopLabel.frame.maxX - x, y: nameLabel.frame.maxY, width: RequestViewButton.frame.width / 2.5, height: (2 * y))
            shopName.text =  ProductNameArray[i] as? String
            shopName.textColor = UIColor.black
            shopName.textAlignment = .left
            shopName.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            shopName.adjustsFontSizeToFitWidth = true
            RequestViewButton.addSubview(shopName)
            
            //
            let Tailor_Icon = UIImageView()
            Tailor_Icon.frame = CGRect(x: tailorImageView.frame.maxX + x, y: ProductName_Icon.frame.maxY + y, width: x, height: y)
            Tailor_Icon.image = UIImage(named: "OrderID")
            RequestViewButton.addSubview(Tailor_Icon)
            
            let ordersLabel = UILabel()
            ordersLabel.frame = CGRect(x: Tailor_Icon.frame.maxX + x, y: shopLabel.frame.maxY, width: (12 * x), height: (2 * y))
            ordersLabel.text = "Total No of Tailors :"
            ordersLabel.textColor = UIColor.blue
            ordersLabel.textAlignment = .left
            ordersLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            RequestViewButton.addSubview(ordersLabel)
            
            let ordersCountLabel = UILabel()
            ordersCountLabel.frame = CGRect(x: ordersLabel.frame.maxX - x, y: shopLabel.frame.maxY, width: RequestViewButton.frame.width / 2.5, height: (2 * y))
            let TailorNum : Int = NoOfTailorsArray[i] as! Int
            ordersCountLabel.text =  "\(TailorNum)"
            ordersCountLabel.textColor = UIColor.black
            ordersCountLabel.textAlignment = .left
            ordersCountLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            ordersCountLabel.adjustsFontSizeToFitWidth = true
            RequestViewButton.addSubview(ordersCountLabel)
            
            //
            let orderIDLabel = UILabel()
            orderIDLabel.frame = CGRect(x: tailorImageView.frame.maxX + x, y: ordersLabel.frame.maxY, width: (10 * x), height: (2 * y))
            orderIDLabel.text = "Order ID :"
            orderIDLabel.textColor = UIColor.blue
            orderIDLabel.textAlignment = .left
            orderIDLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            RequestViewButton.addSubview(orderIDLabel)
            
            let orderIdNumLabel = UILabel()
            orderIdNumLabel.frame = CGRect(x: orderIDLabel.frame.maxX - x, y: ordersLabel.frame.maxY, width: RequestViewButton.frame.width / 2.5, height: (2 * y))
            let orderNum : Int = OrderIdArray[i] as! Int
            orderIdNumLabel.text =  "\(orderNum)"
            RequestViewButton.tag = OrderIdArray[i] as! Int
            orderIdNumLabel.textColor = UIColor.black
            orderIdNumLabel.textAlignment = .left
            orderIdNumLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            orderIdNumLabel.adjustsFontSizeToFitWidth = true
            RequestViewButton.addSubview(orderIdNumLabel)
            
            orderIDLabel.isHidden = true
            orderIdNumLabel.isHidden = true
            
            RequestViewButton.addTarget(self, action: #selector(self.confirmSelectionButtonAction(sender:)), for: .touchUpInside)
            
            y1 = RequestViewButton.frame.maxY + y
        }
        
      
    }
    
    @objc func confirmSelectionButtonAction(sender : UIButton)
    {
        
        let QuotationListScreen = QuotationListViewController()
        QuotationListScreen.OrderId = sender.tag
        self.navigationController?.pushViewController(QuotationListScreen, animated: true)
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
