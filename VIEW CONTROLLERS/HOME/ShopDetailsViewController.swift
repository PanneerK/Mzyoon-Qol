//
//  ShopDetailsViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 27/02/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class ShopDetailsViewController: CommonViewController,UITableViewDelegate,UITableViewDataSource,ServerAPIDelegate
{
   
    let serviceCall = ServerAPI()
    
    //SCREEN PARAMETERS
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()
    let selfScreenContents = UIView()

    
    let shopName = UILabel()
    let ratingImageView = UIImageView()
    let ratingCountLabel = UILabel()
    let reviewsButton = UIButton()
    let ordersCountLabel = UILabel()
    let tailorName = UILabel()
    let Call_LBL = UILabel()
    let Link_Label = UILabel()
    let Address_Label = UILabel()
    
    var strPhoneNumber:String!
    
     let TimingsTableView = UITableView()
    let blurView = UIView()
    let alertView = UIView()
    let titleLabel = UILabel()
    let cancelButton = UIButton()
    
    var DaysArray = NSArray()
    var TimeArray = NSArray()
    
     var TailorID:Int!
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    // String..
    var AddressInEnglish:String!
    var ShopNameInEnglish:String!
    var CountryName:String!
    var StateName:String!
    var TailorNameInEnglish:String!
    var WebSite:String!
    var PhoneNumber:String!
    var OrderCount:String!
    var Rating:String!
    var Review:String!
    
    
    // Array..
    var AddressArray = NSArray()
    var ShopNameArray = NSArray()
    var TailorNameArray = NSArray()
    var CountryArray = NSArray()
    var StateArray = NSArray()
    var WebsiteArray = NSArray()
    var PhoneNumberArray = NSArray()
    var OrderCountArray = NSArray()
    var RatingArray = NSArray()
    var ReviewArray = NSArray()
    var ShopImageArray = NSArray()
    var TailorShopTimeArray = NSArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //  let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(ShopDetailsViewController.panGesture))
        //  view.addGestureRecognizer(gesture)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
    //  prepareBackgroundView()
        
       if(TailorID != nil)
       {
         self.serviceCall.API_GetShopDetails(TailorId: TailorID!, delegate: self)
       }
     
   
       // ShopDetailsContent()
       // strPhoneNumber = "+91 8015557649"
        
        DaysArray = ["Sunday","Monday","Tuesday","Wednesday","Thrusday","Friday","Saturday"]
        TimeArray = ["Closed","9.00 AM - 9.00 PM","9.00 AM - 9.00 PM","9.00 AM - 9.00 PM","9.00 AM - 9.00 PM","9.00 AM - 9.00 PM","9.00 AM - 9.00 PM"]
        
    }
    
   /*
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            let frame = self?.view.frame
            let yComponent = UIScreen.main.bounds.height - 200
            self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
                                    // CGRectMake(0, yComponent, frame!.width, frame!.height)
        }
    }
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer)
    {
        let translation = recognizer.translation(in: self.view)
        let y = self.view.frame.minY
        self.view.frame = CGRect(x: 0, y: y+translation.y, width: view.frame.width, height: view.frame.width)
        // CGRectMake(0, y + translation.y, view.frame.width, view.frame.height)
        recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
        
    }
     
     func prepareBackgroundView()
     {
     let blurEffect = UIBlurEffect.init(style: .dark)
     let visualEffect = UIVisualEffectView.init(effect: blurEffect)
     let bluredView = UIVisualEffectView.init(effect: blurEffect)
     bluredView.contentView.addSubview(visualEffect)
     
     visualEffect.frame = UIScreen.main.bounds
     bluredView.frame = UIScreen.main.bounds
     
     view.insertSubview(bluredView, at: 0)
     }
 */
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        // ErrorStr = "Default Error"
        PageNumStr = "ShopDetailsViewController"
        //  MethodName = "do"
        
        print("UUID", UIDevice.current.identifierForVendor?.uuidString as Any)
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
    }
    
 
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("Shop Details : ", errorMessage)
    }
    
    func API_CALLBACK_GetShopDetails(getShopDetails: NSDictionary)
    {
        let ResponseMsg = getShopDetails.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = getShopDetails.object(forKey: "Result") as! NSDictionary
            print("Shop Details :", Result)
            
            let GetShopDetails = Result.object(forKey: "GetShopDetails") as! NSArray
            print("GetShopDetails:",GetShopDetails)
            
            AddressArray = GetShopDetails.value(forKey: "AddressInEnglish") as! NSArray
            print("AddressArray:",AddressArray)
          //  AddressInEnglish = AddressArray[0] as? String
          //  print("AddressInEnglish:",AddressInEnglish)
            
            CountryArray = GetShopDetails.value(forKey: "CountryName") as! NSArray
             print("CountryArray:",CountryArray)
          //  CountryName = CountryArray[0] as? String
          //  print("CountryName:",CountryName)
            
            PhoneNumberArray = GetShopDetails.value(forKey: "PhoneNumber") as! NSArray
            print("PhoneNumberArray:",PhoneNumberArray)
          //  PhoneNumber = PhoneNumberArray[0] as? String
          //  print("PhoneNumber:",PhoneNumber)
            
            StateArray = GetShopDetails.value(forKey: "StateName") as! NSArray
            print("StateArray:",StateArray)
          //  StateName = StateArray[0] as? String
          //  print("StateName:",StateName)
            
            TailorNameArray = GetShopDetails.value(forKey: "TailorNameInEnglish") as! NSArray
            print("TailorNameArray:",TailorNameArray)
           // TailorNameInEnglish = TailorNameArray[0] as? String
           // print("TailorNameInEnglish:",TailorNameInEnglish)
            
            WebsiteArray = GetShopDetails.value(forKey: "WebSite") as! NSArray
            print("WebsiteArray:",WebsiteArray)
           // WebSite = WebsiteArray[0] as? String
           // print("WebSite:",WebSite)
            
            ShopNameArray = GetShopDetails.value(forKey: "ShopNameInEnglish") as! NSArray
            print("ShopNameArray:",ShopNameArray)
           // ShopNameInEnglish = ShopNameArray[0] as? String
           // print("ShopNameInEnglish:",ShopNameInEnglish)
            
            
            let OrderCounts = Result.object(forKey: "OrderCount") as! NSArray
            print("OrderCounts:",OrderCounts)
            
            OrderCountArray = OrderCounts.value(forKey: "OrderCount") as! NSArray
            print("OrderCountArray:",OrderCountArray)
          //  OrderCount = OrderCountArray[0] as? String
           // print("OrderCount:",OrderCount)
            
            RatingArray = OrderCounts.value(forKey: "Rating") as! NSArray
            print("RatingArray:",RatingArray)
          //  Rating = RatingArray[0] as? String
          //  print("Rating:",Rating)
            
            
            let ReviewCount = Result.object(forKey: "ReviewCount") as! NSArray
            print("ReviewCount:",ReviewCount)
            
            ReviewArray = ReviewCount.value(forKey: "Review") as! NSArray
            print("ReviewArray:",ReviewArray)
          //  Review = ReviewArray[0] as? String
           // print("Review:",Review)
            
            
            let ShopImages = Result.object(forKey: "ShopImages") as! NSArray
            print("ShopImages:",ShopImages)
            
            ShopImageArray = ShopImages.value(forKey: "Image") as! NSArray
            print("ShopImageArray:",ShopImageArray)
            
            
            let TailorShopTime = Result.object(forKey: "TailorShopTime") as! NSArray
            print("TailorShopTime:",TailorShopTime)
            
            TailorShopTimeArray = TailorShopTime.value(forKey: "TailorShopTime") as! NSArray
            print("ShopImageArray:",ShopImageArray)
         
        }
        else if ResponseMsg == "Failure"
        {
            let Result = getShopDetails.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetShopDetails"
            ErrorStr = Result
            DeviceError()
        }
        
        self.ShopDetailsContent()
    }
    
    func changeViewToArabicInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        selfScreenContents.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        shopName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        shopName.textAlignment = .right
        
        reviewsButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        tailorName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        tailorName.textAlignment = .right
        
        ordersCountLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        ordersCountLabel.textAlignment = .right
    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        selfScreenContents.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        shopName.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        shopName.textAlignment = .left
        
        reviewsButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        tailorName.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        tailorName.textAlignment = .left
        
        ordersCountLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        ordersCountLabel.textAlignment = .left
    }
    
  func ShopDetailsContent()
  {
     self.stopActivity()
    
     selfScreenNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width,  height: (6.4 * y))
     selfScreenNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
    view.addSubview(selfScreenNavigationBar)
    
    let backButton = UIButton()
    backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
    backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
    backButton.tag = 4
    backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
    selfScreenNavigationBar.addSubview(backButton)
    
    selfScreenNavigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: selfScreenNavigationBar.frame.width, height: (3 * y))
    if(ShopNameArray.count > 0)
    {
      selfScreenNavigationTitle.text = ShopNameArray[0] as? String
    }
    else
    {
         selfScreenNavigationTitle.text = "SHOP DETAILS"
    }
    selfScreenNavigationTitle.textColor = UIColor.white
    selfScreenNavigationTitle.textAlignment = .center
    selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
    selfScreenNavigationTitle.font = selfScreenNavigationTitle.font.withSize(2 * x)
    selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
    
    selfScreenContents.frame = CGRect(x: (3 * x), y: selfScreenNavigationBar.frame.maxY, width: view.frame.width - (6 * x), height: view.frame.height - ((5 * y) + selfScreenNavigationBar.frame.maxY))
    selfScreenContents.backgroundColor = UIColor.clear
    view.addSubview(selfScreenContents)
    
    // let shopName = UILabel()
    shopName.frame = CGRect(x: 0, y: y, width: selfScreenContents.frame.width, height: (3 * y))
  //  shopName.text = ShopNameInEnglish   // marker.title?.uppercased()
    shopName.textColor = UIColor.blue
    shopName.textAlignment = .left
    shopName.font = UIFont(name: "Avenir Next", size: (1.5 * x))
    shopName.adjustsFontSizeToFitWidth = true
    selfScreenContents.addSubview(shopName)
    
   // print("SHOP NAME", shopName.text!)
  //  shopName.attributedText = NSAttributedString(string: shopName.text!, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    
    let ratingLabel = UILabel()
    ratingLabel.frame = CGRect(x: selfScreenContents.frame.minX, y: shopName.frame.maxY + (y / 2), width: (5 * x), height: (2 * y))
    ratingLabel.text = "Rating : "
    ratingLabel.textColor = UIColor.blue
    ratingLabel.textAlignment = .left
    ratingLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
    //view.addSubview(ratingLabel)
    
    //let ratingImageView = UIImageView()
    ratingImageView.frame = CGRect(x: 0, y: shopName.frame.maxY + (y / 2), width: view.frame.width / 4, height: (1.5 * y))
    selfScreenContents.addSubview(ratingImageView)
    
    
   // let reviewsButton = UIButton()
    reviewsButton.frame = CGRect(x: ratingImageView.frame.maxX, y: shopName.frame.maxY + (y / 2), width: (10 * x), height: (2 * y))
    // reviewsButton.backgroundColor = UIColor.lightGray
    reviewsButton.setTitleColor(UIColor.blue, for: .normal)
    reviewsButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.2 * x)!
    reviewsButton.addTarget(self, action: #selector(self.ReviewsButtonAction(sender:)), for: .touchUpInside)
    selfScreenContents.addSubview(reviewsButton)
    
    //let ratingCountLabel = UILabel()
    ratingCountLabel.frame = CGRect(x: ratingImageView.frame.maxX, y: shopName.frame.maxY + (y / 2), width: view.frame.width / 2.5, height: (2 * y))
    ratingCountLabel.textColor = UIColor.black
    ratingCountLabel.textAlignment = .left
    ratingCountLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
    ratingCountLabel.adjustsFontSizeToFitWidth = true
    view.addSubview(ratingCountLabel)
    
    let Name_Icon = UIImageView()
    Name_Icon.frame = CGRect(x: (3 * x), y: ratingImageView.frame.maxY + (y / 2), width: x, height: y)
    Name_Icon.image = UIImage(named: "TailorName")
   // view.addSubview(Name_Icon)
    
    let nameLabel = UILabel()
    nameLabel.frame = CGRect(x: 0, y: ratingImageView.frame.maxY + (y / 2), width: (5 * x), height: (2 * y))
    nameLabel.text = "Name : "
    nameLabel.textColor = UIColor.blue
    nameLabel.textAlignment = .left
    nameLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
    selfScreenContents.addSubview(nameLabel)
    
   // let tailorName = UILabel()
    tailorName.frame = CGRect(x: nameLabel.frame.maxX, y: ratingImageView.frame.maxY + (y / 2), width: view.frame.width / 2, height: (2 * y))
   // tailorName.text = "Tailor Name"  //marker.snippet
    tailorName.textColor = UIColor.black
    tailorName.textAlignment = .left
    tailorName.font = UIFont(name: "Avenir Next", size: (1.2 * x))
    selfScreenContents.addSubview(tailorName)
    
    let ordersLabel = UILabel()
    ordersLabel.frame = CGRect(x: 0, y: nameLabel.frame.maxY, width: (9 * x), height: (2 * y))
    ordersLabel.text = "No. of Orders : "
    ordersLabel.textColor = UIColor.blue
    ordersLabel.textAlignment = .left
    ordersLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
    selfScreenContents.addSubview(ordersLabel)
    
    //let ordersCountLabel = UILabel()
    ordersCountLabel.frame = CGRect(x: ordersLabel.frame.maxX, y: nameLabel.frame.maxY, width: view.frame.width / 2.5, height: (2 * y))
    ordersCountLabel.textColor = UIColor.black
    ordersCountLabel.textAlignment = .left
    ordersCountLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
    ordersCountLabel.adjustsFontSizeToFitWidth = true
    selfScreenContents.addSubview(ordersCountLabel)
    
    
    let DetailsView = UIView()
    DetailsView.frame = CGRect(x: 0, y: ordersCountLabel.frame.maxY + y, width: view.frame.width - (6 * x), height: (11 * y))
    DetailsView.backgroundColor = UIColor.white
    DetailsView.layer.borderWidth = 1
    DetailsView.layer.borderColor = UIColor.lightGray.cgColor
    selfScreenContents.addSubview(DetailsView)
    
    let Addr_Icon = UIImageView()
    Addr_Icon.frame = CGRect(x: x, y: y, width: (1.5 * x), height: (1.5 * y))
    Addr_Icon.image = UIImage(named: "Contact")
    DetailsView.addSubview(Addr_Icon)
    
    let Address_Label = UILabel()
    Address_Label.frame = CGRect(x: Addr_Icon.frame.maxX + x, y: y, width: (26 * x), height: (1.5 * y))
    // Address_Label.backgroundColor = UIColor.lightGray
   // Address_Label.text = "Villa No:58, Near Dubai Zoo,Dubai, UAE"
    Address_Label.font = UIFont(name: "Avenir Next", size: (1.2 * x))
    DetailsView.addSubview(Address_Label)
    
     let underLine1 = UILabel()
     underLine1.frame = CGRect(x: 0, y: Address_Label.frame.maxY + y, width: DetailsView.frame.width, height: 0.5)
     underLine1.backgroundColor = UIColor.lightGray
     DetailsView.addSubview(underLine1)
    
    let Time_Icon = UIImageView()
    Time_Icon.frame = CGRect(x: x, y: underLine1.frame.maxY + y, width: (1.5 * x), height: (1.5 * y))
    Time_Icon.image = UIImage(named: "ShopTime")
    DetailsView.addSubview(Time_Icon)
    
    let Time_Label = UILabel()
    Time_Label.frame = CGRect(x: Time_Icon.frame.maxX + x, y: underLine1.frame.maxY + y, width: (16 * x), height: (1.5 * y))
    //Time_Label.backgroundColor = UIColor.lightGray
    Time_Label.text = "OPEN : Closes 09:00 PM"
    Time_Label.font = UIFont(name: "Avenir Next", size: (1.2 * x))
    DetailsView.addSubview(Time_Label)
    
    let DownArrow_Icon = UIButton()
    DownArrow_Icon.frame = CGRect(x: Time_Label.frame.maxX, y: underLine1.frame.maxY + y, width: (1.5 * x), height: (1.5 * y))
    DownArrow_Icon.setImage(UIImage(named: "downArrow"), for: .normal)
    DownArrow_Icon.addTarget(self, action: #selector(self.TimingsButtonAction(sender:)), for: .touchUpInside)
     DetailsView.addSubview(DownArrow_Icon)
    
    let underLine2 = UILabel()
    underLine2.frame = CGRect(x: 0, y: Time_Label.frame.maxY + y, width: DetailsView.frame.width, height: 0.5)
    underLine2.backgroundColor = UIColor.lightGray
    DetailsView.addSubview(underLine2)
    
    let Link_Icon = UIImageView()
    Link_Icon.frame = CGRect(x: x, y: underLine2.frame.maxY + y, width: (1.5 * x), height: (1.5 * y))
    Link_Icon.image = UIImage(named: "WebLink")
    DetailsView.addSubview(Link_Icon)
    
   // let Link_Label = UILabel()
    Link_Label.frame = CGRect(x: Time_Icon.frame.maxX + x, y: underLine2.frame.maxY + y, width: (20 * x), height: (1.5 * y))
   // Link_Label.backgroundColor = UIColor.lightGray
    // Link_Label.text = "http://www.shopname.com"
    Link_Label.font = UIFont(name: "Avenir Next", size: (1.3 * x))
    DetailsView.addSubview(Link_Label)
    
    // Directions Button..
    let Direction_Btn = UIButton()
    Direction_Btn.frame = CGRect(x: (3 * x), y: DetailsView.frame.maxY + (2 * y), width: (5 * x), height: (4.8 * y))
    Direction_Btn.backgroundColor = UIColor.white
   // Direction_Btn.layer.shadowColor = UIColor.black.cgColor
    Direction_Btn.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
    Direction_Btn.layer.masksToBounds = false
    Direction_Btn.layer.shadowRadius = 1.0
    Direction_Btn.layer.shadowOpacity = 0.5
    Direction_Btn.layer.cornerRadius = Direction_Btn.frame.width / 2
    Direction_Btn.layer.borderColor = UIColor.lightGray.cgColor
    Direction_Btn.layer.borderWidth = 1.0
    Direction_Btn.setImage(UIImage(named: "Directions"), for: .normal)
    Direction_Btn.addTarget(self, action: #selector(self.DirectionButtonAction(sender:)), for: .touchUpInside)
    selfScreenContents.addSubview(Direction_Btn)
    
    let Directions_LBL = UILabel()
    Directions_LBL.frame = CGRect(x: (2 * x), y: Direction_Btn.frame.maxY + y, width: (8 * x), height: y)
   // Directions_LBL.backgroundColor = UIColor.lightGray
    Directions_LBL.text = "DIRECTIONS"
    Directions_LBL.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
    Directions_LBL.font = UIFont(name: "Avenir Next", size: y)
    Directions_LBL.textAlignment = .center
    selfScreenContents.addSubview(Directions_LBL)
    
    // Call Button..
    let Call_Btn = UIButton()
    Call_Btn.frame = CGRect(x: Direction_Btn.frame.maxX + (6 * x), y: DetailsView.frame.maxY + (2 * y), width: (5 * x), height: (4.8 * y))
    Call_Btn.backgroundColor = UIColor.white
   // Call_Btn.layer.shadowColor = UIColor.black.cgColor
    Call_Btn.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
    Call_Btn.layer.masksToBounds = false
    Call_Btn.layer.shadowRadius = 1.0
    Call_Btn.layer.shadowOpacity = 0.5
    Call_Btn.layer.cornerRadius = Call_Btn.frame.width / 2
    Call_Btn.layer.borderColor = UIColor.lightGray.cgColor
    Call_Btn.layer.borderWidth = 1.0
    Call_Btn.setImage(UIImage(named: "mobile-number"), for: .normal)
    Call_Btn.addTarget(self, action: #selector(self.CallButtonAction(sender:)), for: .touchUpInside)
    selfScreenContents.addSubview(Call_Btn)
    
    //let Call_LBL = UILabel()
    Call_LBL.frame = CGRect(x: Directions_LBL.frame.maxX + (2 * x), y: Direction_Btn.frame.maxY + y, width: (10 * x), height: y)
    //Call_LBL.backgroundColor = UIColor.lightGray
   // Call_LBL.text = "044 48616069"
    Call_LBL.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
    Call_LBL.font = UIFont(name: "Avenir Next", size: y)
    Call_LBL.textAlignment = .center
    selfScreenContents.addSubview(Call_LBL)
    
    // Share Button..
    let Share_Btn = UIButton()
    Share_Btn.frame = CGRect(x: Call_Btn.frame.maxX + (6 * x), y: DetailsView.frame.maxY + (2 * y), width: (5 * x), height: (4.8 * y))
    Share_Btn.backgroundColor = UIColor.white
    // Share_Btn.layer.shadowColor = UIColor.black.cgColor
    Share_Btn.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
    Share_Btn.layer.masksToBounds = false
    Share_Btn.layer.shadowRadius = 1.0
    Share_Btn.layer.shadowOpacity = 0.5
    Share_Btn.layer.cornerRadius = Share_Btn.frame.width / 2
    Share_Btn.layer.borderColor = UIColor.lightGray.cgColor
    Share_Btn.layer.borderWidth = 1.0
    Share_Btn.setImage(UIImage(named: "Share"), for: .normal)
    Share_Btn.addTarget(self, action: #selector(self.ShareButtonAction(sender:)), for: .touchUpInside)
    selfScreenContents.addSubview(Share_Btn)
    
    let Share_LBL = UILabel()
    Share_LBL.frame = CGRect(x: Call_LBL.frame.maxX + (3 * x), y: Direction_Btn.frame.maxY + y, width: (6 * x), height: y)
    //Share_LBL.backgroundColor = UIColor.lightGray
    Share_LBL.text = "SHARE"
    Share_LBL.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
    Share_LBL.font = UIFont(name: "Avenir Next", size: y)
    Share_LBL.textAlignment = .center
    selfScreenContents.addSubview(Share_LBL)
    
    
    // Order Type..
    let Photos_Label = UILabel()
    Photos_Label.frame = CGRect(x: 0, y: Call_LBL.frame.maxY + (2 * y), width: selfScreenContents.frame.width, height: (3 * y))
    Photos_Label.backgroundColor = UIColor.white
    Photos_Label.text = "SHOP PHOTOS"
    Photos_Label.layer.borderColor = UIColor.lightGray.cgColor
    Photos_Label.layer.borderWidth = 1.0
    Photos_Label.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
    Photos_Label.textAlignment = .center
    Photos_Label.font = UIFont(name: "Avenir Next", size: 1.3 * x)
    selfScreenContents.addSubview(Photos_Label)
    
    let PhotosScrollview = UIScrollView()
    PhotosScrollview.frame = CGRect(x: 0, y: Photos_Label.frame.maxY + y, width: selfScreenContents.frame.width, height: (12 * x))
    PhotosScrollview.backgroundColor = UIColor.white
    PhotosScrollview.layer.borderColor = UIColor.lightGray.cgColor
    selfScreenContents.addSubview(PhotosScrollview)
    
    for i in 0..<ShopNameArray.count
    {
        if(ShopNameArray.count > 0)
        {
            shopName.text = ShopNameArray[i] as? String
            shopName.attributedText = NSAttributedString(string: shopName.text!, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        }
       else
       {
          shopName.text = ""
       }
        
        if(RatingArray.count > 0)
        {
           ratingImageView.image = UIImage(named: "\(RatingArray[i])")
           reviewsButton.setTitle("(\(ReviewArray[i]) reviews)", for: .normal)
          // ratingCountLabel.text = "(\(ratingArray[i]) reviews)"
        }
        else
        {
            ratingImageView.image = UIImage(named: "0")
            reviewsButton.setTitle("(0 reviews)", for: .normal)
        }
        
        if(TailorNameArray.count > 0)
        {
            tailorName.text = TailorNameArray[i] as? String
        }
        else
        {
            tailorName.text = ""
        }
        
        if(OrderCountArray.count > 0)
        {
            ordersCountLabel.text = "\(OrderCountArray[i])"
        }
        else
        {
            ordersCountLabel.text = "0"
        }
        
        if(PhoneNumberArray.count > 0)
        {
            Call_LBL.text = PhoneNumberArray[i] as? String
        }
        else
        {
            Call_LBL.text = ""
        }
        
        
        if(WebsiteArray.count > 0)
        {
             Link_Label.text = WebsiteArray[i] as? String
        }
        else
        {
            Link_Label.text = "http://"
        }
        
        if(AddressArray.count > 0)
        {
            Address_Label.text = AddressArray[i] as? String
        }
        else
        {
            Address_Label.text = ""
        }
    
    }
    
    var x3:CGFloat = x
    
    for i in 0..<ShopImageArray.count
    {
        let PhotosIV = UIImageView()
        PhotosIV.frame = CGRect(x: x3, y: 0, width: (12 * x), height: (12 * y))
        PhotosIV.backgroundColor = UIColor.groupTableViewBackground
       // PhotosScrollview.addSubview(PhotosIV)
     
        if let imageName = ShopImageArray[i] as? String
        {
            let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/ShopImages/\(imageName)"
            let apiurl = URL(string: api)
            if apiurl != nil
            {
                PhotosIV.dowloadFromServer(url: apiurl!)
            }
        }
        
        PhotosScrollview.addSubview(PhotosIV)
        x3 = PhotosIV.frame.maxX + x
    }
    
     PhotosScrollview.contentSize.width = x3 + x
    
    if let language = UserDefaults.standard.value(forKey: "language") as? String
    {
        if language == "en"
        {
            nameLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            nameLabel.text = "Name : "
            nameLabel.textAlignment = .left
            
            ordersLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            ordersLabel.text = "No. of Orders : "
            ordersLabel.textAlignment = .left
            
            Address_Label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            Address_Label.textAlignment = .left
            
            Time_Label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            Time_Label.textAlignment = .left
            
            Link_Label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            Link_Label.textAlignment = .left
            
            Direction_Btn.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            Directions_LBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            Directions_LBL.text = "DIRECTIONS"
            Call_Btn.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            Call_LBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            Share_Btn.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            Share_LBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            Share_LBL.text = "SHARE"
            Photos_Label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            Photos_Label.text = "SHOP PHOTOS"
            
            changeViewToEnglishInSelf()
        }
        else if language == "ar"
        {
            nameLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            nameLabel.text = "الاسم : "
            nameLabel.textAlignment = .right
            
            ordersLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            ordersLabel.text = "No. of Orders : "
            ordersLabel.textAlignment = .right
            
            Address_Label.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            Address_Label.textAlignment = .right
            
            Time_Label.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            Time_Label.textAlignment = .right
            
            Link_Label.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            Link_Label.textAlignment = .right
            
            Direction_Btn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            Directions_LBL.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            Directions_LBL.text = "اتجاه"
            Call_Btn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            Call_LBL.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            Share_Btn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            Share_LBL.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            Share_LBL.text = "شارك"
            Photos_Label.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            Photos_Label.text = "صور التسوق"
            
            changeViewToArabicInSelf()
        }
    }
    else
    {
        nameLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        nameLabel.text = "Name : "
        nameLabel.textAlignment = .left
        
        ordersLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        ordersLabel.text = "No. of Orders : "
        ordersLabel.textAlignment = .left
        
        Address_Label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        Address_Label.textAlignment = .left
        
        Time_Label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        Time_Label.textAlignment = .left
        
        Link_Label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        Link_Label.textAlignment = .left
        
        Direction_Btn.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        Directions_LBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        Directions_LBL.text = "DIRECTIONS"
        Call_Btn.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        Call_LBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        Share_Btn.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        Share_LBL.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        Share_LBL.text = "SHARE"
        Photos_Label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        Photos_Label.text = "SHOP PHOTOS"
        
        changeViewToEnglishInSelf()
    }
  }

  @objc func otpBackButtonAction(sender : UIButton)
  {
     self.navigationController?.popViewController(animated: true)
  }
  
  @objc func ReviewsButtonAction(sender : UIButton)
  {
     let ReviewsScreen = ReviewsViewController()
     ReviewsScreen.TailorID = TailorID!
     self.navigationController?.pushViewController(ReviewsScreen, animated: true)
  }
  @objc func TimingsButtonAction(sender : UIButton)
  {
      print("Timings Button..Click..!")
    
    blurView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    blurView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    view.addSubview(blurView)
    
    alertView.frame = CGRect(x: (3 * x), y: (17 * y), width: view.frame.width - (6 * x), height: view.frame.height - (34 * y))
    alertView.layer.cornerRadius = 15
    alertView.layer.masksToBounds = true
    alertView.backgroundColor = UIColor.white
    blurView.addSubview(alertView)
    
    titleLabel.frame = CGRect(x: 0, y: 0, width: alertView.frame.width, height: (3 * y))
    titleLabel.text = "SHOP TIMINGS"
    titleLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
    titleLabel.textAlignment = .center
    titleLabel.textColor = UIColor.white
    titleLabel.font = UIFont(name: "Avenir Next", size: (1.6 * x))
    alertView.addSubview(titleLabel)
    
    let underLine1 = UILabel()
    underLine1.frame = CGRect(x: 0, y: titleLabel.frame.maxY, width: alertView.frame.width, height: 1)
    underLine1.backgroundColor = UIColor.blue
    alertView.addSubview(underLine1)
    
    TimingsTableView.frame = CGRect(x: 0, y: underLine1.frame.maxY, width: alertView.frame.width, height: alertView.frame.height - (8.1 * y))
    TimingsTableView.register(ShopDetailsTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(ShopDetailsTableViewCell.self))
    TimingsTableView.dataSource = self
    TimingsTableView.delegate = self
    alertView.addSubview(TimingsTableView)
    
    TimingsTableView.reloadData()
    
    cancelButton.frame = CGRect(x: 0, y: TimingsTableView.frame.maxY + (2 * y), width: alertView.frame.width, height: (3 * y))
    cancelButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
    cancelButton.setTitle("CANCEL", for: .normal)
    cancelButton.setTitleColor(UIColor.white, for: .normal)
    cancelButton.addTarget(self, action: #selector(self.CancelAction(sender:)), for: .touchUpInside)
    alertView.addSubview(cancelButton)
  }
    @objc func CancelAction(sender : UIButton)
    {
        blurView.removeFromSuperview()
    }
    
  @objc func DirectionButtonAction(sender : UIButton)
  {
      print("Directions Button..Click..!")
  }
    
   @objc func CallButtonAction(sender : UIButton)
  {
     if(PhoneNumberArray.count > 0)
     {
      let NumStr = PhoneNumberArray[0] as? String
      let url: NSURL = URL(string: "TEL://\(NumStr!)")! as NSURL
      UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
     }
  }
    
  @objc func ShareButtonAction(sender : UIButton)
  {
      print("Share Button..Click..!")
    
     let textToShare = ""
    
      if let myWebsite = NSURL(string: "")
      {
        let objectsToShare = [textToShare, myWebsite] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = sender
        self.present(activityVC, animated: true, completion: nil)
      }
  }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return DaysArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ShopDetailsTableViewCell.self), for: indexPath as IndexPath) as! ShopDetailsTableViewCell
        
        cell.DaysName.frame = CGRect(x: (3 * x), y: y, width: (10 * x), height: (2 * y))
        cell.DaysName.text = DaysArray[indexPath.row] as? String
        
        cell.ShopTime.frame = CGRect(x: cell.DaysName.frame.maxX + (2 * x), y: y, width: cell.frame.width - (15 * x), height: (2 * y))
        
        cell.ShopTime.text = TimeArray[indexPath.row] as? String
    
        
        return cell
    }
}
