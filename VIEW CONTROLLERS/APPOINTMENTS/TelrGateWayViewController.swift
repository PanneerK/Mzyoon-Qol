//
//  TelrGateWayViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 24/01/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit
import TelrSDK

class TelrGateWayViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource
{
     var TotalAmount:Int!
     let CardNum_TF = UITextField()
     let ExpMonth_TF = UITextField()
     let ExpYear_TF = UITextField()
     let CVV_TF = UITextField()
    
    var MonthPick : UIPickerView!
    var YearPick : UIPickerView!
    
     var ExpMonthArray = NSArray()
     var ExpYearArray = NSArray()
    
     var x = CGFloat()
     var y = CGFloat()
    
    // Parameters:
    var KEY:String!
    var STOREID:String!
    var EMAIL:String!
    
    var DeviceType:String!
    var DeviceNum:String!
    var DeviceAgent:String!
    var DeviceAccept:String!
    
    var AppName:String!
    var AppVersion:String!
    var AppUser:String!
    var AppId:String!
    
    
    
    var dictionaryData = NSDictionary()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
     
         x = 10 / 375 * 100
         x = x * view.frame.width / 100
         
         y = 10 / 667 * 100
         y = y * view.frame.height / 100
      
        view.backgroundColor = UIColor.white
        
        TelrGatewayView()
        
         self.addDoneButtonOnKeyboard()
        
         ExpMonthArray = ["01","02","03","04","05","06","07","08","09","10","11","12"]
         ExpYearArray = ["2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030","2031","2032","2033","2034","2035","2036","2037","2038","2039","2040"]
        
        self.ExpMonth_TF.text = ExpMonthArray[0] as? String
        self.ExpYear_TF.text = ExpYearArray[0] as? String
        
        KEY = "XZCQ~9wRvD^prrJx"
        STOREID = "21552"
        // EMAIL = "rohith.qol@gmail.com"
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        DeviceType = "Simulator"
        DeviceAgent = "Card"
        DeviceType = "Auth"
        
