//
//  NewOrderViewController.swift
//  Mzyoon
//
//  Created by QOL on 15/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class NewOrderViewController: UIViewController
{
    override func viewDidLoad()
    {
        view.backgroundColor = UIColor.cyan
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        self.navigationController?.isNavigationBarHidden = true
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
