//
//  RewardsViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 17/05/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit
import ScratchCard

class RewardsViewController: CommonViewController, ScratchUIViewDelegate
{

    //SCREEN PARAMETERS
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()
    
    let selfScreenContents = UIView()
    
    let ScratchCardButton = UIButton()
    let EarnPointsButton = UIButton()
    
    let ScratchCardScrollView = UIScrollView()
    let EarnPointsScrollView = UIScrollView()
    
   // BalancDetailsView-topview..
    let BalanceDetView = UIView()
    let CurrBalnc = UILabel()
    let CurrBalncAmt = UILabel()
    let PointsViewButton = UIButton()
    let CoinsImageView = UIImageView()
    
    //AccountView..
    let AccountView = UIView()
  
    // Purchase view..
    let PurchaseView = UIView()
  
    // Share Link view..
    let ShareView = UIView()

    
    // ScratchcardView..
    var scratchCard: ScratchUIView!
    
    override func viewDidLoad()
    {
       // navigationTitle.text = "REWARDS"
        
      //  view.backgroundColor = UIColor.black
        
     //   selectedButton(tag: 3)
        
        super.viewDidLoad()
        
        screenContents()
        
        scratchCard.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        selectedButton(tag: 3)
        // self.serviceCall.API_OrderApprovalPrice(TailorResponseId: self.TailorResponseID, delegate: self)
    }
    func screenContents()
    {
        stopActivity()
        activity.stopActivity()
        
        selfScreenNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        selfScreenNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(selfScreenNavigationBar)
      
        selfScreenNavigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: selfScreenNavigationBar.frame.width, height: (3 * y))
        selfScreenNavigationTitle.text = "REWARDS"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationTitle.font = selfScreenNavigationTitle.font.withSize(2 * x)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        selfScreenContents.frame = CGRect(x: x, y: selfScreenNavigationBar.frame.maxY, width: view.frame.width - (2 * x), height: view.frame.height - ((5 * y) + selfScreenNavigationBar.frame.maxY))
        selfScreenContents.backgroundColor = UIColor.clear
        view.addSubview(selfScreenContents)
        
       // let BalanceDetView = UIView()
        BalanceDetView.frame = CGRect(x: 0, y: y, width: selfScreenContents.frame.width, height: (8 * y))
        BalanceDetView.layer.cornerRadius = 10
        BalanceDetView.layer.borderWidth = 1
        BalanceDetView.layer.backgroundColor = UIColor.white.cgColor
        BalanceDetView.layer.borderColor = UIColor.lightGray.cgColor
        selfScreenContents.addSubview(BalanceDetView)
        
       // let CurrBalnc = UILabel()
        CurrBalnc.frame = CGRect(x: (4 * x), y: y, width: BalanceDetView.frame.width - (8 * x), height: (2 * y))
        CurrBalnc.text = "CURRENT BALANCE"
        CurrBalnc.font = UIFont(name: "Avenir-Regular", size: 1.3 * x)
        CurrBalnc.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        CurrBalnc.textAlignment = .center
        BalanceDetView.addSubview(CurrBalnc)
        
