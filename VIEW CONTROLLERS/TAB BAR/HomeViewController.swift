//
//  HomeViewController.swift
//  Mzyoon
//
//  Created by QOL on 29/10/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit
import SideMenu

class HomeViewController: CommonViewController, ServerAPIDelegate
{
    let serviceCall = ServerAPI()

    let slideMB = UIButton()
    var slideView = UIView()
    
    //POSITION
    var xPos:CGFloat!
    var yPos:CGFloat!
    
    var imageName = NSArray()
    
    let slideScreen = SlideViewController()
    
    override func viewDidLoad()
    {
        UserDefaults.standard.set(1, forKey: "screenAppearance")
        
        xPos = 10 / 375 * 100
        xPos = xPos * view.frame.width / 100
        
        yPos = 10 / 667 * 100
        yPos = yPos * view.frame.height / 100
                
        selectedButton(tag: 0)
        
//        sideMenuFunctions()
        
        if let userId = UserDefaults.standard.value(forKey: "userId") as? String
        {
            serviceCall.API_ExistingUserProfile(Id: userId, delegate: self)
        }
        else if let userId = UserDefaults.standard.value(forKey: "userId") as? Int
        {
            serviceCall.API_ExistingUserProfile(Id: "\(userId)", delegate: self)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            // Your code with delay
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    self.navigationTitle.text = "HOME"
                    self.checkContent()
                }
                else if language == "ar"
                {
                    self.navigationTitle.text = "الصفحة الرئيسية"
                    self.checkContentInArabic()
                }
            }
            else
            {
                self.navigationTitle.text = "HOME"
                self.checkContent()
            }
        }
                
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String) {
        print("ERROR MESSAGE IN HOME PAGE", errorMessage)
    }
    
    func API_CALLBACK_ExistingUserProfile(userProfile: NSDictionary)
    {
        print("SELF OF EXISTING USER", userProfile)
        
        let responseMsg = userProfile.object(forKey: "ResponseMsg") as! String
        
        if responseMsg == "Success"
        {
            let result = userProfile.object(forKey: "Result") as! NSArray
            print("RESULT IN EXISTING", result)
            
            if result.count != 0
            {
                imageName = result.value(forKey: "ProfilePicture") as! NSArray
                
                if let imageName = imageName[0] as? String
                {
                    let urlString = serviceCall.baseURL
                    let api = "\(urlString)/Images/BuyerImages/\(imageName)"
                    
                    print("SMALL ICON", api)
                    let apiurl = URL(string: api)
                    
                    if apiurl != nil
                    {
                        //                    userImage.dowloadFromServer(url: apiurl!)
                        
                        downloadImage(from: apiurl!)
                    }
                }
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.userImage.image = UIImage(data: data)
                FileHandler().saveImageDocumentDirectory(image: UIImage(data: data)!)
            }
        }
    }
    
    func sideMenuFunctions()
    {
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: self)
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                let menuRightNavigationController = UISideMenuNavigationController(rootViewController: self)
                SideMenuManager.default.menuLeftNavigationController = menuRightNavigationController
            }
            else if language == "ar"
            {
                let menuRightNavigationController = UISideMenuNavigationController(rootViewController: self)
                SideMenuManager.default.menuRightNavigationController = menuRightNavigationController
            }
        }
        else
        {
            let menuRightNavigationController = UISideMenuNavigationController(rootViewController: self)
            SideMenuManager.default.menuLeftNavigationController = menuRightNavigationController
        }
        
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuFadeStatusBar = false
    }
    
    func checkContent()
    {
        let buttonTitleText = ["NEW ORDER", "BOOK AN APPOINTMENT", "STORE", "REFER AND EARN"]
        let imageName = ["new_order", "appointment", "store", "refer-&-earn"]
        var y1:CGFloat = (10 * yPos)
        
        self.stopActivity()
        for i in 0..<4
        {
            let selectionButton = UIButton()
            selectionButton.frame = CGRect(x: (3 * xPos), y: y1, width: view.frame.width - (6 * xPos), height: (11.175 * yPos))
            selectionButton.layer.cornerRadius = 15
            //            selectionButton.setImage(UIImage(named: "dashboardButton"), for: .normal)
            selectionButton.layer.borderWidth = 1
            selectionButton.layer.borderColor = UIColor.lightGray.cgColor
            selectionButton.backgroundColor = UIColor.white
            selectionButton.tag = i
            selectionButton.addTarget(self, action: #selector(self.selectionButtonAction(sender:)), for: .touchUpInside)
            selectionButton.isUserInteractionEnabled = true
            view.addSubview(selectionButton)
            
            y1 = selectionButton.frame.maxY + yPos
            
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: ((selectionButton.frame.width - (8 * xPos)) / 2), y: yPos, width: (8 * xPos), height: (7 * yPos))
            buttonImage.image = UIImage(named: imageName[i])
            selectionButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 0, y: buttonImage.frame.maxY, width: selectionButton.frame.width, height: (2 * yPos))
            buttonTitle.text = buttonTitleText[i]
            buttonTitle.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 5)
            selectionButton.addSubview(buttonTitle)
        }
    }
    
    func checkContentInArabic()
    {
        let buttonTitleText = ["طلب جديد", "حجز موعد", "متجر", "اشير واكسب"]
        let imageName = ["new_order", "appointment", "store", "refer-&-earn"]
        var y1:CGFloat = (10 * yPos)
        
        self.stopActivity()
        
        for i in 0..<4
        {
            let selectionButton = UIButton()
            selectionButton.frame = CGRect(x: (3 * xPos), y: y1, width: view.frame.width - (6 * xPos), height: (11.175 * yPos))
            selectionButton.layer.cornerRadius = 15
            //            selectionButton.setImage(UIImage(named: "dashboardButton"), for: .normal)
            selectionButton.layer.borderWidth = 1
            selectionButton.layer.borderColor = UIColor.lightGray.cgColor
            selectionButton.backgroundColor = UIColor.white
            selectionButton.tag = i
            selectionButton.addTarget(self, action: #selector(self.selectionButtonAction(sender:)), for: .touchUpInside)
            selectionButton.isUserInteractionEnabled = true
            view.addSubview(selectionButton)
            
            y1 = selectionButton.frame.maxY + yPos
            
            let buttonImage = UIImageView()
            buttonImage.frame = CGRect(x: ((selectionButton.frame.width - (8 * xPos)) / 2), y: yPos, width: (8 * xPos), height: (7 * yPos))
            buttonImage.image = UIImage(named: imageName[i])
            selectionButton.addSubview(buttonImage)
            
            let buttonTitle = UILabel()
            buttonTitle.frame = CGRect(x: 0, y: buttonImage.frame.maxY, width: selectionButton.frame.width, height: (2 * yPos))
            buttonTitle.text = buttonTitleText[i]
            buttonTitle.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            buttonTitle.textAlignment = .center
            buttonTitle.font = UIFont(name: "Avenir-Regular", size: 5)
            selectionButton.addSubview(buttonTitle)
        }
    }
    
    @objc func closeSlideView(gesture : UITapGestureRecognizer)
    {
        slideView.removeFromSuperview()
        // slideMenuButton.frame = CGRect(x: 0, y: ((view.frame.height - 65) / 2), width: 30, height: 65)
        slideMB.frame = CGRect(x: 0, y: ((view.frame.height - 65) / 2), width: 30, height: 65)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                self.navigationTitle.text = "HOME"
                self.checkContent()
            }
            else if language == "ar"
            {
                self.navigationTitle.text = "الصفحة الرئيسية"
                self.checkContentInArabic()
            }
        }
        else
        {
            self.navigationTitle.text = "HOME"
            self.checkContent()
        }
    }

    
    @objc func selectionButtonAction(sender : UIButton)
    {
        if sender.tag == 0
        {
            print("NEW ORDER")
            let newOrderScreen = GenderViewController()
            self.navigationController?.pushViewController(newOrderScreen, animated: true)
        }
        else if sender.tag == 1
        {
            print("BOOK AN APPOINTMENT")
            
            let AppointmentScreen = AppointmentListViewController()
            self.navigationController?.pushViewController(AppointmentScreen, animated: true)
        }
        else if sender.tag == 2
        {
            print("STORE")
        }
        else if sender.tag == 3
        {
            print("REFER AND EARN")
        }
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
