//
//  PartsTableViewCell.swift
//  Mzyoon
//
//  Created by QOL on 30/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class PartsTableViewCell: UITableViewCell {
    
    var partsImage : UIImageView!
    var partsName:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        partsName = UILabel()
//        partsName.backgroundColor = UIColor.cyan
        partsName.textColor = UIColor.black
        partsName.textAlignment = .left
        partsName.font = UIFont(name: "Gilroy-Regular", size: 12)
        contentView.addSubview(partsName)
        
        partsImage = UIImageView()
//        partsImage.backgroundColor = UIColor.green
        contentView.addSubview(partsImage)
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
