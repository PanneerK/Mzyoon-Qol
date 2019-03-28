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
    var RequestDate = String()
    
    
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
    var productNameArabicArray = NSArray()
    var RequestDtArray = NSArray()
    
    let emptyLabel = UILabel()
    
    var applicationDelegate = AppDelegate()

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//         self.tab2Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        navigationBar.isHidden = false
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                navigationTitle.text = "ORDER REQUEST LIST"
                self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            else if language == "ar"
            {
                navigationTitle.text = "طلب قائمة الطلب"
                self.navigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            }
        }
        else
        {
            navigationTitle.text = "ORDER REQUEST LIST"
            self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        selectedButton(tag: 1)
        
    //  self.serviceCall.API_GetOrderRequest(RequestId: 1070, delegate: self)
    
        
    /*
        if let userId = UserDefaults.standard.value(forKey: "userId") as? Int
        {
            self.serviceCall.API_GetOrderRequest(RequestId: userId, delegate: self)
        }
        else if let userId = UserDefaults.standard.value(forKey: "userId") as? String
        {
            self.serviceCall.API_GetOrderRequest(RequestId: Int(userId)!, delegate: self)
        }
    */
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        let navigationArray = self.navigationController?.viewControllers
        print("viewControllers Aray:",navigationArray!)
        
        if let userId = UserDefaults.standard.value(forKey: "userId") as? Int
        {
            self.serviceCall.API_GetOrderRequest(RequestId: userId, delegate: self)
        }
        else if let userId = UserDefaults.standard.value(forKey: "userId") as? String
        {
            self.serviceCall.API_GetOrderRequest(RequestId: Int(userId)!, delegate: self)
        }
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("Order Request : ", errorMessage)
        stopActivity()
        applicationDelegate.exitContents()
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
            
            if Result.count == 0
            {
                stopActivity()
                
                emptyLabel.frame = CGRect(x: 0, y: ((view.frame.height - (3 * y)) / 2), width: view.frame.width, height: (3 * y))
                if let language = UserDefaults.standard.value(forKey: "language") as? String
                {
                    if language == "en"
                    {
                        emptyLabel.text = "You Don't have Any Order Request"
                    }
                    else if language == "ar"
                    {
                        emptyLabel.text = "ليس لديك أي طلب"
                    }
                }
                else
                {
                    emptyLabel.text = "You Don't have Any Order Requests"
                }
                emptyLabel.textColor = UIColor.black
                emptyLabel.textAlignment = .center
                emptyLabel.numberOfLines = 2
                emptyLabel.adjustsFontSizeToFitWidth = true
                emptyLabel.font = UIFont(name: "Avenir Next", size: (1.5 * x))
                emptyLabel.font = emptyLabel.font.withSize(1.5 * x)
                view.addSubview(emptyLabel)
            }
            else
            {
                NoOfTailorsArray = Result.value(forKey: "NoOfTailors") as! NSArray
                print("NoOfTailorsArray", NoOfTailorsArray)
                
                OrderIdArray = Result.value(forKey: "OrderId") as! NSArray
                print("OrderIdArray", OrderIdArray)
                
                ProductImageArray = Result.value(forKey: "ProductImage") as! NSArray
                print("ProductImageArray", ProductImageArray)
                
                ProductNameArray = Result.value(forKey: "Product_NameInEnglish") as! NSArray
                print("ProductNameArray", ProductNameArray)
                
                productNameArabicArray = Result.value(forKey: "Product_NameInArabic") as! NSArray
                print("productNameArabicArray", productNameArabicArray)
                
                RequestDtArray = Result.value(forKey: "RequestDt") as! NSArray
                print("RequestDtArray", RequestDtArray)
                
//               OrderRequestListContent()
                RequestListView()
            }
            
//            OrderRequestListContent()
        }
        else if ResponseMsg == "Failure"
        {
            let Result = requestList.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "/GetOrderRequest"
            ErrorStr = Result
            DeviceError()
            
            stopActivity()
            
            emptyLabel.frame = CGRect(x: 0, y: ((view.frame.height - (3 * y)) / 2), width: view.frame.width, height: (3 * y))
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    emptyLabel.text = "You Don't have Any Order Request"
                }
                else if language == "ar"
                {
                    emptyLabel.text = "ليس لديك أي طلب"
                }
            }
            else
            {
                emptyLabel.text = "You Don't have Any Order Request"
            }
            emptyLabel.textColor = UIColor.black
            emptyLabel.textAlignment = .center
            emptyLabel.numberOfLines = 2
            emptyLabel.adjustsFontSizeToFitWidth = true
            emptyLabel.font = UIFont(name: "Avenir Next", size: (1.5 * x))
            emptyLabel.font = emptyLabel.font.withSize(1.5 * x)
            view.addSubview(emptyLabel)
        }
        
       // OrderRequestListContent()
    }
        
    
    func OrderRequestListContent()
    {
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
        self.stopActivity()
        
        let backDrop = UIView()
        backDrop.frame = CGRect(x: (3 * x), y: navigationBar.frame.maxY, width: view.frame.width - (6 * x), height: view.frame.height - (navigationBar.frame.height + tabBar.frame.height))
        backDrop.backgroundColor = UIColor.red
//        view.addSubview(backDrop)
     
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
        
        RequestListScrollView.frame = CGRect(x: (3 * x), y: navigationBar.frame.maxY + y, width: view.frame.width - (6 * x), height: view.frame.height - (navigationBar.frame.height + tabBar.frame.height + (2 * y)))
        RequestListScrollView.backgroundColor = UIColor.clear
        view.addSubview(RequestListScrollView)
        
        for views in RequestListScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        var y1:CGFloat = 0
        
        for i in 0..<OrderIdArray.count
        {
             let RequestViewButton = UIButton()
            RequestViewButton.frame = CGRect(x: 0, y: y1, width: RequestListScrollView.frame.width, height: (7 * y))
            RequestViewButton.backgroundColor = UIColor.white
            RequestListScrollView.addSubview(RequestViewButton)
            
            let tailorImageView = UIImageView()
            tailorImageView.frame = CGRect(x: 0, y: 0, width: (6 * x), height: RequestViewButton.frame.height)
            tailorImageView.layer.borderWidth = 1.0
            tailorImageView.layer.borderColor = UIColor.lightGray.cgColor
            tailorImageView.backgroundColor = UIColor.white  // UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            // tailorImageView.setImage(UIImage(named: "men"), for: .normal)
            
        
            if let imageName = ProductImageArray[i] as? String
            {
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/DressSubType/\(imageName)"
                print("Image Of Dress", api)
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
            orderId_Icon.frame = CGRect(x: tailorImageView.frame.maxX + x, y: y, width: x, height: y)
            orderId_Icon.image = UIImage(named: "OrderDate")
            RequestViewButton.addSubview(orderId_Icon)
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: orderId_Icon.frame.maxX + x, y: y/2, width: (10 * x), height: (2 * y))
            nameLabel.textColor = UIColor.blue
            nameLabel.textAlignment = .left
            nameLabel.font =  UIFont(name: "Avenir Next", size: 1.2 * x)  //nameLabel.font.withSize(1.2 * x)
            RequestViewButton.addSubview(nameLabel)
            
            let tailorName = UILabel()
            tailorName.frame = CGRect(x: nameLabel.frame.maxX - x, y: y/2, width: RequestViewButton.frame.width / 2, height: (2 * y))
            if let date = RequestDtArray[i] as? String
            {
                RequestDate = String(date.prefix(10))
            }
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
            shopLabel.textColor = UIColor.blue
            shopLabel.textAlignment = .left
            shopLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            RequestViewButton.addSubview(shopLabel)
            
            let shopName = UILabel()
            shopName.frame = CGRect(x: shopLabel.frame.maxX - x, y: nameLabel.frame.maxY, width: RequestViewButton.frame.width / 2.5, height: (2 * y))
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
            ordersLabel.textColor = UIColor.blue
            ordersLabel.textAlignment = .left
            ordersLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            RequestViewButton.addSubview(ordersLabel)
            
            let ordersCountLabel = UILabel()
            ordersCountLabel.frame = CGRect(x: ordersLabel.frame.maxX - (3 * x), y: shopLabel.frame.maxY, width: (5 * x) , height: (2 * y))
            let TailorNum : Int = NoOfTailorsArray[i] as! Int
            //ordersCountLabel.backgroundColor = UIColor.lightGray
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
           // RequestViewButton.addSubview(orderIDLabel)
            
            let orderIdNumLabel = UILabel()
            orderIdNumLabel.frame = CGRect(x: ordersCountLabel.frame.maxX + x, y: shopLabel.frame.maxY, width: (5 * x), height: (2 * y))
            let orderNum : Int = OrderIdArray[i] as! Int
            orderIdNumLabel.text =  "\(orderNum)"
            RequestViewButton.tag = OrderIdArray[i] as! Int
            orderIdNumLabel.textColor = UIColor.black
            orderIdNumLabel.textAlignment = .left
            //orderIdNumLabel.backgroundColor = UIColor.lightGray
            orderIdNumLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            orderIdNumLabel.adjustsFontSizeToFitWidth = true
            RequestViewButton.addSubview(orderIdNumLabel)
            
          //  orderIDLabel.isHidden = true
              orderIdNumLabel.isHidden = true
            
            RequestViewButton.addTarget(self, action: #selector(self.confirmSelectionButtonAction(sender:)), for: .touchUpInside)
            
            y1 = RequestViewButton.frame.maxY + y
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    RequestViewButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    tailorImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    nameLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    nameLabel.text = "Request Date  : "
                    nameLabel.textAlignment = .left
                    
                    tailorName.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    tailorName.text = RequestDate
                    tailorName.textAlignment = .left

                    shopLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    shopLabel.text = "Product Name : "
                    shopLabel.textAlignment = .left
                    
                    shopName.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    shopName.text =  ProductNameArray[i] as? String
                    shopName.textAlignment = .left
                    
                    ordersLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    ordersLabel.text = "No of Tailors    :"
                    ordersLabel.textAlignment = .left
                    
                    ordersCountLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    ordersCountLabel.textAlignment = .left
                }
                else if language == "ar"
                {
                    RequestViewButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    tailorImageView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    nameLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    nameLabel.text = "تاريخ الطلب : "
                    nameLabel.textAlignment = .right
                    
                    tailorName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    tailorName.text = RequestDate
                    tailorName.textAlignment = .right
                    
                    shopLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    shopLabel.text = "اسم المنتج :"
                    shopLabel.textAlignment = .right
                    
                    shopName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    shopName.text =  productNameArabicArray[i] as? String
                    shopName.textAlignment = .right
                    
                    ordersLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    ordersLabel.text = "إجمالي عدد الخياطين:"
                    ordersLabel.textAlignment = .right
                    
                    ordersCountLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    ordersCountLabel.textAlignment = .right
                }
            }
            else
            {
                RequestViewButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                tailorImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                nameLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                nameLabel.text = "Request Date  : "
                nameLabel.textAlignment = .left
                
                tailorName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                tailorName.text = RequestDate
                tailorName.textAlignment = .left
                
                shopLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                shopLabel.text = "Product Name : "
                shopLabel.textAlignment = .left
                
                shopName.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                shopName.text =  ProductNameArray[i] as? String
                shopName.textAlignment = .left
                
                ordersLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                ordersLabel.text = "No of Tailors    :"
                ordersLabel.textAlignment = .left
                
                ordersCountLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                ordersCountLabel.textAlignment = .left
            }
        }
        
        RequestListScrollView.contentSize.height = y1 + (2 * y)

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
