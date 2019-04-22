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

class LocationViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate,UISearchBarDelegate,LocateOnTheMap,GMSAutocompleteFetcherDelegate
{
  
    var x = CGFloat()
    var y = CGFloat()
    
    var screenTag = 1
    
    //SCREEN PARAMETERS
    let selfScreenNavigationBar = UIView()
    let selfScreenNavigationTitle = UILabel()
    let selfScreenContents = UIView()

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

    // rohith - 9-4-2019
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    var gmsFetcher: GMSAutocompleteFetcher!
    
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
        
        // rohith - 9-4-2019
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
    }
    
    // rohith - 9-4-2019
    
    @IBAction func searchWithAddress(_ sender: AnyObject)
    {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.present(searchController, animated:true, completion: nil)
    }
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction])
    {
        for prediction in predictions
        {
            
            if let prediction = prediction as GMSAutocompletePrediction!
            {
                self.resultsArray.append(prediction.attributedFullText.string)
            }
        }
        self.searchResultController.reloadDataWithArray(self.resultsArray)
        //   self.searchResultsTable.reloadDataWithArray(self.resultsArray)
        print(resultsArray)
    }
    
    func didFailAutocompleteWithError(_ error: Error)
    {
        
    }
    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String)
    {
        
        DispatchQueue.main.async { () -> Void in
            
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            
              let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
               self.mapView.camera = camera
            
            marker.title = "Address : \(title)"
            marker.map = self.mapView
            
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.resultsArray.removeAll()
        gmsFetcher?.sourceTextHasChanged(searchText)
        
    }
    func activityContents()
    {
        activeView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        activeView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        view.addSubview(activeView)
        
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
    
    func changeViewToArabicInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selfScreenNavigationTitle.text = "موقعك"
        
        selfScreenContents.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        addAddressButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        addAddressButton.setTitle("تأكيد الموقع", for: .normal)
        
        mapView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    func changeViewToEnglishInSelf()
    {
        selfScreenNavigationBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        selfScreenNavigationTitle.text = "LOCATION"
        
        selfScreenContents.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        addAddressButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        addAddressButton.setTitle("Confirm Location", for: .normal)
        
        mapView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    func locationContents()
    {
        let backgroundImageview = UIImageView()
        backgroundImageview.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        backgroundImageview.image = UIImage(named: "background")
        view.addSubview(backgroundImageview)
        
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
        selfScreenNavigationTitle.text = "LOCATION"
        selfScreenNavigationTitle.textColor = UIColor.white
        selfScreenNavigationTitle.textAlignment = .center
        selfScreenNavigationTitle.font = UIFont(name: "Avenir-Regular", size: 20)
        selfScreenNavigationTitle.font = selfScreenNavigationTitle.font.withSize(2 * x)
        selfScreenNavigationBar.addSubview(selfScreenNavigationTitle)
        
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus()
            {
            case .notDetermined, .restricted, .denied:
                print("No access")
                
                if let language = UserDefaults.standard.value(forKey: "language") as? String
                {
                    if language == "en"
                    {
                        let alertController = UIAlertController(title: "Alert", message: "Please go to Settings and allow location access", preferredStyle: .alert)
                        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                return
                            }
                            if UIApplication.shared.canOpenURL(settingsUrl)
                            {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                            }
                        }
                        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                        alertController.addAction(cancelAction)
                        alertController.addAction(settingsAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if language == "ar"
                    {
                        let alertController = UIAlertController(title: "تنبيه", message: "يرجى الانتقال إلى الإعدادات والسماح بالوصول إلى الموقع", preferredStyle: .alert)
                        let settingsAction = UIAlertAction(title: "الإعدادات", style: .default) { (_) -> Void in
                            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                return
                            }
                            if UIApplication.shared.canOpenURL(settingsUrl)
                            {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                            }
                        }
                        let cancelAction = UIAlertAction(title: "إلغاء", style: .default, handler: nil)
                        alertController.addAction(cancelAction)
                        alertController.addAction(settingsAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                else
                {
                    let alertController = UIAlertController(title: "Alert", message: "Please go to Settings and allow location access", preferredStyle: .alert)
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        if UIApplication.shared.canOpenURL(settingsUrl)
                        {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                        }
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    alertController.addAction(cancelAction)
                    alertController.addAction(settingsAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
            print("Location services are not enabled")
        }
        
        
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
        
        selfScreenContents.frame = CGRect(x: 0, y: selfScreenNavigationBar.frame.maxY, width: view.frame.width, height: view.frame.height - (selfScreenNavigationBar.frame.maxY))
        selfScreenContents.backgroundColor = UIColor.clear
        view.addSubview(selfScreenContents)
        
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: selfScreenContents.frame.height - (5 * y))
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        selfScreenContents.addSubview(mapView)
        
        addressLabel.frame = CGRect(x: x, y: y, width: view.frame.width - (2 * x), height: (7 * y))
        addressLabel.layer.borderWidth = 1
        addressLabel.layer.borderColor = UIColor.lightGray.cgColor
        addressLabel.backgroundColor = UIColor.white
        addressLabel.textColor = UIColor.black
        addressLabel.textAlignment = .center
        addressLabel.font = UIFont(name: "Avenir-Next", size: (2 * x))
        addressLabel.numberOfLines = 3
        mapView.addSubview(addressLabel)
        
        let searchButton = UIButton()
        searchButton.frame = CGRect(x: (x / 2), y: mapView.frame.height - (5.5 * y), width: (5 * x), height: (5 * x))
        searchButton.layer.cornerRadius = searchButton.frame.height / 2
        searchButton.layer.borderWidth = 0.5
        searchButton.layer.borderColor = UIColor.lightGray.cgColor
        searchButton.backgroundColor = UIColor.white
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        searchButton.addTarget(self, action: #selector(self.searchButtonAction(sender:)), for: .touchUpInside)
        mapView.addSubview(searchButton)
        
        addAddressButton.isEnabled = false
        addAddressButton.frame = CGRect(x: 0, y: mapView.frame.maxY, width: view.frame.width, height: (5 * y))
        addAddressButton.backgroundColor = UIColor(red: 0.0392, green: 0.2078, blue: 0.5922, alpha: 1.0)
        addAddressButton.setTitle("Confirm Location", for: .normal)
        addAddressButton.setTitleColor(UIColor.white, for: .normal)
        addAddressButton.addTarget(self, action: #selector(self.addAddressButtonAction(sender:)), for: .touchUpInside)
        selfScreenContents.addSubview(addAddressButton)
        
        markerImageView.frame = CGRect(x: ((view.frame.width - (6 * x)) / 2), y: ((view.frame.height - (5 * y)) / 2), width: (6 * x), height: (5 * y))
        markerImageView.image = UIImage(named: "marker")
        view.addSubview(markerImageView)
        
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
        
        activityContents()
    }
    
    @objc func otpBackButtonAction(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func searchButtonAction(sender : UIButton)
    {
        // Panneer... 
   
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
//        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
//            UInt(GMSPlaceField.placeID.rawValue))!
//        autocompleteController.placeFields = fields
                
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
 
        
        // rohith - 9-4-2019
       /*
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.present(searchController, animated:true, completion: nil)
        */
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

extension LocationViewController : GMSAutocompleteViewControllerDelegate
{
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace)
    {
        print("Place name: \(place.name)")
        print("Place ID: \(place.placeID)")
        print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error)
    {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
