//
//  TrackingTableViewCell.swift
//  Mzyoon
//
//  Created by QOLSoft on 02/01/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class TrackingTableViewCell: UITableViewCell
{
    
    let TrackerImg = UIImageView()
    let TrackingDetails = UILabel()
    let TrackingDate = UILabel()
    let TrackingTime = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        TrackerImg.backgroundColor = UIColor.blue
        
       // TrackerImg.translatesAutoresizingMaskIntoConstraints = false
       // TrackingDetails.translatesAutoresizingMaskIntoConstraints = false
      //  TrackingDate.translatesAutoresizingMaskIntoConstraints = false
      //  TrackingTime.translatesAutoresizingMaskIntoConstraints = false
        
        TrackingDate.frame = CGRect(x: 5 , y: contentView.frame.width, width: 10, height: 10)
         TrackingDate.backgroundColor = UIColor.gray
        //TrackingDate.text = "Sun, 09 Dec"
        TrackingDate.font = UIFont(name: "Avenir Next", size: 12)
        TrackingDate.textColor = UIColor.black
        contentView.addSubview(TrackingDate)
        
        TrackingDetails.frame = CGRect(x: TrackingDate.frame.width + 10 , y: contentView.frame.width, width: contentView.frame.width / 2, height: 10)
         TrackingDetails.backgroundColor = UIColor.gray
       // TrackingDetails.text = "your order has been placed successfully"
        TrackingDate.font = UIFont(name: "Avenir Next", size: 12)
        TrackingDate.textColor = UIColor.black
        contentView.addSubview(TrackingDetails)
        
        //contentView.addSubview(TrackerImg)
        //contentView.addSubview(TrackingDetails)
        //contentView.addSubview(TrackingDate)
        // contentView.addSubview(TrackingTime)
     
     /*
        let viewsDict = [
            "TrackImage" : TrackerImg,
            "TrackDetails" : TrackingDetails,
            "TrackDate" : TrackingDate,
            "TrackTime" : TrackingTime,
            ] as [String : Any]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[TrackImage(10)]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[TrackTime]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[TrackingDetails]-[TrackDate]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[TrackingDetails]-[TrackImage(10)]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[message]-[TrackTime]-|", options: [], metrics: nil, views: viewsDict))
        
        */
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
 /*
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 */
}
