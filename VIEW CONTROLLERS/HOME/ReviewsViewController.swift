//
//  ReviewsViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 25/01/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit
import Cosmos

class ReviewsViewController:CommonViewController,ServerAPIDelegate
{
    
   let serviceCall = ServerAPI()
    var TailorID:Int!
   let ReviewsScrollView = UIScrollView()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
   // CustomerRating Array..
    var CustomerCreateDtArray = NSArray()
    var CustomerRatingArray = NSArray()
    var CustomerReviewArray = NSArray()
    var CustomerNameArray = NSArray()
    
    //PerformenceStatus Array..
    var PerformenceStatusArr = NSArray()
    
    //RatingStatus Array..
    var Based_On_ReviewsArr = NSArray()
    var FullStatusArr = NSArray()
    
    // Ratings Array..
    var CategoryCountArray = NSArray()
    var CategoryIdArray = NSArray()
    var RatingArray = NSArray()
    var ValueArray = NSArray()
    
    let emptyLabel = UILabel()
    
    var applicationDelegate = AppDelegate()
    
    let Review_LBL = UILabel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        print("Tailor Id:",TailorID)
        
        if(TailorID != nil)
        {
            self.serviceCall.API_GetRatings(TailorId:TailorID, delegate: self)
        }
       
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("Reviews : ", errorMessage)
        stopActivity()
        applicationDelegate.exitContents()
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
    
