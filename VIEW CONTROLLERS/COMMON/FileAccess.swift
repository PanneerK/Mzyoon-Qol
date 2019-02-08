//
//  FileAccess.swift
//  Mzyoon
//
//  Created by QOL on 08/02/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import Foundation
import UIKit

class FileAccess {

    func getDirectoryPath() -> NSURL {
        let path1 = configureDirectory()
        
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("Mzyoon")
        let url = NSURL(string: path1)
        return url!
    }
    
    func saveImageDocumentDirectory(image: UIImage, imageName: String, imageType : String) {
        let path1 = configureDirectory()
        
        let fileManager = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageType)
        if !fileManager.fileExists(atPath: path) {
            try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        let url = NSURL(string: path1)
        let imagePath = url!.appendingPathComponent(imageName)
        print("IMAGE PATH 1", imagePath)
        let urlString: String = imagePath!.absoluteString
        let imageData = image.jpegData(compressionQuality: 0.5)
        //let imageData = UIImagePNGRepresentation(image)
        fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
    }
    
    func getImageFromDocumentDirectory(imageName : String) -> UIImage {
        var returnImage = UIImage()
        let fileManager = FileManager.default
        for i in 0..<1 {
            let imagePath = (self.getDirectoryPath() as NSURL).appendingPathComponent(imageName)
            let urlString: String = imagePath!.absoluteString
            if fileManager.fileExists(atPath: urlString) {
                let image = UIImage(contentsOfFile: urlString)
//                self.userImage.image = image
                
                returnImage =  image!
            } else {
                // print("No Image")
            }
        }
        
        return returnImage
    }
    
    func configureDirectory() -> String {
        let fileManager = FileManager.default
        
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("Mzyoon")
        if !fileManager.fileExists(atPath: path) {
            try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }
    
    func deleteDirectory(imageType : String) {
        let fileManager = FileManager.default
        let yourProjectImagesPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageType)
        if fileManager.fileExists(atPath: yourProjectImagesPath) {
            try! fileManager.removeItem(atPath: yourProjectImagesPath)
        }
        let yourProjectDirectoryPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("Mzyoon")
        if fileManager.fileExists(atPath: yourProjectDirectoryPath) {
            try! fileManager.removeItem(atPath: yourProjectDirectoryPath)
        }
    }
}
