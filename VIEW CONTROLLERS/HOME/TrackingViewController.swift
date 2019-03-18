//
//  TrackingViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 02/01/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class TrackingViewController: CommonViewController,ServerAPIDelegate,UITableViewDelegate,UITableViewDataSource
{
    let ServiceCall = ServerAPI()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    var OrderID:Int!
    
    //Tracking array..
    var DateArray = NSArray()
    var StatusArray = NSArray()
    var TrackingStatusIdArray = NSArray()
    
    let TrackingTableview = UITableView()
   
    var TrackingDate = String()
    var TrackingTime = String()

    let emptyLabel = UILabel()
    
    var applicationDelegate = AppDelegate()

    var TrackingStatusArray = NSArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        slideMenuButton.isHidden = true
        tabBar.isHidden = true
        
        self.TrackingTableview.separatorStyle = UITableViewCell.SeparatorStyle.none
        
       
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.ServiceCall.API_GetTrackingDetails(OrderId: OrderID, delegate: self)
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("Tracking Details :", errorNumber)
        stopActivity()
        applicationDelegate.exitContents()
    }
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        // ErrorStr = "Default Error"
        PageNumStr = "TrackingViewController"
        //  MethodName = "do"
        
        print("UUID", UIDevice.current.identifierForVendor?.uuidString as Any)
        self.ServiceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
        
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
    func API_CALLBACK_GetTrackingDetails(getTrackingDetails: NSDictionary)
    {
        let ResponseMsg = getTrackingDetails.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = getTrackingDetails.object(forKey: "Result") as! NSArray
            
            if Result.count == 0  // || Result == nil
            {
                TrackingTableview.removeFromSuperview()
                
                emptyLabel.frame = CGRect(x: 0, y: ((view.frame.height - (3 * y)) / 2), width: view.frame.width, height: (3 * y))
                emptyLabel.text = "No Tracking Details Updated.."
                emptyLabel.textColor = UIColor.black
                emptyLabel.textAlignment = .center
                emptyLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
                emptyLabel.font = emptyLabel.font.withSize(1.5 * x)
                view.addSubview(emptyLabel)
            }
            
            
            DateArray = Result.value(forKey: "Date") as! NSArray
            print("DateArray:",DateArray)
            
            StatusArray = Result.value(forKey: "Status") as! NSArray
            print("StatusArray:",StatusArray)
            
            TrackingStatusIdArray = Result.value(forKey: "TrackingStatusId") as! NSArray
            print("TrackingStatusIdArray:",TrackingStatusIdArray)
            
            print("Tracking Array :",TrackingStatusArray)
            
            for i in 0..<StatusArray.count
            {
                let status = StatusArray[i]
                TrackingStatusArray.addingObjects(from:[status])
            }
            
            print("Tracking Array :",TrackingStatusArray)
            
            TrackingView()
            
            TrackingTableview.reloadData()
            
        }
        else if ResponseMsg == "Failure"
        {
            let Result = getTrackingDetails.object(forKey: "Result") as! String
            print("Result", Result)
            
            MethodName = "GetTrackingDetails"
            ErrorStr = Result
            
            DeviceError()
            
        }
    }
    
    func TrackingView()
    {
        self.stopActivity()
        
        let TrackingDetailsNavigationBar = UIView()
        TrackingDetailsNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        TrackingDetailsNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(TrackingDetailsNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 4
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        TrackingDetailsNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: TrackingDetailsNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "TRACKING DETAILS"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        TrackingDetailsNavigationBar.addSubview(navigationTitle)
        
    // get width and height of View...
        // let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        //  let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.size.height
        // let displayWidth: CGFloat = self.view.frame.width
        
        let displayHeight: CGFloat = self.view.frame.height
        
      //  TrackingTableview = UITableView(frame: CGRect(x: 0, y: TrackingDetailsNavigationBar.frame.maxY, width: TrackingDetailsNavigationBar.frame.width, height: displayHeight - (TrackingDetailsNavigationBar.frame.height)))
        
        TrackingTableview.frame = CGRect(x: 0, y: TrackingDetailsNavigationBar.frame.maxY, width: TrackingDetailsNavigationBar.frame.width, height: displayHeight - (TrackingDetailsNavigationBar.frame.height))
        TrackingTableview.backgroundColor = UIColor.white
        TrackingTableview.register(TrackingTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(TrackingTableViewCell.self))
        
        // register cell name
        
        //Tableview..
        TrackingTableview.delegate = self
        TrackingTableview.dataSource = self
        
        //Auto-set the UITableViewCells height (requires iOS8+)
       // TrackingTableview.rowHeight = UITableView.automaticDimension
        //TrackingTableview.estimatedRowHeight = 44
        
        
        view.addSubview(TrackingTableview)
        
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
   /*
    // return the number of sections
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    */
    
    // return the number of cells each section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return StatusArray.count
    }
    
    // return cells
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TrackingTableViewCell.self), for: indexPath as IndexPath) as! TrackingTableViewCell
       
        cell.backgroundColor = UIColor.white
        
        cell.contentSpace.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: (5 * y))
        
       // cell.roundLabel.frame = CGRect(x: (3 * x), y: ((cell.frame.height - (y)) / 2), width: y, height: y)
        
       
        cell.TrackingDate.frame = CGRect(x: (3 * x), y: ((cell.frame.height - (y)) / 2.5) , width: (10 * x), height: (1.5 * y))
        
        cell.TrackingTime.frame = CGRect(x: (5 * x), y: ((cell.frame.height - (y)) / 1.2), width: (10 * x), height: (1.5 * y))
        
        cell.roundLabel.frame = CGRect(x:  cell.TrackingDate.frame.maxX , y: ((cell.frame.height - (y))), width: y, height: y)
        cell.roundLabel.layer.cornerRadius = cell.roundLabel.frame.height / 2
        
        cell.TrackingDetails.frame = CGRect(x: cell.roundLabel.frame.maxX + (3 * x), y: ((cell.frame.height - (y)) / 1.2), width: cell.frame.width - (15 * x), height: (1.5 * y))
        
        
       //  cell.spaceView.frame = CGRect(x: 0, y: cell.frame.height - y, width: cell.frame.width, height: y)
      
        if(indexPath.row > 0)
        {
            cell.lineLabel.frame = CGRect(x: (cell.TrackingDate.frame.maxX) + ((cell.roundLabel.frame.width - 1) / 2), y: 0, width: 1, height: (cell.frame.height - cell.roundLabel.frame.height))
        }
       
        
        cell.TrackingDetails.text = StatusArray[indexPath.row] as? String
        
       // cell.TrackingDate.text = DateArray[indexPath.row] as? String
        
       
        if let date = DateArray[indexPath.row] as? String
        {
            print("Date:",date)
            //TrackingDate = String(date.prefix(10))
          
            
            let dateComponent = date.components(separatedBy: "T")
            
            TrackingDate = dateComponent[0]
            
            let SplitTime = dateComponent[1]
            
            TrackingTime = String(SplitTime.prefix(5))
            
            print("Date:",TrackingDate)
            print("Time:",TrackingTime)
            
            /*
             
             // var ConvertDate : String = ""
             //  var ConvertTime : String = ""
             
             let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "yyyy-MM-dd"
             let NewDateFormatter = DateFormatter()
             NewDateFormatter.dateFormat = "MMM d"
             
             let TimeFormatter = DateFormatter()
             TimeFormatter.dateFormat = "HH-mm-ss"
             let NewTimeFormatter = DateFormatter()
             NewTimeFormatter.dateFormat = "h:mm a"
             
             // let SplitDate = dateComponent[0]
             // let SplitTime = dateComponent[1]
             
            if let NewDate = dateFormatter.date(from: SplitDate)
            {
                TrackingDate = NewDateFormatter.string(from: NewDate)
                print("Date:",TrackingDate)
            }
            
            if let NewTime = TimeFormatter.date(from: SplitTime)
            {
                TrackingTime = NewTimeFormatter.string(from: NewTime)
                print("Time:",TrackingTime)
            }
            */
            
        }
        cell.TrackingDate.text = TrackingDate
        cell.TrackingTime.text = TrackingTime
        
        /*
        if (indexPath.row % 2) == 0
        {
            cell.lineLabel.frame = CGRect(x: (3 * x) + ((cell.roundLabel.frame.width - 1) / 2), y: cell.roundLabel.frame.maxY, width: 1, height:(cell.frame.height - cell.roundLabel.frame.height))
        }
         else if (indexPath.row % 2) != 0
         {
         cell.lineLabel.frame = CGRect(x: (3 * x) + ((cell.roundLabel.frame.width - 1) / 2), y: 0, width: 1, height: (cell.frame.height - cell.roundLabel.frame.height))
         }
        else
        {
            cell.lineLabel.frame = CGRect(x: (3 * x) + ((cell.roundLabel.frame.width - 1) / 2), y: 0, width: 1, height: (cell.frame.height - cell.roundLabel.frame.height))
        }
     */
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return (5 * y)
    }

}
