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
        var compareId = Int()
//        var List1 = [[String: Int]]()
        var checkList = [[String: Int]]()
 
        for i in 0..<attId.count
        {
            if compareId == nil || compareId == 0
            {
                checkList.insert(["CustomizationAttributeId" : attId[i], "AttributeImageId" : imgId[i]], at: i)
                compareId = attId[i]
            }
            else
            {
                if compareId > attId[i]
                {
                    let count = checkList.count
                    checkList.insert(["CustomizationAttributeId" : attId[i], "AttributeImageId" : imgId[i]], at: (i - count))
                    compareId = attId[i]
                }
                else
                {
                    checkList.insert(["CustomizationAttributeId" : attId[i], "AttributeImageId" : imgId[i]], at: i)
                    compareId = attId[i]
                }
            }
            
//            List1.append(["CustomizationAttributeId" : attId[i], "AttributeImageId" : imgId[i]])
            print("List1", attId[i])
            print("CHECK LIST", checkList)
        }
        
        print("CHECK LIST OUT OF FOR LOOP", checkList)
        return checkList
    }
    
    func userMeasurementRequest(id : [Int], values : [Float]) -> [[String: Any]]
    {
        var List1 = [[String: Any]]()
        
        for i in 0..<id.count
        {
            List1.append(["MeasurementId" : id[i], "Value" : values[i]])
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
    
    func tailorId(id : [Int]) -> [[String: Any]]
    {
        var List1 = [[String: Any]]()
        
        for i in 0..<id.count
        {
            List1.append(["Id" : id[i]])
        }
        
        return List1
    }
}
