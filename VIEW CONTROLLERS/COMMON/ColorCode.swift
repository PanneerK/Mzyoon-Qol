//
//  ColorCode.swift
//  Mzyoon
//
//  Created by QOL on 24/05/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import Foundation
import UIKit


class ColorCode:NSObject
{
    //MZYOON COLORS
    public static let navigationBarColor:UIColor = ("#194ec2").hexStringToUIColor()
    public static let genderColor:UIColor = ("#494a4c").hexStringToUIColor()
    public static let buttonColor:UIColor = ("#0c2c75").hexStringToUIColor()
    
}

extension String {
    
    func hexStringToUIColor () -> UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UITextField {
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        print("sender tag ====== ",self.tag)
        print(#selector(UIResponderStandardEditActions.cut))
        if self.tag == 1112131415 || self.tag == 2122232425
        {
            return false
        }
        return super.canPerformAction(action, withSender:sender)
    }
}