        //let CurrBalncAmt = UILabel()
        CurrBalncAmt.frame = CGRect(x: (5 * x), y: CurrBalnc.frame.maxY + y/2, width: BalanceDetView.frame.width - (10 * x), height: (2 * y))
        CurrBalncAmt.text = "AED 48.00"
        CurrBalncAmt.font = UIFont(name: "Avenir-Bold", size: 1.4 * x)
        CurrBalncAmt.textColor = UIColor.black
        CurrBalncAmt.textAlignment = .center
        BalanceDetView.addSubview(CurrBalncAmt)
        
        
        //let PointsViewButton = UIButton()
        PointsViewButton.frame = CGRect(x: (8 * x), y: CurrBalncAmt.frame.maxY + (2 * y), width: BalanceDetView.frame.width - (16 * x), height: (2 * y))
        PointsViewButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        PointsViewButton.setTitle("4800 POINTS", for: .normal)
        PointsViewButton.setTitleColor(UIColor.white, for: .normal)
        PointsViewButton.titleLabel?.font =  UIFont(name: "Avenir-Regular", size: 1.3 * x)
        PointsViewButton.layer.cornerRadius = 10;  // this value vary as per your desire
        PointsViewButton.clipsToBounds = true;
        PointsViewButton.isUserInteractionEnabled = false
        self.selfScreenContents.addSubview(PointsViewButton)
        
        
       // let CoinsImageView = UIImageView()
        CoinsImageView.frame = CGRect(x: x, y: y/2, width: (2 * x), height: (1.5 * y))
        CoinsImageView.image = UIImage(named: "Coins")
        PointsViewButton.addSubview(CoinsImageView)
       
        
        ScratchCardButton.frame = CGRect(x: 0, y: BalanceDetView.frame.maxY + (2 * y), width: ((selfScreenContents.frame.width / 2) - 1), height: (4 * y))
        ScratchCardButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        ScratchCardButton.setTitle("SCRATCH CARD", for: .normal)
        ScratchCardButton.setTitleColor(UIColor.white, for: .normal)
        ScratchCardButton.titleLabel?.font =  UIFont(name: "Avenir-Regular", size: 1.5 * x)
        ScratchCardButton.tag = 0
        ScratchCardButton.addTarget(self, action: #selector(self.selectionViewButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(ScratchCardButton)
        
        EarnPointsButton.frame = CGRect(x: ScratchCardButton.frame.maxX + 1, y: BalanceDetView.frame.maxY + (2 * y), width: selfScreenContents.frame.width / 2, height: (4 * y))
        EarnPointsButton.backgroundColor = UIColor.lightGray
        EarnPointsButton.setTitle("EARN POINTS", for: .normal)
        EarnPointsButton.setTitleColor(UIColor.black, for: .normal)
        EarnPointsButton.titleLabel?.font =  UIFont(name: "Avenir-Regular", size: 1.5 * x)
        EarnPointsButton.tag = 1
        EarnPointsButton.addTarget(self, action: #selector(self.selectionViewButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(EarnPointsButton)
        
        EarnPointsButton.backgroundColor = UIColor.lightGray
        EarnPointsButton.setTitleColor(UIColor.black, for: .normal)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                
            }
            else if language == "ar"
            {
               
            }
        }
        else
        {
           
        }
        
