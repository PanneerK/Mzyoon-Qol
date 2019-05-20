//
//  ReferAndEarnViewController.swift
//  Mzyoon
//
//  Created by QOL on 17/05/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class ReferAndEarnViewController: CommonViewController
{
    
    let selfScreenContents = UIView()

    override func viewDidLoad()
    {
        Variables.sharedManager.screenNavigationBarTag = 0
        commonBackButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        selectedButton(tag: 0)
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                self.navigationTitle.text = "REFER AND EARN"
                self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            else if language == "ar"
            {
                self.navigationTitle.text = "أنا أشير وكسب"
                self.navigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            }
        }
        else
        {
            self.navigationTitle.text = "REFER AND EARN"
            self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            // Your code with delay
            self.referAndEarnScreenContents()
        }
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func referAndEarnScreenContents()
    {
        activity.stopActivity()
        
        selfScreenContents.frame = CGRect(x: 0, y: navigationBar.frame.maxY, width: view.frame.width, height: view.frame.height - ((5 * y) + navigationBar.frame.maxY))
        selfScreenContents.backgroundColor = UIColor.clear
        view.addSubview(selfScreenContents)
        
        let upperImage = UIImageView()
        upperImage.frame = CGRect(x: 0, y: 0, width: selfScreenContents.frame.width, height: (17 * y))
        upperImage.image = UIImage(named: "refer&earn")
        selfScreenContents.addSubview(upperImage)
        
        let shareView = UIView()
        shareView.frame = CGRect(x: x, y: upperImage.frame.maxY + y, width: selfScreenContents.frame.width - (2 * x), height: (16 * y))
        shareView.layer.borderColor = UIColor.lightGray.cgColor
        shareView.layer.borderWidth = 1
        shareView.backgroundColor = UIColor.white
        selfScreenContents.addSubview(shareView)
        
        let shareHeading = UILabel()
        shareHeading.frame = CGRect(x: 0, y: y, width: shareView.frame.width, height: (2 * y))
        shareHeading.text = "INVITE YOUR FRIENDS AND GET POINTS"
        shareHeading.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        shareHeading.textAlignment = .center
        shareHeading.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
        shareHeading.font = shareHeading.font.withSize(1.5 * x)
        shareView.addSubview(shareHeading)
        
        let shareDetailedLabel = UILabel()
        shareDetailedLabel.frame = CGRect(x: 0, y: shareHeading.frame.maxY, width: shareView.frame.width, height: (5 * y))
        shareDetailedLabel.text = "Ask your friends to signup with your refereal code and make an initial points once done both you and your friends each earn 50 points"
        shareDetailedLabel.textColor = UIColor.black
        shareDetailedLabel.textAlignment = .center
        shareDetailedLabel.font = UIFont(name: "Avenir-Regular", size: (1 * x))
        shareDetailedLabel.font = shareDetailedLabel.font.withSize(1 * x)
        shareDetailedLabel.numberOfLines = 3
        shareView.addSubview(shareDetailedLabel)
        
        let shareMzyoonBuyerButton = UIButton()
        shareMzyoonBuyerButton.frame = CGRect(x: x, y: shareDetailedLabel.frame.maxY, width: shareView.frame.width - (2 * x), height: (3 * y))
        shareMzyoonBuyerButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        shareMzyoonBuyerButton.setTitle("Invite your contacts - Buyer", for: .normal)
        shareMzyoonBuyerButton.setTitleColor(UIColor.white, for: .normal)
        shareMzyoonBuyerButton.titleLabel?.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
        shareMzyoonBuyerButton.titleLabel?.font = shareMzyoonBuyerButton.titleLabel?.font.withSize(1.5 * x)
        shareMzyoonBuyerButton.tag = 1
        shareMzyoonBuyerButton.addTarget(self, action: #selector(self.shareButtonAction(sender:)), for: .touchUpInside)
        shareView.addSubview(shareMzyoonBuyerButton)
        
        let shareMzyoonTailorButton = UIButton()
        shareMzyoonTailorButton.frame = CGRect(x: x, y: shareMzyoonBuyerButton.frame.maxY + y, width: shareView.frame.width - (2 * x), height: (3 * y))
        shareMzyoonTailorButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        shareMzyoonTailorButton.setTitle("Invite your contacts - Tailor", for: .normal)
        shareMzyoonTailorButton.setTitleColor(UIColor.white, for: .normal)
        shareMzyoonTailorButton.titleLabel?.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
        shareMzyoonTailorButton.titleLabel?.font = shareMzyoonTailorButton.titleLabel?.font.withSize(1.5 * x)
        shareMzyoonTailorButton.tag = 2
        shareMzyoonTailorButton.addTarget(self, action: #selector(self.shareButtonAction(sender:)), for: .touchUpInside)
        shareView.addSubview(shareMzyoonTailorButton)
        
        let viewAllButton = UIButton()
        viewAllButton.frame = CGRect(x: selfScreenContents.frame.width - (9 * x), y: shareView.frame.maxY + y, width: (8 * x), height: (2 * y))
        viewAllButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        viewAllButton.setTitle("VIEW ALL", for: .normal)
        viewAllButton.setTitleColor(UIColor.white, for: .normal)
        viewAllButton.titleLabel?.font = UIFont(name: "Avenir-Regular", size: (1.25 * x))
        viewAllButton.titleLabel?.font = viewAllButton.titleLabel?.font.withSize(1.25 * x)
        viewAllButton.addTarget(self, action: #selector(self.viewAllButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(viewAllButton)
        
        var x1:CGFloat = x
        var y1:CGFloat = viewAllButton.frame.maxY + y
        
        for i in 0..<6
        {
            let offersButton = UIButton()
            if i % 2 == 0
            {
                offersButton.frame = CGRect(x: x1, y: y1, width: (17.25 * x), height: (5 * y))
                x1 = offersButton.frame.maxX + x
            }
            else
            {
                offersButton.frame = CGRect(x: x1, y: y1, width: (17.25 * x), height: (5 * y))
                y1 = offersButton.frame.maxY + (y / 2)
                x1 = x
            }
            offersButton.layer.cornerRadius = x
            offersButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
            offersButton.setTitle("\(i)", for: .normal)
            offersButton.setTitleColor(UIColor.white, for: .normal)
            offersButton.titleLabel?.font = UIFont(name: "Avenir-Regular", size: (1.25 * x))
            offersButton.titleLabel?.font = offersButton.titleLabel?.font.withSize(1.25 * x)
            selfScreenContents.addSubview(offersButton)
        }
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func shareButtonAction(sender : UIButton)
    {
        var text = String()
        
        if sender.tag == 1
        {
            text = "https://play.google.com/store/apps/details?id=com.qoltech.mzyoon&hl=en"
        }
        else
        {
            text = "https://play.google.com/store/apps/details?id=com.qoltech.mzyoontailor&hl=en"
        }
        
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func viewAllButtonAction(sender : UIButton)
    {
        let offerScreen = OffersViewController()
        self.navigationController?.pushViewController(offerScreen, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
