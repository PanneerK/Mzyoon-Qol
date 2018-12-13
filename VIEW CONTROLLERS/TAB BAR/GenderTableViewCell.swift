//
//  GenderTableViewCell.swift
//  Mzyoon
//
//  Created by QOL on 13/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class GenderTableViewCell: UITableViewCell {

    var selectImage : UIImageView!
    var genderName:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectImage = UIImageView()
        contentView.addSubview(selectImage)
        
        genderName = UILabel()
        genderName.textColor = UIColor.black
        genderName.textAlignment = .left
        genderName.font = UIFont(name: "Gilroy-Regular", size: 12)
        contentView.addSubview(genderName)
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
