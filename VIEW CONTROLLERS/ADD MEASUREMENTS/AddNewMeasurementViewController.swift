//
//  AddNewMeasurementViewController.swift
//  Mzyoon
//
//  Created by QOL on 15/04/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class AddNewMeasurementViewController: UIViewController
{
    var x = CGFloat()
    var y = CGFloat()
    
    let backgroundImage = UIImageView()
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()
    
    override func viewDidLoad()
    {
        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
        
        selfScreenNavigationContents()
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func selfScreenNavigationContents()
    {
        backgroundImage.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        backgroundImage.image = UIImage(named: "background")
        view.addSubview(backgroundImage)
        
        selfScreenNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        selfScreenNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(selfScreenNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 1
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        selfScreenNavigationBar.addSubview(backButton)
        
        selfScreenNavigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: selfScreenNavigationBar.frame.width, height: (3 * y))
        selfScreenNavigationTitle.text = "Measurement List"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationTitle.font = selfScreenNavigationTitle.font.withSize(2 * x)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        let measurementScrollView = UIScrollView()
        measurementScrollView.frame = CGRect(x: x, y: selfScreenNavigationBar.frame.maxY + y, width: view.frame.width - (2 * x), height: view.frame.height - (selfScreenNavigationBar.frame.maxY + (7 * y)))
        view.addSubview(measurementScrollView)
        
        
        var y2:CGFloat = 0
        
        for i in 0..<15
        {
            let measurementButton = UIButton()
            measurementButton.frame = CGRect(x: 0, y: y2, width: measurementScrollView.frame.width, height: (8 * x))
            measurementButton.backgroundColor = UIColor.white
            measurementButton.layer.cornerRadius = 10
            measurementButton.tag = i
            measurementButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
            measurementScrollView.addSubview(measurementButton)
            
            let dressImageView = UIImageView()
            dressImageView.frame = CGRect(x: x, y: y, width: (6 * y), height: (measurementButton.frame.height - (2 * y)))
            dressImageView.backgroundColor = UIColor.blue
            dressImageView.layer.cornerRadius = dressImageView.frame.height / 2
            measurementButton.addSubview(dressImageView)
            
            let userNameLabel = UILabel()
            userNameLabel.frame = CGRect(x: dressImageView.frame.maxX + x, y: y, width: measurementButton.frame.width - (10 * x), height: (3 * y))
            userNameLabel.text = "Testing Name"
            userNameLabel.textColor = UIColor.blue
            userNameLabel.textAlignment = .left
            userNameLabel.font = UIFont(name: "Avenir-Regular", size: (2 * x))
            userNameLabel.font = userNameLabel.font.withSize((2 * x))
            measurementButton.addSubview(userNameLabel)
            
            let dressNameLabel = UILabel()
            dressNameLabel.frame = CGRect(x: dressImageView.frame.maxX + x, y: userNameLabel.frame.maxY, width: measurementButton.frame.width - (10 * x), height: (3 * y))
            dressNameLabel.text = "Dress Name"
            dressNameLabel.textColor = UIColor.blue
            dressNameLabel.textAlignment = .left
            dressNameLabel.font = UIFont(name: "Avenir-Regular", size: (2 * x))
            dressNameLabel.font = dressNameLabel.font.withSize((2 * x))
            measurementButton.addSubview(dressNameLabel)
            
            y2 = measurementButton.frame.maxY + y
        }
        
        measurementScrollView.contentSize.height = y2 + (2 * y)
        
        let addNewButton = UIButton()
        addNewButton.frame = CGRect(x: 0, y: view.frame.height - (5 * y), width: view.frame.width, height: (5 * y))
        addNewButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        addNewButton.setTitle("Add new measurements", for: .normal)
        addNewButton.setTitleColor(UIColor.white, for: .normal)
        view.addSubview(addNewButton)
    }
    
    @objc func measurementButtonAction(sender : UIButton)
    {
        Variables.sharedManager.measurementTag = 1
        let genderScreen = GenderViewController()
        self.navigationController?.pushViewController(genderScreen, animated: true)
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
