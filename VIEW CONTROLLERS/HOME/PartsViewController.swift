//
//  PartsViewController.swift
//  Mzyoon
//
//  Created by QOL on 30/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class PartsViewController: UIViewController, UITextFieldDelegate
{

    var x = CGFloat()
    var y = CGFloat()
    
    
    override func viewDidLoad()
    {
        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
        
        view.backgroundColor = UIColor.white
        
        partsContent()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func partsContent()
    {
        let downArrowImageView = UIImageView()
        downArrowImageView.frame = CGRect(x: (2 * x), y: (7 * y), width: view.frame.width - (4 * x), height: (36.98 * y))
        downArrowImageView.image = UIImage(named: "men")
        view.addSubview(downArrowImageView)
        
        print("WIDTH", downArrowImageView.frame.width)
        
        let addressSwitchButton = UISwitch()
        addressSwitchButton.frame = CGRect(x: view.frame.width - (7 * x), y: downArrowImageView.frame.maxY + y, width: (5 * x), height: (2 * y))
        view.addSubview(addressSwitchButton)
        
        let mobileTextField = UITextField()
        mobileTextField.frame = CGRect(x: (5 * x), y: addressSwitchButton.frame.maxY + (2 * y), width: view.frame.width - (10 * x), height: (4 * y))
        mobileTextField.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        mobileTextField.placeholder = "0.00"
        mobileTextField.textColor = UIColor.white
        mobileTextField.textAlignment = .left
        mobileTextField.font = UIFont(name: "Avenir-Heavy", size: 18)
        mobileTextField.leftViewMode = UITextField.ViewMode.always
        mobileTextField.adjustsFontSizeToFitWidth = true
        mobileTextField.keyboardType = .default
        mobileTextField.clearsOnBeginEditing = true
        mobileTextField.returnKeyType = .done
        mobileTextField.delegate = self
        view.addSubview(mobileTextField)
        
        let cancelButton = UIButton()
        cancelButton.frame = CGRect(x: x, y: mobileTextField.frame.maxY + (3 * y), width: ((view.frame.width / 2) - (2 * x)), height: (4 * y))
        cancelButton.backgroundColor = UIColor(red: 0.2353, green: 0.4, blue: 0.4471, alpha: 1.0)
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
//        cancelButton.addTarget(self, action: #selector(self.cancelButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        let saveButton = UIButton()
        saveButton.frame = CGRect(x: cancelButton.frame.maxX + (2 * x), y: mobileTextField.frame.maxY + (3 * y), width: ((view.frame.width / 2) - (2 * x)), height: (4 * y))
        saveButton.backgroundColor = UIColor(red: 0.2353, green: 0.4, blue: 0.4471, alpha: 1.0)
        saveButton.setTitle("SAVE", for: .normal)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        //        saveButton.addTarget(self, action: #selector(self.cancelButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(saveButton)
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
