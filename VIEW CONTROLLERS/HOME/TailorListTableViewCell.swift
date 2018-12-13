//
//  TailorListTableViewCell.swift
//  Mzyoon
//
//  Created by QOL on 28/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class TailorListTableViewCell: UITableViewCell {
    
    var tailorImage:UIImageView!
    var tailorName:UILabel!
    var tailorShopName:UILabel!
    var tailorOrdersCount:UILabel!
    var tailorDirection:UIButton!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        tailorName = UILabel()
        tailorName.textColor = UIColor.black
        tailorName.textAlignment = .left
        tailorName.font = UIFont(name: "Gilroy-Regular", size: 12)
        contentView.addSubview(tailorName)
        
        tailorImage = UIImageView()
        contentView.addSubview(tailorImage)
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
