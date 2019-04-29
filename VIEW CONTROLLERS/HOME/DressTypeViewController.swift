//
//  DressTypeViewController.swift
//  Mzyoon
//
//  Created by QOL on 16/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class DressTypeViewController: CommonViewController, ServerAPIDelegate, UITextFieldDelegate
{
    var tag = Int()
    let serviceCall = ServerAPI()
    
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()

    //DRESS TYPE PARAMETERS
    var dressTypeArray = NSArray()
    var dressTypeArrayInArabic = NSArray()
    var dressIdArray = NSArray()
    var dressImageArray = NSArray()
    var convertedDressImageArray = [UIImage]()
    
    let dressTypeView = UIView()
    let filterButton = UIButton()
    let sortButton = UIButton()
    let searchTextField = UITextField()
    let searchTextTableView = UITableView()
    let filterView = UIView()
    let dressTypeScrollView = UIScrollView()

    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    var applicationDelegate = AppDelegate()

    
    override func viewDidLoad()
    {
        self.navigationBar.isHidden = true
        selectedButton(tag: 0)
        
        serviceCall.API_DressType(genderId: tag, delegate: self)

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                changeViewToEnglishInSelf()
                dressTypeSubContents(inputTextArray: dressTypeArray, inputIdArray: dressIdArray, inputImageArray: dressImageArray)
            }
            else if language == "ar"
            {
                changeViewToArabicInSelf()
                dressTypeSubContents(inputTextArray: dressTypeArrayInArabic, inputIdArray: dressIdArray, inputImageArray: dressImageArray)
            }
        }
        else
        {
            changeViewToEnglishInSelf()
            dressTypeSubContents(inputTextArray: dressTypeArray, inputIdArray: dressIdArray, inputImageArray: dressImageArray)
        }
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                slideMenu()
                changeViewToEnglish()
            }
            else if language == "ar"
            {
                slideMenuRight()
                changeViewToArabic()
            }
        }
        else
        {
            slideMenu()
            changeViewToEnglish()
        }
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
       // ErrorStr = "Default Error"
        PageNumStr = "DressTypeViewController"
        MethodName = "GetDressTypeByGender"
        
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("DRESS TYPE", errorMessage)
        stopActivity()
        applicationDelegate.exitContents()
    }
    
    func API_CALLBACK_DressType(dressType: NSDictionary)
    {
        print("DRESS TYPE", dressType)
        let ResponseMsg = dressType.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = dressType.object(forKey: "Result") as! NSArray
            
            dressTypeArray = Result.value(forKey: "NameInEnglish") as! NSArray
            
            dressTypeArrayInArabic = Result.value(forKey: "NameInArabic") as! NSArray
            
            dressIdArray = Result.value(forKey: "Id") as! NSArray
            
            dressImageArray = Result.value(forKey: "ImageURL") as! NSArray
            
            dressTypeContent()
        }
        else if ResponseMsg == "Failure"
        {
            let Result = dressType.object(forKey: "Result") as! String
            print("Result", Result)
            
            ErrorStr = Result
            DeviceError()
        }
        
    }
    
    func API_CALLBACK_InsertErrorDevice(deviceError: NSDictionary)
    {
        let ResponseMsg = deviceError.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = deviceError.object(forKey: "Result") as! String
            print("Result", Result)
        }
    }
    
    func API_CALLBACK_SortAscending(ascending: NSDictionary) {
        print("ASCENDING ORDER", ascending)
        
        let ResponseMsg = ascending.object(forKey: "ResponseMsg") as! String
        
        let dummyArray = NSArray()
        
        dressTypeArray = dummyArray
        dressIdArray = dummyArray
        dressImageArray = dummyArray
        
        if ResponseMsg == "Success"
        {
            let Result = ascending.object(forKey: "Result") as! NSArray
            
            dressTypeArray = Result.value(forKey: "NameInEnglish") as! NSArray
            
            dressIdArray = Result.value(forKey: "Id") as! NSArray
            
            dressImageArray = Result.value(forKey: "ImageURL") as! NSArray
            
            dressTypeSubContents(inputTextArray: dressTypeArray, inputIdArray: dressIdArray, inputImageArray: dressImageArray)
            
        }
        else
        {
            let Result = ascending.object(forKey: "Result") as! String
            print("Result", Result)
            
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func API_CALLBACK_SortDescending(descending: NSDictionary) {
        print("ASCENDING ORDER", descending)
        
        let ResponseMsg = descending.object(forKey: "ResponseMsg") as! String
        
        let dummyArray = NSArray()
        
        dressTypeArray = dummyArray
        dressIdArray = dummyArray
        dressImageArray = dummyArray
        
        if ResponseMsg == "Success"
        {
            let Result = descending.object(forKey: "Result") as! NSArray
            
            dressTypeArray = Result.value(forKey: "NameInEnglish") as! NSArray
            
            dressIdArray = Result.value(forKey: "Id") as! NSArray
            
            dressImageArray = Result.value(forKey: "ImageURL") as! NSArray
            
            dressTypeSubContents(inputTextArray: dressTypeArray, inputIdArray: dressIdArray, inputImageArray: dressImageArray)
        }
        else
        {
            let Result = descending .object(forKey: "Result") as! String
            print("Result", Result)
            
            ErrorStr = Result
            DeviceError()
        }
    }
    
    func changeViewToArabicInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.text = "اختيار نوع اللباس"
        
        dressTypeScrollView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        searchTextField.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        searchTextField.textAlignment = .left
        searchTextField.placeholder = "بحث"
    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.text = "Dress Type Selection"
        
        dressTypeScrollView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        searchTextField.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        searchTextField.textAlignment = .left
        searchTextField.placeholder = "Search"
    }
    
    func dressTypeContent()
    {
        selfScreenNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        selfScreenNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(selfScreenNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        backButton.tag = 2
        selfScreenNavigationBar.addSubview(backButton)
        
        selfScreenNavigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: selfScreenNavigationBar.frame.width, height: (3 * y))
        selfScreenNavigationTitle.text = "Dress Type Selection"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationTitle.font = selfScreenNavigationTitle.font.withSize(2 * x)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        pageBar.image = UIImage(named: "Dress typeBar")
        
        searchTextField.frame = CGRect(x: 0, y: pageBar.frame.maxY, width: view.frame.width, height: (4 * y))
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.orange.cgColor
        searchTextField.placeholder = "Search"
        searchTextField.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        searchTextField.textAlignment = .left
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: searchTextField.frame.height))
        searchTextField.leftView = paddingView
        searchTextField.leftViewMode = UITextField.ViewMode.always
        searchTextField.adjustsFontSizeToFitWidth = true
        searchTextField.keyboardType = .default
        searchTextField.clearsOnBeginEditing = true
        searchTextField.returnKeyType = .done
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        view.addSubview(searchTextField)
        
        let searchButton = UIButton()
        searchButton.frame = CGRect(x: view.frame.width - (5 * x), y: 0, width: (5 * x), height: (4 * y))
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.orange.cgColor
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        searchButton.addTarget(self, action: #selector(self.searchButtonAction(sender:)), for: .touchUpInside)
        searchTextField.addSubview(searchButton)
        
        filterButton.frame = CGRect(x: 0, y: searchTextField.frame.maxY, width: (view.frame.width / 2) - 1, height: 40)
        filterButton.backgroundColor = UIColor.lightGray
        filterButton.setTitle("FILTER", for: .normal)
        filterButton.setTitleColor(UIColor.black, for: .normal)
        filterButton.tag = 1
//        filterButton.addTarget(self, action: #selector(self.featuresButtonAction(sender:)), for: .touchUpInside)
//        view.addSubview(filterButton)
        
        let downArrow1 = UIImageView()
        downArrow1.frame = CGRect(x: filterButton.frame.maxX - (5 * x), y: y, width: (2 * x), height: (2 * y))
        downArrow1.image = UIImage(named: "downArrow")
        filterButton.addSubview(downArrow1)
        
        sortButton.frame = CGRect(x: filterButton.frame.maxX + 1, y: searchTextField.frame.maxY, width: (view.frame.width / 2), height: 40)
        sortButton.backgroundColor = UIColor.lightGray
        sortButton.setTitle("SORT", for: .normal)
        sortButton.setTitleColor(UIColor.black, for: .normal)
        sortButton.tag = 2
        sortButton.addTarget(self, action: #selector(self.featuresButtonAction(sender:)), for: .touchUpInside)
//        view.addSubview(sortButton)
        
        let downArrow2 = UIImageView()
        downArrow2.frame = CGRect(x: filterButton.frame.maxX - (5 * x), y: y, width: (2 * x), height: (2 * y))
        downArrow2.image = UIImage(named: "downArrow")
        sortButton.addSubview(downArrow2)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                changeViewToEnglishInSelf()
                dressTypeSubContents(inputTextArray: dressTypeArray, inputIdArray: dressIdArray, inputImageArray: dressImageArray)
            }
            else if language == "ar"
            {
                changeViewToArabicInSelf()
                dressTypeSubContents(inputTextArray: dressTypeArrayInArabic, inputIdArray: dressIdArray, inputImageArray: dressImageArray)
            }
        }
        else
        {
            changeViewToEnglishInSelf()
            dressTypeSubContents(inputTextArray: dressTypeArray, inputIdArray: dressIdArray, inputImageArray: dressImageArray)
        }
        
        pageContent(tag: 2)
    }
    
    @objc func searchButtonAction(sender : UIButton)
    {
        searchTextField.becomeFirstResponder()
    }
    
    func dressTypeSubContents(inputTextArray : NSArray, inputIdArray : NSArray, inputImageArray : NSArray)
    {
        dressTypeScrollView.frame = CGRect(x: x, y: searchTextField.frame.maxY + y, width: view.frame.width - (2 * x), height: (view.frame.height - (searchTextField.frame.maxY + tabBar.frame.height + (2 * y))))
        //        dressTypeScrollView.backgroundColor = UIColor.red
        view.addSubview(dressTypeScrollView)
        
        for views in dressTypeScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        var y1:CGFloat = 0
        var x1:CGFloat = 0
        for i in 0..<inputTextArray.count
        {
            let dressTypeButton = UIButton()
            if i % 2 == 0
            {
                dressTypeButton.frame = CGRect(x: 0, y: y1, width: (17.25 * x), height: (17 * y))
            }
            else
            {
                dressTypeButton.frame = CGRect(x: x1, y: y1, width: (17.25 * x), height: (17 * y))
                y1 = dressTypeButton.frame.maxY + y
            }
            dressTypeButton.backgroundColor = UIColor.white
            dressTypeButton.tag = inputIdArray[i] as! Int
            dressTypeButton.addTarget(self, action: #selector(self.dressTypeButtonAction(sender:)), for: .touchUpInside)
            dressTypeScrollView.addSubview(dressTypeButton)
            
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    dressTypeButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
                else if language == "ar"
                {
                    dressTypeButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                }
            }
            else
            {
                dressTypeButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            
            x1 = dressTypeButton.frame.maxX + x
            
            let dressTypeImageView = UIImageView()
            dressTypeImageView.frame = CGRect(x: 0, y: 0, width: dressTypeButton.frame.width, height: dressTypeButton.frame.height - (3 * y))
            if let imageName = inputImageArray[i] as? String
            {
                let urlString = serviceCall.baseURL
                let api = "\(urlString)/images/DressTypes/\(imageName)"
                let apiurl = URL(string: api)
                if apiurl != nil
                {
                    dressTypeImageView.dowloadFromServer(url: apiurl!)
                }
                
                if i == inputImageArray.count - 1
                {
                    self.stopActivity()
                }
                else
                {
                    
                }
            }
            dressTypeButton.addSubview(dressTypeImageView)
            
            let dressTypeNameLabel = UILabel()
            dressTypeNameLabel.frame = CGRect(x: 0, y: dressTypeImageView.frame.maxY, width: dressTypeButton.frame.width, height: (3 * y))

            if let dressName = inputTextArray[i] as? String
            {
                if dressName.characters.count > 15
                {
                    dressTypeNameLabel.numberOfLines = 2
                }
                else
                {
                    dressTypeNameLabel.numberOfLines = 1
                }
            }
            dressTypeNameLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            dressTypeNameLabel.text = inputTextArray[i] as? String
            dressTypeNameLabel.textColor = UIColor.white
            dressTypeNameLabel.textAlignment = .center
            dressTypeNameLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
            dressTypeNameLabel.font = dressTypeNameLabel.font.withSize(1.5 * x)
            dressTypeNameLabel.tag = ((dressTypeButton.tag * 1) + 300)
            dressTypeButton.addSubview(dressTypeNameLabel)
        }
        
        print("CHECKING COUNT", inputTextArray.count % 2, inputTextArray)
        
        if inputTextArray.count % 2 == 0
        {
            dressTypeScrollView.contentSize.height = y1 + (2 * y)
        }
        else
        {
            dressTypeScrollView.contentSize.height = y1 + (18 * y)
        }
    }
    
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func genderButtonAction(sender : UIButton)
    {
        serviceCall.API_DressType(genderId: sender.tag, delegate: self)
    }
    
    @objc func featuresButtonAction(sender : UIButton)
    {
        view.endEditing(true)
        
        if sender.tag == 1
        {
            sortButton.backgroundColor = UIColor.lightGray
            sortButton.setTitleColor(UIColor.black, for: .normal)
            
            if sender.backgroundColor == UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            {
                sender.backgroundColor = UIColor.lightGray
                sender.setTitleColor(UIColor.black, for: .normal)
                filterViewContents(isHidden: true)
            }
            else
            {
                sender.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
                sender.setTitleColor(UIColor.white, for: .normal)
                
                filterViewContents(isHidden: false)
                
//                let filterScreen = FilterViewController()
//                self.navigationController?.pushViewController(filterScreen, animated: true)
            }
        }
        else
        {
            filterButton.backgroundColor = UIColor.lightGray
            filterButton.setTitleColor(UIColor.black, for: .normal)
            
            sender.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            sender.setTitleColor(UIColor.white, for: .normal)
            
            filterViewContents(isHidden: true)
            sortFunc()
        }
        
    }
    
    func filterViewContents(isHidden : Bool)
    {
        filterView.frame = CGRect(x: 0, y: filterButton.frame.maxY, width: view.frame.width, height: view.frame.height)
        filterView.backgroundColor = UIColor.white
        view.addSubview(filterView)
        
        filterView.isHidden = isHidden
        
        var y1:CGFloat = (5 * y)
        
        var filterButtonImages = ["gender-1", "occasion", "Price", "Region"]
        let filterButtonText = ["Gender", "Occasion", "Price", "Region"]
        
        for i in 0..<4
        {
            let filterButtons = UIButton()
            filterButtons.frame = CGRect(x: x, y: y1, width: view.frame.width - (2 * x), height: (5 * x))
            filterButtons.layer.borderWidth = 1
//            filterButtons.setImage(UIImage(named: filterButtonImages[i]), for: .normal)
            filterButtons.tag = i
            filterButtons.addTarget(self, action: #selector(self.filterButtonAction(sender:)), for: .touchUpInside)
            filterView.addSubview(filterButtons)
            
            let filterImage = UIImageView()
            filterImage.frame = CGRect(x: x, y: y, width: (3 * x), height: (3 * y))
            filterImage.image = UIImage(named: filterButtonImages[i])
            filterButtons.addSubview(filterImage)
            
            let filterButtonTitle = UILabel()
            filterButtonTitle.frame = CGRect(x: (5 * x ), y: y, width: filterButtons.frame.width, height: (1.5 * x))
            filterButtonTitle.text = filterButtonText[i]
            filterButtonTitle.textColor = UIColor.black
            filterButtonTitle.textAlignment = .left
            filterButtons.addSubview(filterButtonTitle)
            
            let filterButtonSubTitle = UILabel()
            filterButtonSubTitle.frame = CGRect(x: (5 * x ), y: filterButtonTitle.frame.maxY, width: filterButtons.frame.width, height: (1.5 * x))
            filterButtonSubTitle.text = "CHECKING SUB"
            filterButtonSubTitle.textColor = UIColor.black
            filterButtonSubTitle.textAlignment = .left
            filterButtons.addSubview(filterButtonSubTitle)
            
            y1 = filterButtons.frame.maxY + (2 * y)
        }
    }
    
    @objc func filterButtonAction(sender : UIButton)
    {
        let filterScreen = FilterViewController()
        
        if sender.tag == 0
        {
            filterScreen.filterTitle = "Gender"
        }
        else if sender.tag == 1
        {
            filterScreen.filterTitle = "Occasion"
        }
        else if sender.tag == 2
        {
            filterScreen.filterTitle = "Price"
        }
        else if sender.tag == 3
        {
            filterScreen.filterTitle = "Region"
        }
        
        self.navigationController?.pushViewController(filterScreen, animated: true)
    }
    
    
    @objc func sortFunc()
    {
        let alert = UIAlertController(title: "SORT BY", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Name -- Ascending A-Z", style: .default, handler: ascendingOrderAlertAction(action:)))
        alert.addAction(UIAlertAction(title: "Name -- Descending Z-A", style: .default, handler: descendingOrderAlertAction(action:)))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: sortCancelAction(action:)))
        self.present(alert, animated: true, completion: nil)
    }
    
    func ascendingOrderAlertAction(action : UIAlertAction)
    {
        serviceCall.API_SortAscending(delegate: self)
        sortButton.backgroundColor = UIColor.lightGray
        sortButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    func descendingOrderAlertAction(action : UIAlertAction)
    {
        serviceCall.API_SortDescending(delegate: self)
        sortButton.backgroundColor = UIColor.lightGray
        sortButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    @objc func sortCancelAction(action : UIAlertAction)
    {
        sortButton.backgroundColor = UIColor.lightGray
        sortButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    @objc func dressTypeButtonAction(sender : UIButton)
    {
        if sender.tag != 0
        {
            let dressSubScreen = DressSubTypeViewController()
            dressSubScreen.screenTag = sender.tag
            Variables.sharedManager.dressId = sender.tag
            
            if let label = view.viewWithTag((sender.tag * 1) + 300) as? UILabel
            {
                Variables.sharedManager.dressType = label.text!
                dressSubScreen.headingTitle = label.text!
            }
            
            print("DRESS TYPE IN VARIABLES", Variables.sharedManager.dressType)
            
            self.navigationController?.pushViewController(dressSubScreen, animated: true)
        }
        else
        {
            let emptyAlert = UIAlertController(title: "Alert", message: "We don't have sub types in this", preferredStyle: .alert)
            emptyAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(emptyAlert, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        
        var nameArrayString = [String]()
        var imageArrayString = [String]()
        var idArrayString = [Int]()
        var nameArray = NSArray()
        var imageArray = NSArray()
        var idArray = NSArray()
        
        let text = textField.text
        
        if (text?.utf16.count)! >= 1{
            for i in 0..<dressTypeArray.count
            {
                if let dress = dressTypeArray[i] as? String
                {
                    let count = textField.text?.count
                    let subString = dress.prefix(count!)
                    let convertedSubString = String(subString)
                    if textField.text == convertedSubString
                    {
                        nameArrayString.append(dress)
                        imageArrayString.append(dressImageArray[i] as! String)
                        idArrayString.append(dressIdArray[i] as! Int)
                    }
                }
            }
            
            nameArray = nameArrayString as NSArray
            imageArray = imageArrayString as NSArray
            idArray = idArrayString as NSArray
            
            dressTypeSubContents(inputTextArray: nameArray, inputIdArray: idArray, inputImageArray: imageArray)
        }
        else
        {
            dressTypeSubContents(inputTextArray: dressTypeArray, inputIdArray: dressIdArray, inputImageArray: dressImageArray)
        }
        
    }
    
    /*func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == searchTextField
        {
     
        }
        
        return true
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var nameArray = NSArray()
        var imageArray = NSArray()
        
        if textField == searchTextField
        {
            if (textField.text?.count)! > 0
            {
                for i in 0..<dressTypeArray.count
                {
                    if let dress = dressTypeArray[i] as? String
                    {
                        let count = textField.text?.count
                        let subString = dress.prefix(count!)
                        let convertedSubString = String(subString)
                        if textField.text == convertedSubString
                        {
                            nameArray.addingObjects(from: [dress])
                            imageArray.addingObjects(from: [dressImageArray[i]])
                        }
                    }
                }
                
                dressTypeSubContents(inputTextArray: nameArray, inputImageArray: imageArray)
            }
            else
            {
                dressTypeSubContents(inputTextArray: dressTypeArray, inputImageArray: dressImageArray)
            }
        }
        else
        {
            dressTypeSubContents(inputTextArray: dressTypeArray, inputImageArray: dressImageArray)
        }
       
        return true
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
