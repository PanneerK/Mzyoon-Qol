//
//  DashboardViewController.swift
//  Mzyoon
//
//  Created by QOL on 16/10/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit
import ImageIO

class DashboardViewController: UIViewController, UIScrollViewDelegate
{

    var x = CGFloat()
    var y = CGFloat()
    
    
    override func viewDidLoad()
    {
        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
        
        screenContents()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func screenContents()
    {
        let backgroundImage = UIImageView()
        backgroundImage.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        backgroundImage.image = UIImage(named: "giphy")
        view.addSubview(backgroundImage)
        
        let navigationbar = UIView()
        navigationbar.frame = CGRect(x: 0, y: 20, width: view.frame.width, height: 44)
        navigationbar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
//        view.addSubview(navigationbar)
        
        let menuButton = UIButton()
        menuButton.frame = CGRect(x: (2 * x), y: y, width: (2 * x), height: (2.4 * y))
        menuButton.setTitle("M", for: .normal)
        navigationbar.addSubview(menuButton)
        
        let notificationButton = UIButton()
        notificationButton.frame = CGRect(x: (navigationbar.frame.width - (4 * x)), y: y, width: (2 * x), height: (2.4 * y))
        notificationButton.setTitle("N", for: .normal)
        navigationbar.addSubview(notificationButton)
        
        let productScrollView = UIScrollView()
        productScrollView.frame = CGRect(x: 0, y: navigationbar.frame.maxY, width: view.frame.width, height: 150)
        productScrollView.backgroundColor = UIColor.orange
        productScrollView.isPagingEnabled = true
        productScrollView.contentSize.width = (3 * view.frame.width)
        productScrollView.delegate = self
//        view.addSubview(productScrollView)
        
        var x1:CGFloat = 0
        
        for i in 0..<3
        {
            let contentImage = UIImageView()
            contentImage.frame = CGRect(x: x1, y: 0, width: view.frame.width, height: productScrollView.frame.height)
            contentImage.backgroundColor = UIColor.cyan
            productScrollView.addSubview(contentImage)
            
            x1 = contentImage.frame.maxX
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
