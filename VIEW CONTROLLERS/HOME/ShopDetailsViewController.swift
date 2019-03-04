//
//  ShopDetailsViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 27/02/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class ShopDetailsViewController: CommonViewController
{
    
    let shopName = UILabel()
    let ratingImageView = UIImageView()
    let ratingCountLabel = UILabel()
    let reviewsButton = UIButton()
    let ordersCountLabel = UILabel()
    
    var strPhoneNumber:String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        ShopDetailsContent()
       // strPhoneNumber = "+91 8015557649"
    }

  func ShopDetailsContent()
  {
     self.stopActivity()
    
     let ShopDetailsNavigationBar = UIView()
     ShopDetailsNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width,  height: (6.4 * y))
     ShopDetailsNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
    view.addSubview(ShopDetailsNavigationBar)
    
    let backButton = UIButton()
    backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
    backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
    backButton.tag = 4
    backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
    ShopDetailsNavigationBar.addSubview(backButton)
    
    let navigationTitle = UILabel()
    navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: ShopDetailsNavigationBar.frame.width, height: (3 * y))
    navigationTitle.text = "SHOP DETAILS"
    navigationTitle.textColor = UIColor.white
    navigationTitle.textAlignment = .center
    navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
    ShopDetailsNavigationBar.addSubview(navigationTitle)
    
    // let shopName = UILabel()
    shopName.frame = CGRect(x: (3 * x), y: ShopDetailsNavigationBar.frame.maxY + y, width: view.frame.width - (6 * x), height: (3 * y))
    shopName.text = "Shop Title"  // marker.title?.uppercased()
    shopName.textColor = UIColor.blue
    shopName.textAlignment = .left
    shopName.font = UIFont(name: "Avenir Next", size: (1.5 * x))
    shopName.adjustsFontSizeToFitWidth = true
    view.addSubview(shopName)
    
    print("SHOP NAME", shopName.text!)
    shopName.attributedText = NSAttributedString(string: shopName.text!, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    
    let ratingLabel = UILabel()
    ratingLabel.frame = CGRect(x: (3 * x), y: shopName.frame.maxY + (y / 2), width: (5 * x), height: (2 * y))
    ratingLabel.text = "Rating : "
    ratingLabel.textColor = UIColor.blue
    ratingLabel.textAlignment = .left
    ratingLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
    //view.addSubview(ratingLabel)
    
    //let ratingImageView = UIImageView()
    ratingImageView.frame = CGRect(x: (3 * x), y: shopName.frame.maxY + (y / 2), width: view.frame.width / 4, height: (1.5 * y))
    view.addSubview(ratingImageView)
    
    
   // let reviewsButton = UIButton()
    reviewsButton.frame = CGRect(x: ratingImageView.frame.maxX, y: shopName.frame.maxY + (y / 2), width: (7 * x), height: (2 * y))
    // reviewsButton.backgroundColor = UIColor.lightGray
    reviewsButton.setTitleColor(UIColor.blue, for: .normal)
    reviewsButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 1.2 * x)!
    reviewsButton.addTarget(self, action: #selector(self.ReviewsButtonAction(sender:)), for: .touchUpInside)
    view.addSubview(reviewsButton)
    
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
    nameLabel.frame = CGRect(x: (3 * x), y: ratingImageView.frame.maxY + (y / 2), width: (5 * x), height: (2 * y))
    nameLabel.text = "Name : "
    nameLabel.textColor = UIColor.blue
    nameLabel.textAlignment = .left
    nameLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
    view.addSubview(nameLabel)
    
    let tailorName = UILabel()
    tailorName.frame = CGRect(x: nameLabel.frame.maxX, y: ratingImageView.frame.maxY + (y / 2), width: view.frame.width / 2, height: (2 * y))
    tailorName.text = "Tailor Name"  //marker.snippet
    tailorName.textColor = UIColor.black
    tailorName.textAlignment = .left
    tailorName.font = UIFont(name: "Avenir Next", size: (1.2 * x))
    view.addSubview(tailorName)
    
    let ordersLabel = UILabel()
    ordersLabel.frame = CGRect(x: (3 * x), y: nameLabel.frame.maxY, width: (9 * x), height: (2 * y))
    ordersLabel.text = "No. of Orders : "
    ordersLabel.textColor = UIColor.blue
    ordersLabel.textAlignment = .left
    ordersLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
    view.addSubview(ordersLabel)
    
    //let ordersCountLabel = UILabel()
    ordersCountLabel.frame = CGRect(x: ordersLabel.frame.maxX, y: nameLabel.frame.maxY, width: view.frame.width / 2.5, height: (2 * y))
    ordersCountLabel.textColor = UIColor.black
    ordersCountLabel.textAlignment = .left
    ordersCountLabel.font = UIFont(name: "Avenir Next", size: (1.2 * x))
    ordersCountLabel.adjustsFontSizeToFitWidth = true
    view.addSubview(ordersCountLabel)
    
    /*
     for i in 0..<ShopNameArray.count
     {
        if let name = ShopNameArray[i] as? String
        {
            if name == marker.title
            {
                ratingImageView.image = UIImage(named: "\(ratingArray[i])")
                
                // ratingCountLabel.text = "(\(ratingArray[i]) reviews)"
                reviewsButton.setTitle("(\(ratingArray[i]) reviews)", for: .normal)
                ordersCountLabel.text = "\(orderCountArray[i])"
                
                TailorID = IdArray[i] as? Int
                
            }
        }
     }
    */
    
    let DetailsView = UIView()
    DetailsView.frame = CGRect(x: (3 * x), y: ordersCountLabel.frame.maxY + y, width: view.frame.width - (6 * x), height: (11 * y))
    DetailsView.backgroundColor = UIColor.white
    DetailsView.layer.borderWidth = 1
    DetailsView.layer.borderColor = UIColor.lightGray.cgColor
    view.addSubview(DetailsView)
    
    let Addr_Icon = UIImageView()
    Addr_Icon.frame = CGRect(x: x, y: y, width: (1.5 * x), height: (1.5 * y))
    Addr_Icon.image = UIImage(named: "Contact")
    DetailsView.addSubview(Addr_Icon)
    
    let Address_Label = UILabel()
    Address_Label.frame = CGRect(x: Addr_Icon.frame.maxX + x, y: y, width: (26 * x), height: (1.5 * y))
    // Address_Label.backgroundColor = UIColor.lightGray
    Address_Label.text = "Villa No:58, Near Dubai Zoo,Dubai, UAE"
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
    Time_Label.text = "OPEN : Closes 10:00 PM"
    Time_Label.font = UIFont(name: "Avenir Next", size: (1.2 * x))
    DetailsView.addSubview(Time_Label)
    
    let DownArrow_Icon = UIImageView()
    DownArrow_Icon.frame = CGRect(x: Time_Label.frame.maxX, y: underLine1.frame.maxY + y, width: (1.5 * x), height: (1.5 * y))
    DownArrow_Icon.image = UIImage(named: "downArrow")
    DetailsView.addSubview(DownArrow_Icon)
    
    let underLine2 = UILabel()
    underLine2.frame = CGRect(x: 0, y: Time_Label.frame.maxY + y, width: DetailsView.frame.width, height: 0.5)
    underLine2.backgroundColor = UIColor.lightGray
    DetailsView.addSubview(underLine2)
    
    
    let Link_Icon = UIImageView()
    Link_Icon.frame = CGRect(x: x, y: underLine2.frame.maxY + y, width: (1.5 * x), height: (1.5 * y))
    Link_Icon.image = UIImage(named: "WebLink")
    DetailsView.addSubview(Link_Icon)
    
    let Link_Label = UILabel()
    Link_Label.frame = CGRect(x: Time_Icon.frame.maxX + x, y: underLine2.frame.maxY + y, width: (20 * x), height: (1.5 * y))
   // Link_Label.backgroundColor = UIColor.lightGray
    Link_Label.text = "http://www.shopname.com"
    Link_Label.font = UIFont(name: "Avenir Next", size: (1.3 * x))
    DetailsView.addSubview(Link_Label)
    
    // Directions Button..
    let Direction_Btn = UIButton()
    Direction_Btn.frame = CGRect(x: (6 * x), y: DetailsView.frame.maxY + (2 * y), width: (5 * x), height: (4.8 * y))
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
    view.addSubview(Direction_Btn)
    
    let Directions_LBL = UILabel()
    Directions_LBL.frame = CGRect(x: (4 * x), y: Direction_Btn.frame.maxY + y, width: (8 * x), height: y)
   // Directions_LBL.backgroundColor = UIColor.lightGray
    Directions_LBL.text = "DIRECTIONS"
    Directions_LBL.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
    Directions_LBL.font = UIFont(name: "Avenir Next", size: y)
    Directions_LBL.textAlignment = .center
    view.addSubview(Directions_LBL)
    
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
    view.addSubview(Call_Btn)
    
    let Call_LBL = UILabel()
    Call_LBL.frame = CGRect(x: Directions_LBL.frame.maxX + (2 * x), y: Direction_Btn.frame.maxY + y, width: (10 * x), height: y)
    //Call_LBL.backgroundColor = UIColor.lightGray
    Call_LBL.text = "044 48616069"
    Call_LBL.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
    Call_LBL.font = UIFont(name: "Avenir Next", size: y)
    Call_LBL.textAlignment = .center
    view.addSubview(Call_LBL)
    
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
    view.addSubview(Share_Btn)
    
    let Share_LBL = UILabel()
    Share_LBL.frame = CGRect(x: Call_LBL.frame.maxX + (3 * x), y: Direction_Btn.frame.maxY + y, width: (6 * x), height: y)
    //Share_LBL.backgroundColor = UIColor.lightGray
    Share_LBL.text = "SHARE"
    Share_LBL.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
    Share_LBL.font = UIFont(name: "Avenir Next", size: y)
    Share_LBL.textAlignment = .center
    view.addSubview(Share_LBL)
    
  }

  @objc func otpBackButtonAction(sender : UIButton)
  {
     self.navigationController?.popViewController(animated: true)
  }
  
  @objc func ReviewsButtonAction(sender : UIButton)
  {
     let ReviewsScreen = ReviewsViewController()
     self.navigationController?.pushViewController(ReviewsScreen, animated: true)
  }
    
  @objc func DirectionButtonAction(sender : UIButton)
  {
      print("Directions Button..Click..!")
  }
    
   @objc func CallButtonAction(sender : UIButton)
  {
    
     let url: NSURL = URL(string: "TEL://914448616069")! as NSURL
     UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
  }
    
  @objc func ShareButtonAction(sender : UIButton)
  {
      print("Share Button..Click..!")
  }
    
}
