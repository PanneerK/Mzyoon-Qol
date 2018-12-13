//
//  ActivityView.swift
//  Mzyoon
//
//  Created by QOL on 31/10/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class ActivityView: UIView
{
    let activity = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addCustomView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCustomView()
    {
        activity.frame = CGRect(x: ((self.frame.width - 50) / 2), y: ((self.frame.height - 50) / 2), width: 50, height: 50)
        activity.style = .whiteLarge
        activity.color = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        self.addSubview(activity)
    }
    
    func startActivity()
    {
        activity.startAnimating()
    }
    
    func stopActivity()
    {
        activity.stopAnimating()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
