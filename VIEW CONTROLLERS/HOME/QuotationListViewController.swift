//
//  QuotationListViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 26/12/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit

class QuotationListViewController: CommonViewController
{

    let quotationListNavigationBar = UIView()
    let tailorListScrollView = UIScrollView()
    var selectedTailorListArray = [Int]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        quotationListContent()
    }
    
   func quotationListContent()
   {
    self.stopActivity()
    
    //let quotationListNavigationBar = UIView()
    quotationListNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
    quotationListNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
    view.addSubview(quotationListNavigationBar)
    
    let backButton = UIButton()
    backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
    backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
    backButton.tag = 4
    backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
    quotationListNavigationBar.addSubview(backButton)
    
    let navigationTitle = UILabel()
    navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: quotationListNavigationBar.frame.width, height: (3 * y))
    navigationTitle.text = "QUOTATION LIST"
    navigationTitle.textColor = UIColor.white
    navigationTitle.textAlignment = .center
    navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
    quotationListNavigationBar.addSubview(navigationTitle)

    TailorListView()
   }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func TailorListView()
    {
        let backDrop = UIView()
        backDrop.frame = CGRect(x: (3 * x), y: quotationListNavigationBar.frame.maxY + y, width: view.frame.width - (6 * x), height: view.frame.height - (10 * y))
        backDrop.backgroundColor = UIColor.clear
        view.addSubview(backDrop)
        
        let sortButton = UIButton()
        sortButton.frame = CGRect(x: backDrop.frame.width - (10 * x), y: y, width: (10 * x), height: (2 * y))
        sortButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        sortButton.setTitle("SORT", for: .normal)
        sortButton.setTitleColor(UIColor.white, for: .normal)
        sortButton.tag = 0
        //        sortButton.addTarget(self, action: #selector(self.selectionViewButtonAction(sender:)), for: .touchUpInside)
        backDrop.addSubview(sortButton)
        
        tailorListScrollView.frame = CGRect(x: 0, y: sortButton.frame.maxY + y, width: backDrop.frame.width, height: (45 * y))
        backDrop.addSubview(tailorListScrollView)
        
        tailorListScrollView.contentSize.height = (12 * y * CGFloat(6))
        
        for views in tailorListScrollView.subviews
        {
            views.removeFromSuperview()
        }
        
        var y1:CGFloat = 0
        
        for i in 0..<6
        {
            let tailorView = UIView()
            tailorView.frame = CGRect(x: 0, y: y1, width: tailorListScrollView.frame.width, height: (10 * y))
            tailorView.backgroundColor = UIColor.white
            tailorListScrollView.addSubview(tailorView)
            
            let tailorImageButton = UIButton()
            tailorImageButton.frame = CGRect(x: x, y: y, width: (8 * x), height: (8 * y))
            tailorImageButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
            //            tailorImageButton.setImage(UIImage(named: "men"), for: .normal)
         
          /*
            if let imageName = ShopOwnerImageArray[i] as? String
            {
                let api = "http://appsapi.mzyoon.com/images/Tailorimages/\(imageName)"
                print("SMALL ICON", api)
                let apiurl = URL(string: api)
                
                let dummyImageView = UIImageView()
                dummyImageView.frame = CGRect(x: 0, y: 0, width: tailorImageButton.frame.width, height: tailorImageButton.frame.height)
                dummyImageView.dowloadFromServer(url: apiurl!)
                dummyImageView.tag = -1
                tailorImageButton.addSubview(dummyImageView)
            }
         */
            
            tailorImageButton.tag = i
            tailorImageButton.addTarget(self, action: #selector(self.tailorSelectionButtonAction(sender:)), for: .touchUpInside)
            tailorView.addSubview(tailorImageButton)
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: tailorImageButton.frame.maxX + x, y: 0, width: (5 * x), height: (2 * y))
            nameLabel.text = "Name : "
            nameLabel.textColor = UIColor.blue
            nameLabel.textAlignment = .left
            nameLabel.font =  UIFont(name: "Avenir Next", size: 1.2 * x)  //nameLabel.font.withSize(1.2 * x)
            tailorView.addSubview(nameLabel)
            
            let tailorName = UILabel()
            tailorName.frame = CGRect(x: nameLabel.frame.maxX, y: 0, width: tailorView.frame.width / 2, height: (2 * y))
            tailorName.text = "Abdullah"
            tailorName.textColor = UIColor.black
            tailorName.textAlignment = .left
            tailorName.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            tailorView.addSubview(tailorName)
            
            let shopLabel = UILabel()
            shopLabel.frame = CGRect(x: tailorImageButton.frame.maxX + x, y: nameLabel.frame.maxY, width: (8 * x), height: (2 * y))
            shopLabel.text = "Shop Name : "
            shopLabel.textColor = UIColor.blue
            shopLabel.textAlignment = .left
            shopLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            tailorView.addSubview(shopLabel)
            
            let shopName = UILabel()
            shopName.frame = CGRect(x: shopLabel.frame.maxX, y: nameLabel.frame.maxY, width: tailorView.frame.width / 2.5, height: (2 * y))
            shopName.text =  "Golden Stitching"
            shopName.textColor = UIColor.black
            shopName.textAlignment = .left
            shopName.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            shopName.adjustsFontSizeToFitWidth = true
            tailorView.addSubview(shopName)
            
            let ordersLabel = UILabel()
            ordersLabel.frame = CGRect(x: tailorImageButton.frame.maxX + x, y: shopLabel.frame.maxY, width: (9 * x), height: (2 * y))
            ordersLabel.text = "Price : "
            ordersLabel.textColor = UIColor.blue
            ordersLabel.textAlignment = .left
            ordersLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            tailorView.addSubview(ordersLabel)
            
            let ordersCountLabel = UILabel()
            ordersCountLabel.frame = CGRect(x: ordersLabel.frame.maxX, y: shopLabel.frame.maxY, width: tailorView.frame.width / 2.5, height: (2 * y))
            ordersCountLabel.text =  "2366 AED"
            ordersCountLabel.textColor = UIColor.black
            ordersCountLabel.textAlignment = .left
            ordersCountLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            ordersCountLabel.adjustsFontSizeToFitWidth = true
            tailorView.addSubview(ordersCountLabel)
            
            let ratingLabel = UILabel()
            ratingLabel.frame = CGRect(x: tailorImageButton.frame.maxX + x, y: ordersLabel.frame.maxY, width: (8 * x), height: (2 * y))
            ratingLabel.text = "No Of Days : "
            ratingLabel.textColor = UIColor.blue
            ratingLabel.textAlignment = .left
            ratingLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            tailorView.addSubview(ratingLabel)
            
            let ratingCountLabel = UILabel()
            ratingCountLabel.frame = CGRect(x: ratingLabel.frame.maxX, y: ordersLabel.frame.maxY, width: tailorView.frame.width / 2.5, height: (2 * y))
            ratingCountLabel.text = "5 Days"
            ratingCountLabel.textColor = UIColor.black
            ratingCountLabel.textAlignment = .left
            ratingCountLabel.font = UIFont(name: "Avenir Next", size: 1.2 * x)
            ratingCountLabel.adjustsFontSizeToFitWidth = true
            tailorView.addSubview(ratingCountLabel)
            
           y1 = tailorView.frame.maxY + y
        }
        
        let confirmSelectionButton = UIButton()
        confirmSelectionButton.frame = CGRect(x: ((backDrop.frame.width - (17 * x)) / 2), y: tailorListScrollView.frame.maxY + y, width: (17 * x), height: (3 * y))
        confirmSelectionButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        confirmSelectionButton.setTitle("Confirm Selection", for: .normal)
        confirmSelectionButton.addTarget(self, action: #selector(self.confirmSelectionButtonAction(sender:)), for: .touchUpInside)
        backDrop.addSubview(confirmSelectionButton)
        
    }
    
 @objc func tailorSelectionButtonAction(sender : UIButton)
 {
    let selectionImage = UIImageView()
    selectionImage.frame = CGRect(x: x, y: y, width: (2 * x), height: (2 * y))
    selectionImage.image = UIImage(named: "selectionImage")
    selectionImage.tag = sender.tag
    
   if selectedTailorListArray.isEmpty == true
   {
    selectedTailorListArray.append(sender.tag)
    sender.addSubview(selectionImage)
   }
   else
   {
     if selectedTailorListArray.contains(sender.tag)
     {
       if let index = selectedTailorListArray.index(where: {$0 == sender.tag})
       {
          selectedTailorListArray.remove(at: index)
       }
    
     for views in sender.subviews
     {
       if let findView = views.viewWithTag(sender.tag)
       {
         if findView.tag == sender.tag
         {
           print("FIND VIEW", findView.description)
           findView.removeFromSuperview()
         }
         else
         {
           print("NOT SAME VIEW")
         }
       }
     }
    }
    else
    {
      selectedTailorListArray.append(sender.tag)
      sender.addSubview(selectionImage)
    }
  }
        print("Tailor List Arr:", selectedTailorListArray)
   }
    
    @objc func confirmSelectionButtonAction(sender : UIButton)
    {
        let orderApproveScreen = OrderApprovalViewController()
        self.navigationController?.pushViewController(orderApproveScreen, animated: true)
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
