//
//  OrderCustomizationToJson.swift
//  Mzyoon
//
//  Created by QOL on 08/02/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import Foundation
import UIKit

class OrderCustomizationToJson
{
    class Customization: NSObject {
        
        var attributeId: Int?
        var attributeImageId : Int?
        
        init(AttId: Int) {
            self.attributeId = AttId
        }
        
        init(ImgId : Int){
            self.attributeImageId = ImgId
        }
        
        func getDictFormat() -> [String: Int]{
            return ["CustomizationAttributeId" : attributeId!]
        }
        
        func getDictFormat1() -> [String : Int]{
            return ["AttributeImageId" : attributeImageId!]
        }
    }
    
    func AttIdMakeRequest(attId : [Int]) -> ([[String: Int]])
    {
        var array1 = [Customization]()
        
        for i in 0..<attId.count
        {
            array1.append(Customization(AttId: attId[i]))
        }
        
        var List1 = [[String: Int]]()
        
        for item in array1 {
            
            List1.append(item.getDictFormat())
        }
        
        return List1
    }
    
    func AttImgIdMakeRequest(imgId : [Int]) -> ([[String: Int]])
    {
        var array1 = [Customization]()
        
        for i in 0..<imgId.count
        {
            array1.append(Customization(ImgId: imgId[i]))
        }
        
        var List1 = [[String: Int]]()
        
        for item in array1 {
            
            List1.append(item.getDictFormat1())
        }
        
        return List1
    }
    
    func makeRequest(attId : [Int], imgId : [Int]) -> [[String: Int]]
    {
        var List1 = [[String: Int]]()

        for i in 0..<imgId.count
        {
            List1.append(["CustomizationAttributeId" : attId[i], "AttributeImageId" : imgId[i]])
        }

        return List1
    }
    
    func userMeasurementRequest(id : [Int], values : [Float]) -> [[String: Any]]
    {
        var List1 = [[String: Any]]()
        
        for i in 0..<id.count
        {
            List1.append(["UserMeasurementId" : id[i], "Value" : values[i]])
        }
        
        return List1
    }
    
    func referenceImage(image : [UIImage]) -> [[String: Any]]
    {
        var List1 = [[String: Any]]()
        
        for i in 0..<image.count
        {
            List1.append(["Image" : image[i]])
        }
        
        return List1
    }
}
