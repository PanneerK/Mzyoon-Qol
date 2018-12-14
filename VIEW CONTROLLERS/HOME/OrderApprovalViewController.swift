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
        DressTypeLabel.frame = CGRect(x: DressImageView.frame.maxX + x, y: 0, width: (30 * x), height: (4 * y))
        DressTypeLabel.text = "Men's Mandarin Suits "
        DressTypeLabel.textColor = UIColor.white
        DressTypeLabel.textAlignment = .left
        DressTypeLabel.font = DressTypeLabel.font.withSize(16)
        DressDetView.addSubview(DressTypeLabel)
        
        
        let ColorLabel = UILabel()
        ColorLabel.frame = CGRect(x: DressImageView.frame.maxX + x, y: DressTypeLabel.frame.minY + (2.5 * y), width: (8 * x), height: (4 * y))
        ColorLabel.text = "Color  : "
        ColorLabel.textColor = UIColor.white
        ColorLabel.textAlignment = .left
        ColorLabel.font = ColorLabel.font.withSize(14)
        DressDetView.addSubview(ColorLabel)
        
        let ColorTypeLabel = UILabel()
        ColorTypeLabel.frame = CGRect(x: ColorLabel.frame.maxX - (2 * x), y: DressTypeLabel.frame.minY + (2.5 * y), width: (8 * x), height: (4 * y))
        ColorTypeLabel.text = "Grey"
        ColorTypeLabel.textColor = UIColor.white
        ColorTypeLabel.textAlignment = .left
        ColorTypeLabel.font = ColorLabel.font.withSize(14)
        DressDetView.addSubview(ColorTypeLabel)
        
        
        let QtyLabel = UILabel()
        QtyLabel.frame = CGRect(x: DressImageView.frame.maxX + x, y: ColorLabel.frame.minY + (2.5 * y), width: (8 * x), height: (4 * y))
        QtyLabel.text = "Qty     : "
        QtyLabel.textColor = UIColor.white
        QtyLabel.textAlignment = .left
        QtyLabel.font = ColorLabel.font.withSize(14)
        DressDetView.addSubview(QtyLabel)
        
        
        let QtyNumTF = UITextField()
        QtyNumTF.frame = CGRect(x: QtyLabel.frame.maxX - (2 * x), y: ColorTypeLabel.frame.minY + (2.5 * y), width: (5 * x), height: (4 * y))
        QtyNumTF.text = "1"
        QtyNumTF.textColor = UIColor.white
        QtyNumTF.textAlignment = .left
        QtyNumTF.font = ColorLabel.font.withSize(14)
        DressDetView.addSubview(QtyNumTF)
        
        PricingButton.frame = CGRect(x: 0, y: DressDetView.frame.maxY + y, width: ((view.frame.width / 2) - 1), height: 50)
        PricingButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        PricingButton.setTitle("PRICE DETAILS", for: .normal)
        PricingButton.setTitleColor(UIColor.white, for: .normal)
        PricingButton.tag = 0
        PricingButton.addTarget(self, action: #selector(self.selectionViewButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(PricingButton)
        
        DeliveryDetailsButton.frame = CGRect(x: PricingButton.frame.maxX + 1, y: DressDetView.frame.maxY + y, width: view.frame.width / 2, height: 50)
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
        deliveryDetailsView.frame = CGRect(x: (4 * x), y: DeliveryDetailsButton.frame.maxY + (2 * y), width: view.frame.width - (6 * x), height: (28 * x))
        deliveryDetailsView.backgroundColor = UIColor.white
        view.addSubview(deliveryDetailsView)
        
     //   let dressTypeArray = ["Appointments  -  Nil", "Delivery Type  -  Urgent", "Stiching time required for stiches  -  4 days", "Approximate Delivery Date  -  24-12-2018 to 28-12-2018"]
        
        var y1:CGFloat = y
        
     
     //   for i in 0..<dressTypeArray.count
      //  {
            let AppointmentViewLabels = UILabel()
            AppointmentViewLabels.frame = CGRect(x: x, y: y1 + 2, width: deliveryDetailsView.frame.width - (2 * x), height: (6 * y))
            AppointmentViewLabels.layer.cornerRadius = 10
            AppointmentViewLabels.layer.masksToBounds = true
            AppointmentViewLabels.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
          //  DeliveryDetLabels.text = dressTypeArray[i]
           // AppointmentViewLabels.textColor = UIColor.white
           // AppointmentViewLabels.textAlignment = .left
           // AppointmentViewLabels.font = AppointmentViewLabels.font.withSize(14)
            deliveryDetailsView.addSubview(AppointmentViewLabels)
            
            y1 = AppointmentViewLabels.frame.maxY + (y / 2)
        
        
           let AppointmentsLabels = UILabel()
           AppointmentsLabels.frame = CGRect(x: 0, y: 0 , width: 20 * x, height: (3 * y))
          // AppointmentsLabels.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
           AppointmentsLabels.text = "Appointments          - "
          AppointmentsLabels.textColor = UIColor.white
          AppointmentsLabels.textAlignment = .left
          AppointmentsLabels.font = AppointmentsLabels.font.withSize(14)
          AppointmentViewLabels.addSubview(AppointmentsLabels)
        
        
      //  }
        
     
        
    }

}
