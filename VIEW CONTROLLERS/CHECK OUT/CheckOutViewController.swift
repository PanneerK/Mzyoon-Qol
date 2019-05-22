//
//  CheckOutViewController.swift
//  Mzyoon
//
//  Created by QOL on 21/05/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit

class CheckOutViewController: CommonViewController
{

    let selfScreenContents = UIScrollView()
    
    let listArray = 3
    
    override func viewDidLoad()
    {
        Variables.sharedManager.screenNavigationBarTag = 0
        commonBackButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        selectedButton(tag: 0)
        if let language = UserDefaults.standard.value(forKey: "language") as? String
        {
            if language == "en"
            {
                self.navigationTitle.text = "CHECK OUT"
                self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            else if language == "ar"
            {
                self.navigationTitle.text = "دفع"
                self.navigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            }
        }
        else
        {
            self.navigationTitle.text = "CHECK OUT"
            self.navigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            // Your code with delay
            self.checkoutScreenContents()
        }
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func checkoutScreenContents()
    {
        activity.stopActivity()
        
        selfScreenContents.frame = CGRect(x: 0, y: navigationBar.frame.maxY, width: view.frame.width, height: view.frame.height - ((5 * y) + navigationBar.frame.maxY))
        selfScreenContents.backgroundColor = UIColor.clear
        view.addSubview(selfScreenContents)
        
        let shippingAddressView = UIView()
        shippingAddressView.frame = CGRect(x: x, y: y, width: selfScreenContents.frame.width - (2 * x), height: (9 * y))
        shippingAddressView.backgroundColor = UIColor.white
        selfScreenContents.addSubview(shippingAddressView)
        
        let shippingToLabel = UILabel()
        shippingToLabel.frame = CGRect(x: x, y: y, width: shippingAddressView.frame.width - (2 * x), height: (2 * y))
        shippingToLabel.text = "Shipping To"
        shippingToLabel.textAlignment = .left
        shippingToLabel.textColor = UIColor.black
        shippingToLabel.font = UIFont(name: "Avenir-Black", size: (1.5 * x))
        shippingToLabel.font = shippingToLabel.font.withSize(1.5 * x)
        shippingAddressView.addSubview(shippingToLabel)
        
        let lineLabel1 = UILabel()
        lineLabel1.frame = CGRect(x: 0, y: shippingToLabel.frame.maxY, width: shippingAddressView.frame.width, height: 1)
        lineLabel1.backgroundColor = UIColor.lightGray
        shippingAddressView.addSubview(lineLabel1)
        
        let addressLabel = UILabel()
        addressLabel.frame = CGRect(x: x, y: lineLabel1.frame.maxY, width: shippingAddressView.frame.width - (2 * x), height: (5 * y))
        addressLabel.text = "Mzyoon[22584:8404530] [BoringSSL] nw_protocol_boringssl_get_output_frames(1301)"
        addressLabel.textAlignment = .left
        addressLabel.textColor = UIColor.black
        addressLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
        addressLabel.font = addressLabel.font.withSize(1.5 * x)
        addressLabel.numberOfLines = 2
        shippingAddressView.addSubview(addressLabel)
        
        let orderView = UIView()
        orderView.frame = CGRect(x: x, y: shippingAddressView.frame.maxY + y, width: selfScreenContents.frame.width - (2 * x), height: ((12 * y) + (CGFloat(listArray) * y * 7)))
        orderView.backgroundColor = UIColor.white
        selfScreenContents.addSubview(orderView)
        
        let yourOrderLabel = UILabel()
        yourOrderLabel.frame = CGRect(x: x, y: y, width: orderView.frame.width - (2 * x), height: (2 * y))
        yourOrderLabel.text = "Your Order"
        yourOrderLabel.textAlignment = .left
        yourOrderLabel.textColor = UIColor.black
        yourOrderLabel.font = UIFont(name: "Avenir-Black", size: (1.5 * x))
        yourOrderLabel.font = shippingToLabel.font.withSize(1.5 * x)
        orderView.addSubview(yourOrderLabel)
        
        let lineLabel2 = UILabel()
        lineLabel2.frame = CGRect(x: 0, y: shippingToLabel.frame.maxY, width: shippingAddressView.frame.width, height: 1)
        lineLabel2.backgroundColor = UIColor.lightGray
        orderView.addSubview(lineLabel2)
        
        var y1:CGFloat = lineLabel2.frame.maxY + y
        
        for i in 0..<3
        {
            let orderedImageView = UIImageView()
            orderedImageView.frame = CGRect(x: x, y: y1, width: (8 * y), height: (8 * y))
            orderedImageView.backgroundColor = UIColor.cyan
            orderView.addSubview(orderedImageView)
            
            if i != listArray - 1
            {
                let underLine = UILabel()
                underLine.frame = CGRect(x: 0, y: orderedImageView.frame.maxY + y, width: orderView.frame.width, height: 1)
                underLine.backgroundColor = UIColor.lightGray
                orderView.addSubview(underLine)
            }
            
            let verticalLineLabel = UILabel()
            verticalLineLabel.frame = CGRect(x: orderedImageView.frame.maxX + x, y: y1 + y, width: 1, height: (6 * y))
            verticalLineLabel.backgroundColor = UIColor.lightGray
            orderView.addSubview(verticalLineLabel)
            
            let dressNameLabel = UILabel()
            dressNameLabel.frame = CGRect(x: verticalLineLabel.frame.maxX + x, y: y1, width: orderView.frame.width - (10 * x), height: (2 * y))
            dressNameLabel.text = "All dress types"
            dressNameLabel.textAlignment = .left
            dressNameLabel.textColor = UIColor.black
            dressNameLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
            dressNameLabel.font = dressNameLabel.font.withSize(1.5 * x)
            orderView.addSubview(dressNameLabel)
            
            let quantityLabel = UILabel()
            quantityLabel.frame = CGRect(x: verticalLineLabel.frame.maxX + x, y: dressNameLabel.frame.maxY + y, width: (5 * x), height: (2 * y))
            quantityLabel.text = "Qty"
            quantityLabel.textAlignment = .left
            quantityLabel.textColor = UIColor.black
            quantityLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
            quantityLabel.font = quantityLabel.font.withSize(1.5 * x)
            orderView.addSubview(quantityLabel)
            
            let quantityColonLabel = UILabel()
            quantityColonLabel.frame = CGRect(x: quantityLabel.frame.maxX + x, y: dressNameLabel.frame.maxY + y, width: x / 2, height: (2 * y))
            quantityColonLabel.text = ":"
            quantityColonLabel.textAlignment = .center
            quantityColonLabel.textColor = UIColor.black
            quantityColonLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
            quantityColonLabel.font = quantityColonLabel.font.withSize(1.5 * x)
            orderView.addSubview(quantityColonLabel)
            
            let getQuantityLabel = UILabel()
            getQuantityLabel.frame = CGRect(x: quantityColonLabel.frame.maxX + x, y: dressNameLabel.frame.maxY + y, width: (5 * x), height: (2 * y))
            getQuantityLabel.text = "1"
            getQuantityLabel.textAlignment = .left
            getQuantityLabel.textColor = UIColor.black
            getQuantityLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
            getQuantityLabel.font = getQuantityLabel.font.withSize(1.5 * x)
            orderView.addSubview(getQuantityLabel)
            
            let priceLabel = UILabel()
            priceLabel.frame = CGRect(x: verticalLineLabel.frame.maxX + x, y: quantityColonLabel.frame.maxY + y, width: (5 * x), height: (2 * y))
            priceLabel.text = "Price"
            priceLabel.textAlignment = .left
            priceLabel.textColor = UIColor.black
            priceLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
            priceLabel.font = priceLabel.font.withSize(1.5 * x)
            orderView.addSubview(priceLabel)
            
            let priceColonLabel = UILabel()
            priceColonLabel.frame = CGRect(x: priceLabel.frame.maxX + x, y: quantityColonLabel.frame.maxY + y, width: x / 2, height: (2 * y))
            priceColonLabel.text = ":"
            priceColonLabel.textAlignment = .center
            priceColonLabel.textColor = UIColor.black
            priceColonLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
            priceColonLabel.font = priceColonLabel.font.withSize(1.5 * x)
            orderView.addSubview(priceColonLabel)
            
            let getPriceLabel = UILabel()
            getPriceLabel.frame = CGRect(x: priceColonLabel.frame.maxX + x, y: quantityColonLabel.frame.maxY + y, width: (10 * x), height: (2 * y))
            getPriceLabel.text = "250 AED"
            getPriceLabel.textAlignment = .left
            getPriceLabel.textColor = UIColor.black
            getPriceLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
            getPriceLabel.font = getPriceLabel.font.withSize(1.5 * x)
            orderView.addSubview(getPriceLabel)
            
            y1 = orderedImageView.frame.maxY + (2 * y)
        }
        
        let promoCodeView = UIView()
        promoCodeView.frame = CGRect(x: x, y: orderView.frame.maxY + y, width: selfScreenContents.frame.width - (2 * x), height: (10 * y))
        promoCodeView.backgroundColor = UIColor.white
        selfScreenContents.addSubview(promoCodeView)
        
        let applyTextField = UITextField()
        applyTextField.frame = CGRect(x: x, y: y, width: promoCodeView.frame.width - (12 * x), height: (3 * y))
        applyTextField.layer.borderWidth = 1
        applyTextField.layer.borderColor = UIColor.lightGray.cgColor
        applyTextField.backgroundColor = UIColor.clear
        applyTextField.placeholder = "Apply your promo code"
        applyTextField.textColor = UIColor(red: 0.098, green: 0.302, blue: 0.7608, alpha: 1.0)
        applyTextField.font = UIFont(name: "Avenir-Heavy", size: (1.8 * x))
        applyTextField.adjustsFontSizeToFitWidth = true
        applyTextField.keyboardType = .numberPad
        applyTextField.clearsOnBeginEditing = true
        applyTextField.returnKeyType = .done
//        applyTextField.delegate = self
        promoCodeView.addSubview(applyTextField)
        
        let applyButton = UIButton()
        applyButton.frame = CGRect(x: applyTextField.frame.maxX, y: y, width: (10 * x), height: (3 * y))
        applyButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        applyButton.setTitle("Apply", for: .normal)
        applyButton.setTitleColor(UIColor.white, for: .normal)
        promoCodeView.addSubview(applyButton)
        
        let viewAllButton = UIButton()
        viewAllButton.frame = CGRect(x: ((promoCodeView.frame.width - (20 * x)) / 2), y: applyTextField.frame.maxY + (2 * y), width: (20 * x), height: (3 * y))
        viewAllButton.backgroundColor = UIColor.clear
        viewAllButton.setTitle("View All Promo Code", for: .normal)
        viewAllButton.setTitleColor(UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85), for: .normal)
         viewAllButton.addTarget(self, action: #selector(self.promosButtonAction(sender:)), for: .touchUpInside)
        promoCodeView.addSubview(viewAllButton)
        
        let pointImageView = UIImageView()
        pointImageView.frame = CGRect(x: x, y: promoCodeView.frame.maxY + y, width: ((selfScreenContents.frame.width - (2 * x)) / 2), height: (15 * y))
        pointImageView.image = UIImage(named: "Checkout _points to cash")
        selfScreenContents.addSubview(pointImageView)
        
        let conversionButton = UIButton()
        conversionButton.frame = CGRect(x: pointImageView.frame.maxX, y: ( promoCodeView.frame.maxY + y) + ((pointImageView.frame.height - (3 * y)) / 2), width: ((selfScreenContents.frame.width - (2 * x)) / 2), height: (3 * y))
        conversionButton.layer.cornerRadius = conversionButton.frame.height / 2
        conversionButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
        conversionButton.setTitle("Convert points to cash", for: .normal)
        conversionButton.setTitleColor(UIColor.white, for: .normal)
        conversionButton.addTarget(self, action: #selector(self.redeemButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(conversionButton)
        
        let paymentView = UIView()
        paymentView.frame = CGRect(x: x, y: pointImageView.frame.maxY + y, width: selfScreenContents.frame.width - (2 * x), height: (20 * y))
        paymentView.backgroundColor = UIColor.white
        selfScreenContents.addSubview(paymentView)
        
        let paymentLabel = UILabel()
        paymentLabel.frame = CGRect(x: x, y: y, width: orderView.frame.width - (2 * x), height: (2 * y))
        paymentLabel.text = "Payment"
        paymentLabel.textAlignment = .left
        paymentLabel.textColor = UIColor.black
        paymentLabel.font = UIFont(name: "Avenir-Black", size: (1.5 * x))
        paymentLabel.font = shippingToLabel.font.withSize(1.5 * x)
        paymentView.addSubview(paymentLabel)
        
        let paymentUnderLine = UILabel()
        paymentUnderLine.frame = CGRect(x: 0, y: paymentLabel.frame.maxY + (y / 2), width: paymentView.frame.width, height: 1)
        paymentUnderLine.backgroundColor = UIColor.lightGray
        paymentView.addSubview(paymentUnderLine)
        
        var y2:CGFloat = paymentUnderLine.frame.maxY + (y / 2)
        
        for i in 0..<4
        {
            let paymentSubLabel = UILabel()
            paymentSubLabel.frame = CGRect(x: x, y: y2, width: (paymentView.frame.width / 2) - x, height: (2 * y))
            paymentSubLabel.text = "250 AED"
            paymentSubLabel.textAlignment = .left
            paymentSubLabel.textColor = UIColor.black
            paymentSubLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
            paymentSubLabel.font = paymentSubLabel.font.withSize(1.5 * x)
            paymentView.addSubview(paymentSubLabel)
            
            
            let getPaymentSubLabel = UILabel()
            getPaymentSubLabel.frame = CGRect(x: paymentSubLabel.frame.maxX + x, y: y2, width: ((paymentView.frame.width / 2) - (2 * x)), height: (2 * y))
            getPaymentSubLabel.text = "250 AED"
            getPaymentSubLabel.textAlignment = .right
            getPaymentSubLabel.textColor = UIColor.black
            getPaymentSubLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
            getPaymentSubLabel.font = getPaymentSubLabel.font.withSize(1.5 * x)
            paymentView.addSubview(getPaymentSubLabel)
            
            let lineLabel = UILabel()
            lineLabel.frame = CGRect(x: 0, y: paymentSubLabel.frame.maxY, width: paymentView.frame.width, height: 1)
            lineLabel.backgroundColor = UIColor.lightGray
            paymentView.addSubview(lineLabel)
            
            y2 = paymentSubLabel.frame.maxY + y
        }
        
        let totalLabel = UILabel()
        totalLabel.frame = CGRect(x: x, y: y2 + y, width: (paymentView.frame.width / 2) - x, height: (2 * y))
        totalLabel.text = "TOTAL"
        totalLabel.textAlignment = .left
        totalLabel.textColor = UIColor.black
        totalLabel.font = UIFont(name: "Avenir-Black", size: (1.5 * x))
        totalLabel.font = totalLabel.font.withSize(1.5 * x)
        paymentView.addSubview(totalLabel)
        
        let getTotalLabel = UILabel()
        getTotalLabel.frame = CGRect(x: totalLabel.frame.maxX + x, y: y2 + y, width: ((paymentView.frame.width / 2) - (2 * x)), height: (2 * y))
        getTotalLabel.text = "1649 AED"
        getTotalLabel.textAlignment = .right
        getTotalLabel.textColor = UIColor.black
        getTotalLabel.font = UIFont(name: "Avenir-Black", size: (1.5 * x))
        getTotalLabel.font = getTotalLabel.font.withSize(1.5 * x)
        paymentView.addSubview(getTotalLabel)
        
        let relatedProductsView = UIView()
        relatedProductsView.frame = CGRect(x: x, y: paymentView.frame.maxY + y, width: selfScreenContents.frame.width - (2 * x), height: (26 * y))
        relatedProductsView.backgroundColor = UIColor.white
        selfScreenContents.addSubview(relatedProductsView)
        
        let relatedProductsLabel = UILabel()
        relatedProductsLabel.frame = CGRect(x: x, y: y, width: relatedProductsView.frame.width, height: (2 * y))
        relatedProductsLabel.text = "Related Products"
        relatedProductsLabel.textAlignment = .left
        relatedProductsLabel.textColor = UIColor.black
        relatedProductsLabel.font = UIFont(name: "Avenir-Black", size: (1.5 * x))
        relatedProductsLabel.font = relatedProductsLabel.font.withSize(1.5 * x)
        relatedProductsView.addSubview(relatedProductsLabel)
        
        let relatedUnderLineLabel = UILabel()
        relatedUnderLineLabel.frame = CGRect(x: 0, y: relatedProductsLabel.frame.maxY, width: relatedProductsView.frame.width, height: 1)
        relatedUnderLineLabel.backgroundColor = UIColor.lightGray
        relatedProductsView.addSubview(relatedUnderLineLabel)
        
        let productsScrollView = UIScrollView()
        productsScrollView.frame = CGRect(x: 0, y: relatedUnderLineLabel.frame.maxY + y, width: relatedProductsView.frame.width, height: (22 * y))
        productsScrollView.backgroundColor = UIColor.clear
        relatedProductsView.addSubview(productsScrollView)
        
        var x2:CGFloat = x
        
        for i in 0..<5
        {
            let productImageView = UIImageView()
            productImageView.frame = CGRect(x: x2, y: 0, width: (10 * x), height: (13 * y))
            productImageView.image = UIImage(named: "Checkout _points to cash")
            productsScrollView.addSubview(productImageView)
            
            let productNameLabel = UILabel()
            productNameLabel.frame = CGRect(x: x2, y: productImageView.frame.maxY, width: (10 * x), height: (2 * y))
            productNameLabel.text = "xxx"
            productNameLabel.textAlignment = .center
            productNameLabel.textColor = UIColor.black
            productNameLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
            productNameLabel.font = productNameLabel.font.withSize(1.5 * x)
            productsScrollView.addSubview(productNameLabel)
            
            let productPriceLabel = UILabel()
            productPriceLabel.frame = CGRect(x: x2, y: productNameLabel.frame.maxY, width: (10 * x), height: (2 * y))
            productPriceLabel.text = "25\(i) AED"
            productPriceLabel.textAlignment = .center
            productPriceLabel.textColor = UIColor.black
            productPriceLabel.font = UIFont(name: "Avenir-Regular", size: (1.5 * x))
            productPriceLabel.font = productPriceLabel.font.withSize(1.5 * x)
            productsScrollView.addSubview(productPriceLabel)
            
            let ratingImageView = UIImageView()
            ratingImageView.frame = CGRect(x: x2, y: productPriceLabel.frame.maxY, width: (10 * x), height: (2 * y))
            ratingImageView.image = UIImage(named: "\(i)")
            productsScrollView.addSubview(ratingImageView)
            
            let addToCartButton = UIButton()
            addToCartButton.frame = CGRect(x: x2, y: ratingImageView.frame.maxY, width: (10 * x), height: (3 * y))
            addToCartButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 0.85)
            addToCartButton.setTitle("Add To Cart", for: .normal)
            addToCartButton.setTitleColor(UIColor.white, for: .normal)
            productsScrollView.addSubview(addToCartButton)
            
            x2 = productImageView.frame.maxX + x
        }
        
        productsScrollView.contentSize.width = x2 + (2 * x)
        
        selfScreenContents.contentSize.height = relatedProductsView.frame.maxY + (2 * y)
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func redeemButtonAction(sender : UIButton)
    {
        let redeemScreen = RedeemViewController()
        self.navigationController?.pushViewController(redeemScreen, animated: true)
    }
    
    @objc func promosButtonAction(sender : UIButton)
    {
        let redeemScreen = OffersViewController()
        self.navigationController?.pushViewController(redeemScreen, animated: true)
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
