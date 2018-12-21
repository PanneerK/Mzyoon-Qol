//
//  OrderDetailsViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 20/12/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class OrderDetailsViewController: CommonViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        orderDetailsContent()
    }
    
    func orderDetailsContent()
    {
        self.stopActivity()
        
        let orderDetailsNavigationBar = UIView()
        orderDetailsNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        orderDetailsNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(orderDetailsNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 4
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        orderDetailsNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: orderDetailsNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "ORDER DETAILS"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        orderDetailsNavigationBar.addSubview(navigationTitle)
        
       // Scrollview...
      let OrderDetailsScrollView = UIScrollView()
        OrderDetailsScrollView.frame = CGRect(x: 0, y: orderDetailsNavigationBar.frame.maxY + y, width: view.frame.width, height: view.frame.height - (13 * y))
        OrderDetailsScrollView.backgroundColor = UIColor.clear
        OrderDetailsScrollView.contentSize.height = (1.75 * view.frame.height)
        view.addSubview(OrderDetailsScrollView)
        
        // OrderId View..
        let orderIdView = UIView()
        orderIdView.frame = CGRect(x: (3 * x), y: y, width: OrderDetailsScrollView.frame.width - (6 * x), height: (10 * y))
        orderIdView.backgroundColor = UIColor.white
        OrderDetailsScrollView.addSubview(orderIdView)
        
        // Label
        let orderIdLabel = UILabel()
        orderIdLabel.frame = CGRect(x: x, y: orderIdView.frame.minY, width: (10 * x), height: (2 * x))
        orderIdLabel.text = "ORDER ID : "
        orderIdLabel.font = UIFont(name: "Avenir Next", size: 16)
        orderIdLabel.textColor = UIColor.black
        orderIdView.addSubview(orderIdLabel)
        
        let orderIdNumLabel = UILabel()
        orderIdNumLabel.frame = CGRect(x: orderIdLabel.frame.maxX, y: orderIdView.frame.minY, width: (15 * x), height: (2 * x))
        orderIdNumLabel.text = "#60123456"
        orderIdNumLabel.font = UIFont(name: "Avenir Next", size: 16)
         orderIdNumLabel.textColor = UIColor.black
        orderIdView.addSubview(orderIdNumLabel)
        
       // OrderDetailsScrollView.contentSize.height = y1 + (20 * y)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
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
