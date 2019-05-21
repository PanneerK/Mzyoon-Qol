//
//  OffersViewController.swift
//  Mzyoon
//
//  Created by QOL on 17/05/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class OffersViewController: CommonViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate
{
    let selfScreenContents = UIView()
    let offersHorizontalScrollView = UIScrollView()
    var pageControl : UIPageControl = UIPageControl(frame: CGRect(x:50,y: 300, width:200, height:50))
    
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    
    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]

    var pageNumber = 0
    
    let blurView = UIView()
    let sortTableView = UITableView()
    
    let sortTitle = ["Popularity", "Price - Low to high", "Price - High to low", "Newest First"]
    
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
            
            self.offersScreenContents()
        }
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func offersScreenContents()
    {
        activity.stopActivity()
        
        selfScreenContents.frame = CGRect(x: 0, y: navigationBar.frame.maxY, width: view.frame.width, height: view.frame.height - ((5 * y) + navigationBar.frame.maxY))
        selfScreenContents.backgroundColor = UIColor.clear
        view.addSubview(selfScreenContents)
        
        let offerButtonScrollView = UIScrollView()
        offerButtonScrollView.frame = CGRect(x: 0, y: 0, width: selfScreenContents.frame.width, height: (4 * y))
        selfScreenContents.addSubview(offerButtonScrollView)
        
        var x1:CGFloat = 0
        
        for i in 0..<colors.count
        {
            let offersButton = UIButton()
            offersButton.frame = CGRect(x: x1, y: 0, width: (10 * x), height: (4 * y))
            offersButton.layer.borderWidth = 1
            offersButton.layer.borderColor = UIColor.orange.cgColor
            offersButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
            offersButton.setTitle("\(i)", for: .normal)
            offersButton.setTitleColor(UIColor.white, for: .normal)
            offersButton.titleLabel?.font = UIFont(name: "Avenir-Regular", size: (1.25 * x))
            offersButton.titleLabel?.font = offersButton.titleLabel?.font.withSize(1.25 * x)
            offersButton.tag = i
            offersButton.addTarget(self, action: #selector(self.offersButtonAction(sender:)), for: .touchUpInside)
            offerButtonScrollView.addSubview(offersButton)
            
            x1 = offersButton.frame.maxX
        }
        
        offerButtonScrollView.contentSize.width = x1
        
        offersHorizontalScrollView.frame = CGRect(x: x, y: offerButtonScrollView.frame.maxY, width: selfScreenContents.frame.width - (2 * x), height: selfScreenContents.frame.height - (offerButtonScrollView.frame.maxY))
        offersHorizontalScrollView.backgroundColor = UIColor.clear
        offersHorizontalScrollView.delegate = self
        selfScreenContents.addSubview(offersHorizontalScrollView)
        
        if colors.count != 0
        {
            for index in 0..<colors.count
            {
                frame.origin.x = offersHorizontalScrollView.frame.size.width * CGFloat(index)
                frame.size = offersHorizontalScrollView.frame.size
                
                let subView = UIScrollView(frame: frame)
                subView.backgroundColor = UIColor.clear
                subView.tag = ((index * 1) + 500)
                offersHorizontalScrollView.addSubview(subView)
                
                print("SUBVIEW WIDTH", subView.frame.width)
                
                let filterButton = UIButton()
                filterButton.frame = CGRect(x: x, y: y, width: ((subView.frame.width / 2) - x), height: (4 * y))
                filterButton.setTitle("Filter", for: .normal)
                filterButton.setTitleColor(UIColor.black, for: .normal)
                filterButton.addTarget(self, action: #selector(self.filterButtonAction(sender:)), for: .touchUpInside)
                subView.addSubview(filterButton)
                
                let filterImage = UIImageView()
                filterImage.frame = CGRect(x: 0, y: y, width: (3 * x), height: (2 * y))
                filterImage.image = UIImage(named: "filter")
                filterButton.addSubview(filterImage)
                
                let line = UILabel()
                line.frame = CGRect(x: filterButton.frame.maxX + (x / 2), y: y, width: 1, height: (4 * y))
                line.backgroundColor = UIColor.black
                subView.addSubview(line)
 
                let sortButton = UIButton()
                sortButton.frame = CGRect(x: filterButton.frame.maxX + x, y: y, width: ((subView.frame.width / 2) - x), height: (4 * y))
                sortButton.setTitle("Sort", for: .normal)
                sortButton.setTitleColor(UIColor.black, for: .normal)
                sortButton.addTarget(self, action: #selector(self.sortButtonAction(sender:)), for: .touchUpInside)
                subView.addSubview(sortButton)
                
                let sortImage = UIImageView()
                sortImage.frame = CGRect(x: 0, y: y, width: (3 * x), height: (2 * y))
                sortImage.image = UIImage(named: "sort")
                sortButton.addSubview(sortImage)
                
                if index == (colors.count - 1)
                {
                    var y1:CGFloat = filterButton.frame.maxY
                    for i in 0..<4
                    {
                        let coverImage = UIImageView()
                        coverImage.frame = CGRect(x: 0, y: y1, width: view.frame.width, height: (17 * y))
                        coverImage.backgroundColor = UIColor.black
                        subView.addSubview(coverImage)
                        
                        let nameLabel = UILabel()
                        nameLabel.frame = CGRect(x: x, y: ((coverImage.frame.height - (9 * y)) / 2), width: ((coverImage.frame.width / 2) - (2 * x)), height: (3 * y))
                        nameLabel.text = "Panneer selvam \(i)"
                        nameLabel.textAlignment = .left
                        nameLabel.textColor = UIColor.white
                        coverImage.addSubview(nameLabel)
                        
                        let offerLabel = UILabel()
                        offerLabel.frame = CGRect(x: x, y: nameLabel.frame.maxY, width: ((coverImage.frame.width / 2) - (2 * x)), height: (3 * y))
                        offerLabel.text = "Highlights of the year \(i + 1)"
                        offerLabel.textAlignment = .left
                        offerLabel.textColor = UIColor.white
                        coverImage.addSubview(offerLabel)
                        
                        let codeLabel = UILabel()
                        codeLabel.frame = CGRect(x: x, y: offerLabel.frame.maxY, width: ((coverImage.frame.width / 2) - (2 * x)), height: (3 * y))
                        codeLabel.layer.cornerRadius = x
                        codeLabel.backgroundColor = UIColor.orange
                        codeLabel.text = "USE CODE : \(i + 500)"
                        codeLabel.textColor = UIColor.white
                        codeLabel.textAlignment = .center
                        codeLabel.clipsToBounds = true
                        coverImage.addSubview(codeLabel)
                        
                        let detailedText = UIView()
                        detailedText.frame = CGRect(x: 0, y: coverImage.frame.maxY, width: view.frame.width, height: (6 * y))
                        detailedText.backgroundColor = UIColor.white
                        subView.addSubview(detailedText)
                        
                        let tailorName = UILabel()
                        tailorName.frame = CGRect(x: x, y: 0, width: (detailedText.frame.width / 3), height: (3 * y))
                        tailorName.text = "Tailor Name"
                        tailorName.textColor = UIColor.black
                        tailorName.textAlignment = .center
                        tailorName.clipsToBounds = true
                        detailedText.addSubview(tailorName)
                        
                        let getTailorName = UILabel()
                        getTailorName.frame = CGRect(x: x, y: tailorName.frame.maxY, width: (detailedText.frame.width / 3), height: (3 * y))
                        getTailorName.text = "abcdefghijklmnopqrstuvwxyz"
                        getTailorName.textColor = UIColor.black
                        getTailorName.textAlignment = .center
                        getTailorName.clipsToBounds = true
                        detailedText.addSubview(getTailorName)
                        
                        let line1 = UILabel()
                        line1.frame = CGRect(x: tailorName.frame.maxX, y: y, width: 1, height: (4 * y))
                        line1.backgroundColor = UIColor.black
                        detailedText.addSubview(line1)
                        
                        let shopName = UILabel()
                        shopName.frame = CGRect(x: line1.frame.maxX, y: 0, width: (detailedText.frame.width / 3), height: (3 * y))
                        shopName.text = "Shop Name"
                        shopName.textColor = UIColor.black
                        shopName.textAlignment = .center
                        shopName.clipsToBounds = true
                        detailedText.addSubview(shopName)
                        
                        let getShopName = UILabel()
                        getShopName.frame = CGRect(x: line1.frame.maxX, y: shopName.frame.maxY, width: (detailedText.frame.width / 3), height: (3 * y))
                        getShopName.text = "abcdefghijklmnopqrstuvwxyz"
                        getShopName.textColor = UIColor.black
                        getShopName.textAlignment = .center
                        getShopName.clipsToBounds = true
                        detailedText.addSubview(getShopName)
                        
                        let line2 = UILabel()
                        line2.frame = CGRect(x: shopName.frame.maxX, y: y, width: 1, height: (4 * y))
                        line2.backgroundColor = UIColor.black
                        detailedText.addSubview(line2)
                        
                        let applyButton = UIButton()
                        applyButton.frame = CGRect(x: line2.frame.maxX, y: y, width: (detailedText.frame.width / 4), height: (4 * y))
                        applyButton.setTitle("Apply", for: .normal)
                        applyButton.setTitleColor(UIColor.green, for: .normal)
                        detailedText.addSubview(applyButton)
                        
                        y1 = coverImage.frame.maxY + (9 * y)
                    }
                    
                    subView.contentSize.height = y1
                }
                else
                {
                    var y1:CGFloat = filterButton.frame.maxY
                    for i in 0..<4
                    {
                        let coverImage = UIImageView()
                        coverImage.frame = CGRect(x: 0, y: y1, width: view.frame.width, height: (17 * y))
                        coverImage.backgroundColor = UIColor.black
                        subView.addSubview(coverImage)
                        
                        let nameLabel = UILabel()
                        nameLabel.frame = CGRect(x: x, y: ((coverImage.frame.height - (6 * y)) / 2), width: ((coverImage.frame.width / 2) - (2 * x)), height: (3 * y))
                        nameLabel.text = "Panneer selvam \(i)"
                        nameLabel.textAlignment = .left
                        nameLabel.textColor = UIColor.white
                        coverImage.addSubview(nameLabel)
                        
                        let offerLabel = UILabel()
                        offerLabel.frame = CGRect(x: x, y: nameLabel.frame.maxY, width: ((coverImage.frame.width / 2) - (2 * x)), height: (3 * y))
                        offerLabel.text = "Highlights of the year \(i + 1)"
                        offerLabel.textAlignment = .left
                        offerLabel.textColor = UIColor.white
                        coverImage.addSubview(offerLabel)
                        
                        let detailedText = UIView()
                        detailedText.frame = CGRect(x: 0, y: coverImage.frame.maxY, width: view.frame.width, height: (6 * y))
                        detailedText.backgroundColor = UIColor.white
                        subView.addSubview(detailedText)
                        
                        let codeLabel = UILabel()
                        codeLabel.frame = CGRect(x: x, y: y, width: ((detailedText.frame.width / 2) - (2 * x)), height: (4 * y))
                        codeLabel.layer.cornerRadius = x
                        codeLabel.backgroundColor = UIColor.orange
                        codeLabel.text = "USE CODE : \(i + 500)"
                        codeLabel.textColor = UIColor.white
                        codeLabel.textAlignment = .center
                        codeLabel.clipsToBounds = true
                        detailedText.addSubview(codeLabel)
                        
                        let line = UILabel()
                        line.frame = CGRect(x: codeLabel.frame.maxX + (x / 2), y: y, width: 1, height: (4 * y))
                        line.backgroundColor = UIColor.black
                        detailedText.addSubview(line)
                        
                        let applyButton = UIButton()
                        applyButton.frame = CGRect(x: line.frame.maxX + (x / 2), y: y, width: ((detailedText.frame.width / 2) - (2 * x)), height: (4 * y))
                        applyButton.setTitle("Apply", for: .normal)
                        applyButton.setTitleColor(UIColor.green, for: .normal)
                        detailedText.addSubview(applyButton)
                        
                        y1 = coverImage.frame.maxY + (9 * y)
                    }
                    
                    subView.contentSize.height = y1
                }
            }
        }
        
        
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)

        offersHorizontalScrollView.contentSize = CGSize(width: offersHorizontalScrollView.frame.size.width * CGFloat(colors.count),height: offersHorizontalScrollView.frame.size.height)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func offersButtonAction(sender : UIButton)
    {
        for view in offersHorizontalScrollView.subviews
        {
            if view.tag == ((sender.tag * 1) + 500)
            {
                offersHorizontalScrollView.setContentOffset(CGPoint(x: view.frame.origin.x, y: view.frame.origin.y), animated: true)
            }
        }
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = colors.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
//        self.view.addSubview(pageControl)
        
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    @objc func changePage(sender: AnyObject) -> ()
    {
        let x = CGFloat(pageControl.currentPage) * offersHorizontalScrollView.frame.size.width
        offersHorizontalScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let pageNumbers = round(offersHorizontalScrollView.contentOffset.x / offersHorizontalScrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumbers)
        pageNumber = Int(pageNumbers)
        
        let x = CGFloat(pageNumbers) * offersHorizontalScrollView.frame.size.width
        offersHorizontalScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
        
    }
    
    
    @objc func filterButtonAction(sender : UIButton)
    {
        let filterScreen = OffersFilterViewController()
        self.navigationController?.navigationController?.pushViewController(filterScreen, animated: true)
    }
    
    @objc func sortButtonAction(sender : UIButton)
    {
        blurView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        blurView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.addSubview(blurView)
        
        let closeGesture = UITapGestureRecognizer(target: self, action: #selector(self.closeSortView(gesture:)))
        blurView.addGestureRecognizer(closeGesture)
        
        sortTableView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height / 3)
        sortTableView.dataSource = self
        sortTableView.delegate = self
        sortTableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        blurView.addSubview(sortTableView)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.sortTableView.frame = CGRect(x: 0, y: self.view.frame.height / 1.5, width: self.view.frame.width, height: self.view.frame.height / 3)
        }, completion: { finished in
            print("Basket doors opened!")
        })
    }
    
    @objc func closeSortView(gesture : UITapGestureRecognizer)
    {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.sortTableView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height / 3)
        }, completion: { finished in
            print("Basket doors closed!")
            self.blurView.removeFromSuperview()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "SORT BY"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath as IndexPath)
        
        cell.textLabel?.text = sortTitle[indexPath.row]
        
        let enableSwitch = UISwitch()
        enableSwitch.frame = CGRect(x: cell.frame.width - x, y: y, width: (5 * x), height: cell.frame.height)
        enableSwitch.isOn = false
        enableSwitch.tintColor = UIColor.lightGray
        enableSwitch.onTintColor = UIColor.orange
        cell.addSubview(enableSwitch)
        
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
