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
    
    var contentSpace : UIView!
    var TrackerImg : UIImageView!
    var TrackingDetails : UILabel!
    var TrackingDate : UILabel!
    var TrackingTime : UILabel!
    var spaceView : UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       //  TrackerImg.backgroundColor = UIColor.blue
        
      
    
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
