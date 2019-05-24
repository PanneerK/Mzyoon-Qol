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
    
    //
    
    public static let purple: UIColor = ("#7e51df").hexStringToUIColor()
    public static let appBlue: UIColor = ("#346af8").hexStringToUIColor()
    public static let switchBlue: UIColor = ("#346af8").hexStringToUIColor()
    
    public static let btnSelectedColor: UIColor = ("#fe924a").hexStringToUIColor()
    public static let menuSelectedColor: UIColor = ("#33b5de").hexStringToUIColor()
    public static let btnDisabledColor: UIColor = ("#cbcbcb").hexStringToUIColor()//("#bfc0c1")
    public static let switchBackground: UIColor = ("#ebebeb").hexStringToUIColor()
    
    //in
    public static let login_background: UIColor = ("#8dd558").hexStringToUIColor()
    public static let login_storke: UIColor = ("#27864f").hexStringToUIColor()
    public static let login_finished: UIColor = ("#6cbb33").hexStringToUIColor()
    public static let login_unfinished: UIColor = ("#e6f0df").hexStringToUIColor()
    
    //out
    public static let logout_background: UIColor = ("#e03939").hexStringToUIColor()
    public static let logout_storke: UIColor = ("#862729").hexStringToUIColor()
    public static let logout_finished: UIColor = ("#bf1a1a").hexStringToUIColor()
    public static let logout_unfinished: UIColor = ("#f0dfdf").hexStringToUIColor()
    
    //Share Page
    public static let headerBlue: UIColor = ("#33b5de").hexStringToUIColor()
    public static let recentShareBg: UIColor = ("#e7f9fe").hexStringToUIColor()
    public static let orangeBtn: UIColor = ("#ee9534").hexStringToUIColor()
    public static let durationBlue: UIColor = ("#33b5de").hexStringToUIColor()
    public static let bodyBg: UIColor = ("#f8f7f7").hexStringToUIColor()
    public static let navigationPath: UIColor = ("#006d98").hexStringToUIColor()
    
    public static let destinationSelectedColor: UIColor = ("#96bf25").hexStringToUIColor()
    public static let destinationDisabledColor: UIColor = ("#282c3f").hexStringToUIColor()
    public static let contactsTagColor: UIColor = ("#b9e4f4").hexStringToUIColor()
    
    public static let headerTitleColor: UIColor = ("#465167").hexStringToUIColor()
    
    public static let shadowColor: UIColor = ("#d3d3d3").hexStringToUIColor()
    public static let sideMenuProfileBorder: UIColor = ("#5dcbee").hexStringToUIColor()
    
    
    //open static let statusBarColor: UIColor = ("#244dc6").hexStringToUIColor()
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

