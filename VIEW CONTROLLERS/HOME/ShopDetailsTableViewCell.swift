//
//  ShopDetailsTableViewCell.swift
//  Mzyoon
//
//  Created by QOLSoft on 05/03/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class ShopDetailsTableViewCell: UITableViewCell
{
     var DaysName:UILabel!
     var ShopTime:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        DaysName = UILabel()
        DaysName.textColor = UIColor.black
        DaysName.textAlignment = .left
        DaysName.font = UIFont(name: "Avenir Next", size: 14)
        contentView.addSubview(DaysName)
        
        ShopTime = UILabel()
        ShopTime.textColor = UIColor.black
        ShopTime.textAlignment = .left
        ShopTime.font = UIFont(name: "Avenir Next", size: 14)
        contentView.addSubview(ShopTime)
    }
    required init(coder aDecoder: NSCoder)
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

}
