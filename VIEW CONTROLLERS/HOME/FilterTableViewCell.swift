//
//  FilterTableViewCell.swift
//  Mzyoon
//
//  Created by QOL on 13/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    var filterImage : UIImageView!
    var filterName:UILabel!    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        filterName = UILabel()
        filterName.textColor = UIColor.black
        filterName.textAlignment = .left
        filterName.font = UIFont(name: "Gilroy-Regular", size: 12)
        contentView.addSubview(filterName)
        
        filterImage = UIImageView()
        contentView.addSubview(filterImage)
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
