//
//  OrderSummaryViewController.swift
//  Mzyoon
//
//  Created by QOL on 19/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class OrderSummaryViewController: CommonViewController
{

    let randomInt = Int.random(in: 10265..<10365)

    
    override func viewDidLoad()
    {
        navigationBar.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of seconds
            // Your code with delay
            self.orderSummaryContent()
        }
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func orderSummaryContent()
    {
        self.stopActivity()
        let orderSummaryNavigationBar = UIView()
        orderSummaryNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        orderSummaryNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(orderSummaryNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 4
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        orderSummaryNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: orderSummaryNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "ORDER SUMMARY"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        orderSummaryNavigationBar.addSubview(navigationTitle)
        
        let orderSummaryScrollView = UIScrollView()
        orderSummaryScrollView.frame = CGRect(x: 0, y: orderSummaryNavigationBar.frame.maxY + y, width: view.frame.width, height: view.frame.height - (13 * y))
        orderSummaryScrollView.backgroundColor = UIColor.clear
        orderSummaryScrollView.contentSize.height = (1.75 * view.frame.height)
        view.addSubview(orderSummaryScrollView)
        
        let dressTypeHeadingLabel = UILabel()
        dressTypeHeadingLabel.frame = CGRect(x: (3 * x), y: y, width: view.frame.width, height: (3 * y))
        dressTypeHeadingLabel.text = "DRESS TYPE"
        dressTypeHeadingLabel.textColor = UIColor.black
        dressTypeHeadingLabel.textAlignment = .left
        dressTypeHeadingLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        orderSummaryScrollView.addSubview(dressTypeHeadingLabel)
        
        let dressTypeView = UIView()
        dressTypeView.frame = CGRect(x: (3 * x), y: dressTypeHeadingLabel.frame.maxY, width: orderSummaryScrollView.frame.width - (6 * x), height: (24 * x))
        dressTypeView.backgroundColor = UIColor.white
        orderSummaryScrollView.addSubview(dressTypeView)
        
        let dressTypeArray = ["Gender - Men", "Seasonal - All", "Place of Industry - All", "Brand - All", "Material Type - Cotton"]
        var y1:CGFloat = y
        
        for i in 0..<5
        {
            let dressTypeLabels = UILabel()
            dressTypeLabels.frame = CGRect(x: x, y: y1, width: dressTypeView.frame.width - (2 * x), height: (4 * y))
            dressTypeLabels.layer.cornerRadius = 10
            dressTypeLabels.layer.masksToBounds = true
            dressTypeLabels.backgroundColor = UIColor.blue
            dressTypeLabels.text = dressTypeArray[i]
            dressTypeLabels.textColor = UIColor.white
            dressTypeLabels.textAlignment = .center
            dressTypeView.addSubview(dressTypeLabels)
            
            y1 = dressTypeLabels.frame.maxY + (y / 2)
        }
        
        
        let customizationHeadingLabel = UILabel()
        customizationHeadingLabel.frame = CGRect(x: (3 * x), y: dressTypeView.frame.maxY + y, width: view.frame.width, height: (3 * y))
        customizationHeadingLabel.text = "CUSTOMIZATION"
        customizationHeadingLabel.textColor = UIColor.black
        customizationHeadingLabel.textAlignment = .left
        customizationHeadingLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        orderSummaryScrollView.addSubview(customizationHeadingLabel)
        
        let customizationView = UIView()
        customizationView.frame = CGRect(x: (3 * x), y: customizationHeadingLabel.frame.maxY, width: orderSummaryScrollView.frame.width - (6 * x), height: (19.5 * x))
        customizationView.backgroundColor = UIColor.white
        orderSummaryScrollView.addSubview(customizationView)
        
        let customizationArray = ["Lapels - Notch", "Buttons - Button 1", "Pockets - Pocket 1", "Vents - vent 1"]
        var y2:CGFloat = y
        
        for i in 0..<4
        {
            let customizationLabels = UILabel()
            customizationLabels.frame = CGRect(x: x, y: y2, width: dressTypeView.frame.width - (2 * x), height: (4 * y))
            customizationLabels.layer.cornerRadius = 10
            customizationLabels.layer.masksToBounds = true
            customizationLabels.backgroundColor = UIColor.blue
            customizationLabels.text = customizationArray[i]
            customizationLabels.textColor = UIColor.white
            customizationLabels.textAlignment = .center
            customizationView.addSubview(customizationLabels)
            
            y2 = customizationLabels.frame.maxY + (y / 2)
        }
        
        let premiumServicesHeadingLabel = UILabel()
        premiumServicesHeadingLabel.frame = CGRect(x: (3 * x), y: customizationView.frame.maxY + y, width: view.frame.width, height: (3 * y))
        premiumServicesHeadingLabel.text = "PREMIUM SERVICES"
        premiumServicesHeadingLabel.textColor = UIColor.black
        premiumServicesHeadingLabel.textAlignment = .left
        premiumServicesHeadingLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        orderSummaryScrollView.addSubview(premiumServicesHeadingLabel)
        
        let premiumServicesView = UIView()
        premiumServicesView.frame = CGRect(x: (3 * x), y: premiumServicesHeadingLabel.frame.maxY, width: orderSummaryScrollView.frame.width - (6 * x), height: (24 * x))
        premiumServicesView.backgroundColor = UIColor.white
        orderSummaryScrollView.addSubview(premiumServicesView)
        
        let premiumArray = ["Measurement + Service - 50.00 AED", "Material Delivery - 70.00 AED", "Urgent Stitches - 150.00 AED", "Additional Design - 20.00 AED", "Special Delivery - 30.00 AED"]
        var y3:CGFloat = y
        
        for i in 0..<5
        {
            let premiumServicesLabels = UILabel()
            premiumServicesLabels.frame = CGRect(x: x, y: y3, width: dressTypeView.frame.width - (2 * x), height: (4 * y))
            premiumServicesLabels.layer.cornerRadius = 10
            premiumServicesLabels.layer.masksToBounds = true
            premiumServicesLabels.backgroundColor = UIColor.blue
            premiumServicesLabels.text = premiumArray[i]
            premiumServicesLabels.textColor = UIColor.white
            premiumServicesLabels.textAlignment = .center
            premiumServicesView.addSubview(premiumServicesLabels)
            
            y3 = premiumServicesLabels.frame.maxY + (y / 2)
        }
        
        let noteView = UIView()
        noteView.frame = CGRect(x: (3 * x), y: premiumServicesView.frame.maxY, width: orderSummaryScrollView.frame.width - (6 * x), height: (5 * x))
        noteView.backgroundColor = UIColor.orange
        orderSummaryScrollView.addSubview(noteView)
        
        let noteLabel = UILabel()
        noteLabel.frame = CGRect(x: x, y: 0, width: noteView.frame.width - (2 * x), height: (4 * y))
        noteLabel.text = "NOTE : The price, services and courier will add to order total amount"
        noteLabel.textAlignment = .center
        noteLabel.textColor = UIColor.white
        noteLabel.font = noteLabel.font.withSize(15)
        noteLabel.numberOfLines = 2
        noteView.addSubview(noteLabel)
        
        
        let tailorListHeadingLabel = UILabel()
        tailorListHeadingLabel.frame = CGRect(x: (3 * x), y: noteView.frame.maxY + y, width: view.frame.width, height: (3 * y))
        tailorListHeadingLabel.text = "TOTAL NUMBER OF TAILORS"
        tailorListHeadingLabel.textColor = UIColor.black
        tailorListHeadingLabel.textAlignment = .left
        tailorListHeadingLabel.font = UIFont(name: "Avenir-Regular", size: 10)
        orderSummaryScrollView.addSubview(tailorListHeadingLabel)
        
        let tailorView = UIView()
        tailorView.frame = CGRect(x: (3 * x), y: tailorListHeadingLabel.frame.maxY, width: orderSummaryScrollView.frame.width - (6 * x), height: (10.5 * x))
        tailorView.backgroundColor = UIColor.white
        orderSummaryScrollView.addSubview(tailorView)
        
        var y4:CGFloat = y
        
        let tailorArray = ["Noorul", "Ameen"]
        
        for i in 0..<2
        {
            let tailorLabels = UILabel()
            tailorLabels.frame = CGRect(x: x, y: y4, width: dressTypeView.frame.width - (2 * x), height: (4 * y))
            tailorLabels.layer.cornerRadius = 10
            tailorLabels.layer.masksToBounds = true
            tailorLabels.backgroundColor = UIColor.blue
            tailorLabels.text = "Tailor - \(i) - \(tailorArray[i])"
            tailorLabels.textColor = UIColor.white
            tailorLabels.textAlignment = .center
            tailorView.addSubview(tailorLabels)
            
            y4 = tailorLabels.frame.maxY + (y / 2)
        }
        
        
        let submitButton = UIButton()
        submitButton.frame = CGRect(x: orderSummaryScrollView.frame.width - (13 * x), y: tailorView.frame.maxY + (2 * y), width: (10 * x), height: (4 * y))
        submitButton.backgroundColor = UIColor.blue
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.addTarget(self, action: #selector(self.submitButtonAction(sender:)), for: .touchUpInside)
        orderSummaryScrollView.addSubview(submitButton)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func submitButtonAction(sender : UIButton)
    {
        let alert = UIAlertController(title: "Oredered Placed Successfully", message: "Order Id = \(randomInt)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
