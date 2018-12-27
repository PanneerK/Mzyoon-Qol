//
//  MeasurementCall.swift
//  Mzyoon
//
//  Created by QOL on 27/12/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import Foundation

@objc protocol MeasurementCall
{
    @objc optional func MeasurementCallBack(measurement : String)
}
