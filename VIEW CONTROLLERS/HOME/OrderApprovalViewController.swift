//
//  OrderApprovalViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 13/12/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class OrderApprovalViewController: CommonViewController
{
    let PricingButton = UIButton()
    let DeliveryDetailsButton = UIButton()
    let ProceedToPayButton = UIButton()

    override func viewDidLoad()
    {
       // print("SUCCESS")
        
         navigationBar.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of seconds
            // Your code with delay
       
            self.orderApprovalContent()
        }
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func orderApprovalContent()
    {
        self.stopActivity()
        
        let orderApprovalNavigationBar = UIView()
        orderApprovalNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        orderApprovalNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(orderApprovalNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 4
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        orderApprovalNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: orderApprovalNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "ORDER APPROVAL"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        orderApprovalNavigationBar.addSubview(navigationTitle)
        
        let DressDetView = UIView()
        DressDetView.frame = CGRect(x: x + 15 , y: orderApprovalNavigationBar.frame.maxY + y, width: view.frame.width - (5 * x), height: (12 * y))
        DressDetView.layer.cornerRadius = 5
        DressDetView.layer.borderWidth = 1
        DressDetView.layer.backgroundColor = UIColor.orange.cgColor
        DressDetView.layer.borderColor = UIColor.black.cgColor
        view.addSubview(DressDetView)
        
        let DressImageView = UIImageView()
        DressImageView.frame = CGRect(x: x, y: y, width: (10 * x), height:(10 * y))
        DressImageView.backgroundColor = UIColor.gray
        DressDetView.addSubview(DressImageView)
        
        let DressTypeLabel = UILabel()
        DressTypeLabel.frame = CGRect(x: DressImageView.frame.maxX + x, y: 5, width: (20 * x), height: (2 * y))
        DressTypeLabel.text = "Men's Mandarin Suits "
        DressTypeLabel.textColor = UIColor.white
    //  DressTypeLabel.backgroundColor = UIColor.gray
        DressTypeLabel.textAlignment = .left
        DressTypeLabel.font = DressTypeLabel.font.withSize(16)
        DressDetView.addSubview(DressTypeLabel)
        
        
        let ColorLabel = UILabel()
        ColorLabel.frame = CGRect(x: DressImageView.frame.maxX + x, y: DressTypeLabel.frame.minY + (2.5 * y), width: (6 * x), height: (2 * y))
        ColorLabel.text = "Color  : "
        ColorLabel.textColor = UIColor.white
    //  ColorLabel.backgroundColor = UIColor.gray
        ColorLabel.textAlignment = .left
        ColorLabel.font = ColorLabel.font.withSize(14)
        DressDetView.addSubview(ColorLabel)
        
        let ColorTypeLabel = UILabel()
        ColorTypeLabel.frame = CGRect(x: ColorLabel.frame.maxX , y: DressTypeLabel.frame.minY + (2.5 * y), width: (8 * x), height: (2 * y))
        ColorTypeLabel.text = "Grey"
       // ColorTypeLabel.backgroundColor = UIColor.gray
        ColorTypeLabel.textColor = UIColor.white
        ColorTypeLabel.textAlignment = .left
        ColorTypeLabel.font = ColorLabel.font.withSize(14)
        DressDetView.addSubview(ColorTypeLabel)
        
        
        let QtyLabel = UILabel()
        QtyLabel.frame = CGRect(x: DressImageView.frame.maxX + x, y: ColorLabel.frame.minY + (2.5 * y), width: (8 * x), height: (2 * y))
        QtyLabel.text = "Qty     : "
        QtyLabel.textColor = UIColor.white
        QtyLabel.textAlignment = .left
        QtyLabel.font = ColorLabel.font.withSize(14)
        DressDetView.addSubview(QtyLabel)
        
        
        let QtyNumTF = UITextField()
        QtyNumTF.frame = CGRect(x: QtyLabel.frame.maxX - (2 * x), y: ColorTypeLabel.frame.minY + (2.5 * y), width: (4 * x), height: (2 * y))
        QtyNumTF.backgroundColor = UIColor.white
        QtyNumTF.text = "1"
        QtyNumTF.textColor = UIColor.black
        QtyNumTF.textAlignment = .center
        QtyNumTF.font = ColorLabel.font.withSize(14)
        DressDetView.addSubview(QtyNumTF)
        
        PricingButton.frame = CGRect(x: 0, y: DressDetView.frame.maxY + y, width: ((view.frame.width / 2) - 1), height: 40)
        PricingButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        PricingButton.setTitle("PRICE DETAILS", for: .normal)
        PricingButton.setTitleColor(UIColor.white, for: .normal)
        PricingButton.tag = 0
        PricingButton.addTarget(self, action: #selector(self.selectionViewButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(PricingButton)
        
        DeliveryDetailsButton.frame = CGRect(x: PricingButton.frame.maxX + 1, y: DressDetView.frame.maxY + y, width: view.frame.width / 2, height: 40)
        DeliveryDetailsButton.backgroundColor = UIColor.lightGray
        DeliveryDetailsButton.setTitle("DELIVERY DETAILS", for: .normal)
        DeliveryDetailsButton.setTitleColor(UIColor.black, for: .normal)
        DeliveryDetailsButton.tag = 1
        DeliveryDetailsButton.addTarget(self, action: #selector(self.selectionViewButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(DeliveryDetailsButton)
        
        DeliveryDetailsButton.backgroundColor = UIColor.lightGray
        DeliveryDetailsButton.setTitleColor(UIColor.black, for: .normal)
        PricingViewContents(isHidden: false)
        DeliveryDetailsViewContents(isHidden: true)
       
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func selectionViewButtonAction(sender : UIButton)
    {
        if sender.tag == 0
        {
            DeliveryDetailsButton.backgroundColor = UIColor.lightGray
            DeliveryDetailsButton.setTitleColor(UIColor.black, for: .normal)
            PricingViewContents(isHidden: false)
            DeliveryDetailsViewContents(isHidden: true)
        }
        else if sender.tag == 1
        {
            PricingButton.backgroundColor = UIColor.lightGray
            PricingButton.setTitleColor(UIColor.black, for: .normal)
            PricingViewContents(isHidden: true)
            DeliveryDetailsViewContents(isHidden: false)
        }
        
        sender.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        sender.setTitleColor(UIColor.white, for: .normal)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func PricingViewContents(isHidden : Bool)
    {
        
       
    }
    
    func DeliveryDetailsViewContents(isHidden : Bool)
    {
        
        let deliveryDetailsView = UIView()
        deliveryDetailsView.frame = CGRect(x: (4 * x), y: DeliveryDetailsButton.frame.maxY + y , width: view.frame.width - (6 * x), height: (40 * x))
        deliveryDetailsView.backgroundColor = UIColor.white
        view.addSubview(deliveryDetailsView)
        
      //   var y1:CGFloat = y
        
        // AppointmentView :-
            let AppointmentsView = UIView()
            AppointmentsView.frame = CGRect(x: x, y: 10, width: deliveryDetailsView.frame.width - (2 * x), height: (6 * y))
            AppointmentsView.layer.cornerRadius = 10
            AppointmentsView.layer.masksToBounds = true
            AppointmentsView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        
          //  DeliveryDetLabels.text = dressTypeArray[i]
           // AppointmentViewLabels.textColor = UIColor.white
           // AppointmentViewLabels.textAlignment = .left
           // AppointmentViewLabels.font = AppointmentViewLabels.font.withSize(14)
            deliveryDetailsView.addSubview(AppointmentsView)
            
    //        y1 = AppointmentsView.frame.maxY + (y / 2)
        
        // Label :-
           let AppointmentsLabels = UILabel()
           AppointmentsLabels.frame = CGRect(x: 5, y: 10 , width: 15 * x, height: (3 * y))
         //  AppointmentsLabels.backgroundColor = UIColor.gray
           AppointmentsLabels.text = "Appointments"
           AppointmentsLabels.textColor = UIColor.white
           AppointmentsLabels.textAlignment = .left
           AppointmentsLabels.font = AppointmentsLabels.font.withSize(14)
           AppointmentsView.addSubview(AppointmentsLabels)
        
        // DeliveryColonLabel :-
        let AppointColonLabel = UILabel()
        AppointColonLabel.frame = CGRect(x: AppointmentsLabels.frame.maxX, y: AppointmentsView.frame.minY , width: 2 * x, height: (2 * y))
       // AppointColonLabel = UIColor.gray
        AppointColonLabel.text = "-"
        AppointColonLabel.textColor = UIColor.white
        AppointColonLabel.textAlignment = .center
        AppointColonLabel.font = AppointColonLabel.font.withSize(14)
        AppointmentsView.addSubview(AppointColonLabel)
        
        // DeliveryTypeView :-
        let DeliveryTypeView = UIView()
        DeliveryTypeView.frame = CGRect(x: x, y: 25 + (6 * y), width: AppointmentsView.frame.width , height: (5 * y))
        DeliveryTypeView.layer.cornerRadius = 10
        DeliveryTypeView.layer.masksToBounds = true
        DeliveryTypeView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        deliveryDetailsView.addSubview(DeliveryTypeView)
       
        // Label :-
        let DeliveryTypeLabel = UILabel()
        DeliveryTypeLabel.frame = CGRect(x: 5, y: 6 , width: 15 * x, height: (3 * y))
        DeliveryTypeLabel.backgroundColor = UIColor.gray
        DeliveryTypeLabel.text = "Delivery Type"
        DeliveryTypeLabel.textColor = UIColor.white
        DeliveryTypeLabel.textAlignment = .left
        DeliveryTypeLabel.font = DeliveryTypeLabel.font.withSize(14)
        DeliveryTypeView.addSubview(DeliveryTypeLabel)
        
        // DeliveryColonLabel :-
        let DeliveryColonLabel = UILabel()
        DeliveryColonLabel.frame = CGRect(x: DeliveryTypeLabel.frame.minX, y: DeliveryTypeView.frame.minY , width: 2 * x, height: (2 * y))
        DeliveryColonLabel.backgroundColor = UIColor.gray
        DeliveryColonLabel.text = "-"
        DeliveryColonLabel.textColor = UIColor.white
        DeliveryColonLabel.textAlignment = .center
        DeliveryColonLabel.font = DeliveryColonLabel.font.withSize(14)
        DeliveryTypeView.addSubview(DeliveryColonLabel)
        
        
        
        // StichTimeView :-
        let StichTimeView = UIView()
        StichTimeView.frame = CGRect(x: x, y: 105 + (6 * y), width: DeliveryTypeView.frame.width , height: (6 * y))
        StichTimeView.layer.cornerRadius = 10
        StichTimeView.layer.masksToBounds = true
        StichTimeView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        deliveryDetailsView.addSubview(StichTimeView)
        
        
        // Label :-
        let StichTimeLabel = UILabel()
        StichTimeLabel.frame = CGRect(x: 5, y: 8 , width: 15 * x, height: (3 * y))
        StichTimeLabel.backgroundColor = UIColor.gray
        StichTimeLabel.text = "Stiching time required for stiches"
        StichTimeLabel.lineBreakMode = .byWordWrapping
        StichTimeLabel.numberOfLines = 2
        StichTimeLabel.textColor = UIColor.white
        StichTimeLabel.textAlignment = .left
        StichTimeLabel.font = StichTimeLabel.font.withSize(14)
        StichTimeView.addSubview(StichTimeLabel)
        
        
        // StichColon Label :-
        let StichColonLabel = UILabel()
        StichColonLabel.frame = CGRect(x: StichTimeLabel.frame.maxX, y: StichTimeView.frame.minY , width: 2 * x, height: (2 * y))
        StichColonLabel.backgroundColor = UIColor.gray
        StichColonLabel.text = "-"
        StichColonLabel.textColor = UIColor.white
        StichColonLabel.textAlignment = .center
        StichColonLabel.font = StichColonLabel.font.withSize(12)
        StichTimeView.addSubview(StichColonLabel)
       
        
        // DeliveryDateView :-
        let DeliveryDateView = UIView()
        DeliveryDateView.frame = CGRect(x: x, y: 195 + (6 * y), width: StichTimeView.frame.width , height: (10 * y))
        DeliveryDateView.layer.cornerRadius = 10
        DeliveryDateView.layer.masksToBounds = true
        DeliveryDateView.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        deliveryDetailsView.addSubview(DeliveryDateView)
 
        // Label :-
        let DeliveryDateLabel = UILabel()
        DeliveryDateLabel.frame = CGRect(x: 5, y: 25 , width: 15 * x, height: (3 * y))
        DeliveryDateLabel.backgroundColor = UIColor.gray
        DeliveryDateLabel.text = "Approximate delivery date"
        DeliveryDateLabel.lineBreakMode = .byWordWrapping
        DeliveryDateLabel.numberOfLines = 2
        DeliveryDateLabel.textColor = UIColor.white
        DeliveryDateLabel.textAlignment = .left
        DeliveryDateLabel.font = DeliveryDateLabel.font.withSize(14)
        DeliveryDateView.addSubview(DeliveryDateLabel)
        
        // DateColon Label :-
        let DateColonLabel = UILabel()
        DateColonLabel.frame = CGRect(x: DeliveryDateLabel.frame.maxX, y: DeliveryDateView.frame.minY , width: 2 * x, height: (2 * y))
         DateColonLabel.backgroundColor = UIColor.gray
        DateColonLabel.text = "-"
        DateColonLabel.textColor = UIColor.white
        DateColonLabel.textAlignment = .center
        DateColonLabel.font = DateColonLabel.font.withSize(12)
        DeliveryDateView.addSubview(DateColonLabel)
        
        // Pay Button :-
        ProceedToPayButton.frame = CGRect(x: 0, y: deliveryDetailsView.frame.maxY + y, width: view.frame.width , height: 40)
        ProceedToPayButton.backgroundColor = UIColor.orange
        ProceedToPayButton.setTitle("PROCEED TO PAY", for: .normal)
        ProceedToPayButton.setTitleColor(UIColor.white, for: .normal)
        ProceedToPayButton.addTarget(self, action: #selector(self.ProccedToPayButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(ProceedToPayButton)
        
    }
    
    @objc func ProccedToPayButtonAction(sender : UIButton)
    {
        print("Redirect To Next Page.. !")
    }

}
