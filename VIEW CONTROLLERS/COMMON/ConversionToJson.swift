//
//  ConversionToJson.swift
//  Mzyoon
//
//  Created by QOL on 05/02/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import Foundation

class ConversionToJson
{
    class Customization: NSObject {
        
        var Id: Int?
        
        init(Id: Int) {
            self.Id = Id
        }
        
        func getDictFormat() -> [String: Int]{
            return ["Id" : Id!]
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
}