        ScratchCardViewContents(isHidden: false)
        EarnPointsViewContents(isHidden: true)
    }
    
    
    @objc func selectionViewButtonAction(sender : UIButton)
    {
        if sender.tag == 0
        {
            EarnPointsButton.backgroundColor = UIColor.lightGray
            EarnPointsButton.setTitleColor(UIColor.black, for: .normal)
            ScratchCardViewContents(isHidden: false)
            EarnPointsViewContents(isHidden: true)
            
        }
        else if sender.tag == 1
        {
            ScratchCardButton.backgroundColor = UIColor.lightGray
            ScratchCardButton.setTitleColor(UIColor.black, for: .normal)
            ScratchCardViewContents(isHidden: true)
            EarnPointsViewContents(isHidden: false)
            
        }
        
        sender.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        sender.setTitleColor(UIColor.white, for: .normal)
    }
    
    func ScratchCardViewContents(isHidden : Bool)
    {
        ScratchCardScrollView.frame = CGRect(x: 0, y: EarnPointsButton.frame.maxY, width: selfScreenContents.frame.width, height: (38 * y))
        ScratchCardScrollView.backgroundColor = UIColor.clear
        selfScreenContents.addSubview(ScratchCardScrollView)
        
        ScratchCardScrollView.isHidden = isHidden
        
        var y1:CGFloat = 0
        var x1:CGFloat = 0
        
        for views in ScratchCardScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        for i in 0..<3  // getNameArray.count
        {
       
          // scratchCard.frame = CGRect(x: x1, y: y1, width: (17.25 * x), height: (17 * y))
            scratchCard = ScratchUIView(frame: CGRect(x: 0, y: y, width:(17.25 * x), height:(13 * y)), Coupon: "Scratch_Image", MaskImage: "Scratch_Mask", ScratchWidth: CGFloat(15))
                y1 = scratchCard.frame.maxY + y
            scratchCard.backgroundColor = UIColor.white
            ScratchCardScrollView.addSubview(scratchCard)
            
            x1 = scratchCard.frame.maxX + x
            
        }
            ScratchCardScrollView.contentSize.height = y1 + (2 * y)
       
    }
    
    func EarnPointsViewContents(isHidden : Bool)
    {
        EarnPointsScrollView.frame = CGRect(x: 0, y: EarnPointsButton.frame.maxY, width: selfScreenContents.frame.width, height: (38 * y))
        EarnPointsScrollView.backgroundColor = UIColor.white
        selfScreenContents.addSubview(EarnPointsScrollView)
        
        EarnPointsScrollView.isHidden = isHidden
        
        // Create Account view..
       // let AccountView = UIView()
        AccountView.frame = CGRect(x: (2 * x), y: (3 * y), width: EarnPointsScrollView.frame.width - (4 * x), height: (7 * y))
        AccountView.layer.cornerRadius = 10
        AccountView.layer.borderWidth = 1
        AccountView.layer.backgroundColor = UIColor.white.cgColor
        AccountView.layer.borderColor = UIColor.lightGray.cgColor
        EarnPointsScrollView.addSubview(AccountView)
        
        
        let SignUpButton = UIButton()
        SignUpButton.frame = CGRect(x: (15 * x), y: AccountView.frame.minY - (2 * y), width: (5 * x), height: (4 * y))
        SignUpButton.backgroundColor = UIColor.white
        SignUpButton.layer.cornerRadius = 10;  // this value vary as per your desire
        SignUpButton.clipsToBounds = true;
        SignUpButton.isUserInteractionEnabled = false
        EarnPointsScrollView.addSubview(SignUpButton)
        
        let SignUpImageView = UIImageView()
        SignUpImageView.frame = CGRect(x: 0, y: 0, width: SignUpButton.frame.width, height: SignUpButton.frame.height)
        SignUpImageView.image = UIImage(named: "Reward_signup")
        SignUpImageView.contentMode = .scaleAspectFit
        SignUpButton.addSubview(SignUpImageView)
        
        let Acc_LBL = UILabel()
        Acc_LBL.frame = CGRect(x: (4 * x), y: (3 * y), width: AccountView.frame.width - (8 * x), height: (2 * y))
        Acc_LBL.text = "Create an account"
        Acc_LBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        //Acc_LBL.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        Acc_LBL.textAlignment = .center
        AccountView.addSubview(Acc_LBL)
        
     
         let AccPointsViewButton = UIButton()
        AccPointsViewButton.frame = CGRect(x: (2 * x), y: AccountView.frame.maxY - y, width: AccountView.frame.width, height: (2 * y))
        AccPointsViewButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        AccPointsViewButton.setTitle("500 points", for: .normal)
        AccPointsViewButton.setTitleColor(UIColor.white, for: .normal)
        AccPointsViewButton.titleLabel?.font =  UIFont(name: "Avenir Next", size: 1.3 * x)
        AccPointsViewButton.layer.cornerRadius = 10;  // this value vary as per your desire
        AccPointsViewButton.clipsToBounds = true;
        AccPointsViewButton.isUserInteractionEnabled = false
        EarnPointsScrollView.addSubview(AccPointsViewButton)
        
        // Purchase view..
       // let PurchaseView = UIView()
        PurchaseView.frame = CGRect(x: (2 * x), y: AccountView.frame.maxY + (5 * y), width: EarnPointsScrollView.frame.width - (4 * x), height: (7 * y))
        PurchaseView.layer.cornerRadius = 10
        PurchaseView.layer.borderWidth = 1
        PurchaseView.layer.backgroundColor = UIColor.white.cgColor
        PurchaseView.layer.borderColor = UIColor.lightGray.cgColor
        EarnPointsScrollView.addSubview(PurchaseView)
        
        let OrderButton = UIButton()
        OrderButton.frame = CGRect(x: (15 * x), y: PurchaseView.frame.minY - (2 * y), width: (5 * x), height: (4 * y))
        OrderButton.backgroundColor = UIColor.white
        OrderButton.layer.cornerRadius = 10;  // this value vary as per your desire
        OrderButton.clipsToBounds = true;
        OrderButton.isUserInteractionEnabled = false
        EarnPointsScrollView.addSubview(OrderButton)
        
        let OrderImageView = UIImageView()
        OrderImageView.frame = CGRect(x: 0, y: 0, width: OrderButton.frame.width, height: OrderButton.frame.height)
        OrderImageView.image = UIImage(named: "Reward_Order")
        OrderImageView.contentMode = .scaleAspectFit
        OrderButton.addSubview(OrderImageView)
        
        let Purc_LBL = UILabel()
        Purc_LBL.frame = CGRect(x: (4 * x), y: (3 * y), width: PurchaseView.frame.width - (8 * x), height: (2 * y))
        Purc_LBL.text = "Make a purchase"
        Purc_LBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        //Acc_LBL.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        Purc_LBL.textAlignment = .center
        PurchaseView.addSubview(Purc_LBL)
        
        
        let PurcPointsViewButton = UIButton()
        PurcPointsViewButton.frame = CGRect(x: (2 * x), y: PurchaseView.frame.maxY - y, width: PurchaseView.frame.width, height: (2 * y))
        PurcPointsViewButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        PurcPointsViewButton.setTitle("250 points", for: .normal)
        PurcPointsViewButton.setTitleColor(UIColor.white, for: .normal)
        PurcPointsViewButton.titleLabel?.font =  UIFont(name: "Avenir Next", size: 1.3 * x)
        PurcPointsViewButton.layer.cornerRadius = 10;  // this value vary as per your desire
        PurcPointsViewButton.clipsToBounds = true;
        PurcPointsViewButton.isUserInteractionEnabled = false
        EarnPointsScrollView.addSubview(PurcPointsViewButton)
        
        // Share Link view..
        //let ShareView = UIView()
        ShareView.frame = CGRect(x: (2 * x), y: PurchaseView.frame.maxY + (5 * y), width: EarnPointsScrollView.frame.width - (4 * x), height: (7 * y))
        ShareView.layer.cornerRadius = 10
        ShareView.layer.borderWidth = 1
        ShareView.layer.backgroundColor = UIColor.white.cgColor
        ShareView.layer.borderColor = UIColor.lightGray.cgColor
        EarnPointsScrollView.addSubview(ShareView)
        
        let ShareButton = UIButton()
        ShareButton.frame = CGRect(x: (15 * x), y: ShareView.frame.minY - (2 * y), width: (5 * x), height: (4 * y))
        ShareButton.backgroundColor = UIColor.white
        ShareButton.layer.cornerRadius = 10;  // this value vary as per your desire
        ShareButton.clipsToBounds = true;
        ShareButton.isUserInteractionEnabled = false
        EarnPointsScrollView.addSubview(ShareButton)
        
        let ShareImageView = UIImageView()
        ShareImageView.frame = CGRect(x: 0, y: 0, width: ShareButton.frame.width, height: ShareButton.frame.height)
        ShareImageView.image = UIImage(named: "Reward_share")
        ShareImageView.contentMode = .scaleAspectFit
        ShareButton.addSubview(ShareImageView)
        
        let Share_LBL = UILabel()
        Share_LBL.frame = CGRect(x: (2 * x), y: (3 * y), width: ShareView.frame.width - (4 * x), height: (2 * y))
        Share_LBL.text = "Share a Mzyoon link(once a month)"
        Share_LBL.font = UIFont(name: "Avenir Next", size: 1.3 * x)
        //Acc_LBL.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        Share_LBL.textAlignment = .center
        ShareView.addSubview(Share_LBL)
        
        let SharePointsViewButton = UIButton()
        SharePointsViewButton.frame = CGRect(x: (2 * x), y: ShareView.frame.maxY - y, width: ShareView.frame.width, height: (2 * y))
        SharePointsViewButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        SharePointsViewButton.setTitle("100 points", for: .normal)
        SharePointsViewButton.setTitleColor(UIColor.white, for: .normal)
        SharePointsViewButton.titleLabel?.font =  UIFont(name: "Avenir Next", size: 1.3 * x)
        SharePointsViewButton.layer.cornerRadius = 10;  // this value vary as per your desire
        SharePointsViewButton.clipsToBounds = true;
        SharePointsViewButton.isUserInteractionEnabled = false
        EarnPointsScrollView.addSubview(SharePointsViewButton)
        
        EarnPointsScrollView.contentSize.height = ShareView.frame.maxY + (3 * y)
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
