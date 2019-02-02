//
//  PartsTableViewCell.swift
//  Mzyoon
//
//  Created by QOL on 30/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class PartsTableViewCell: UITableViewCell
{
    
    var contentSpace:UIView!
    var partsImage : UIImageView!
    var partsName:UILabel!
    var partsSizeLabel:UILabel!
    var spaceView:UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentSpace = UIView()
        contentSpace.backgroundColor = UIColor(red: 0.9451, green: 0.9373, blue: 0.9373, alpha: 1.0)
        contentView.addSubview(contentSpace)
        
        partsName = UILabel()
        //        partsName.backgroundColor = UIColor.cyan
        partsName.textColor = UIColor.black
        partsName.textAlignment = .left
        partsName.font = UIFont(name: "Gilroy-Regular", size: 12)
        contentSpace.addSubview(partsName)
        
        partsImage = UIImageView()
        //        partsImage.backgroundColor = UIColor.green
        contentSpace.addSubview(partsImage)
        
        partsSizeLabel = UILabel()
        //        partsSizeLabel.backgroundColor = UIColor.white
        partsSizeLabel.text = "0.0"
        partsSizeLabel.textColor = UIColor.black
        partsSizeLabel.textAlignment = .left
        partsSizeLabel.font = UIFont(name: "Gilroy-Regular", size: 10)
        contentSpace.addSubview(partsSizeLabel)
        
        spaceView = UIView()
        spaceView.backgroundColor = UIColor.clear
        contentView.addSubview(spaceView)
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
