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
    /*
    let TrackerImg = UIImageView()
    let TrackingDetails = UILabel()
    let TrackingDate = UILabel()
    let TrackingTime = UILabel()
    */
    
    var x = CGFloat()
    var y = CGFloat()
    
    var contentSpace : UIView!
    var spaceView : UIView!
    
    var TrackerImg : UIImageView!
    var TrackingDetails : UILabel!
    var TrackingDate : UILabel!
    var TrackingTime : UILabel!
    
    var roundLabel:UILabel!
    var lineLabel:UILabel!
    
    
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
       //  TrackerImg.backgroundColor = UIColor.blue
        
        contentSpace = UIView()
        contentSpace.backgroundColor = UIColor.white   //UIColor(red: 0.9451, green: 0.9373, blue: 0.9373, alpha: 1.0)
        contentView.addSubview(contentSpace)
        
        TrackingDate = UILabel()
       // TrackingDate.backgroundColor = UIColor.lightGray
        TrackingDate.textColor = UIColor.black
        TrackingDate.textAlignment = .left
        TrackingDate.font = UIFont(name: "Avenir Next", size: 12)
        contentSpace.addSubview(TrackingDate)
        
        TrackerImg = UIImageView()
        //TrackerImg.backgroundColor = UIColor.green
        contentSpace.addSubview(TrackerImg)
        
        TrackingTime = UILabel()
        //TrackingTime.backgroundColor = UIColor.white
        TrackingTime.textColor = UIColor.black
        TrackingTime.textAlignment = .left
        TrackingTime.font = UIFont(name: "Avenir Next", size: 12)
        contentSpace.addSubview(TrackingTime)
        
        TrackingDetails = UILabel()
       // TrackingDetails.backgroundColor = UIColor.lightGray
        TrackingDetails.textColor = UIColor.black
        TrackingDetails.textAlignment = .left
        TrackingDetails.font = UIFont(name: "Avenir Next", size: 12)
        contentSpace.addSubview(TrackingDetails)
        
        spaceView = UIView()
        spaceView.backgroundColor = UIColor.clear
        contentView.addSubview(spaceView)
        
        roundLabel = UILabel()
        roundLabel.backgroundColor = UIColor.lightGray
        roundLabel.layer.masksToBounds = true
        contentSpace.addSubview(roundLabel)
        
        lineLabel = UILabel()
        lineLabel.backgroundColor = UIColor.lightGray
        contentSpace.addSubview(lineLabel)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
    }
    
    override func layoutSubviews()
    {
        
        super.layoutSubviews()
        
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
