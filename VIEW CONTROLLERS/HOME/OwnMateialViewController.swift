//
//  OwnMateialViewController.swift
//  Mzyoon
//
//  Created by QOL on 16/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia
import CoreImage

class OwnMateialViewController: CommonViewController, ServerAPIDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    let serviceCall = ServerAPI()
    
    let selfScreenContents = UIView()

    //ADD MATERIAL PARAMETERS
    let addReferenceView = UIView()
    let addReferenceImage = UIImageView()
    let notifyLabel = UILabel()
    let addMaterialLabel = UILabel()
    let addMaterialNextButton = UIButton()

    //ADD MATERIAL PAGE PARAMETERS
    var imagePicker = UIImagePickerController()
    let addReferenceScrolView = UIScrollView()
    let addMaterialButton = UIButton()
    var imageArray = [UIImage]()
    var removeTag = Int()
    
    var selectedImage = UIImage()
    var selectedTag = Int()
    
    let fileAccessing = FileAccess()
    
    var getMaterialImageNameArray = [String]()
    
    var applicationDelegate = AppDelegate()

    
    override func viewDidLoad()
    {
        fileAccessing.deleteDirectory(imageType: "Mzyoon")
        fileAccessing.configureDirectory()
        
        Variables.sharedManager.screenNavigationBarTag = 0
        commonBackButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        selectedButton(tag: 0)
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                self.navigationTitle.text = "ADD MATERIAL IMAGE"
                self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            else if language == "ar"
            {
                self.navigationTitle.text = "إضافة صورة المواد"
                self.navigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            }
        }
        else
        {
            self.navigationTitle.text = "ADD MATERIAL IMAGE"
            self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of seconds
            // Your code with delay
            self.addMaterialContent()
        }
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
//        self.addMaterialContent()
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                slideMenu()
                changeViewToEnglish()
            }
            else if language == "ar"
            {
                slideMenuRight()
                changeViewToArabic()
            }
        }
        else
        {
            slideMenu()
            changeViewToEnglish()
        }
    }*/
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("OWN MATERIAL", errorMessage)
        stopActivity()
        applicationDelegate.exitContents()
    }
    
    func changeViewToArabicInSelf()
    {
        notifyLabel.text = "يرجى إضافة صورة مادية لتكون مرجعا"
        addMaterialLabel.text = "إضافة صورة مادية لتوصية الطلب"
        
        selfScreenContents.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        addReferenceImage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        addReferenceScrolView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        addMaterialButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
//        addMaterialNextButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    func changeViewToEnglishInSelf()
    {
        notifyLabel.text = "Please add material image for reference"
        addMaterialLabel.text = "Add material image for tailor refrence"
        
        selfScreenContents.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        addReferenceImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

        addReferenceScrolView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        addMaterialButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        addMaterialNextButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    func addMaterialContent()
    {
        self.stopActivity()
        
        selfScreenContents.frame = CGRect(x: x, y: pageBar.frame.maxY, width: view.frame.width - (2 * x), height: view.frame.height - ((5 * y) + navigationBar.frame.maxY + pageBar.frame.height))
        selfScreenContents.backgroundColor = UIColor.clear
        view.addSubview(selfScreenContents)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                pageBar.image = UIImage(named: "MaterialBar")
            }
            else if language == "ar"
            {
                pageBar.image = UIImage(named: "materialArabicHintImage")
            }
        }
        else
        {
            pageBar.image = UIImage(named: "MaterialBar")
        }
        
        self.view.bringSubviewToFront(slideMenuButton)
        
        addReferenceImage.frame = CGRect(x: (2 * x), y: y, width: selfScreenContents.frame.width - (4 * x), height: selfScreenContents.frame.width - (4 * x))
        addReferenceImage.layer.borderWidth = 1
        addReferenceImage.layer.borderColor = UIColor.lightGray.cgColor
        addReferenceImage.backgroundColor = UIColor.white
        selfScreenContents.addSubview(addReferenceImage)
        
        print("WELCOME OF WIDTH AND HEIGHT", addReferenceImage.frame.height, addReferenceImage.frame.width)
        
        if imageArray.count == 0 || imageArray.isEmpty == true
        {
            notifyLabel.frame = CGRect(x: x, y: ((addReferenceImage.frame.height - (5 * y)) / 2), width: addReferenceImage.frame.width - (2 * x), height: (5 * y))
            notifyLabel.text = "Please add material image for reference"
            notifyLabel.textColor = UIColor.black
            notifyLabel.textAlignment = .center
            notifyLabel.font = notifyLabel.font.withSize((1.5 * x))
            addReferenceImage.addSubview(notifyLabel)
        }
        
        addMaterialLabel.frame = CGRect(x: 0, y: addReferenceImage.frame.maxY + y, width: selfScreenContents.frame.width, height: (2 * y))
        addMaterialLabel.text = "Add material image for tailor refrence"
        addMaterialLabel.textColor = UIColor.black
        addMaterialLabel.textAlignment = .left
        addMaterialLabel.font = UIFont(name: "Avenir-Regular", size: (2 * x))
        selfScreenContents.addSubview(addMaterialLabel)
        
        addReferenceScrolView.frame = CGRect(x: 0, y: addMaterialLabel.frame.maxY, width: selfScreenContents.frame.width - (11 * x), height: (10 * y))
        addReferenceScrolView.backgroundColor = UIColor.clear
        selfScreenContents.addSubview(addReferenceScrolView)
        
        addMaterialButton.frame = CGRect(x: addReferenceScrolView.frame.maxX + x, y: addMaterialLabel.frame.maxY + y, width: (8 * y), height: (8 * y))
        addMaterialButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        addMaterialButton.setTitle("+", for: .normal)
        addMaterialButton.setTitleColor(UIColor.white, for: .normal)
        addMaterialButton.tag = -1
        addMaterialButton.addTarget(self, action: #selector(self.addMaterialButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(addMaterialButton)
        
        addMaterialNextButton.frame = CGRect(x: selfScreenContents.frame.width - (4 * x), y: addReferenceScrolView.frame.maxY, width: (4 * x), height: (4 * y))
        addMaterialNextButton.layer.cornerRadius = addMaterialNextButton.frame.height / 2
        addMaterialNextButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        addMaterialNextButton.setImage(UIImage(named: "rightArrow"), for: .normal)
        //        addMaterialNextButton.backgroundColor = UIColor.blue
        //        addMaterialNextButton.setTitle("Next", for: .normal)
        //        addMaterialNextButton.setTitleColor(UIColor.white, for: .normal)
        addMaterialNextButton.addTarget(self, action: #selector(self.addMaterialNextButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(addMaterialNextButton)
        
        //        addMaterial(xPosition: x)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                changeViewToEnglishInSelf()
            }
            else if language == "ar"
            {
                changeViewToArabicInSelf()
            }
        }
        else
        {
            changeViewToEnglishInSelf()
        }
        
        let onOrOffValue = UserDefaults.standard.value(forKey: "hintsSwitch") as! Int
        
        if onOrOffValue == 1
        {
            hintsViewContents()
            hintsContents()
        }
        else
        {
            
        }
    }
    
    func hintsContents()
    {
        let headingLabel = UILabel()
        headingLabel.frame = CGRect(x: (2 * x), y: (5 * y), width: hintsView.frame.width - (4 * x), height: (3 * y))
        headingLabel.text = "Own Material"
        headingLabel.textAlignment = .left
        headingLabel.textColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0)
        headingLabel.font = UIFont(name: "Avenir-Regular", size: (2 * x))
        hintsView.addSubview(headingLabel)
        
        let hintsImage = UIImageView()
        hintsImage.frame = CGRect(x: addMaterialButton.frame.minX + x, y: addMaterialButton.frame.minY + (11.5 * y), width: addMaterialButton.frame.width, height: addMaterialButton.frame.height)
        hintsImage.layer.borderWidth = 2
        hintsImage.layer.borderColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0).cgColor
        hintsImage.image = UIImage(named: "addHintImage")
        hintsView.addSubview(hintsImage)
        
        let detailedLabel = UILabel()
        detailedLabel.frame = CGRect(x: (2 * x), y: hintsImage.frame.minY - (5 * y), width: hintsView.frame.width - (4 * x), height: (5 * y))
        detailedLabel.text = "Please click here to add the new material image"
        detailedLabel.textAlignment = .left
        detailedLabel.textColor = UIColor.white
        detailedLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
        detailedLabel.font = detailedLabel.font.withSize((1.5 * x))
        detailedLabel.font = detailedLabel.font.withSize((1.5 * x))
        detailedLabel.numberOfLines = 3
        hintsView.addSubview(detailedLabel)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                headingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                headingLabel.text = "Own Material"
                headingLabel.textAlignment = .left
                
                hintsImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                detailedLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                detailedLabel.text = "Please click here to add the new material image"
                detailedLabel.textAlignment = .left
            }
            else if language == "ar"
            {
                headingLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                headingLabel.text = "Own Material"
                headingLabel.textAlignment = .left
                
                hintsImage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                
                detailedLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                detailedLabel.text = "الرجاء الضغط هنا لإضافة صورة المادة الجديدة"
                detailedLabel.textAlignment = .left
            }
        }
        else
        {
            headingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            headingLabel.text = "Own Material"
            headingLabel.textAlignment = .left
            
            hintsImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            detailedLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            detailedLabel.text = "Please click here to add the new material image"
            detailedLabel.textAlignment = .left
        }
    }
    
    func addMaterial(xPosition : CGFloat)
    {
        addMaterialButton.backgroundColor = UIColor.blue
        addMaterialButton.setTitle("+", for: .normal)
        addMaterialButton.setTitleColor(UIColor.white, for: .normal)
        addMaterialButton.tag = -1
        addMaterialButton.addTarget(self, action: #selector(self.addMaterialButtonAction(sender:)), for: .touchUpInside)
        addReferenceScrolView.addSubview(addMaterialButton)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addMaterialNextButtonAction(sender : UIButton)
    {
        if imageArray.count == 0
        {
            if let language = UserDefaults.standard.value(forKey: "language") as? String
            {
                if language == "en"
                {
                    let alert = UIAlertController(title: "Alert", message: "Please add a material image for tailor reference", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else if language == "ar"
                {
                    let alert = UIAlertController(title: "محزر", message: "يرجى إضافة صورة مادية لمرجع خياط", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else
            {
                let alert = UIAlertController(title: "Alert", message: "Please add a material image for tailor reference", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            for i in 0..<imageArray.count
            {
                fileAccessing.saveImageDocumentDirectory(image: imageArray[i], imageName: "Material\(i)", imageType: "Mzyoon")
            }
            
            
//            let returnImage = ConversionToJson()
//
//            let images = returnImage.imageRequest(imageName: [getImage])
//

            
            UserDefaults.standard.set(imageArray.count, forKey: "materialImageArray")
            
            var getImageArray = [UIImage]()

            if let materialImages = UserDefaults.standard.value(forKey: "materialImageArray") as? Int
            {
                for i in 0..<materialImages
                {
                    let getImage = fileAccessing.getImageFromDocumentDirectory(imageName: "Material\(i)")
                    getImageArray.append(getImage)
                }
            }
            
//            self.serviceCall.API_MaterialImageUpload(materialImages: getImageArray, delegate: self)

            let custom3Screen = Customization3ViewController()
            self.navigationController?.pushViewController(custom3Screen, animated: true)
        }
    }
    
    func API_CALLBACK_MaterialImageUpload(material: NSDictionary) {
        print("MATERIAL IMAGE UPLOAD", material)
        
        let ResponseMsg = material.object(forKey: "ResponseMsg") as! String
        
        if ResponseMsg == "Success"
        {
            let Result = material.object(forKey: "Result") as! NSArray
            
            if Result.count != 0
            {
                for i in 0..<Result.count
                {
                    if let file1 = Result[i] as? String
                    {
                        let splitted = file1.split(separator: "\\")
                        
                        let imageName = splitted.last
                        
                        getMaterialImageNameArray.append((imageName?.description)!)
                    }
                }
            }
        }
    }
    
    @objc func addMaterialButtonAction(sender : UIButton)
    {
        UserDefaults.standard.set(1, forKey: "screenValue")
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                let cameraAlert = UIAlertController(title: "Alert", message: "Choose image from", preferredStyle: .alert)
                cameraAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: cameraAlertAction(action:)))
                cameraAlert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: galleryAlertAction(action:)))
                cameraAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(cameraAlert, animated: true, completion: nil)
            }
            else if language == "ar"
            {
                let cameraAlert = UIAlertController(title: "محزر", message: "اختر صورة من", preferredStyle: .alert)
                cameraAlert.addAction(UIAlertAction(title: "الة تصوير", style: .default, handler: cameraAlertAction(action:)))
                cameraAlert.addAction(UIAlertAction(title: "صالة عرض", style: .default, handler: galleryAlertAction(action:)))
                cameraAlert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: nil))
                self.present(cameraAlert, animated: true, completion: nil)
            }
        }
        else
        {
            let cameraAlert = UIAlertController(title: "Alert", message: "Choose image from", preferredStyle: .alert)
            cameraAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: cameraAlertAction(action:)))
            cameraAlert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: galleryAlertAction(action:)))
            cameraAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(cameraAlert, animated: true, completion: nil)
        }
    }
    
    func cameraAlertAction(action : UIAlertAction)
    {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    //access allowed
                    print("ALLOWED")
                    
                    if self.imageArray.count <= 10
                    {
                        if UIImagePickerController.isSourceTypeAvailable(.camera)
                        {
                            self.imagePicker.delegate = self
                            self.imagePicker.sourceType = .camera;
                            self.imagePicker.allowsEditing = false
                            
                            self.present(self.imagePicker, animated: true, completion: nil)
                        }
                        else
                        {
                            print("CAMERA NOT OPENING")
                        }
                    }
                    else
                    {
                        let alert = UIAlertController(title: "Error", message: "You have excedded your limit for adding material image", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                } else {
                    //access denied
                    print("DENIED")
                    self.alertPromptToAllowCameraAccessViaSetting()
                }
            })
        }
    }
    
    func alertPromptToAllowCameraAccessViaSetting() {
        let alert = UIAlertController(title: "Error", message: "Camera access required to...", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Settings", style: .cancel) { (alert) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        })
        
        present(alert, animated: true)
    }
    
    func galleryAlertAction(action : UIAlertAction)
    {
        if imageArray.count <= 10
        {
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
            {
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
            self.addReferenceImage.image = pickedImage
            imageArray.append(pickedImage)
            notifyLabel.isHidden = true
            
            addMaterialSubImage()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func addMaterialSubImage()
    {
        var x1:CGFloat = x
        
        for views in addReferenceScrolView.subviews
        {
            views.removeFromSuperview()
        }
        
        if imageArray.count > 0
        {
            for i in 0..<imageArray.count
            {
                let selectMaterialImageButton = UIButton()
                selectMaterialImageButton.frame = CGRect(x: x1, y: y, width: (8 * y), height: (8 * y))
                selectMaterialImageButton.backgroundColor = UIColor.blue
                selectMaterialImageButton.setImage(imageArray[i], for: .normal)
                selectMaterialImageButton.tag = (i + 200)
                selectMaterialImageButton.addTarget(self, action: #selector(self.selectedMaterialButtonAction(sender:)), for: .touchUpInside)
                addReferenceScrolView.addSubview(selectMaterialImageButton)
                
                let cancelMaterialImageCollection = UIButton()
                cancelMaterialImageCollection.frame = CGRect(x: selectMaterialImageButton.frame.width - (2 * x), y: 0, width: (2 * x), height: (2 * y))
                cancelMaterialImageCollection.setImage(UIImage(named: "close"), for: .normal)
                cancelMaterialImageCollection.tag = i
                //                cancelMaterialImageCollection.addTarget(self, action: #selector(self.removeMaterialButtonAction(sender:)), for: .touchUpInside)
                selectMaterialImageButton.addSubview(cancelMaterialImageCollection)
                
                x1 = selectMaterialImageButton.frame.maxX + x
            }
            
            print("REMOVE TAG", removeTag)
            addReferenceScrolView.contentSize.width = x1
//            self.addReferenceImage.image = imageArray[imageArray.count - 1]
//            if removeTag != 0
//            {
//                self.addReferenceImage.image = imageArray[removeTag - 1]
//            }
//            else
//            {
//                self.addReferenceImage.image = imageArray[0]
//            }
        }
        else
        {
            notifyLabel.isHidden = false
            
            self.addReferenceImage.image = nil
            addReferenceScrolView.contentSize.width = x1
        }
        
        //        addMaterial(xPosition: x1)
    }
    
    @objc func selectedMaterialButtonAction(sender : UIButton)
    {
        self.selectedImage = (sender.imageView?.image)!
        self.selectedTag = sender.tag
        var chooseAlert = UIAlertController()
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                chooseAlert = UIAlertController(title: "Alert", message: "Choose Image to", preferredStyle: .alert)
                chooseAlert.addAction(UIAlertAction(title: "View", style: .default, handler: viewAlertAction(action:)))
                chooseAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: deleteAlertAction(action:)))
            }
            else if language == "ar"
            {
                chooseAlert = UIAlertController(title: "تنبيه", message: "اختيار صورة ل", preferredStyle: .alert)
                chooseAlert.addAction(UIAlertAction(title: "معاينة", style: .default, handler: viewAlertAction(action:)))
                chooseAlert.addAction(UIAlertAction(title: "حذف", style: .default, handler: deleteAlertAction(action:)))
            }
        }
        else
        {
            chooseAlert = UIAlertController(title: "Alert", message: "Choose Image to", preferredStyle: .alert)
            chooseAlert.addAction(UIAlertAction(title: "View", style: .default, handler: viewAlertAction(action:)))
            chooseAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: deleteAlertAction(action:)))
        }
        
        self.present(chooseAlert, animated: true, completion: nil)
    }
    
    @objc func removeMaterialButtonAction(sender : UIButton)
    {
        imageArray.remove(at: sender.tag)
        
        addMaterialSubImage()
    }
    
    func viewAlertAction(action : UIAlertAction)
    {
        self.addReferenceImage.image = selectedImage
    }
    
    func deleteAlertAction(action : UIAlertAction)
    {
        removeTag = self.selectedTag - 200
        imageArray.remove(at: removeTag)
        
        if removeTag != 0
        {
            self.addReferenceImage.image = imageArray[removeTag - 1]
        }
        else
        {
//            self.addReferenceImage.image = imageArray[0]
        }
        
        /*for views in addReferenceScrolView.subviews
         {
         if views.tag == self.selectedTag
         {
         views.removeFromSuperview()
         let removeTag = self.selectedTag - 200
         imageArray.remove(at: removeTag)
         //                if imageArray.count > 0
         //                {
         //                    imageArray.remove(at: self.selectedTag)
         //                }
         }
         }*/
        
        addMaterialSubImage()
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
