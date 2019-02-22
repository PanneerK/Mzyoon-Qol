//
//  WriteReviewRateViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 25/01/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit
import Cosmos

class WriteReviewRateViewController: CommonViewController,ServerAPIDelegate,UITextFieldDelegate
{
    let serviceCall = ServerAPI()
    
    let ReviewNavigationBar = UIView()
    var RatingTypeArray = NSArray()
    let Review_TF = UITextField()
    
    var reviewStr:String!
    var RatingNum:Int!
    var OrderID:Int!
    var CategoryID:Int!
    var TailorID:Int!
    
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    var applicationDelegate = AppDelegate()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        RatingTypeArray = ["ON TIME SERVICE","STICHING QUALITY","CUSTOMER SERVICE"]
        
        writeReviewContent()
        
        
        
    }
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("Write Reviews Error:",errorMessage)
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
    func API_CALLBACK_InsertRating(insertRating: NSDictionary)
    {
        let ResponseMsg = insertRating.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = insertRating.object(forKey: "Result") as! NSDictionary
            
            print("RAting Result :",Result)
            
          //  let HomeScreen = HomeViewController()
          //  self.navigationController?.pushViewController(HomeScreen, animated: true)
        }
        else if ResponseMsg == "Failure"
        {
            let Result = insertRating.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "InsertRating"
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
        PageNumStr = "WriteReviewsViewController"
        // MethodName = "GetRating"
        
        print("UUID", UIDevice.current.identifierForVendor?.uuidString as Any)
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
    }
    
   func writeReviewContent()
   {
    self.stopActivity()
    
    //let ReviewNavigationBar = UIView()
    ReviewNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
    ReviewNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
    view.addSubview(ReviewNavigationBar)
    
    let backButton = UIButton()
    backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
    backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
    backButton.tag = 4
    backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
    ReviewNavigationBar.addSubview(backButton)
    
    let navigationTitle = UILabel()
    navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: ReviewNavigationBar.frame.width, height: (3 * y))
    navigationTitle.text = "RATE AND WRITE A REVIEW"
    navigationTitle.textColor = UIColor.white
    navigationTitle.textAlignment = .center
    navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
    ReviewNavigationBar.addSubview(navigationTitle)
    
    //RatingsLabel..
    let RatingsLabel = UILabel()
    RatingsLabel.frame = CGRect(x: (3 * x), y: ReviewNavigationBar.frame.maxY + (3 * y), width: (10 * x), height: (2.5 * y))
    RatingsLabel.text = "GIVE A RATINGS"
    RatingsLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
    RatingsLabel.textColor =  UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
    //RatingsLabel.backgroundColor = UIColor.lightGray
    view.addSubview(RatingsLabel)
    
    
    // UnderLine..
    let RatingsUnderline = UILabel()
    RatingsUnderline.frame = CGRect(x: (3 * x), y: RatingsLabel.frame.maxY - 5, width: (10 * x), height: 0.5)
    RatingsUnderline.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
    view.addSubview(RatingsUnderline)
    
    
    // RatingsView..
    let RatingsView = UIView()
    RatingsView.frame = CGRect(x: (3 * x), y: RatingsUnderline.frame.maxY + y, width: view.frame.width - (6 * x), height: (12 * y))
    RatingsView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
    view.addSubview(RatingsView)
    
  var y1:CGFloat = y
    
  for i in 0..<RatingTypeArray.count
  {
    //RatingsTypeView..
    let RatingTypeView = UIView()
    RatingTypeView.frame = CGRect(x: (2 * x), y: y1, width: RatingsView.frame.width - (4 * x), height: (2.5 * y))
    RatingTypeView.backgroundColor = UIColor.white
    RatingsView.addSubview(RatingTypeView)
   
     //RatingsTypeLabel
    let RatingsTypeLabel = UILabel()
    RatingsTypeLabel.frame = CGRect(x: x/2, y: 0, width: (12 * x), height: (2.5 * y))
    RatingsTypeLabel.textColor = UIColor.black
    // RatingsTypeLabel.backgroundColor = UIColor.lightGray
    RatingsTypeLabel.text = RatingTypeArray[i] as? String
    
    RatingsTypeLabel.textAlignment = .center
    RatingsTypeLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
    RatingsTypeLabel.adjustsFontSizeToFitWidth = true
    RatingTypeView.addSubview(RatingsTypeLabel)
    
    // ColonLabel :-
    let ColonLabel = UILabel()
    ColonLabel.frame = CGRect(x: RatingsTypeLabel.frame.maxX, y: 0, width: (2 * x), height: (2.5 * y))
    //ColonLabel.backgroundColor = UIColor.gray
    ColonLabel.text = "-"
    ColonLabel.textColor = UIColor.black
    ColonLabel.textAlignment = .center
    ColonLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
    RatingTypeView.addSubview(ColonLabel)
    
    // Ratings Buttons
   
    /*
    let CustomerRatingImageView = UIImageView()
    CustomerRatingImageView.frame = CGRect(x: ColonLabel.frame.maxX, y: 0, width: (12 * x), height:(2 * y))
    CustomerRatingImageView.image = UIImage(named: "5")
    RatingTypeView.addSubview(CustomerRatingImageView)
   */
    
   // Ratings....
    
     let customerRatingView = CosmosView()
    customerRatingView.frame = CGRect(x: ColonLabel.frame.maxX, y: y/2, width: (12 * x), height:(2.5 * y))
    //customerRatingView.settings.updateOnTouch = false
    customerRatingView.settings.fillMode = .half
    customerRatingView.settings.starSize = 20
   // customerRatingView.settings.starMargin = 5
    customerRatingView.settings.filledColor = UIColor.orange
    customerRatingView.settings.emptyBorderColor = UIColor.orange
    customerRatingView.settings.filledBorderColor = UIColor.orange
    customerRatingView.settings.filledImage = UIImage(named: "GoldStarFull")?.withRenderingMode(.alwaysOriginal)
     customerRatingView.settings.emptyImage = UIImage(named: "GoldStarEmpty")?.withRenderingMode(.alwaysOriginal)
    
    RatingTypeView.addSubview(customerRatingView)
    
    
    customerRatingView.didTouchCosmos = { rating in
        print("rated :", "\(rating)")
        
        self.RatingNum = Int(rating)
    }
    
      y1 = RatingTypeView.frame.maxY + y
    }
    
    //RatingsLabel..
    let ReviewLabel = UILabel()
    ReviewLabel.frame = CGRect(x: (3 * x), y: RatingsView.frame.maxY + (3 * y), width: (11 * x), height: (2.5 * y))
    ReviewLabel.text = "WRITE A REVIEW"
    ReviewLabel.font = UIFont(name: "Avenir Next", size: (1.3 * x))
    ReviewLabel.textColor =  UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
    //ReviewLabel.backgroundColor = UIColor.lightGray
    view.addSubview(ReviewLabel)
    
    // UnderLine..
    let ReviewUnderline = UILabel()
    ReviewUnderline.frame = CGRect(x: (3 * x), y: ReviewLabel.frame.maxY - 5, width: (11 * x), height: 0.5)
    ReviewUnderline.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
    view.addSubview(ReviewUnderline)
    
    // REviewsTF..
     let Review_TF = UITextField()
    Review_TF.frame = CGRect(x: (3 * x), y: ReviewUnderline.frame.maxY + y, width: view.frame.width - (6 * x), height: (10 * y))
    Review_TF.backgroundColor = UIColor.white
    Review_TF.placeholder = "      Write a review..   "
    Review_TF.textColor = UIColor.black
    Review_TF.textAlignment = .left
    Review_TF.contentVerticalAlignment = .top
    Review_TF.layer.borderColor = UIColor.lightGray.cgColor
    Review_TF.layer.borderWidth = 1.0
    //Review_TF.layer.cornerRadius = 10
    Review_TF.font = UIFont(name: "Avenir Next", size: 1.5 * x)
    Review_TF.leftViewMode = UITextField.ViewMode.always
    Review_TF.adjustsFontSizeToFitWidth = true
    Review_TF.keyboardType = .default
    Review_TF.clearsOnBeginEditing = true
    Review_TF.returnKeyType = .done
    Review_TF.addTarget(self, action: #selector(self.DoneAction), for: .allEditingEvents)
    Review_TF.delegate = self
    view.addSubview(Review_TF)
    
    
    let SubmitButton = UIButton()
    SubmitButton.frame = CGRect(x: (20 * x), y: Review_TF.frame.maxY + (3 * y) , width: (15 * x), height: (3 * y))
    SubmitButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
    SubmitButton.setTitle("Submit", for: .normal)
    SubmitButton.setTitleColor(UIColor.white, for: .normal)
    SubmitButton.titleLabel?.font = UIFont(name: "Avenir-Regular", size: 1.3 * x)
    SubmitButton.layer.borderWidth = 1.0
    SubmitButton.layer.cornerRadius = 15
    SubmitButton.addTarget(self, action: #selector(self.SubmitButtonAction(sender:)), for: .touchUpInside)
    
  view.addSubview(SubmitButton)
   }
    
  @objc func otpBackButtonAction(sender : UIButton)
  {
    self.navigationController?.popViewController(animated: true)
  }
    
  @objc func DoneAction()
  {
     Review_TF.resignFirstResponder()
  }
    
  @objc func SubmitButtonAction(sender : UIButton)
  {
    
    print("Review:",reviewStr)
    print("Rating:",RatingNum)
    
    self.serviceCall.API_InsertRatings(OrderId:1, CategoryId:1, Review:reviewStr, Rating:RatingNum, TailorId:1, delegate: self)
    
  }
}
