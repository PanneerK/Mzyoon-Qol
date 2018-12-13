//
//  CountryCodeTableViewCell.swift
//  Mzyoon
//
//  Created by QOL on 17/10/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class CountryCodeTableViewCell: UITableViewCell
{
    var flagImage : UIImageView!
    var countryName:UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        flagImage = UIImageView()
        contentView.addSubview(flagImage)
        
        countryName = UILabel()
        countryName.textColor = UIColor.black
        countryName.textAlignment = .left
        countryName.font = UIFont(name: "Gilroy-Regular", size: 12)
        contentView.addSubview(countryName)
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
