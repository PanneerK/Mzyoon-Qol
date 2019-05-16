//
//  TelrGateWayViewController.swift
//  Mzyoon
//
//  Created by QOLSoft on 24/01/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import WebKit

class TelrGateWayViewController: UIViewController,UIWebViewDelegate
{
    var window: UIWindow?
    
     var x = CGFloat()
     var y = CGFloat()
 
    
    // Parameters:
    var KEY:String!
    var STOREID:String!
 // var EMAIL:String!

    var dictionaryData = NSDictionary()
    var TelrWebView = UIWebView()
   
    var TelrStartUrl : String!
    var TelrCloseUrl : String!
    var TelrAbortUrl : String!
    var TelrTransCode : String!
    
    var TransRef:String!
    var TransTraceNum:String!
    
    let activeView = UIView()
    let activityIndicator = UIActivityIndicatorView()
    
    let activity = ActivityView()
    
    var applicationDelegate = AppDelegate()

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
         x = 10 / 375 * 100
         x = x * view.frame.width / 100
         
         y = 10 / 667 * 100
         y = y * view.frame.height / 100
      
        view.backgroundColor = UIColor.white
        
      
      //   KEY = "XZCQ~9wRvD^prrJx" //"0d644cd3MsvS6r49sBDqdd29"  // "XZCQ~9wRvD^prrJx"
     //    STOREID = "21552"
      
        //Your code goes here
            print("Telr Start URL:",TelrStartUrl)
            print("Telr Close URL:",TelrCloseUrl)
            print("Telr Abort URL:",TelrAbortUrl)
            print("Telr Code:",TelrTransCode)
        
     //   TelrWebView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        TelrWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.addSubview(TelrWebView)
        
        /*activeView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        activeView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(activeView)
        
        activityIndicator.frame = CGRect(x: ((activeView.frame.width - (5 * x)) / 2), y: ((activeView.frame.height - (5 * y)) / 2), width: (5 * x), height: (5 * y))
        activityIndicator.color = UIColor.white
        activityIndicator.style = .whiteLarge
        activityIndicator.startAnimating()
        activeView.addSubview(activityIndicator)*/
        
        activity.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(activity)
      
        TelrWebView.delegate = self
        
       
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.loadWebView()
    }
    func loadWebView()
    {
        DispatchQueue.main.async (execute: { () -> Void in
            self.activityIndicator.startAnimating()
           // self.activityIndicator.hidesWhenStopped = true
            self.TelrWebView.loadRequest(NSURLRequest(url: NSURL(string: self.TelrStartUrl)! as URL) as URLRequest)
             })
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        print("webViewDidStartLoad")
        
    
    }
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        
        print("webViewDidFinishLoad")
        
        activeView.removeFromSuperview()
        activityIndicator.stopAnimating()
        activity.stopActivity()
        
   }
 
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool
    {
        print("request: \(request.description)")
        
        if request.description == TelrCloseUrl
        {
            //do close window magic here!!
            print("url matches...")
            
            window = UIWindow(frame: UIScreen.main.bounds)
            let ResponseScreen = TelrResponseViewController()
            let navigationScreen = UINavigationController(rootViewController: ResponseScreen)
            navigationScreen.isNavigationBarHidden = true
            window?.rootViewController = navigationScreen
            window?.makeKeyAndVisible()
            
            return false
        }
        return true
    }

}
