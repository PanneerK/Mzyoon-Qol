//
//  AppointmentListViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 04/01/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit 

class AppointmentListViewController: CommonViewController,ServerAPIDelegate
{
   
     let serviceCall = ServerAPI()
    
    let AppointmentListNavigationBar = UIView()
    let AppointmentListScrollView = UIScrollView()
    
   //  let AppointmentViewButton = UIButton()
     let OR_IdLabel = UILabel()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    var BuyerId:Int!
    var SelectedOrderID:Int!
    
    var ApprovedTailorIdArray = NSArray()
    var CreatedOnArray = NSArray()
    var IdArray = NSArray()
    var NameInEnglishArray = NSArray()
    var ShopNameInEnglishArray = NSArray()
    var TailorNameInEnglishArray = NSArray()
    var ImageArray = NSArray()
    
     let emptyLabel = UILabel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     
    
    if let userId = UserDefaults.standard.value(forKey: "userId") as? Int
    {
         self.serviceCall.API_GetAppointmentList(BuyerId:userId, delegate:self)
    }
    else if let userId = UserDefaults.standard.value(forKey: "userId") as? String
    {
         self.serviceCall.API_GetAppointmentList(BuyerId:Int(userId)!, delegate:self)
    }
  }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("ERROR IN Appointment List Page:", errorMessage)
        
    }
    func API_CALLBACK_GetAppointmentList(getAppointmentList: NSDictionary)
    {
        let ResponseMsg = getAppointmentList.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = getAppointmentList.object(forKey: "Result") as! NSArray
            print(Result)
     
            if Result.count == 0 || Result == nil
            {
                emptyLabel.frame = CGRect(x: 0, y: ((view.frame.height - (3 * y)) / 2), width: view.frame.width, height: (3 * y))
                emptyLabel.text = "You don't have any order request"
                emptyLabel.textColor = UIColor.black
                emptyLabel.textAlignment = .center
                emptyLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
                emptyLabel.font = emptyLabel.font.withSize(1.5 * x)
                view.addSubview(emptyLabel)
            }
            
            ApprovedTailorIdArray = Result.value(forKey: "ApprovedTailorId") as! NSArray
            print("ApprovedTailorId:",ApprovedTailorIdArray)
            
            CreatedOnArray = Result.value(forKey: "CreatedOn") as! NSArray
            print("CreatedOn:",CreatedOnArray)
            
            IdArray = Result.value(forKey: "Id") as! NSArray
            print("Id:",IdArray)
            
            ImageArray = Result.value(forKey: "Image") as! NSArray
            print("Image:",ImageArray)
            
            NameInEnglishArray = Result.value(forKey: "NameInEnglish") as! NSArray
            print("NameInEnglish:",NameInEnglishArray)
            
            ShopNameInEnglishArray = Result.value(forKey: "ShopNameInEnglish") as! NSArray
            print("ShopNameInEnglish:",ShopNameInEnglishArray)
            
            TailorNameInEnglishArray = Result.value(forKey: "TailorNameInEnglish") as! NSArray
            print("TailorNameInEnglish:",TailorNameInEnglishArray)
            
           // self.AppointmentListContent()
         
        }
        else if ResponseMsg == "Failure"
        {
            let Result = getAppointmentList.object(forKey: "Result") as! String
            
            ErrorStr = Result
            DeviceError()
            
            emptyLabel.frame = CGRect(x: 0, y: ((view.frame.height - (3 * y)) / 2), width: view.frame.width, height: (3 * y))
            emptyLabel.text = "You don't have any order request"
            emptyLabel.textColor = UIColor.black
            emptyLabel.textAlignment = .center
            emptyLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
            emptyLabel.font = emptyLabel.font.withSize(1.5 * x)
            view.addSubview(emptyLabel)
        }
        
       self.AppointmentListContent()
    }
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "Customer"
        // ErrorStr = "Default Error"
        PageNumStr = "AppointmentListViewController"
        MethodName = "GetAppoinmentList"
        
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
    }
    func AppointmentListContent()
    {
        self.stopActivity()
        
        //let RequestListNavigationBar = UIView()
        AppointmentListNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        AppointmentListNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(AppointmentListNavigationBar)
     
      /*
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 4
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        AppointmentListNavigationBar.addSubview(backButton)
     */
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: AppointmentListNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "APPOINTMENT LIST"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        AppointmentListNavigationBar.addSubview(navigationTitle)
        
        AppointmentListView()
    }
    
    func AppointmentListView()
    {
        let backDrop = UIView()
        backDrop.frame = CGRect(x: (3 * x), y: AppointmentListNavigationBar.frame.maxY + y, width: view.frame.width - (4 * x), height: view.frame.height - (13 * y))
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
        
        AppointmentListScrollView.frame = CGRect(x: 0, y: y, width: backDrop.frame.width, height: (52 * y))
        // RequestListScrollView.backgroundColor = UIColor.gray
        backDrop.addSubview(AppointmentListScrollView)
        
        AppointmentListScrollView.contentSize.height = (12 * y * CGFloat(IdArray.count))
        
        for views in AppointmentListScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        var y1:CGFloat = 0
        
        for i in 0..<IdArray.count
        {
            //
             let AppointmentViewButton = UIButton()
            AppointmentViewButton.frame = CGRect(x: 0, y: y1, width: AppointmentListScrollView.frame.width, height: (10 * y))
            AppointmentViewButton.backgroundColor = UIColor.white
            AppointmentListScrollView.addSubview(AppointmentViewButton)
            
            //
            let DressImageView = UIImageView()
            DressImageView.frame = CGRect(x: 0, y: 0, width: (8 * x), height: AppointmentViewButton.frame.height)
            DressImageView.backgroundColor = UIColor.white  //UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            DressImageView.layer.borderWidth = 1.0
            DressImageView.layer.borderColor = UIColor.lightGray.cgColor
            // DressImageView.setImage(UIImage(named: "men"), for: .normal)
            
          
            if let imageName = ImageArray[i] as? String
            {
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/DressSubType/\(imageName)"
                print("SMALL ICON", api)
                let apiurl = URL(string: api)
                
                let dummyImageView = UIImageView()
                dummyImageView.frame = CGRect(x: 0, y: 0, width: DressImageView.frame.width, height: DressImageView.frame.height)
                dummyImageView.dowloadFromServer(url: apiurl!)
                dummyImageView.tag = -1
                DressImageView.addSubview(dummyImageView)
            }
        
            AppointmentViewButton.addSubview(DressImageView)
            
            //
            
            let orderDate_Icon = UIImageView()
            orderDate_Icon.frame = CGRect(x: DressImageView.frame.maxX + x, y: y/2, width: x, height: y)
            orderDate_Icon.image = UIImage(named: "OrderDate")
            AppointmentViewButton.addSubview(orderDate_Icon)
            
            let O_DateLabel = UILabel()
            O_DateLabel.frame = CGRect(x: orderDate_Icon.frame.maxX + x, y: 0, width: (10 * x), height: (2 * y))
            O_DateLabel.text = "Order Date :"
            O_DateLabel.textColor = UIColor.blue
            O_DateLabel.textAlignment = .left
            O_DateLabel.font =  UIFont(name: "Avenir Next", size: 1.2 * x)  //nameLabel.font.withSize(1.2 * x)
            AppointmentViewButton.addSubview(O_DateLabel)
            
            let OR_DateLabel = UILabel()
            OR_DateLabel.frame = CGRect(x: O_DateLabel.frame.maxX - x, y: 0, width: AppointmentViewButton.frame.width / 2, height: (2 * y))
            OR_DateLabel.text = CreatedOnArray[i] as? String
            OR_DateLabel.textColor = UIColor.black
            OR_DateLabel.textAlignment = .left
            OR_DateLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            AppointmentViewButton.addSubview(OR_DateLabel)
            
            //
            let orderId_Icon = UIImageView()
            orderId_Icon.frame = CGRect(x: DressImageView.frame.maxX + x, y: orderDate_Icon.frame.maxY + y, width: x, height: y)
            orderId_Icon.image = UIImage(named: "OrderID")
            AppointmentViewButton.addSubview(orderId_Icon)
            
            let O_IdLabel = UILabel()
            O_IdLabel.frame = CGRect(x: orderId_Icon.frame.maxX + x, y: O_DateLabel.frame.maxY, width: (10 * x), height: (2 * y))
            O_IdLabel.text = "Order ID :"
            O_IdLabel.textColor = UIColor.blue
            O_IdLabel.textAlignment = .left
            O_IdLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            AppointmentViewButton.addSubview(O_IdLabel)
            
            let OR_IdLabel = UILabel()
            OR_IdLabel.frame = CGRect(x: O_IdLabel.frame.maxX - x, y: O_DateLabel.frame.maxY, width: AppointmentViewButton.frame.width / 2.5, height: (2 * y))
            let orderNum : Int = IdArray[i] as! Int
            OR_IdLabel.text = "\(orderNum)"
            AppointmentViewButton.tag = IdArray[i] as! Int
            OR_IdLabel.textColor = UIColor.black
            OR_IdLabel.textAlignment = .left
            OR_IdLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            OR_IdLabel.adjustsFontSizeToFitWidth = true
            AppointmentViewButton.addSubview(OR_IdLabel)
            
            //
            let TailorName_Icon = UIImageView()
            TailorName_Icon.frame = CGRect(x: DressImageView.frame.maxX + x, y: orderId_Icon.frame.maxY + y, width: x, height: y)
            TailorName_Icon.image = UIImage(named: "TailorName")
            AppointmentViewButton.addSubview(TailorName_Icon)
            
            let T_NameLabel = UILabel()
            T_NameLabel.frame = CGRect(x: TailorName_Icon.frame.maxX + x, y: O_IdLabel.frame.maxY, width: (10 * x), height: (2 * y))
            T_NameLabel.text = "Tailor Name :"
            T_NameLabel.textColor = UIColor.blue
            T_NameLabel.textAlignment = .left
            T_NameLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            AppointmentViewButton.addSubview(T_NameLabel)
            
            let TR_NameLabel = UILabel()
            TR_NameLabel.frame = CGRect(x: T_NameLabel.frame.maxX - x, y: OR_IdLabel.frame.maxY, width: AppointmentViewButton.frame.width / 2.5, height: (2 * y))
            TR_NameLabel.text =  TailorNameInEnglishArray[i] as? String
            TR_NameLabel.textColor = UIColor.black
            TR_NameLabel.textAlignment = .left
            TR_NameLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            TR_NameLabel.adjustsFontSizeToFitWidth = true
            AppointmentViewButton.addSubview(TR_NameLabel)
            
            //
            let ShopName_Icon = UIImageView()
            ShopName_Icon.frame = CGRect(x: DressImageView.frame.maxX + x, y: TailorName_Icon.frame.maxY + y, width: x, height: y)
            ShopName_Icon.image = UIImage(named: "ShopName")
            AppointmentViewButton.addSubview(ShopName_Icon)
            
            let S_NameLabel = UILabel()
            S_NameLabel.frame = CGRect(x: ShopName_Icon.frame.maxX + x, y: T_NameLabel.frame.maxY, width: (10 * x), height: (2 * y))
            S_NameLabel.text = "Shop Name :"
            S_NameLabel.textColor = UIColor.blue
            S_NameLabel.textAlignment = .left
            S_NameLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            AppointmentViewButton.addSubview(S_NameLabel)
            
             let SH_NameLabel = UILabel()
            SH_NameLabel.frame = CGRect(x: S_NameLabel.frame.maxX - x, y: T_NameLabel.frame.maxY, width: AppointmentViewButton.frame.width / 2.5, height: (2 * y))
            SH_NameLabel.text =  ShopNameInEnglishArray[i] as? String
            SH_NameLabel.textColor = UIColor.black
            SH_NameLabel.textAlignment = .left
            SH_NameLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            SH_NameLabel.adjustsFontSizeToFitWidth = true
            AppointmentViewButton.addSubview(SH_NameLabel)
            
            //
            let ProductName_Icon = UIImageView()
            ProductName_Icon.frame = CGRect(x: DressImageView.frame.maxX + x, y: ShopName_Icon.frame.maxY + y, width: x, height: y)
            ProductName_Icon.image = UIImage(named: "ProductName")
            AppointmentViewButton.addSubview(ProductName_Icon)
            
            let P_NameLabel = UILabel()
            P_NameLabel.frame = CGRect(x: ProductName_Icon.frame.maxX + x, y: S_NameLabel.frame.maxY, width: (10 * x), height: (2 * y))
            P_NameLabel.text = "Product Name :"
            P_NameLabel.textColor = UIColor.blue
            P_NameLabel.textAlignment = .left
            P_NameLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            AppointmentViewButton.addSubview(P_NameLabel)
            
            let PR_NameLabel = UILabel()
            PR_NameLabel.frame = CGRect(x: P_NameLabel.frame.maxX - x, y: S_NameLabel.frame.maxY, width: AppointmentViewButton.frame.width / 2.5, height: (2 * y))
            PR_NameLabel.text =  NameInEnglishArray[i] as? String
            PR_NameLabel.textColor = UIColor.black
            PR_NameLabel.textAlignment = .left
            PR_NameLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            PR_NameLabel.adjustsFontSizeToFitWidth = true
            AppointmentViewButton.addSubview(PR_NameLabel)
            
            
            AppointmentViewButton.addTarget(self, action: #selector(self.confirmSelectionButtonAction(sender:)), for: .touchUpInside)
            
            y1 = AppointmentViewButton.frame.maxY + y
        }
        
        
    }
    
    @objc func confirmSelectionButtonAction(sender : UIButton)
    {
       // print("Tag Id:",OR_IdLabel.tag)
        
        let AppointmentScreen = AppointmentViewController()
        AppointmentScreen.OrderID = sender.tag
        self.navigationController?.pushViewController(AppointmentScreen, animated: true)
        
    }
    
   /*
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
   */
   
}
