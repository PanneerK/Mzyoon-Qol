//
//  DressTypeCollectionViewCell.swift
//  Mzyoon
//
//  Created by QOL on 01/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class DressTypeCollectionViewCell: UICollectionViewCell
{
    
    var dressTypeImage: UIImageView!
    var dressTypeName: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dressTypeImage = UIImageView()
        dressTypeImage.contentMode = .scaleAspectFill
        dressTypeImage.isUserInteractionEnabled = false
        contentView.addSubview(dressTypeImage)
        
        dressTypeName = UILabel()
        dressTypeName.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        dressTypeName.textColor = UIColor.white
        dressTypeName.textAlignment = .center
        contentView.addSubview(dressTypeName)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var frame = dressTypeImage.frame
        frame.size.height = self.frame.size.height
        frame.size.width = self.frame.size.width
        frame.origin.x = 0
        frame.origin.y = 0
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