    func API_CALLBACK_GetRatings(getRatings: NSDictionary)
    {
        let ResponseMsg = getRatings.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = getRatings.object(forKey: "Result") as! NSDictionary
            
            //
            let CustomerRating = Result.value(forKey: "CustomerRating") as! NSArray
            
            CustomerCreateDtArray = CustomerRating.value(forKey: "CreateDt") as! NSArray
            print("CustomerCreateDtArray :", CustomerCreateDtArray)
            
            CustomerNameArray = CustomerRating.value(forKey: "Name") as! NSArray
            print("CustomerNameArray :",CustomerNameArray)
            
            CustomerRatingArray = CustomerRating.value(forKey: "Rating") as! NSArray
            print("CustomerRatingArray :", CustomerRatingArray)
            
            CustomerReviewArray = CustomerRating.value(forKey: "Review") as! NSArray
            print("CustomerReviewArray :", CustomerReviewArray)
            
            //
            let PerformenceStatus = Result.value(forKey: "PerformenceStatus") as! NSArray
            
            PerformenceStatusArr = PerformenceStatus.value(forKey: "Status") as! NSArray
            print("PerformenceStatusArr :", PerformenceStatusArr)
            
            //
            let RatingStatus = Result.value(forKey: "RatingStatus") as! NSArray
            
            Based_On_ReviewsArr = RatingStatus.value(forKey: "Based_On_Reviews") as! NSArray
            print("Based_On_ReviewsArr :", Based_On_ReviewsArr)
            
            FullStatusArr = RatingStatus.value(forKey: "FullStatus") as! NSArray
            print("FullStatusArr :", FullStatusArr)
            
            //
            let Ratings = Result.value(forKey: "Ratings") as! NSArray
            
            CategoryCountArray = Ratings.value(forKey: "CategoryCount") as! NSArray
            print("CategoryCountArray :", CategoryCountArray)
            
            CategoryIdArray = Ratings.value(forKey: "CategoryId") as! NSArray
            print("CategoryIdArray :", CategoryIdArray)
            
            RatingArray = Ratings.value(forKey: "Rating") as! NSArray
            print("RatingArray :", RatingArray)
            
            ValueArray = Ratings.value(forKey: "Value") as! NSArray
            print("ValueArray :", ValueArray)
            
            reviewsContent()
        }
        else if ResponseMsg == "Failure"
        {
            let Result = getRatings.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetRating"
            ErrorStr = Result
            DeviceError()
        }
        
        
    }
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        // ErrorStr = "Default Error"
        PageNumStr = "ReviewsViewController"
       // MethodName = "GetRating"
        
        print("UUID", UIDevice.current.identifierForVendor?.uuidString as Any)
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
    }
  func reviewsContent()
  {
    self.stopActivity()
    
    let ratingsNavigationBar = UIView()
    ratingsNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
    ratingsNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
    view.addSubview(ratingsNavigationBar)
    
    let backButton = UIButton()
    backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
    backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
    backButton.tag = 4
    backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
    ratingsNavigationBar.addSubview(backButton)
    
    let navigationTitle = UILabel()
    navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: ratingsNavigationBar.frame.width, height: (3 * y))
    navigationTitle.text = "REVIEWS AND RATINGS"
    navigationTitle.textColor = UIColor.white
    navigationTitle.textAlignment = .center
    navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
    ratingsNavigationBar.addSubview(navigationTitle)
    
    let RatingsView = UIView()
    RatingsView.frame = CGRect(x: x , y: ratingsNavigationBar.frame.maxY + y, width: view.frame.width - (2 * x), height: (15 * y))
    //RatingsView.layer.cornerRadius = 5
    RatingsView.layer.borderWidth = 1
    RatingsView.layer.backgroundColor = UIColor.white.cgColor
    RatingsView.layer.borderColor = UIColor.lightGray.cgColor
    view.addSubview(RatingsView)
    
    let StarImageView = UIImageView()
    StarImageView.frame = CGRect(x: x/2, y: y/2, width: (7 * x), height:(6 * y))
    //StarImageView.backgroundColor = UIColor.lightGray
    StarImageView.image = UIImage(named: "star")
    if(FullStatusArr.count > 0)
    {
      RatingsView.addSubview(StarImageView)
    }
    else
    {
        
    }
   
    let RatingNumLabel = UILabel()
    RatingNumLabel.frame = CGRect(x: (2 * x), y: (2 * y), width: (3 * x), height: (2 * y))
    if(FullStatusArr.count > 0)
    {
      let rateNum : Int = Int(FullStatusArr[0] as! Double)
      RatingNumLabel.text = "\(rateNum)/5"
    }
    else
    {
        RatingNumLabel.text = ""
    }
    RatingNumLabel.textColor = UIColor.white
    //RatingNumLabel.backgroundColor = UIColor.gray
    RatingNumLabel.textAlignment = .center
    RatingNumLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
    StarImageView.addSubview(RatingNumLabel)
    
    
    let RatingStatusLabel = UILabel()
    RatingStatusLabel.frame = CGRect(x: x/2, y: StarImageView.frame.maxY, width: (8 * x), height: (2 * y))
    if(PerformenceStatusArr.count > 0)
    {
      RatingStatusLabel.text = PerformenceStatusArr[0] as? String
    }
    else
    {
        RatingStatusLabel.text = "GOOD"
    }
    RatingStatusLabel.textColor = UIColor.black
    //RatingStatusLabel.backgroundColor = UIColor.gray
    RatingStatusLabel.textAlignment = .left
    RatingStatusLabel.font = UIFont(name: "Avenir Next", size: 1.4 * x)
    RatingsView.addSubview(RatingStatusLabel)
    
    
    let ReviewStatusLabel = UILabel()
    ReviewStatusLabel.frame = CGRect(x: x/2, y: RatingStatusLabel.frame.maxY, width: (8 * x), height: (5 * y))
    if(Based_On_ReviewsArr.count > 0)
    {
       let StatusNum : Int = Based_On_ReviewsArr[0] as! Int
       ReviewStatusLabel.text = "(Based on \(StatusNum) Reviews)"
    }
    else
    {
       ReviewStatusLabel.text = ""
    }
    ReviewStatusLabel.textColor = UIColor.black
   // ReviewStatusLabel.backgroundColor = UIColor.gray
    ReviewStatusLabel.textAlignment = .center
    ReviewStatusLabel.lineBreakMode = .byWordWrapping
    ReviewStatusLabel.numberOfLines = 2
    ReviewStatusLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
    RatingsView.addSubview(ReviewStatusLabel)
    
    
 /*
    let serviceLabel = UILabel()
    serviceLabel.frame = CGRect(x: StarImageView.frame.maxX + x, y: y, width: (12 * x), height: (2 * y))
    serviceLabel.text = "On Time Service"
    serviceLabel.textColor = UIColor.black
    //serviceLabel.backgroundColor = UIColor.gray
    serviceLabel.textAlignment = .left
    serviceLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
    RatingsView.addSubview(serviceLabel)
    
    let ServiceRatingImageView = UIImageView()
    ServiceRatingImageView.frame = CGRect(x: serviceLabel.frame.maxX, y: y, width: (12 * x), height:(1.5 * y))
   // ServiceRatingImageView.backgroundColor = UIColor.lightGray
    ServiceRatingImageView.image = UIImage(named: "5")
    RatingsView.addSubview(ServiceRatingImageView)
    
    let StitchLabel = UILabel()
    StitchLabel.frame = CGRect(x: StarImageView.frame.maxX + x, y: serviceLabel.frame.maxY + y, width: (12 * x), height: (2 * y))
    StitchLabel.text = "Stiching Quality"
    StitchLabel.textColor = UIColor.black
    StitchLabel.textAlignment = .left
    StitchLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
    RatingsView.addSubview(StitchLabel)
    
    let StitchRatingImageView = UIImageView()
    StitchRatingImageView.frame = CGRect(x: StitchLabel.frame.maxX, y: serviceLabel.frame.maxY + y, width: (12 * x), height:(1.5 * y))
    StitchRatingImageView.image = UIImage(named: "5")
    RatingsView.addSubview(StitchRatingImageView)
    
    let CustomerLabel = UILabel()
    CustomerLabel.frame = CGRect(x: StarImageView.frame.maxX + x, y: StitchLabel.frame.maxY + y, width: (12 * x), height: (2 * y))
    CustomerLabel.text = "Customer Service"
    CustomerLabel.textColor = UIColor.black
    CustomerLabel.textAlignment = .left
    CustomerLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
    RatingsView.addSubview(CustomerLabel)
    
    let CustomerRatingImageView = UIImageView()
    CustomerRatingImageView.frame = CGRect(x: CustomerLabel.frame.maxX, y: StitchLabel.frame.maxY + y, width: (12 * x), height:(1.5 * y))
    CustomerRatingImageView.image = UIImage(named: "5")
    RatingsView.addSubview(CustomerRatingImageView)
  */
 
    var y1:CGFloat = y
    
    for i in 0..<ValueArray.count
    {
        //RatingsTypeView..
        let RatingTypeView = UIView()
        RatingTypeView.frame = CGRect(x: StarImageView.frame.maxX + x, y: y1, width: (24 * x), height: (2.5 * y))
       // RatingTypeView.backgroundColor = UIColor.gray
        RatingsView.addSubview(RatingTypeView)
        
        //RatingsTypeLabel
        let RatingsTypeLabel = UILabel()
        RatingsTypeLabel.frame = CGRect(x: 0, y: 0, width: (10 * x), height: (2.5 * y))
        RatingsTypeLabel.textColor = UIColor.black
        //RatingsTypeLabel.backgroundColor = UIColor.lightGray
        RatingsTypeLabel.text = ValueArray[i] as? String
        RatingsTypeLabel.textAlignment = .center
        RatingsTypeLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
        RatingsTypeLabel.adjustsFontSizeToFitWidth = true
        RatingTypeView.addSubview(RatingsTypeLabel)
        
        let RatingCountLBL = UILabel()
        RatingCountLBL.frame = CGRect(x:RatingsTypeLabel.frame.maxX, y: 0, width: (2 * x), height: (2.5 * y))
        RatingCountLBL.textColor = UIColor.black
        //RatingCountLBL.backgroundColor = UIColor.lightGray
        let CountNum : Int = CategoryCountArray[i] as! Int
        RatingCountLBL.text = "(\(CountNum))"
        RatingCountLBL.textAlignment = .center
        RatingCountLBL.font = UIFont(name: "Avenir Next", size: 1.2 * x)
        RatingCountLBL.adjustsFontSizeToFitWidth = true
        RatingTypeView.addSubview(RatingCountLBL)
        
       
      /*
        // Ratings....
        let OnTimeServiceRating = CosmosView()
        OnTimeServiceRating.frame = CGRect(x: ColonLabel1.frame.maxX, y: y/2, width: (12 * x), height:(2.5 * y))
        //OnTimeServiceRating.settings.updateOnTouch = false
        OnTimeServiceRating.settings.fillMode = .half
        OnTimeServiceRating.settings.starSize = 20
        // OnTimeServiceRating.settings.starMargin = 5
        OnTimeServiceRating.settings.filledColor = UIColor.orange
        OnTimeServiceRating.settings.emptyBorderColor = UIColor.orange
        OnTimeServiceRating.settings.filledBorderColor = UIColor.orange
        OnTimeServiceRating.settings.filledImage = UIImage(named: "GoldStarFull")?.withRenderingMode(.alwaysOriginal)
        OnTimeServiceRating.settings.emptyImage = UIImage(named: "GoldStarEmpty")?.withRenderingMode(.alwaysOriginal)
        OnTimeServiceView.addSubview(OnTimeServiceRating)
        
        
        OnTimeServiceRating.didTouchCosmos = { rating in
            print("OnTimeServiceRating :", "\(rating)")
            
            self.OnTimeServiceRatingNum = Int(rating)
            
        }
        */
        
        
        // Ratings Buttons
        let ratingNum : Int = Int(RatingArray[i] as! Double)
        let CustomerRatingImageView = UIImageView()
        CustomerRatingImageView.frame = CGRect(x: RatingCountLBL.frame.maxX, y: 0, width: (12 * x), height:(2 * y))
       // CustomerRatingImageView.backgroundColor = UIColor.lightGray
        
        if(ratingNum == 1)
        {
         CustomerRatingImageView.image = UIImage(named: "1")
        }
        else if(ratingNum == 2)
        {
            CustomerRatingImageView.image = UIImage(named: "2")
        }
        else if(ratingNum == 3)
        {
            CustomerRatingImageView.image = UIImage(named: "3")
        }
        else if(ratingNum == 4)
        {
            CustomerRatingImageView.image = UIImage(named: "4")
        }
        else if(ratingNum == 5)
        {
            CustomerRatingImageView.image = UIImage(named: "5")
        }
        RatingTypeView.addSubview(CustomerRatingImageView)
        
        
        
        let RatingValLBL = UILabel()
        RatingValLBL.frame = CGRect(x:CustomerRatingImageView.frame.maxX, y: 0, width: (2 * x), height: (2 * y))
        RatingValLBL.textColor = UIColor.black
        //RatingValLBL.backgroundColor = UIColor.lightGray
        let ratVal : Int = Int(RatingArray[i] as! Double)
        RatingValLBL.text = "\(ratVal)"
        RatingValLBL.textAlignment = .center
        RatingValLBL.font = UIFont(name: "Avenir Next", size: 1.2 * x)
        RatingValLBL.adjustsFontSizeToFitWidth = true
        RatingTypeView.addSubview(RatingValLBL)
        
        y1 = RatingTypeView.frame.maxY + (2 * y)
    }
 
    
    // Rate And Write A Review.. Button Action..
    let WriteReviewButton = UIButton()
    WriteReviewButton.frame = CGRect(x: (3 * x), y: RatingsView.frame.maxY + (2 * y) , width: view.frame.width - (6 * x), height: (3 * y))
    WriteReviewButton.backgroundColor =  UIColor.orange  //UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
    WriteReviewButton.setTitle("REVIEWS", for: .normal)
    WriteReviewButton.setTitleColor(UIColor.white, for: .normal)
    WriteReviewButton.titleLabel?.font = UIFont(name: "Avenir-Regular", size: 1.2 * x)
    //SubmitButton.layer.borderWidth = 1.0
   // SubmitButton.layer.cornerRadius = 15
    WriteReviewButton.isUserInteractionEnabled = false
     //WriteReviewButton.addTarget(self, action: #selector(self.WriteReviewButtonAction(sender:)), for: .touchUpInside)
     view.addSubview(WriteReviewButton)
    
    
    //Reviews ScrollView...
    ReviewsScrollView.frame = CGRect(x: (3 * x), y: WriteReviewButton.frame.maxY + (2 * y), width: view.frame.width - (6 * x), height: (30 * y))
    ReviewsScrollView.backgroundColor = UIColor.white
    view.addSubview(ReviewsScrollView)
    
    
    for views in ReviewsScrollView.subviews
    {
        views.removeFromSuperview()
    }
    
    var y2:CGFloat = 0
    
    if(CustomerNameArray.count == 0)
    {
        emptyLabel.frame = CGRect(x: 0, y: ((ReviewsScrollView.frame.height - (3 * y)) / 2), width: ReviewsScrollView.frame.width, height: (3 * y))
        emptyLabel.text = "No Reviews For this Shop"
        emptyLabel.textColor = UIColor.black
        emptyLabel.textAlignment = .center
        emptyLabel.font = UIFont(name: "Avenir Next", size: (1.5 * x))
        emptyLabel.font = emptyLabel.font.withSize(1.5 * x)
        ReviewsScrollView.addSubview(emptyLabel)
    }
    else
    {
    for i in 0..<CustomerNameArray.count
    {
        //
        let ReviewsView = UIView()
        ReviewsView.frame = CGRect(x: 0, y: y2, width: ReviewsScrollView.frame.width, height: (10 * y))
        ReviewsView.backgroundColor = UIColor.white
        ReviewsScrollView.addSubview(ReviewsView)
        
        //
        let userImageView = UIImageView()
        userImageView.frame = CGRect(x: x/2, y: y/2, width: (6 * x), height: (5 * y))
        userImageView.backgroundColor = UIColor.lightGray  //UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        userImageView.layer.borderWidth = 1
        userImageView.layer.masksToBounds = false
        userImageView.layer.borderColor = UIColor.black.cgColor
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        userImageView.clipsToBounds = true
       // userImageView.image = UIImage(named: "TailorName")
        userImageView.layer.borderColor = UIColor.lightGray.cgColor
        
      /*
        if let imageName = ImageArray[i] as? String
        {
         // let urlString = serviceCall.baseURL
            let api = "\(urlString)/images/DressSubType/\(imageName)"
            let api = "http://192.168.0.21/TailorAPI/Images/BuyerImages/buyer.jpg"
            print("SMALL ICON", api)
            let apiurl = URL(string: api)
            
            let dummyImageView = UIImageView()
            dummyImageView.frame = CGRect(x: 0, y: 0, width: userImageView.frame.width, height: userImageView.frame.height)
            dummyImageView.dowloadFromServer(url: apiurl!)
            dummyImageView.tag = -1
            userImageView.addSubview(dummyImageView)
        }
      */
        
        ReviewsView.addSubview(userImageView)
        
      
        let UserNameLabel = UILabel()
        UserNameLabel.frame = CGRect(x: userImageView.frame.maxX + x, y: y/2, width: ReviewsView.frame.width / 2, height: (2 * y))
        UserNameLabel.text = CustomerNameArray[i] as? String
        //UserNameLabel.backgroundColor = UIColor.lightGray
        UserNameLabel.textColor = UIColor.blue
        UserNameLabel.textAlignment = .left
        UserNameLabel.font =  UIFont(name: "Avenir Next", size: 1.3 * x)  //nameLabel.font.withSize(1.2 * x)
        ReviewsView.addSubview(UserNameLabel)
        
        
        // Ratings Buttons
        let CusRatingNum : Int = Int(CustomerRatingArray[i] as! Double)
        let CustomerRatingImageView = UIImageView()
        CustomerRatingImageView.frame = CGRect(x: userImageView.frame.maxX + x, y: UserNameLabel.frame.maxY, width: (8 * x), height: (1.5 * y))
        //CustomerRatingImageView.backgroundColor = UIColor.lightGray
        
        if(CusRatingNum == 1)
        {
            CustomerRatingImageView.image = UIImage(named: "1")
        }
        else if(CusRatingNum == 2)
        {
            CustomerRatingImageView.image = UIImage(named: "2")
        }
        else if(CusRatingNum == 3)
        {
            CustomerRatingImageView.image = UIImage(named: "3")
        }
        else if(CusRatingNum == 4)
        {
            CustomerRatingImageView.image = UIImage(named: "4")
        }
        else if(CusRatingNum == 5)
        {
            CustomerRatingImageView.image = UIImage(named: "5")
        }
        ReviewsView.addSubview(CustomerRatingImageView)
        
        
        //
        let RatingDate_LBL = UILabel()
        RatingDate_LBL.frame = CGRect(x: CustomerRatingImageView.frame.maxX + x, y: UserNameLabel.frame.maxY, width: (12 * x), height: (1.5 * y))
        RatingDate_LBL.text = CustomerCreateDtArray[i] as? String
        //RatingDate_LBL.backgroundColor = UIColor.lightGray
        RatingDate_LBL.textColor = UIColor.blue
        RatingDate_LBL.textAlignment = .left
        RatingDate_LBL.font = UIFont(name: "Avenir Next", size: 1.2 * x)
        ReviewsView.addSubview(RatingDate_LBL)
        
       // let Review_LBL = UILabel()
        Review_LBL.frame = CGRect(x: userImageView.frame.maxX + x, y: RatingDate_LBL.frame.maxY, width: ReviewsView.frame.width - (8 * x), height: (7 * y))
        Review_LBL.text = CustomerReviewArray[i] as? String
       // Review_LBL.backgroundColor = UIColor.lightGray
        Review_LBL.textColor = UIColor.black
        Review_LBL.textAlignment = .left
        Review_LBL.lineBreakMode = .byWordWrapping
        Review_LBL.numberOfLines = 4
        Review_LBL.font = UIFont(name: "Avenir Next", size: 1.2 * x)
        Review_LBL.adjustsFontSizeToFitWidth = true
        ReviewsView.addSubview(Review_LBL)
      
        let ReviewUnderline_LBL = UILabel()
        ReviewUnderline_LBL.frame = CGRect(x: 0, y: Review_LBL.frame.maxY + y, width: ReviewsView.frame.width, height: 0.5)
        ReviewUnderline_LBL.backgroundColor = UIColor.lightGray
      //  ReviewsView.addSubview(ReviewUnderline_LBL)
        
        /*
        btnDetail.titleLabel?.numberOfLines = 5
        btnDetail.titleLabel?.lineBreakMode = .byCharWrapping
        btnDetail.contentVerticalAlignment = .top
        btnDetail.contentHorizontalAlignment = .left
        btnDetail.isUserInteractionEnabled = false
        btnDetail.autoresizesSubviews = true
        btnDetail.autoresizingMask = .flexibleWidth
       */
        
      //  AppointmentViewButton.addTarget(self, action: #selector(self.confirmSelectionButtonAction(sender:)), for: .touchUpInside)
        
        y2 = ReviewsView.frame.maxY + y/2
        
     }
         ReviewsScrollView.contentSize.height = Review_LBL.frame.maxY + y
   }
 }
    
   
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func WriteReviewButtonAction(sender : UIButton)
    {
        let RatingScreen = WriteReviewRateViewController()
        self.navigationController?.pushViewController(RatingScreen, animated: true)
    }
}
