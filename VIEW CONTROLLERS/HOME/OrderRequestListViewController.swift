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
         self.tab2Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
       
        self.serviceCall.API_GetOrderRequest(RequestId: 1, delegate: self)
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
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func RequestListView()
    {
        let backDrop = UIView()
        backDrop.frame = CGRect(x: (3 * x), y: RequestListNavigationBar.frame.maxY + y, width: view.frame.width - (6 * x), height: view.frame.height - (13 * y))
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
            RequestViewButton.frame = CGRect(x: 0, y: y1, width: RequestListScrollView.frame.width, height: (10 * y))
            RequestViewButton.backgroundColor = UIColor.white
            RequestListScrollView.addSubview(RequestViewButton)
            
            let tailorImageView = UIImageView()
            tailorImageView.frame = CGRect(x: x, y: y, width: (8 * x), height: (8 * y))
           // tailorImageView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            // tailorImageView.setImage(UIImage(named: "men"), for: .normal)
            
        
            if let imageName = ProductImageArray[i] as? String
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
         
            RequestViewButton.addSubview(tailorImageView)
 
         
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: tailorImageView.frame.maxX + x, y: y, width: (10 * x), height: (2 * y))
            nameLabel.text = "Request Date : "
            nameLabel.textColor = UIColor.blue
            nameLabel.textAlignment = .left
            nameLabel.font =  UIFont(name: "Avenir Next", size: 1.2 * x)  //nameLabel.font.withSize(1.2 * x)
            RequestViewButton.addSubview(nameLabel)
            
            let tailorName = UILabel()
            tailorName.frame = CGRect(x: nameLabel.frame.maxX, y: y, width: RequestViewButton.frame.width / 2, height: (2 * y))
            tailorName.text = RequestDtArray[i] as? String
            tailorName.textColor = UIColor.black
            tailorName.textAlignment = .left
            tailorName.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            RequestViewButton.addSubview(tailorName)
            
            let shopLabel = UILabel()
            shopLabel.frame = CGRect(x: tailorImageView.frame.maxX + x, y: nameLabel.frame.maxY, width: (10 * x), height: (2 * y))
            shopLabel.text = "Product Name : "
            shopLabel.textColor = UIColor.blue
            shopLabel.textAlignment = .left
            shopLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            RequestViewButton.addSubview(shopLabel)
            
            let shopName = UILabel()
            shopName.frame = CGRect(x: shopLabel.frame.maxX, y: nameLabel.frame.maxY, width: RequestViewButton.frame.width / 2.5, height: (2 * y))
            shopName.text =  ProductNameArray[i] as? String
            shopName.textColor = UIColor.black
            shopName.textAlignment = .left
            shopName.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            shopName.adjustsFontSizeToFitWidth = true
            RequestViewButton.addSubview(shopName)
            
            let ordersLabel = UILabel()
            ordersLabel.frame = CGRect(x: tailorImageView.frame.maxX + x, y: shopLabel.frame.maxY, width: (10 * x), height: (2 * y))
            ordersLabel.text = "No of Tailors : "
            ordersLabel.textColor = UIColor.blue
            ordersLabel.textAlignment = .left
            ordersLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            RequestViewButton.addSubview(ordersLabel)
            
            let ordersCountLabel = UILabel()
            ordersCountLabel.frame = CGRect(x: ordersLabel.frame.maxX, y: shopLabel.frame.maxY, width: RequestViewButton.frame.width / 2.5, height: (2 * y))
            ordersCountLabel.text =  NoOfTailorsArray[i] as? String
            ordersCountLabel.textColor = UIColor.black
            ordersCountLabel.textAlignment = .left
            ordersCountLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            ordersCountLabel.adjustsFontSizeToFitWidth = true
            RequestViewButton.addSubview(ordersCountLabel)
            
            RequestViewButton.addTarget(self, action: #selector(self.confirmSelectionButtonAction(sender:)), for: .touchUpInside)
            
            y1 = RequestViewButton.frame.maxY + y
        }
        
      
    }
    
    @objc func confirmSelectionButtonAction(sender : UIButton)
    {
        let QuotationListScreen = QuotationListViewController()
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