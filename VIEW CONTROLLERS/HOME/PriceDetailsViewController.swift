//
//  PriceDetailsViewController.swift
//  Mzyoon
//
//  Created by QOL on 02/05/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class PriceDetailsViewController: CommonViewController,UITextFieldDelegate
{

    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()
    let selfScreenContents = UIView()

    // Order Total..
    let orderTotalLabel = UILabel()
    let getOrderTotalLabel = UILabel()
    
    // Qty..
    let QtyLbl = UILabel()
    let QtyNum_TF = UITextField()
    
    override func viewDidLoad()
    {
        navigationBar.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 1 to desired number of seconds
            // Your code with delay
            self.selfScreenNavigationContents()
        }
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.addDoneButtonOnKeyboard()
        
        print("Tailor ID:",Variables.sharedManager.TailorID);
    }
    
    
    func selfScreenNavigationContents()
    {
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
        selfScreenNavigationTitle.text = "PRICE DETAILS"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationTitle.font = selfScreenNavigationTitle.font.withSize(2 * x)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        selfScreenContents.frame = CGRect(x: x, y: pageBar.frame.maxY, width: view.frame.width - (2 * x), height: view.frame.height - ((5 * y) + selfScreenNavigationBar.frame.maxY + pageBar.frame.height))
        selfScreenContents.backgroundColor = UIColor.clear
        view.addSubview(selfScreenContents)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                pageBar.image = UIImage(named: "ServiceBar")
            }
            else if language == "ar"
            {
                pageBar.image = UIImage(named: "serviceArabicHintImage")
            }
        }
        else
        {
            pageBar.image = UIImage(named: "ServiceBar")
        }
        
        PriceDetailsScreenContents()
    }
    
    func PriceDetailsScreenContents()
    {
        stopActivity()
        activity.stopActivity()
        
        
        QtyLbl.frame = CGRect(x: x, y: y, width: (10 * y), height: (3 * y))
        QtyLbl.text = "QTY"
        QtyLbl.textColor = UIColor.black
        QtyLbl.textAlignment = .left
        QtyLbl.font = UIFont(name: "Avenir-Regular", size: 20)
        QtyLbl.font = QtyLbl.font.withSize(1.5 * x)
        selfScreenContents.addSubview(QtyLbl)
        
        
        QtyNum_TF.frame = CGRect(x: selfScreenContents.frame.width - (8 * x), y: y, width: (7 * x), height: (3 * y))
        QtyNum_TF.backgroundColor = UIColor.white
        QtyNum_TF.layer.borderWidth = 1
        QtyNum_TF.layer.borderColor = UIColor.lightGray.cgColor
        
        QtyNum_TF.text = "1"
        QtyNum_TF.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        QtyNum_TF.textAlignment = .center
        QtyNum_TF.font = UIFont(name: "Avenir-Regular", size: 20)
        QtyNum_TF.font = QtyNum_TF.font!.withSize(1.5 * x)
        QtyNum_TF.adjustsFontSizeToFitWidth = true
        QtyNum_TF.keyboardType = .numberPad
        QtyNum_TF.clearsOnBeginEditing = false
        QtyNum_TF.returnKeyType = .done
        QtyNum_TF.delegate = self
        QtyNum_TF.isUserInteractionEnabled = true
        selfScreenContents.addSubview(QtyNum_TF)
        
        var y1:CGFloat = QtyLbl.frame.maxY + y
        
       // var y1:CGFloat = y
        
        for i in 0..<3
        {
            let chargesLabel = UILabel()
            chargesLabel.frame = CGRect(x: x, y: y1, width: (10 * y), height: (3 * y))
            chargesLabel.text = "TESTING"
            chargesLabel.textColor = UIColor.black
            chargesLabel.textAlignment = .left
            chargesLabel.font = UIFont(name: "Avenir-Regular", size: 20)
            chargesLabel.font = chargesLabel.font.withSize(1.5 * x)
            selfScreenContents.addSubview(chargesLabel)
            
            let getChargesLabel = UILabel()
            getChargesLabel.frame = CGRect(x: selfScreenContents.frame.width - (8 * x), y: y1, width: (7 * x), height: (3 * y))
            getChargesLabel.text = "20 AED"
            getChargesLabel.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            getChargesLabel.textAlignment = .center
            getChargesLabel.font = UIFont(name: "Avenir-Regular", size: 20)
            getChargesLabel.font = getChargesLabel.font.withSize(1.5 * x)
            selfScreenContents.addSubview(getChargesLabel)
            
            y1 = chargesLabel.frame.maxY + y
        }
        
        let lineLabel1 = UILabel()
        lineLabel1.frame = CGRect(x: x, y: y1, width: view.frame.width - (2 * x), height: 1)
        lineLabel1.backgroundColor = UIColor.black
        selfScreenContents.addSubview(lineLabel1)
        
       // let orderTotalLabel = UILabel()
        orderTotalLabel.frame = CGRect(x: x, y: lineLabel1.frame.maxY + y, width: (10 * y), height: (3 * y))
        orderTotalLabel.text = "Order Total"
        orderTotalLabel.textColor = UIColor.black
        orderTotalLabel.textAlignment = .left
        orderTotalLabel.font = UIFont(name: "Avenir-Regular", size: 20)
        orderTotalLabel.font = orderTotalLabel.font.withSize(1.5 * x)
        selfScreenContents.addSubview(orderTotalLabel)
        
       // let getOrderTotalLabel = UILabel()
        getOrderTotalLabel.frame = CGRect(x: selfScreenContents.frame.width - (12 * x), y: lineLabel1.frame.maxY + y, width: (7 * x), height: (3 * y))
        getOrderTotalLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        getOrderTotalLabel.text = "60"
        getOrderTotalLabel.textColor = UIColor.white
        getOrderTotalLabel.textAlignment = .right
        getOrderTotalLabel.font = UIFont(name: "Avenir-Regular", size: 20)
        getOrderTotalLabel.font = getOrderTotalLabel.font.withSize(1.5 * x)
        selfScreenContents.addSubview(getOrderTotalLabel)
        
         let AED_Label = UILabel()
        AED_Label.frame = CGRect(x: getOrderTotalLabel.frame.maxX - x, y: lineLabel1.frame.maxY + y, width: (7 * x), height: (3 * y))
       // AED_Label.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        AED_Label.text = "AED"
        AED_Label.textColor =  UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        AED_Label.textAlignment = .center
        AED_Label.font = UIFont(name: "Avenir-Regular", size: 20)
        AED_Label.font = AED_Label.font.withSize(1.5 * x)
        selfScreenContents.addSubview(AED_Label)

        
        let lineLabel2 = UILabel()
        lineLabel2.frame = CGRect(x: x, y: orderTotalLabel.frame.maxY + y, width: view.frame.width - (2 * x), height: 1)
        lineLabel2.backgroundColor = UIColor.black
        selfScreenContents.addSubview(lineLabel2)
        
        let priceDetailsNextButton = UIButton()
        priceDetailsNextButton.frame = CGRect(x: selfScreenContents.frame.width - (5 * x), y: selfScreenContents.frame.height - (5 * y), width: (4 * x), height: (4 * x))
        priceDetailsNextButton.layer.cornerRadius = priceDetailsNextButton.frame.height / 2
        priceDetailsNextButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        priceDetailsNextButton.setImage(UIImage(named: "rightArrow"), for: .normal)
        priceDetailsNextButton.addTarget(self, action: #selector(self.priceDetailsNextButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(priceDetailsNextButton)
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.QtyNum_TF.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        Variables.sharedManager.ApprovalQty = self.QtyNum_TF.text!
        let orderTotal = Int(getOrderTotalLabel.text!)!
        let QtyTotal = Int(Variables.sharedManager.ApprovalQty)!
        let total:Int = (orderTotal * QtyTotal)
        getOrderTotalLabel.text = String(total)
        self.view.endEditing(true)
    }
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func priceDetailsNextButtonAction(sender : UIButton)
    {
        let idType = Variables.sharedManager.tailorType
        
        if idType == 1
        {
            Variables.sharedManager.TotalAmount = getOrderTotalLabel.text!
            Variables.sharedManager.ApprovalQty = self.QtyNum_TF.text!
        }
        let orderScreen = OrderSummaryViewController()
        self.navigationController?.pushViewController(orderScreen, animated: true)
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
