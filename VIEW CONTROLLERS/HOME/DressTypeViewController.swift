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
    
    //DRESS TYPE PARAMETERS
    var dressTypeArray = NSArray()
    var dressIdArray = NSArray()
    var dressImageArray = NSArray()
    var convertedDressImageArray = [UIImage]()
    
    let dressTypeView = UIView()
    let filterButton = UIButton()
    let sortButton = UIButton()
    let searchTextField = UITextField()
    let searchTextTableView = UITableView()
    let filterView = UIView()

    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    override func viewDidLoad()
    {
        self.navigationBar.isHidden = true
        
        self.tab1Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        
        serviceCall.API_DressType(genderId: tag, delegate: self)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
       // ErrorStr = "Default Error"
        PageNumStr = "DressTypeViewController"
        MethodName = "GetDressTypeByGender"
        
        print("UUID", UIDevice.current.identifierForVendor?.uuidString as Any)
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String) {
        print("DRESS TYPE", errorMessage)
    }
    
    func API_CALLBACK_DressType(dressType: NSDictionary)
    {
        
        let ResponseMsg = dressType.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = dressType.object(forKey: "Result") as! NSArray
            print("Result", Result)
            
            dressTypeArray = Result.value(forKey: "NameInEnglish") as! NSArray
            print("DressTypeInEnglish", dressTypeArray)
            
            dressIdArray = Result.value(forKey: "Id") as! NSArray
            print("Id", dressIdArray)
            
            dressImageArray = Result.value(forKey: "ImageURL") as! NSArray
            print("ImageURL", dressImageArray)
            
            /*for i in 0..<dressImageArray.count
            {
                if let imageName = dressImageArray[i] as? String
                {
                    let api = "http://appsapi.mzyoon.com/images/DressTypes/\(imageName)"
                    let apiurl = URL(string: api)
                    
                    if let data = try? Data(contentsOf: apiurl!) {
                        print("DATA OF IMAGE", data)
                        if let image = UIImage(data: data) {
                            self.convertedDressImageArray.append(image)
                        }
                    }
                    else
                    {
                        let emptyImage = UIImage(named: "empty")
                        self.convertedDressImageArray.append(emptyImage!)
                    }
                }
                else if let imgName = dressImageArray[i] as? NSNull
                {
                    let emptyImage = UIImage(named: "empty")
                    self.convertedDressImageArray.append(emptyImage!)
                }
            }*/
            
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
    
    func dressTypeContent()
    {
        self.stopActivity()
        
        dressTypeView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        dressTypeView.backgroundColor = UIColor.white
//        view.addSubview(dressTypeView)
        
        let dressTypeNavigationBar = UIView()
        dressTypeNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        dressTypeNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(dressTypeNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        backButton.tag = 2
        dressTypeNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: dressTypeNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "DRESS TYPE"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        dressTypeNavigationBar.addSubview(navigationTitle)
        
        searchTextField.frame = CGRect(x: 0, y: dressTypeNavigationBar.frame.maxY, width: view.frame.width - 50, height: 40)
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
        view.addSubview(searchTextField)
        
        let searchButton = UIButton()
        searchButton.frame = CGRect(x: view.frame.width - 51, y: 0, width: 50, height: 40)
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.orange.cgColor
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        searchTextField.addSubview(searchButton)
        
        filterButton.frame = CGRect(x: 0, y: searchTextField.frame.maxY, width: (view.frame.width / 2) - 1, height: 40)
        filterButton.backgroundColor = UIColor.lightGray
        filterButton.setTitle("FILTER", for: .normal)
        filterButton.setTitleColor(UIColor.black, for: .normal)
        filterButton.tag = 1
        filterButton.addTarget(self, action: #selector(self.featuresButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(filterButton)
        
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
        view.addSubview(sortButton)
        
        let downArrow2 = UIImageView()
        downArrow2.frame = CGRect(x: filterButton.frame.maxX - (5 * x), y: y, width: (2 * x), height: (2 * y))
        downArrow2.image = UIImage(named: "downArrow")
        sortButton.addSubview(downArrow2)
        
        /*let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: view.frame.width / 2.70, height: view.frame.width / 2.25)
        
        let dressTypeCollectionView = UICollectionView(frame: CGRect(x: (3 * x), y: filterButton.frame.maxY + (2 * y), width: view.frame.width - (6 * x), height: view.frame.height - (18 * y)), collectionViewLayout: layout)
        //        dressTypeCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        dressTypeCollectionView.register(DressTypeCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(DressTypeCollectionViewCell.self))
//        dressTypeCollectionView.dataSource = self
//        dressTypeCollectionView.delegate = self
        dressTypeCollectionView.backgroundColor = UIColor.clear
        dressTypeCollectionView.isUserInteractionEnabled = true
        dressTypeCollectionView.allowsMultipleSelection = false
        dressTypeCollectionView.allowsSelection = true
        dressTypeCollectionView.selectItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.top)
        //        view.addSubview(dressTypeCollectionView)*/
        
        let dressTypeScrollView = UIScrollView()
        dressTypeScrollView.frame = CGRect(x: (3 * x), y: sortButton.frame.maxY + (2 * y), width: view.frame.width - (6 * x), height: (45 * y))
//        dressTypeScrollView.backgroundColor = UIColor.red
        view.addSubview(dressTypeScrollView)
        
        var y1:CGFloat = 0
        var x1:CGFloat = 0
        for i in 0..<dressTypeArray.count
        {
            let dressTypeButton = UIButton()
            if i % 2 == 0
            {
                dressTypeButton.frame = CGRect(x: 0, y: y1, width: (15.25 * x), height: (16 * y))
            }
            else
            {
                dressTypeButton.frame = CGRect(x: x1, y: y1, width: (15.25 * x), height: (16 * y))
                y1 = dressTypeButton.frame.maxY + y
            }
            dressTypeButton.backgroundColor = UIColor.clear
            dressTypeButton.tag = i + 1
            dressTypeButton.addTarget(self, action: #selector(self.dressTypeButtonAction(sender:)), for: .touchUpInside)
            dressTypeScrollView.addSubview(dressTypeButton)
            
            x1 = dressTypeButton.frame.maxX + x
            
            let dressTypeImageView = UIImageView()
            dressTypeImageView.frame = CGRect(x: 0, y: 0, width: dressTypeButton.frame.width, height: (13 * y))
            if let imageName = dressImageArray[i] as? String
            {
                let api = "http://appsapi.mzyoon.com/images/DressTypes/\(imageName)"
                let apiurl = URL(string: api)
                dressTypeImageView.dowloadFromServer(url: apiurl!)
            }
//            dressTypeImageView.image = convertedDressImageArray[i]
            dressTypeButton.addSubview(dressTypeImageView)
            
            let dressTypeNameLabel = UILabel()
            dressTypeNameLabel.frame = CGRect(x: 0, y: dressTypeImageView.frame.maxY, width: dressTypeButton.frame.width, height: (3 * y))
            dressTypeNameLabel.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            dressTypeNameLabel.text = dressTypeArray[i] as? String
            dressTypeNameLabel.textColor = UIColor.white
            dressTypeNameLabel.textAlignment = .center
            dressTypeButton.addSubview(dressTypeNameLabel)
        }
        dressTypeScrollView.contentSize.height = y1 + (20 * y)
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
            filterButtons.setImage(UIImage(named: filterButtonImages[i]), for: .normal)
            filterButtons.tag = i
            filterButtons.addTarget(self, action: #selector(self.filterButtonAction(sender:)), for: .touchUpInside)
            filterView.addSubview(filterButtons)
            
            let filterImage = UIImageView()
            filterImage.frame = CGRect(x: (2 * x), y: y, width: (3 * x), height: (3 * y))
            filterImage.backgroundColor = UIColor.orange
//            filterButtons.addSubview(filterImage)
            
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
        alert.addAction(UIAlertAction(title: "Popularity", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Name -- Ascending A-Z", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Name -- Descending Z-A", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: sortCancelAction(action:)))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func sortCancelAction(action : UIAlertAction)
    {
        sortButton.backgroundColor = UIColor.lightGray
        sortButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    @objc func dressTypeButtonAction(sender : UIButton)
    {
        UserDefaults.standard.set(dressTypeArray[sender.tag - 1], forKey: "DressType")
        print("DRESS TYPE OF SELECTED - \(sender.tag)", dressTypeArray[sender.tag])
        let dressSubScreen = DressSubTypeViewController()
        dressSubScreen.screenTag = sender.tag
        dressSubScreen.headingTitle = dressTypeArray[sender.tag - 1] as! String
        self.navigationController?.pushViewController(dressSubScreen, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
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
