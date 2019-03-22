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
    
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()

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
    
    var applicationDelegate = AppDelegate()

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
   
        
  }
    
    override func viewWillAppear(_ animated: Bool)
    {
        let navigationArray = self.navigationController?.viewControllers
        print("viewControllers Aray:",navigationArray!)
        
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
        stopActivity()
        applicationDelegate.exitContents()
        
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
    
    
    func changeViewToArabicInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.text = "قائمة المواعيد"
        
        AppointmentListScrollView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.text = "APPOINTMENT LIST"
        
        AppointmentListScrollView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    func AppointmentListContent()
    {
        self.stopActivity()
        
        //let RequestListNavigationBar = UIView()
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
        selfScreenNavigationTitle.text = "APPOINTMENT LIST"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationTitle.font = selfScreenNavigationTitle.font.withSize(2 * x)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        AppointmentListView()
        
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
    
    func AppointmentListView()
    {
        let backDrop = UIView()
        backDrop.frame = CGRect(x: (3 * x), y: selfScreenNavigationBar.frame.maxY + y, width: view.frame.width - (6 * x), height: view.frame.height - (navigationBar.frame.height + y + tabBar.frame.height))
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
        
        AppointmentListScrollView.frame = CGRect(x: (3 * x), y: navigationBar.frame.maxY + y, width: view.frame.width - (6 * x), height: view.frame.height - (navigationBar.frame.height + tabBar.frame.height + (2 * y)))
        AppointmentListScrollView.backgroundColor = UIColor.clear
        view.addSubview(AppointmentListScrollView)
        
        print("FINDING WIDTH", view.frame.width, AppointmentListScrollView.frame.width, x)
        
       
        
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
            if let date = CreatedOnArray[i] as? String
            {
                let dateSimplify = date.prefix(10)
                print("SIMPLIFIED DATE", dateSimplify)
                OR_DateLabel.text = "\(dateSimplify)"
            }
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
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    DressImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    
                    O_DateLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    O_DateLabel.text = "Order Date :"
                    O_DateLabel.textAlignment = .left
                    OR_DateLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    OR_DateLabel.textAlignment = .left
                    O_IdLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    O_IdLabel.text = "Order ID :"
                    O_IdLabel.textAlignment = .left
                    OR_IdLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    OR_IdLabel.textAlignment = .left
                    T_NameLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    T_NameLabel.text = "Tailor Name :"
                    T_NameLabel.textAlignment = .left
                    TR_NameLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    TR_NameLabel.textAlignment = .left
                    S_NameLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    S_NameLabel.text = "Shop Name :"
                    S_NameLabel.textAlignment = .left
                    SH_NameLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    SH_NameLabel.textAlignment = .left
                    P_NameLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    P_NameLabel.text = "Product Name :"
                    P_NameLabel.textAlignment = .left
                    PR_NameLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    PR_NameLabel.textAlignment = .left
                }
                else if language == "ar"
                {
                    DressImageView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    
                    O_DateLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    O_DateLabel.text = "تاريخ الطلبية :"
                    O_DateLabel.textAlignment = .right
                    OR_DateLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    OR_DateLabel.textAlignment = .right
                    O_IdLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    O_IdLabel.text = "رقم الطلبية :"
                    O_IdLabel.textAlignment = .right
                    OR_IdLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    OR_IdLabel.textAlignment = .right
                    T_NameLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    T_NameLabel.text = "اسم الخياط :"
                    T_NameLabel.textAlignment = .right
                    TR_NameLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    TR_NameLabel.textAlignment = .right
                    S_NameLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    S_NameLabel.text = "اسم المحل :"
                    S_NameLabel.textAlignment = .right
                    SH_NameLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    SH_NameLabel.textAlignment = .right
                    P_NameLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    P_NameLabel.text = "اسم المنتج :"
                    P_NameLabel.textAlignment = .right
                    PR_NameLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    PR_NameLabel.textAlignment = .right
                }
            }
            else
            {
                changeViewToEnglishInSelf()
            }
            
        }
        
         AppointmentListScrollView.contentSize.height = y1 + (2 * y)
        
        
    }
    
    @objc func confirmSelectionButtonAction(sender : UIButton)
    {
       // print("Tag Id:",OR_IdLabel.tag)
        
        let AppointmentScreen = AppointmentViewController()
        AppointmentScreen.OrderID = sender.tag
        self.navigationController?.pushViewController(AppointmentScreen, animated: true)
        
    }
    
   
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
 
   
}
