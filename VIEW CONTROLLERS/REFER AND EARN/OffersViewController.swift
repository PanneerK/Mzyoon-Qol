//
//  OffersViewController.swift
//  Mzyoon
//
//  Created by QOL on 17/05/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class OffersViewController: CommonViewController
{
    let selfScreenContents = UIView()
    let offersHorizontalScrollView = UIScrollView()
    var pageControl : UIPageControl = UIPageControl(frame: CGRect(x:50,y: 300, width:200, height:50))
    
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    
    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]

    let page1 = UIScrollView()
    let page2 = UIScrollView()

    
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
        
        offersHorizontalScrollView.frame = CGRect(x: 0, y: offerButtonScrollView.frame.maxY, width: selfScreenContents.frame.width, height: selfScreenContents.frame.height - (offerButtonScrollView.frame.maxY))
        offersHorizontalScrollView.backgroundColor = UIColor.gray
        selfScreenContents.addSubview(offersHorizontalScrollView)
        
        for index in 0..<colors.count
        {
            frame.origin.x = offersHorizontalScrollView.frame.size.width * CGFloat(index)
            frame.size = offersHorizontalScrollView.frame.size
            
            let subView = UIView(frame: frame)
            subView.backgroundColor = colors[index]
            subView.tag = ((index * 1) + 500)
            offersHorizontalScrollView.addSubview(subView)
        }
        
        offersHorizontalScrollView.contentSize.width = (CGFloat(colors.count) * offersHorizontalScrollView.frame.width)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
        
        /*page1.frame = CGRect(x: 0, y: 0, width: offersHorizontalScrollView.frame.width, height: offersHorizontalScrollView.frame.width)
        page1.backgroundColor = UIColor.green
        offersHorizontalScrollView.addSubview(page1)

        page2.frame = CGRect(x: page1.frame.width, y: 0, width: offersHorizontalScrollView.frame.width, height: offersHorizontalScrollView.frame.width)
        page2.backgroundColor = UIColor.red
        offersHorizontalScrollView.addSubview(page2)*/
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func offersButtonAction(sender : UIButton)
    {
        if sender.tag == 1
        {
            
        }
        else
        {
            
        }
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = 10
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
        self.view.addSubview(pageControl)
        
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
