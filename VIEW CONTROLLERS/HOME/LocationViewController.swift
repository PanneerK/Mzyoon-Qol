//
//  LocationViewController.swift
//  Mzyoon
//
//  Created by QOL on 19/11/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import GoogleMaps
import GooglePlaces

class LocationViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate
{
    var x = CGFloat()
    var y = CGFloat()
    
    var screenTag = 1
    var selectedCoordinate = CLLocationCoordinate2D()
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    let mapView = GMSMapView()
    let marker = GMSMarker()
    
    let markerImageView = UIImageView()
    
    let addressLabel = UILabel()
    let addAddressButton = UIButton()
    
    var activeView = UIView()
    var activityView = UIActivityIndicatorView()
    
    var getTraggedPosition = CLLocationCoordinate2D()
    
    var currentCoordinate = CLLocationCoordinate2D()
    
    var applicationDelegate = AppDelegate()

    
    override func viewDidLoad()
    {
        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
        
        locationManager.requestAlwaysAuthorization()
        
        locationContents()
        
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func activityContents()
    {
        activeView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        activeView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        mapView.addSubview(activeView)
        
        activityView.frame = CGRect(x: ((activeView.frame.width - 50) / 2), y: ((activeView.frame.height - 50) / 2), width: 50, height: 50)
        activityView.style = .whiteLarge
        activityView.color = UIColor.white
        activityView.startAnimating()
        activeView.addSubview(activityView)
    }
    
    func stopActivity()
    {
        activeView.removeFromSuperview()
        activityView.stopAnimating()
    }
    
    func locationContents()
    {
        let backgroundImageview = UIImageView()
        backgroundImageview.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        backgroundImageview.image = UIImage(named: "background")
        view.addSubview(backgroundImageview)
        
        let locationNavigationBar = UIView()
        locationNavigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (6.4 * y))
        locationNavigationBar.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        view.addSubview(locationNavigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: x, y: (3 * y), width: (3 * x), height: (2.5 * y))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.tag = 4
        backButton.addTarget(self, action: #selector(self.otpBackButtonAction(sender:)), for: .touchUpInside)
        locationNavigationBar.addSubview(backButton)
        
        let navigationTitle = UILabel()
        navigationTitle.frame = CGRect(x: 0, y: (2.5 * y), width: locationNavigationBar.frame.width, height: (3 * y))
        navigationTitle.text = "LOCATION"
        navigationTitle.textColor = UIColor.white
        navigationTitle.textAlignment = .center
        navigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        locationNavigationBar.addSubview(navigationTitle)
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        else
        {
            
        }
        
        #if targetEnvironment(simulator)
        // your simulator code
        print("APP IS RUNNING ON SIMULATOR")
        #else
        // your real device code
        print("APP IS RUNNING ON DEVICE")
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways)
        {
            
            currentLocation = locationManager.location
            print("Current Loc:",currentLocation.coordinate)
        }
        
        #endif
        
        mapView.frame = CGRect(x: 0, y: locationNavigationBar.frame.maxY, width: view.frame.width, height: view.frame.height - (11.4 * y))
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        view.addSubview(mapView)
        
        addressLabel.frame = CGRect(x: x, y: y, width: view.frame.width - (2 * x), height: (7 * y))
        addressLabel.layer.borderWidth = 1
        addressLabel.layer.borderColor = UIColor.lightGray.cgColor
        addressLabel.backgroundColor = UIColor.white
        addressLabel.textColor = UIColor.black
        addressLabel.textAlignment = .center
        addressLabel.font = UIFont(name: "Avenir-Next", size: (2 * x))
        addressLabel.numberOfLines = 3
        mapView.addSubview(addressLabel)
        
        addAddressButton.isEnabled = false
        addAddressButton.frame = CGRect(x: 0, y: mapView.frame.maxY, width: view.frame.width, height: (5 * y))
        addAddressButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        addAddressButton.setTitle("Confirm Location", for: .normal)
        addAddressButton.setTitleColor(UIColor.white, for: .normal)
        addAddressButton.addTarget(self, action: #selector(self.addAddressButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(addAddressButton)
        
        markerImageView.frame = CGRect(x: ((view.frame.width - (6 * x)) / 2), y: ((view.frame.height - (5 * y)) / 2), width: (6 * x), height: (5 * y))
        markerImageView.image = UIImage(named: "marker")
        view.addSubview(markerImageView)
        
        activityContents()
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func addAddressButtonAction(sender : UIButton)
    {
        let address2Screen = Address2ViewController()
        
//        address2Screen.screenTag = 2
//        address2Screen.firstNameEnglishTextField.text = Variables.sharedManager.firstName
//        address2Screen.secondNameEnglishTextField.text = Variables.sharedManager.secondName
//        address2Screen.locationTypeTextField.text = Variables.sharedManager.locationType
//        address2Screen.areaButton.setTitle("\(Variables.sharedManager.areaName)", for: .normal)
//        address2Screen.floorTextField.text = Variables.sharedManager.floor
//        address2Screen.landMarkTextField.text = Variables.sharedManager.landmark
//        address2Screen.mobileTextField.text = Variables.sharedManager.mobileNumber
//        address2Screen.mobileCountryCodeLabel.text = Variables.sharedManager.countryCode
//        address2Screen.shippingNotesTextField.text = Variables.sharedManager.shippingNotes
//        address2Screen.checkDefault = Variables.sharedManager.checkDefaultId
//        address2Screen.addressString = [addressLabel.text!]
//        address2Screen.editStateId = Variables.sharedManager.stateId
//        address2Screen.editCountryId = Variables.sharedManager.countryCodeId
//        address2Screen.editAreaId = Variables.sharedManager.areaId
//        address2Screen.getLocation = getTraggedPosition
        
        if screenTag == 1
        {
            address2Screen.addressString = [addressLabel.text!]
            address2Screen.getLocation = getTraggedPosition
            address2Screen.screenTag = 2
            address2Screen.checkScreen = 2
        }
        else
        {
            address2Screen.addressString = [addressLabel.text!]
            address2Screen.getLocation = getTraggedPosition
            address2Screen.screenTag = 1
            address2Screen.checkScreen = 1
            address2Screen.checkTag = 1
        }
        
        self.navigationController?.pushViewController(address2Screen, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        print("LOCATIONS", locations[0].coordinate.latitude, locations[0].coordinate.longitude)
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 150, width: view.frame.width, height: 50)
        label.text = "\(locValue.latitude) \(locValue.longitude)"
        label.textColor = UIColor.black
        label.textAlignment = .center
        //        mapView.addSubview(label)
        
        guard let location = locations.first else
        {
            return
        }
        
        //  let camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), zoom: 16.0, bearing: 0.5, viewingAngle: 1.0)
        
        if screenTag != 1
        {
            if selectedCoordinate.latitude == 0.0 || selectedCoordinate.longitude == 0.0
            {
                stopActivity()
                
                let camera = GMSCameraPosition(target:location.coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
                mapView.camera = camera
                
                currentCoordinate = location.coordinate
            }
            else
            {
                let camera = GMSCameraPosition(target: selectedCoordinate, zoom: 16.0, bearing: 0, viewingAngle: 0)
                mapView.camera = camera
                
                currentCoordinate = selectedCoordinate
            }
        }
        else
        {
            let camera = GMSCameraPosition(target:location.coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
            mapView.camera = camera
            
            currentCoordinate = location.coordinate
        }
        
        marker.position = CLLocationCoordinate2D(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude)
        marker.iconView = markerImageView
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        marker.map = mapView
        
        locationManager.stopUpdatingLocation()
        
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        marker.position = CLLocationCoordinate2D(latitude: position.target.latitude, longitude: position.target.longitude)
        
        print("LAT OF - \(position.target.latitude), LONG OF - \(position.target.longitude)")
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition)
    {
        //        marker.position = CLLocationCoordinate2D(latitude: position.target.latitude, longitude: position.target.longitude)
        print("LAT OF - \(position.target.latitude), LONG OF - \(position.target.longitude)")
        reverseGeocodeCoordinate(position.target)
        getTraggedPosition = CLLocationCoordinate2D(latitude: position.target.latitude, longitude: position.target.longitude)
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D)
    {
        
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            
            print("RESPONSE IN LOCATION ", response)
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
            // 3
            print("GET CURRENT ADDRESS", lines.joined(separator: "\n"))
            
            self.addressLabel.text = lines.joined(separator: "\n")
            
            //  self.addressLabel.text = lines.joined(separator: "\n")
            
            // 4
            UIView.animate(withDuration: 0.25)
            {
                self.view.layoutIfNeeded()
            }
            
            self.stopActivity()
            self.addAddressButton.isEnabled = true
        }
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
