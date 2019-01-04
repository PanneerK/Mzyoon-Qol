//
//  TrackingViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 02/01/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class TrackingViewController: CommonViewController,UITableViewDelegate,UITableViewDataSource
{
  // let TrackingTableview = UITableView()
    private var TrackingTableview: UITableView!
    
     private let fruit: NSArray = ["apple", "orange", "banana", "strawberry", "lemon"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        TrackingView()
        
        slideMenuButton.isHidden = true
        tabBar.isHidden = true
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
        
        TrackingTableview = UITableView(frame: CGRect(x: 0, y: TrackingDetailsNavigationBar.frame.maxY, width: TrackingDetailsNavigationBar.frame.width, height: displayHeight - (TrackingDetailsNavigationBar.frame.height)))
        TrackingTableview.register(TrackingTableViewCell.self, forCellReuseIdentifier: "cell")         // register cell name
        
        //Tableview..
        TrackingTableview.delegate = self
        TrackingTableview.dataSource = self
        
        //Auto-set the UITableViewCells height (requires iOS8+)
        TrackingTableview.rowHeight = UITableView.automaticDimension
        TrackingTableview.estimatedRowHeight = 44
        
        self.view.addSubview(TrackingTableview)
        
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // return the number of sections
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    // return the number of cells each section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return fruit.count
    }
    
    // return cells
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrackingTableViewCell
        
        cell.TrackingDetails.text = "\(fruit[indexPath.row])"
        cell.TrackingDate.text = "Message \(indexPath.row)"
      //  cell.TrackingTime.text = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .short, timeStyle: .short)
        
        return cell
    }

}