        AppName = "Mzyoon"
        AppVersion = UIDevice.current.systemVersion
        AppUser = "User"
        AppId = "123456"
    }
    

     func TelrGatewayView()
     {
        let PaymentDetailsView = UIView()
        PaymentDetailsView.frame = CGRect(x: x, y: (5 * y) , width: view.frame.width - (2 * x), height: (10 * y))
        PaymentDetailsView.backgroundColor = UIColor(red:0.15, green:0.29, blue:0.12, alpha:1.0)
        view.addSubview(PaymentDetailsView)
        
        let PaymentLBL = UILabel()
        PaymentLBL.frame = CGRect(x: x, y: y/2 , width: PaymentDetailsView.frame.width - (2 * x), height: (3 * y))
        PaymentLBL.font = UIFont.boldSystemFont(ofSize: 16)
        PaymentLBL.text = "Telr Secure Payments"
        PaymentLBL.font = UIFont(name: "Avenir Next", size: 20)
        PaymentLBL.textColor = UIColor.white
        PaymentLBL.textAlignment = .left
        PaymentDetailsView.addSubview(PaymentLBL)
        
        // Upper_UnderLine..
        let Underline = UILabel()
        Underline.frame = CGRect(x: x, y: PaymentLBL.frame.maxY + (y / 2), width: PaymentDetailsView.frame.width - (2 * x), height: 1)
        Underline.backgroundColor = UIColor.white
        PaymentDetailsView.addSubview(Underline)
        
        let GBMPotalLBL = UILabel()
        GBMPotalLBL.frame = CGRect(x: x, y: Underline.frame.maxY + (y / 2) , width: PaymentDetailsView.frame.width - (2 * x), height: (2 * y))
        GBMPotalLBL.font = UIFont.boldSystemFont(ofSize: 16)
        GBMPotalLBL.text = "GBM Portal"
        GBMPotalLBL.font = UIFont(name: "Avenir Next", size: 16)
        GBMPotalLBL.textColor = UIColor.white
        GBMPotalLBL.textAlignment = .left
        PaymentDetailsView.addSubview(GBMPotalLBL)
        
        let AmountLBL = UILabel()
        AmountLBL.frame = CGRect(x: x, y: GBMPotalLBL.frame.maxY + (y / 2) , width: PaymentDetailsView.frame.width - (2 * x), height: (2 * y))
        AmountLBL.font = UIFont.boldSystemFont(ofSize: 16)
        AmountLBL.text = "Purchase For AED 250"
        AmountLBL.font = UIFont(name: "Avenir Next", size: 16)
        AmountLBL.textColor = UIColor.white
        AmountLBL.textAlignment = .left
        PaymentDetailsView.addSubview(AmountLBL)
        
        
        // TestMode View..
        let CardsView = UIView()
        CardsView.frame = CGRect(x: x, y: PaymentDetailsView.frame.maxY + y, width: view.frame.width - (2 * x), height: (24 * y))
        CardsView.backgroundColor = UIColor.white
        CardsView.layer.borderWidth = 0.5
        CardsView.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(CardsView)
        
        
        // Delivery Info Label..
        let CardLabel = UILabel()
        CardLabel.frame = CGRect(x: 0, y: 0, width: CardsView.frame.width, height: (4 * x))
        CardLabel.text = "     Credit/Debit Card"
        CardLabel.backgroundColor = UIColor.groupTableViewBackground
        CardLabel.font = UIFont(name: "Avenir Next", size: 16)
       // CardLabel.font = UIFont.boldSystemFont(ofSize: 16)
        CardLabel.textColor = UIColor.black
        CardsView.addSubview(CardLabel)
        
        let CardNumberLBL = UILabel()
        CardNumberLBL.frame = CGRect(x: x, y: CardLabel.frame.maxY + y , width: CardsView.frame.width - (2 * x), height: (2 * y))
        // CardNumberLBL.font = UIFont.boldSystemFont(ofSize: 16)
        CardNumberLBL.text = "Card Number"
        CardNumberLBL.font = UIFont(name: "Avenir Next", size: 14)
        CardNumberLBL.textColor = UIColor.black
        CardNumberLBL.textAlignment = .left
        CardsView.addSubview(CardNumberLBL)
        
       // let CardNum_TF = UITextField()
        CardNum_TF.frame = CGRect(x:x, y: CardNumberLBL.frame.maxY + y, width: CardsView.frame.width - (2 * x), height: (3 * y))
        //CardNum_TF.backgroundColor = UIColor.groupTableViewBackground
        //CardNum_TF.font = UIFont.boldSystemFont(ofSize: 16)
        CardNum_TF.placeholder = "  Card Number"
        CardNum_TF.font = UIFont(name: "Avenir Next", size: 14)
        CardNum_TF.textColor = UIColor.black
        CardNum_TF.adjustsFontSizeToFitWidth = true
        CardNum_TF.keyboardType = .numberPad
        CardNum_TF.clearsOnBeginEditing = true
        CardNum_TF.returnKeyType = .done
        CardNum_TF.delegate = self
        CardNum_TF.layer.borderColor = UIColor.lightGray.cgColor
        CardNum_TF.layer.borderWidth = 0.5
        CardNum_TF.textAlignment = .left
        CardsView.addSubview(CardNum_TF)
        
        let ExpiryDateLBL = UILabel()
        ExpiryDateLBL.frame = CGRect(x: x, y: CardNum_TF.frame.maxY + y , width: (8 * x), height: (2 * y))
        // CardNumberLBL.font = UIFont.boldSystemFont(ofSize: 16)
        ExpiryDateLBL.text = "Expiry date"
        ExpiryDateLBL.font = UIFont(name: "Avenir Next", size: 14)
        ExpiryDateLBL.textColor = UIColor.black
        ExpiryDateLBL.textAlignment = .left
        CardsView.addSubview(ExpiryDateLBL)
        
        let CVVLBL = UILabel()
        CVVLBL.frame = CGRect(x: ExpiryDateLBL.frame.maxX + (16 * x), y: CardNum_TF.frame.maxY + y , width: (6 * x), height: (2 * y))
        // CVVLBL.font = UIFont.boldSystemFont(ofSize: 16)
        CVVLBL.text = "CVV"
        CVVLBL.font = UIFont(name: "Avenir Next", size: 14)
        CVVLBL.textColor = UIColor.black
        CVVLBL.textAlignment = .left
        CardsView.addSubview(CVVLBL)
        
       // let ExpMonth_TF = UITextField()
        ExpMonth_TF.frame = CGRect(x:x, y: ExpiryDateLBL.frame.maxY + y, width: (10.5 * x), height: (3 * y))
        ExpMonth_TF.backgroundColor = UIColor(red:0.86, green:0.86, blue:0.83, alpha:1.0)
        ExpMonth_TF.font = UIFont(name: "Avenir Next", size: 14)
        ExpMonth_TF.textColor = UIColor.black
        ExpMonth_TF.adjustsFontSizeToFitWidth = true
        ExpMonth_TF.delegate = self
        ExpMonth_TF.layer.borderColor = UIColor.lightGray.cgColor
        ExpMonth_TF.layer.borderWidth = 0.5
        ExpMonth_TF.textAlignment = .left
        ExpMonth_TF.addTarget(self, action: #selector(self.ExpiryMonthAction), for: .allEditingEvents)
        CardsView.addSubview(ExpMonth_TF)
        
        // let ExpYear_TF = UITextField()
        ExpYear_TF.frame = CGRect(x:ExpMonth_TF.frame.maxX + x, y: ExpiryDateLBL.frame.maxY + y, width: (10.5 * x), height: (3 * y))
        ExpYear_TF.backgroundColor = UIColor(red:0.86, green:0.86, blue:0.83, alpha:1.0)
        ExpYear_TF.font = UIFont(name: "Avenir Next", size: 14)
        ExpYear_TF.textColor = UIColor.black
        ExpYear_TF.adjustsFontSizeToFitWidth = true
        ExpYear_TF.delegate = self
        ExpYear_TF.layer.borderColor = UIColor.lightGray.cgColor
        ExpYear_TF.layer.borderWidth = 0.5
        ExpYear_TF.textAlignment = .left
        ExpYear_TF.addTarget(self, action: #selector(self.ExpiryYearAction), for: .allEditingEvents)
        CardsView.addSubview(ExpYear_TF)
        
         //let CVV_TF = UITextField()
        CVV_TF.frame = CGRect(x:ExpYear_TF.frame.maxX + x, y: ExpiryDateLBL.frame.maxY + y, width: (10.5 * x), height: (3 * y))
        //CardNum_TF.backgroundColor = UIColor.groupTableViewBackground
        //CardNum_TF.font = UIFont.boldSystemFont(ofSize: 16)
        CVV_TF.placeholder = "  CVV"
        CVV_TF.font = UIFont(name: "Avenir Next", size: 14)
        CVV_TF.textColor = UIColor.black
        CVV_TF.adjustsFontSizeToFitWidth = true
        CVV_TF.keyboardType = .numberPad
        CVV_TF.clearsOnBeginEditing = true
        CVV_TF.returnKeyType = .done
        CVV_TF.delegate = self
        CVV_TF.layer.borderColor = UIColor.lightGray.cgColor
        CVV_TF.layer.borderWidth = 0.5
        CVV_TF.textAlignment = .left
        CardsView.addSubview(CVV_TF)
        
        
        let MakePay_BTN = UIButton()
        MakePay_BTN.frame = CGRect(x: x, y: ExpMonth_TF.frame.maxY + (2 * y), width: (12 * x), height: (3 * y))
        MakePay_BTN.backgroundColor = UIColor(red:0.35, green:0.81, blue:0.47, alpha:1.0)
        MakePay_BTN.setTitle("Make Payment", for: .normal)
        MakePay_BTN.setTitleColor(UIColor.white, for: .normal)
        MakePay_BTN.titleLabel?.font = UIFont(name: "Avenir Next", size: 16)!
        MakePay_BTN.layer.borderColor = UIColor.lightGray.cgColor
        //MakePay_BTN.layer.borderWidth = 1.0
        MakePay_BTN.layer.cornerRadius = 5
        MakePay_BTN.addTarget(self, action: #selector(self.MakePayment(sender:)), for: .touchUpInside)
        CardsView.addSubview(MakePay_BTN)
        
        
        let Cancel_BTN = UIButton()
        Cancel_BTN.frame = CGRect(x: MakePay_BTN.frame.maxX + (3 * x), y: ExpMonth_TF.frame.maxY + (2 * y), width: (12 * x), height: (3 * y))
        Cancel_BTN.backgroundColor = UIColor(red:0.98, green:0.35, blue:0.39, alpha:1.0)
        Cancel_BTN.setTitle("Cancel", for: .normal)
        Cancel_BTN.setTitleColor(UIColor.white, for: .normal)
        Cancel_BTN.titleLabel?.font = UIFont(name: "Avenir Next", size: 16)!
        Cancel_BTN.layer.borderColor = UIColor.lightGray.cgColor
        //MakePay_BTN.layer.borderWidth = 1.0
        Cancel_BTN.layer.cornerRadius = 5
        Cancel_BTN.addTarget(self, action: #selector(self.CancelPayment(sender:)), for: .touchUpInside)
        CardsView.addSubview(Cancel_BTN)
        
     }

func PaymentRequest()
{
    
let Message: String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
 "<mobile>" +
    "<store>\(String(describing: STOREID))</store>" +
    "<key>\(String(describing: KEY))</key>" +
    "<device>" +
    "<type>\(String(describing: DeviceType))</type>" +
    "<id>\(String(describing: DeviceNum))</id>" +
    "<agent>\(String(describing: DeviceAgent))</agent>" +
    "<accept>\(String(describing: DeviceAccept))</accept>" +
    "</device>" +
    "<app>" +
    "<name>\(String(describing: AppName))</name>" +
    "<version>\(String(describing: AppVersion))</version>" +
    "<user>\(String(describing: AppUser))</user>" +
    "<id>\(String(describing: AppId))</id>" +
    "</app>" +
    "<tran>" +
        "<test>0/test>" +
        "<type>PayPage</type>" +
        "<class>cont</class>" +
        "<cartid>Sys100</cartid>" +
        "<description>Testing</description>" +
        "<currency>AED</currency>" +
        "<amount>1</amount>" +
        "<ref>100000</ref>" +
    "</tran>" +
    "<card>" +
        "<number>4111111111111111</number>" +
        "<expiry>" +
          "<month>05</month>" +
          "<year>2020</year>" +
        "</expiry>" +
        "<cvv>123</cvv>" +
    "</card>" +
    "<billing>" +
       "<name>" +
         "<title>Mr</title>" +
         "<first>Rohith</first>" +
         "<last>Singh</last>" +
       "</name>\n" +
       "<address>" +
         "<line1>Appavoo street</line1>" +
         "<line2>Eliss road</line2>" +
         "<line3>Triplicane</line3>" +
         "<city>Chennai</city>" +
         "<region>TN</region>" +
         "<country>IN</country>" +
         "<zip>600002</zip>" +
       "</address>" +
    "<email>\(String(describing: EMAIL))</email>" +
    "</billing>" +
 "</mobile>"
    
    let urlString = "https://secure.innovatepayments.com/gateway/mobile.xml"
        if let url = NSURL(string: urlString)
        {
            let theRequest = NSMutableURLRequest(url: url as URL)
            theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            theRequest.addValue("http://tempuri.org/GetMISReqxml", forHTTPHeaderField: "SOAPAction")
            theRequest.addValue((Message), forHTTPHeaderField: "Content-Length")
            theRequest.httpMethod = "POST"
            theRequest.httpBody = Message.data(using: String.Encoding.utf8)
            let task = URLSession.shared.dataTask(with: theRequest as URLRequest)
            { (data, response, error) in
                if error == nil
                {
                    if let data = data, let responseString = String(data: data, encoding: String.Encoding.utf8)
                    {
                         print("responseString = \(responseString)")
                        do
                        {
                            self.dictionaryData = try XMLReader.dictionary(forXMLData: data, options:UInt(XMLReaderOptionsProcessNamespaces)) as NSDictionary
                            
                            print("Value:",self.dictionaryData)
                            
                         
                        }
                        catch
                        {
                            print("Your Dictionary value nil")
                        }
                        //print(dictionaryData)
                    }
                }
                else
                {
                    print(error!)
                }
            }
            task.resume()
        }
        
        
    }
     @objc func MakePayment(sender : UIButton)
     {
        
        PaymentRequest()
        
      /*
        if (CardNum_TF.text?.isEmpty)!
       {
         let appointmentAlert = UIAlertController(title: "Message..!", message: "Please Enter Card Number", preferredStyle: .alert)
         appointmentAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        //appointmentAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(appointmentAlert, animated: true, completion: nil)
       }
        else
        {
        let appointmentAlert = UIAlertController(title: "Alert..!", message: "Transaction Failed", preferredStyle: .alert)
        appointmentAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: proceedAlertAction(action:)))
        //appointmentAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(appointmentAlert, animated: true, completion: nil)
        }
        */
     }
     @objc func CancelPayment(sender : UIButton)
     {
        let appointmentAlert = UIAlertController(title: "Alert..!", message: "Transaction Failed", preferredStyle: .alert)
        appointmentAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: proceedAlertAction(action:)))
       // appointmentAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(appointmentAlert, animated: true, completion: nil)
     }
    func proceedAlertAction(action : UIAlertAction)
    {
        let HomeScreen = HomeViewController()
        self.navigationController?.pushViewController(HomeScreen, animated: true)
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
        
        self.CardNum_TF.inputAccessoryView = doneToolbar
        self.CVV_TF.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    @objc func ExpiryMonthAction()
    {
        ExpMonth_Pickup(ExpMonth_TF)
    }
    @objc func ExpiryYearAction()
    {
        ExpYear_Pickup(ExpYear_TF)
    }
    func ExpMonth_Pickup(_ textField : UITextField)
    {
        // Slot Picker Material..
        self.MonthPick = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 180))
        self.MonthPick.backgroundColor = UIColor.groupTableViewBackground
        //MonthPick.tag = 1
        textField.inputView = self.MonthPick
        
        MonthPick.showsSelectionIndicator = true
        MonthPick.delegate = self
        MonthPick.dataSource = self
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.DoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolBar
    }
    func ExpYear_Pickup(_ textField : UITextField)
    {
        // Slot Picker Material..
        self.YearPick = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 180))
        self.YearPick.backgroundColor = UIColor.groupTableViewBackground
        //MonthPick.tag = 1
        textField.inputView = self.YearPick
        
        YearPick.showsSelectionIndicator = true
        YearPick.delegate = self
        YearPick.dataSource = self
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.DoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolBar
    }
    @objc func DoneClick()
    {
        ExpMonth_TF.resignFirstResponder()
        ExpYear_TF.resignFirstResponder()
    }
    @objc func cancelClick()
    {
        ExpMonth_TF.resignFirstResponder()
        ExpYear_TF.resignFirstResponder()
    }
    
    // PickerView Delegate Methods..
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView == MonthPick
        {
            return ExpMonthArray.count
        }
        else if pickerView == YearPick
        {
            return ExpYearArray.count
        }
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == MonthPick
        {
            return  ExpMonthArray[row] as? String
        }
        else if pickerView == YearPick
        {
             return ExpYearArray[row] as? String
        }
       return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == MonthPick
        {
            ExpMonth_TF.text = ExpMonthArray[row] as? String
        }
        else if pickerView == YearPick
        {
            ExpYear_TF.text = ExpYearArray[row] as? String
        }
    }

}
