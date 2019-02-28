//
//  Variables.swift
//  Mzyoon
//
//  Created by QOL on 26/02/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class Variables: NSObject
{
    public var firstName:String = ""
    public var secondName:String = ""
    public var countryName:String = ""
    public var stateName:String = ""
    public var areaName:String = ""
    public var floor:String = ""
    public var landmark:String = ""
    public var locationType:String = ""
    public var mobileNumber:String = ""
    public var countryCode:String = ""
    public var shippingNotes:String = ""
    
    public var countryCodeId:Int = 0
    public var countryId:Int = 0
    public var stateId:Int = 0
    public var areaId:Int = 0
    public var checkDefaultId:Int = 0

    public var individualAddressId:Int = 0

    // Here is how you would get to it without there being a global collision of variables.
    // , or in other words, it is a globally accessable parameter that is specific to the
    // class.
    class var sharedManager: Variables
    {
        struct Static
        {
            static let instance = Variables()
        }
        return Static.instance
    }    
}
