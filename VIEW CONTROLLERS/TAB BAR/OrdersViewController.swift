//
//  OrdersViewController.swift
//  Mzyoon
//
//  Created by QOL on 29/10/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class OrdersViewController: CommonViewController
{
    
    override func viewDidLoad()
    {
        navigationTitle.text = "ORDER"
        
        view.backgroundColor = UIColor.black
        
        self.tab2Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        screenContents()
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        // Show the Navigation Bar
//        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController?.navigationBar.topItem?.title = "ORDERS"        
//    }
    
    func screenContents()
    { 
        let backgroundImage = UIImageView()
        backgroundImage.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        backgroundImage.image = UIImage(named: "background")
        view.addSubview(backgroundImage)
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
