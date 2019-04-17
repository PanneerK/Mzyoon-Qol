//
//  ReferenceImageViewController.swift
//  Mzyoon
//
//  Created by QOL on 16/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class ReferenceImageViewController: CommonViewController, ServerAPIDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    //ADD MATERIAL PARAMETERS
    let addReferenceView = UIView()
    let addReferenceImage = UIImageView()
    let addMaterialLabel = UILabel()
    let addMaterialNextButton = UIButton()

    let notifyLabel = UILabel()
    
    //ADD MATERIAL PAGE PARAMETERS
    var imagePicker = UIImagePickerController()
    let addReferenceScrolView = UIScrollView()
    let addMaterialButton = UIButton()
    var imageArray = [UIImage]()
    
    var selectedImage = UIImage()
    var selectedTag = Int()
    
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()
    
    let selfScreenContents = UIView()

    let fileAccessing = FileAccess()

    var applicationDelegate = AppDelegate()
    
    override func viewDidLoad()
    {
        fileAccessing.configureDirectory()

        navigationBar.isHidden = true
        
        //        self.tab1Button.backgroundColor = UIColor(red: 0.9098, green: 0.5255, blue: 0.1765, alpha: 1.0)
        selectedButton(tag: 0)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of seconds
            // Your code with delay
            self.addMaterialContent()
        }
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addMaterialContent()
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
    }
    
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        print("OWN MATERIAL", errorMessage)
        stopActivity()
        applicationDelegate.exitContents()
    }
    
    func changeViewToArabicInSelf()
    {
        print("BEFORE X", addMaterialNextButton.frame.minX)
        
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        selfScreenNavigationTitle.text = "إضافة صورة المواد"
        notifyLabel.text = "يرجى إضافة صورة للرجوع اليها"
        addMaterialLabel.text = "إضافة صورة مرجعية لتوصية خياط"
        
        selfScreenContents.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        addReferenceImage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        addReferenceScrolView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        addMaterialButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        //        addMaterialNextButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        print("AFTER X", addMaterialNextButton.frame.minX)
    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        selfScreenNavigationTitle.text = "ADD REFERENCE IMAGE"
        notifyLabel.text = "Please add Image for reference"
        addMaterialLabel.text = "Add reference image for tailor refrence"
        
        selfScreenContents.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        addReferenceImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        addReferenceScrolView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        addMaterialButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        addMaterialNextButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    func addMaterialContent()
    {
        self.stopActivity()
        
        selfScreenNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        selfScreenNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(selfScreenNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 4
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        selfScreenNavigationBar.addSubview(backButton)
        
        selfScreenNavigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: selfScreenNavigationBar.frame.width, height: (3 * y))
        selfScreenNavigationTitle.text = "ADD REFERENCE IMAGE"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: (2 * x))
        selfScreenNavigationTitle.font = selfScreenNavigationTitle.font.withSize(2 * x)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        selfScreenContents.frame = CGRect(x: (3 * x), y: pageBar.frame.maxY, width: view.frame.width - (6 * x), height: view.frame.height - ((5 * y) + selfScreenNavigationBar.frame.maxY + pageBar.frame.height))
        selfScreenContents.backgroundColor = UIColor.clear
        view.addSubview(selfScreenContents)
        
        pageBar.image = UIImage(named: "Measurement_wizard")
        
        self.view.bringSubviewToFront(slideMenuButton)
        
        addReferenceImage.frame = CGRect(x: 0, y: (3 * y), width: selfScreenContents.frame.width, height: (27 * y))
        addReferenceImage.layer.borderWidth = 1
        addReferenceImage.layer.borderColor = UIColor.lightGray.cgColor
        addReferenceImage.backgroundColor = UIColor.white
        selfScreenContents.addSubview(addReferenceImage)
        
        if imageArray.count == 0 || imageArray.isEmpty == true
        {
            notifyLabel.frame = CGRect(x: x, y: ((addReferenceImage.frame.height - (3 * y)) / 2), width: addReferenceImage.frame.width - (2 * x), height: (5 * y))
            notifyLabel.text = "Please add Image for reference"
            notifyLabel.textColor = UIColor.black
            notifyLabel.textAlignment = .center
            notifyLabel.font = notifyLabel.font.withSize((1.5 * x))
            addReferenceImage.addSubview(notifyLabel)
        }
        
        addMaterialLabel.frame = CGRect(x: 0, y: addReferenceImage.frame.maxY + y, width: selfScreenContents.frame.width, height: (2 * y))
        addMaterialLabel.text = "Add reference image for tailor refrence"
        addMaterialLabel.textColor = UIColor.black
        addMaterialLabel.textAlignment = .left
        addMaterialLabel.font = UIFont(name: "Avenir-Regular", size: (2 * x))
        selfScreenContents.addSubview(addMaterialLabel)
        
        addReferenceScrolView.frame = CGRect(x: 0, y: addMaterialLabel.frame.maxY, width: selfScreenContents.frame.width - (12 * x), height: (12 * y))
        selfScreenContents.addSubview(addReferenceScrolView)
        
        addMaterialButton.frame = CGRect(x: addReferenceScrolView.frame.maxX + x, y: addMaterialLabel.frame.maxY + y, width: (10 * x), height: (10 * y))
        addMaterialButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        addMaterialButton.setTitle("+", for: .normal)
        addMaterialButton.setTitleColor(UIColor.white, for: .normal)
        addMaterialButton.tag = -1
        addMaterialButton.addTarget(self, action: #selector(self.addMaterialButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(addMaterialButton)
        
        addMaterialNextButton.frame = CGRect(x: selfScreenContents.frame.width - (4 * x), y: addReferenceScrolView.frame.maxY + y, width: (4 * x), height: (4 * y))
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
        headingLabel.text = "Reference Image"
        headingLabel.textAlignment = .left
        headingLabel.textColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0)
        headingLabel.font = UIFont(name: "Avenir-Regular", size: (2 * x))
        hintsView.addSubview(headingLabel)
        
        let hintsImage = UIImageView()
        hintsImage.frame = CGRect(x: addMaterialButton.frame.minX + (3 * x), y: addMaterialButton.frame.minY + (11.5 * y), width: addMaterialButton.frame.width, height: addMaterialButton.frame.height)
        hintsImage.layer.borderWidth = 2
        hintsImage.layer.borderColor = UIColor(red: 0.902, green: 0.5294, blue: 0.1765, alpha: 1.0).cgColor
        hintsImage.image = UIImage(named: "addHintImage")
        hintsView.addSubview(hintsImage)
        
        let detailedLabel = UILabel()
        detailedLabel.frame = CGRect(x: (2 * x), y: hintsImage.frame.maxY + y, width: hintsView.frame.width - (4 * x), height: (5 * y))
        detailedLabel.text = "Please click here to add new reference  image"
        detailedLabel.textAlignment = .justified
        detailedLabel.textColor = UIColor.white
        detailedLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
        detailedLabel.font = detailedLabel.font.withSize((1.5 * x))
        detailedLabel.numberOfLines = 3
        hintsView.addSubview(detailedLabel)
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                headingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                headingLabel.text = "Reference Image"
                headingLabel.textAlignment = .left
                
                hintsImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                detailedLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                detailedLabel.text = "Please click here to add new reference  image"
                detailedLabel.textAlignment = .left
            }
            else if language == "ar"
            {
                headingLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                headingLabel.text = "Reference Image"
                headingLabel.textAlignment = .left
                
                hintsImage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                
                detailedLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                detailedLabel.text = "الرجاء الضغط هنا لإضافة صورة مرجعية جديدة"
                detailedLabel.textAlignment = .left
            }
        }
        else
        {
            headingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            headingLabel.text = "Reference Image"
            headingLabel.textAlignment = .left
            
            hintsImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            detailedLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            detailedLabel.text = "Please click here to add new reference  image"
            detailedLabel.textAlignment = .left
        }
    }
    
    func addMaterial(xPosition : CGFloat)
    {
        addMaterialButton.frame = CGRect(x: xPosition, y: y, width: (6.25 * x), height: (6.25 * y))
        addMaterialButton.backgroundColor = UIColor.blue
        addMaterialButton.setTitle("+", for: .normal)
        addMaterialButton.setTitleColor(UIColor.white, for: .normal)
        addMaterialButton.tag = -1
        addMaterialButton.addTarget(self, action: #selector(self.addMaterialButtonAction(sender:)), for: .touchUpInside)
        addReferenceScrolView.addSubview(addMaterialButton)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        if let values = UserDefaults.standard.value(forKey: "measurement2Response") as? Int
        {
            print("otpBackButtonAction", values)
            if values == 1
            {
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            }
            else
            {
                self.navigationController?.popViewController(animated: true)
            }
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func addMaterialNextButtonAction(sender : UIButton)
    {
        let fileAccessing = FileAccess()
        let file = fileAccessing.configureDirectory()
        fileAccessing.getImageFromDocumentDirectory(imageName: "Reference")
        let path = fileAccessing.getDirectoryPath()
        print("FILE-\(file) AND PATH-\(path)")
        
        if imageArray.count != 0
        {
            for i in 0..<imageArray.count
            {
                fileAccessing.saveImageDocumentDirectory(image: imageArray[i], imageName: "Reference\(i)", imageType: "Mzyoon")
            }
        }
       
        UserDefaults.standard.set(imageArray.count, forKey: "referenceImageArray")

        let addressScreen = AddressViewController()
        addressScreen.viewController = "reference"
        self.navigationController?.pushViewController(addressScreen, animated: true)
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
        if imageArray.count <= 10
        {
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                print("Button capture")
                
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = false
                
                self.present(imagePicker, animated: true, completion: nil)
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
    }
    
    func galleryAlertAction(action : UIAlertAction)
    {
        if imageArray.count <= 10
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
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
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
        print("materialCount", imageArray.count)
        
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
                selectMaterialImageButton.frame = CGRect(x: x1, y: y, width: (10 * x), height: (10 * y))
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
            
            addReferenceScrolView.contentSize.width = x1
            self.addReferenceImage.image = imageArray[imageArray.count - 1]
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
        
        var imageAlert = UIAlertController()
        
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                imageAlert = UIAlertController(title: "Alert", message: "Choose Image to", preferredStyle: .alert)
                imageAlert.addAction(UIAlertAction(title: "View", style: .default, handler: viewAlertAction(action:)))
                imageAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: deleteAlertAction(action:)))
            }
            else if language == "ar"
            {
                imageAlert = UIAlertController(title: "تنبيه", message: "اختيار صورة ل", preferredStyle: .alert)
                imageAlert.addAction(UIAlertAction(title: "معاينة", style: .default, handler: viewAlertAction(action:)))
                imageAlert.addAction(UIAlertAction(title: "حذف", style: .default, handler: deleteAlertAction(action:)))
            }
        }
        else
        {
            imageAlert = UIAlertController(title: "Alert", message: "Choose Image to", preferredStyle: .alert)
            imageAlert.addAction(UIAlertAction(title: "View", style: .default, handler: viewAlertAction(action:)))
            imageAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: deleteAlertAction(action:)))
        }
        
        self.present(imageAlert, animated: true, completion: nil)
    }
    
    @objc func removeMaterialButtonAction(sender : UIButton)
    {
        
        print("TAG - \(sender.tag), imageArray - \(imageArray.count)")
        imageArray.remove(at: sender.tag)
        
        addMaterialSubImage()
    }
    
    func viewAlertAction(action : UIAlertAction)
    {
        self.addReferenceImage.image = selectedImage
    }
    
    func deleteAlertAction(action : UIAlertAction)
    {
        print("BEFORE", self.selectedTag, imageArray)
        
        let removeTag = self.selectedTag - 200
        imageArray.remove(at: removeTag)
        
        /*for views in addReferenceScrolView.subviews
         {
         if views.tag == self.selectedTag
         {
         print("TAGS EQUAL", views.tag, self.selectedTag)
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
