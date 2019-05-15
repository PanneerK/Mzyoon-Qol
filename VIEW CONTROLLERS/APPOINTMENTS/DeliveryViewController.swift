//
//  DeliveryViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 15/04/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit
import FSCalendar

class DeliveryViewController: CommonViewController,FSCalendarDelegate,FSCalendarDataSource
{

    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()
    var CalendartView = UIView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        DeliveryDetailsView()
    }
    
    func DeliveryDetailsView()
    {
        self.stopActivity()
        activity.stopActivity()
        
        //let RequestListNavigationBar = UIView()
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
        selfScreenNavigationTitle.text = "DELIVERY DATE"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationTitle.font = selfScreenNavigationTitle.font.withSize(2 * x)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        Calendarview()
    }

    func Calendarview()
    {
        
        CalendartView.frame = CGRect(x: (3 * x), y: selfScreenNavigationBar.frame.maxY + (2 * y), width: view.frame.width - (6 * x), height: (20 * y))
        CalendartView.backgroundColor = UIColor.white
        view.addSubview(CalendartView)
        
        
        // In loadView or viewDidLoad
        let calendar = FSCalendar(frame: CGRect(x: (3 * x), y: selfScreenNavigationBar.frame.maxY + (2 * y), width: view.frame.width - (6 * x), height: (20 * y)))
        calendar.dataSource = self
        calendar.delegate = self
        view.addSubview(calendar)
        
        self.CalendartView = calendar
        
        
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
  

}
