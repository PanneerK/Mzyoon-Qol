//
//  TestingViewController.swift
//  Mzyoon
//
//  Created by QOL on 20/03/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Photos

class TestingViewController: UIViewController, UISearchBarDelegate,LocateOnTheMap,GMSAutocompleteFetcherDelegate
{
 
    // Panneer..
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
     // rohith - 8-4-2019
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    var gmsFetcher: GMSAutocompleteFetcher!
    
    var loadingCount = 0
    let customLoader = UIImageView()
    var loadingTimer = Timer()
    let loadingText = UILabel()

    
    let mapView = GMSMapView()

    override func viewDidLoad()
    {
        view.backgroundColor = UIColor.cyan
        
        /*resultsViewController = GMSAutocompleteResultsViewController()
//        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 65.0, width: 350.0, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        makeButton()*/
        
        
        super.viewDidLoad()

        /*// Do any additional setup after loading the view.
        
         // rohith - 8-4-2019
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
        
        mapView.frame = CGRect(x: 0, y: 200, width: view.frame.width, height: view.frame.height - (210))
//        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
//        view.addSubview(mapView)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 13.0067, longitude: 80.2206)
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.75)
        marker.snippet = "PANNEER"
        marker.title = "MY NAME"
        marker.tracksInfoWindowChanges = true
        marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
        marker.map = mapView
        
        mapView.selectedMarker = marker
        
        let imagesArray = [UIImage(named: "loader1"), UIImage(named: "loader2"), UIImage(named: "loader3"), UIImage(named: "loader4"), UIImage(named: "loader5"), UIImage(named: "loader6"), UIImage(named: "loader7"), UIImage(named: "loader8")]
        
        customLoader.frame = CGRect(x: 150, y: 500, width: 50, height: 50)
//        customLoader.backgroundColor = UIColor.gray
        customLoader.layer.cornerRadius = customLoader.frame.height / 2
        customLoader.animationImages = imagesArray as! [UIImage]
        customLoader.animationDuration = 5.0
        customLoader.startAnimating()
        view.addSubview(customLoader)
        
        let imagesArray1 = [UIImage(named: "loading1"), UIImage(named: "loading2"), UIImage(named: "loading3")]
        
        let customLoading = UIImageView()
        customLoading.frame = CGRect(x: 150, y: customLoader.frame.maxY, width: 50, height: 30)
        //        customLoading.backgroundColor = UIColor.gray
        customLoading.layer.cornerRadius = customLoader.frame.height / 2
        customLoading.animationImages = imagesArray1 as! [UIImage]
        customLoading.animationDuration = 2.0
        customLoading.startAnimating()
//        view.addSubview(customLoading)
        
        forLoadingText()
        
        loadingCount = 1
        
        loadingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCall), userInfo: nil, repeats: true)*/
        
        let activity = ActivityView()
        activity.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(activity)
    }
    
    func forLoadingText()
    {
        loadingText.frame = CGRect(x: 100, y: customLoader.frame.maxY, width: 200, height: 50)
        loadingText.text = "Loading."
        loadingText.textAlignment = .center
        loadingText.textColor = UIColor.blue
        view.addSubview(loadingText)
    }
    
    @objc func timerCall()
    {
        if loadingCount == 0
        {
            forLoadingText()
            loadingCount = 1
        }
        else if loadingCount == 1
        {
            self.loadingText.text = "Loading.."
            loadingCount = 2
        }
        else
        {
            self.loadingText.text = "Loading..."
            loadingCount = 0
        }
    }
    
    
    // Add a button to the view.
    func makeButton()
    {
        let btnLaunchAc = UIButton(frame: CGRect(x: 5, y: 150, width: 300, height: 35))
        btnLaunchAc.backgroundColor = .blue
        btnLaunchAc.setTitle("Loading...", for: .normal)
        btnLaunchAc.addTarget(self, action: #selector(autocompleteClicked), for: .touchUpInside)
        self.view.addSubview(btnLaunchAc)
    }
    
    // Present the Autocomplete view controller when the button is pressed.
    @objc func autocompleteClicked(_ sender: UIButton)
    {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.

        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    // rohith - 8-4-2019
    
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
            
          //  let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
         //   self.googleMapsView.camera = camera
            
            marker.title = "Address : \(title)"
         //   marker.map = self.googleMapsView
            
        }
    }
    
  
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.resultsArray.removeAll()
        gmsFetcher?.sourceTextHasChanged(searchText)
        
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

extension TestingViewController: GMSAutocompleteViewControllerDelegate
{
    
    // Handle the user's selection.
    public func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace)
    {
        print("Place name: \(place.name)")
        print("Place ID: \(place.placeID)")
        print("Place attributions: \(place.attributions!)")
        searchController?.isActive = false

        dismiss(animated: true, completion: nil)
    }
    
    public func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error)
    {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    public func wasCancelled(_ viewController: GMSAutocompleteViewController)
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
