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
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!

    let mapView = GMSMapView()
    let marker = GMSMarker()
    
    let markerImageView = UIImageView()

    override func viewDidLoad()
    {
        x = 10 / 375 * 100
        x = x * view.frame.width / 100
        
        y = 10 / 667 * 100
        y = y * view.frame.height / 100
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        locationContents()

        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        else
        {
            
        }
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways)
        {
            
            currentLocation = locationManager.location
            print("Current Loc:",currentLocation.coordinate)
        }
        
        let camera = GMSCameraPosition(target: currentLocation.coordinate, zoom: 15.0, bearing: 0, viewingAngle: 0)

        mapView.frame = CGRect(x: 0, y: locationNavigationBar.frame.maxY, width: view.frame.width, height: view.frame.height - (6.4 * y))
        mapView.camera = camera
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        view.addSubview(mapView)
        
        markerImageView.frame = CGRect(x: 0, y: 0, width: (6 * x), height: (5 * y))
        markerImageView.image = UIImage(named: "marker")
        view.addSubview(markerImageView)
        
        marker.position = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        marker.iconView = markerImageView
//        marker.map = mapView
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func currentLocationButtonAction(sender : UIButton)
    {
        
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
        
        let camera = GMSCameraPosition(target:location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        mapView.camera = camera
        
        marker.position = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        marker.iconView = markerImageView
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.75)
        marker.map = mapView
        
        locationManager.stopUpdatingLocation()

    }
    
//    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//        marker.position = CLLocationCoordinate2D(latitude: position.target.latitude, longitude: position.target.longitude)
//        marker.map = mapView
//
//        print("LAT OF - \(position.target.latitude), LONG OF - \(position.target.longitude)")
//    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition)
    {
        marker.position = CLLocationCoordinate2D(latitude: position.target.latitude, longitude: position.target.longitude)
        print("LAT OF - \(position.target.latitude), LONG OF - \(position.target.longitude)")
        reverseGeocodeCoordinate(position.target)
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D)
    {
        
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
            // 3
            print(lines.joined(separator: "\n"))
            
            //  self.addressLabel.text = lines.joined(separator: "\n")
            
            // 4
            UIView.animate(withDuration: 0.25)
            {
                self.view.layoutIfNeeded()
            }
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
