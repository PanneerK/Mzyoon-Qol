//
//  OffersFilterViewController.swift
//  Mzyoon
//
//  Created by QOL on 20/05/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class OffersFilterViewController: CommonViewController, UITableViewDataSource, UITableViewDelegate
{
    
    let selfScreenContents = UIView()
    let filterTableView = UITableView()

    var buttonCount = 0
    var filterType = 1

    override func viewDidLoad()
    {
        Variables.sharedManager.screenNavigationBarTag = 0
        commonBackButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        selectedButton(tag: 0)
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                self.navigationTitle.text = "ORDERS"
                self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            else if language == "ar"
            {
                self.navigationTitle.text = "أوامر"
                self.navigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            }
        }
        else
        {
            self.navigationTitle.text = "ORDERS"
            self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            // Your code with delay
            
            self.filterScreenContents()
        }
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func filterScreenContents()
    {
        activity.stopActivity()
        
        selfScreenContents.frame = CGRect(x: 0, y: navigationBar.frame.maxY, width: view.frame.width, height: view.frame.height - ((5 * y) + navigationBar.frame.maxY))
        selfScreenContents.backgroundColor = UIColor.clear
        view.addSubview(selfScreenContents)
        
        let filterTitle = ["Gender", "Category Type", "Location", "Coupon Type Discounts", "Discounts"]
        
        var y1:CGFloat = (2 * y)
        for i in 0..<filterTitle.count
        {
            let filterButtons = UIButton()
            filterButtons.frame = CGRect(x: x, y: y1, width: selfScreenContents.frame.width - (2 * x), height: (5 * y))
            filterButtons.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
            filterButtons.setTitle(filterTitle[i], for: .normal)
            filterButtons.setTitleColor(UIColor.white, for: .normal)
            filterButtons.contentHorizontalAlignment = .left
            filterButtons.tag = i
            filterButtons.addTarget(self, action: #selector(self.filtersButtonAction(sender:)), for: .touchUpInside)
            selfScreenContents.addSubview(filterButtons)
            
            let closeImage = UIImageView()
            closeImage.frame = CGRect(x: filterButtons.frame.width - (4 * y), y: y, width: (3 * y), height: (3 * y))
            closeImage.backgroundColor = UIColor.white
            filterButtons.addSubview(closeImage)
            
            y1 = filterButtons.frame.maxY + y
        }
        
        let applyFiltersButton = UIButton()
        applyFiltersButton.frame = CGRect(x: x, y: selfScreenContents.frame.height - (6 * y), width: selfScreenContents.frame.width - (2 * x), height: (5 * y))
        applyFiltersButton.backgroundColor = UIColor.blue
        applyFiltersButton.setTitle("APPLY FILTERS", for: .normal)
        applyFiltersButton.setTitleColor(UIColor.white, for: .normal)
        applyFiltersButton.tag = 1
        applyFiltersButton.addTarget(self, action: #selector(self.applyButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(applyFiltersButton)
    }
    
    @objc func filtersButtonAction(sender : UIButton)
    {
        filterType = sender.tag
        
        filterTableView.frame = CGRect(x: sender.frame.minX, y: sender.frame.maxY, width: sender.frame.width, height: (20 * y))
        filterTableView.backgroundColor = UIColor.clear
        filterTableView.dataSource = self
        filterTableView.delegate = self
        filterTableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        
        if buttonCount == 0
        {
            selfScreenContents.addSubview(filterTableView)
            buttonCount = 1
            for views in sender.subviews
            {
                if let imageView = views as? UIImageView
                {
                    imageView.image = UIImage(named: "")
                }
            }
        }
        else
        {
            filterTableView.removeFromSuperview()
            buttonCount = 0
            for views in sender.subviews
            {
                if let imageView = views as? UIImageView
                {
                    imageView.image = UIImage(named: "")
                }
            }
        }
        
        filterTableView.reloadData()
    }
    
    @objc func applyButtonAction(sender : UIButton)
    {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var returnCount = Int()
        
        if filterType == 0
        {
            returnCount = 4
        }
        else if filterType == 1
        {
            returnCount = 5
        }
        else if filterType == 2
        {
            returnCount = 6
        }
        else if filterType == 3
        {
            returnCount = 7
        }
        else
        {
            returnCount = 8
        }
        
        return returnCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath as IndexPath) as! UITableViewCell
        
        if filterType == 0
        {
            let cellTitle = ["Male", "Female", "Boy", "Girl"]
            cell.textLabel?.text = cellTitle[indexPath.row]
        }
        else if filterType == 1
        {
            
        }
        else if filterType == 2
        {
            
        }
        else if filterType == 3
        {
            
        }
        else
        {
            
        }
        
        let enableSwitch = UISwitch()
        enableSwitch.frame = CGRect(x: cell.frame.width - (5 * x), y: y, width: (5 * x), height: cell.frame.height)
        enableSwitch.isOn = false
        enableSwitch.tintColor = UIColor.lightGray
        enableSwitch.onTintColor = UIColor.orange
        cell.addSubview(enableSwitch)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (5 * y)
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
