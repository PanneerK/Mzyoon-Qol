//
//  UserViewController.swift
//  Mzyoon
//
//  Created by QOL on 01/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{

    var x = CGFloat()
    var y = CGFloat()
    
    let getUserImage = UIImageView()
    var imagePicker = UIImagePickerController()

    
    override func viewDidLoad()
    {
        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
        
        screenContents()
        
        let closeKeyboard = UITapGestureRecognizer(target: self, action: #selector(self.closeKeyboard(gesture:)))
        closeKeyboard.delegate = self
        view.addGestureRecognizer(closeKeyboard)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "PROFILE"
    }
    
    @objc func closeKeyboard(gesture : UITapGestureRecognizer)
    {
        view.endEditing(true)
    }

    
    func screenContents()
    {
        let backgroundImage = UIImageView()
        backgroundImage.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        backgroundImage.image = UIImage(named: "background")
        view.addSubview(backgroundImage)
        
        getUserImage.frame = CGRect(x: ((view.frame.width - 200) / 2), y: 150, width: 200, height: 200)
        getUserImage.layer.cornerRadius = getUserImage.frame.height / 2
        getUserImage.layer.masksToBounds = true
        getUserImage.layer.borderWidth = 2
        view.addSubview(getUserImage)
        
        let photoButton = UIButton()
        photoButton.frame = CGRect(x: getUserImage.frame.maxX - 50, y: getUserImage.frame.maxY - 60, width: 60, height: 60)
        photoButton.layer.cornerRadius = photoButton.frame.height / 2
        photoButton.layer.masksToBounds = true
        photoButton.backgroundColor = UIColor.white
        photoButton.setImage(UIImage(named: "camera"), for: .normal)
        photoButton.addTarget(self, action: #selector(self.photoButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(photoButton)
        
        let userNameTextField = UITextField()
        userNameTextField.frame = CGRect(x: (2 * x), y: photoButton.frame.maxY + (4 * y), width: view.frame.width - (4 * x), height: 40)
        userNameTextField.placeholder = "Enter your name"
        userNameTextField.textColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        userNameTextField.textAlignment = .left
        userNameTextField.font = UIFont(name: "Avenir-Regular", size: 30)
        userNameTextField.keyboardType = .default
        userNameTextField.returnKeyType = .done
        userNameTextField.clearsOnBeginEditing = true
        userNameTextField.delegate = self
        view.addSubview(userNameTextField)
        
        let nameUnderline = UILabel()
        nameUnderline.frame = CGRect(x: (2 * x), y: userNameTextField.frame.maxY + 2, width: view.frame.width - (4 * x), height: 1)
        nameUnderline.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(nameUnderline)
        
        let saveButton = UIButton()
        saveButton.frame = CGRect(x: (2 * x), y: userNameTextField.frame.maxY + (5 * y), width: view.frame.width - (4 * x), height: 40)
        saveButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        saveButton.setTitle("SAVE", for: .normal)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        view.addSubview(saveButton)
    }
    
    @objc func photoButtonAction(sender : UIButton)
    {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        getUserImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
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
