//
//  ReviewsViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 25/01/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class ReviewsViewController:CommonViewController,ServerAPIDelegate
{
    
   let serviceCall = ServerAPI()
    var TailorID:Int!
    
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if(TailorID != nil)
        {
          self.serviceCall.API_GetRatings(TailorId:TailorID, delegate: self)
        }
        else
        {
          self.serviceCall.API_GetRatings(TailorId: 1, delegate: self)
        }
        // reviewsContent()
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("Reviews : ", errorMessage)
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
    RatingsView.frame = CGRect(x: x , y: ratingsNavigationBar.frame.maxY + y, width: view.frame.width - (2 * x), height: (10 * y))
    //RatingsView.layer.cornerRadius = 5
    RatingsView.layer.borderWidth = 1
    RatingsView.layer.backgroundColor = UIColor.white.cgColor
    RatingsView.layer.borderColor = UIColor.lightGray.cgColor
    view.addSubview(RatingsView)
    
    let StarImageView = UIImageView()
    StarImageView.frame = CGRect(x: x/2, y: y/2, width: (8 * x), height:(6 * y))
    //StarImageView.backgroundColor = UIColor.lightGray
    StarImageView.image = UIImage(named: "star")
    RatingsView.addSubview(StarImageView)
   
    let RatingNumLabel = UILabel()
    RatingNumLabel.frame = CGRect(x: (3 * x), y: (2 * y), width: (3 * x), height: (2 * y))
    let rateNum : Int = FullStatusArr[0] as! Int
    RatingNumLabel.text = "\(rateNum)/5"
    RatingNumLabel.textColor = UIColor.black
   // RatingNumLabel.backgroundColor = UIColor.gray
    RatingNumLabel.textAlignment = .left
    RatingNumLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
    StarImageView.addSubview(RatingNumLabel)
    
    let RatingStatusLabel = UILabel()
    RatingStatusLabel.frame = CGRect(x: x/2, y: StarImageView.frame.maxY, width: (8 * x), height: (2 * y))
    RatingStatusLabel.text = PerformenceStatusArr[0] as? String
    RatingStatusLabel.textColor = UIColor.black
    //RatingStatusLabel.backgroundColor = UIColor.gray
    RatingStatusLabel.textAlignment = .center
    RatingStatusLabel.font = UIFont(name: "Avenir Next", size: 1.4 * x)
    RatingsView.addSubview(RatingStatusLabel)
    
    let ReviewStatusLabel = UILabel()
    ReviewStatusLabel.frame = CGRect(x: x/2, y: RatingStatusLabel.frame.maxY, width: (10 * x), height: y)
    let StatusNum : Int = Based_On_ReviewsArr[0] as! Int
    ReviewStatusLabel.text = "(Based on \(StatusNum) Review)"
    ReviewStatusLabel.textColor = UIColor.black
    //RatingStatusLabel.backgroundColor = UIColor.gray
    ReviewStatusLabel.textAlignment = .left
    ReviewStatusLabel.font = UIFont(name: "Avenir Next", size: 1.0 * x)
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
 
    var y1:CGFloat = 0
    
    for i in 0..<ValueArray.count
    {
        //RatingsTypeView..
        let RatingTypeView = UIView()
        RatingTypeView.frame = CGRect(x: StarImageView.frame.maxX + x, y: y1, width: (24 * x), height: (2.5 * y))
       // RatingTypeView.backgroundColor = UIColor.gray
        RatingsView.addSubview(RatingTypeView)
        
        //RatingsTypeLabel
        let RatingsTypeLabel = UILabel()
        RatingsTypeLabel.frame = CGRect(x: 0, y: 0, width: (12 * x), height: (2.5 * y))
        RatingsTypeLabel.textColor = UIColor.black
      //  RatingsTypeLabel.backgroundColor = UIColor.lightGray
        RatingsTypeLabel.text = ValueArray[i] as? String
        RatingsTypeLabel.textAlignment = .center
        RatingsTypeLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        RatingsTypeLabel.adjustsFontSizeToFitWidth = true
        RatingTypeView.addSubview(RatingsTypeLabel)
        
        // Ratings Buttons
        let CustomerRatingImageView = UIImageView()
        CustomerRatingImageView.frame = CGRect(x: RatingsTypeLabel.frame.maxX, y: 0, width: (12 * x), height:(2 * y))
         CustomerRatingImageView.image = UIImage(named: "5")
        RatingTypeView.addSubview(CustomerRatingImageView)
        
        y1 = RatingTypeView.frame.maxY + y
    }
 
    
    let WriteReviewButton = UIButton()
    WriteReviewButton.frame = CGRect(x: (3 * x), y: RatingsView.frame.maxY + (3 * y) , width: view.frame.width - (6 * x), height: (3 * y))
    WriteReviewButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
    WriteReviewButton.setTitle("RATE AND WRITE A REVIEW", for: .normal)
    WriteReviewButton.setTitleColor(UIColor.white, for: .normal)
    WriteReviewButton.titleLabel?.font = UIFont(name: "Avenir-Regular", size: 1.3 * x)
    //SubmitButton.layer.borderWidth = 1.0
   // SubmitButton.layer.cornerRadius = 15
    WriteReviewButton.addTarget(self, action: #selector(self.WriteReviewButtonAction(sender:)), for: .touchUpInside)
    
    view.addSubview(WriteReviewButton)
    
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
