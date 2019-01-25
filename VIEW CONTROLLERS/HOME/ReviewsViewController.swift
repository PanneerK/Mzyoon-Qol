//
//  ReviewsViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 25/01/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class ReviewsViewController:CommonViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        reviewsContent()
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
    RatingsView.frame = CGRect(x: x + 15 , y: ratingsNavigationBar.frame.maxY + y, width: view.frame.width - (5 * x), height: (10 * y))
    RatingsView.layer.cornerRadius = 5
    RatingsView.layer.borderWidth = 1
    RatingsView.layer.backgroundColor = UIColor.orange.cgColor
    RatingsView.layer.borderColor = UIColor.black.cgColor
    view.addSubview(RatingsView)
    
    let StarImageView = UIImageView()
    StarImageView.frame = CGRect(x: x, y: y, width: (8 * x), height:(8 * y))
    StarImageView.backgroundColor = UIColor.white
    
    /*
    if let imageName = DressImageArray[0] as? String
    {
    let api = "http://appsapi.mzyoon.com/images/DressSubType/\(imageName)"
    //  let api = "http://192.168.0.21/TailorAPI/Images/DressSubType/\(imageName)"
    let apiurl = URL(string: api)
    print("Image Of Dress", apiurl!)
    DressImageView.dowloadFromServer(url: apiurl!)
    }
    DressImageView(DressImageView)
   */
    
    let serviceLabel = UILabel()
    serviceLabel.frame = CGRect(x: StarImageView.frame.maxX + x, y: StarImageView.frame.minY - (6 * y), width: (20 * x), height: (2 * y))
    serviceLabel.text = "On Time Service"
    serviceLabel.textColor = UIColor.white
    //  DressTypeLabel.backgroundColor = UIColor.gray
    serviceLabel.textAlignment = .left
    serviceLabel.font = UIFont(name: "Avenir Next", size: 1.5 * x)
    RatingsView.addSubview(serviceLabel)
    
   
    let StitchLabel = UILabel()
    StitchLabel.frame = CGRect(x: StarImageView.frame.maxX + x, y: serviceLabel.frame.minY + (3 * y), width: (20 * x), height: (2 * y))
    StitchLabel.text = "Stiching Quality"
    StitchLabel.textColor = UIColor.white
    StitchLabel.textAlignment = .left
    StitchLabel.font = UIFont(name: "Avenir Next", size: 1.5 * x)
    RatingsView.addSubview(StitchLabel)
    
    
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
