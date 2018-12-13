//
//  TestViewController.swift
//  Mzyoon
//
//  Created by QOL on 07/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{

    let backgroundImage = UIImageView()
    let button = UIButton()
    var imagePicker = UIImagePickerController()

    override func viewDidLoad()
    {
        
        view.backgroundColor = UIColor.white

        backgroundImage.frame = CGRect(x: -250, y: 0, width: 2 * view.frame.width, height: view.frame.height)
        backgroundImage.image = UIImage(named: "imgpsh_fullsize")
        view.addSubview(backgroundImage)
        
        button.frame = CGRect(x: 50, y: 0, width: 100, height: 50)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(self.helpless(sender:)), for: .touchUpInside)
        view.addSubview(button)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc func helpless(sender : UIButton)
    {
        print("WELCOME TO HOME")
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            self.backgroundImage.image = pickedImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
