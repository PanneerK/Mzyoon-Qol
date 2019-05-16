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
    let customLoader = UIImageView()
    let customLoading = UIImageView()
    let backgroundCircle = UIView()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addCustomView()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCustomView()
    {
        var x:CGFloat = 10 / 375 * 100
        x = x * UIScreen.main.bounds.width / 100
        
        var y:CGFloat = 10 / 667 * 100
        y = y * UIScreen.main.bounds.height / 100
        
        backgroundCircle.frame = CGRect(x: ((UIScreen.main.bounds.width - (10 * y)) / 2), y: ((UIScreen.main.bounds.height - (10 * y)) / 2), width: (10 * y), height: (10 * y))
        backgroundCircle.layer.cornerRadius = backgroundCircle.frame.height / 2
        backgroundCircle.backgroundColor = UIColor.black
        self.addSubview(backgroundCircle)
        
        let imagesArray = [UIImage(named: "loader1"), UIImage(named: "loader2"), UIImage(named: "loader3"), UIImage(named: "loader4"), UIImage(named: "loader5"), UIImage(named: "loader6"), UIImage(named: "loader7"), UIImage(named: "loader8")]
        
        customLoader.frame = CGRect(x: ((backgroundCircle.frame.width - (5 * x)) / 2), y: (2 * y), width: (5 * x), height: backgroundCircle.frame.height - (4 * y))
        //        customLoader.backgroundColor = UIColor.gray
        customLoader.animationImages = imagesArray as? [UIImage]
        customLoader.animationDuration = 5.0
        customLoader.startAnimating()
        backgroundCircle.addSubview(customLoader)
        
        let imagesArray1 = [UIImage(named: "loading1"), UIImage(named: "loading2"), UIImage(named: "loading3")]
        let imagesArray2 = [UIImage(named: "loadingArabic1"), UIImage(named: "loadingArabic2"), UIImage(named: "loadingArabic3")]
        
        customLoading.frame = CGRect(x: ((UIScreen.main.bounds.width - (8 * x)) / 2), y: backgroundCircle.frame.maxY + y, width: (8 * x), height: y)
        //        customLoading.backgroundColor = UIColor.gray
        customLoading.layer.cornerRadius = customLoader.frame.height / 2
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                customLoading.animationImages = imagesArray1 as? [UIImage]
                customLoading.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                customLoader.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            else if language == "ar"
            {
                customLoading.animationImages = imagesArray2 as? [UIImage]
                customLoading.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                customLoader.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            }
        }
        else
        {
            customLoading.animationImages = imagesArray1 as? [UIImage]
            customLoading.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            customLoader.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        customLoading.animationDuration = 2.0
        customLoading.startAnimating()
        self.addSubview(customLoading)
    }
    
    func startActivity()
    {
        
    }
    
    func stopActivity()
    {
        self.removeFromSuperview()
        customLoader.stopAnimating()
        customLoading.stopAnimating()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
