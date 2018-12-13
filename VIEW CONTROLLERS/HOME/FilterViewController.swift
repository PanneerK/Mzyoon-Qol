//
//  FilterViewController.swift
//  Mzyoon
//
//  Created by QOL on 13/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate
{
    var filterTitle = String()
    var filterNames = [String]()

    var x = CGFloat()
    var y = CGFloat()
    
    override func viewDidLoad()
    {
        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
        
        view.backgroundColor = UIColor.white
        self.title = filterTitle
        filterContents()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func filterContents()
    {
        let searchTextField = UITextField()
        searchTextField.frame = CGRect(x: 0, y: (6.4 * y), width: view.frame.width, height: (5 * y))
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.orange.cgColor
        searchTextField.backgroundColor = UIColor.white
        searchTextField.placeholder = "Search"
        searchTextField.textAlignment = .left
        searchTextField.textColor = UIColor.black
        searchTextField.font = UIFont(name: "Avenir-Heavy", size: 18)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: searchTextField.frame.height))
        searchTextField.leftView = paddingView
        searchTextField.leftViewMode = UITextField.ViewMode.always
        searchTextField.adjustsFontSizeToFitWidth = true
        searchTextField.keyboardType = .default
        searchTextField.clearsOnBeginEditing = true
        searchTextField.returnKeyType = .done
        searchTextField.delegate = self
        view.addSubview(searchTextField)
        
        let line = UILabel()
        line.frame = CGRect(x: view.frame.width - (5 * x), y: (y / 2), width: 1, height: (4 * y))
        line.backgroundColor = UIColor.orange
        searchTextField.addSubview(line)
        
        let searchButton = UIButton()
        searchButton.frame = CGRect(x: line.frame.maxX, y: 0, width: (4.8 * x), height: (5 * y))
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        searchTextField.addSubview(searchButton)
        
        let filterTableView = UITableView()
        filterTableView.frame = CGRect(x: 0, y: searchTextField.frame.maxY + y, width: view.frame.width, height: (45 * y))
        filterTableView.dataSource = self
        filterTableView.delegate = self
        filterTableView.register(FilterTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(FilterTableViewCell.self))
        filterTableView.allowsMultipleSelection = true
        view.addSubview(filterTableView)
        
        let resetButton = UIButton()
        resetButton.frame = CGRect(x: (2 * x), y: view.frame.height - (6 * y), width: (15 * x), height: (4 * y))
        resetButton.backgroundColor = UIColor.lightGray
        resetButton.setTitle("RESET", for: .normal)
        resetButton.setTitleColor(UIColor.black, for: .normal)
        resetButton.addTarget(self, action: #selector(self.resetButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(resetButton)
        
        let applyButton = UIButton()
        applyButton.frame = CGRect(x: view.frame.width - (17 * x), y: view.frame.height - (6 * y), width: (15 * x), height: (4 * y))
        applyButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        applyButton.setTitle("APPLY", for: .normal)
        applyButton.setTitleColor(UIColor.white, for: .normal)
        applyButton.addTarget(self, action: #selector(self.applyButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(applyButton)
    }
    
    @objc func resetButtonAction(sender : UIButton)
    {
        
    }
    
    @objc func applyButtonAction(sender : UIButton)
    {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FilterTableViewCell.self), for: indexPath as IndexPath) as! FilterTableViewCell
        
        cell.filterName.frame = CGRect(x: (2 * x), y: 0, width: cell.frame.width - (10 * x), height: cell.frame.height)
        
        cell.filterImage.frame = CGRect(x: cell.filterName.frame.maxX + x, y: 0, width: (5 * x), height: (5 * y))
        
        return cell
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
