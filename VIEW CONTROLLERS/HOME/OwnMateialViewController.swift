//
//  OwnMateialViewController.swift
//  Mzyoon
//
//  Created by QOL on 16/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class OwnMateialViewController: CommonViewController, ServerAPIDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    //ADD MATERIAL PARAMETERS
    let addMaterialView = UIView()
    let addMaterialImage = UIImageView()
    
    //ADD MATERIAL PAGE PARAMETERS
    var materialCount = 0
    var imagePicker = UIImagePickerController()
    let addMaterialScrolView = UIScrollView()
    let addMaterialImageCollection = UIButton()
    var imageArray = [UIImage]()
    
    var selectedImage = UIImage()
    var selectedTag = Int()
    
    // Error PAram...
    var DeviceNum:String!
    var UserType:String!
    var AppVersion:String!
    var ErrorStr:String!
    var PageNumStr:String!
    var MethodName:String!
    
    let serviceCall = ServerAPI()
    
    override func viewDidLoad()
    {
        self.tab1Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of seconds
            // Your code with delay
            self.addMaterialContent()
        }
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func DeviceError()
    {
        DeviceNum = UIDevice.current.identifierForVendor?.uuidString
        AppVersion = UIDevice.current.systemVersion
        UserType = "customer"
        ErrorStr = "Default Error"
        PageNumStr = "First"
        MethodName = "do"
        
        print("UUID", UIDevice.current.identifierForVendor?.uuidString as Any)
        self.serviceCall.API_InsertErrorDevice(DeviceId: DeviceNum, PageName: PageNumStr, MethodName: MethodName, Error: ErrorStr, ApiVersion: AppVersion, Type: UserType, delegate: self)
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String) {
        print("OWN MATERIAL", errorMessage)
    }
  
    
    func API_CALLBACK_InsertErrorDevice(deviceError: NSDictionary)
    {
        let ResponseMsg = deviceError.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = deviceError.object(forKey: "Result") as! String
            print("Result", Result)
        }
    }
    func addMaterialContent()
    {
        self.stopActivity()
        addMaterialView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        addMaterialView.backgroundColor = UIColor.white
//        view.addSubview(addMaterialView)
        
        let addMaterialNavigationBar = UIView()
        addMaterialNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        addMaterialNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(addMaterialNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 4
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        addMaterialNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: addMaterialNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "ADD MATERIAL"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        addMaterialNavigationBar.addSubview(navigationTitle)
        
        addMaterialImage.frame = CGRect(x: (3 * x), y: addMaterialNavigationBar.frame.maxY + (3 * y), width: view.frame.width - (6 * x), height: view.frame.width - (4 * x))
        addMaterialImage.layer.cornerRadius = 5
        addMaterialImage.layer.borderWidth = 1
        addMaterialImage.layer.borderColor = UIColor.gray.cgColor
        addMaterialImage.backgroundColor = UIColor.lightGray
        addMaterialImage.contentMode = .scaleToFill
        view.addSubview(addMaterialImage)
        
        let addMaterialLabel = UILabel()
        addMaterialLabel.frame = CGRect(x: (2 * x), y: addMaterialImage.frame.maxY + (2 * x), width: view.frame.width, height: (2 * y))
        addMaterialLabel.text = "Add material image for tailor refrence"
        addMaterialLabel.textColor = UIColor.black
        addMaterialLabel.textAlignment = .left
        view.addSubview(addMaterialLabel)
        
        addMaterialScrolView.frame = CGRect(x: 0, y: addMaterialLabel.frame.maxY, width: view.frame.width, height: (8.25 * y))
        view.addSubview(addMaterialScrolView)
        
        addMaterialImageCollection.frame = CGRect(x: x, y: y, width: (6.25 * x), height: (6.25 * y))
        addMaterialImageCollection.backgroundColor = UIColor.blue
        addMaterialImageCollection.setTitle("+", for: .normal)
        addMaterialImageCollection.setTitleColor(UIColor.white, for: .normal)
        addMaterialImageCollection.addTarget(self, action: #selector(self.addMaterialButtonAction(sender:)), for: .touchUpInside)
        addMaterialScrolView.addSubview(addMaterialImageCollection)
        
        
        let addMaterialNextButton = UIButton()
        addMaterialNextButton.frame = CGRect(x: view.frame.width - (15 * x), y: addMaterialScrolView.frame.maxY + y, width: (13 * x), height: (4 * y))
        addMaterialNextButton.layer.cornerRadius = 10
        addMaterialNextButton.backgroundColor = UIColor.blue
        addMaterialNextButton.setTitle("Next", for: .normal)
        addMaterialNextButton.setTitleColor(UIColor.white, for: .normal)
        addMaterialNextButton.addTarget(self, action: #selector(self.addMaterialNextButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(addMaterialNextButton)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addMaterialNextButtonAction(sender : UIButton)
    {
        let custom3Screen = Customization3ViewController()
        self.navigationController?.pushViewController(custom3Screen, animated: true)
    }

    @objc func addMaterialButtonAction(sender : UIButton)
    {
        UserDefaults.standard.set(1, forKey: "screenValue")
        
        let cameraAlert = UIAlertController(title: "Alert", message: "Choose image from", preferredStyle: .alert)
        cameraAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: cameraAlertAction(action:)))
        cameraAlert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: galleryAlertAction(action:)))
        cameraAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(cameraAlert, animated: true, completion: nil)
    }
    
    func cameraAlertAction(action : UIAlertAction)
    {
        if materialCount <= 10
        {
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                print("Button capture")
                
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = false
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "You have excedded your limit for adding refrence image", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func galleryAlertAction(action : UIAlertAction)
    {
        if materialCount <= 10
        {
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                print("Button capture")
                
                imagePicker.delegate = self
                imagePicker.sourceType = .savedPhotosAlbum;
                imagePicker.allowsEditing = false
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "You have excedded your limit for adding refrence image", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.addMaterialImage.image = pickedImage
            
            let imageName = pickedImage // your image name here
            let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName).png"
            let imageUrl: URL = URL(fileURLWithPath: imagePath)
            
            let newImage: UIImage = pickedImage// create your UIImage here
            try? UIImage.pngData(newImage)()?.write(to : imageUrl)
//                try? UIImagePNGRepresentation(newImage)?.write(to: imageUrl)
            
            
            imageArray.append(pickedImage)
            materialCount += 1
            addReferenceSubImage()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func addReferenceSubImage()
    {
        print("materialCount", self.imageArray.count)
        
        var x1:CGFloat = x
        
        if imageArray.count != 0
        {
            for i in 0..<imageArray.count
            {
                let addMaterialImageButton = UIButton()
                addMaterialImageButton.frame = CGRect(x: x1, y: y, width: (6.25 * x), height: (6.25 * y))
                addMaterialImageButton.backgroundColor = UIColor.blue
                addMaterialImageButton.setImage(imageArray[i], for: .normal)
                addMaterialImageButton.addTarget(self, action: #selector(self.selectedMaterialButtonAction(sender:)), for: .touchUpInside)
                addMaterialScrolView.addSubview(addMaterialImageButton)
                
                let cancelMaterialImageCollection = UIButton()
                cancelMaterialImageCollection.frame = CGRect(x: addMaterialImageButton.frame.width - (1 * x), y: 0, width: (1 * x), height: (1 * y))
                cancelMaterialImageCollection.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
                cancelMaterialImageCollection.setImage(UIImage(named: "close"), for: .normal)
//                cancelMaterialImageCollection.setTitle("\(i)", for: .normal)
//                cancelMaterialImageCollection.setTitleColor(UIColor.black, for: .normal)
                cancelMaterialImageCollection.tag = i
//                cancelMaterialImageCollection.addTarget(self, action: #selector(self.removeMaterialButtonAction(sender:)), for: .touchUpInside)
                addMaterialImageButton.addSubview(cancelMaterialImageCollection)
                
                x1 = addMaterialImageButton.frame.maxX + x
            }
            
            addMaterialImageCollection.frame = CGRect(x: x1, y: y, width: (6.25 * x), height: (6.25 * y))
            addMaterialScrolView.contentSize.width = addMaterialImageCollection.frame.maxX + (3 * x)
        }
        else
        {
            self.addMaterialImage.image = nil
            addMaterialImageCollection.frame = CGRect(x: x1, y: y, width: (6.25 * x), height: (6.25 * y))
            addMaterialScrolView.contentSize.width = addMaterialImageCollection.frame.maxX + (3 * x)
        }
    }
    
    @objc func selectedMaterialButtonAction(sender : UIButton)
    {
        //        self.addReferenceImage.image = sender.imageView?.image
        
        self.selectedImage = (sender.imageView?.image)!
        self.selectedTag = sender.tag
        
        let alert = UIAlertController(title: "Alert", message: "Choose Image to", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "View", style: .default, handler: viewAlertAction(action:)))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: deleteAlertAction(action:)))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func removeMaterialButtonAction(sender : UIButton)
    {
        
        print("TAG - \(sender.tag), imageArray - \(imageArray.count)")
        imageArray.remove(at: sender.tag)
        
        addReferenceSubImage()
    }
    
    func viewAlertAction(action : UIAlertAction)
    {
        self.addMaterialImage.image = selectedImage
    }
    
    func deleteAlertAction(action : UIAlertAction)
    {
        print("BEFORE", materialCount, self.selectedTag, imageArray)
        for views in addMaterialScrolView.subviews
        {
            if views.tag == self.selectedTag
            {
                views.removeFromSuperview()
                if materialCount > 0
                {
                    materialCount -= 1
                    imageArray.remove(at: self.selectedTag)
                }
                addReferenceSubImage()
            }
        }
        print("AFTER", materialCount)
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
