//
//  ViewDetailsViewController.swift
//  Mzyoon
//
//  Created by QOL on 08/05/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class ViewDetailsViewController: CommonViewController, UIScrollViewDelegate
{
    let serviceCall = ServerAPI()

    //SCROLL VIEW CONTENTS
    let detailScrollView = UIScrollView()
    var viewDetailsImageArray = [String]()
    var colorArrayCount = Int()
    
    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    var pageControl : UIPageControl = UIPageControl()
    
    override func viewDidLoad()
    {
        Variables.sharedManager.screenNavigationBarTag = 0
        commonBackButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        selectedButton(tag: 0)
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                self.navigationTitle.text = "Material Selection"
                self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            else if language == "ar"
            {
                self.navigationTitle.text = "اختيار المواد"
                self.navigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            }
        }
        else
        {
            self.navigationTitle.text = "Material Selection"
            self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func viewDetailsContents()
    {
        detailScrollView.frame = CGRect(x: (2 * x), y: navigationBar.frame.maxY + (2 * y), width: view.frame.width - (4 * x), height: view.frame.height - (30 * y))
        detailScrollView.backgroundColor = UIColor.clear
        detailScrollView.isPagingEnabled = true
        detailScrollView.delegate = self
        view.addSubview(detailScrollView)
        
        for view in detailScrollView.subviews
        {
            view.removeFromSuperview()
        }
        
        for index in 0..<viewDetailsImageArray.count
        {
            frame.origin.x = self.detailScrollView.frame.size.width * CGFloat(index)
            frame.size = self.detailScrollView.frame.size
            
            print("COLOR IMAGE ARRAY COUNT", colorArrayCount)
            
            let subImageView = UIImageView(frame: frame)
            //            subImageView.backgroundColor = colors[index]
            
            if let imageName =  viewDetailsImageArray[index] as? String
            {
                if colorArrayCount >= index
                {
                    let urlString = serviceCall.baseURL
                    let api = "\(urlString)/images/color/\(imageName)"
                    let apiurl = URL(string: api)
                    print("VIEW DETAILS IMAGE API", apiurl)
                    if apiurl != nil
                    {
                        subImageView.dowloadFromServer(url: apiurl!)
                    }
                }
                else
                {
                    let urlString = serviceCall.baseURL
                    let api = "\(urlString)/images/pattern/\(imageName)"
                    let apiurl = URL(string: api)
                    print("VIEW DETAILS IMAGE API", apiurl)
                    if apiurl != nil
                    {
                        subImageView.dowloadFromServer(url: apiurl!)
                    }
                }
            }
            subImageView.contentMode = .scaleAspectFit
            self.detailScrollView.addSubview(subImageView)
        }
        
        self.detailScrollView.contentSize = CGSize(width:self.detailScrollView.frame.size.width * CGFloat(viewDetailsImageArray.count),height: self.detailScrollView.frame.size.height)
        
        pageControl = UIPageControl(frame: CGRect(x: ((detailScrollView.frame.width - (20 * x)) / 2), y: detailScrollView.frame.maxY - (2 * y), width: (20 * x), height: (2 * y)))
        
        configurePageControl()
        
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
        
        
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: (2 * x), y: ((detailScrollView.frame.height - (3 * y)) / 2), width: (3 * x), height: (3 * y))
        leftButton.setImage(UIImage(named: "closeMenu"), for: .normal)
        leftButton.backgroundColor = UIColor.white
        //        detailsView.addSubview(leftButton)
        
        let rightButton = UIButton()
        rightButton.frame = CGRect(x: view.frame.width - (5 * x), y: ((detailScrollView.frame.height - (3 * y)) / 2), width: (3 * x), height: (3 * y))
        rightButton.setImage(UIImage(named: "openMenu"), for: .normal)
        rightButton.backgroundColor = UIColor.white
        //        detailsView.addSubview(rightButton)
        
        var x1:CGFloat = (2 * x)
        var y1:CGFloat = detailScrollView.frame.maxY + y
        
        var headingString = ["MATERIAL", "Seasonal", "Place Of Industry", "Brands", "Material Type", "Color"]
        
        for i in 0..<6
        {
            let detailLabel = UILabel()
            detailLabel.frame = CGRect(x: (2 * x), y: y1, width: (detailScrollView.frame.width / 2), height: (3 * y))
            detailLabel.text = headingString[i]
            detailLabel.textAlignment = .center
            view.addSubview(detailLabel)
            
            let getDetailLabel = UITextView()
            getDetailLabel.frame = CGRect(x: detailLabel.frame.maxX + 1, y: y1, width: (detailScrollView.frame.width / 2), height: (3 * y))
            
            if i == 0
            {
                if let strings = UserDefaults.standard.value(forKey: "pattern") as? String
                {
                    getDetailLabel.text = strings
                }
            }
            else if i == 1
            {
                if let strings = UserDefaults.standard.value(forKey: "season") as? [String]
                {
                    var appendString = String()
                    for i in 0..<strings.count
                    {
                        appendString.append(strings[i])
                    }
                    getDetailLabel.text = appendString
                }
            }
            else if i == 2
            {
                if let strings = UserDefaults.standard.value(forKey: "industry") as? [String]
                {
                    var appendString = String()
                    for i in 0..<strings.count
                    {
                        appendString.append(strings[i])
                    }
                    getDetailLabel.text = appendString
                }
            }
            else if i == 3
            {
                if let strings = UserDefaults.standard.value(forKey: "brand") as? [String]
                {
                    var appendString = String()
                    for i in 0..<strings.count
                    {
                        appendString.append(strings[i])
                    }
                    getDetailLabel.text = appendString
                }
            }
            else if i == 4
            {
                if let strings = UserDefaults.standard.value(forKey: "material") as? [String]
                {
                    var appendString = String()
                    for i in 0..<strings.count
                    {
                        appendString.append(strings[i])
                    }
                    getDetailLabel.text = appendString
                }
            }
            else if i == 5
            {
                if let strings = UserDefaults.standard.value(forKey: "color") as? [String]
                {
                    var appendString = String()
                    for i in 0..<strings.count
                    {
                        appendString.append(strings[i])
                    }
                    getDetailLabel.text = appendString
                }
            }
            
            getDetailLabel.isEditable = false
            getDetailLabel.textAlignment = .center
            view.addSubview(getDetailLabel)
            
            if i == 0
            {
                detailLabel.backgroundColor = UIColor.blue
                getDetailLabel.backgroundColor = UIColor.blue
                
                detailLabel.textColor = UIColor.white
                getDetailLabel.textColor = UIColor.white
            }
            else
            {
                detailLabel.backgroundColor = UIColor.white
                getDetailLabel.backgroundColor = UIColor.white
                
                detailLabel.textColor = UIColor.black
                getDetailLabel.textColor = UIColor.black
            }
            
            y1 = detailLabel.frame.maxY + 1
        }
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = viewDetailsImageArray.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.orange
        self.view.addSubview(pageControl)
    }
    
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * detailScrollView.frame.size.width
        detailScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
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
