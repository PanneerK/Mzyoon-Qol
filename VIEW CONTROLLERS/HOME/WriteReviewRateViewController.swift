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
    var Review_TF = UITextField()
    
    var reviewStr:String!
    var OnTimeServiceRatingNum:Int!
    var StitchingQualityRatingNum:Int!
    var CustomerServiceRatingNum:Int!
    
    var OrderID:Int!
  //  var CategoryID = [[String : AnyObject]]()
    var TailorID:Int!
    
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    var applicationDelegate = AppDelegate()
    
    var RatingsInt = Int()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
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
            let Result = insertRating.object(forKey: "Result") as! String
            
            print("RAting Result :",Result)
           
           if(Result == "1")
           {
            
            let alert = UIAlertController(title: "", message: "Thank You for FeedBack", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: OkAction(action:)))
            self.present(alert, animated: true, completion: nil)
            
           }
          
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
    func OkAction(action : UIAlertAction)
    {
        window = UIWindow(frame: UIScreen.main.bounds)
        let HomeScreen = HomeViewController()
        let navigationScreen = UINavigationController(rootViewController: HomeScreen)
        navigationScreen.isNavigationBarHidden = true
        window?.rootViewController = navigationScreen
        window?.makeKeyAndVisible()
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
 
    
 /*
     
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
 
 */
    
    //OnTimeServiceView..
    let OnTimeServiceView = UIView()
    OnTimeServiceView.frame = CGRect(x: (2 * x), y: y, width: RatingsView.frame.width - (4 * x), height: (2.5 * y))
    OnTimeServiceView.backgroundColor = UIColor.white
    RatingsView.addSubview(OnTimeServiceView)
    
    //RatingsTypeLabel
    let OnTimeServiceLabel = UILabel()
    OnTimeServiceLabel.frame = CGRect(x: x/2, y: 0, width: (12 * x), height: (2.5 * y))
    OnTimeServiceLabel.textColor = UIColor.black
    // OnTimeServiceLabel.backgroundColor = UIColor.lightGray
    OnTimeServiceLabel.text = "ON TIME SERVICE"
    OnTimeServiceLabel.textAlignment = .center
    OnTimeServiceLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
    OnTimeServiceLabel.adjustsFontSizeToFitWidth = true
    OnTimeServiceView.addSubview(OnTimeServiceLabel)
    
    // ColonLabel :-
    let ColonLabel1 = UILabel()
    ColonLabel1.frame = CGRect(x: OnTimeServiceLabel.frame.maxX, y: 0, width: (2 * x), height: (2.5 * y))
    //ColonLabel1.backgroundColor = UIColor.gray
    ColonLabel1.text = "-"
    ColonLabel1.textColor = UIColor.black
    ColonLabel1.textAlignment = .center
    ColonLabel1.font = UIFont(name: "Avenir Next", size: 1.3 * x)
    OnTimeServiceView.addSubview(ColonLabel1)
    
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
    
    
    //StichingQualityView..
    let StichingQualityView = UIView()
    StichingQualityView.frame = CGRect(x: (2 * x), y: OnTimeServiceView.frame.maxY + y, width: RatingsView.frame.width - (4 * x), height: (2.5 * y))
    StichingQualityView.backgroundColor = UIColor.white
    RatingsView.addSubview(StichingQualityView)
    
    
    //StitchingQualityLabel
    let StitchingQualityLabel = UILabel()
    StitchingQualityLabel.frame = CGRect(x: x/2, y: 0, width: (12 * x), height: (2.5 * y))
    StitchingQualityLabel.textColor = UIColor.black
    // StitchingQualityLabel.backgroundColor = UIColor.lightGray
    StitchingQualityLabel.text = "STICHING QUALITY"
    StitchingQualityLabel.textAlignment = .center
    StitchingQualityLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
    StitchingQualityLabel.adjustsFontSizeToFitWidth = true
    StichingQualityView.addSubview(StitchingQualityLabel)
    
    // ColonLabel :-
    let ColonLabel2 = UILabel()
    ColonLabel2.frame = CGRect(x: StitchingQualityLabel.frame.maxX, y: 0, width: (2 * x), height: (2.5 * y))
    //ColonLabel2.backgroundColor = UIColor.gray
    ColonLabel2.text = "-"
    ColonLabel2.textColor = UIColor.black
    ColonLabel2.textAlignment = .center
    ColonLabel2.font = UIFont(name: "Avenir Next", size: 1.3 * x)
    StichingQualityView.addSubview(ColonLabel2)
    
    // Ratings....
    let StichingQualityRating = CosmosView()
    StichingQualityRating.frame = CGRect(x: ColonLabel2.frame.maxX, y: y/2, width: (12 * x), height:(2.5 * y))
    //StichingQualityRating.settings.updateOnTouch = false
    StichingQualityRating.settings.fillMode = .half
    StichingQualityRating.settings.starSize = 20
    //StichingQualityRating.settings.starMargin = 5
    StichingQualityRating.settings.filledColor = UIColor.orange
    StichingQualityRating.settings.emptyBorderColor = UIColor.orange
    StichingQualityRating.settings.filledBorderColor = UIColor.orange
    StichingQualityRating.settings.filledImage = UIImage(named: "GoldStarFull")?.withRenderingMode(.alwaysOriginal)
    StichingQualityRating.settings.emptyImage = UIImage(named: "GoldStarEmpty")?.withRenderingMode(.alwaysOriginal)
    StichingQualityView.addSubview(StichingQualityRating)
    
    
    StichingQualityRating.didTouchCosmos = { rating in
        print("StichingQualityRating :", "\(rating)")
        
        self.StitchingQualityRatingNum = Int(rating)
        
    }
    
    
    //CustomerServiceView..
    let CustomerServiceView = UIView()
    CustomerServiceView.frame = CGRect(x: (2 * x), y: StichingQualityView.frame.maxY + y, width: RatingsView.frame.width - (4 * x), height: (2.5 * y))
    CustomerServiceView.backgroundColor = UIColor.white
    RatingsView.addSubview(CustomerServiceView)
    
    //CustomerServiceLabel
    let CustomerServiceLabel = UILabel()
    CustomerServiceLabel.frame = CGRect(x: x/2, y: 0, width: (12 * x), height: (2.5 * y))
    CustomerServiceLabel.textColor = UIColor.black
    // CustomerServiceLabel.backgroundColor = UIColor.lightGray
    CustomerServiceLabel.text = "CUSTOMER SERVICE"
    CustomerServiceLabel.textAlignment = .center
    CustomerServiceLabel.font = UIFont(name: "Avenir Next", size: 1.3 * x)
    CustomerServiceLabel.adjustsFontSizeToFitWidth = true
    CustomerServiceView.addSubview(CustomerServiceLabel)
    
    // ColonLabel :-
    let ColonLabel3 = UILabel()
    ColonLabel3.frame = CGRect(x: CustomerServiceLabel.frame.maxX, y: 0, width: (2 * x), height: (2.5 * y))
    //ColonLabel3.backgroundColor = UIColor.gray
    ColonLabel3.text = "-"
    ColonLabel3.textColor = UIColor.black
    ColonLabel3.textAlignment = .center
    ColonLabel3.font = UIFont(name: "Avenir Next", size: 1.3 * x)
    CustomerServiceView.addSubview(ColonLabel3)
    
    // Ratings....
    let CustomerServiceRating = CosmosView()
    CustomerServiceRating.frame = CGRect(x: ColonLabel3.frame.maxX, y: y/2, width: (12 * x), height:(2.5 * y))
    //CustomerServiceRating.settings.updateOnTouch = false
    CustomerServiceRating.settings.fillMode = .half
    CustomerServiceRating.settings.starSize = 20
    // CustomerServiceRating.settings.starMargin = 5
    CustomerServiceRating.settings.filledColor = UIColor.orange
    CustomerServiceRating.settings.emptyBorderColor = UIColor.orange
    CustomerServiceRating.settings.filledBorderColor = UIColor.orange
    CustomerServiceRating.settings.filledImage = UIImage(named: "GoldStarFull")?.withRenderingMode(.alwaysOriginal)
    CustomerServiceRating.settings.emptyImage = UIImage(named: "GoldStarEmpty")?.withRenderingMode(.alwaysOriginal)
    CustomerServiceView.addSubview(CustomerServiceRating)
    
    
    CustomerServiceRating.didTouchCosmos = { rating in
        print("CustomerServiceRating :", "\(rating)")
        
        self.CustomerServiceRatingNum = Int(rating)
        
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
    // let Review_TF = UITextField()
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
     reviewStr = self.Review_TF.text
    
  }
    
  @objc func SubmitButtonAction(sender : UIButton)
  {
    
    let CategoryID: [[String: Int]] = [["1":OnTimeServiceRatingNum],["2":StitchingQualityRatingNum],["3":CustomerServiceRatingNum]]
    let TailorId = UserDefaults.standard.value(forKey: "TailorID") as? Int
    
    print("Review:",reviewStr)
    print("Category:",CategoryID)
    print("Order ID:",OrderID)
    print("Tailor Id",TailorId!)
    
    if (reviewStr == nil || reviewStr.isEmpty)
    {
        reviewStr = ""
    }
    
    self.serviceCall.API_InsertRatings(OrderId:OrderID!, Category:CategoryID, Review:reviewStr, TailorId:TailorId!, delegate: self)
    
  }
}
