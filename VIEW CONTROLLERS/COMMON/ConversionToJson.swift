//
//  ConversionToJson.swift
//  Mzyoon
//
//  Created by QOL on 05/02/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import Foundation
import UIKit

class ConversionToJson
{
    class Customization: NSObject {
        
        var Id: Int?
        var name : UIImage?
        
        init(Id: Int) {
            self.Id = Id
        }
        
        init(name : UIImage){
            self.name = name
        }
        
        func getDictFormat() -> [String: Int]{
            return ["Id" : Id!]
        }
        
        func getDictFormat1() -> [String : UIImage]{
            return ["Image" : name!]
        }
    }
    
    func MakeRequest(id : [Int]) -> ([[String: Int]])
    {
        var array1 = [Customization]()
        
        for i in 0..<id.count
        {
            array1.append(Customization(Id: id[i]))
        }
        
        var List1 = [[String: Int]]()
        
        for item in array1 {
            
            List1.append(item.getDictFormat())
        }
        
        return List1
    }
    
    func imageRequest(imageName : [UIImage]) -> [[String: UIImage]]
    {
        var array1 = [Customization]()
        
        for i in 0..<imageName.count
        {
            array1.append(Customization(name: imageName[i]))
        }
        
        var List1 = [[String: UIImage]]()
        
        for item in array1 {
            
            List1.append(item.getDictFormat1())
        }
        
        return List1
    }
}
