//
//  FileHandler.swift
//  SimpleTruckELD
//
//  Created by Sasikumar on 12/6/17.
//  Copyright © 2017 triesten. All rights reserved.
//

import Foundation
import UIKit

class FileHandler {
    
    func saveImageDocumentDirectory(image: UIImage){
        let path = imagePath()
        let image = image
        print(path)
        
//        let imageData = UIImageJPEGRepresentation(image, 0.5)
        let imageData = image.jpegData(compressionQuality: 0.5)

        FileManager.default.createFile(atPath: path, contents: imageData, attributes: nil)
    }
    
    func getImageFromDocumentDirectory() -> UIImage? {
        if FileManager.default.fileExists(atPath: imagePath()){
           return UIImage(contentsOfFile: imagePath())
        }else{
            return nil
        }
    }
    
    func getImageAsBase64() -> String? {

        let image = getImageFromDocumentDirectory()
        if let image = image{
            let imageData:NSData = image.pngData()! as NSData
            return imageData.base64EncodedString(options: .lineLength64Characters)
        }
        return nil
    }
    
    func removeImage() {
        do {
            try FileManager.default.removeItem(atPath: imagePath())
        }catch {
            
        }
    }
    
    func imagePath() -> String{
        return (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("signature.png")
    }
}



    
