//
//  SlideMenuView.swift
//  Mzyoon
//
//  Created by QOL on 31/10/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class SlideMenuView: UIView
{
    var x = CGFloat()
    var y = CGFloat()
    
    let homeScreen = HomeViewController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        x = 10 / 375 * 100
        x = x * self.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * self.frame.height / 100
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        self.addCustomView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCustomView()
    {
        let slideView = UIView()
        slideView.frame = CGRect(x: 0, y: 0, width: self.frame.width - 75, height: self.frame.height)
        slideView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        self.addSubview(slideView)
        
        
        let userImage = UIImageView()
        userImage.frame = CGRect(x: ((slideView.frame.width - 100) / 2), y: 25, width: 100, height: 100)
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.layer.borderWidth = 0.50
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.masksToBounds = true
        userImage.image = UIImage(named: "men")
        slideView.addSubview(userImage)
        
        let userName = UILabel()
        userName.frame = CGRect(x: 0, y: userImage.frame.maxY + 10, width: slideView.frame.width, height: 30)
        userName.text = "MOHAMMED"
        userName.textColor = UIColor.white
        userName.textAlignment = .center
        slideView.addSubview(userName)
        
        let underline = UILabel()
        underline.frame = CGRect(x: 0, y: userName.frame.maxY + y, width: slideView.frame.width, height: 0.25)
        underline.backgroundColor = UIColor.white
        slideView.addSubview(underline)
        
        let buttonTitle = ["My Account", "Book an Appointment" ,"Transaction" ,"Rewards", "Refer Friends", "FAQ", "Terms and Conditions", "Settings", "Log Out"]
        let buttonImage = ["my_account", "appointment-1", "transaction", "rewards", "refer_friends", "FAQ", "terms&condition", "settings", "logout"]
        
        var y1:CGFloat = userName.frame.maxY + (2 * y)
        
        
        for i in 0..<buttonTitle.count
        {
            let slideMenusButton = UIButton()
            slideMenusButton.frame = CGRect(x: 0, y: y1, width: slideView.frame.width, height: (4 * y))
            slideMenusButton.tag = i
            slideMenusButton.addTarget(self, action: #selector(self.slideMenuButtonAction(sender:)), for: .touchUpInside)
             slideView.addSubview(slideMenusButton)
            
            y1 = slideMenusButton.frame.maxY + y
            
            let slideMenuButonImage = UIImageView()
            slideMenuButonImage.frame = CGRect(x: (3 * x), y: y, width: (2 * x), height: (2 * y))
            slideMenuButonImage.image = UIImage(named: buttonImage[i])
            slideMenusButton.addSubview(slideMenuButonImage)
            
            let slideMenuButtonTitle = UILabel()
            slideMenuButtonTitle.frame = CGRect(x: slideMenuButonImage.frame.maxX + x, y: y, width: slideMenusButton.frame.width, height: (2 * y))
            slideMenuButtonTitle.text = buttonTitle[i]
            slideMenuButtonTitle.textColor = UIColor.white
            slideMenuButtonTitle.textAlignment = .left
            slideMenusButton.addSubview(slideMenuButtonTitle)
        }
        
        let slideMenuButton = UIButton()
        slideMenuButton.frame = CGRect(x: slideView.frame.maxX, y: ((self.frame.height - 65) / 2), width: 30, height: 65)
        slideMenuButton.setImage(UIImage(named: "sidemenu"), for: .normal)
        slideMenuButton.addTarget(self, action: #selector(self.slideMenuButtonAction(sender:)), for: .touchUpInside)
        self.addSubview(slideMenuButton)
    }
    
    @objc func menuButtonAction(sender : UIButton)
    {
        self.removeFromSuperview()
        
        if sender.tag == 0
        {
            let profileScreen = ProfileViewController()
            homeScreen.navigationController?.pushViewController(profileScreen, animated: true)
        }
        else
        {
            
        }
    }
    
    @objc func slideMenuButtonAction(sender : UIButton)
    {
        self.removeFromSuperview()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
