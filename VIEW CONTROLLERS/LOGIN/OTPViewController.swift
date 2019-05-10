//
//  OTPViewController.swift
//  Mzyoon
//
//  Created by QOL on 10/05/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController, CodeInputViewDelegate
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
        
        let otpNavigationBar = UIView()
        otpNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (15 * y))
        otpNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(otpNavigationBar)
        
        let otpBackButton = UIButton()
        otpBackButton.frame = CGRect(x: (2 * x), y: (5 * y), width: (4 * x), height: (2 * y))
        otpBackButton.backgroundColor = UIColor.white
        //        otpNavigationBar.addSubview(otpBackButton)
        
        let otpImageView = UIImageView()
        otpImageView.frame = CGRect(x: ((otpNavigationBar.frame.width - (10 * x)) / 2), y: otpNavigationBar.frame.height - (5 * x), width: (10 * x), height: (10 * x))
        otpImageView.layer.cornerRadius = otpImageView.frame.height / 2
        otpImageView.image = UIImage(named: "otpMessage")
        otpNavigationBar.addSubview(otpImageView)
        
        let otpEnterLabel = UILabel()
        otpEnterLabel.frame = CGRect(x: 0, y: otpImageView.frame.maxY + y, width: view.frame.width, height: (2 * y))
        otpEnterLabel.text = "Verify your phone number"
        otpEnterLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        otpEnterLabel.textAlignment = .center
        otpEnterLabel.font = UIFont(name: "Avenir-Regular", size: (x))
        otpEnterLabel.font = otpEnterLabel.font.withSize(1.5 * x)
        view.addSubview(otpEnterLabel)
        
        let OTPView = CodeInputView()
        OTPView.frame = CGRect(x: 0, y: otpEnterLabel.frame.maxY + (2 * y), width: view.frame.width, height: (9 * y))
        OTPView.delegate = self
        view.addSubview(OTPView)
        
        OTPView.becomeFirstResponder()
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func codeInputView(_ codeInputView: CodeInputView, didFinishWithCode code: String) {
        let title = (code == "123456" ? "Correct!" : "Wrong!")
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in codeInputView.clear() })
        present(alert, animated: true)
        
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
