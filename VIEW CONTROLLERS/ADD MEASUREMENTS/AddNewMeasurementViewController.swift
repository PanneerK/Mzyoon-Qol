//
//  AddNewMeasurementViewController.swift
//  Mzyoon
//
//  Created by QOL on 15/04/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class AddNewMeasurementViewController: UIViewController, ServerAPIDelegate
{
    
    var x = CGFloat()
    var y = CGFloat()
    
    let serviceCall = ServerAPI()
    
    let backgroundImage = UIImageView()
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()
    
    let measurementScrollView = UIScrollView()
    let addNewButton = UIButton()
    
    var genderArrayInEnglish = NSArray()
    var genderArrayInArabic = NSArray()
    var nameArray = NSArray()
    var imageArray = NSArray()
    var dressNameArrayInEnglish = NSArray()
    var dressNameArrayInArabic = NSArray()
    
    override func viewDidLoad()
    {
        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if let id = UserDefaults.standard.value(forKey: "userId") as? Int
        {
            serviceCall.API_MeasurementList(userId: id, delegate: self)
        }
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("ERROR CODE", errorMessage)
    }
    
    func API_CALLBACK_MeasurementList(list: NSDictionary)
    {
        print("MEASUREMENT LIST", list)
        
        let ResponseMsg = list.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = list.object(forKey: "Result") as! NSArray
            
            genderArrayInEnglish = Result.value(forKey: "Gender") as! NSArray
            genderArrayInArabic = Result.value(forKey: "GenderInArabic") as! NSArray
            imageArray = Result.value(forKey: "Image") as! NSArray
            nameArray = Result.value(forKey: "Name") as! NSArray
            dressNameArrayInEnglish = Result.value(forKey: "NameInEnglish") as! NSArray
            dressNameArrayInArabic = Result.value(forKey: "NameInArabic") as! NSArray
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    selfScreenNavigationContents(getUserNameArray: nameArray, getDressNameArray: dressNameArrayInEnglish, getGenderArray: genderArrayInEnglish)
                }
                else if language == "ar"
                {
                    selfScreenNavigationContents(getUserNameArray: nameArray, getDressNameArray: dressNameArrayInArabic, getGenderArray: genderArrayInArabic)
                }
            }
            else
            {
                selfScreenNavigationContents(getUserNameArray: nameArray, getDressNameArray: dressNameArrayInEnglish, getGenderArray: genderArrayInEnglish)
            }
        }
    }
    
    func changeViewToArabicInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.text = "قائمة القياس"
        
//        measurementScrollView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        addNewButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        addNewButton.setTitle("إضافة قياسات جديدة", for: .normal)
    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.text = "Measurement List"
        
//        measurementScrollView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        addNewButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        addNewButton.setTitle("Add new measurements", for: .normal)
    }
    
    func selfScreenNavigationContents(getUserNameArray : NSArray, getDressNameArray : NSArray, getGenderArray : NSArray)
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
        
        measurementScrollView.frame = CGRect(x: x, y: selfScreenNavigationBar.frame.maxY + y, width: view.frame.width - (2 * x), height: view.frame.height - (selfScreenNavigationBar.frame.maxY + (7 * y)))
        view.addSubview(measurementScrollView)
        
        var y2:CGFloat = 0
        
        for i in 0..<getUserNameArray.count
        {
            let measurementButton = UIButton()
            measurementButton.frame = CGRect(x: 0, y: y2, width: measurementScrollView.frame.width, height: (8 * x))
            measurementButton.backgroundColor = UIColor.white
            measurementButton.layer.cornerRadius = 10
            measurementButton.tag = i
//            measurementButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
            measurementScrollView.addSubview(measurementButton)
            
            let dressImageView = UIImageView()
            dressImageView.frame = CGRect(x: x, y: y, width: (6 * y), height: (measurementButton.frame.height - (2 * y)))
//            dressImageView.layer.borderWidth = 0.5
//            dressImageView.layer.borderColor = UIColor.lightGray.cgColor
            dressImageView.layer.cornerRadius = dressImageView.frame.height / 2
            dressImageView.contentMode = .scaleAspectFit
            if let imageName = imageArray[i] as? String
            {
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/DressSubType/\(imageName)"
                let apiurl = URL(string: api)
                if apiurl != nil
                {
                    dressImageView.dowloadFromServer(url: apiurl!)
                }
            }
            measurementButton.addSubview(dressImageView)
            
            let lineLabel = UILabel()
            lineLabel.frame = CGRect(x: dressImageView.frame.maxX + x, y: y, width: 1, height: measurementButton.frame.height - (2 * y))
            lineLabel.backgroundColor = UIColor.lightGray
            measurementButton.addSubview(lineLabel)
            
            let userNameLabel = UILabel()
            userNameLabel.frame = CGRect(x: lineLabel.frame.maxX + x, y: y, width: measurementButton.frame.width - (10 * x), height: (3 * y))
            if let measurementName = getUserNameArray[i] as? String
            {
                userNameLabel.text = measurementName
            }
            userNameLabel.textColor = UIColor.black
            userNameLabel.textAlignment = .left
            userNameLabel.font = UIFont(name: "Avenir-Regular", size: (2 * x))
            userNameLabel.font = userNameLabel.font.withSize((2 * x))
            measurementButton.addSubview(userNameLabel)
            
            let dressNameLabel = UILabel()
            dressNameLabel.frame = CGRect(x: lineLabel.frame.maxX + x, y: userNameLabel.frame.maxY, width: measurementButton.frame.width - (10 * x), height: (3 * y))
            if let dressName = getDressNameArray[i] as? String, let gender = getGenderArray[i] as? String
            {
                dressNameLabel.text = "\(dressName) - \(gender)"
            }
            dressNameLabel.textColor = UIColor.lightGray
            dressNameLabel.textAlignment = .left
            dressNameLabel.font = UIFont(name: "Avenir-Regular", size: (2 * x))
            dressNameLabel.font = dressNameLabel.font.withSize((2 * x))
            measurementButton.addSubview(dressNameLabel)
            
            y2 = measurementButton.frame.maxY + y
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    measurementButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    dressImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    userNameLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    userNameLabel.textAlignment = .left
                    dressNameLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    dressNameLabel.textAlignment = .left
                }
                else if language == "ar"
                {
                    measurementButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    dressImageView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    userNameLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    userNameLabel.textAlignment = .right
                    dressNameLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    dressNameLabel.textAlignment = .right   
                }
            }
            else
            {
                measurementButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                dressImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                userNameLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                userNameLabel.textAlignment = .left
                dressNameLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                dressNameLabel.textAlignment = .left
            }
        }
        
        measurementScrollView.contentSize.height = y2 + (2 * y)
        
        addNewButton.frame = CGRect(x: 0, y: view.frame.height - (5 * y), width: view.frame.width, height: (5 * y))
        addNewButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        addNewButton.setTitle("Add new measurements", for: .normal)
        addNewButton.setTitleColor(UIColor.white, for: .normal)
        addNewButton.addTarget(self, action: #selector(self.measurementButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(addNewButton)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                changeViewToEnglishInSelf()
            }
            else if language == "ar"
            {
                changeViewToArabicInSelf()
            }
        }
        else
        {
            changeViewToEnglishInSelf()
        }
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
