//
//  RedeemViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 22/05/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class RedeemViewController: CommonViewController
{
    //SCREEN PARAMETERS
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()
    
    let selfScreenContents = UIView()
    let PaymentButton = UIButton()
    
    let ChangeValue_LBL = UILabel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     
        screenContents()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        selectedButton(tag: 2)
        
        // self.serviceCall.API_OrderApprovalPrice(TailorResponseId: self.TailorResponseID, delegate: self)
    }
    func screenContents()
    {
        stopActivity()
        activity.stopActivity()
        
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
        selfScreenNavigationTitle.text = "REDEEM"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationTitle.font = selfScreenNavigationTitle.font.withSize(2 * x)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        selfScreenContents.frame = CGRect(x: x, y: selfScreenNavigationBar.frame.maxY, width: view.frame.width - (2 * x), height: view.frame.height - ((5 * y) + selfScreenNavigationBar.frame.maxY))
        selfScreenContents.backgroundColor = UIColor.clear
        view.addSubview(selfScreenContents)
        
        let TotPtsView_LBL = UILabel()
        TotPtsView_LBL.frame = CGRect(x: x , y: (3 * y), width: selfScreenContents.frame.width - (2 * x), height: (3 * y))
       // TotPtsCount_LBL.text = "Total Available Points   4800 Points"
       // TotPtsView_LBL.textColor = UIColor.white
        TotPtsView_LBL.layer.cornerRadius = 10
        TotPtsView_LBL.layer.borderWidth = 0.5
        //TotPtsCount_LBL.layer.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0).cgColor
        TotPtsView_LBL.layer.borderColor = UIColor.lightGray.cgColor
        TotPtsView_LBL.clipsToBounds = true
        //TotPtsView_LBL.textAlignment = .center
        TotPtsView_LBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        selfScreenContents.addSubview(TotPtsView_LBL)
        
        let TotPts_LBL = UILabel()
        TotPts_LBL.frame = CGRect(x: x/2 , y: 0, width: (TotPtsView_LBL.frame.width / 2) + x, height: (3 * y))
        TotPts_LBL.text = "TOTAL AVAILABLE POINTS"
       // TotPts_LBL.backgroundColor = UIColor.lightGray
        TotPtsView_LBL.textAlignment = .center
        TotPts_LBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        TotPtsView_LBL.addSubview(TotPts_LBL)
        
        let PointsViewButton = UIButton()
        PointsViewButton.frame = CGRect(x: TotPts_LBL.frame.maxX , y: 0, width: (TotPtsView_LBL.frame.width) - (TotPts_LBL.frame.width), height: (3 * y))
        PointsViewButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        PointsViewButton.setTitle("4800 POINTS", for: .normal)
        PointsViewButton.setTitleColor(UIColor.white, for: .normal)
        PointsViewButton.titleLabel?.font =  UIFont(name: "Avenir Next", size: 1.5 * x)
        PointsViewButton.layer.cornerRadius = 10;  // this value vary as per your desire
        PointsViewButton.clipsToBounds = true;
        PointsViewButton.isUserInteractionEnabled = false
        TotPtsView_LBL.addSubview(PointsViewButton)
        
        let CoinsImageView = UIImageView()
        CoinsImageView.frame = CGRect(x: x, y: y/2, width: (2 * x), height: (2 * y))
        CoinsImageView.image = UIImage(named: "Coins")
        PointsViewButton.addSubview(CoinsImageView)
        
        // UnderLine..
        let UnderLine = UILabel()
        UnderLine.frame = CGRect(x: x/2, y: TotPtsView_LBL.frame.maxY + (2 * y) , width: self.selfScreenContents.frame.width - x, height: 0.3)
        UnderLine.backgroundColor = UIColor.lightGray
        selfScreenContents.addSubview(UnderLine)
        
        let Mzyoon_LBL = UILabel()
        Mzyoon_LBL.frame = CGRect(x: x, y: UnderLine.frame.maxY + y, width: selfScreenContents.frame.width - (2 * x), height: (2 * y))
        Mzyoon_LBL.text = "USE YOUR MZYOON POINTS"
        Mzyoon_LBL.textAlignment = .left
        Mzyoon_LBL.font = UIFont(name: "Avenir-Regular", size: x)
        selfScreenContents.addSubview(Mzyoon_LBL)
        
        let MzyoonCont_LBL = UILabel()
        MzyoonCont_LBL.frame = CGRect(x: x, y: Mzyoon_LBL.frame.maxY + y/2, width: selfScreenContents.frame.width - (2 * x), height: (2 * y))
        MzyoonCont_LBL.text = "Select the amount to pay with your Mzyoon Points"
        MzyoonCont_LBL.textAlignment = .left
        MzyoonCont_LBL.font = UIFont(name: "Avenir Next", size: 1.2 * x)
        selfScreenContents.addSubview(MzyoonCont_LBL)
        
        // let ChangeValue_LBL = UILabel()
        ChangeValue_LBL.frame = CGRect(x: (selfScreenContents.frame.width / 2) - (2 * x), y: Mzyoon_LBL.frame.maxY + (3 * y), width: (8 * x), height: (2 * y))
        ChangeValue_LBL.backgroundColor = UIColor.orange
        ChangeValue_LBL.textColor = UIColor.white
        ChangeValue_LBL.text = "2400"
        ChangeValue_LBL.textAlignment = .center
        ChangeValue_LBL.font = UIFont(name: "Avenir Next", size: 1.4 * x)
        selfScreenContents.addSubview(ChangeValue_LBL)
        
        // SliderMenu..
        let slider = UISlider()
        slider.frame = CGRect(x: (2 * x), y: ChangeValue_LBL.frame.maxY + y, width: selfScreenContents.frame.width - (4 * x), height: (2 * y))
        //slider.center = self.view.center
        //slider.backgroundColor = UIColor.cyan
        slider.minimumTrackTintColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        slider.maximumTrackTintColor = .lightGray
        slider.thumbTintColor = .white
        slider.maximumValue = 4800
        slider.minimumValue = 0
        slider.setValue(2400, animated: false)
        slider.addTarget(self, action: #selector(SliderChangeValue(_:)), for: .valueChanged)
        selfScreenContents.addSubview(slider)
        
        let StartPts_LBL = UILabel()
        StartPts_LBL.frame = CGRect(x: x, y: slider.frame.maxY, width: (3 * x), height: (2 * y))
        StartPts_LBL.text = "0"
        StartPts_LBL.textAlignment = .left
        StartPts_LBL.font = UIFont(name: "Avenir Next", size: 1.2 * x)
        selfScreenContents.addSubview(StartPts_LBL)
        
        let EndPts_LBL = UILabel()
        EndPts_LBL.frame = CGRect(x: slider.frame.width, y: slider.frame.maxY, width: (3 * x), height: (2 * y))
        EndPts_LBL.text = "4800"
        EndPts_LBL.textAlignment = .left
        EndPts_LBL.font = UIFont(name: "Avenir Next", size: 1.2 * x)
        selfScreenContents.addSubview(EndPts_LBL)
        
        // Points View..
        let PointsView = UIView()
        PointsView.frame = CGRect(x: x/2, y: slider.frame.maxY + (3 * y), width: selfScreenContents.frame.width - x, height: (10 * y))
        //PointsView.layer.cornerRadius = 5
        PointsView.layer.borderWidth = 1
        PointsView.layer.backgroundColor = UIColor.white.cgColor
        PointsView.layer.borderColor = UIColor.lightGray.cgColor
        selfScreenContents.addSubview(PointsView)
        
        let pointsImageView = UIImageView()
        pointsImageView.frame = CGRect(x: (4 * x), y: y, width: (6 * x), height:(6 * y))
       // pointsImageView.backgroundColor = UIColor.white
        pointsImageView.image = UIImage(named: "Coins")
        PointsView.addSubview(pointsImageView)
        
        let PtsRedeem_LBL = UILabel()
        PtsRedeem_LBL.frame = CGRect(x: 0, y: pointsImageView.frame.maxY + y/2, width: (14 * x), height: (2 * y))
        PtsRedeem_LBL.text = "POINTS TO REDEEM"
       // PtsRedeem_LBL.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
       // PtsRedeem_LBL.backgroundColor = UIColor.gray
        PtsRedeem_LBL.textAlignment = .center
        PtsRedeem_LBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PointsView.addSubview(PtsRedeem_LBL)
        
        // Straight Line..
        let Pts_StraightLine = UILabel()
        Pts_StraightLine.frame = CGRect(x: PtsRedeem_LBL.frame.maxX, y: y, width: 0.3, height: PointsView.frame.height - (2 * y))
        Pts_StraightLine.backgroundColor = UIColor.lightGray
        PointsView.addSubview(Pts_StraightLine)
        
        let PtsUsed_LBL = UILabel()
        PtsUsed_LBL.frame = CGRect(x: Pts_StraightLine.frame.maxX + x, y: (2 * y), width: (8 * x), height: (2 * y))
        PtsUsed_LBL.text = "Points Used"
       // PtsUsed_LBL.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
       // PtsUsed_LBL.backgroundColor = UIColor.gray
        PtsUsed_LBL.textAlignment = .left
        PtsUsed_LBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PointsView.addSubview(PtsUsed_LBL)
        
        let PtsUsedCount_LBL = UILabel()
        PtsUsedCount_LBL.frame = CGRect(x: PtsUsed_LBL.frame.maxX , y: (2 * y), width: (10 * x), height: (2 * y))
        PtsUsedCount_LBL.text = "3500"
        PtsUsedCount_LBL.textColor = UIColor.white
        PtsUsedCount_LBL.layer.cornerRadius = 10
        PtsUsedCount_LBL.layer.borderWidth = 0.5
        PtsUsedCount_LBL.layer.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0).cgColor
        PtsUsedCount_LBL.layer.borderColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0).cgColor
        PtsUsedCount_LBL.clipsToBounds = true
        PtsUsedCount_LBL.textAlignment = .center
        PtsUsedCount_LBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PointsView.addSubview(PtsUsedCount_LBL)
        
        let PtsLeft_LBL = UILabel()
        PtsLeft_LBL.frame = CGRect(x: Pts_StraightLine.frame.maxX + x, y: PtsUsed_LBL.frame.minY + (3 * y), width: (8 * x), height: (2 * y))
        PtsLeft_LBL.text = "Points Left"
        // PtsLeft_LBL.backgroundColor = UIColor.gray
        // PtsLeft_LBL.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        PtsLeft_LBL.textAlignment = .left
        PtsLeft_LBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PointsView.addSubview(PtsLeft_LBL)
        
        let PtsLeftCount_LBL = UILabel()
        PtsLeftCount_LBL.frame = CGRect(x: PtsLeft_LBL.frame.maxX , y: PtsUsedCount_LBL.frame.minY + (3 * y), width: (10 * x), height: (2 * y))
        PtsLeftCount_LBL.text = "1300"
        PtsLeftCount_LBL.textColor = UIColor.white
        PtsLeftCount_LBL.layer.cornerRadius = 10
        PtsLeftCount_LBL.layer.borderWidth = 0.5
        PtsLeftCount_LBL.layer.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0).cgColor
        PtsLeftCount_LBL.layer.borderColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0).cgColor
        PtsLeftCount_LBL.clipsToBounds = true
        PtsLeftCount_LBL.textAlignment = .center
        PtsLeftCount_LBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        PointsView.addSubview(PtsLeftCount_LBL)
        
        // Converted View..
        let ConvertedView = UIView()
        ConvertedView.frame = CGRect(x: x/2, y: PointsView.frame.maxY + (2 * y), width: selfScreenContents.frame.width - x, height: (10 * y))
        ConvertedView.layer.borderWidth = 1
        ConvertedView.layer.backgroundColor = UIColor.white.cgColor
        ConvertedView.layer.borderColor = UIColor.lightGray.cgColor
        selfScreenContents.addSubview(ConvertedView)
        
        let DiscImageView = UIImageView()
        DiscImageView.frame = CGRect(x: (4 * x), y: y, width: (4 * x), height:(4 * y))
       // DiscImageView.backgroundColor = UIColor.gray
        DiscImageView.image = UIImage(named: "Coins")
        ConvertedView.addSubview(DiscImageView)
        
        let Discount_LBL = UILabel()
        Discount_LBL.frame = CGRect(x: 0, y: DiscImageView.frame.maxY + y/2, width: (14 * x), height: (4 * y))
        Discount_LBL.text = "USE MONEY FOR DISCOUNT"
        Discount_LBL.numberOfLines = 2
        Discount_LBL.adjustsFontSizeToFitWidth = true
        // Discount_LBL.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
      //  Discount_LBL.backgroundColor = UIColor.gray
        Discount_LBL.textAlignment = .center
        Discount_LBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        ConvertedView.addSubview(Discount_LBL)
        
        // Straight Line..
        let Disc_StraightLine = UILabel()
        Disc_StraightLine.frame = CGRect(x: PtsRedeem_LBL.frame.maxX, y: y, width: 0.3, height: PointsView.frame.height - (2 * y))
        Disc_StraightLine.backgroundColor = UIColor.lightGray
        ConvertedView.addSubview(Disc_StraightLine)
        
        let ConvMoney_LBL = UILabel()
        ConvMoney_LBL.frame = CGRect(x: Disc_StraightLine.frame.maxX + (3 * x), y: (2 * y), width: (14 * x), height: (2 * y))
        ConvMoney_LBL.text = "Converted Money"
        // PtsUsed_LBL.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
       // ConvMoney_LBL.backgroundColor = UIColor.gray
        ConvMoney_LBL.textAlignment = .center
        ConvMoney_LBL.font = UIFont(name: "Avenir Next", size: 1.2 * x)
        ConvertedView.addSubview(ConvMoney_LBL)
        
        let ConvMoneyAmt_LBL = UILabel()
        ConvMoneyAmt_LBL.frame = CGRect(x: Disc_StraightLine.frame.maxX + (3 * x), y: ConvMoney_LBL.frame.minY + (3 * y), width: (14 * x), height: (2 * y))
        ConvMoneyAmt_LBL.text = "35.00 AED"
        // PtsLeft_LBL.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
       // ConvMoneyAmt_LBL.backgroundColor = UIColor.gray
        ConvMoneyAmt_LBL.textAlignment = .center
        ConvMoneyAmt_LBL.font = UIFont(name: "Avenir-Regular", size: 1.4 * x)
        ConvertedView.addSubview(ConvMoneyAmt_LBL)
        
        // ADD TO THE PAYMENT Button :-
        PaymentButton.frame = CGRect(x: 0, y: view.frame.height - (9 * y), width: view.frame.width , height: (4 * y))
        PaymentButton.backgroundColor = UIColor(red:0.29, green:0.48, blue:0.92, alpha:1.0)
        PaymentButton.setTitle("ADD TO THE PAYMENT", for: .normal)
        PaymentButton.setTitleColor(UIColor.white, for: .normal)
        PaymentButton.titleLabel?.font =  UIFont(name: "Avenir-Regular", size: 1.5 * x)
        PaymentButton.addTarget(self, action: #selector(self.AddToPaymentButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(PaymentButton)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func AddToPaymentButtonAction(sender : UIButton)
    {
        print("Redirecting To Payment..!")
    }
    @objc func SliderChangeValue(_ sender: UISlider)
    {
        print("value is" , Int(sender.value));
        let value = Int(sender.value)
        ChangeValue_LBL.text = "\(value)"
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
