//
//  AppointmentViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 04/01/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class AppointmentViewController: CommonViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        AppointmentContent()
    }
    
    func AppointmentContent()
    {
        self.stopActivity()
        
        let AppointmentNavigationBar = UIView()
        AppointmentNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        AppointmentNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(AppointmentNavigationBar)
        
        let backButton = UIButton()
         backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
         backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
         backButton.tag = 4
         backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
         AppointmentNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: AppointmentNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "APPOINTMENT"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        AppointmentNavigationBar.addSubview(navigationTitle)
        
        AppointmentTypeView()
    }
    
    func AppointmentTypeView()
    {
        let orderTypeLabel = UILabel()
        orderTypeLabel.frame = CGRect(x: ((view.frame.width - (12 * x)) / 2), y: (8 * y), width: (12 * x), height: (3 * y))
        orderTypeLabel.backgroundColor = UIColor.white
        orderTypeLabel.text = "ORDER TYPE"
        orderTypeLabel.layer.borderColor = UIColor.lightGray.cgColor
        orderTypeLabel.layer.borderWidth = 1.0
        orderTypeLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        orderTypeLabel.textAlignment = .center
        orderTypeLabel.font = UIFont(name: "Avenir Next", size: 16)
        view.addSubview(orderTypeLabel)
        
        
       let AppointmentStatusView = UIView()
        AppointmentStatusView.frame = CGRect(x: ((view.frame.width - (12 * x)) / 2), y: (8 * y), width: (15 * x), height: (3 * y))
        
        
    }

    
    @objc func otpBackButtonAction(sender : UIButton)
    {
     self.navigationController?.popViewController(animated: true)
    }
 
}
